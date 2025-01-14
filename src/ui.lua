print("What the fuck just broke")

local AceGUI = LibStub("AceGUI-3.0")

XddTrackerFrame = AceGUI:Create("SimpleGroup")
XddTrackerFrame:SetTitle("XddTracker")
XddTrackerFrame:SetLayout("Flow")
XddTrackerFrame:SetWidth(250)
XddTrackerFrame:SetHeight(300)



--Define backdrop table
local backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
}

-- Apply the backdrop to the frame
XddTrackerFrame.frame:SetBackdrop(backdrop)
XddTrackerFrame.frame:SetBackdropColor(0, 0, 0, 1) -- Set the backdrop color (black with full opacity)
XddTrackerFrame.frame:SetBackdropBorderColor(1, 1, 1, 1) -- Set the border color (white with full opacity)
XddTrackerFrame.frame:SetWidth(250)
XddTrackerFrame.frame:SetHeight(300)



local columns = { "Name", "Deaths" }
local rows = {}

-- Create the Rows to insert the data
local function CreateRow(parent, rowData)
    local row = AceGUI:Create("SimpleGroup")
    row:SetLayout("Flow")
    row:SetFullWidth(true)

    for _, cellData in ipairs(rowData) do
        local cell = AceGUI:Create("Label")
        cell:SetText(cellData)
        cell:SetWidth(100)
        row:AddChild(cell)
    end

    parent:AddChild(row)
end

--Table :)
local function CreateTable(parent, columns, rows)
    local header = AceGUI:Create("SimpleGroup")
    header:SetLayout("Flow")
    header:SetFullWidth(true)

    for _, column in ipairs(columns) do
        local headerCell = AceGUI:Create("Label")
        headerCell:SetText(column)
        headerCell:SetWidth(100)
        header:AddChild(headerCell)
    end

    parent:AddChild(header)

    for _, row in ipairs(rows) do
        CreateRow(parent, row)
    end
end

CreateTable(XddTrackerFrame, columns, rows)




-- Clear Children (content:ReleaseChildren was crashing the function)
    function ClearContentChildren(entry) 
        while #entry.children > 0 do
            local child = table.remove(entry.children)
            child:Release()
        end
    end
    
    local deathEntries = {}
    -- Dynamic Death List
    _G.UpdateDeathList = function ()
        print("puta de mensagem longa para se ver na puta do chat")
        
        -- Clear previous entries
        ClearContentChildren(XddTrackerFrame)
        
        local header = AceGUI:Create("SimpleGroup")
        header:SetLayout("Flow")
        header:SetFullWidth(true)
    
        for _, column in ipairs(columns) do
            local headerCell = AceGUI:Create("Label")
            headerCell:SetText(column)
            headerCell:SetWidth(100)
            header:AddChild(headerCell)
        end
        
        XddTrackerFrame:AddChild(header)
        local orderedDB = XddTracker:BubbleSort(XddTrackerDB)
        for _, entry in ipairs(orderedDB) do
            local name, count = entry[1], entry[2]
            CreateRow(XddTrackerFrame, { name, count })
        end
    end
    
    UpdateDeathList()




