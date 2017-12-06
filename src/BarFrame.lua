local AceOO = AceLibrary("AceOO-2.0")
local BarFrame = AceOO.Class()
AceOO.Class:init(BarFrame, ManaMinder.Frame)

local db = ManaMinder.db
local frameCount = 1

function BarFrame.prototype:init(parentFrame, data)
    BarFrame.super.prototype.init(self, {
        frameType = "Frame",
        frameName = "ManaMinder_Bar_" .. frameCount,
        parentFrame = parentFrame
    })

    frameCount = frameCount + 1

    self.data = data
    self:SetupFrame()
    self:SetupFrameBackground()
    self:SetupIcon()
    self:SetupStatusBar()
end

function BarFrame.prototype:SetupFrame()
    self.frame:SetWidth(db.profile.mainFrame.width)
    self.frame:SetHeight(db.profile.bars.height)
end

function BarFrame.prototype:SetupFrameBackground()
    local color = db.profile.bars.backgroundColor
    self.background = self.frame:CreateTexture(nil, "BACKGROUND")
    self.background:SetTexture(color[1], color[2], color[3], color[4] * db.profile.bars.alpha)
    self.background:SetAllPoints()
end

function BarFrame.prototype:SetupStatusBar()
    local statusBarWidth = db.profile.mainFrame.width - db.profile.bars.height - 1
    local textMargin = 5
    local font = GameFontHighlight:GetFont()
    local fontColor = db.profile.bars.fontColor

    self.statusBar = CreateFrame("StatusBar", nil, self.frame)
    self.statusBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", db.profile.bars.height + 1, 0)
    self.statusBar:SetWidth(statusBarWidth)
    self.statusBar:SetHeight(db.profile.bars.height)
    self.statusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.statusBar:SetStatusBarColor(0.7, 0.7, 0.7, 0.7)
    self.statusBar:SetMinMaxValues(0,100)
    self.statusBar:SetValue(self:GetCurrentPercent())

    self.statusBarText = self.statusBar:CreateFontString(nil, "OVERLAY")
    self.statusBarText:SetFont(font, db.profile.bars.fontSize)
    self.statusBarText:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4] * db.profile.bars.alpha)
    self.statusBarText:SetHeight(db.profile.bars.height)
    self.statusBarText:SetWidth(statusBarWidth - textMargin)
    self.statusBarText:SetPoint( "LEFT", self.statusBar, "LEFT", textMargin, 0)
    self.statusBarText:SetJustifyH("LEFT")
    self.statusBarText:SetText("")
end

function BarFrame.prototype:SetupIcon()
    self.icon = CreateFrame("Button", nil, self.frame)
    self.icon:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
    self.icon:SetWidth(db.profile.bars.height)
    self.icon:SetHeight(db.profile.bars.height)
    self.icon:SetNormalTexture(self.data.texture)
    self.icon:SetAlpha(db.profile.bars.alpha)

    local color = db.profile.bars.iconFontColor
    local font = NumberFontNormalSmall:GetFont()
    self.iconText = self.icon:CreateFontString(nil, "ARTWORK")
    self.iconText:SetPoint("BOTTOMRIGHT", self.icon, "BOTTOMRIGHT", -2, 2)
    self.iconText:SetJustifyH("RIGHT")
    self.iconText:SetWidth(db.profile.bars.height)
    self.iconText:SetFont(font, db.profile.bars.iconFontSize)
    self.iconText:SetShadowColor(0, 0, 0, 1.0)
    self.iconText:SetShadowOffset(0.80, -0.80)
    self.iconText:SetTextColor(color[1], color[2], color[3], color[4] * db.profile.bars.alpha)
    self.iconText:SetText(self.data.count)
end

function BarFrame.prototype:Update(index)
    local margin = db.profile.bars.margin
    local height = db.profile.bars.height
    local y = (index - 1) * (height + margin) * -1

    self.frame:SetPoint("TOPLEFT", self.parentFrame, "TOPLEFT", 0, y)
    self.statusBar:SetValue(self:GetCurrentPercent())

    local color = self:GetCurrentColor(index)
    local alpha = db.profile.bars.alpha
    self.statusBar:SetStatusBarColor(color[1], color[2], color[3], color[4] * alpha)
    self.statusBarText:SetText(self:GetCurrentText())

    self.iconText:SetText(self.data.count)
end

function BarFrame.prototype:GetCurrentPercent()
    if self.data.cooldown == 0 then
        return 100
    end
    return (self.data.cooldown / self.data.cooldownTotal) * 100
end

function BarFrame.prototype:GetCurrentColor(index)
    if self.data.cooldown > 0 then
        return db.profile.bars.cooldownColor
    end

    if self.data.deficitRemaining > 0 then
        return db.profile.bars.deficitColor
    end

    return index == 1 and db.profile.bars.readyColor or db.profile.bars.cooldownColor
end

function BarFrame.prototype:GetCurrentText()
    if self.data.cooldown > 0 then
        return ManaMinder:SecondsToRelativeTime(self.data.cooldown)
    end

    if self.data.deficitRemaining > 0 then
        return "+" .. self.data.deficitRemaining
    end

    return ""
end

function BarFrame.prototype:Consume()
    if self.data.cooldown == 0 and self.data.deficitRemaining == 0 then
        if self.data.type == "ITEM" then
            UseContainerItem(self.data.bag, self.data.slot)
        elseif self.data.type == "SPELL" then
            CastSpell(self.data.spellId, "BOOKTYPE_SPELL")
        end
    end
end

ManaMinder.BarFrame = BarFrame
