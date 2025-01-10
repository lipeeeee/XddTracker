--
-- Issues = XddTrackerDB; playerName and recentDamage are not global, and its causing multiple crashes
--

-- ADDON_LOADED
function XddTracker:ADDON_LOADED(addonName)
    if addonName == "XddTracker" then
        print("XddTracker enabled")
        RegisterAddonMessagePrefix("XddTracker")
        C_ChatInfo.RegisterAddonMessagePrefix("XddTracker")
    end
end

-- PLAYER_DEAD
function XddTracker:PLAYER_DEAD()
    XddTrackerDB[playerName] = (XddTrackerDB[playerName] or 0) + 1

    local cause = "Unknown"
    if recentDamage.subevent == "ENVIRONMENTAL_DAMAGE" then
        cause = "Fall Damage"
    elseif recentDamage.sourceName then
        cause = recentDamage.sourceName .. " (" .. (recentDamage.spellName or "Unknown") .. ")"
    end

    RaidNotice_AddMessage(RaidWarningFrame, playerName .. " has died! Cause: " .. cause .. ". Total deaths: " .. XddTrackerDB[playerName], ChatTypeInfo["RAID_WARNING"])
    XddTracker:BroadcastDB()
end

-- COMBAT_LOG_EVENT_UNFILTERED
function XddTracker:COMBAT_LOG_EVENT_UNFILTERED() -- CHECK THIS, CRASHES ON LINE 1
    local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, damage = CombatLogGetCurrentEventInfo()
    if destName == playerName then
        recentDamage = {
            timestamp = timestamp,
            subevent = subevent,
            sourceName = sourceName or "Environment",
            spellName = spellName or "Melee",
            damage = damage
        }
    end
end

-- CHAT_MSG_ADDON
function XddTracker:CHAT_MSG_ADDON(prefix, message, channel, sender)
    if prefix == "XddTracker" and sender ~= playerName then
        local name, count = strsplit(":", message)
        count = tonumber(count)

        if not XddTrackerDB[name] or count > XddTrackerDB[name] then
            XddTrackerDB[name] = count
            RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
        end
    end
end

