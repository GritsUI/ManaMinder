local AceOO = AceLibrary("AceOO-2.0")
local AvailableConsumableFrame = AceOO.Class()
AceOO.Class:init(AvailableConsumableFrame, ManaMinder.Frame)

local L = ManaMinder.L
local frameCount = 1

local SECTION_LEFT_MARGIN = 10
local SECTION_RIGHT_MARGIN = -24
local SECTION_RIGHT_NO_SCROLL_MARGIN = -6
local SECTION_TOP_MARGIN = -6
local ITEM_HEIGHT = 20

function AvailableConsumableFrame.prototype:init(parentFrame, consumable)
  AvailableConsumableFrame.super.prototype.init(self, {
    frameType = "Frame",
    frameName = "ManaMinder_Available_Consumable_" .. frameCount,
    parentFrame = parentFrame,
    inheritsFrame = "ManaMinder_Available_Consumable"
  })

  frameCount = frameCount + 1

  self.consumable = consumable
  self.withScroll = false
  self:InitializeEventHandlers()
  self:UpdateText()
end

function AvailableConsumableFrame.prototype:InitializeEventHandlers()
  getglobal(self.frameName .. "_Add"):SetScript("OnClick", function() self:OnClick() end)
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

function AvailableConsumableFrame.prototype:UpdateText()
  getglobal(self.frameName .. "_Text"):SetText(L[self.consumable.name])
end

function AvailableConsumableFrame.prototype:SetScrollVisibility(visible)
  self.withScroll = visible
  self:SetPosition(self.index)
end

function AvailableConsumableFrame.prototype:OnClick()
  if self.onClick then
    self.onClick(self.consumable)
  end
end

ManaMinder.AvailableConsumableFrame = AvailableConsumableFrame
