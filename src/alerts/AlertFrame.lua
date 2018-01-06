local AceOO = AceLibrary("AceOO-2.0")
local AlertFrame = AceOO.Class()

local db = ManaMinder.db

local ICON_BOTTOM_MARGIN = 8

function AlertFrame.prototype:init()
  AlertFrame.super.prototype.init(self)
  self.isActive = false
  self.startTime = nil
  self.lastActiveConsumable = nil
end

function AlertFrame.prototype:OnLoad(frame)
  local name = frame:GetName()
  self.frame = frame
  self.icon = getglobal(name .. "_Icon")
  self.iconTexture = getglobal(name .. "_Icon_NormalTexture")
  self.text = getglobal(name .. "_Text")
end

function AlertFrame.prototype:OnInitialize()
  self:InitializeState()
  self:InitializeEventHandlers()
end

function AlertFrame.prototype:InitializeState()
  local selfDB = db.char.alertFrame

  self.frame:SetPoint("CENTER", "UIParent", "CENTER", selfDB.position.x, selfDB.position.y)
  self.frame:SetHeight(selfDB.size + ICON_BOTTOM_MARGIN)
  self.frame:SetAlpha(0)

  self.icon:SetWidth(selfDB.size)
  self.icon:SetHeight(selfDB.size)

  self.text:SetFont(GameFontHighlight:GetFont(), selfDB.fontSize)
  self.text:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 0, -(selfDB.size + ICON_BOTTOM_MARGIN))
end

function AlertFrame.prototype:InitializeEventHandlers()
  self.frame:SetScript("OnUpdate", function() self:OnUpdate() end)
end

function AlertFrame.prototype:OnUpdate()
  if not db.char.alertFrame.enabled then
    return
  end

  local readyConsumable = self:GetReadyConsumable()

  if self.isActive then
    if self:HasDurationExpired() then
      self:Deactivate()
    elseif self:ShouldFinishEarly(readyConsumable) then
      self.startTime = self:GetFadeOutStartTime()
    end
  elseif not readyConsumable then
    self.lastActiveConsumable = nil
  elseif self:NeedsActivation(readyConsumable) then
    self:Activate(readyConsumable)
  end

  self:UpdateState()
end

function AlertFrame.prototype:GetReadyConsumable()
  if ManaMinder.barManager.barFrames[1] and ManaMinder.barManager.barFrames[1]:IsReady() then
    return ManaMinder.barManager.barFrames[1].data
  end
  return nil
end

function AlertFrame.prototype:HasDurationExpired()
  return (GetTime() - self.startTime) >= db.char.alertFrame.duration
end

function AlertFrame.prototype:Deactivate()
  self.isActive = false
  self.frame:SetAlpha(0)
end

function AlertFrame.prototype:ShouldFinishEarly(readyConsumable)
  return (not readyConsumable or readyConsumable.key ~= self.lastActiveConsumable.key)
    and self.startTime > self:GetFadeOutStartTime()
end

function AlertFrame.prototype:GetFadeOutStartTime()
  return GetTime() - (db.char.alertFrame.duration - db.char.alertFrame.animationDuration)
end

function AlertFrame.prototype:NeedsActivation(consumable)
  return
    not self.isActive
    and consumable
    and (
      not self.lastActiveConsumable
      or self.lastActiveConsumable.key ~= consumable.key
    )
end

function AlertFrame.prototype:Activate(consumable)
  self.isActive = true
  self.startTime = GetTime()
  self.lastActiveConsumable = consumable
  self.iconTexture:SetTexture(consumable.texture)
  self.text:SetText(self:GetText(consumable))

  if db.char.alertFrame.soundEnabled then
    ManaMinder:PlaySound(db.char.alertFrame.soundType)
  end
end

function AlertFrame.prototype:GetText(consumable)
  local name = ManaMinder:GetConsumableNameForKey(consumable.key, consumable.type)
  return string.gsub(db.char.alertFrame.text, "%%name%%", name)
end

function AlertFrame.prototype:UpdateState()
  if not self.isActive then
    return
  end

  self:UpdateScale()
  self:UpdateAlpha()
end

function AlertFrame.prototype:UpdateScale()
  local scale = 1
  local elapsed = GetTime() - self.startTime
  local total = db.char.alertFrame.duration
  local fadeDuration = db.char.alertFrame.animationDuration
  local beforeFadeOut = total - fadeDuration

  if elapsed < fadeDuration then
    scale = ManaMinder:Lerp(0.95, 1, elapsed / fadeDuration)
  elseif elapsed > beforeFadeOut then
    scale = ManaMinder:Lerp(0.95, 1, 1 - ((elapsed - beforeFadeOut) / fadeDuration))
  end

  self.frame:SetScale(scale)
end

function AlertFrame.prototype:UpdateAlpha()
  local alpha = 1
  local elapsed = GetTime() - self.startTime
  local total = db.char.alertFrame.duration
  local fadeDuration = db.char.alertFrame.animationDuration
  local beforeFadeOut = total - fadeDuration

  if elapsed < fadeDuration then
    alpha = elapsed / fadeDuration
  elseif elapsed > beforeFadeOut then
    alpha = 1 - ((elapsed - beforeFadeOut) / fadeDuration)
  end

  self.frame:SetAlpha(alpha)
end

ManaMinder.alertFrame = AlertFrame:new()
