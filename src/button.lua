-- Setup
local button = CreateFrame("Button", "XddTrackerButton", Minimap)
button:SetWidth(28)
button:SetHeight(28)
button:SetFrameStrata("HIGH")
button:SetMovable(true)
button:EnableMouse(true)
button:RegisterForDrag("LeftButton")
button:RegisterForClicks(XddTracker.WOW_API_LEFTCLICK, XddTracker.WOW_API_RIGHTCLICK)
button:SetPoint("TOPRIGHT", Minimap, -10)

-- Appearence
button.texture = button:CreateTexture(nil, "BACKGROUND")
-- button.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
button.texture:SetTexture("Interface\\AddOns\\" .. XddTracker.PREFIX .. "\\media\\icon2.tga")
button.texture:SetAllPoints(button)
-- Classic border :
-- button.border = button:CreateTexture(nil , "OVERLAY")
-- button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
-- button.border:SetWidth(28*3)
-- button.border:SetHeight(28*3)
-- button.border:SetPoint("TOPLEFT", button, -10, -10)

-- Draggin' shit
local function UpdateButtonPosition() --dont let icon go outside minimap
  local mx, my = Minimap:GetCenter()
  local cx, cy = GetCursorPosition()
  local scale = Minimap:GetEffectiveScale()

  -- Adjust for scale and center
  cx = cx / scale
  cy = cy / scale

  local dx = cx - mx
  local dy = cy - my
  local angle = math.atan2(dy, dx)            -- deprecated but its fine trust
  local radius = Minimap:GetWidth() / 2 + 5   -- +5 for padding

  -- Position the button around the minimap
  local posx = math.cos(angle) * radius
  local posy = math.sin(angle) * radius
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", posx, posy)
  -- print("[DEBUG] Minimap position = (".. posx .. ", " .. posy ..")")
end
button:SetScript("OnDragStart", function(self)
  self:SetScript("OnUpdate", UpdateButtonPosition)
end)

button:SetScript("OnDragStop", function(self)
  self:SetScript("OnUpdate", nil)
end)

-- Events
button:SetScript("OnClick", function(self, buttonClicked)
  if buttonClicked == "LeftButton" then
    if XddTrackerFrame:IsShown() then
      XddTrackerFrame:Hide()
    else
      XddTrackerFrame:Show()
    end
  elseif buttonClicked == "RightButton" then
    XddTracker:SyncData()
  end
end)

button:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:AddDoubleLine(XddTracker.COLOR_ORANGE .. XddTracker.PREFIX,
    XddTracker.COLOR_ORANGE .. "v" .. XddTracker.VERSION, 1, 1, 1, 0.8, 0.8, 0.8)
  GameTooltip:AddLine(XddTracker.COLOR_ORANGE ..
  "Left-Click" .. XddTracker.COLOR_RESET .. " " .. XddTracker.COLOR_GREEN .. "toggle UI" .. XddTracker.COLOR_RESET)
  GameTooltip:AddLine(XddTracker.COLOR_ORANGE ..
  "Right-Click" .. XddTracker.COLOR_RESET .. " " .. XddTracker.COLOR_GREEN .. "sync data" .. XddTracker.COLOR_RESET)
  GameTooltip:AddLine(XddTracker.COLOR_ORANGE ..
  "Middle-Click" .. XddTracker.COLOR_RESET .. " " .. XddTracker.COLOR_GREEN .. "idk debug?" .. XddTracker.COLOR_RESET)
  GameTooltip:Show()
end)

button:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)
