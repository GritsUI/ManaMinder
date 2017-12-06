ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "AceConsole-2.0")
ManaMinder:RegisterDB("ManaMinderDB")

local stateManager
local barManager
local mainFrame

function ManaMinder:OnInitialize()
    ManaMinder:RegisterDefaults('profile', ManaMinder.defaults.profile)

    mainFrame = ManaMinder.MainFrame:new()
    mainFrame.frame:SetScript("OnUpdate", self.Update)

    stateManager = ManaMinder.StateManager:new()
    barManager = ManaMinder.BarManager:new(mainFrame, stateManager)

    ManaMinder:RegisterChatCommand({'/mana'}, ManaMinder:GetChatCommandOptions())

    ManaMinder:SystemMessage("Addon Loaded. Type /mana for slash commands")
end

function ManaMinder:GetChatCommandOptions()
    local options = {
        type = "group",
        args = {
            hide = {name = "Hide", desc = "Hides all frames", type = "execute", func = "Hide"},
            show = {name = "Show", desc = "Shows all frames", type = "execute", func = "Show"},
            lock = {name = "Lock", desc = "Lock all frames", type = "execute", func = "Lock" },
            unlock = {name = "Unlock", desc = "Unlock all frames", type = "execute", func = "Unlock"},
            consume = {name = "Consume", desc = "Uses highest priority consumable, if any available with proper mana deficit", type = "execute", func = "Consume"}
        }
    }
    return options
end

function ManaMinder:Hide()
    mainFrame:Hide()
    ManaMinder:SystemMessage("Frames hidden")
end

function ManaMinder:Show()
    mainFrame:Show()
    ManaMinder:SystemMessage("Frames shown")
end

function ManaMinder:Lock()
    mainFrame.frame:EnableMouse(false)
    ManaMinder:SystemMessage("Frames locked")
end

function ManaMinder:Unlock()
    mainFrame.frame:EnableMouse(true)
    ManaMinder:SystemMessage("Frames unlocked")
end

function ManaMinder:Consume()
    if barManager.barFrames[1] then
        barManager.barFrames[1]:Consume()
    end
end

function ManaMinder:Update()
    stateManager:Update()
    barManager:Update()
end
