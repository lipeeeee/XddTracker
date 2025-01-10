-- ADDON_LOADED
function XddTracker:ADDON_LOADED(addonName)
  if addonName == "XddTracker" then
    self.DB = XddTrackerDB or {}     -- Sync db
    -- ! REGISTERADDONMESSAGEPREFIX
    RegisterAddonMessagePrefix("XddTracker")

    -- Sync full db after loading
    -- C_Timer only came in WOD....
    self:BroadcastFullDB()
    print("XddTracker loaded, syncing with group...")
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

  RaidNotice_AddMessage(RaidWarningFrame,
    self.playerName .. " has died! Cause: " .. cause .. ". Total deaths: " .. self.DB[self.playerName],
    ChatTypeInfo["RAID_WARNING"])
  if false then   -- Manually switch this, either for whole db or just death broadcast
    self:BroadcastDB()
  else
    self:BroadcastDeath(self.playerName)
  end
end

-- COMBAT_LOG_EVENT_UNFILTERED
function XddTracker:COMBAT_LOG_EVENT_UNFILTERED() -- CHECK THIS, CRASHES ON LINE 1
  local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, damage =
  CombatLogGetCurrentEventInfo()
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
  if prefix == "XddTracker" and sender ~= self.playerName then
    local name, count = strsplit(":", message)
    count = tonumber(count)

    if not self.DB[name] or count > self.DB[name] then
      self.DB[name] = count
      RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
    end


    -- Sync shit
    if strsub(message, 1, 5) == "SYNC|" then
      local data = strsub(message, 6)
      local name, count = strsplit(":", data)
      count = tonumber(count)

      -- Merge logic
      if not self.DB[name] or count > self.DB[name] then
        self.DB[name] = count
        print(name .. "'s death count updated to " .. count .. " (Synced)")
      end
    else     -- Handle normal brocadcasts
      local name, count = strsplit(":", message)
      count = tonumber(count)

      -- procs when raid warning
      if not self.DB[name] or count > self.DB[name] then
        self.DB[name] = count
      end
    end
  end
end
