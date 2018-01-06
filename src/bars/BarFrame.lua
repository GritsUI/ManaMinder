local AceOO = AceLibrary("AceOO-2.0")
local BarFrame = AceOO.Class()
AceOO.Class:init(BarFrame, ManaMinder.Frame)

local db = ManaMinder.db
local frameCount = 1
local NORMALTEX_RATIO = 1.7

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
  self.frame:SetWidth(db.char.mainFrame.width)
  self.frame:SetHeight(db.char.bars.height)
  self.frame:SetScript("OnUpdate", function() self:Update() end)
end

function BarFrame.prototype:SetupFrameBackground()
  local color = db.char.bars.backgroundColor
  self.background = self.frame:CreateTexture(nil, "BACKGROUND")
  self.background:SetTexture(color[1], color[2], color[3], color[4])
  self.background:SetAllPoints()
end

function BarFrame.prototype:SetupStatusBar()
  local font = GameFontHighlight:GetFont()
  local fontColor = db.char.bars.readyFontColor
  local texture = ManaMinder.textures[db.char.bars.texture]

  self.statusBar = CreateFrame("StatusBar", nil, self.frame)
  self.statusBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", db.char.bars.height + 1, 0)
  self.statusBar:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
  self.statusBar:SetStatusBarTexture(texture.texture)
  self.statusBar:SetStatusBarColor(0.7, 0.7, 0.7, 0.7)
  self.statusBar:SetMinMaxValues(0,100)
  self.statusBar:SetValue(self:GetCurrentPercent())

  self.statusBarText = self.statusBar:CreateFontString(nil, "OVERLAY")
  self.statusBarText:SetFont(font, db.char.bars.fontSize)
  self.statusBarText:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
  self.statusBarText:SetPoint("TOPLEFT", self.statusBar, "TOPLEFT", 5, 0)
  self.statusBarText:SetPoint("BOTTOMRIGHT", self.statusBar, "BOTTOMRIGHT", 0, 0)
  self.statusBarText:SetJustifyH("LEFT")
  self.statusBarText:SetText("")
end

function BarFrame.prototype:SetupIcon()
  local buttonName = self.frame:GetName() .. "_Button"
  local buttonSize = db.char.bars.height
  self.button = CreateFrame("Button", buttonName, self.frame, "ActionButtonTemplate")
  self.button:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 1)
  self.button:SetWidth(buttonSize)
  self.button:SetHeight(buttonSize)
  self.button:EnableMouse(true)
  self.button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  self.button:SetScript("OnClick", function() self:Consume(true) end)

  local buttonIcon = getglobal(buttonName .. "Icon")
  local normalTexture = getglobal(buttonName .. "NormalTexture")
  buttonIcon:SetTexture(self.data.texture)
  normalTexture:SetWidth(buttonSize * NORMALTEX_RATIO)
  normalTexture:SetHeight(buttonSize * NORMALTEX_RATIO)

  local color = db.char.bars.iconFontColor
  local font = NumberFontNormalSmall:GetFont()
  self.buttonText = self.button:CreateFontString(nil, "ARTWORK")
  self.buttonText:SetPoint("BOTTOMRIGHT", self.button, "BOTTOMRIGHT", -2, 2)
  self.buttonText:SetJustifyH("RIGHT")
  self.buttonText:SetWidth(db.char.bars.height)
  self.buttonText:SetFont(font, db.char.bars.iconFontSize)
  self.buttonText:SetShadowColor(0, 0, 0, 1.0)
  self.buttonText:SetShadowOffset(0.80, -0.80)
  self.buttonText:SetTextColor(color[1], color[2], color[3], color[4])
  self.buttonText:SetText(self.data.count)
end

function BarFrame.prototype:ChangeIndex(index, animate)
  if self.index == index then
    return
  end

  self.index = index

  local targetPosition = self:GetPositionForIndex(index)
  if not animate then
    self:SetPosition(targetPosition)
  else
    self:BeginPositionAnimation(targetPosition)
  end
end

function BarFrame.prototype:GetPositionForIndex(index)
  local margin = db.char.bars.margin
  local height = db.char.bars.height
  return (index - 1) * (height + margin) * -1
end

function BarFrame.prototype:SetPosition(y)
  self.frame:SetPoint("TOPLEFT", self.parentFrame, "TOPLEFT", 0, y)
  self.position = y
end

function BarFrame.prototype:BeginPositionAnimation(y)
  self.animation = {
    startPosition = self.position,
    endPosition = y,
    startTime = GetTime(),
    duration = db.char.bars.animationDuration
  }
end

function BarFrame.prototype:Update()
  self:UpdateAnimation()
  self:UpdateAlpha()
  self:UpdateCooldownState()
  self:UpdateStatusBar()
  self:UpdateConsumableCount()
end

function BarFrame.prototype:UpdateAnimation()
  if not self.animation then
    return
  end

  local now = GetTime()
  local percent = math.min(1, (now - self.animation.startTime) / self.animation.duration)

  local newPosition = ManaMinder:EaseInOutQuad(
    self.animation.startPosition,
    self.animation.endPosition,
    percent,
    self.animation.duration
  )
  self:SetPosition(newPosition)

  if percent == 1 then
    self.animation = nil
  end
end

function BarFrame.prototype:UpdateAlpha()
  if self:GetCooldownRemaining() > 0 then
    self.frame:SetAlpha(db.char.bars.cooldownAlpha)
  elseif self:GetDeficitRemaining() > 0 then
    self.frame:SetAlpha(db.char.bars.deficitAlpha)
  elseif self.index == 1 then
    self.frame:SetAlpha(db.char.bars.readyAlpha)
  else
    self.frame:SetAlpha(db.char.bars.cooldownAlpha)
  end
end

function BarFrame.prototype:UpdateCooldownState()
  local newValue = self:GetCooldownRemaining() > 0

  if self.onCooldown ~= newValue then
    ManaMinder.mainFrame:UpdateAll()
  end

  self.onCooldown = newValue
end

function BarFrame.prototype:UpdateStatusBar()
  local color, fontColor = self:GetCurrentColors()
  self.statusBar:SetStatusBarColor(color[1], color[2], color[3], color[4])
  self.statusBar:SetValue(self:GetCurrentPercent())
  self.statusBarText:SetText(self:GetCurrentText())
  self.statusBarText:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
end

function BarFrame.prototype:UpdateConsumableCount()
  self.buttonText:SetText(self.data.count)
end

function BarFrame.prototype:GetDeficitRemaining()
  if not self.data.requiredDeficit then
    return 0
  end

  local mana = UnitMana("player")
  local manaMax = UnitManaMax("player")
  local deficit = manaMax - mana
  return math.max(0, self.data.requiredDeficit - deficit)
end

function BarFrame.prototype:GetCooldownRemaining()
  return ManaMinder:GetCooldownRemaining(self.data.cooldownStart, self.data.cooldown, self.data.type == "SPELL")
end

function BarFrame.prototype:GetCurrentPercent()
  local remaining = self:GetCooldownRemaining()
  if remaining == 0 then
    return 100
  end
  return (remaining / self.data.cooldown) * 100
end

function BarFrame.prototype:GetCurrentColors()
  if self:GetCooldownRemaining() > 0 then
    return db.char.bars.cooldownColor, db.char.bars.cooldownFontColor
  end

  if self:GetDeficitRemaining() > 0 then
    return db.char.bars.deficitColor, db.char.bars.deficitFontColor
  end

  if self.index == 1 then
    return db.char.bars.readyColor, db.char.bars.readyFontColor
  end

  return db.char.bars.cooldownColor, db.char.bars.cooldownFontColor
end

function BarFrame.prototype:GetCurrentText()
  local remaining = self:GetCooldownRemaining()
  if remaining > 0 then
    local relative = ManaMinder:SecondsToRelativeTime(remaining)
    return string.gsub(db.char.bars.cooldownText, "%%cooldown%%", relative)
  end

  local deficit = self:GetDeficitRemaining()
  if deficit > 0 then
    return string.gsub(db.char.bars.deficitText, "%%deficit%%", deficit)
  end

  if self.index == 1 then
    return db.char.bars.readyText
  end

  return ""
end

function BarFrame.prototype:Consume(force)
  if force or (not self.onCooldown and self:GetDeficitRemaining() == 0) then
    if self.data.type == "ITEM" then
      UseContainerItem(self.data.bag, self.data.slot)
    elseif self.data.type == "SPELL" then
      CastSpell(self.data.spellId, "BOOKTYPE_SPELL")
    elseif self.data.type == "EQUIPPED" then
      UseInventoryItem(self.data.slot)
    end
  end
end

function BarFrame.prototype:UpdateWidth()
  self.frame:SetWidth(db.char.mainFrame.width)
end

function BarFrame.prototype:UpdateHeight()
  local height = db.char.bars.height
  self.frame:SetHeight(height)
  self.statusBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", height + 1, 0)
  self.button:SetWidth(height)
  self.button:SetHeight(height)
  self.buttonText:SetWidth(height)

  local normalTexture = getglobal(self.button:GetName() .. "NormalTexture")
  normalTexture:SetWidth(height * NORMALTEX_RATIO)
  normalTexture:SetHeight(height * NORMALTEX_RATIO)

  self:UpdatePosition()
end

function BarFrame.prototype:UpdateFontSize()
  self.statusBarText:SetFont(GameFontHighlight:GetFont(), db.char.bars.fontSize)
end

function BarFrame.prototype:UpdatePosition()
  self.animation = nil
  self:SetPosition(self:GetPositionForIndex(self.index))
end

function BarFrame.prototype:UpdateBackground()
  local color = db.char.bars.backgroundColor
  self.background:SetTexture(color[1], color[2], color[3], color[4])
end

function BarFrame.prototype:UpdateTexture()
  local texture = ManaMinder.textures[db.char.bars.texture]
  self.statusBar:SetStatusBarTexture(texture.texture)
end

function BarFrame.prototype:IsReady()
  return self:GetCooldownRemaining() == 0 and self:GetDeficitRemaining() == 0 and self.index == 1
end

ManaMinder.BarFrame = BarFrame
