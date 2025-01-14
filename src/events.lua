function XddTracker:ADDON_LOADED(addonName)
  if addonName == self.PREFIX then
    print("XddTracker loaded, syncing with database with GUILD...")
    -- C_Timer only came in WOD so we rawdog it
    self:SyncData()
  end
  UpdateDeathList()
end

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
  self:BroadcastDeath()
  UpdateDeathList()
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
  if prefix ~= self.PREFIX or sender == UnitName("player") then
    self:printd("IGNORING MESSAGE((" .. prefix .. ")" .. message .. ") IN " .. channel .. " BY " .. sender)
    return
  end

  self:printd("Received - (" .. prefix .. ")" .. message)
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
