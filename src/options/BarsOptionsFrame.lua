local AceOO = AceLibrary("AceOO-2.0")
local BarsOptions = AceOO.Class()
local db = ManaMinder.db

local WIDTH_SLIDER_NAME = "ManaMinder_Options_Bars_Width_Slider"
local HEIGHT_SLIDER_NAME = "ManaMinder_Options_Bars_Height_Slider"
local FONT_SIZE_SLIDER_NAME = "ManaMinder_Options_Bars_Font_Size_Slider"
local MARGIN_SLIDER_NAME = "ManaMinder_Options_Bars_Margin_Slider"
local READY_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Ready_Background_Picker"
local READY_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Ready_Font_Picker"
local READY_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Ready_Alpha_Slider"
local DEFICIT_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Deficit_Background_Picker"
local DEFICIT_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Deficit_Font_Picker"
local DEFICIT_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Deficit_Alpha_Slider"
local COOLDOWN_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Cooldown_Background_Picker"
local COOLDOWN_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Cooldown_Font_Picker"
local COOLDOWN_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Cooldown_Alpha_Slider"
local BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Background_Picker"
local TEXTURE_DROPDOWN_NAME = "ManaMinder_Options_Bars_Texture_DropDown"

function BarsOptions.prototype:init()
    BarsOptions.super.prototype.init(self)
end

function BarsOptions.prototype:OnInitialize()
    getglobal(WIDTH_SLIDER_NAME):SetValue(db.profile.mainFrame.width)
    getglobal(HEIGHT_SLIDER_NAME):SetValue(db.profile.bars.height)
    getglobal(FONT_SIZE_SLIDER_NAME):SetValue(db.profile.bars.fontSize)
    getglobal(MARGIN_SLIDER_NAME):SetValue(db.profile.bars.margin)
    getglobal(READY_ALPHA_SLIDER_NAME):SetValue(db.profile.bars.readyAlpha)
    getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetValue(db.profile.bars.deficitAlpha)
    getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetValue(db.profile.bars.cooldownAlpha)
    UIDropDownMenu_SetSelectedValue(getglobal(TEXTURE_DROPDOWN_NAME), db.profile.bars.texture)
    self:SetSwatchColor(READY_BACKGROUND_PICKER_NAME, db.profile.bars.readyColor)
    self:SetSwatchColor(READY_FONT_PICKER_NAME, db.profile.bars.readyFontColor)
    self:SetSwatchColor(DEFICIT_BACKGROUND_PICKER_NAME, db.profile.bars.deficitColor)
    self:SetSwatchColor(DEFICIT_FONT_PICKER_NAME, db.profile.bars.deficitFontColor)
    self:SetSwatchColor(COOLDOWN_BACKGROUND_PICKER_NAME, db.profile.bars.cooldownColor)
    self:SetSwatchColor(COOLDOWN_FONT_PICKER_NAME, db.profile.bars.cooldownFontColor)
    self:SetSwatchColor(BACKGROUND_PICKER_NAME, db.profile.bars.backgroundColor)
end

function BarsOptions.prototype:SetSwatchColor(pickerName, color)
    getglobal(pickerName .. "ButtonSwatch"):SetVertexColor(color[1], color[2], color[3])
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

function BarsOptions.prototype:OnReadyBackgroundLoad()
    getglobal(READY_BACKGROUND_PICKER_NAME .. "Text"):SetText("Bar Color")
    getglobal(READY_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(READY_BACKGROUND_PICKER_NAME, "readyColor", false))
end

function BarsOptions.prototype:OnReadyFontLoad()
    getglobal(READY_FONT_PICKER_NAME .. "Text"):SetText("Font Color")
    getglobal(READY_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(READY_FONT_PICKER_NAME, "readyFontColor", false))
end

function BarsOptions.prototype:OnReadyAlphaLoad()
    getglobal(READY_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1);
    getglobal(READY_ALPHA_SLIDER_NAME):SetValueStep(0.01);
end

function BarsOptions.prototype:OnReadyAlphaChange(value)
    db.profile.bars.readyAlpha = value
    getglobal(READY_ALPHA_SLIDER_NAME .. "Text"):SetText("Alpha: " .. ManaMinder:RoundTo(db.profile.bars.readyAlpha, 2))
end

function BarsOptions.prototype:OnDeficitBackgroundLoad()
    getglobal(DEFICIT_BACKGROUND_PICKER_NAME .. "Text"):SetText("Bar Color")
    getglobal(DEFICIT_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(DEFICIT_BACKGROUND_PICKER_NAME, "deficitColor", false))
end

function BarsOptions.prototype:OnDeficitFontLoad()
    getglobal(DEFICIT_FONT_PICKER_NAME .. "Text"):SetText("Font Color")
    getglobal(DEFICIT_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(DEFICIT_FONT_PICKER_NAME, "deficitFontColor", false))
end

function BarsOptions.prototype:OnDeficitAlphaLoad()
    getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1);
    getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetValueStep(0.01);
end

function BarsOptions.prototype:OnDeficitAlphaChange(value)
    db.profile.bars.deficitAlpha = value
    getglobal(DEFICIT_ALPHA_SLIDER_NAME .. "Text"):SetText("Alpha: " .. ManaMinder:RoundTo(db.profile.bars.deficitAlpha, 2))
end

function BarsOptions.prototype:OnCooldownBackgroundLoad()
    getglobal(COOLDOWN_BACKGROUND_PICKER_NAME .. "Text"):SetText("Bar Color")
    getglobal(COOLDOWN_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(COOLDOWN_BACKGROUND_PICKER_NAME, "cooldownColor", false))
end

function BarsOptions.prototype:OnCooldownFontLoad()
    getglobal(COOLDOWN_FONT_PICKER_NAME .. "Text"):SetText("Font Color")
    getglobal(COOLDOWN_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(COOLDOWN_FONT_PICKER_NAME, "cooldownFontColor", false))
end

function BarsOptions.prototype:OnCooldownAlphaLoad()
    getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1);
    getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetValueStep(0.01);
end

function BarsOptions.prototype:OnCooldownAlphaChange(value)
    db.profile.bars.cooldownAlpha = value
    getglobal(COOLDOWN_ALPHA_SLIDER_NAME .. "Text"):SetText("Alpha: " .. ManaMinder:RoundTo(db.profile.bars.cooldownAlpha, 2))
end

function BarsOptions.prototype:OnBackgroundPickerLoad()
    getglobal(BACKGROUND_PICKER_NAME .. "Text"):SetText("Background Color")
    getglobal(BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
        self:GetColorPickerClickHandler(BACKGROUND_PICKER_NAME, "backgroundColor", true, function()
            ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateBackground() end)
        end))
end

function BarsOptions.prototype:OnTextureDropDownLoad()
    local dropdown = this
    UIDropDownMenu_Initialize(this, function()
        for key, value in ipairs(ManaMinder.texturesList) do
            local info = {}
            info.text = value.name
            info.value = value.name
            info.func = function()
                UIDropDownMenu_SetSelectedID(dropdown, this:GetID())
                db.profile.bars.texture = UIDropDownMenu_GetText(dropdown)
                ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateTexture() end)
            end
            info.checked = false
            UIDropDownMenu_AddButton(info, 1)
        end
    end);
end

function BarsOptions.prototype:GetColorPickerClickHandler(pickerName, optionName, hasOpacity, callback)
    return function()
        local color = db.profile.bars[optionName]
        ManaMinder:ShowColorPicker(color[1], color[2], color[3], color[4], hasOpacity, function()
            if not ColorPickerFrame:IsVisible() then
                local r, g, b = ColorPickerFrame:GetColorRGB()
                if (hasOpacity) then
                    db.profile.bars[optionName] = { r, g, b, 1 - OpacitySliderFrame:GetValue() }
                else
                    db.profile.bars[optionName] = { r, g, b }
                end

                self:SetSwatchColor(pickerName, db.profile.bars[optionName])
                if callback then
                    callback()
                end
            end
        end)
    end
end

ManaMinder.optionsFrame.barsFrame = BarsOptions:new()
