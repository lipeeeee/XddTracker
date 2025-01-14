-- Fuck wow api:
--  SendAddonMessage(prefix, msg, scope) - does NOT work when passed '|' with a character after it
--

-- Global addon table
XddTracker = XddTracker or {}
XddTracker.frame = CreateFrame("Frame")
XddTracker.playerName = UnitName("player")
XddTracker.recentDamage = {}

-- Register Events
XddTracker.frame:RegisterEvent("PLAYER_LOGIN")
XddTracker.frame:RegisterEvent("PLAYER_LOGOUT")
XddTracker.frame:RegisterEvent("PLAYER_DEAD")
XddTracker.frame:RegisterEvent("CHAT_MSG_ADDON")
XddTracker.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
XddTracker.frame:RegisterEvent("ADDON_LOADED")
XddTracker.frame:SetScript("OnEvent", function(self, event, ...)
  if XddTracker[event] then
    XddTracker[event](XddTracker, ...) -- Pass the addon table for context
  end
end)

-- Initializes / retrieves saved vars
if not XddTrackerDB then
  XddTrackerDB = {}
end

if not XddTrackerMinimapPos then
  XddTrackerMinimapPos = { x = 0, y = 0}
end

