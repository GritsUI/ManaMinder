local db = nil
local L = ManaMinder.L

local CLOSE_BUTTON_NAME = "ManaMinder_Main_Header_Close"
local CONFIG_BUTTON_NAME = "ManaMinder_Main_Header_Config"
local HEADER_NAME = "ManaMinder_Main_Header"
local LOCK_BUTTON_NAME = "ManaMinder_Main_Header_Lock"
local UNLOCK_BUTTON_NAME = "ManaMinder_Main_Header_Unlock"


MainFrame = {}
MainFrame.__index = MainFrame;

function MainFrame:new()
  local self = {}
  setmetatable(self, MainFrame)
  return self
end

function MainFrame:OnLoad(frame)
  self.frame = frame
  self.isVisible = true
end

function MainFrame:OnInitialize()
  db = ManaMinder.db
  self:InitializeState()
  self:InitializeEventHandlers()
  self:UpdateAll()
end

function MainFrame:InitializeState()
  local selfDB = db.char.mainFrame

  if selfDB.locked then
    getglobal(LOCK_BUTTON_NAME):Hide()
  else
    getglobal(UNLOCK_BUTTON_NAME):Hide()
  end

  self.frame:SetPoint(selfDB.position.point, "UIParent", selfDB.position.relativePoint, selfDB.position.x, selfDB.position.y)
  self.frame:SetWidth(selfDB.width)
  self.frame:SetMovable(not selfDB.locked)
  self.frame:RegisterForDrag("LeftButton")
  self:UpdateVisibility()
end

function MainFrame:InitializeEventHandlers()
  self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
  self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)

  self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
  self.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
  self.frame:RegisterEvent("BAG_UPDATE")
  self.frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
  self.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
  self.frame:SetScript("OnEvent", function(_, event) self:OnEvent(event) end)
end

function MainFrame:OnDragStart()
  if db.char.mainFrame.locked then
    return
  end

  self.frame:StartMoving()
end

function MainFrame:OnDragStop()
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

function MainFrame:OnEnter()
  getglobal(HEADER_NAME):Show()
end

function MainFrame:OnLeave()
  getglobal(HEADER_NAME):Hide()
end

function MainFrame:OnEvent(event)
  if event == "PLAYER_REGEN_DISABLED" then
    self:OnEnterCombat()
  elseif event == "PLAYER_REGEN_ENABLED" then
    self:OnLeaveCombat()
  elseif event == "GROUP_ROSTER_UPDATE" then
    self:UpdateVisibility()
  else
    self:UpdateAll()
  end
end

function MainFrame:OnEnterCombat()
  self.inCombat = true
  self.combatEnterTime = GetTime()
  self:UpdateVisibility()
end

function MainFrame:OnLeaveCombat()
  self.inCombat = false
  self:UpdateVisibility()
end

function MainFrame:GetTimeInCombat()
  if self.combatEnterTime == nil then
    return 0
  end
  return GetTime() - self.combatEnterTime
end

function MainFrame:UpdateVisibility()
  local inRaid = UnitInRaid("player")
  local inGroup = IsInGroup() and not inRaid
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

function MainFrame:UpdateAll()
  ManaMinder.stateManager:Update()
  ManaMinder.barManager:Update()
  self:UpdateHeight()
end

function MainFrame:UpdateHeight()
  self.frame:SetHeight(ManaMinder.barManager:GetTotalHeight())
end

function MainFrame:UpdateWidth()
  self.frame:SetWidth(db.char.mainFrame.width)
end

function MainFrame:OnCloseClick()
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  ManaMinder:Hide(true)
end

function MainFrame:OnCloseEnter()
  GameTooltip:SetOwner(getglobal(CLOSE_BUTTON_NAME), "ANCHOR_LEFT")
  GameTooltip:AddLine(L["Hide bar frames"], 1, 1, 1)
  GameTooltip:Show()
end

function MainFrame:OnConfigClick()
  ManaMinder:Config()
end

function MainFrame:OnConfigEnter()
  GameTooltip:SetOwner(getglobal(CONFIG_BUTTON_NAME), "ANCHOR_LEFT")
  GameTooltip:AddLine(L["Show options"], 1, 1, 1)
  GameTooltip:Show()
end

function MainFrame:OnLockClick()
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  ManaMinder:Lock(true)
  getglobal(LOCK_BUTTON_NAME):Hide()
  getglobal(UNLOCK_BUTTON_NAME):Show()
end

function MainFrame:OnLockEnter()
  GameTooltip:SetOwner(getglobal(LOCK_BUTTON_NAME), "ANCHOR_LEFT")
  GameTooltip:AddLine(L["Lock bar frames"], 1, 1, 1)
  GameTooltip:Show()
end

function MainFrame:OnUnlockClick()
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  ManaMinder:Unlock(true)
  getglobal(LOCK_BUTTON_NAME):Show()
  getglobal(UNLOCK_BUTTON_NAME):Hide()
end

function MainFrame:OnUnlockEnter()
  GameTooltip:SetOwner(getglobal(UNLOCK_BUTTON_NAME), "ANCHOR_LEFT")
  GameTooltip:AddLine(L["Unlock bar frames"], 1, 1, 1)
  GameTooltip:Show()
end

ManaMinder.mainFrame = MainFrame:new()
