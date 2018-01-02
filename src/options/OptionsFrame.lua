local AceOO = AceLibrary("AceOO-2.0")
local Options = AceOO.Class()

function Options.prototype:init()
  Options.super.prototype.init(self)
end

function Options.prototype:OnLoad(frame)
  self.frame = frame
  PanelTemplates_SetNumTabs(frame, 3)
  PanelTemplates_SetTab(frame, 1)
end

function Options.prototype:OnInitialize()
  self.generalFrame:OnInitialize()
  self.barsFrame:OnInitialize()
  self.consumablesFrame:OnInitialize()
end

function Options.prototype:OnTabLoad(tab)
  tab:SetFrameLevel(tab:GetFrameLevel() + 4)
end

function Options.prototype:OnTabShow(tab)
  PanelTemplates_TabResize(0)
  getglobal(tab:GetName().."HighlightTexture"):SetWidth(tab:GetTextWidth() + 30)
end

function Options.prototype:OnTabClick(tab)
  PlaySound("igCharacterInfoTab")
  PanelTemplates_Tab_OnClick(self.frame)
  self:HideSections()

  local tabName = tab:GetName()
  if tabName == "ManaMinder_OptionsTab1" then
    ManaMinder_Options_General:Show()
  elseif tabName == "ManaMinder_OptionsTab2" then
    ManaMinder_Options_Bars:Show()
  elseif tabName == "ManaMinder_OptionsTab3" then
    ManaMinder_Options_Consumables:Show()
  end
end

function Options.prototype:OnOptionsFrameBoxLoad(box)
  box:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.9)
  box:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
end

function Options.prototype:HideSections()
  ManaMinder_Options_General:Hide()
  ManaMinder_Options_Bars:Hide()
  ManaMinder_Options_Consumables:Hide()
end

function Options.prototype:Open()
  self.frame:Show()
end

function Options.prototype:Close()
  self.frame:Hide()
end

ManaMinder.optionsFrame = Options:new()
