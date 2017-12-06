ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0")
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

    ManaMinder:SystemMessage("Addon Loaded")
end

function ManaMinder:Update()
    stateManager:Update()
    barManager:Update()
end
