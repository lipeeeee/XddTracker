SLASH_XDDTRACKER1 = "/deaths"
SlashCmdList["XDDTRACKER"] = function()
  print("XddTracker: Death List")
  for name, count in pairs(XddTracker.DB) do
    print(name .. " has died " .. count .. " times.")
  end
end

SLASH_XDDXDD1 = "/xdd"
SlashCmdList["XDDXDD"] = function()
  SendAddonMessage(XddTracker.PREFIX, XddTracker.MSG_SYNC_SEND .. "xdd:1", XddTracker.CHANNEL_GUILD)
  print("XddTracker: xdd'd")
  print("XddTracker: xdd'd")
end

SLASH_XDDSYNC1 = "/sync"
SlashCmdList["XDDSYNC"] = function()
  SendAddonMessage(XddTracker.PREFIX, XddTracker.MSG_SYNC_REQUEST, XddTracker.CHANNEL_GUILD)
  print("XddTracker: Sync request sent to GUILD.")
end

SLASH_XDDUIPD1 = "/xddup"
SlashCmdList["XDDUIPD"] = function()
  print("XddTracker: UI update command received.")
  UpdateDeathList()
  print("XddTracker: UI updated.")
end
