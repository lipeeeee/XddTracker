-- Broadcast the death database to the raid
function XddTracker:BroadcastDB()
    for name, count in pairs(self.DB) do
        local message = name .. ":" .. count
        C_ChatInfo.SendAddonMessage("XddTracker", message, "RAID")
    end
end

function XddTracker:BroadcastFullDB()
      for name, count in pairs(XddTrackerDB) do
          local message = name .. ":" .. count
          C_ChatInfo.SendAddonMessage("XddTracker", "SYNC|" .. message, "RAID")
      end
end
