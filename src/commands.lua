SLASH_XDDTRACKER1 = "/deaths"
SlashCmdList["XDDTRACKER"] = function()
  print("XddTracker: Death List")
  for name, count in pairs(XddTrackerDB) do
    print(name .. " has died " .. count .. " times.")
  end
end

--[[ 
SLASH_XDDXDD1 = "/xdd"
SlashCmdList["XDDXDD"] = function()
  XddTracker:PLAYER_DEAD()
  SendAddonMessage(XddTracker.PREFIX, XddTracker.MSG_SYNC_SEND .. "xdd:1", XddTracker.CHANNEL_GUILD)
  XddTracker:printd("xdd'd")
end ]]

SLASH_XDDSYNC1 = "/sync"
SlashCmdList["XDDSYNC"] = function()
  XddTracker:SyncData()
  print("XddTracker: Sync request sent to GUILD.")
end

SLASH_XDDUIPD1 = "/xddup"
SlashCmdList["XDDUIPD"] = function()
  UpdateDeathList()
  XddTracker:printd("Ui updated")
end
