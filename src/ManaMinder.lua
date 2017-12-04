ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0")
ManaMinder:RegisterDB("ManaMinderDB")

local stateManager
local barManager

function ManaMinder:OnInitialize()
    ManaMinder:RegisterDefaults('profile', ManaMinder.defaults.profile)

    stateManager = ManaMinder.StateManager:new()
    barManager = ManaMinder.StateManager:new(stateManager)

    self.frame = CreateFrame("Frame", "ManaMinderRoot")
    self.frame:SetScript("OnUpdate", self.Update)

    ManaMinder:SystemMessage("Addon Loaded")
end

function ManaMinder:Update()
    stateManager:Update()
    barManager:Update()
end
