local L = ManaMinder.L
local db = nil

local AVAILABLE_SECTION_NAME = "ManaMinder_Options_Consumables_Available_Section"
local TRACKED_SECTION_NAME = "ManaMinder_Options_Consumables_Tracked_Section"
local SHARED_SECTION_NAME = "ManaMinder_Options_Consumables_Shared_Section"
local USAGE_SECTION_NAME = "ManaMinder_Options_Consumables_Usage_Section"
local POTIONS_CHECK_NAME = "ManaMinder_Options_Consumables_Potions_Check"
local RUNES_CHECK_NAME = "ManaMinder_Options_Consumables_Runes_Check"
local GEMS_CHECK_NAME = "ManaMinder_Options_Consumables_Gems_Check"
local AVAILABLE_SCROLL_FRAME = "ManaMinder_Options_Consumables_Available_Section_Scroll"
local TRACKED_SCROLL_FRAME = "ManaMinder_Options_Consumables_Tracked_Section_Scroll"
local OOC_CHECK_NAME = "ManaMinder_Options_Consumables_OOC_Check"

local MAX_SCROLL_ITEMS = 12
local SCROLL_ITEM_HEIGHT = 20

ConsumablesOptions = {}
ConsumablesOptions.__index = ConsumablesOptions;

function ConsumablesOptions:new()
  local self = {}
  setmetatable(self, ConsumablesOptions)

  self.availableConsumables = {}
  self.availableFrames = {}
  self.trackedFrames = {}

  return self
end

function ConsumablesOptions:OnInitialize()
  db = ManaMinder.db
  self.availableSectionFrame = getglobal(AVAILABLE_SECTION_NAME)
  self.trackedSectionFrame = getglobal(TRACKED_SECTION_NAME)
  self:RefreshAllFrames()
  self:ApplyTranslations()
  self:SetInitialValues()
end

function ConsumablesOptions:ApplyTranslations()
  getglobal(AVAILABLE_SECTION_NAME .. "Text"):SetText(L["Available"])
  getglobal(TRACKED_SECTION_NAME .. "Text"):SetText(L["Tracked"])
  getglobal(SHARED_SECTION_NAME .. "Text"):SetText(L["Shared Cooldowns"])
  getglobal(USAGE_SECTION_NAME .. "Text"):SetText(L["Usage"])
end

function ConsumablesOptions:SetInitialValues()
  getglobal(POTIONS_CHECK_NAME):SetChecked(not db.char.showAllPotions)
  getglobal(RUNES_CHECK_NAME):SetChecked(not db.char.showAllRunes)
  getglobal(GEMS_CHECK_NAME):SetChecked(not db.char.showAllGems)
  getglobal(OOC_CHECK_NAME):SetChecked(db.char.onlyUseInCombat)
end

function ConsumablesOptions:RefreshAllFrames()
  self:RefreshAvailableFrames()
  self:RefreshTrackedFrames()
end

function ConsumablesOptions:RefreshAvailableFrames()
  self:RemoveCurrentAvailableFrames()
  self:AddAvailableFrames()
end

function ConsumablesOptions:RefreshTrackedFrames()
  self:RemoveCurrentTrackedFrames()
  self:AddTrackedFrames()
end

function ConsumablesOptions:RemoveCurrentAvailableFrames()
  for i = 1, table.getn(self.availableFrames), 1 do
    self.availableFrames[i].frame:Hide()
  end
end

function ConsumablesOptions:AddAvailableFrames()
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

function ConsumablesOptions:AddAvailableFrame(index, consumable)
  if not self.availableFrames[index] then
    self.availableFrames[index] = ManaMinder.AvailableConsumableFrame:new(self.availableSectionFrame, consumable)
  end

  local frame = self.availableFrames[index]
  frame.consumable = consumable
  frame.onClick = function() self:TrackConsumable(consumable) end
  frame:SetPosition(index)
  frame:Update()
  frame.frame:Show()
end

function ConsumablesOptions:GetAvailableConsumables()
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

function ConsumablesOptions:OnAvailableScroll()
  self:UpdateAvailableScroll()
  self:RefreshAvailableFrames()
end

function ConsumablesOptions:UpdateAvailableScroll()
  local consumableCount = table.getn(self.availableConsumables)
  FauxScrollFrame_Update(getglobal(AVAILABLE_SCROLL_FRAME), consumableCount, MAX_SCROLL_ITEMS, SCROLL_ITEM_HEIGHT)

  for i = 1, table.getn(self.availableFrames), 1 do
    self.availableFrames[i]:SetScrollVisibility(consumableCount > MAX_SCROLL_ITEMS)
  end
end

function ConsumablesOptions:IsConsumableTracked(consumableKey)
  for index = 1, db.char.consumableCount, 1 do
    if db.char.consumables[index].key == consumableKey then
      return true
    end
  end
  return false
end

function ConsumablesOptions:IsConsumableAvailableForClass(consumable)
  local _, class = UnitClass("player")
  return not consumable.class or consumable.class == class
end

function ConsumablesOptions:RemoveCurrentTrackedFrames()
  for i = 1, table.getn(self.trackedFrames), 1 do
    self.trackedFrames[i].frame:Hide()
  end
end

function ConsumablesOptions:AddTrackedFrames()
  local offset = FauxScrollFrame_GetOffset(getglobal(TRACKED_SCROLL_FRAME))
  if offset > 0 and offset + MAX_SCROLL_ITEMS > db.char.consumableCount then
    offset = offset - 1
    FauxScrollFrame_SetOffset(getglobal(TRACKED_SCROLL_FRAME), offset)
  end

  local itemCount = math.min(MAX_SCROLL_ITEMS, db.char.consumableCount)
  for index = 1, itemCount, 1 do
    self:AddTrackedFrame(index, db.char.consumables[index + offset])
  end
end

function ConsumablesOptions:AddTrackedFrame(index, consumable)
  if not self.trackedFrames[index] then
    self.trackedFrames[index] = ManaMinder.TrackedConsumableFrame:new(self.trackedSectionFrame, consumable)
  end

  local frame = self.trackedFrames[index]
  frame.consumable = consumable
  frame.onRemoveClick = function() self:UntrackConsumable(consumable) end
  frame.onUpClick = function() self:IncreasePriority(index) end
  frame.onDownClick = function() self:DecreasePriority(index) end
  frame:SetPosition(index)
  frame:Update()
  frame.frame:Show()
end

function ConsumablesOptions:OnTrackedScroll()
  self:UpdateTrackedScroll()
  self:RefreshTrackedFrames()
end

function ConsumablesOptions:UpdateTrackedScroll()
  local consumableCount = db.char.consumableCount
  FauxScrollFrame_Update(getglobal(TRACKED_SCROLL_FRAME), consumableCount, MAX_SCROLL_ITEMS, SCROLL_ITEM_HEIGHT)

  for i = 1, table.getn(self.trackedFrames), 1 do
    self.trackedFrames[i]:SetScrollVisibility(consumableCount > MAX_SCROLL_ITEMS)
  end
end

function ConsumablesOptions:TrackConsumable(consumable)
  db.char.consumableCount = db.char.consumableCount + 1
  db.char.consumables[db.char.consumableCount] = {
    key = consumable.key,
    priority = db.char.consumableCount,
    type = consumable.type
  }

  self:RefreshAllFrames()
  self:UpdateAvailableScroll()
  self:UpdateTrackedScroll()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions:UntrackConsumable(consumable)
  db.char.consumables = ManaMinder:Splice(db.char.consumables, consumable.priority, 1)
  db.char.consumableCount = db.char.consumableCount - 1

  for i = 1, db.char.consumableCount, 1 do
    db.char.consumables[i].priority = i
  end
  self:RefreshAllFrames()
  self:UpdateAvailableScroll()
  self:UpdateTrackedScroll()
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions:IncreasePriority(index)
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

function ConsumablesOptions:DecreasePriority(index)
  if (index == db.char.consumableCount) then
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

function ConsumablesOptions:OnPotionsCheckLoad()
  getglobal(POTIONS_CHECK_NAME .. "Text"):SetText(L["Only Show Highest Priority Potion"])
  getglobal(POTIONS_CHECK_NAME).tooltipText = L["When multiple potions are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions:OnPotionsCheckChange(value)
  db.char.showAllPotions = not value
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions:OnRunesCheckLoad()
  getglobal(RUNES_CHECK_NAME .. "Text"):SetText(L["Only Show Highest Priority Rune"])
  getglobal(RUNES_CHECK_NAME).tooltipText = L["When multiple runes are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions:OnRunesCheckChange(value)
  db.char.showAllRunes = not value
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions:OnGemsCheckLoad()
  getglobal(GEMS_CHECK_NAME .. "Text"):SetText(L["Only Show Highest Priority Mana Gem"])
  getglobal(GEMS_CHECK_NAME).tooltipText = L["When multiple mana gems are tracked, only show a bar for that with the highest priority."]
end

function ConsumablesOptions:OnGemsCheckChange(value)
  db.char.showAllGems = not value
  ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions:OnOOCCheckLoad()
  getglobal(OOC_CHECK_NAME .. "Text"):SetText(L["Only Use Consumables in Combat"])
  getglobal(OOC_CHECK_NAME).tooltipText = L["When checked, macro will not use the next available consumable when out of combat."]
end

function ConsumablesOptions:OnOOCCheckChange(value)
  db.char.onlyUseInCombat = value
end

ManaMinder.optionsFrame.consumablesFrame = ConsumablesOptions:new()
