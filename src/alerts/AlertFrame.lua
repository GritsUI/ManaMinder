local db = nil
local L = ManaMinder.L

local ICON_BOTTOM_MARGIN = 8

AlertFrame = {}
AlertFrame.__index = AlertFrame;

function AlertFrame:new()
  local self = {}
  setmetatable(self, AlertFrame)

  self.isActive = false
  self.startTime = nil
  self.lastActiveConsumable = nil
  self.lastReady = {}

  return self
end

function AlertFrame:OnLoad(frame)
  local name = frame:GetName()
  self.frame = frame
  self.icon = getglobal(name .. "_Icon")
  self.iconTexture = getglobal(name .. "_Icon_NormalTexture")
  self.text = getglobal(name .. "_Text")
end

function AlertFrame:OnInitialize()
  db = ManaMinder.db
  self:InitializeState()
  self:InitializeEventHandlers()
end

function AlertFrame:InitializeState()
  local selfDB = db.char.alertFrame

  self.frame:SetPoint(selfDB.position.point, "UIParent", selfDB.position.relativePoint, selfDB.position.x, selfDB.position.y)
  self.frame:SetAlpha(selfDB.unlocked and 1 or 0)
  self.frame:SetMovable(selfDB.unlocked)
  self.frame:EnableMouse(selfDB.unlocked)
  self.frame:RegisterForDrag("LeftButton")
  self.frame:SetHeight(selfDB.size + ICON_BOTTOM_MARGIN + 30)

  self.icon:SetWidth(selfDB.size)
  self.icon:SetHeight(selfDB.size)
  self.icon:EnableMouse(false)

  self.text:SetFont(GameFontHighlight:GetFont(), selfDB.fontSize)
  self.text:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 0, -(selfDB.size + ICON_BOTTOM_MARGIN))
  self.text:SetText(self:GetText(ManaMinder.consumables["MAJOR_MANA_POTION"]))
end

function AlertFrame:InitializeEventHandlers()
  self.frame:SetScript("OnUpdate", function() self:OnUpdate() end)
  self.frame:SetScript("OnDragStart", function() self:OnDragStart() end)
  self.frame:SetScript("OnDragStop", function() self:OnDragStop() end)
end

function AlertFrame:OnUpdate()
  local readyConsumable = self:GetReadyConsumable()

  if readyConsumable then
    self.lastReady[readyConsumable.key] = GetTime()
  end

  if self.isActive then
    if self:HasDurationExpired() then
      self:Deactivate()
    elseif self:ShouldFinishEarly(readyConsumable) then
      self.startTime = self:GetFadeOutStartTime()
    end
  elseif not readyConsumable and self:CanRealert(self.lastActiveConsumable) then
    self.lastActiveConsumable = nil
  elseif readyConsumable and self:IsEnabled() and self:NeedsActivation(readyConsumable) then
    self:Activate(readyConsumable)
  end

  self:UpdateState()
end

function AlertFrame:GetReadyConsumable()
  if ManaMinder.barManager.barFrames[1] and ManaMinder.barManager.barFrames[1]:IsReady() then
    return ManaMinder.barManager.barFrames[1].data
  end
  return nil
end

function AlertFrame:HasDurationExpired()
  return (GetTime() - self.startTime) >= db.char.alertFrame.duration
end

function AlertFrame:Deactivate()
  self.isActive = false
  if not db.char.alertFrame.unlocked then
    self.frame:SetAlpha(0)
  end
end

function AlertFrame:ShouldFinishEarly(readyConsumable)
  return (not self:IsEnabled() or not readyConsumable or readyConsumable.key ~= self.lastActiveConsumable.key)
    and self.startTime > self:GetFadeOutStartTime()
end

function AlertFrame:GetFadeOutStartTime()
  return GetTime() - (db.char.alertFrame.duration - db.char.alertFrame.animationDuration)
end

function AlertFrame:CanRealert(consumable)
  if not consumable then
    return true
  end
  local sinceReady = self:TimeSinceLastReady(consumable)
  return sinceReady == nil or sinceReady > db.char.alertFrame.repeatDelay
end

function AlertFrame:TimeSinceLastReady(consumable)
  local lastReady = self.lastReady[consumable.key]
  if not lastReady then
    return nil
  end

  return GetTime() - lastReady
end

function AlertFrame:IsEnabled()
  return not db.char.alertFrame.hidden and (ManaMinder.mainFrame.isVisible or db.char.alertFrame.showWithoutBars)
end

function AlertFrame:NeedsActivation(consumable)
  return
    not self.isActive
    and consumable
    and (
      not self.lastActiveConsumable
      or self.lastActiveConsumable.key ~= consumable.key
    )
end

function AlertFrame:Activate(consumable)
  self.isActive = true
  self.startTime = GetTime()
  self.lastActiveConsumable = consumable
  self.iconTexture:SetTexture(consumable.texture)
  self.text:SetText(self:GetText(consumable))

  if not db.char.alertFrame.soundDisabled then
    ManaMinder:PlaySound(db.char.alertFrame.soundType)
  end
end

function AlertFrame:GetText(consumable)
  local name = ManaMinder:GetConsumableNameForKey(consumable.key, consumable.type)
  return string.gsub(db.char.alertFrame.text, "%%name%%", L[name])
end

function AlertFrame:UpdateState()
  if not self.isActive then
    return
  end

  self:UpdateAlpha()
end

function AlertFrame:UpdateAlpha()
  local alpha = 1
  local elapsed = GetTime() - self.startTime
  local total = db.char.alertFrame.duration
  local fadeDuration = db.char.alertFrame.animationDuration
  local beforeFadeOut = total - fadeDuration

  if not db.char.alertFrame.unlocked then
    if elapsed < fadeDuration then
      alpha = elapsed / fadeDuration
    elseif elapsed > beforeFadeOut then
      alpha = 1 - ((elapsed - beforeFadeOut) / fadeDuration)
    end
  end

  self.frame:SetAlpha(alpha)
end

function AlertFrame:UpdateSize()
  self.icon:SetWidth(db.char.alertFrame.size)
  self.icon:SetHeight(db.char.alertFrame.size)
  self.text:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 0, -(db.char.alertFrame.size + ICON_BOTTOM_MARGIN))
end

function AlertFrame:UpdateFontSize()
  self.text:SetFont(GameFontHighlight:GetFont(), db.char.alertFrame.fontSize)
end

function AlertFrame:OnLockChange(locked)
  if locked then
    self:OnLock()
  else
    self:OnUnlock()
  end
end

function AlertFrame:OnLock()
  if not self.isActive then
    self.frame:SetAlpha(0)
  end
  self.frame:SetMovable(false)
  self.frame:EnableMouse(false)
end

function AlertFrame:OnUnlock()
  self.frame:SetAlpha(1)
  self.frame:SetMovable(true)
  self.frame:EnableMouse(true)
end

function AlertFrame:OnDragStart()
  if not db.char.alertFrame.unlocked then
    return
  end

  self.frame:StartMoving()
end

function AlertFrame:OnDragStop()
  if not db.char.alertFrame.unlocked then
    return
  end

  self.frame:StopMovingOrSizing()

  local point, _, relativePoint, x, y = self.frame:GetPoint(1)
  db.char.alertFrame.position.point = point
  db.char.alertFrame.position.relativePoint = relativePoint
  db.char.alertFrame.position.x = x
  db.char.alertFrame.position.y = y
end

ManaMinder.alertFrame = AlertFrame:new()
