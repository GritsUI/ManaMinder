local AceOO = AceLibrary("AceOO-2.0")
local Bar = AceOO.Class()

function Bar.prototype:init(options)
    Bar.super.prototype.init(self)

    self.parentFrame = options.parentFrame
    self.state = options.state
end

function Bar.prototype:Update()

end

ManaMinder.Bar = Bar
