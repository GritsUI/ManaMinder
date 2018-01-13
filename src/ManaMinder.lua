ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "AceConsole-2.0")
ManaMinder:RegisterDB("ManaMinderDB", "ManaMinderCharDB")
ManaMinder.L = AceLibrary("AceLocale-2.2"):new("ManaMinder")
local L = ManaMinder.L

function ManaMinder:OnInitialize()
  ManaMinder.controller = self
  ManaMinder:RegisterDefaults('profile', ManaMinder.defaults.profile)
  ManaMinder:RegisterDefaults('char', ManaMinder.defaults.char)

  ManaMinder.mainFrame:OnInitialize()
  ManaMinder.alertFrame:OnInitialize()
  ManaMinder.optionsFrame:OnInitialize()

  ManaMinder:RegisterChatCommand({'/mana'}, ManaMinder:GetChatCommandOptions())
  ManaMinder:SystemMessage(L["Addon Loaded. Type /mana for slash commands"])
end

function ManaMinder:GetChatCommandOptions()
  return {
    type = "group",
    args = {
      config = {name = L["Config"], desc = L["Open configuration window"], type = "execute", func = "Config"},
      hide = {name = L["Hide"], desc = L["Hides all frames"], type = "execute", func = "Hide"},
      show = {name = L["Show"], desc = L["Shows all frames"], type = "execute", func = "Show"},
      lock = {name = L["Lock"], desc = L["Lock all frames"], type = "execute", func = "Lock" },
      unlock = {name = L["Unlock"], desc = L["Unlock all frames"], type = "execute", func = "Unlock"},
      consume = {name = L["Consume"], desc = L["Uses highest priority consumable, if any available with proper mana deficit"], type = "execute", func = "Consume"}
    }
  }
end

function ManaMinder:Config()
  ManaMinder.optionsFrame:Toggle()
end

function ManaMinder:Hide()
  ManaMinder.mainFrame.frame:Hide()
  ManaMinder.db.char.mainFrame.hidden = true
  ManaMinder_Options_Bars_Show_Check:SetChecked(false)
  ManaMinder.optionsFrame.barsFrame:UpdateShowChecksState()
  ManaMinder:SystemMessage(L["Frames hidden"])
end

function ManaMinder:Show()
  ManaMinder.mainFrame.frame:Show()
  ManaMinder.db.char.mainFrame.hidden = false
  ManaMinder_Options_Bars_Show_Check:SetChecked(true)
  ManaMinder.optionsFrame.barsFrame:UpdateShowChecksState()
  ManaMinder:SystemMessage(L["Frames shown"])
end

function ManaMinder:Lock()
  ManaMinder.mainFrame.frame:SetMovable(false)
  ManaMinder.db.char.mainFrame.locked = true
  ManaMinder_Options_Bars_Lock_Check:SetChecked(true)
  ManaMinder:SystemMessage(L["Frames locked"])
end

function ManaMinder:Unlock()
  ManaMinder.mainFrame.frame:SetMovable(true)
  ManaMinder.db.char.mainFrame.locked = false
  ManaMinder_Options_Bars_Lock_Check:SetChecked(false)
  ManaMinder:SystemMessage(L["Frames unlocked"])
end

function ManaMinder:Consume()
  if ManaMinder.barManager.barFrames[1] then
    ManaMinder.barManager.barFrames[1]:Consume()
  end
end
