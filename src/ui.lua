print("What the fuck just broke")

local AceGUI = LibStub("AceGUI-3.0")

XddTrackerFrame = AceGUI:Create("SimpleGroup")
XddTrackerFrame:SetLayout("Fill")
XddTrackerFrame:SetFullWidth(true)
XddTrackerFrame:SetFullHeight(true)


--Define backdrop table
XddTrackerFrame.frame:SetBackdrop({
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true,
  tileSize = 16,
  edgeSize = 16,
  insets = { left = 0, right = 0, top = 4, bottom = 4 }
})

-- Apply the backdrop to the frame
XddTrackerFrame.frame:SetBackdropColor(0, 0, 0, 0.8)     -- Set the backdrop color (black with full opacity)
XddTrackerFrame.frame:SetBackdropBorderColor(1, 1, 1, 0) -- Set the border color (white with full opacity)
XddTrackerFrame.frame:SetWidth(230)
XddTrackerFrame.frame:SetHeight(300)
XddTrackerFrame.frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -300, -100)

XddTrackerFrame.frame:SetMovable(true)
XddTrackerFrame.frame:EnableMouse(true)
XddTrackerFrame.frame:RegisterForDrag("LeftButton")
XddTrackerFrame.frame:SetScript("OnDragStart", function(self)
  self:StartMoving()
end)
XddTrackerFrame.frame:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing()
end)

local scrollFrame = AceGUI:Create("ScrollFrame")
scrollFrame:SetLayout("List")
scrollFrame:SetWidth(200)
scrollFrame:SetHeight(270)
XddTrackerFrame:AddChild(scrollFrame)

----
local headerGroup = AceGUI:Create("SimpleGroup")
headerGroup:SetFullWidth(true)
headerGroup:SetLayout("Flow")

local nameHeader = AceGUI:Create("Label")
nameHeader:SetText("Name")
nameHeader:SetWidth(100)
headerGroup:AddChild(nameHeader)

local deathsHeader = AceGUI:Create("Label")
deathsHeader:SetText("Deaths")
deathsHeader:SetWidth(100)
headerGroup:AddChild(deathsHeader)

scrollFrame:AddChild(headerGroup)

local contentGroup = AceGUI:Create("SimpleGroup")
contentGroup:SetLayout("Flow") -- Layout inside the scroll frame
contentGroup:SetWidth(200)
contentGroup:SetHeight(270)

scrollFrame:AddChild(contentGroup)

-- Function to dynamically add rows
local function AddRow(parent, name, deaths)
  local rowGroup = AceGUI:Create("SimpleGroup")
  rowGroup:SetFullWidth(true)
  rowGroup:SetLayout("Flow")

  local nameLabel = AceGUI:Create("Label")
  nameLabel:SetText(name)
  nameLabel:SetWidth(100)
  rowGroup:AddChild(nameLabel)

  local deathsLabel = AceGUI:Create("Label")
  deathsLabel:SetText(tostring(deaths))
  deathsLabel:SetWidth(100)
  rowGroup:AddChild(deathsLabel)

  parent:AddChild(rowGroup)
end

local closeButton = CreateFrame("Button", nil, XddTrackerFrame.frame, "UIPanelCloseButton")
closeButton:SetSize(24, 24)
closeButton:SetPoint("TOPRIGHT", XddTrackerFrame.frame, "TOPRIGHT", 0, 0)
closeButton:SetScript("OnClick", function()
  XddTrackerFrame.frame:Hide()
end)

local function ClearContentChildren(parent)
  while #parent.children > 0 do
    local child = table.remove(parent.children)
    child:Release()
  end
end

-- Dynamic Death List
_G.UpdateDeathList = function()
  ClearContentChildren(contentGroup)
  local orderedDB = XddTracker:BubbleSort(XddTrackerDB)

  for _, entry in ipairs(orderedDB) do
    local name, count = entry[1], entry[2]
    AddRow(contentGroup, name, count)
  end
end

_G.ShowXddTrackerFrame = function()
  XddTrackerFrame.frame:Show()
end
