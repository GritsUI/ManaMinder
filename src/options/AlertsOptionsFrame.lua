local AceOO = AceLibrary("AceOO-2.0")
local AlertsOptions = AceOO.Class()
local db = ManaMinder.db

local ENABLED_CHECK_NAME = "ManaMinder_Options_Alerts_Enabled_Check"
local SOUNDS_ENABLED_CHECK_NAME = "ManaMinder_Options_Alerts_Sounds_Enabled_Check"
local TEXT_INPUT_NAME = "ManaMinder_Options_Alerts_Text"
local DURATION_SLIDER_NAME = "ManaMinder_Options_Alerts_Duration_Slider"
local ANIMATION_DURATION_SLIDER_NAME = "ManaMinder_Options_Alerts_Animation_Duration_Slider"
local ICON_SIZE_SLIDER_NAME = "ManaMinder_Options_Alerts_Icon_Size_Slider"
local FONT_SIZE_SLIDER_NAME = "ManaMinder_Options_Alerts_Font_Size_Slider"
local SOUND_DROPDOWN_NAME = "ManaMinder_Options_Alerts_Sound_DropDown"

function AlertsOptions.prototype:init()
  AlertsOptions.super.prototype.init(self)
end

function AlertsOptions.prototype:OnInitialize()
  getglobal(ENABLED_CHECK_NAME):SetChecked(db.char.alertFrame.enabled)
  getglobal(SOUNDS_ENABLED_CHECK_NAME):SetChecked(db.char.alertFrame.soundEnabled)
  getglobal(TEXT_INPUT_NAME):SetText(db.char.alertFrame.text)
  getglobal(DURATION_SLIDER_NAME):SetValue(db.char.alertFrame.duration)
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetValue(db.char.alertFrame.animationDuration)
  getglobal(ICON_SIZE_SLIDER_NAME):SetValue(db.char.alertFrame.size)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValue(db.char.alertFrame.fontSize)
  UIDropDownMenu_SetSelectedValue(getglobal(SOUND_DROPDOWN_NAME), db.char.alertFrame.soundType)
  UIDropDownMenu_SetText(db.char.alertFrame.soundType, getglobal(SOUND_DROPDOWN_NAME))
end

function AlertsOptions.prototype:OnEnabledLoad()
  getglobal(ENABLED_CHECK_NAME .. "Text"):SetText("Show Alerts")
end

function AlertsOptions.prototype:OnEnabledChange(enabled)
  db.char.alertFrame.enabled = enabled
end

function AlertsOptions.prototype:OnSoundsEnabledLoad()
  getglobal(SOUNDS_ENABLED_CHECK_NAME .. "Text"):SetText("Enable Alert Sound")
end

function AlertsOptions.prototype:OnSoundsEnabledChange(enabled)
  db.char.alertFrame.soundEnabled = enabled
end

function AlertsOptions.prototype:OnTextLoad()
  getglobal(TEXT_INPUT_NAME .. "Text"):SetText("Text")
end

function AlertsOptions.prototype:OnTextChange(value)
  db.char.alertFrame.text = value
end

function AlertsOptions.prototype:OnDurationLoad()
  getglobal(DURATION_SLIDER_NAME):SetMinMaxValues(1, 10)
  getglobal(DURATION_SLIDER_NAME):SetValueStep(1)
end

function AlertsOptions.prototype:OnDurationChange(value)
  db.char.alertFrame.duration = value
  getglobal(DURATION_SLIDER_NAME .. "Text"):SetText("Duration: " ..db.char.alertFrame.duration .. "s")
end

function AlertsOptions.prototype:OnAnimationDurationLoad()
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetMinMaxValues(0, 1)
  getglobal(ANIMATION_DURATION_SLIDER_NAME):SetValueStep(0.01)
end

function AlertsOptions.prototype:OnAnimationDurationChange(value)
  db.char.alertFrame.animationDuration = value
  getglobal(ANIMATION_DURATION_SLIDER_NAME .. "Text"):SetText("Animation Duration: " .. ManaMinder:RoundTo(value, 2) .. "s")
end

function AlertsOptions.prototype:OnIconSizeLoad()
  getglobal(ICON_SIZE_SLIDER_NAME):SetMinMaxValues(20, 60)
  getglobal(ICON_SIZE_SLIDER_NAME):SetValueStep(1)
end

function AlertsOptions.prototype:OnIconSizeChange(value)
  db.char.alertFrame.size = value
  ManaMinder.alertFrame:UpdateSize()
  getglobal(ICON_SIZE_SLIDER_NAME .. "Text"):SetText("Icon Size: " .. value)
end

function AlertsOptions.prototype:OnFontSizeLoad()
  getglobal(FONT_SIZE_SLIDER_NAME):SetMinMaxValues(10, 40)
  getglobal(FONT_SIZE_SLIDER_NAME):SetValueStep(1)
end

function AlertsOptions.prototype:OnFontSizeChange(value)
  db.char.alertFrame.fontSize = value
  ManaMinder.alertFrame:UpdateFontSize()
  getglobal(FONT_SIZE_SLIDER_NAME .. "Text"):SetText("Font Size: " .. value)
end

function AlertsOptions.prototype:OnSoundDropDownLoad()
  local dropdown = getglobal(SOUND_DROPDOWN_NAME)
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
