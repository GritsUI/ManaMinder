local AceOO = AceLibrary("AceOO-2.0")
local MainFrame = AceOO.Class()

local db = ManaMinder.db

function MainFrame.prototype:init()
    MainFrame.super.prototype.init(self)
end

function MainFrame.prototype:OnLoad(frame)
    self.frame = frame
end

function MainFrame.prototype:OnInitialize()
    self:InitializeState()
    self:InitializeEventHandlers()
    self:UpdateAll()
end

function MainFrame.prototype:InitializeState()
    local selfDB = db.profile.mainFrame

    self.frame:SetPoint("CENTER", "UIParent", "CENTER", selfDB.position.x, selfDB.position.y)
    self.frame:SetWidth(selfDB.width)
    self.frame:SetAlpha(selfDB.alpha)
    self.frame:SetScale(selfDB.scale)
    self.frame:SetMovable(not selfDB.locked)
    self.frame:RegisterForDrag("LeftButton")

    if selfDB.hidden or selfDB.hiddenOutOfCombat then
        self.frame:Hide()
    end
end

function MainFrame.prototype:InitializeEventHandlers()
    self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
    self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

    self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.frame:RegisterEvent("BAG_UPDATE")
    self.frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
    self.frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    self.frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    self.frame:SetScript("OnEvent", function() self:OnEvent(event) end)
end

function MainFrame.prototype:OnDragStart()
    if db.profile.mainFrame.locked then
        return
    end

    self.frame:StartMoving()
end

function MainFrame.prototype:OnDragStop()
    if db.profile.mainFrame.locked then
        return
    end

    self.frame:StopMovingOrSizing()

    local point, parent, relativePoint, x, y = self.frame:GetPoint(1)
    db.profile.mainFrame.position.x = x
    db.profile.mainFrame.position.y = y
end

function MainFrame.prototype:OnEvent(event)
    if event == "PLAYER_REGEN_DISABLED" then
        self:OnEnterCombat()
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:OnLeaveCombat()
    else
        self:UpdateAll()
    end
end

function MainFrame.prototype:OnEnterCombat()
    self.inCombat = true
    if db.profile.mainFrame.hiddenOutOfCombat then
        self.frame:Show()
    end
end

function MainFrame.prototype:OnLeaveCombat()
    self.inCombat = false
    if db.profile.mainFrame.hiddenOutOfCombat then
        self.frame:Hide()
    end
end

function MainFrame.prototype:UpdateAll()
    ManaMinder.stateManager:Update()
    ManaMinder.barManager:Update()
    self:UpdateAlpha()
end

function MainFrame.prototype:UpdateAlpha()
    self.frame:SetAlpha(1)
    self.frame:SetAlpha(db.profile.mainFrame.alpha)
end

ManaMinder.mainFrame = MainFrame:new()
