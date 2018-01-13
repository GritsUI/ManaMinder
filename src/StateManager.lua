local AceOO = AceLibrary("AceOO-2.0")
local StateManager = AceOO.Class()
local db = ManaMinder.db

function StateManager.prototype:init()
  StateManager.super.prototype.init(self)

  -- Tracks state of all consumable counts in bags and consumable/spell cooldowns. Only tracks those which are
  -- present in db.char.consumables/items/spells, currently enabled and with a bag count greater than 0.
  -- Table index is equal to "key" in db consumables/items/spells config.
  -- All objects contain properties: key, priority, cooldown, cooldownStart, texture, type, requiredDeficit
  -- "ITEM" objects additionally contain: count, bag, slot
  -- "SPELL" objects additionally contain: spellId
  -- "EQUIPPED" objects additionally contain: slot
  self.state = {}
end

function StateManager.prototype:Update()
  local newState = {}
  self:UpdateStateForConsumables(newState)
  self:UpdateStateForSpells(newState)
  self:UpdateStateForEquippedItems(newState)
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
              group = consumableData.group,
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
  for _, consumableConfig in pairs(ManaMinder.db.char.consumables) do
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
  for _, spellConfig in pairs(ManaMinder.db.char.consumables) do
    if spellConfig.type == "SPELL" then
      local spellData = ManaMinder.spells[spellConfig.key]
      local cooldownStart, cooldown, spellId = ManaMinder:GetCooldownForSpellName(spellData.name)
      if spellId ~= nil then
        state[spellConfig.key] = {
          key = spellConfig.key,
          group = spellData.group,
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

function StateManager.prototype:UpdateStateForEquippedItems(state)
  local equipped = {}

  for _, itemConfig in pairs(ManaMinder.db.char.consumables) do
    if itemConfig.type == "EQUIPPED" then
      local itemData = ManaMinder.items[itemConfig.key]
      for _, slot in itemData.slots do
        local slotId = GetInventorySlotInfo(slot)
        if not equipped[slot] then
          equipped[slot] = ManaMinder:GetItemIdFromLink(GetInventoryItemLink("player", slotId))
        end

        if equipped[slot] == itemData.itemId then
          local start, duration = GetInventoryItemCooldown("player", slotId)
          state[itemConfig.key] = {
            key = itemConfig.key,
            group = itemData.group,
            priority = itemConfig.priority,
            cooldown = duration,
            cooldownStart = start,
            texture = itemData.iconTexture,
            requiredDeficit = itemData.requiredDeficit,
            type = "EQUIPPED",
            slot = slotId
          }
        end
      end
    end
  end
end

function StateManager.prototype:GetBarData()
  local bars = {}

  for _, consumable in self.state do
    if consumable.type ~= "ITEM" or consumable.count > 0 then
      table.insert(bars, consumable)
    end
  end

  table.sort(bars, function(barA, barB) return barA.priority < barB.priority end)

  if not db.char.showAllPotions then
    bars = self:FilterGroup(bars, "POTION")
  end

  if not db.char.showAllRunes then
    bars = self:FilterGroup(bars, "RUNE")
  end

  if not db.char.showAllGems then
    bars = self:FilterGroup(bars, "GEM")
  end

  return bars
end

function StateManager.prototype:FilterGroup(bars, group)
  local filtered = {}
  local groupFound = false

  for _, bar in bars do
    if bar.group == group then
      if not groupFound then
        table.insert(filtered, bar)
        groupFound = true
      end
    else
      table.insert(filtered, bar)
    end
  end

  return filtered
end

ManaMinder.stateManager = StateManager:new()
