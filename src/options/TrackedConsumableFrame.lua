local L = ManaMinder.L
local frameCount = 1

local SECTION_LEFT_MARGIN = 10
local SECTION_RIGHT_MARGIN = -24
local SECTION_RIGHT_NO_SCROLL_MARGIN = -6
local SECTION_TOP_MARGIN = -6
local ITEM_HEIGHT = 20
local ICON_HEIGHT = ITEM_HEIGHT - 4
local NORMALTEX_RATIO = 1.7

TrackedConsumableFrame = {}
TrackedConsumableFrame.__index = TrackedConsumableFrame;

function TrackedConsumableFrame:new(parentFrame, consumable)
  local self = {}
  setmetatable(self, TrackedConsumableFrame)

  self.parentFrame = parentFrame
  self.frameName = "ManaMinder_Tracked_Consumable_" .. frameCount
  self.frame = CreateFrame("Frame", self.frameName, parentFrame, "ManaMinder_Tracked_Consumable")

  frameCount = frameCount + 1

  self.consumable = consumable
  self.withScroll = false
  self:InitializeEventHandlers()
  self:InitializeIcon()
  self:Update()

  return self
end

function TrackedConsumableFrame:SetPosition(index)
  self.index = index

  self.frame:SetPoint(
    "TOPLEFT",
    self.parentFrame,
    "TOPLEFT",
    SECTION_LEFT_MARGIN,
    SECTION_TOP_MARGIN + (-1 * ITEM_HEIGHT) * (index - 1)
  )

  local rightMargin = self.withScroll and SECTION_RIGHT_MARGIN or SECTION_RIGHT_NO_SCROLL_MARGIN
  self.frame:SetPoint("RIGHT", self.parentFrame, "RIGHT", rightMargin, 0)
end

function TrackedConsumableFrame:SetScrollVisibility(visible)
  self.withScroll = visible
  self:SetPosition(self.index)
end

function TrackedConsumableFrame:InitializeEventHandlers()
  self.frame:EnableMouse(true)
  self.frame:SetScript("OnEnter", function() self:OnMouseEnter() end)
  self.frame:SetScript("OnLeave", function() self:OnMouseLeave() end)

  getglobal(self.frameName .. "_Remove"):SetScript("OnClick", function() self:OnRemoveClick() end)
  getglobal(self.frameName .. "_Remove"):SetScript("OnEnter", function() self:OnMouseEnter() end)
  getglobal(self.frameName .. "_Remove"):SetScript("OnLeave", function() self:OnMouseLeave() end)
  getglobal(self.frameName .. "_Down"):SetScript("OnClick", function() self:OnDownClick() end)
  getglobal(self.frameName .. "_Down"):SetScript("OnEnter", function() self:OnMouseEnter() end)
  getglobal(self.frameName .. "_Down"):SetScript("OnLeave", function() self:OnMouseLeave() end)
  getglobal(self.frameName .. "_Up"):SetScript("OnClick", function() self:OnUpClick() end)
  getglobal(self.frameName .. "_Up"):SetScript("OnEnter", function() self:OnMouseEnter() end)
  getglobal(self.frameName .. "_Up"):SetScript("OnLeave", function() self:OnMouseLeave() end)
end

function TrackedConsumableFrame:OnMouseEnter()
  getglobal(self.frameName .. "_Text"):SetTextColor(1, 1, 1, 1)
end

function TrackedConsumableFrame:OnMouseLeave()
  getglobal(self.frameName .. "_Text"):SetTextColor(1, 0.82, 0, 1)
end

function TrackedConsumableFrame:InitializeIcon()
  local iconButton = getglobal(self.frameName .. "_Icon")
  iconButton:SetWidth(ICON_HEIGHT)
  iconButton:SetHeight(ICON_HEIGHT)
  iconButton:EnableMouse(false)

  local normalTexture = getglobal(self.frameName .. "_IconNormalTexture")
  normalTexture:SetWidth(ICON_HEIGHT * NORMALTEX_RATIO)
  normalTexture:SetHeight(ICON_HEIGHT * NORMALTEX_RATIO)
end

function TrackedConsumableFrame:Update()
  self:UpdateText()
  self:UpdateIconTexture()
end

function TrackedConsumableFrame:UpdateIconTexture()
  getglobal(self.frameName .. "_IconIcon"):SetTexture(ManaMinder:GetConsumableTextureForKey(self.consumable.key, self.consumable.type))
end

function TrackedConsumableFrame:UpdateText()
  getglobal(self.frameName .. "_Text"):SetText(L[ManaMinder:GetConsumableNameForKey(self.consumable.key, self.consumable.type)])
end

function TrackedConsumableFrame:OnRemoveClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  if self.onRemoveClick then
    self.onRemoveClick(self.consumable)
  end
end

function TrackedConsumableFrame:OnDownClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  if self.onDownClick then
    self.onDownClick(self.consumable)
  end
end

function TrackedConsumableFrame:OnUpClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  if self.onUpClick then
    self.onUpClick(self.consumable)
  end
end

ManaMinder.TrackedConsumableFrame = TrackedConsumableFrame
