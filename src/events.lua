-- ADDON_LOADED
function XddTracker:ADDON_LOADED(addonName)
    if addonName == "XddTracker" then
        self.DB = XddTrackerDB or {} -- Sync db
        -- ! REGISTERADDONMESSAGEPREFIX
        RegisterAddonMessagePrefix("XddTracker")

        -- Sync full db after loading
        -- C_Timer only came in WOD....
        self:BroadcastDB()
        print("XddTracker loaded, syncing with guild...")
    end
end

-- PLAYER_DEAD
function XddTracker:PLAYER_DEAD()
    self.DB[self.playerName] = (self.DB[self.playerName] or 0) + 1

    local cause = "Unknown"
    if self.recentDamage.subevent == "ENVIRONMENTAL_DAMAGE" then
        cause = "Fall Damage"
    elseif self.recentDamage.sourceName then
        cause = self.recentDamage.sourceName .. " (" .. (self.recentDamage.spellName or "Unknown") .. ")"
    end

    RaidNotice_AddMessage(RaidWarningFrame, self.playerName .. " has died! Cause: " .. cause .. ". Total deaths: " .. self.DB[self.playerName], ChatTypeInfo["RAID_WARNING"])
    self:BroadcastDeath(self.playerName)
end

-- COMBAT_LOG_EVENT_UNFILTERED
function XddTracker:COMBAT_LOG_EVENT_UNFILTERED() -- CHECK THIS, CRASHES ON LINE 1
    local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, damage = CombatLogGetCurrentEventInfo()
    if destName == self.playerName then
        self.recentDamage = {
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
    if prefix ~= "XddTracker" or sender == UnitName("player") then return end

    if strsub(message, 1, 5) == "SYNC|" then -- Sync data
      local data = strsub(message, 6)
      local name, count = strsplit(":", data)
      count = tonumber(count)

      -- Merge logic
      if not self.DB[name] or count > self.DB[name] then
        self.DB[name] = count
        print(name .. "'s death count updated to " .. count .. " (Synced)")
      end
    elseif strsub(message, 1, 5) == "ANCC|" then -- Announce
      local name, count = strsplit(":", message)
      count = tonumber(count)

      if not self.DB[name] or count > self.DB[name] then
          self.DB[name] = count
          RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
      end
    end
end

