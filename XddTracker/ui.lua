-- Create Main Frame
local XddTrackerFrame = CreateFrame("Frame", "XddTrackerFrame", UIParent)
XddTrackerFrame:SetSize(250, 300)
XddTrackerFrame:SetPoint("CENTER")
XddTrackerFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true,
  tileSize = 32,
  edgeSize = 32,
  insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
XddTrackerFrame:SetMovable(true)
XddTrackerFrame:EnableMouse(true)
XddTrackerFrame:RegisterForDrag("LeftButton")
XddTrackerFrame:SetScript("OnDragStart", XddTrackerFrame.StartMoving)
XddTrackerFrame:SetScript("OnDragStop", XddTrackerFrame.StopMovingOrSizing)
XddTrackerFrame:Show() -- Start hidden

-- Title Text
local title = XddTrackerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("XddTracker - Deaths")

-- Close Button
local closeButton = CreateFrame("Button", nil, XddTrackerFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -5, -5)
closeButton:SetScript("OnClick", function()
  XddTrackerFrame:Hide()
end)

-- Scroll Frame
local scrollFrame = CreateFrame("ScrollFrame", nil, XddTrackerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(220, 220)
scrollFrame:SetPoint("TOP", 0, -40)

-- Content Frame
local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(220, 220)
scrollFrame:SetScrollChild(content)

-- Dynamic Death List
local function UpdateDeathList()
  content:ReleaseChildren()   -- Clear previous entries

  local yOffset = -5
  XddTrackerDB = XddTrackerDB or {}
  for name, count in pairs(XddTrackerDB) do
    local entry = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    entry:SetPoint("TOPLEFT", 10, yOffset)
    entry:SetText(name .. ": " .. count .. " deaths")
    yOffset = yOffset - 20
  end
end
