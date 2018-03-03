local L = ManaMinder.L

function ManaMinder:ForEachContainerSlot(func)
  for bag = 4, 0, -1 do
    local size = GetContainerNumSlots(bag)
    if size > 0 then
      for slot=1, size, 1 do
        func(bag, slot)
      end
    end
  end
end

function ManaMinder:GetContainerItemCooldownRemaining(bagId, slot)
  local start, duration, enabled = GetContainerItemCooldown(bagId, slot)
  local finish = start + duration
  local now = GetTime()
  return enabled and now < finish and finish - now or 0
end

function ManaMinder:GetCooldownRemaining(start, duration)
  if duration == 1.5 then
    return 0
  end

  local now = GetTime()
  local finish = start + duration
  local remaining = now < finish and finish - now or 0

  return remaining
end

function ManaMinder:GetItemIdFromLink(itemLink)
  local id
  if (itemLink) then
    for id in string.gfind(itemLink, "|c%x+|Hitem:(%d+):%d+:%d+:%d+|h%[.-%]|h|r") do
      return tonumber(id)
    end
  end
end

function ManaMinder:GetConsumableNameForKey(key, type)
  if type == "SPELL" and ManaMinder.spells[key] then
    return ManaMinder.spells[key].name
  end

  if type == "ITEM" and ManaMinder.consumables[key] then
    return ManaMinder.consumables[key].name
  end

  if type == "EQUIPPED" and ManaMinder.items[key] then
    return ManaMinder.items[key].name
  end

  return nil
end

function ManaMinder:GetCooldownForSpellName(spellName)
  local _,_,offset,numSpells = GetSpellTabInfo(GetNumSpellTabs())
  local numAllSpell = offset + numSpells
  for i = numAllSpell, 1, -1 do
    local name = GetSpellName(i, "BOOKTYPE_SPELL")
    if name == L[spellName] then
      local start, duration = GetSpellCooldown(i, "BOOKTYPE_SPELL")
      return start, duration, i
    end
  end
  return 0, 0, nil
end

function ManaMinder:GetSpiritRegenRate()
  -- Taken from Lightshope calculations:
  -- https://github.com/LightsHope/server/blob/6dfb67c785206410a4d3030fd28f3d1ced462e5e/src/game/Objects/Player.cpp#L5124-L5157

  local spirit = UnitStat("player", 5)
  local _, class = UnitClass("player")

  if class == "DRUID" then
    return (spirit / 5) + 15
  elseif class == "HUNTER" then
    return (spirit / 5) + 15
  elseif class == "MAGE" then
    return (spirit / 4) + 12.5
  elseif class == "PALADIN" then
    return (spirit / 5) + 15
  elseif class == "PRIEST" then
    return (spirit / 4) + 12.5
  elseif class == "SHAMAN" then
    return (spirit / 5) + 17
  elseif class == "WARLOCK" then
    return (spirit / 5) + 15
  end

  return 0
end

function ManaMinder:UseContainerItem(bag, slot)
  UseContainerItem(bag, slot)
end

function ManaMinder:CastSpell(spellId, targeted)
  if targeted then
    local hasTarget = UnitName("target")
    TargetUnit("player");
    CastSpell(spellId, "BOOKTYPE_SPELL")

    if hasTarget then
      TargetUnit("playertarget");
    else
      ClearTarget()
    end
  else
    CastSpell(spellId, "BOOKTYPE_SPELL")
  end
end

function ManaMinder:UseInventoryItem(slot)
  UseInventoryItem(slot)
end
