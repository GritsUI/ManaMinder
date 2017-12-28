local AceOO = AceLibrary("AceOO-2.0")
local StateManager = AceOO.Class()

function StateManager.prototype:init()
    StateManager.super.prototype.init(self)

    -- Tracks state of all consumable counts in bags and consumable/spell cooldowns. Only tracks those which are
    -- present in db.profile.consumables/items/spells, currently enabled and with a bag count greater than 0.
    -- Table index is equal to "key" in db consumables/items/spells config.
    -- All objects contain properties: key, priority, cooldown, cooldownStart, texture, type, requiredDeficit
    -- "ITEM" objects additionally contain: count, bag, slot
    -- "SPELL" objects additionally contain: spellId
    self.state = {}
end

function StateManager.prototype:Update()
    local newState = {}
    self:UpdateStateForConsumables(newState)
    self:UpdateStateForSpells(newState)
    self.state = newState
end

function StateManager.prototype:UpdateStateForConsumables(state)
    ManaMinder:ForEachContainerSlot(
        function(bag, slot)
            local texture, itemCount = GetContainerItemInfo(bag, slot)
            if itemCount then
                local link = GetContainerItemLink(bag, slot)
                local itemId = ManaMinder:GetItemIdFromLink(link)
                local consumableConfig, consumableData = self:GetConsumableConfigIfTracked(itemId)

                if consumableConfig then
                    if state[consumableConfig.key] then
                        state[consumableConfig.key].count = state[consumableConfig.key].count + itemCount
                    else
                        local start, duration = GetContainerItemCooldown(bag, slot)

                        state[consumableConfig.key] = {
                            key = consumableConfig.key,
                            priority = consumableConfig.priority,
                            count = itemCount,
                            cooldown = duration,
                            cooldownStart = start,
                            texture = texture,
                            requiredDeficit = consumableData.requiredDeficit,
                            type = "ITEM",
                            bag = bag,
                            slot = slot
                        }
                    end
                end
            end
        end
    )
end

function StateManager.prototype:GetConsumableConfigIfTracked(itemId)
    for index, consumableConfig in pairs(ManaMinder.db.profile.consumables) do
        if consumableConfig.type == "ITEM" then
            local consumableData = ManaMinder.consumables[consumableConfig.key]
            if consumableData.itemId == itemId then
                return consumableConfig, consumableData
            end
        end
    end
    return nil
end

function StateManager.prototype:UpdateStateForSpells(state)
    for index, spellConfig in pairs(ManaMinder.db.profile.consumables) do
        if spellConfig.type == "SPELL" then
            local spellData = ManaMinder.spells[spellConfig.key]
            local cooldownStart, cooldown, spellId = ManaMinder:GetCooldownForSpellName(spellData.name)
            if spellId ~= nil then
                state[spellConfig.key] = {
                    key = spellConfig.key,
                    priority = spellConfig.priority,
                    cooldown = cooldown,
                    cooldownStart = cooldownStart,
                    texture = spellData.iconTexture,
                    requiredDeficit = spellData.requiredDeficit,
                    type = "SPELL",
                    spellId = spellId
                }
            end
        end
    end
end

function StateManager.prototype:GetBarData()
    local bars = {}

    for key, consumable in self.state do
       if consumable.type ~= "ITEM" or consumable.count > 0 then
           table.insert(bars, consumable)
       end
    end

    return bars
end

ManaMinder.stateManager = StateManager:new()
