local L = ManaMinder.L

local TITLE_NAME = "ManaMinder_Options_Title"
local OKAY_BUTTON_NAME = "ManaMinder_Options_Okay_Button"
local CONSUMABLES_TAB_NAME = "ManaMinder_OptionsTab1"
local BARS_TAB_NAME = "ManaMinder_OptionsTab2"
local ALERTS_TAB_NAME = "ManaMinder_OptionsTab3"

Options = {}
Options.__index = Options;

function Options:new()
  local self = {}
  setmetatable(self, Options)
  return self
end

function Options:OnLoad(frame)
  self.frame = frame
  self.frame:SetMovable(true)
  self.frame:RegisterForDrag("LeftButton")
  self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
  self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

  self.isOpen = false
  PanelTemplates_SetNumTabs(frame, 3)
  PanelTemplates_SetTab(frame, 1)
end

function Options:OnInitialize()
  self:ApplyTranslations()
  self.barsFrame:OnInitialize()
  self.consumablesFrame:OnInitialize()
  self.alertsFrame:OnInitialize()
end

function Options:ApplyTranslations()
  getglobal(TITLE_NAME):SetText(L["ManaMinder Options"])
  getglobal(OKAY_BUTTON_NAME):SetText(L["Okay"])
  getglobal(CONSUMABLES_TAB_NAME):SetText(L["Consumables"])
  getglobal(BARS_TAB_NAME):SetText(L["Bars"])
  getglobal(ALERTS_TAB_NAME):SetText(L["Alerts"])
end

function Options:OnDragStart()
  self.frame:StartMoving()
end

function Options:OnDragStop()
  self.frame:StopMovingOrSizing()
end

function Options:OnTabLoad(tab)
  tab:SetFrameLevel(tab:GetFrameLevel() + 4)
end

function Options:OnTabShow(tab)
  PanelTemplates_TabResize(tab, 0, nil, 32, 88);
end

function Options:OnTabClick(tab)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
  PanelTemplates_Tab_OnClick(tab, self.frame)

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

function Options:OnOptionsFrameBoxLoad(box)
  box:SetBackdropBorderColor(0.3, 0.3, 0.3)
  box:SetBackdropColor(0.1, 0.1, 0.1)
end

function Options:HideSections()
  ManaMinder_Options_Bars:Hide()
  ManaMinder_Options_Consumables:Hide()
  ManaMinder_Options_Alerts:Hide()
end

function Options:Open()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
  self.frame:Show()
  self.isOpen = true
end

function Options:Close()
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  self.frame:Hide()
  self.isOpen = false
end

function Options:Toggle()
  if self.isOpen then
    self:Close()
  else
    self:Open()
  end
end

ManaMinder.optionsFrame = Options:new()
