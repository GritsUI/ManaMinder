ManaMinder = AceLibrary("AceAddon-2.0"):new("AceDB-2.0")
ManaMinder:RegisterDB("ManaMinderDB")

local ITEM_IDS = {
    ["MINOR_MANA_POTION"] = 2455,
    ["MAJOR_MANA_POTION"] = 13444
}

function ManaMinder:OnInitialize()
    ManaMinder_MainFrame:SetScript("OnUpdate", self.Update)
end

function ManaMinder:Update()
    local count, cooldown = ManaMinder:GetItemState(ITEM_IDS["MINOR_MANA_POTION"])
    ManaMinder_MainFrame_Text2:SetText("Count: " .. count)
    ManaMinder_MainFrame_Text3:SetText("Cooldown: " .. cooldown)
end

function ManaMinder:GetItemState(itemId)
    local count = 0
    local cooldown = 0
    for bag = 4, 0, -1 do
        local size = GetContainerNumSlots(bag)
        if (size > 0) then
            for slot=1, size, 1 do
                local texture, itemCount = GetContainerItemInfo(bag, slot)
                if (itemCount) then
                    local link = GetContainerItemLink(bag, slot)
                    local curItemId = ManaMinder:GetItemIdFromLink(link)
                    if (curItemId == itemId) then
                        count = count + itemCount
                        cooldown = ManaMinder:GetContainerItemCooldownRemaining(bag, slot)
                    end
                end
            end
        end
    end
    return count, cooldown
end

function ManaMinder:GetItemIdFromLink(itemLink)
    local id
    if (itemLink) then
        for id in string.gfind(itemLink, "|c%x+|Hitem:(%d+):%d+:%d+:%d+|h%[.-%]|h|r") do
            return tonumber(id)
        end
    end
end

function ManaMinder:GetContainerItemCooldownRemaining(bagId, slot)
    local start, duration, enabled = GetContainerItemCooldown(bagId, slot)
    local finish = start + duration
    local now = GetTime()
    return enabled and now < finish and finish - now or 0
end

function ManaMinder:SystemMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF2150C2ManaMinder|cFFFFFFFF: " .. msg)
end
