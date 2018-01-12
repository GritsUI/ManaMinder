local AceOO = AceLibrary("AceOO-2.0")
local MainFrame = AceOO.Class()

local db = ManaMinder.db

function MainFrame.prototype:init()
  MainFrame.super.prototype.init(self)
end

function MainFrame.prototype:OnLoad(frame)
  self.frame = frame
  self.isVisible = true
end

function MainFrame.prototype:OnInitialize()
  self:InitializeState()
  self:InitializeEventHandlers()
  self:UpdateAll()
end

function MainFrame.prototype:InitializeState()
  local selfDB = db.char.mainFrame

  self.frame:SetPoint(selfDB.position.point, "UIParent", selfDB.position.relativePoint, selfDB.position.x, selfDB.position.y)
  self.frame:SetWidth(selfDB.width)
  self.frame:SetMovable(not selfDB.locked)
  self.frame:RegisterForDrag("LeftButton")
  self:UpdateVisibility()
end

function MainFrame.prototype:InitializeEventHandlers()
  self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
  self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

  self.frame:RegisterEvent("RAID_ROSTER_UPDATE")
  self.frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
  self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
  self.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
  self.frame:RegisterEvent("BAG_UPDATE")
  self.frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
  self.frame:SetScript("OnEvent", function() self:OnEvent(event) end)
end

function MainFrame.prototype:OnDragStart()
  if db.char.mainFrame.locked then
    return
  end

  self.frame:StartMoving()
end

function MainFrame.prototype:OnDragStop()
  if db.char.mainFrame.locked then
    return
  end

  self.frame:StopMovingOrSizing()

  local point, _, relativePoint, x, y = self.frame:GetPoint(1)
  db.char.mainFrame.position.point = point
  db.char.mainFrame.position.relativePoint = relativePoint
  db.char.mainFrame.position.x = x
  db.char.mainFrame.position.y = y
end

function MainFrame.prototype:OnEvent(event)
  if event == "PLAYER_REGEN_DISABLED" then
    self:OnEnterCombat()
  elseif event == "PLAYER_REGEN_ENABLED" then
    self:OnLeaveCombat()
  elseif event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
    self:UpdateVisibility()
  else
    self:UpdateAll()
  end
end

function MainFrame.prototype:OnEnterCombat()
  self.inCombat = true
  self:UpdateVisibility()
end

function MainFrame.prototype:OnLeaveCombat()
  self.inCombat = false
  self:UpdateVisibility()
end

function MainFrame.prototype:UpdateVisibility()
  local inRaid = GetNumRaidMembers() > 0
  local inGroup = not inRaid and GetNumPartyMembers() > 0
  local isSolo = not inRaid and not inGroup

  if db.char.mainFrame.hidden
    or (db.char.mainFrame.hiddenOutOfCombat and not self.inCombat)
    or (db.char.mainFrame.hiddenRaid and inRaid)
    or (db.char.mainFrame.hiddenGroup and inGroup)
    or (db.char.mainFrame.hiddenSolo and isSolo) then
    self.frame:Hide()
    self.isVisible =  false
  else
    self.frame:Show()
    self.isVisible =  true
  end
end

function MainFrame.prototype:UpdateAll()
  ManaMinder.stateManager:Update()
  ManaMinder.barManager:Update()
end

ManaMinder.mainFrame = MainFrame:new()
