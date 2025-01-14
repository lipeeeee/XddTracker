function XddTracker:BroadcastDB()
  for name, count in pairs(self.DB) do
    local message = name .. ":" .. count
    SendAddonMessage(self.PREFIX, self.MSG_SYNC_SEND .. message, "GUILD", nil)
  end
end

function XddTracker:BroadcastDeath()
  local message = self.playerName .. ":" .. self.DB[self.playerName]
  SendAddonMessage(self.PREFIX, self.MSG_DEATH_BROADCAST .. message, "GUILD")
end

-- Force updates the deathcounter to db
-- Still dont know how to forcefully change the db INPLACE
-- because the api only saves variables on /reload or logout
-- but shouldnt be a problem if the deaths are being brodcasted correctly =)
function XddTracker:ForceUpdateDeath(playerName, count)
  count = tonumber(count)
  self.DB[playerName] = count
  XddTrackerDB[playerName] = count -- change INFILE
end

-- Just update the local db if the given player count pair is higher than existing one
-- returns true if updated
function XddTracker:MergeDB(player, count)
  count = tonumber(count)
  if not self.DB[player] or count > self.BD[player] then
    self.DB[player] = count
    return true
  end
  return false
end

function XddTracker:SyncData()
  SendAddonMessage(XddTracker.PREFIX, XddTracker.MSG_SYNC_REQUEST, XddTracker.CHANNEL_GUILD)
end

function XddTracker:BubbleSort(inputTable)
  local copy = {}
  for k, v in pairs(inputTable) do
      table.insert(copy, {k, v})
  end

  local n = #copy
  local swapped = true
  while swapped do
      swapped = false
      for i = 1, n - 1 do
          if copy[i][2] < copy[i + 1][2] then
              copy[i], copy[i + 1] = copy[i + 1], copy[i]
              swapped = true
          end
      end
  end
  return copy
end
