local db = nil
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

AlertsOptions = {}
AlertsOptions.__index = AlertsOptions;

function AlertsOptions:new()
  local self = {}
  setmetatable(self, AlertsOptions)
  return self
end

function AlertsOptions:OnInitialize()
  db = ManaMinder.db
  self:ApplyTranslations()
  self:SetInitialValues()
  self:UpdateEnabledChecksState()
end

function AlertsOptions:ApplyTranslations()
  _G[DISPLAY_SECTION_TEXT_NAME]:SetText(L["Display"])
  _G[SOUND_SECTION_TEXT_NAME]:SetText(L["Sound"])
end

function AlertsOptions:SetInitialValues()
  _G[ENABLED_CHECK_NAME]:SetChecked(not db.char.alertFrame.hidden)
  _G[ENABLED_WHEN_HIDDEN_CHECK_NAME]:SetChecked(db.char.alertFrame.showWithoutBars)
  _G[LOCKED_CHECK_NAME]:SetChecked(not db.char.alertFrame.unlocked)
  _G[SOUNDS_ENABLED_CHECK_NAME]:SetChecked(not db.char.alertFrame.soundDisabled)
  _G[TEXT_INPUT_NAME]:SetText(db.char.alertFrame.text)
  _G[DURATION_SLIDER_NAME]:SetValue(db.char.alertFrame.duration)
  _G[ANIMATION_DURATION_SLIDER_NAME]:SetValue(db.char.alertFrame.animationDuration)
  _G[ICON_SIZE_SLIDER_NAME]:SetValue(db.char.alertFrame.size)
  _G[FONT_SIZE_SLIDER_NAME]:SetValue(db.char.alertFrame.fontSize)
  _G[REPEAT_DELAY_SLIDER_NAME]:SetValue(db.char.alertFrame.repeatDelay)
  _G[SOUND_DROPDOWN_NAME .. "Text"]:SetText(db.char.alertFrame.soundType)
end

function AlertsOptions:UpdateEnabledChecksState()
  if db.char.alertFrame.hidden then
    _G[ENABLED_WHEN_HIDDEN_CHECK_NAME]:Disable()
  else
    _G[ENABLED_WHEN_HIDDEN_CHECK_NAME]:Enable()
  end
end

function AlertsOptions:OnEnabledLoad()
  _G[ENABLED_CHECK_NAME .. "Text"]:SetText(L["Show Alerts"])
  _G[ENABLED_CHECK_NAME].tooltipText = L["Uncheck to disable alerts at all times."]
end

function AlertsOptions:OnEnabledChange(enabled)
  db.char.alertFrame.hidden = not enabled
  self:UpdateEnabledChecksState()
end

function AlertsOptions:OnEnabledWhenHiddenLoad()
  _G[ENABLED_WHEN_HIDDEN_CHECK_NAME .. "Text"]:SetText(L["Show Alerts When Bars Hidden"])
  _G[ENABLED_WHEN_HIDDEN_CHECK_NAME].tooltipText = L["Check to continue showing alerts when bars are hidden."]
end

function AlertsOptions:OnEnabledWhenHiddenChange(enabled)
  db.char.alertFrame.showWithoutBars = enabled
end

function AlertsOptions:OnLockedLoad()
  _G[LOCKED_CHECK_NAME .. "Text"]:SetText(L["Lock Alerts"])
  _G[LOCKED_CHECK_NAME].tooltipText = L["Uncheck to make the alert frame draggable."]
end

function AlertsOptions:OnLockedChange(locked)
  db.char.alertFrame.unlocked = not locked
  ManaMinder.alertFrame:OnLockChange(locked)
end

function AlertsOptions:OnSoundsEnabledLoad()
  _G[SOUNDS_ENABLED_CHECK_NAME .. "Text"]:SetText(L["Enable Alert Sound"])
  _G[SOUNDS_ENABLED_CHECK_NAME].tooltipText = L["Uncheck to disable alert sounds."]
end

function AlertsOptions:OnSoundsEnabledChange(enabled)
  db.char.alertFrame.soundDisabled = not enabled
end

function AlertsOptions:OnTextLoad()
  _G[TEXT_INPUT_NAME .. "Text"]:SetText(L["Text"])
  _G[TEXT_INPUT_NAME].tooltipText = L["Change the text displayed with alerts. Use \"%name%\" to insert the name of the consumable."]
end

function AlertsOptions:OnTextChange(value)
  db.char.alertFrame.text = value
end

function AlertsOptions:OnDurationLoad()
  _G[DURATION_SLIDER_NAME]:SetMinMaxValues(1, 10)
  _G[DURATION_SLIDER_NAME]:SetValueStep(1)
  _G[DURATION_SLIDER_NAME].tooltipText = L["Adjust the length of time an alert is displayed."]
end

function AlertsOptions:OnDurationChange(value)
  rounded = floor(value + 0.5)
  db.char.alertFrame.duration = rounded
  _G[DURATION_SLIDER_NAME .. "Text"]:SetText(L["Duration: "] .. rounded .. L["SECONDS"])
end

function AlertsOptions:OnAnimationDurationLoad()
  _G[ANIMATION_DURATION_SLIDER_NAME]:SetMinMaxValues(0, 1)
  _G[ANIMATION_DURATION_SLIDER_NAME]:SetValueStep(0.01)
  _G[ANIMATION_DURATION_SLIDER_NAME].tooltipText = L["Adjust the speed at which an alert fades in and out."]
end

function AlertsOptions:OnAnimationDurationChange(value)
  db.char.alertFrame.animationDuration = value
  _G[ANIMATION_DURATION_SLIDER_NAME .. "Text"]:SetText(L["Animation Duration: "] .. ManaMinder:RoundTo(value, 2) .. L["SECONDS"])
end

function AlertsOptions:OnIconSizeLoad()
  _G[ICON_SIZE_SLIDER_NAME]:SetMinMaxValues(20, 60)
  _G[ICON_SIZE_SLIDER_NAME]:SetValueStep(1)
  _G[ICON_SIZE_SLIDER_NAME].tooltipText = L["Adjust the size of the icon displayed in an alert."]
end

function AlertsOptions:OnIconSizeChange(value)
  rounded = floor(value + 0.5)
  db.char.alertFrame.size = rounded
  ManaMinder.alertFrame:UpdateSize()
  _G[ICON_SIZE_SLIDER_NAME .. "Text"]:SetText(L["Icon Size: "] .. rounded)
end

function AlertsOptions:OnFontSizeLoad()
  _G[FONT_SIZE_SLIDER_NAME]:SetMinMaxValues(10, 40)
  _G[FONT_SIZE_SLIDER_NAME]:SetValueStep(1)
  _G[FONT_SIZE_SLIDER_NAME].tooltipText = L["Adjust the font size of the text displayed in an alert."]
end

function AlertsOptions:OnFontSizeChange(value)
  rounded = floor(value + 0.5)
  db.char.alertFrame.fontSize = rounded
  ManaMinder.alertFrame:UpdateFontSize()
  _G[FONT_SIZE_SLIDER_NAME .. "Text"]:SetText(L["Font Size: "] .. rounded)
end

function AlertsOptions:OnRepeatDelayLoad()
  _G[REPEAT_DELAY_SLIDER_NAME]:SetMinMaxValues(0, 20)
  _G[REPEAT_DELAY_SLIDER_NAME]:SetValueStep(1)
  _G[REPEAT_DELAY_SLIDER_NAME].tooltipText = L["Adjust the length of time a consumable needs to be not ready before a new alert is shown again. This prevents multiple alerts when hovering around the required deficit for a consumable."]
end

function AlertsOptions:OnRepeatDelayChange(value)
  rounded = floor(value + 0.5)
  db.char.alertFrame.repeatDelay = rounded
  _G[REPEAT_DELAY_SLIDER_NAME .. "Text"]:SetText(L["Repeat Delay: "] .. rounded .. L["SECONDS"])
end

function AlertsOptions:OnSoundDropDownLoad()
  local dropdown = _G[SOUND_DROPDOWN_NAME]
  dropdown.tooltipText = L["Change the sound played when an alert occurs."]

  UIDropDownMenu_Initialize(dropdown, function()
    for _, value in ipairs(ManaMinder.soundsList) do
      local info = {}
      info.text = value.name
      info.value = value.name
      info.func = function()
        db.char.alertFrame.soundType = value.name
        _G[SOUND_DROPDOWN_NAME .. "Text"]:SetText(db.char.alertFrame.soundType)
      end
      info.checked = db and value.name == db.char.alertFrame.soundType or false
      UIDropDownMenu_AddButton(info, 1)
    end
  end)
  UIDropDownMenu_SetWidth(dropdown, 150)
end

function AlertsOptions:OnSoundTestClick()
  ManaMinder:PlaySound(db.char.alertFrame.soundType)
end

ManaMinder.optionsFrame.alertsFrame = AlertsOptions:new()
