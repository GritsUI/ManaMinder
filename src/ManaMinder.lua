ManaMinder = LibStub("AceAddon-3.0"):NewAddon("ManaMinder", "AceEvent-3.0", "AceConsole-3.0")
ManaMinder.minimapIcon = LibStub("LibDBIcon-1.0")
ManaMinder.L = LibStub("AceLocale-3.0"):GetLocale("ManaMinder", true)
local L = ManaMinder.L

BINDING_HEADER_MANAMINDER = "ManaMinder";
BINDING_NAME_MANAMINDER_CONSUME = "Use next consumable";

function ManaMinder:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("ManaMinderDB", ManaMinder.defaults)

  self:LocalizeKeyBindings()
  self:InitializeMinimapIcon()
  self:InitializeSlashCommands()

  ManaMinder.controller = self
  ManaMinder.barManager:OnInitialize()
  ManaMinder.stateManager:OnInitialize()
  ManaMinder.mainFrame:OnInitialize()
  ManaMinder.alertFrame:OnInitialize()
  ManaMinder.optionsFrame:OnInitialize()

  ManaMinder:Print(L["Addon Loaded. Type /mana for slash commands"])
end

function ManaMinder:LocalizeKeyBindings()
  BINDING_HEADER_MANAMINDER = L["ManaMinder"];
  BINDING_NAME_MANAMINDER_CONSUME = L["Use next consumable"];
end

function ManaMinder:InitializeMinimapIcon()
  local obj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ManaMinder", {
    type = "launcher",
    text = "ManaMinder",
    icon = "Interface/Icons/INV_Potion_76",
    OnClick = function(self, button)
      if button == "LeftButton" then
        ManaMinder:Config()
      elseif button == "RightButton" then
        if ManaMinder.db.char.mainFrame.hidden == true then
          ManaMinder:Show()
        else
          ManaMinder:Hide()
        end
      end
    end,
    OnEnter = function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT")
      GameTooltip:AddLine("|cFFFFFFFFManaMinder|r")
      GameTooltip:AddLine("Left click to open settings.")
      GameTooltip:AddLine("Right click to show/hide bars.")
      GameTooltip:Show()
    end,
    OnLeave = function(self)
      GameTooltip:Hide()
    end
  })
  ManaMinder.minimapIcon:Register("ManaMinder", obj)
end

function ManaMinder:InitializeSlashCommands()
  SLASH_MANAMINDER1 = "/mana"
  SLASH_MANAMINDER2 = "/manaminder"
  SLASH_MANAMINDER3 = "/mm"
  SlashCmdList["MANAMINDER"] = function(msg)
    msg = msg:lower()
    if msg == "show" then
      ManaMinder:Show()
    elseif msg == "hide" then
      ManaMinder:Hide()
    elseif msg == "lock" then
      ManaMinder:Lock()
    elseif msg == "unlock" then
      ManaMinder:Unlock()
    elseif msg == "help" then
      ManaMinder:Print(
        "\n"
        .. "/mana or /mm to toggle the settings panel\n"
        .. "/mana show to show bars\n"
        .. "/mana hide to hide bars\n"
        .. "/mana lock to lock bars\n"
        .. "/mana unlock to unlock bars\n"
      )
    else
      ManaMinder:Config()
    end
  end
end

function ManaMinder:Config()
  ManaMinder.optionsFrame:Toggle()
end

function ManaMinder:Hide(noMessage)
  ManaMinder.mainFrame.frame:Hide()
  ManaMinder.db.char.mainFrame.hidden = true
  ManaMinder_Options_Bars_Show_Check:SetChecked(false)
  ManaMinder.optionsFrame.barsFrame:UpdateShowChecksState()

  if not noMessage then
    ManaMinder:Print(L["Frames hidden"])
  end
end

function ManaMinder:Show(noMessage)
  ManaMinder.mainFrame.frame:Show()
  ManaMinder.db.char.mainFrame.hidden = false
  ManaMinder_Options_Bars_Show_Check:SetChecked(true)
  ManaMinder.optionsFrame.barsFrame:UpdateShowChecksState()

  if not noMessage then
    ManaMinder:Print(L["Frames shown"])
  end
end

function ManaMinder:Lock(noMessage)
  ManaMinder.mainFrame.frame:SetMovable(false)
  ManaMinder.db.char.mainFrame.locked = true
  ManaMinder_Options_Bars_Lock_Check:SetChecked(true)

  if not noMessage then
    ManaMinder:Print(L["Frames locked"])
  end
end

function ManaMinder:Unlock(noMessage)
  ManaMinder.mainFrame.frame:SetMovable(true)
  ManaMinder.db.char.mainFrame.locked = false
  ManaMinder_Options_Bars_Lock_Check:SetChecked(false)

  if not noMessage then
    ManaMinder:Print(L["Frames unlocked"])
  end
end

function ManaMinder:Consume()
  local combatCheck = not ManaMinder.db.char.onlyUseInCombat
    or (ManaMinder.mainFrame.inCombat and ManaMinder.mainFrame:GetTimeInCombat() >= 3)

  if combatCheck and ManaMinder.barManager.barFrames[1] then
    ManaMinder.barManager.barFrames[1]:Consume()
  end
end
