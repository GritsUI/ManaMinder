local AceOO = AceLibrary("AceOO-2.0")
local GeneralOptions = AceOO.Class()
local db = ManaMinder.db

local HIDE_CHECK_NAME = "ManaMinder_Options_General_Hide_Check"
local HIDE_OOC_CHECK_NAME = "ManaMinder_Options_General_Hide_OOC_Check"
local LOCK_CHECK_NAME = "ManaMinder_Options_General_Lock_Check"

function GeneralOptions.prototype:init()
    GeneralOptions.super.prototype.init(self)
end

function GeneralOptions.prototype:OnInitialize()
    getglobal(HIDE_CHECK_NAME):SetChecked(db.profile.mainFrame.hidden);
    getglobal(HIDE_OOC_CHECK_NAME):SetChecked(db.profile.mainFrame.hiddenOutOfCombat);
    getglobal(LOCK_CHECK_NAME):SetChecked(db.profile.mainFrame.locked);
end

function GeneralOptions.prototype:OnHideLoad()
    getglobal(HIDE_CHECK_NAME .. "Text"):SetText("Hide Bars");
end

function GeneralOptions.prototype:OnHideChange(hide)
    if hide then
        db.profile.mainFrame.hidden = true
        ManaMinder.mainFrame.frame:Hide()
    else
        db.profile.mainFrame.hidden = false
        ManaMinder.mainFrame.frame:Show()
    end
end

function GeneralOptions.prototype:OnHideOutOfCombatLoad()
    getglobal(HIDE_OOC_CHECK_NAME .. "Text"):SetText("Hide Bars Out of Combat");
end

function GeneralOptions.prototype:OnHideOutOfCombatChange(hide)
    if hide then
        db.profile.mainFrame.hiddenOutOfCombat = true
        if ManaMinder.mainFrame.inCombat and not db.profile.mainFrame.hidden then
            ManaMinder.mainFrame.frame:Show()
        else
            ManaMinder.mainFrame.frame:Hide()
        end
    else
        db.profile.mainFrame.hiddenOutOfCombat = false
        if not db.profile.mainFrame.hidden then
            ManaMinder.mainFrame.frame:Show()
        end
    end
end

function GeneralOptions.prototype:OnLockLoad()
    getglobal(LOCK_CHECK_NAME .. "Text"):SetText("Lock Bars");
end

function GeneralOptions.prototype:OnLockChange(locked)
    if locked then
        db.profile.mainFrame.locked = true
        ManaMinder.mainFrame.frame:SetMovable(false)
    else
        db.profile.mainFrame.locked = false
        ManaMinder.mainFrame.frame:SetMovable(true)
    end
end

ManaMinder.optionsFrame.generalFrame = GeneralOptions:new()
