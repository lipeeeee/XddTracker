function XddTracker:ADDON_LOADED(addonName)
  print(self.PREFIX)
  if addonName == self.PREFIX then
    print("XddTracker loaded, syncing with database with GUILD...")
    if not XddTrackerDB then
      XddTrackerDB = {}          -- What.. the.. fuck
    end
    self.DB = XddTrackerDB or {} -- Sync db
    -- C_Timer only came in WOD so we rawdog it
    self:BroadcastDB()
  end
end

function XddTracker:PLAYER_DEAD()
  self.DB[self.playerName] = (self.DB[self.playerName] or 0) + 1
  XddTrackerDB[self.playerName] = self.DB[self.playerName]
  print(yay)
  local cause = "Unknown"
  if self.recentDamage.subevent == "ENVIRONMENTAL_DAMAGE" then
    cause = "Fall Damage"
  elseif self.recentDamage.sourceName then
    cause = self.recentDamage.sourceName .. " (" .. (self.recentDamage.spellName or "Unknown") .. ")"
  end

  RaidNotice_AddMessage(RaidWarningFrame,
    self.playerName .. " has died! Cause: " .. cause .. ". Total deaths: " .. self.DB[self.playerName],
    ChatTypeInfo["RAID_WARNING"])
  self:BroadcastDeath(self.playerName)
end

function XddTracker:COMBAT_LOG_EVENT_UNFILTERED()
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

function XddTracker:CHAT_MSG_ADDON(prefix, message, channel, sender)
  -- if prefix ~= "XddTracker" or sender == UnitName("player") then return end
  if prefix ~= self.PREFIX then
    print("[DEBUG] IGNORING MESSAGE((" .. prefix .. ")" .. message .. ") IN " .. channel)
    return
  end

  print("[DEBUG] Received - (" .. prefix .. ")" .. message)
  local command = string.sub(message, 1, self.MSG_LEN)
  if command == self.MSG_SYNC_SEND then -- Sync data
    local data = string.sub(message, 6)
    local name, count = strsplit(":", data)
    if self:MergeDB(name, count) then
      print(name .. "'s death count updated to " .. count .. " (Synced)")
    end
  elseif command == self.MSG_DEATH_BROADCAST then -- In-game death announcer
    local data = string.sub(message, 6)
    local name, count = strsplit(":", data)
    if self:MergeDB(name, count) then
      RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
    end
  elseif command == self.MSG_SYNC_REQUEST then -- Sync request
    print("XddTracker: Sync requested by " .. sender .. ". Sending data.")
    self:BroadcastDB()
  end
end

function XddTracker:PLAYER_LOGOUT()
  XddTrackerDB = self.DB
end
