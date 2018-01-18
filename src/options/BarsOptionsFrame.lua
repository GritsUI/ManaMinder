local AceOO = AceLibrary("AceOO-2.0")
local BarsOptions = AceOO.Class()
local db = ManaMinder.db
local L = ManaMinder.L

local VISIBILITY_SECTION_TEXT_NAME = "ManaMinder_Options_Bars_Visibility_SectionText"
local DISPLAY_SECTION_TEXT_NAME = "ManaMinder_Options_Bars_Display_SectionText"
local READY_SECTION_TEXT_NAME = "ManaMinder_Options_Bars_Ready_SectionText"
local DEFICIT_SECTION_TEXT_NAME = "ManaMinder_Options_Bars_Deficit_SectionText"
local COOLDOWN_SECTION_TEXT_NAME = "ManaMinder_Options_Bars_Cooldown_SectionText"
local TEXTURE_DROPDOWN_TEXT_NAME = "ManaMinder_Options_Bars_Texture_DropDown_Text"

local SHOW_CHECK_NAME = "ManaMinder_Options_Bars_Show_Check"
local SHOW_OOC_CHECK_NAME = "ManaMinder_Options_Bars_Show_OOC_Check"
local SHOW_SOLO_CHECK_NAME = "ManaMinder_Options_Bars_Show_Solo_Check"
local SHOW_GROUP_CHECK_NAME = "ManaMinder_Options_Bars_Show_Group_Check"
local SHOW_RAID_CHECK_NAME = "ManaMinder_Options_Bars_Show_Raid_Check"
local LOCK_CHECK_NAME = "ManaMinder_Options_Bars_Lock_Check"
local TOOLTIPS_CHECK_NAME = "ManaMinder_Options_Bars_Tooltips_Check"
local WIDTH_SLIDER_NAME = "ManaMinder_Options_Bars_Width_Slider"
local HEIGHT_SLIDER_NAME = "ManaMinder_Options_Bars_Height_Slider"
local FONT_SIZE_SLIDER_NAME = "ManaMinder_Options_Bars_Font_Size_Slider"
local MARGIN_SLIDER_NAME = "ManaMinder_Options_Bars_Margin_Slider"
local READY_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Ready_Background_Picker"
local READY_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Ready_Font_Picker"
local READY_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Ready_Alpha_Slider"
local READY_TEXT_BOX_NAME = "ManaMinder_Options_Bars_Ready_Text"
local DEFICIT_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Deficit_Background_Picker"
local DEFICIT_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Deficit_Font_Picker"
local DEFICIT_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Deficit_Alpha_Slider"
local DEFICIT_TEXT_BOX_NAME = "ManaMinder_Options_Bars_Deficit_Text"
local COOLDOWN_BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Cooldown_Background_Picker"
local COOLDOWN_FONT_PICKER_NAME = "ManaMinder_Options_Bars_Cooldown_Font_Picker"
local COOLDOWN_ALPHA_SLIDER_NAME = "ManaMinder_Options_Bars_Cooldown_Alpha_Slider"
local COOLDOWN_TEXT_BOX_NAME = "ManaMinder_Options_Bars_Cooldown_Text"
local BACKGROUND_PICKER_NAME = "ManaMinder_Options_Bars_Background_Picker"
local TEXTURE_DROPDOWN_NAME = "ManaMinder_Options_Bars_Texture_DropDown"

function BarsOptions.prototype:init()
  BarsOptions.super.prototype.init(self)
end

function BarsOptions.prototype:OnInitialize()
  self:ApplyTranslations()
  self:SetInitialValues()
  self:UpdateShowChecksState()
end

function BarsOptions.prototype:ApplyTranslations()
  getglobal(VISIBILITY_SECTION_TEXT_NAME):SetText(L["Visibility"])
  getglobal(DISPLAY_SECTION_TEXT_NAME):SetText(L["Display"])
  getglobal(READY_SECTION_TEXT_NAME):SetText(L["Ready State"])
  getglobal(DEFICIT_SECTION_TEXT_NAME):SetText(L["Deficit State"])
  getglobal(COOLDOWN_SECTION_TEXT_NAME):SetText(L["Cooldown State"])
  getglobal(TEXTURE_DROPDOWN_TEXT_NAME):SetText(L["Texture"])
end

function BarsOptions.prototype:SetInitialValues()
  getglobal(SHOW_CHECK_NAME):SetChecked(not db.char.mainFrame.hidden)
  getglobal(SHOW_OOC_CHECK_NAME):SetChecked(not db.char.mainFrame.hiddenOutOfCombat)
  getglobal(SHOW_SOLO_CHECK_NAME):SetChecked(not db.char.mainFrame.hiddenSolo)
  getglobal(SHOW_GROUP_CHECK_NAME):SetChecked(not db.char.mainFrame.hiddenGroup)
  getglobal(SHOW_RAID_CHECK_NAME):SetChecked(not db.char.mainFrame.hiddenRaid)
  getglobal(LOCK_CHECK_NAME):SetChecked(db.char.mainFrame.locked)
  getglobal(TOOLTIPS_CHECK_NAME):SetChecked(not db.char.bars.tooltipsDisabled)
  getglobal(WIDTH_SLIDER_NAME):SetValue(db.char.mainFrame.width)
  getglobal(HEIGHT_SLIDER_NAME):SetValue(db.char.bars.height)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValue(db.char.bars.fontSize)
  getglobal(MARGIN_SLIDER_NAME):SetValue(db.char.bars.margin)
  getglobal(READY_ALPHA_SLIDER_NAME):SetValue(db.char.bars.readyAlpha)
  getglobal(READY_TEXT_BOX_NAME):SetText(db.char.bars.readyText)
  getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetValue(db.char.bars.deficitAlpha)
  getglobal(DEFICIT_TEXT_BOX_NAME):SetText(db.char.bars.deficitText)
  getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetValue(db.char.bars.cooldownAlpha)
  getglobal(COOLDOWN_TEXT_BOX_NAME):SetText(db.char.bars.cooldownText)
  UIDropDownMenu_SetSelectedValue(getglobal(TEXTURE_DROPDOWN_NAME), db.char.bars.texture)
  self:SetSwatchColor(READY_BACKGROUND_PICKER_NAME, db.char.bars.readyColor)
  self:SetSwatchColor(READY_FONT_PICKER_NAME, db.char.bars.readyFontColor)
  self:SetSwatchColor(DEFICIT_BACKGROUND_PICKER_NAME, db.char.bars.deficitColor)
  self:SetSwatchColor(DEFICIT_FONT_PICKER_NAME, db.char.bars.deficitFontColor)
  self:SetSwatchColor(COOLDOWN_BACKGROUND_PICKER_NAME, db.char.bars.cooldownColor)
  self:SetSwatchColor(COOLDOWN_FONT_PICKER_NAME, db.char.bars.cooldownFontColor)
  self:SetSwatchColor(BACKGROUND_PICKER_NAME, db.char.bars.backgroundColor)
end

function BarsOptions.prototype:SetSwatchColor(pickerName, color)
  getglobal(pickerName .. "ButtonSwatch"):SetVertexColor(color[1], color[2], color[3])
end

function BarsOptions.prototype:UpdateShowChecksState()
  if db.char.mainFrame.hidden then
    OptionsFrame_DisableCheckBox(getglobal(SHOW_OOC_CHECK_NAME))
    OptionsFrame_DisableCheckBox(getglobal(SHOW_SOLO_CHECK_NAME))
    OptionsFrame_DisableCheckBox(getglobal(SHOW_GROUP_CHECK_NAME))
    OptionsFrame_DisableCheckBox(getglobal(SHOW_RAID_CHECK_NAME))
  else
    OptionsFrame_EnableCheckBox(getglobal(SHOW_OOC_CHECK_NAME))
    OptionsFrame_EnableCheckBox(getglobal(SHOW_SOLO_CHECK_NAME))
    OptionsFrame_EnableCheckBox(getglobal(SHOW_GROUP_CHECK_NAME))
    OptionsFrame_EnableCheckBox(getglobal(SHOW_RAID_CHECK_NAME))
  end
end

function BarsOptions.prototype:OnShowLoad()
  getglobal(SHOW_CHECK_NAME .. "Text"):SetText(L["Show Bars"])
  getglobal(SHOW_CHECK_NAME).tooltipText = L["Uncheck to hide bars at all times."]
end

function BarsOptions.prototype:OnShowChange(show)
  db.char.mainFrame.hidden = not show
  self:UpdateShowChecksState()
  ManaMinder.mainFrame:UpdateVisibility()
end

function BarsOptions.prototype:OnShowOutOfCombatLoad()
  getglobal(SHOW_OOC_CHECK_NAME .. "Text"):SetText(L["Show Bars Out of Combat"])
  getglobal(SHOW_OOC_CHECK_NAME).tooltipText = L["Uncheck to hide bars when out of combat."]
end

function BarsOptions.prototype:OnShowOutOfCombatChange(show)
  db.char.mainFrame.hiddenOutOfCombat = not show
  ManaMinder.mainFrame:UpdateVisibility()
end

function BarsOptions.prototype:OnShowSoloLoad()
  getglobal(SHOW_SOLO_CHECK_NAME .. "Text"):SetText(L["Show Bars Solo"])
  getglobal(SHOW_SOLO_CHECK_NAME).tooltipText = L["Uncheck to hide bars when not in a party or raid."]
end

function BarsOptions.prototype:OnShowSoloChange(show)
  db.char.mainFrame.hiddenSolo = not show
  ManaMinder.mainFrame:UpdateVisibility()
end

function BarsOptions.prototype:OnShowGroupLoad()
  getglobal(SHOW_GROUP_CHECK_NAME .. "Text"):SetText(L["Show Bars in Group"])
  getglobal(SHOW_GROUP_CHECK_NAME).tooltipText = L["Uncheck to hide bars when in a party."]
end

function BarsOptions.prototype:OnShowGroupChange(show)
  db.char.mainFrame.hiddenGroup = not show
  ManaMinder.mainFrame:UpdateVisibility()
end

function BarsOptions.prototype:OnShowRaidLoad()
  getglobal(SHOW_RAID_CHECK_NAME .. "Text"):SetText(L["Show Bars in Raid"])
  getglobal(SHOW_RAID_CHECK_NAME).tooltipText = L["Uncheck to hide bars when in a raid."]
end

function BarsOptions.prototype:OnShowRaidChange(show)
  db.char.mainFrame.hiddenRaid = not show
  ManaMinder.mainFrame:UpdateVisibility()
end

function BarsOptions.prototype:OnLockLoad()
  getglobal(LOCK_CHECK_NAME .. "Text"):SetText(L["Lock Bars"])
  getglobal(LOCK_CHECK_NAME).tooltipText = L["Uncheck to make the bars frame draggable."]
end

function BarsOptions.prototype:OnLockChange(locked)
  if locked then
    db.char.mainFrame.locked = true
    ManaMinder.mainFrame.frame:SetMovable(false)
  else
    db.char.mainFrame.locked = false
    ManaMinder.mainFrame.frame:SetMovable(true)
  end
end

function BarsOptions.prototype:OnTooltipsLoad()
  getglobal(TOOLTIPS_CHECK_NAME .. "Text"):SetText(L["Show Tooltips"])
  getglobal(TOOLTIPS_CHECK_NAME).tooltipText = L["Uncheck to hide tooltips on the bar icons."]
end

function BarsOptions.prototype:OnTooltipsChange(enabled)
  db.char.bars.tooltipsDisabled = not enabled
end

function BarsOptions.prototype:OnWidthLoad()
  getglobal(WIDTH_SLIDER_NAME):SetMinMaxValues(50, 300)
  getglobal(WIDTH_SLIDER_NAME):SetValueStep(1)
  getglobal(WIDTH_SLIDER_NAME).tooltipText = L["Adjust the width of bars."]
end

function BarsOptions.prototype:OnWidthChange(value)
  db.char.mainFrame.width = value
  ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateWidth() end)
  getglobal(WIDTH_SLIDER_NAME .. "Text"):SetText(L["Width: "] .. db.char.mainFrame.width)
end

function BarsOptions.prototype:OnHeightLoad()
  getglobal(HEIGHT_SLIDER_NAME):SetMinMaxValues(10, 50)
  getglobal(HEIGHT_SLIDER_NAME):SetValueStep(1)
  getglobal(HEIGHT_SLIDER_NAME).tooltipText = L["Adjust the height of bars."]
end

function BarsOptions.prototype:OnHeightChange(value)
  db.char.bars.height = value
  ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateHeight() end)
  getglobal(HEIGHT_SLIDER_NAME .. "Text"):SetText(L["Height: "] .. db.char.bars.height)
end

function BarsOptions.prototype:OnFontSizeLoad()
  getglobal(FONT_SIZE_SLIDER_NAME):SetMinMaxValues(6, 20)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValueStep(1)
  getglobal(FONT_SIZE_SLIDER_NAME).tooltipText = L["Adjust the font size of bar text."]
end

function BarsOptions.prototype:OnFontSizeChange(value)
  db.char.bars.fontSize = value
  ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateFontSize() end)
  getglobal(FONT_SIZE_SLIDER_NAME .. "Text"):SetText(L["Font Size: "] .. db.char.bars.fontSize)
end

function BarsOptions.prototype:OnMarginLoad()
  getglobal(MARGIN_SLIDER_NAME):SetMinMaxValues(0, 20)
  getglobal(MARGIN_SLIDER_NAME):SetValueStep(1)
  getglobal(MARGIN_SLIDER_NAME).tooltipText = L["Adjust the spacing between bars."]
end

function BarsOptions.prototype:OnMarginChange(value)
  db.char.bars.margin = value
  ManaMinder.barManager:ForEachBar(function(bar) bar:UpdatePosition() end)
  getglobal(MARGIN_SLIDER_NAME .. "Text"):SetText(L["Margin: "] .. db.char.bars.margin)
end

function BarsOptions.prototype:OnReadyBackgroundLoad()
  getglobal(READY_BACKGROUND_PICKER_NAME .. "Text"):SetText(L["Bar Color"])
  getglobal(READY_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(READY_BACKGROUND_PICKER_NAME, "readyColor", false))
  getglobal(READY_BACKGROUND_PICKER_NAME .. "Button").tooltipText = L["Change the bar color when a consumable is ready to be used."]
end

function BarsOptions.prototype:OnReadyFontLoad()
  getglobal(READY_FONT_PICKER_NAME .. "Text"):SetText(L["Font Color"])
  getglobal(READY_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(READY_FONT_PICKER_NAME, "readyFontColor", false))
  getglobal(READY_FONT_PICKER_NAME .. "Button").tooltipText = L["Change the font color of bar text when a consumable is ready to be used."]
end

function BarsOptions.prototype:OnReadyAlphaLoad()
  getglobal(READY_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1)
  getglobal(READY_ALPHA_SLIDER_NAME):SetValueStep(0.01)
  getglobal(READY_ALPHA_SLIDER_NAME).tooltipText = L["Adjust the alpha of bars for consumables that are ready to be used."]
end

function BarsOptions.prototype:OnReadyAlphaChange(value)
  db.char.bars.readyAlpha = value
  getglobal(READY_ALPHA_SLIDER_NAME .. "Text"):SetText(L["Alpha: "] .. ManaMinder:RoundTo(db.char.bars.readyAlpha, 2))
end

function BarsOptions.prototype:OnReadyTextLoad()
  getglobal(READY_TEXT_BOX_NAME .. "Text"):SetText(L["Text"])
  getglobal(READY_TEXT_BOX_NAME).tooltipText = L["Change the text displayed when a consumable is ready to be used."]
end

function BarsOptions.prototype:OnReadyTextChange(value)
  db.char.bars.readyText = value
end

function BarsOptions.prototype:OnDeficitBackgroundLoad()
  getglobal(DEFICIT_BACKGROUND_PICKER_NAME .. "Text"):SetText(L["Bar Color"])
  getglobal(DEFICIT_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(DEFICIT_BACKGROUND_PICKER_NAME, "deficitColor", false))
  getglobal(DEFICIT_BACKGROUND_PICKER_NAME .. "Button").tooltipText = L["Change the bar color when you do not have the proper mana deficit to use a consumable."]
end

function BarsOptions.prototype:OnDeficitFontLoad()
  getglobal(DEFICIT_FONT_PICKER_NAME .. "Text"):SetText(L["Font Color"])
  getglobal(DEFICIT_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(DEFICIT_FONT_PICKER_NAME, "deficitFontColor", false))
  getglobal(DEFICIT_FONT_PICKER_NAME .. "Button").tooltipText = L["Change the font color of bar text when you do not have the proper mana deficit to use a consumable."]
end

function BarsOptions.prototype:OnDeficitAlphaLoad()
  getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1)
  getglobal(DEFICIT_ALPHA_SLIDER_NAME):SetValueStep(0.01)
  getglobal(DEFICIT_ALPHA_SLIDER_NAME).tooltipText = L["Adjust the alpha of bars where you do not have the proper mana deficit to use a consumable."]
end

function BarsOptions.prototype:OnDeficitAlphaChange(value)
  db.char.bars.deficitAlpha = value
  getglobal(DEFICIT_ALPHA_SLIDER_NAME .. "Text"):SetText(L["Alpha: "] .. ManaMinder:RoundTo(db.char.bars.deficitAlpha, 2))
end

function BarsOptions.prototype:OnDeficitTextLoad()
  getglobal(DEFICIT_TEXT_BOX_NAME .. "Text"):SetText(L["Text"])
  getglobal(DEFICIT_TEXT_BOX_NAME).tooltipText = L["Change the text displayed when you do not have the proper mana deficit to use a consumable. Use \"%deficit%\" to insert the current required deficit."]
end

function BarsOptions.prototype:OnDeficitTextChange(value)
  db.char.bars.deficitText = value
end

function BarsOptions.prototype:OnCooldownBackgroundLoad()
  getglobal(COOLDOWN_BACKGROUND_PICKER_NAME .. "Text"):SetText(L["Bar Color"])
  getglobal(COOLDOWN_BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(COOLDOWN_BACKGROUND_PICKER_NAME, "cooldownColor", false))
  getglobal(COOLDOWN_BACKGROUND_PICKER_NAME .. "Button").tooltipText = L["Change the bar color when a consumable is on cooldown."]
end

function BarsOptions.prototype:OnCooldownFontLoad()
  getglobal(COOLDOWN_FONT_PICKER_NAME .. "Text"):SetText(L["Font Color"])
  getglobal(COOLDOWN_FONT_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(COOLDOWN_FONT_PICKER_NAME, "cooldownFontColor", false))
  getglobal(COOLDOWN_FONT_PICKER_NAME .. "Button").tooltipText = L["Change the font color of bar text when a consumable is on cooldown."]
end

function BarsOptions.prototype:OnCooldownAlphaLoad()
  getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetMinMaxValues(0, 1)
  getglobal(COOLDOWN_ALPHA_SLIDER_NAME):SetValueStep(0.01)
  getglobal(COOLDOWN_ALPHA_SLIDER_NAME).tooltipText = L["Adjust the alpha of bars for consumables on cooldown."]
end

function BarsOptions.prototype:OnCooldownAlphaChange(value)
  db.char.bars.cooldownAlpha = value
  getglobal(COOLDOWN_ALPHA_SLIDER_NAME .. "Text"):SetText(L["Alpha: "] .. ManaMinder:RoundTo(db.char.bars.cooldownAlpha, 2))
end

function BarsOptions.prototype:OnCooldownTextLoad()
  getglobal(COOLDOWN_TEXT_BOX_NAME .. "Text"):SetText(L["Text"])
  getglobal(COOLDOWN_TEXT_BOX_NAME).tooltipText = L["Change the text displayed when a consumable is on cooldown. Use \"%cooldown%\" to insert the current cooldown."]
end

function BarsOptions.prototype:OnCooldownTextChange(value)
  db.char.bars.cooldownText = value
end

function BarsOptions.prototype:OnBackgroundPickerLoad()
  getglobal(BACKGROUND_PICKER_NAME .. "Text"):SetText(L["Background Color"])
  getglobal(BACKGROUND_PICKER_NAME .. "Button"):SetScript("OnClick",
    self:GetColorPickerClickHandler(BACKGROUND_PICKER_NAME, "backgroundColor", true, function()
      ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateBackground() end)
    end))
  getglobal(BACKGROUND_PICKER_NAME .. "Button").tooltipText = L["Change the background color of bars."]
end

function BarsOptions.prototype:OnTextureDropDownLoad()
  local dropdown = this
  dropdown.tooltipText = L["Change the display texture of bars."]

  UIDropDownMenu_Initialize(this, function()
    for _, value in ipairs(ManaMinder.texturesList) do
      local optionValue = value.name
      local info = {}
      info.text = L[value.name]
      info.value = value.name
      info.func = function()
        UIDropDownMenu_SetSelectedID(dropdown, this:GetID())
        db.char.bars.texture = optionValue
        ManaMinder.barManager:ForEachBar(function(bar) bar:UpdateTexture() end)
      end
      info.checked = false
      UIDropDownMenu_AddButton(info, 1)
    end
  end)
  UIDropDownMenu_SetWidth(115, dropdown)
end

function BarsOptions.prototype:GetColorPickerClickHandler(pickerName, optionName, hasOpacity, callback)
  return function()
    local color = db.char.bars[optionName]
    ManaMinder:ShowColorPicker(color[1], color[2], color[3], color[4], hasOpacity, function()
      if not ColorPickerFrame:IsVisible() then
        local r, g, b = ColorPickerFrame:GetColorRGB()
        local a = 1 - OpacitySliderFrame:GetValue()

        if (hasOpacity) then
          db.char.bars[optionName] = { r, g, b, a }
        else
          db.char.bars[optionName] = { r, g, b }
        end

        self:SetSwatchColor(pickerName, db.char.bars[optionName])
        if callback then
          callback()
        end
      end
    end)
  end
end

ManaMinder.optionsFrame.barsFrame = BarsOptions:new()
