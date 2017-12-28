ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "AceConsole-2.0")
ManaMinder:RegisterDB("ManaMinderDB")

function ManaMinder:OnInitialize()
    ManaMinder.controller = self
    ManaMinder:RegisterDefaults('profile', ManaMinder.defaults.profile)

    ManaMinder.mainFrame:OnInitialize()
    ManaMinder.optionsFrame:OnInitialize()

    ManaMinder:RegisterChatCommand({'/mana'}, ManaMinder:GetChatCommandOptions())
    ManaMinder:SystemMessage("Addon Loaded. Type /mana for slash commands")
end

function ManaMinder:GetChatCommandOptions()
    return {
        type = "group",
        args = {
            config = {name = "Config", desc = "Open configuration window", type = "execute", func = "Config"},
            hide = {name = "Hide", desc = "Hides all frames", type = "execute", func = "Hide"},
            show = {name = "Show", desc = "Shows all frames", type = "execute", func = "Show"},
            lock = {name = "Lock", desc = "Lock all frames", type = "execute", func = "Lock" },
            unlock = {name = "Unlock", desc = "Unlock all frames", type = "execute", func = "Unlock"},
            consume = {name = "Consume", desc = "Uses highest priority consumable, if any available with proper mana deficit", type = "execute", func = "Consume"}
        }
    }
end

function ManaMinder:Config()
    ManaMinder.optionsFrame:Open()
end

function ManaMinder:Hide()
    ManaMinder.mainFrame.frame:Hide()
    ManaMinder.db.profile.mainFrame.hidden = true
    ManaMinder_Options_General_Hide_Check:SetChecked(true);
    ManaMinder:SystemMessage("Frames hidden")
end

function ManaMinder:Show()
    ManaMinder.mainFrame.frame:Show()
    ManaMinder.db.profile.mainFrame.hidden = false
    ManaMinder_Options_General_Hide_Check:SetChecked(false);
    ManaMinder:SystemMessage("Frames shown")
end

function ManaMinder:Lock()
    ManaMinder.mainFrame.frame:SetMovable(false)
    ManaMinder.db.profile.mainFrame.locked = true
    ManaMinder_Options_General_Lock_Check:SetChecked(true);
    ManaMinder:SystemMessage("Frames locked")
end

function ManaMinder:Unlock()
    ManaMinder.mainFrame.frame:SetMovable(true)
    ManaMinder.db.profile.mainFrame.locked = false
    ManaMinder_Options_General_Lock_Check:SetChecked(false);
    ManaMinder:SystemMessage("Frames unlocked")
end

function ManaMinder:Consume()
    if ManaMinder.barManager.barFrames[1] then
        ManaMinder.barManager.barFrames[1]:Consume()
    end
end
