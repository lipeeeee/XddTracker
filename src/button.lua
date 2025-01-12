
local btna = CreateFrame("Button", "Xdd123", Minimap)
btna:SetWidth(28)
btna:SetHeight(28)
btna:SetFrameStrata("MEDIUM")
btna:SetMovable(true)
btna:EnableMouse(true)
btna:RegisterForDrag("LeftButton")
btna:RegisterForClicks(XddTracker.WOW_API_LEFTCLICK, XddTracker.WOW_API_RIGHTCLICK)
btna:SetPoint("TOPRIGHT", Minimap, -10)
btna.texture = btna:CreateTexture()
btna.texture:SetAllPoints()
btna.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
print("Setup1")

-- Setup
local button = CreateFame("Button", "XddTrackerButton", UIParent)
button:SetWidth(32)
button:SetHeight(32)
button:SetFrameStrata("MEDIUM")
button:SetMovable(true)
button:EnableMouse(true)
button:RegisterForDrag("LeftButton")
button:RegisterForClicks(XddTracker.WOW_API_LEFTCLICK, XddTracker.WOW_API_RIGHTCLICK)
print("Setup")

-- Appearence
button.texture = button:CreateTexture(nil, "BACKGROUND")
button.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
button.texture:SetAllPoints(button)
button.border = button:CreateTexture(nil , "OVERLAY")
button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
button.border:SetWidth(54)
button.border:SetHeight(54)
button.border:SetPoint("TOPLEFT", button, -10, -10)
print("Appearence")

-- Draggin' shit
button:SetScript("OnDragStart", button.StartMoving)
button:SetScript("OnDragStop", button.StopMovingOrSizing) -- StopMovingOrSizing | StopMoving
print("Draggin")

-- Events
button:SetScript("OnClick", function(self, buttonClicked)
  if buttonClicked == "LeftButton" then
    -- OPENUI
  elseif buttonClicked == "RightButton" then
    XddTracker:SyncData()
  end
end)
print("E1")

button:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:AddLine("XddTracker")
  GameTooltip:AddLine("Left-Click: Toggle UI", 1, 1, 1)
  GameTooltip:AddLine("Right-Click: Sync Data", 1, 1, 1)
end)
print("E2")

button:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)
print("E3")
