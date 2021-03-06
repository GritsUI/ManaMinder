local AceOO = AceLibrary("AceOO-2.0")
local BarManager = AceOO.Class()
local db = ManaMinder.db

local HEADER_HEIGHT = 20

function BarManager.prototype:init()
  BarManager.super.prototype.init(self)
  self.barFrames = {}
end

function BarManager.prototype:Update()
  local newData = ManaMinder.testBarData
  if not db.char.bars.testMode then
    newData = ManaMinder.stateManager:GetBarData()
  end

  -- Create bars that don't already exist for tracked items
  -- eg. On Initial setup, on going from item count 0 to > 0, on enabling of an item in settings
  self:CreateMissingBars(newData)

  -- Remove bars for tracked items that should no longer be shown
  -- eg. On going from item count > 0 to 0, on disabling of an item in settings, on spell loss from respec
  self:RemoveStaleBars(newData)

  -- Refresh priority numbers on bar data in case of changes
  self:UpdatePriorities()

  -- Sort bars based on current cooldowns and priorities
  self:SortBars()

  -- Update current bar positioning, labels, etc.
  self:UpdateBars(newData)
end

function BarManager.prototype:CreateMissingBars(newData)
  for _, newBar in ipairs(newData) do
    if not self:IsBarInArray(self.barFrames, newBar.key) then
      table.insert(self.barFrames, self:CreateBar(newBar))
    end
  end
end

function BarManager.prototype:IsBarInArray(array, key)
  for _, bar in ipairs(array) do
    -- Handle either an array of bar data objects, or BarFrame objects
    local barKey = bar.data and bar.data.key or bar.key
    if barKey == key then
      return true
    end
  end
  return false
end

function BarManager.prototype:CreateBar(data)
  return ManaMinder.BarFrame:new(ManaMinder.mainFrame.frame, data)
end

function BarManager.prototype:RemoveStaleBars(newData)
  for i = table.getn(self.barFrames), 1, -1 do
    if not self:IsBarInArray(newData, self.barFrames[i].data.key) then
      self.barFrames[i].frame:Hide()
      table.remove(self.barFrames, i)
    end
  end
end

function BarManager.prototype:UpdatePriorities()
  if db.char.bars.testMode then
    return
  end

  for i = table.getn(self.barFrames), 1, -1 do
    for priority, consumable in db.char.consumables do
      if self.barFrames[i].data.key == consumable.key then
        self.barFrames[i].data.priority = priority
      end
    end
  end
end

function BarManager.prototype:SortBars()
  table.sort(self.barFrames, function(barA, barB)
    local cooldownRemainingA = self:GetCooldownRemaining(barA)
    local cooldownRemainingB = self:GetCooldownRemaining(barB)

    if cooldownRemainingA == cooldownRemainingB then
      return barA.data.priority < barB.data.priority
    end
    return cooldownRemainingA < cooldownRemainingB
  end)
end

function BarManager.prototype:GetCooldownRemaining(bar)
  if db.char.bars.testMode then
    return bar.data.cooldownRemaining
  end
  return ManaMinder:GetCooldownRemaining(bar.data.cooldownStart, bar.data.cooldown)
end

function BarManager.prototype:UpdateBars(newData)
  for i = 1, table.getn(self.barFrames), 1 do
    local bar = self.barFrames[i]
    for _, data in ipairs(newData) do
      if bar.data.key == data.key then
        bar.data = data

        if not bar.index then
          bar:ChangeIndex(i, false)
        elseif bar.index ~= i then
          bar:ChangeIndex(i, true)
        end
      end
    end
  end
end

function BarManager.prototype:GetTotalHeight()
  local barMargin = db.char.bars.margin
  local barHeight = db.char.bars.height
  local count =  table.getn(self.barFrames)
  return HEADER_HEIGHT + count * barHeight + (count - 1) * barMargin
end

function BarManager.prototype:ForEachBar(func)
  for i = 1, table.getn(self.barFrames), 1 do
    func(self.barFrames[i])
  end
end

function BarManager.prototype:ClearBars()
  self:ForEachBar(function(bar) bar.frame:Hide() end)
  self.barFrames = {}
end

ManaMinder.barManager = BarManager:new()
