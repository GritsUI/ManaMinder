local AceOO = AceLibrary("AceOO-2.0")
local AlertsOptions = AceOO.Class()
local db = ManaMinder.db

function AlertsOptions.prototype:init()
  AlertsOptions.super.prototype.init(self)
end

function AlertsOptions.prototype:OnInitialize()

end

ManaMinder.optionsFrame.alertsFrame = AlertsOptions:new()
