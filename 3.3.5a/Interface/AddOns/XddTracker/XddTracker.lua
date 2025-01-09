local XddTracker = CreateFrame("Frame")
local playerName = UnitName("player")
local recentDamage = {}

-- Initialize Database
XddTrackerDB = XddTrackerDB or {}

-- Register Events
XddTracker:RegisterEvent("PLAYER_DEAD")
XddTracker:RegisterEvent("CHAT_MSG_ADDON")
XddTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
XddTracker:RegisterEvent("ADDON_LOADED")

-- Event Handlers
XddTracker:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "XddTracker" then
            C_ChatInfo.RegisterAddonMessagePrefix("XddTracker")
        end

    elseif event == "PLAYER_DEAD" then
        -- Increment Death Count
        XddTrackerDB[playerName] = (XddTrackerDB[playerName] or 0) + 1

        -- Determine Cause of Death
        local cause = "Unknown"
        if recentDamage.subevent == "ENVIRONMENTAL_DAMAGE" then
            cause = "Fall Damage"
        elseif recentDamage.sourceName then
            cause = recentDamage.sourceName .. " (" .. (recentDamage.spellName or "Unknown") .. ")"
        end

        -- Display Message
        RaidNotice_AddMessage(RaidWarningFrame, playerName .. " has died! Cause: " .. cause .. ". Total deaths: " .. XddTrackerDB[playerName], ChatTypeInfo["RAID_WARNING"])

        -- Broadcast Updated Death Count
        XddTracker:BroadcastDB()

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, damage = CombatLogGetCurrentEventInfo()
        if destName == playerName then
            -- Record Recent Damage
            recentDamage = {
                timestamp = timestamp,
                subevent = subevent,
                sourceName = sourceName or "Environment",
                spellName = spellName or "Melee",
                damage = damage
            }
        end

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == "XddTracker" and sender ~= playerName then
            local name, count = strsplit(":", message)
            count = tonumber(count)

            -- Merge Data
            if not XddTrackerDB[name] or count > XddTrackerDB[name] then
                XddTrackerDB[name] = count
                RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
            end
        end
    end
end)

-- Broadcast Database
function XddTracker:BroadcastDB()
    for name, count in pairs(XddTrackerDB) do
        local message = name .. ":" .. count
        C_ChatInfo.SendAddonMessage("XddTracker", message, "RAID")
    end
end

