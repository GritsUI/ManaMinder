local AceOO = AceLibrary("AceOO-2.0")
local Frame = AceOO.Class()

function Frame.prototype:init(options)
  Frame.super.prototype.init(self)
  self.frame = CreateFrame(options.frameType, options.frameName, options.parentFrame, options.inheritsFrame)
  self.parentFrame = options.parentFrame
  self.frameName = options.frameName
end

function Frame.prototype:GetPosition()
  local x = self.frame:GetLeft()
  local y = (self.parentFrame:GetHeight() / self.parentFrame:GetScale() - self.frame:GetTop()) * -1
  return x, y
end

function Frame.prototype:Hide()
  self.frame:Hide()
end

function Frame.prototype:Show()
  self.frame:Show()
end

ManaMinder.Frame = Frame
