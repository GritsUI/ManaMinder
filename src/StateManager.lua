local AceOO = AceLibrary("AceOO-2.0")
local StateManager = AceOO.Class()

function StateManager.prototype:init()
    StateManager.super.prototype.init(self)

    -- Tracks state of all consumable counts in bags and consumable/spell cooldowns. Only tracks those which are
    -- present in db.profile.consumables/items/spells, currently enabled and with a bag count greater than 0.
    self.state = {

        -- Map of tracked objects. Table index is equal to "key" in db consumables/items/spells config. Contains
        -- objects with properties: key, priority, count, cooldown, cooldownTotal, texture
        tracked = {}
    }
end

function StateManager.prototype:Update()
    local newTracked = {}
    self:UpdateStateForConsumables(newTracked)

    self.state = {
        tracked = newTracked
    }
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
                if consumableConfig and consumableConfig.enabled then
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
                            deficitRemaining = math.max(0, consumableData.maxMana - deficit)
                        }
                    end
                end
            end
        end
    )
end

function StateManager.prototype:GetConsumableConfigIfTracked(itemId)
    for index, consumableConfig in pairs(ManaMinder.db.profile.consumables) do
        local consumableData = ManaMinder.consumables[consumableConfig.key]
        if consumableData.itemId == itemId then
            return consumableConfig, consumableData
        end
    end
    return nil
end

function StateManager.prototype:GetBarData()
    local bars = {}

    for key, consumable in self.state.tracked do
       if consumable.count > 0 then
           table.insert(bars, consumable)
       end
    end
    table.sort(bars, function(a, b) return a.priority < b.priority end)

    return bars
end

ManaMinder.StateManager = StateManager
