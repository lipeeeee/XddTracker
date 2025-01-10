function XddTracker:BroadcastDB()
  for name, count in pairs(self.DB) do
    local message = name .. ":" .. count
    SendAddonMessage("XddTracker", "SYNC|" .. message, "GUILD", nil)
  end
end

function XddTracker:BroadcastDeath()
  local message = self.playerName .. ":" .. self.DB[self.playerName]
  SendAddonMessage("XddTracker", "ANCC|" .. message, "GUILD", nil)
end

function XddTracker:MergeDB(player, count) 
  count = tonumber(count)
  if not self.DB[player] or count > XddTracker[player] then
    self.DB[player] = count
    print("XddTracker: Synced death count for " .. player .. "(" .. count .. " deaths)")
  end
end
