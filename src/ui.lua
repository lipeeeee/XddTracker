--
-- ISSUES: This is not running at all
-- creating frame works

-- Create Main Frame
local XddTrackerFrame = CreateFrame("Frame", "XddTrackerFrame", UIParent)
XddTrackerFrame:SetSize(250, 300)
XddTrackerFrame:SetPoint("CENTER")
XddTrackerFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
XddTrackerFrame:SetMovable(true)
XddTrackerFrame:EnableMouse(true)
XddTrackerFrame:RegisterForDrag("LeftButton")
XddTrackerFrame:SetScript("OnDragStart", XddTrackerFrame.StartMoving)
XddTrackerFrame:SetScript("OnDragStop", XddTrackerFrame.StopMovingOrSizing)
XddTrackerFrame:Show()  -- Start hidden

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
local scrollFrame = CreateFrame("ScrollFrame", "XddTrackerScrollFrame", XddTrackerFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(220, 220)
scrollFrame:SetPoint("TOP", 0, -40)

-- Content Frame
local content = CreateFrame("Frame", "XddTrackerContent", scrollFrame)
content:SetSize(220, 220)
scrollFrame:SetScrollChild(content)


--Clear Children (content:ReleaseChildren was crashing the function)
local function ClearContentChildren(entry) 
    for _, entries in ipairs(entry) do
        entries:Hide()
        entries = nil
    end
end


local deathEntries = {}
-- Dynamic Death List
_G.UpdateDeathList = function ()
    ClearContentChildren(deathEntries)

    deathEntries = {}
    local yOffset = -5
    for name, count in pairs(XddTrackerDB) do
        print("Adding " .. name .. " to the list")
        local entry = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        entry:SetPoint("TOPLEFT", 10, yOffset)
        entry:SetText(name .. ": " .. count .. " deaths")
        yOffset = yOffset - 20
        print("Added " .. name .. " to the list")
        table.insert(deathEntries, entry)
    end
end

UpdateDeathList()


