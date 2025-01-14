-- For printing debug prints
function XddTracker:printd(message)
  if self.DEBUG then
    print("[XddTracker - DEBUG] " .. message)
  end
end

function XddTracker:BroadcastDB()
  for name, count in pairs(XddTrackerDB) do
    local message = name .. ":" .. count
    SendAddonMessage(self.PREFIX, self.MSG_SYNC_SEND .. message, "GUILD")
  end
end

function XddTracker:BroadcastDeath()
  local message = self.playerName .. ":" .. XddTrackerDB[self.playerName]
  SendAddonMessage(self.PREFIX, self.MSG_DEATH_BROADCAST .. message, "GUILD")
end

-- Just update the local db if the given player count pair is higher than existing one
-- returns true if updated
function XddTracker:MergeDB(player, count)
  count = tonumber(count)
  if not XddTrackerDB[player] or count > XddTrackerDB[player] then
    XddTrackerDB[player] = count
    return true
  end
  return false
end

-- Requests syncing in guild and broadcasts own db
function XddTracker:SyncData()
  SendAddonMessage(XddTracker.PREFIX, XddTracker.MSG_SYNC_REQUEST, XddTracker.CHANNEL_GUILD)
  self:BroadcastDB()
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
