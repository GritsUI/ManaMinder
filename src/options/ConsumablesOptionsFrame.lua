local AceOO = AceLibrary("AceOO-2.0")
local ConsumablesOptions = AceOO.Class()
local db = ManaMinder.db
local L = ManaMinder.L

local AVAILABLE_SECTION_NAME = "ManaMinder_Options_Consumables_Available_Section"
local TRACKED_SECTION_NAME = "ManaMinder_Options_Consumables_Tracked_Section"
local COOLDOWN_SECTION_NAME = "ManaMinder_Options_Consumables_Options_Section"
local POTIONS_CHECK_NAME = "ManaMinder_Options_Consumables_Potions_Check"
local RUNES_CHECK_NAME = "ManaMinder_Options_Consumables_Runes_Check"
local GEMS_CHECK_NAME = "ManaMinder_Options_Consumables_Gems_Check"
local AVAILABLE_SCROLL_FRAME = "ManaMinder_Options_Consumables_Available_Section_Scroll"
local TRACKED_SCROLL_FRAME = "ManaMinder_Options_Consumables_Tracked_Section_Scroll"

local MAX_SCROLL_ITEMS = 12
local SCROLL_ITEM_HEIGHT = 20

function ConsumablesOptions.prototype:init()
  ConsumablesOptions.super.prototype.init(self)
  self.availableConsumables = {}
  self.availableFrames = {}
  self.trackedFrames = {}
end

function ConsumablesOptions.prototype:OnInitialize()
  self.availableSectionFrame = getglobal(AVAILABLE_SECTION_NAME)
  self.trackedSectionFrame = getglobal(TRACKED_SECTION_NAME)
  self:RefreshAllFrames()
  self:ApplyTranslations()
  self:SetInitialValues()
end

function ConsumablesOptions.prototype:ApplyTranslations()
  getglobal(AVAILABLE_SECTION_NAME .. "Text"):SetText(L["Available"])
  getglobal(TRACKED_SECTION_NAME .. "Text"):SetText(L["Tracked"])
  getglobal(COOLDOWN_SECTION_NAME .. "Text"):SetText(L["Shared Cooldowns"])
end

function ConsumablesOptions.prototype:SetInitialValues()
  getglobal(POTIONS_CHECK_NAME):SetChecked(not db.char.showAllPotions)
  getglobal(RUNES_CHECK_NAME):SetChecked(not db.char.showAllRunes)
  getglobal(GEMS_CHECK_NAME):SetChecked(not db.char.showAllGems)
end

function ConsumablesOptions.prototype:RefreshAllFrames()
  self:RefreshAvailableFrames()
  self:RefreshTrackedFrames()
end

function ConsumablesOptions.prototype:RefreshAvailableFrames()
  self:RemoveCurrentAvailableFrames()
  self:AddAvailableFrames()
end

function ConsumablesOptions.prototype:RefreshTrackedFrames()
  self:RemoveCurrentTrackedFrames()
  self:AddTrackedFrames()
end

function ConsumablesOptions.prototype:RemoveCurrentAvailableFrames()
  for i = 1, table.getn(self.availableFrames), 1 do
    self.availableFrames[i]:Hide()
  end
end

function ConsumablesOptions.prototype:AddAvailableFrames()
  self.availableConsumables = self:GetAvailableConsumables()

  local consumableCount = table.getn(self.availableConsumables)
  local offset = FauxScrollFrame_GetOffset(getglobal(AVAILABLE_SCROLL_FRAME))
  if offset > 0 and offset + MAX_SCROLL_ITEMS > consumableCount then
    offset = offset - 1
    FauxScrollFrame_SetOffset(getglobal(AVAILABLE_SCROLL_FRAME), offset)
  end

  local itemCount = math.min(MAX_SCROLL_ITEMS, consumableCount)
  for index = 1, itemCount, 1 do
    self:AddAvailableFrame(index, self.availableConsumables[index + offset])
  end
end

function ConsumablesOptions.prototype:AddAvailableFrame(index, consumable)
  if not self.availableFrames[index] then
    self.availableFrames[index] = ManaMinder.AvailableConsumableFrame:new(self.availableSectionFrame, consumable)
  end

  local frame = self.availableFrames[index]
  frame.consumable = consumable
  frame.onClick = function() self:TrackConsumable(consumable) end
  frame:SetPosition(index)
  frame:UpdateText()
  frame:Show()
end

function ConsumablesOptions.prototype:GetAvailableConsumables()
  local consumables = {}

  for key, data in pairs(ManaMinder.consumables) do
    if not self:IsConsumableTracked(key) and self:IsConsumableAvailableForClass(data) then
      table.insert(consumables, data)
    end
  end

  for key, data in pairs(ManaMinder.items) do
    if not self:IsConsumableTracked(key) and self:IsConsumableAvailableForClass(data) then
      table.insert(consumables, data)
    end
  end

  for key, data in pairs(ManaMinder.spells) do
    if not self:IsConsumableTracked(key) and self:IsConsumableAvailableForClass(data) then
      table.insert(consumables, data)
    end
  end

  table.sort(consumables, function(consumableA, consumableB)
    return consumableA.name < consumableB.name
  end)

  return consumables
end

function ConsumablesOptions.prototype:OnAvailableScroll()
  self:UpdateAvailableScroll()
  self:RefreshAvailableFrames()
end

function ConsumablesOptions.prototype:UpdateAvailableScroll()
  local consumableCount = table.getn(self.availableConsumables)
  FauxScrollFrame_Update(getglobal(AVAILABLE_SCROLL_FRAME), consumableCount, MAX_SCROLL_ITEMS, SCROLL_ITEM_HEIGHT)

  for i = 1, table.getn(self.availableFrames), 1 do
    self.availableFrames[i]:SetScrollVisibility(consumableCount > MAX_SCROLL_ITEMS)
  end
end

function ConsumablesOptions.prototype:IsConsumableTracked(consumableKey)
  for _, consumable in pairs(db.char.consumables) do
    if consumable.key == consumableKey then
      return true
    end
  end
  return false
end

function ConsumablesOptions.prototype:IsConsumableAvailableForClass(consumable)
  local _, class = UnitClass("player")
  return not consumable.class or consumable.class == class
end

function ConsumablesOptions.prototype:RemoveCurrentTrackedFrames()
  for i = 1, table.getn(self.trackedFrames), 1 do
    self.trackedFrames[i]:Hide()
  end
end

function ConsumablesOptions.prototype:AddTrackedFrames()
  local consumableCount = table.getn(db.char.consumables)
  local offset = FauxScrollFrame_GetOffset(getglobal(TRACKED_SCROLL_FRAME))
  if offset > 0 and offset + MAX_SCROLL_ITEMS > consumableCount then
    offset = offset - 1
    FauxScrollFrame_SetOffset(getglobal(TRACKED_SCROLL_FRAME), offset)
  end

  local itemCount = math.min(MAX_SCROLL_ITEMS, consumableCount)
  for index = 1, itemCount, 1 do
    self:AddTrackedFrame(index, db.char.consumables[index + offset])
  end
end

function ConsumablesOptions.prototype:AddTrackedFrame(index, consumable)
  if not self.trackedFrames[index] then
    self.trackedFrames[index] = ManaMinder.TrackedConsumableFrame:new(self.trackedSectionFrame, consumable)
  end

  local frame = self.trackedFrames[index]
  frame.consumable = consumable
  frame.onRemoveClick = function() self:UntrackConsumable(consumable) end
  frame.onUpClick = function() self:IncreasePriority(index) end
  frame.onDownClick = function() self:DecreasePriority(index) end
  frame:SetPosition(index)
  frame:UpdateText()
  frame:Show()
end

function ConsumablesOptions.prototype:OnTrackedScroll()
  self:UpdateTrackedScroll()
  self:RefreshTrackedFrames()
end

function ConsumablesOptions.prototype:UpdateTrackedScroll()
  local consumableCount = table.getn(db.char.consumables)
  FauxScrollFrame_Update(getglobal(TRACKED_SCROLL_FRAME), consumableCount, MAX_SCROLL_ITEMS, SCROLL_ITEM_HEIGHT)

  for i = 1, table.getn(self.trackedFrames), 1 do
    self.trackedFrames[i]:SetScrollVisibility(consumableCount > MAX_SCROLL_ITEMS)
  end
end

function ConsumablesOptions.prototype:TrackConsumable(consumable)
  table.insert(db.char.consumables, {
    key = consumable.key,
    priority = table.getn(db.char.consumables) + 1,
    type = consumable.type
  })
  self:RefreshAllFrames()
  self:UpdateAvailableScroll()
  self:UpdateTrackedScroll()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:UntrackConsumable(consumable)
  db.char.consumables = ManaMinder:Splice(db.char.consumables, consumable.priority, 1)

  for i = 1, table.getn(db.char.consumables), 1 do
    db.char.consumables[i].priority = i
  end
  self:RefreshAllFrames()
  self:UpdateAvailableScroll()
  self:UpdateTrackedScroll()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:IncreasePriority(index)
  if (index == 1) then
    return
  end

  local old = db.char.consumables[index - 1]
  db.char.consumables[index - 1] = db.char.consumables[index]
  db.char.consumables[index - 1].priority = index - 1
  db.char.consumables[index] = old
  db.char.consumables[index].priority = index

  self:RefreshAllFrames()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:DecreasePriority(index)
  if (index == table.getn(db.char.consumables)) then
    return
  end

  local old = db.char.consumables[index + 1]
  db.char.consumables[index + 1] = db.char.consumables[index]
  db.char.consumables[index + 1].priority = index + 1
  db.char.consumables[index] = old
  db.char.consumables[index].priority = index

  self:RefreshAllFrames()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:OnPotionsCheckLoad()
  getglobal(POTIONS_CHECK_NAME .. "Text"):SetText(L["Only Show Highest Priority Potion"])
  getglobal(POTIONS_CHECK_NAME).tooltipText = L["When multiple potions are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions.prototype:OnPotionsCheckChange(value)
  db.char.showAllPotions = not value
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:OnRunesCheckLoad()
  getglobal(RUNES_CHECK_NAME .. "Text"):SetText(L["Only Show One of Demonic Rune/Dark Rune/Lily Root"])
  getglobal(RUNES_CHECK_NAME).tooltipText = L["When multiple runes are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions.prototype:OnRunesCheckChange(value)
  db.char.showAllRunes = not value
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:OnGemsCheckLoad()
  getglobal(GEMS_CHECK_NAME .. "Text"):SetText(L["Only Show Highest Priority Mana Gem"])
  getglobal(GEMS_CHECK_NAME).tooltipText = L["When multiple mana gems are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions.prototype:OnGemsCheckChange(value)
  db.char.showAllGems = not value
  ManaMinder.mainFrame:UpdateAll()
end

ManaMinder.optionsFrame.consumablesFrame = ConsumablesOptions:new()
