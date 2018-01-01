local AceOO = AceLibrary("AceOO-2.0")
local ConsumablesOptions = AceOO.Class()
local db = ManaMinder.db

local AVAILABLE_SECTION_NAME = "ManaMinder_Options_Consumables_Available_Section"
local TRACKED_SECTION_NAME = "ManaMinder_Options_Consumables_Tracked_Section"
local POTIONS_CHECK_NAME = "ManaMinder_Options_Consumables_Potions_Check"
local RUNES_CHECK_NAME = "ManaMinder_Options_Consumables_Runes_Check"

function ConsumablesOptions.prototype:init()
    ConsumablesOptions.super.prototype.init(self)
    self.availableFrames = {}
    self.trackedFrames = {}
end

function ConsumablesOptions.prototype:OnInitialize()
    self.availableSectionFrame = getglobal(AVAILABLE_SECTION_NAME)
    self.trackedSectionFrame = getglobal(TRACKED_SECTION_NAME)
    self:RefreshFrames()

    getglobal(POTIONS_CHECK_NAME):SetChecked(db.profile.combinePotions);
    getglobal(RUNES_CHECK_NAME):SetChecked(db.profile.combineRunes);
end

function ConsumablesOptions.prototype:RefreshFrames()
    self:RemoveCurrentFrames()
    self:AddAvailableFrames()
    self:AddTrackedFrames()
end

function ConsumablesOptions.prototype:RemoveCurrentFrames()
    for i = 1, table.getn(self.availableFrames), 1 do
        self.availableFrames[i]:Hide()
    end

    for i = 1, table.getn(self.trackedFrames), 1 do
        self.trackedFrames[i]:Hide()
    end
end

function ConsumablesOptions.prototype:AddAvailableFrames()
    for index, consumable in ipairs(self:GetAvailableConsumables()) do
        self:AddAvailableFrame(index, consumable)
    end
end

function ConsumablesOptions.prototype:AddAvailableFrame(index, consumable)
    if not self.availableFrames[index] then
        self.availableFrames[index] = ManaMinder.AvailableConsumableFrame:new(self.availableSectionFrame, consumable)
    end

    local frame = self.availableFrames[index]
    frame.consumable = consumable
    frame.onClick = function() self:TrackConsumable(consumable) end
    frame:SetPosition(index)
    frame:UpdateText()
    frame:Show()
end

function ConsumablesOptions.prototype:GetAvailableConsumables()
    local consumables = {}

    for key, data in pairs(ManaMinder.consumables) do
        if not self:IsConsumableTracked(key) then
            table.insert(consumables, data)
        end
    end

    for key, data in pairs(ManaMinder.spells) do
        if not self:IsConsumableTracked(key) then
            table.insert(consumables, data)
        end
    end

    table.sort(consumables, function(consumableA, consumableB)
        return consumableA.name < consumableB.name
    end)

    return consumables
end

function ConsumablesOptions.prototype:IsConsumableTracked(consumableKey)
    for i, consumable in pairs(db.profile.consumables) do
        if consumable.key == consumableKey then
            return true
        end
    end
    return false
end

function ConsumablesOptions.prototype:AddTrackedFrames()
    for index, consumable in ipairs(db.profile.consumables) do
        self:AddTrackedFrame(index, consumable)
    end
end

function ConsumablesOptions.prototype:AddTrackedFrame(index, consumable)
    if not self.trackedFrames[index] then
        self.trackedFrames[index] = ManaMinder.TrackedConsumableFrame:new(self.trackedSectionFrame, consumable)
    end

    local frame = self.trackedFrames[index]
    frame.consumable = consumable
    frame.onRemoveClick = function() self:UntrackConsumable(consumable) end
    frame.onUpClick = function() self:IncreasePriority(index) end
    frame.onDownClick = function() self:DecreasePriority(index) end
    frame:SetPosition(index)
    frame:UpdateText()
    frame:Show()
end

function ConsumablesOptions.prototype:TrackConsumable(consumable)
    table.insert(db.profile.consumables, {
        key = consumable.key,
        priority = table.getn(db.profile.consumables) + 1,
        type = consumable.type
    })
    self:RefreshFrames()
    ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:UntrackConsumable(consumable)
    db.profile.consumables = ManaMinder:Splice(db.profile.consumables, consumable.priority, 1)

    for i = 1, table.getn(db.profile.consumables), 1 do
        db.profile.consumables[i].priority = i
    end

    self:RefreshFrames()
    ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:IncreasePriority(index)
    if (index == 1) then
        return
    end

    local old = db.profile.consumables[index - 1]
    db.profile.consumables[index - 1] = db.profile.consumables[index]
    db.profile.consumables[index - 1].priority = index - 1
    db.profile.consumables[index] = old
    db.profile.consumables[index].priority = index

    self:RefreshFrames()
    ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:DecreasePriority(index)
    if (index == table.getn(db.profile.consumables)) then
        return
    end

    local old = db.profile.consumables[index + 1]
    db.profile.consumables[index + 1] = db.profile.consumables[index]
    db.profile.consumables[index + 1].priority = index + 1
    db.profile.consumables[index] = old
    db.profile.consumables[index].priority = index

    self:RefreshFrames()
    ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:OnPotionsCheckLoad()
    getglobal(POTIONS_CHECK_NAME .. "Text"):SetText("Only Show Highest Priority Potion")
end

function ConsumablesOptions.prototype:OnPotionsCheckChange(value)
    db.profile.combinePotions = value
    ManaMinder.mainFrame:UpdateAll()
end

function ConsumablesOptions.prototype:OnRunesCheckLoad()
    getglobal(RUNES_CHECK_NAME .. "Text"):SetText("Only Show One of Demonic Rune/Dark Rune/Lily Root")
end

function ConsumablesOptions.prototype:OnRunesCheckChange(value)
    db.profile.combineRunes = value
    ManaMinder.mainFrame:UpdateAll()
end

ManaMinder.optionsFrame.consumablesFrame = ConsumablesOptions:new()
