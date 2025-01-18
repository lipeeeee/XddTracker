function XddTracker:ADDON_LOADED(addonName)
  if addonName == self.PREFIX then
    print("XddTracker loaded, syncing with database with GUILD...")
    -- C_Timer only came in WOD so we rawdog it
    self:SyncData()
  end
  UpdateDeathList()
end

function XddTracker:PLAYER_DEAD()
  XddTrackerDB[self.playerName] = (XddTrackerDB[self.playerName] or 0) + 1

  RaidNotice_AddMessage(RaidWarningFrame,
    self.playerName .. " has died! Total deaths: " .. XddTrackerDB[self.playerName],
    ChatTypeInfo["RAID_WARNING"])
  self:BroadcastDeath()
  UpdateDeathList()
end

function XddTracker:CHAT_MSG_ADDON(prefix, message, channel, sender)
  -- if prefix ~= self.PREFIX or sender == UnitName("player") then
  if prefix ~= self.PREFIX then
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
    UpdateDeathList()
  elseif command == self.MSG_DEATH_BROADCAST then -- In-game death announcer
    local data = string.sub(message, 6)
    local name, count = strsplit(":", data)
    if self:MergeDB(name, count) then
      RaidNotice_AddMessage(RaidWarningFrame, name .. " has died! Total deaths: " .. count, ChatTypeInfo["RAID_WARNING"])
    end
    UpdateDeathList()
  elseif command == self.MSG_SYNC_REQUEST then -- Sync request
    print("XddTracker: Sync requested by " .. sender .. ". Sending data.")
    self:BroadcastDB()
  end
end
