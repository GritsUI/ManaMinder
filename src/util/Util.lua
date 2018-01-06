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

function ManaMinder:GetCooldownRemaining(start, duration, isSpell)
  local now = GetTime()
  local finish = start + duration
  local remaining = now < finish and finish - now or 0

  if isSpell and remaining < 1.5 then
    return 0
  end
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
    if name == spellName then
      local start, duration = GetSpellCooldown(i, "BOOKTYPE_SPELL")
      return start, duration, i
    end
  end
  return 0, nil
end

function ManaMinder:SecondsToRelativeTime(seconds)
  local m = math.floor((seconds + 0.5) / 60)
  local s = math.floor((seconds - m * 60) + 0.5)
  local rel = ""

  if m > 0 then
    rel = m .. ":"
  end
  if m > 0 and s < 10 then
    rel = rel .. "0"
  end
  rel = rel .. s

  return rel
end

function ManaMinder:Lerp(a, b, t)
  return (1 - t) * a + t * b
end

function ManaMinder:EaseInOutQuad(a, b, t, d)
  local c = b - a
  t = (t * d) / (d / 2)
  if t < 1 then
    return c/2*t*t + a
  end

  t = t - 1
  return -c/2 * (t*(t-2) - 1) + a
end

function ManaMinder:RoundTo(num, decimalPlaces)
  return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", num))
end

function ManaMinder:ShowColorPicker(r, g, b, a, hasOpacity, callback)
  ColorPickerFrame.func = callback
  ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")

  ColorPickerFrame.hasOpacity = hasOpacity
  if hasOpacity then
    ColorPickerFrame.opacityFunc = ColorPickerFrame.func
    ColorPickerFrame.opacity = 1 - a
  end

  ColorPickerFrame:Hide() -- Need to run the OnShow handler.
  ColorPickerFrame:Show()
  ColorPickerFrame:SetColorRGB(r,g,b)
end

function ManaMinder:Splice(tbl, first, length)
  local spliced = {}

  for i = 1, table.getn(tbl), 1 do
    if i < first or i >= first + length then
      table.insert(spliced, tbl[i])
    end
  end

  return spliced
end

function ManaMinder:PlaySound(key)
  local data = ManaMinder.sounds[key]
  if data.type == "FILE" then
    PlaySoundFile(data.path)
  else
    PlaySound(data.path)
  end
end

function ManaMinder:SystemMessage(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cFF2150C2ManaMinder|cFFFFFFFF: " .. msg)
end