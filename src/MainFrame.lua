local AceOO = AceLibrary("AceOO-2.0")
local MainFrame = AceOO.Class()
AceOO.Class:init(MainFrame, ManaMinder.Frame)

local db = ManaMinder.db

function MainFrame.prototype:init()
    MainFrame.super.prototype.init(self, {
        frameType = "Frame",
        frameName = "ManaMinder_Main",
        parentFrame = UIParent
    })

    self:SetupFrame()
    self:SetupFrameBackground()
end

function MainFrame.prototype:SetupFrame()
    self.frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", db.profile.mainFrame.position.x, db.profile.mainFrame.position.y)
    self.frame:SetWidth(db.profile.mainFrame.width)
    self.frame:SetHeight(100)
    self.frame:EnableMouse(true)
    self.frame:SetMovable(not ManaMinder.db.profile.mainFrame.locked)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
    self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

    if ManaMinder.db.profile.mainFrame.hidden then
        self:Hide()
    end
end

function MainFrame.prototype:SetupFrameBackground()
    self.background = self.frame:CreateTexture("ManaMinder_Main_Background", "BACKGROUND")
    self.background:SetTexture(0, 0, 0, 0)
    self.background:SetAllPoints()
end

function MainFrame.prototype:OnDragStart()
    if ManaMinder.db.profile.mainFrame.locked then
        return
    end

    self.frame:StartMoving()
end

function MainFrame.prototype:OnDragStop()
    if ManaMinder.db.profile.mainFrame.locked then
        return
    end

    self.frame:StopMovingOrSizing()

    local x, y = self:GetPosition()
    db.profile.mainFrame.position.x = x
    db.profile.mainFrame.position.y = y
end

ManaMinder.MainFrame = MainFrame
