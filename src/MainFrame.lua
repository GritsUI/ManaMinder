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
    local selfDB = db.profile.mainFrame

    self.frame:SetPoint("CENTER", "UIParent", "CENTER", selfDB.position.x, selfDB.position.y)
    self.frame:SetWidth(selfDB.width)
    self.frame:SetMovable(not selfDB.locked)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
    self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

    if selfDB.hidden then
        self.frame:Hide()
    end
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

ManaMinder.mainFrame = MainFrame:new()
