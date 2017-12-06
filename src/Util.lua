function ManaMinder:ForEachContainerSlot(func)
    for bag = 4, 0, -1 do
        local size = GetContainerNumSlots(bag)
        if size > 0 then
            for slot=1, size, 1 do
                func(bag, slot)
            end
        end
    end
end

function ManaMinder:GetContainerItemCooldownRemaining(bagId, slot)
    local start, duration, enabled = GetContainerItemCooldown(bagId, slot)
    local finish = start + duration
    local now = GetTime()
    return enabled and now < finish and finish - now or 0
end

function ManaMinder:GetItemIdFromLink(itemLink)
    local id
    if (itemLink) then
        for id in string.gfind(itemLink, "|c%x+|Hitem:(%d+):%d+:%d+:%d+|h%[.-%]|h|r") do
            return tonumber(id)
        end
    end
end

function ManaMinder:SecondsToRelativeTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor((seconds - m * 60) + 0.5)
    local rel = ""

    if m > 0 then
        rel = m .. ":"
    end
    if m > 0 and s < 10 then
        rel = rel .. "0"
    end
    rel = rel .. s

    return rel
end

function ManaMinder:SystemMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF2150C2ManaMinder|cFFFFFFFF: " .. msg)
end
