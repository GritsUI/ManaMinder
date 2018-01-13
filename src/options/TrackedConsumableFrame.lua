local AceOO = AceLibrary("AceOO-2.0")
local TrackedConsumableFrame = AceOO.Class()
AceOO.Class:init(TrackedConsumableFrame, ManaMinder.Frame)

local L = ManaMinder.L
local frameCount = 1

local SECTION_LEFT_MARGIN = 10
local SECTION_RIGHT_MARGIN = -24
local SECTION_RIGHT_NO_SCROLL_MARGIN = -6
local SECTION_TOP_MARGIN = -6
local ITEM_HEIGHT = 20

function TrackedConsumableFrame.prototype:init(parentFrame, consumable)
  TrackedConsumableFrame.super.prototype.init(self, {
    frameType = "Frame",
    frameName = "ManaMinder_Tracked_Consumable_" .. frameCount,
    parentFrame = parentFrame,
    inheritsFrame = "ManaMinder_Tracked_Consumable"
  })

  frameCount = frameCount + 1

  self.consumable = consumable
  self.withScroll = false
  self:UpdateText()
  self:InitializeEventHandlers()
end

function TrackedConsumableFrame.prototype:SetPosition(index)
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

function TrackedConsumableFrame.prototype:UpdateText()
  getglobal(self.frameName .. "_Text"):SetText(L[ManaMinder:GetConsumableNameForKey(self.consumable.key, self.consumable.type)])
end

function TrackedConsumableFrame.prototype:SetScrollVisibility(visible)
  self.withScroll = visible
  self:SetPosition(self.index)
end

function TrackedConsumableFrame.prototype:InitializeEventHandlers()
  getglobal(self.frameName .. "_Remove"):SetScript("OnClick", function() self:OnRemoveClick() end)
  getglobal(self.frameName .. "_Down"):SetScript("OnClick", function() self:OnDownClick() end)
  getglobal(self.frameName .. "_Up"):SetScript("OnClick", function() self:OnUpClick() end)
end

function TrackedConsumableFrame.prototype:OnRemoveClick()
  if self.onRemoveClick then
    self.onRemoveClick(self.consumable)
  end
end

function TrackedConsumableFrame.prototype:OnDownClick()
  if self.onDownClick then
    self.onDownClick(self.consumable)
  end
end

function TrackedConsumableFrame.prototype:OnUpClick()
  if self.onUpClick then
    self.onUpClick(self.consumable)
  end
end

ManaMinder.TrackedConsumableFrame = TrackedConsumableFrame
