local AceOO = AceLibrary("AceOO-2.0")
local Options = AceOO.Class()
local L = ManaMinder.L

local TITLE_NAME = "ManaMinder_Options_Title"
local OKAY_BUTTON_NAME = "ManaMinder_Options_Okay_Button"
local CONSUMABLES_TAB_NAME = "ManaMinder_OptionsTab1"
local BARS_TAB_NAME = "ManaMinder_OptionsTab2"
local ALERTS_TAB_NAME = "ManaMinder_OptionsTab3"

function Options.prototype:init()
  Options.super.prototype.init(self)
end

function Options.prototype:OnLoad(frame)
  self.frame = frame
  self.isOpen = false
  PanelTemplates_SetNumTabs(frame, 3)
  PanelTemplates_SetTab(frame, 1)
end

function Options.prototype:OnInitialize()
  self:ApplyTranslations()
  self.barsFrame:OnInitialize()
  self.consumablesFrame:OnInitialize()
  self.alertsFrame:OnInitialize()
end

function Options.prototype:ApplyTranslations()
  getglobal(TITLE_NAME):SetText(L["ManaMinder Options"])
  getglobal(OKAY_BUTTON_NAME):SetText(L["Okay"])
  getglobal(CONSUMABLES_TAB_NAME):SetText(L["Consumables"])
  getglobal(BARS_TAB_NAME):SetText(L["Bars"])
  getglobal(ALERTS_TAB_NAME):SetText(L["Alerts"])
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
    ManaMinder_Options_Consumables:Show()
  elseif tabName == "ManaMinder_OptionsTab2" then
    ManaMinder_Options_Bars:Show()
  elseif tabName == "ManaMinder_OptionsTab3" then
    ManaMinder_Options_Alerts:Show()
  end
end

function Options.prototype:OnOptionsFrameBoxLoad(box)
  box:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.9)
  box:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
end

function Options.prototype:HideSections()
  ManaMinder_Options_Bars:Hide()
  ManaMinder_Options_Consumables:Hide()
  ManaMinder_Options_Alerts:Hide()
end

function Options.prototype:Open()
  PlaySound("igMainMenuOption");
  self.frame:Show()
  self.isOpen = true
end

function Options.prototype:Close()
  PlaySound("gsTitleOptionOK");
  self.frame:Hide()
  self.isOpen = false
end

function Options.prototype:Toggle()
  if self.isOpen then
    self:Close()
  else
    self:Open()
  end
end

ManaMinder.optionsFrame = Options:new()
