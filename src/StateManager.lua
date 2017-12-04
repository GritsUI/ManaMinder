local AceOO = AceLibrary("AceOO-2.0")
local StateManager = AceOO.Class()

function StateManager.prototype:init()
    StateManager.super.prototype.init(self)

    -- Tracks state of all consumable counts in bags and consumable/spell cooldowns. Only tracks those which are
    -- present in db.profile.consumables/items/spells, currently enabled and with a bag count greater than 0.
    self.state = {

        -- List of tracked objects. Table index is equal to "priority" in db consumables/items/spells config. Contains
        -- objects with properties: count, cooldown, cooldownTotal, texture
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
    ManaMinder:ForEachContainerSlot(
        function(bag, slot)
            local texture, itemCount = GetContainerItemInfo(bag, slot)
            if itemCount then
                local link = GetContainerItemLink(bag, slot)
                local itemId = ManaMinder:GetItemIdFromLink(link)
                local consumableConfig, consumableData = self:GetConsumableConfigIfTracked(itemId)
                if consumableConfig and consumableConfig.enabled then
                    if state[consumableConfig.priority] then
                        state[consumableConfig.priority].count = state[consumableConfig.priority].count + itemCount
                    else
                        state[consumableConfig.priority] = {
                            count = itemCount,
                            cooldown = ManaMinder:GetContainerItemCooldownRemaining(bag, slot),
                            cooldownTotal = consumableData.cooldown,
                            texture = texture
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

end

ManaMinder.StateManager = StateManager
