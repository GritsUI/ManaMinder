local AceOO = AceLibrary("AceOO-2.0")
local ConsumablesOptions = AceOO.Class()
local db = ManaMinder.db

local AVAILABLE_SECTION_NAME = "ManaMinder_Options_Consumables_Available_Section"
local TRACKED_SECTION_NAME = "ManaMinder_Options_Consumables_Tracked_Section"
local SECTION_LEFT_MARGIN = 10
local SECTION_RIGHT_MARGIN = -6
local SECTION_TOP_MARGIN = -6
local ITEM_HEIGHT = 20

function ConsumablesOptions.prototype:init()
    ConsumablesOptions.super.prototype.init(self)
    self.availableFrames = {}
    self.trackedFrames = {}
end

function ConsumablesOptions.prototype:OnInitialize()
    self.availableSectionFrame = getglobal(AVAILABLE_SECTION_NAME)
    self.trackedSectionFrame = getglobal(TRACKED_SECTION_NAME)
    self:RefreshFrames()
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
        self.availableFrames[index] = CreateFrame(
            "Frame",
            "ManaMinder_Available_Consumable_" .. index,
            self.availableSectionFrame,
            "ManaMinder_Available_Consumable"
        )
    end

    local frame = self.availableFrames[index]
    frame:SetPoint(
        "TOPLEFT",
        self.availableSectionFrame,
        "TOPLEFT",
        SECTION_LEFT_MARGIN,
        SECTION_TOP_MARGIN + (-1 * ITEM_HEIGHT) * (index - 1)
    )
    frame:SetPoint("RIGHT", self.availableSectionFrame, "RIGHT", SECTION_RIGHT_MARGIN, 0)

    getglobal(frame:GetName() .. "_Text"):SetText(consumable.name)
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
    ManaMinder:SystemMessage("Add: " .. index .. " " .. (SECTION_TOP_MARGIN + (-1 * ITEM_HEIGHT) * (index - 1)))

    if not self.trackedFrames[index] then
        self.trackedFrames[index] = CreateFrame(
            "Frame",
            "ManaMinder_Tracked_Consumable_" .. index,
            self.trackedSectionFrame,
            "ManaMinder_Tracked_Consumable"
        )
    end

    local frame = self.trackedFrames[index]
    frame:SetPoint(
        "TOPLEFT",
        self.trackedSectionFrame,
        "TOPLEFT",
        SECTION_LEFT_MARGIN,
        SECTION_TOP_MARGIN + (-1 * ITEM_HEIGHT) * (index - 1)
    )
    frame:SetPoint("RIGHT", self.trackedSectionFrame, "RIGHT", SECTION_RIGHT_MARGIN, 0)

    getglobal(frame:GetName() .. "_Text"):SetText(ManaMinder:GetConsumableNameForKey(consumable.key, consumable.type))
end

ManaMinder.optionsFrame.consumablesFrame = ConsumablesOptions:new()
