local AceOO = AceLibrary("AceOO-2.0")
local BarsOptions = AceOO.Class()
local db = ManaMinder.db

local SCALE_SLIDER_NAME = "ManaMinder_Options_Bars_Scale_Slider"
local ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Alpha_Slider"
local WIDTH_SLIDER_NAME = "ManaMinder_Options_Bars_Width_Slider"
local HEIGHT_SLIDER_NAME = "ManaMinder_Options_Bars_Height_Slider"
local FONT_SIZE_SLIDER_NAME = "ManaMinder_Options_Bars_Font_Size_Slider"
local MARGIN_SLIDER_NAME = "ManaMinder_Options_Bars_Margin_Slider"

function BarsOptions.prototype:init()
    BarsOptions.super.prototype.init(self)
end

function BarsOptions.prototype:OnInitialize()
    getglobal(SCALE_SLIDER_NAME):SetValue(db.profile.mainFrame.scale)
    getglobal(ALPHA_SLIDER_NAME):SetValue(db.profile.mainFrame.alpha)
    getglobal(WIDTH_SLIDER_NAME):SetValue(db.profile.mainFrame.width)
    getglobal(HEIGHT_SLIDER_NAME):SetValue(db.profile.bars.height)
    getglobal(FONT_SIZE_SLIDER_NAME):SetValue(db.profile.bars.fontSize)
    getglobal(MARGIN_SLIDER_NAME):SetValue(db.profile.bars.margin)
end

function BarsOptions.prototype:OnScaleLoad()
    getglobal(SCALE_SLIDER_NAME):SetMinMaxValues(0.5, 2);
    getglobal(SCALE_SLIDER_NAME):SetValueStep(0.01);
end

function BarsOptions.prototype:OnScaleChange(value)
    db.profile.mainFrame.scale = value
    ManaMinder.mainFrame.frame:SetScale(value)
    getglobal(SCALE_SLIDER_NAME .. "Text"):SetText("Scale: " .. ManaMinder:RoundTo(db.profile.mainFrame.scale, 2))
end

function BarsOptions.prototype:OnAlphaLoad()
    getglobal(ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1);
    getglobal(ALPHA_SLIDER_NAME):SetValueStep(0.01);
end

function BarsOptions.prototype:OnAlphaChange(value)
    db.profile.mainFrame.alpha = value
    ManaMinder.mainFrame.frame:SetAlpha(value)
    getglobal(ALPHA_SLIDER_NAME .. "Text"):SetText("Alpha: " .. ManaMinder:RoundTo(db.profile.mainFrame.alpha, 2))
end

function BarsOptions.prototype:OnWidthLoad()
    getglobal(WIDTH_SLIDER_NAME):SetMinMaxValues(50, 300);
    getglobal(WIDTH_SLIDER_NAME):SetValueStep(1);
end

function BarsOptions.prototype:OnWidthChange(value)
    db.profile.mainFrame.width = value
    ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateWidth() end)
    getglobal(WIDTH_SLIDER_NAME .. "Text"):SetText("Width: " .. db.profile.mainFrame.width)
end

function BarsOptions.prototype:OnHeightLoad()
    getglobal(HEIGHT_SLIDER_NAME):SetMinMaxValues(10, 50);
    getglobal(HEIGHT_SLIDER_NAME):SetValueStep(1);
end

function BarsOptions.prototype:OnHeightChange(value)
    db.profile.bars.height = value
    ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateHeight() end)
    getglobal(HEIGHT_SLIDER_NAME .. "Text"):SetText("Height: " .. db.profile.bars.height)
end

function BarsOptions.prototype:OnFontSizeLoad()
    getglobal(FONT_SIZE_SLIDER_NAME):SetMinMaxValues(6, 20);
    getglobal(FONT_SIZE_SLIDER_NAME):SetValueStep(1);
end

function BarsOptions.prototype:OnFontSizeChange(value)
    db.profile.bars.fontSize = value
    ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateFontSize() end)
    getglobal(FONT_SIZE_SLIDER_NAME .. "Text"):SetText("Font Size: " .. db.profile.bars.fontSize)
end

function BarsOptions.prototype:OnMarginLoad()
    getglobal(MARGIN_SLIDER_NAME):SetMinMaxValues(0, 20);
    getglobal(MARGIN_SLIDER_NAME):SetValueStep(1);
end

function BarsOptions.prototype:OnMarginChange(value)
    db.profile.bars.margin = value
    ManaMinder.barManager:ForEachBar(function(bar) bar:UpdatePosition() end)
    getglobal(MARGIN_SLIDER_NAME .. "Text"):SetText("Margin: " .. db.profile.bars.margin)
end

ManaMinder.optionsFrame.barsFrame = BarsOptions:new()
