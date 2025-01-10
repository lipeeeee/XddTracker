-- Slash Command to show death counts
SLASH_XDDTRACKER1 = "/deaths"
SlashCmdList["XDDTRACKER"] = function()
  print("XddTracker Death List:")
  for name, count in pairs(XddTracker.DB) do
    print(name .. " has died " .. count .. " times.")
  end
end

SLASH_XDDTRACKER2 = "/xdd"
SlashCmdList["XDDTRACKER2"] = function()
end
