-- Broadcast the death database to the raid
function XddTracker:BroadcastDB()
XddTrackerDB = XddTrackerDB or {} -- !CHANGE!
    for name, count in pairs(XddTrackerDB) do
        local message = name .. ":" .. count
        C_ChatInfo.SendAddonMessage("XddTracker", message, "RAID")
    end
end
