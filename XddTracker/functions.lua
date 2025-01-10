-- Broadcast the death database to the raid
function XddTracker:BroadcastDB()
  for name, count in pairs(self.DB) do
    local message = name .. ":" .. count
    SendAddonMessage("XddTracker", message, "GUILD", nil)
  end
end

function XddTracker:BroadcastFullDB()
  for name, count in pairs(self.DB) do
    local message = name .. ":" .. count
    SendAddonMessage("XddTracker", "SYNC|" .. message, "GUILD", nil)
  end
end

function XddTracker:BroadcastDeath()
  local message = self.playerName .. ":" .. self.DB[self.playerName]
  -- ! VER SE BROADCAST FUNCIONA EM RAID; ELSE PARTY !
  SendAddonMessage("XddTracker", message, "GUILD", nil)
  print("[DEBUG] broadcasted death " .. message)
end
