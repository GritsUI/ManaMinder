local AceOO = AceLibrary("AceOO-2.0")
local GeneralOptions = AceOO.Class()

local HIDE_CHECK_NAME = "ManaMinder_Options_General_Hide_Check"
local LOCK_CHECK_NAME = "ManaMinder_Options_General_Lock_Check"

function GeneralOptions.prototype:init()
    GeneralOptions.super.prototype.init(self)
end

function GeneralOptions.prototype:OnInitialize()
    getglobal(HIDE_CHECK_NAME):SetChecked(ManaMinder.db.profile.mainFrame.hidden);
    getglobal(LOCK_CHECK_NAME):SetChecked(ManaMinder.db.profile.mainFrame.locked);
end

function GeneralOptions.prototype:OnHideLoad()
    getglobal(HIDE_CHECK_NAME .. "Text"):SetText("Hide Bars");
end

function GeneralOptions.prototype:OnHideChange(hide)
    if hide then
        ManaMinder.db.profile.mainFrame.hidden = true
        ManaMinder.mainFrame.frame:Hide()
    else
        ManaMinder.db.profile.mainFrame.hidden = false
        ManaMinder.mainFrame.frame:Show()
    end
end

function GeneralOptions.prototype:OnLockLoad()
    getglobal(LOCK_CHECK_NAME .. "Text"):SetText("Lock Bars");
end

function GeneralOptions.prototype:OnLockChange(locked)
    if locked then
        ManaMinder.db.profile.mainFrame.locked = true
        ManaMinder.mainFrame.frame:SetMovable(false)
    else
        ManaMinder.db.profile.mainFrame.locked = false
        ManaMinder.mainFrame.frame:SetMovable(true)
    end
end

ManaMinder.optionsFrame.generalFrame = GeneralOptions:new()
