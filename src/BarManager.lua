local AceOO = AceLibrary("AceOO-2.0")
local BarManager = AceOO.Class()

function BarManager.prototype:init(options)
    BarManager.super.prototype.init(self)

    self.stateManager = options.stateManager
    self.bars = {}
end

function BarManager.prototype:Update()
    -- Create bars that don't already exist for tracked items
    -- eg. On Initial setup, on going from item count 0 to > 0, on enabling of an item in settings
    ManaMinder:CreateMissingBars()

    -- Remove bars for tracked items that should no longer be shown
    -- eg. On going from item count > 0 to 0, on disabling of an item in settings
    ManaMinder:RemoveStaleBars()

    -- Update current bar positioning, labels, etc.
    ManaMinder:UpdateBars()
end

function BarManager.prototype:CreateMissingBars()

end

function BarManager.prototype:RemoveStaleBars()

end

function BarManager.prototype:UpdateBars()

end

ManaMinder.BarManager = BarManager
