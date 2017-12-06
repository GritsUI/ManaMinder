local AceOO = AceLibrary("AceOO-2.0")
local Frame = AceOO.Class()

function Frame.prototype:init(options)
    Frame.super.prototype.init(self)
    self.frame = CreateFrame(options.frameType, options.frameName, options.parentFrame, options.inheritsFrame)
    self.parentFrame = options.parentFrame
end

function Frame.prototype:GetPosition()
    local x = self.frame:GetLeft()
    local y = (self.parentFrame:GetHeight() / self.parentFrame:GetScale() - self.frame:GetTop()) * -1
    return x, y
end

ManaMinder.Frame = Frame
