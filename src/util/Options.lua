function ManaMinder:ShowColorPicker(r, g, b, a, hasOpacity, callback)
  ColorPickerFrame.func = callback
  ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")

  ColorPickerFrame.hasOpacity = hasOpacity
  if hasOpacity then
    ColorPickerFrame.opacityFunc = ColorPickerFrame.func
    ColorPickerFrame.opacity = 1 - a
  else
    ColorPickerFrame.opacityFunc = nil
  end

  ColorPickerFrame:Hide() -- Need to run the OnShow handler.
  ColorPickerFrame:Show()
  ColorPickerFrame:SetColorRGB(r,g,b)
end

function ManaMinder:PlaySound(key)
  local data = ManaMinder.sounds[key]
  if data.type == "FILE" then
    PlaySoundFile(data.path)
  else
    PlaySound(data.path)
  end
end

function ManaMinder:OnCheckBoxClick()
  if ( this:GetChecked() ) then
    PlaySound("igMainMenuOptionCheckBoxOff");
  else
    PlaySound("igMainMenuOptionCheckBoxOn");
  end
end
