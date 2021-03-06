local AceOO = AceLibrary("AceOO-2.0")
local AvailableConsumableFrame = AceOO.Class()

local L = ManaMinder.L
local frameCount = 1

local SECTION_LEFT_MARGIN = 10
local SECTION_RIGHT_MARGIN = -24
local SECTION_RIGHT_NO_SCROLL_MARGIN = -6
local SECTION_TOP_MARGIN = -6
local ITEM_HEIGHT = 20
local ICON_HEIGHT = ITEM_HEIGHT - 4
local NORMALTEX_RATIO = 1.7

function AvailableConsumableFrame.prototype:init(parentFrame, consumable)
  AvailableConsumableFrame.super.prototype.init(self)

  self.parentFrame = parentFrame
  self.frameName = "ManaMinder_Available_Consumable_" .. frameCount
  self.frame = CreateFrame("Frame", self.frameName, parentFrame, "ManaMinder_Available_Consumable")

  frameCount = frameCount + 1

  self.consumable = consumable
  self.withScroll = false
  self:InitializeEventHandlers()
  self:InitializeIcon()
  self:Update()
end

function AvailableConsumableFrame.prototype:InitializeIcon()
  local iconButton = getglobal(self.frameName .. "_Icon")
  iconButton:SetWidth(ICON_HEIGHT)
  iconButton:SetHeight(ICON_HEIGHT)
  iconButton:EnableMouse(false)

  local normalTexture = getglobal(self.frameName .. "_IconNormalTexture")
  normalTexture:SetWidth(ICON_HEIGHT * NORMALTEX_RATIO)
  normalTexture:SetHeight(ICON_HEIGHT * NORMALTEX_RATIO)
end

function AvailableConsumableFrame.prototype:InitializeEventHandlers()
  self.frame:EnableMouse(true)
  self.frame:SetScript("OnEnter", function() self:OnMouseEnter() end)
  self.frame:SetScript("OnLeave", function() self:OnMouseLeave() end)

  getglobal(self.frameName .. "_Add"):SetScript("OnClick", function() self:OnClick() end)
  getglobal(self.frameName .. "_Add"):SetScript("OnEnter", function() self:OnMouseEnter() end)
  getglobal(self.frameName .. "_Add"):SetScript("OnLeave", function() self:OnMouseLeave() end)
end

function AvailableConsumableFrame.prototype:OnMouseEnter()
  getglobal(self.frameName .. "_Text"):SetTextColor(1, 1, 1, 1)
end

function AvailableConsumableFrame.prototype:OnMouseLeave()
  getglobal(self.frameName .. "_Text"):SetTextColor(1, 0.82, 0, 1)
end

function AvailableConsumableFrame.prototype:OnClick()
  PlaySound("igMainMenuOptionCheckBoxOn");
  if self.onClick then
    self.onClick(self.consumable)
  end
end

function AvailableConsumableFrame.prototype:SetPosition(index)
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

function AvailableConsumableFrame.prototype:Update()
  self:UpdateText()
  self:UpdateIconTexture()
end

function AvailableConsumableFrame.prototype:UpdateText()
  getglobal(self.frameName .. "_Text"):SetText(L[self.consumable.name])
end

function AvailableConsumableFrame.prototype:UpdateIconTexture()
  getglobal(self.frameName .. "_IconIcon"):SetTexture(self.consumable.iconTexture)
end

function AvailableConsumableFrame.prototype:SetScrollVisibility(visible)
  self.withScroll = visible
  self:SetPosition(self.index)
end

ManaMinder.AvailableConsumableFrame = AvailableConsumableFrame
