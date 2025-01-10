XddTracker = CreateFrame("Frame")
local playerName = UnitName("player")
recentDamage = {}

-- Initialize Database
XddTrackerDB = XddTrackerDB or {}

-- Register Events
XddTracker:RegisterEvent("ADDON_LOADED")
XddTracker:RegisterEvent("PLAYER_DEAD")
XddTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
XddTracker:RegisterEvent("CHAT_MSG_ADDON")

-- Event Dispatcher
XddTracker:SetScript("OnEvent", function(self, event, ...)
    if XddTracker[event] then
        print("Event " .. event)
        XddTracker[event](self, ...)
    end
end)
