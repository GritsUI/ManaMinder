local AceOO = AceLibrary("AceOO-2.0")
local AlertsOptions = AceOO.Class()
local db = ManaMinder.db
local L = ManaMinder.L

local DISPLAY_SECTION_TEXT_NAME = "ManaMinder_Options_Alerts_Display_SectionText"
local SOUND_SECTION_TEXT_NAME = "ManaMinder_Options_Alerts_Sounds_SectionText"

local ENABLED_CHECK_NAME = "ManaMinder_Options_Alerts_Enabled_Check"
local ENABLED_WHEN_HIDDEN_CHECK_NAME = "ManaMinder_Options_Alerts_Enabled_When_Hidden_Check"
local LOCKED_CHECK_NAME = "ManaMinder_Options_Alerts_Locked_Check"
local SOUNDS_ENABLED_CHECK_NAME = "ManaMinder_Options_Alerts_Sounds_Enabled_Check"
local TEXT_INPUT_NAME = "ManaMinder_Options_Alerts_Text"
local DURATION_SLIDER_NAME = "ManaMinder_Options_Alerts_Duration_Slider"
local ANIMATION_DURATION_SLIDER_NAME = "ManaMinder_Options_Alerts_Animation_Duration_Slider"
local ICON_SIZE_SLIDER_NAME = "ManaMinder_Options_Alerts_Icon_Size_Slider"
local FONT_SIZE_SLIDER_NAME = "ManaMinder_Options_Alerts_Font_Size_Slider"
local REPEAT_DELAY_SLIDER_NAME = "ManaMinder_Options_Alerts_Repeat_Delay_Slider"
local SOUND_DROPDOWN_NAME = "ManaMinder_Options_Alerts_Sound_DropDown"

function AlertsOptions.prototype:init()
  AlertsOptions.super.prototype.init(self)
end

function AlertsOptions.prototype:OnInitialize()
  self:ApplyTranslations()
  self:SetInitialValues()
  self:UpdateEnabledChecksState()
end

function AlertsOptions.prototype:ApplyTranslations()
  getglobal(DISPLAY_SECTION_TEXT_NAME):SetText(L["Display"])
  getglobal(SOUND_SECTION_TEXT_NAME):SetText(L["Sound"])
  getglobal(SOUND_DROPDOWN_NAME .. "_Text"):SetText(L["Sound"])
end

function AlertsOptions.prototype:SetInitialValues()
  getglobal(ENABLED_CHECK_NAME):SetChecked(not db.char.alertFrame.hidden)
  getglobal(ENABLED_WHEN_HIDDEN_CHECK_NAME):SetChecked(db.char.alertFrame.showWithoutBars)
  getglobal(LOCKED_CHECK_NAME):SetChecked(not db.char.alertFrame.unlocked)
  getglobal(SOUNDS_ENABLED_CHECK_NAME):SetChecked(not db.char.alertFrame.soundDisabled)
  getglobal(TEXT_INPUT_NAME):SetText(db.char.alertFrame.text)
  getglobal(DURATION_SLIDER_NAME):SetValue(db.char.alertFrame.duration)
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetValue(db.char.alertFrame.animationDuration)
  getglobal(ICON_SIZE_SLIDER_NAME):SetValue(db.char.alertFrame.size)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValue(db.char.alertFrame.fontSize)
  getglobal(REPEAT_DELAY_SLIDER_NAME):SetValue(db.char.alertFrame.repeatDelay)
  UIDropDownMenu_SetSelectedValue(getglobal(SOUND_DROPDOWN_NAME), db.char.alertFrame.soundType)
  UIDropDownMenu_SetText(db.char.alertFrame.soundType, getglobal(SOUND_DROPDOWN_NAME))
end

function AlertsOptions.prototype:UpdateEnabledChecksState()
  if db.char.alertFrame.hidden then
    OptionsFrame_DisableCheckBox(getglobal(ENABLED_WHEN_HIDDEN_CHECK_NAME))
  else
    OptionsFrame_EnableCheckBox(getglobal(ENABLED_WHEN_HIDDEN_CHECK_NAME))
  end
end

function AlertsOptions.prototype:OnEnabledLoad()
  getglobal(ENABLED_CHECK_NAME .. "Text"):SetText(L["Show Alerts"])
  getglobal(ENABLED_CHECK_NAME).tooltipText = L["Uncheck to disable alerts at all times."]
end

function AlertsOptions.prototype:OnEnabledChange(enabled)
  db.char.alertFrame.hidden = not enabled
  self:UpdateEnabledChecksState()
end

function AlertsOptions.prototype:OnEnabledWhenHiddenLoad()
  getglobal(ENABLED_WHEN_HIDDEN_CHECK_NAME .. "Text"):SetText(L["Show Alerts When Bars Hidden"])
  getglobal(ENABLED_WHEN_HIDDEN_CHECK_NAME).tooltipText = L["Check to continue showing alerts when bars are hidden."]
end

function AlertsOptions.prototype:OnEnabledWhenHiddenChange(enabled)
  db.char.alertFrame.showWithoutBars = enabled
end

function AlertsOptions.prototype:OnLockedLoad()
  getglobal(LOCKED_CHECK_NAME .. "Text"):SetText(L["Lock Alerts"])
  getglobal(LOCKED_CHECK_NAME).tooltipText = L["Uncheck to make the alert frame draggable."]
end

function AlertsOptions.prototype:OnLockedChange(locked)
  db.char.alertFrame.unlocked = not locked
  ManaMinder.alertFrame:OnLockChange(locked)
end

function AlertsOptions.prototype:OnSoundsEnabledLoad()
  getglobal(SOUNDS_ENABLED_CHECK_NAME .. "Text"):SetText(L["Enable Alert Sound"])
  getglobal(SOUNDS_ENABLED_CHECK_NAME).tooltipText = L["Uncheck to disable alert sounds."]
end

function AlertsOptions.prototype:OnSoundsEnabledChange(enabled)
  db.char.alertFrame.soundDisabled = not enabled
end

function AlertsOptions.prototype:OnTextLoad()
  getglobal(TEXT_INPUT_NAME .. "Text"):SetText(L["Text"])
  getglobal(TEXT_INPUT_NAME).tooltipText = L["Change the text displayed with alerts. Use \"%name%\" to insert the name of the consumable."]
end

function AlertsOptions.prototype:OnTextChange(value)
  db.char.alertFrame.text = value
end

function AlertsOptions.prototype:OnDurationLoad()
  getglobal(DURATION_SLIDER_NAME):SetMinMaxValues(1, 10)
  getglobal(DURATION_SLIDER_NAME):SetValueStep(1)
  getglobal(DURATION_SLIDER_NAME).tooltipText = L["Adjust the length of time an alert is displayed."]
end

function AlertsOptions.prototype:OnDurationChange(value)
  db.char.alertFrame.duration = value
  getglobal(DURATION_SLIDER_NAME .. "Text"):SetText(L["Duration: "] .. value .. L["SECONDS"])
end

function AlertsOptions.prototype:OnAnimationDurationLoad()
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetMinMaxValues(0, 1)
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetValueStep(0.01)
  getglobal(ANIMATION_DURATION_SLIDER_NAME).tooltipText = L["Adjust the speed at which an alert fades in and out."]
end

function AlertsOptions.prototype:OnAnimationDurationChange(value)
  db.char.alertFrame.animationDuration = value
  getglobal(ANIMATION_DURATION_SLIDER_NAME .. "Text"):SetText(L["Animation Duration: "] .. ManaMinder:RoundTo(value, 2) .. L["SECONDS"])
end

function AlertsOptions.prototype:OnIconSizeLoad()
  getglobal(ICON_SIZE_SLIDER_NAME):SetMinMaxValues(20, 60)
  getglobal(ICON_SIZE_SLIDER_NAME):SetValueStep(1)
  getglobal(ICON_SIZE_SLIDER_NAME).tooltipText = L["Adjust the size of the icon displayed in an alert."]
end

function AlertsOptions.prototype:OnIconSizeChange(value)
  db.char.alertFrame.size = value
  ManaMinder.alertFrame:UpdateSize()
  getglobal(ICON_SIZE_SLIDER_NAME .. "Text"):SetText(L["Icon Size: "] .. value)
end

function AlertsOptions.prototype:OnFontSizeLoad()
  getglobal(FONT_SIZE_SLIDER_NAME):SetMinMaxValues(10, 40)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValueStep(1)
  getglobal(FONT_SIZE_SLIDER_NAME).tooltipText = L["Adjust the font size of the text displayed in an alert."]
end

function AlertsOptions.prototype:OnFontSizeChange(value)
  db.char.alertFrame.fontSize = value
  ManaMinder.alertFrame:UpdateFontSize()
  getglobal(FONT_SIZE_SLIDER_NAME .. "Text"):SetText(L["Font Size: "] .. value)
end

function AlertsOptions.prototype:OnRepeatDelayLoad()
  getglobal(REPEAT_DELAY_SLIDER_NAME):SetMinMaxValues(0, 20)
  getglobal(REPEAT_DELAY_SLIDER_NAME):SetValueStep(1)
  getglobal(REPEAT_DELAY_SLIDER_NAME).tooltipText = L["Adjust the length of time a consumable needs to be not ready before a new alert is shown again. This prevents multiple alerts when hovering around the required deficit for a consumable."]
end

function AlertsOptions.prototype:OnRepeatDelayChange(value)
  db.char.alertFrame.repeatDelay = value
  getglobal(REPEAT_DELAY_SLIDER_NAME .. "Text"):SetText(L["Repeat Delay: "] .. value .. L["SECONDS"])
end

function AlertsOptions.prototype:OnSoundDropDownLoad()
  local dropdown = getglobal(SOUND_DROPDOWN_NAME)
  dropdown.tooltipText = L["Change the sound played when an alert occurs."]

  UIDropDownMenu_Initialize(this, function()
    for _, value in ipairs(ManaMinder.soundsList) do
      local info = {}
      info.text = value.name
      info.value = value.name
      info.func = function()
        UIDropDownMenu_SetSelectedID(dropdown, this:GetID())
        db.char.alertFrame.soundType = UIDropDownMenu_GetText(dropdown)
      end
      info.checked = false
      UIDropDownMenu_AddButton(info, 1)
    end
  end)
  UIDropDownMenu_SetWidth(150, dropdown)
end

function AlertsOptions.prototype:OnSoundTestClick()
  ManaMinder:PlaySound(db.char.alertFrame.soundType)
end

ManaMinder.optionsFrame.alertsFrame = AlertsOptions:new()
