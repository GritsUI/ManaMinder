local AceOO = AceLibrary("AceOO-2.0")
local StateManager = AceOO.Class()

function StateManager.prototype:init()
    StateManager.super.prototype.init(self)

    -- Tracks state of all consumable counts in bags and consumable/spell cooldowns. Only tracks those which are
    -- present in db.profile.consumables/items/spells, currently enabled and with a bag count greater than 0.
    -- Table index is equal to "key" in db consumables/items/spells config. Contains
    -- objects with properties: key, priority, count, cooldown, cooldownTotal, texture, type
    self.state = {}
end

function StateManager.prototype:Update()
    local newState = {}
    self:UpdateStateForConsumables(newState)
    self:UpdateStateForSpells(newState)
    self.state = newState
end

function StateManager.prototype:UpdateStateForConsumables(state)
    local mana = UnitMana("player")
    local manaMax = UnitManaMax("player")
    local deficit = manaMax - mana

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
                        state[consumableConfig.key] = {
                            key = consumableConfig.key,
                            priority = consumableConfig.priority,
                            count = itemCount,
                            cooldown = ManaMinder:GetContainerItemCooldownRemaining(bag, slot),
                            cooldownTotal = consumableData.cooldown,
                            texture = texture,
                            deficitRemaining = math.max(0, consumableData.maxMana - deficit),
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
    local mana = UnitMana("player")
    local manaMax = UnitManaMax("player")
    local deficit = manaMax - mana

    for index, spellConfig in pairs(ManaMinder.db.profile.consumables) do
        if spellConfig.type == "SPELL" then
            local spellData = ManaMinder.spells[spellConfig.key]
            local cooldown, spellId = ManaMinder:GetCooldownForSpellName(spellData.name)
            if spellId ~= nil then
                state[spellConfig.key] = {
                    key = spellConfig.key,
                    priority = spellConfig.priority,
                    cooldown = cooldown,
                    cooldownTotal = spellData.cooldown,
                    texture = spellData.iconTexture,
                    deficitRemaining = math.max(0, spellData.maxMana - deficit),
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
    table.sort(bars, function(a, b) return a.priority < b.priority end)

    return bars
end

ManaMinder.StateManager = StateManager
