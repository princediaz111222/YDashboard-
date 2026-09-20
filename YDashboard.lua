--// YDashboard
--// Activity + Movement Monitor
--// Deep Client-Side Object Inspector

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local MAX_LOGS = 100
local MAX_INSPECTED_OBJECTS = 500

local ActivityEnabled = false
local MovementEnabled = false

local ActivityLogs = {}
local MovementLogs = {}

local MonitoredClicks = {}
local MonitoredPrompts = {}
local MonitoredTools = {}
local MonitoredButtons = {}

local SelectedActivity = nil
local SelectedMovement = nil
local LastMovement = nil

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YDashboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- Y BUTTON
--==================================================

local YButton = Instance.new("TextButton")
YButton.Name = "YButton"
YButton.Size = UDim2.fromOffset(48, 48)
YButton.Position = UDim2.new(0, 20, 0.5, -24)
YButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
YButton.BorderSizePixel = 0
YButton.Text = "Y"
YButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YButton.TextSize = 21
YButton.Font = Enum.Font.GothamBold
YButton.ZIndex = 100
YButton.Parent = ScreenGui

local YCorner = Instance.new("UICorner")
YCorner.CornerRadius = UDim.new(1, 0)
YCorner.Parent = YButton

--==================================================
-- DASHBOARD
--==================================================

local Dashboard = Instance.new("Frame")
Dashboard.Name = "Main"
Dashboard.Size = UDim2.fromOffset(700, 450)
Dashboard.Position = UDim2.new(0.5, -350, 0.5, -225)
Dashboard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Dashboard.BorderSizePixel = 0
Dashboard.Visible = true
Dashboard.ZIndex = 10
Dashboard.Parent = ScreenGui

local DashboardCorner = Instance.new("UICorner")
DashboardCorner.CornerRadius = UDim.new(0, 10)
DashboardCorner.Parent = Dashboard

--==================================================
-- TITLE BAR
--==================================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Dashboard

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "YDashboard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = TitleBar

--==================================================
-- LOCK
--==================================================

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.fromOffset(34, 34)
LockButton.Position = UDim2.new(1, -82, 0, 6)
LockButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LockButton.BorderSizePixel = 0
LockButton.Text = "🔓"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 15
LockButton.Font = Enum.Font.GothamBold
LockButton.ZIndex = 12
LockButton.Parent = TitleBar

Instance.new("UICorner", LockButton).CornerRadius = UDim.new(0, 7)

--==================================================
-- CLOSE
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -42, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 12
CloseButton.Parent = TitleBar

Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 7)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.fromOffset(10, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Dashboard

--==================================================
-- TABS
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 38)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabBar

local function CreateTab(Text)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(115, 35)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = TabBar

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 7)

    return Button
end

local ActivityTab = CreateTab("ACTIVITY")
local MovementTab = CreateTab("MOVEMENT")

--==================================================
-- PAGES
--==================================================

local function CreatePage()

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, -45)
    Page.Position = UDim2.fromOffset(0, 45)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Content

    return Page
end

local ActivityPage = CreatePage()
local MovementPage = CreatePage()

ActivityPage.Visible = true

--==================================================
-- BUTTON
--==================================================

local function CreateButton(Parent, Text, Position, Size)

    local Button = Instance.new("TextButton")
    Button.Size = Size
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Parent

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 7)

    return Button
end

--==================================================
-- CONTROLS
--==================================================

local ActivityToggle = CreateButton(
    ActivityPage,
    "ACTIVITY: OFF",
    UDim2.fromOffset(0, 0),
    UDim2.fromOffset(115, 35)
)

local ActivityClear = CreateButton(
    ActivityPage,
    "CLEAR",
    UDim2.fromOffset(123, 0),
    UDim2.fromOffset(75, 35)
)

local ActivityCopy = CreateButton(
    ActivityPage,
    "COPY",
    UDim2.fromOffset(206, 0),
    UDim2.fromOffset(75, 35)
)

local MovementToggle = CreateButton(
    MovementPage,
    "MOVEMENT: OFF",
    UDim2.fromOffset(0, 0),
    UDim2.fromOffset(115, 35)
)

local MovementClear = CreateButton(
    MovementPage,
    "CLEAR",
    UDim2.fromOffset(123, 0),
    UDim2.fromOffset(75, 35)
)

local MovementCopy = CreateButton(
    MovementPage,
    "COPY",
    UDim2.fromOffset(206, 0),
    UDim2.fromOffset(75, 35)
)

--==================================================
-- PANELS
--==================================================

local function CreatePanel(Parent, Position, Size)

    local Panel = Instance.new("ScrollingFrame")
    Panel.Size = Size
    Panel.Position = Position
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.BorderSizePixel = 0
    Panel.ScrollBarThickness = 5
    Panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Panel.CanvasSize = UDim2.new()
    Panel.ScrollingDirection = Enum.ScrollingDirection.Y
    Panel.Parent = Parent

    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 7)
    Padding.PaddingBottom = UDim.new(0, 7)
    Padding.PaddingLeft = UDim.new(0, 7)
    Padding.PaddingRight = UDim.new(0, 7)
    Padding.Parent = Panel

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Panel

    return Panel
end

local ActivityList = CreatePanel(
    ActivityPage,
    UDim2.new(0, 0, 0, 45),
    UDim2.new(0.48, -5, 1, -45)
)

local ActivityDetails = CreatePanel(
    ActivityPage,
    UDim2.new(0.48, 5, 0, 45),
    UDim2.new(0.52, -5, 1, -45)
)

local MovementList = CreatePanel(
    MovementPage,
    UDim2.new(0, 0, 0, 45),
    UDim2.new(0.48, -5, 1, -45)
)

local MovementDetails = CreatePanel(
    MovementPage,
    UDim2.new(0.48, 5, 0, 45),
    UDim2.new(0.52, -5, 1, -45)
)

--==================================================
-- PANEL CLEAR
--==================================================

local function ClearPanel(Panel)

    for _, Child in ipairs(Panel:GetChildren()) do

        if not Child:IsA("UIListLayout")
        and not Child:IsA("UIPadding") then

            Child:Destroy()

        end

    end

end

--==================================================
-- TEXT LABEL
--==================================================

local function CreateDetailsLabel(Parent, Text)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -5, 0, 20)
    Label.AutomaticSize = Enum.AutomaticSize.Y
    Label.BackgroundTransparency = 1

    Label.Text = Text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Code

    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Top
    Label.TextWrapped = true

    Label.Parent = Parent

    return Label
end

--==================================================
-- SAFE VALUE READER
--==================================================

local function ReadValue(Object)

    local Success, Value = pcall(function()
        return Object.Value
    end)

    if not Success then
        return nil
    end

    if typeof(Value) == "Instance" then

        if Value then
            return Value:GetFullName()
        end

        return "nil"
    end

    return Value
end

--==================================================
-- VALUE TYPE CHECK
--==================================================

local function IsValueObject(Object)

    return Object:IsA("ValueBase")
end

--==================================================
-- ATTRIBUTE READER
--==================================================

local function GetAttributes(Object)

    local Attributes = {}

    local Success, Result = pcall(function()
        return Object:GetAttributes()
    end)

    if not Success then
        return Attributes
    end

    for Name, Value in pairs(Result) do

        table.insert(
            Attributes,
            {
                Name = tostring(Name),
                Value = tostring(Value),
                Type = typeof(Value)
            }
        )

    end

    table.sort(Attributes, function(A, B)
        return A.Name:lower() < B.Name:lower()
    end)

    return Attributes

end

--==================================================
-- DEEP INSPECTION
--==================================================

local function BuildDeepInspection(Object)

    if not Object then
        return nil
    end

    local Data = {
        Name = Object.Name,
        Class = Object.ClassName,
        Path = "nil",
        Ancestors = {},
        Children = {},
        Attributes = {},
        Values = {},
        Properties = {}
    }

    pcall(function()
        Data.Path = Object:GetFullName()
    end)

    --==================================================
    -- ANCESTORS
    --==================================================

    local Current = Object

    while Current and Current ~= game do

        table.insert(
            Data.Ancestors,
            1,
            {
                Name = Current.Name,
                Class = Current.ClassName
            }
        )

        Current = Current.Parent

    end

    --==================================================
    -- ATTRIBUTES
    --==================================================

    Data.Attributes = GetAttributes(Object)

    --==================================================
    -- CHILDREN
    --==================================================

    local Success, Children = pcall(function()
        return Object:GetChildren()
    end)

    if Success then

        for _, Child in ipairs(Children) do

            local ChildInfo = {
                Name = Child.Name,
                Class = Child.ClassName
            }

            if IsValueObject(Child) then

                local Value = ReadValue(Child)

                ChildInfo.Value = tostring(Value)

                table.insert(
                    Data.Values,
                    {
                        Path = GetPathSafe(Child),
                        Name = Child.Name,
                        Class = Child.ClassName,
                        Value = tostring(Value)
                    }
                )

            end

            table.insert(Data.Children, ChildInfo)

        end

    end

    --==================================================
    -- OBJECT ITSELF IF VALUE
    --==================================================

    if IsValueObject(Object) then

        local Value = ReadValue(Object)

        table.insert(
            Data.Values,
            {
                Path = Data.Path,
                Name = Object.Name,
                Class = Object.ClassName,
                Value = tostring(Value)
            }
        )

    end

    return Data

end

--==================================================
-- SAFE PATH
--==================================================

function GetPathSafe(Object)

    if not Object then
        return "nil"
    end

    local Success, Path = pcall(function()
        return Object:GetFullName()
    end)

    if Success then
        return Path
    end

    return Object.Name
end

--==================================================
-- RECURSIVE DESCENDANT INSPECTION
--==================================================

local function CollectDescendants(Object, Output, Depth)

    Depth = Depth or 0

    if Depth > 12 then
        return
    end

    local Success, Children = pcall(function()
        return Object:GetChildren()
    end)

    if not Success then
        return
    end

    for _, Child in ipairs(Children) do

        if #Output >= MAX_INSPECTED_OBJECTS then
            return
        end

        local Info = {
            Name = Child.Name,
            Class = Child.ClassName,
            Path = GetPathSafe(Child),
            Depth = Depth + 1
        }

        if IsValueObject(Child) then
            Info.Value = tostring(ReadValue(Child))
        end

        Info.Attributes = GetAttributes(Child)

        table.insert(Output, Info)

        CollectDescendants(
            Child,
            Output,
            Depth + 1
        )

    end

end

--==================================================
-- ACTIVITY DETAILS
--==================================================

local function ShowActivityDetails(Log)

    ClearPanel(ActivityDetails)

    if not Log then

        CreateDetailsLabel(
            ActivityDetails,
            "Tap an activity entry to inspect it."
        )

        return
    end

    CreateDetailsLabel(
        ActivityDetails,
        "ACTIVITY DETAILS"
    )

    CreateDetailsLabel(
        ActivityDetails,
        "Event: " .. Log.EventType
    )

    CreateDetailsLabel(
        ActivityDetails,
        "Time: " .. Log.Time
    )

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "TARGET"
    )

    CreateDetailsLabel(
        ActivityDetails,
        "Name: " .. Log.Name
    )

    CreateDetailsLabel(
        ActivityDetails,
        "Class: " .. Log.Class
    )

    CreateDetailsLabel(
        ActivityDetails,
        "Path: " .. Log.Path
    )

    if Log.Details ~= "" then

        CreateDetailsLabel(
            ActivityDetails,
            ""
        )

        CreateDetailsLabel(
            ActivityDetails,
            "INTERACTION"
        )

        CreateDetailsLabel(
            ActivityDetails,
            Log.Details
        )

    end

    if not Log.Object then
        return
    end

    local Object = Log.Object

    --==================================================
    -- ANCESTORS
    --==================================================

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "ANCESTOR HIERARCHY"
    )

    local Current = Object
    local Ancestors = {}

    while Current and Current ~= game do

        table.insert(
            Ancestors,
            1,
            Current.Name ..
            " [" ..
            Current.ClassName ..
            "]"
        )

        Current = Current.Parent

    end

    for _, Text in ipairs(Ancestors) do

        CreateDetailsLabel(
            ActivityDetails,
            Text
        )

    end

    --==================================================
    -- ATTRIBUTES
    --==================================================

    local Attributes = GetAttributes(Object)

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "ATTRIBUTES (" ..
        tostring(#Attributes) ..
        ")"
    )

    if #Attributes == 0 then

        CreateDetailsLabel(
            ActivityDetails,
            "None"
        )

    else

        for _, Attribute in ipairs(Attributes) do

            CreateDetailsLabel(
                ActivityDetails,
                Attribute.Name ..
                " = " ..
                Attribute.Value ..
                " [" ..
                Attribute.Type ..
                "]"
            )

        end

    end

    --==================================================
    -- DIRECT CHILDREN
    --==================================================

    local Children = Object:GetChildren()

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "DIRECT CHILDREN (" ..
        tostring(#Children) ..
        ")"
    )

    if #Children == 0 then

        CreateDetailsLabel(
            ActivityDetails,
            "None"
        )

    else

        for _, Child in ipairs(Children) do

            local Text =
                Child.Name ..
                " [" ..
                Child.ClassName ..
                "]"

            if IsValueObject(Child) then

                Text = Text ..
                    " = " ..
                    tostring(ReadValue(Child))

            end

            CreateDetailsLabel(
                ActivityDetails,
                Text
            )

        end

    end

    --==================================================
    -- VALUE OBJECTS
    --==================================================

    local Values = {}

    local function FindValues(Parent)

        for _, Child in ipairs(Parent:GetChildren()) do

            if IsValueObject(Child) then

                table.insert(
                    Values,
                    {
                        Name = Child.Name,
                        Class = Child.ClassName,
                        Path = GetPathSafe(Child),
                        Value = tostring(ReadValue(Child))
                    }
                )

            end

            FindValues(Child)

        end

    end

    pcall(function()
        FindValues(Object)
    end)

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "VALUE OBJECTS (" ..
        tostring(#Values) ..
        ")"
    )

    if #Values == 0 then

        CreateDetailsLabel(
            ActivityDetails,
            "None"
        )

    else

        for _, Value in ipairs(Values) do

            CreateDetailsLabel(
                ActivityDetails,

                Value.Name ..
                " [" ..
                Value.Class ..
                "]\n" ..
                "Value: " ..
                Value.Value ..
                "\nPath: " ..
                Value.Path

            )

        end

    end

    --==================================================
    -- ALL DESCENDANTS
    --==================================================

    local Descendants = {}

    pcall(function()

        CollectDescendants(
            Object,
            Descendants,
            0
        )

    end)

    CreateDetailsLabel(
        ActivityDetails,
        ""
    )

    CreateDetailsLabel(
        ActivityDetails,
        "ALL DESCENDANTS (" ..
        tostring(#Descendants) ..
        ")"
    )

    if #Descendants == 0 then

        CreateDetailsLabel(
            ActivityDetails,
            "None"
        )

    else

        for _, Descendant in ipairs(Descendants) do

            local Prefix = string.rep(
                "  ",
                Descendant.Depth
            )

            local Text =
                Prefix ..
                Descendant.Name ..
                " [" ..
                Descendant.Class ..
                "]"

            if Descendant.Value ~= nil then

                Text = Text ..
                    " = " ..
                    Descendant.Value

            end

            CreateDetailsLabel(
                ActivityDetails,
                Text
            )

        end

    end

end

--==================================================
-- MOVEMENT DETAILS
--==================================================

local function ShowMovementDetails(Log)

    ClearPanel(MovementDetails)

    if not Log then

        CreateDetailsLabel(
            MovementDetails,
            "Tap a movement entry to inspect it."
        )

        return

    end

    CreateDetailsLabel(
        MovementDetails,
        "MOVEMENT DETAILS"
    )

    CreateDetailsLabel(
        MovementDetails,
        "State: " .. Log.State
    )

    CreateDetailsLabel(
        MovementDetails,
        "Time: " .. Log.Time
    )

    CreateDetailsLabel(
        MovementDetails,
        "Humanoid: " .. Log.Humanoid
    )

    CreateDetailsLabel(
        MovementDetails,
        "Character: " ..
        (LocalPlayer.Character and
            GetPathSafe(LocalPlayer.Character)
            or "nil")
    )

end

--==================================================
-- REFRESH ACTIVITY
--==================================================

local function RefreshActivity()

    ClearPanel(ActivityList)

    for Index, Log in ipairs(ActivityLogs) do

        local Button = Instance.new("TextButton")

        Button.LayoutOrder = Index
        Button.Size = UDim2.new(1, -5, 0, 55)
        Button.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Button.BorderSizePixel = 0

        Button.Text =
            "[" ..
            Log.Time ..
            "] " ..
            Log.EventType ..
            "\n" ..
            Log.Name

        Button.TextColor3 =
            Color3.fromRGB(225, 225, 225)

        Button.TextSize = 12
        Button.Font = Enum.Font.Code

        Button.TextXAlignment =
            Enum.TextXAlignment.Left

        Button.TextYAlignment =
            Enum.TextYAlignment.Center

        Button.TextWrapped = true

        Button.Parent = ActivityList

        Instance.new("UICorner", Button)
            .CornerRadius = UDim.new(0, 5)

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 5)
        Padding.Parent = Button

        Button.MouseButton1Click:Connect(function()

            SelectedActivity = Log

            ShowActivityDetails(Log)

        end)

    end

end

--==================================================
-- REFRESH MOVEMENT
--==================================================

local function RefreshMovement()

    ClearPanel(MovementList)

    for Index, Log in ipairs(MovementLogs) do

        local Button = Instance.new("TextButton")

        Button.LayoutOrder = Index
        Button.Size = UDim2.new(1, -5, 0, 35)
        Button.BackgroundColor3 =
            Color3.fromRGB(32, 32, 32)

        Button.BorderSizePixel = 0

        Button.Text =
            "[" ..
            Log.Time ..
            "] " ..
            Log.State

        Button.TextColor3 =
            Color3.fromRGB(225, 225, 225)

        Button.TextSize = 12
        Button.Font = Enum.Font.Code
        Button.TextXAlignment =
            Enum.TextXAlignment.Left

        Button.Parent = MovementList

        Instance.new("UICorner", Button)
            .CornerRadius = UDim.new(0, 5)

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.Parent = Button

        Button.MouseButton1Click:Connect(function()

            SelectedMovement = Log

            ShowMovementDetails(Log)

        end)

    end

end

--==================================================
-- ACTIVITY LOGGER
--==================================================

local function LogActivity(
    EventType,
    Object,
    Details
)

    if not ActivityEnabled then
        return
    end

    if IsYDashboardObject(Object) then
        return
    end

    local Log = {

        EventType = EventType,

        Time = os.date("%H:%M:%S"),

        Name =
            Object and
            Object.Name or
            "nil",

        Class =
            Object and
            Object.ClassName or
            "nil",

        Path =
            Object and
            GetPathSafe(Object) or
            "nil",

        Details = Details or "",

        Object = Object

    }

    table.insert(
        ActivityLogs,
        1,
        Log
    )

    if #ActivityLogs > MAX_LOGS then

        table.remove(
            ActivityLogs
        )

    end

    RefreshActivity()

end

--==================================================
-- MOVEMENT LOGGER
--==================================================

local function LogMovement(
    State,
    Humanoid
)

    if not MovementEnabled then
        return
    end

    if State == LastMovement then
        return
    end

    LastMovement = State

    local Log = {

        State = State,

        Time = os.date("%H:%M:%S"),

        Humanoid =
            Humanoid and
            Humanoid.Name or
            "nil"

    }

    table.insert(
        MovementLogs,
        1,
        Log
    )

    if #MovementLogs > MAX_LOGS then

        table.remove(
            MovementLogs
        )

    end

    RefreshMovement()

end

--==================================================
-- CLICK DETECTOR
--==================================================

local function MonitorClickDetector(Detector)

    if MonitoredClicks[Detector] then
        return
    end

    MonitoredClicks[Detector] = true

    Detector.MouseClick:Connect(function(Player)

        if Player ~= LocalPlayer then
            return
        end

        local Target = Detector.Parent

        if IsYDashboardObject(Target) then
            return
        end

        LogActivity(
            "CLICK",
            Target,
            "Interaction: ClickDetector"
        )

    end)

end

--==================================================
-- PROXIMITY PROMPT
--==================================================

local function MonitorPrompt(Prompt)

    if MonitoredPrompts[Prompt] then
        return
    end

    MonitoredPrompts[Prompt] = true

    Prompt.Triggered:Connect(function(Player)

        if Player ~= LocalPlayer then
            return
        end

        local Target = Prompt.Parent

        if IsYDashboardObject(Target) then
            return
        end

        local Details =
            "Interaction: ProximityPrompt"

        if Prompt.ActionText ~= "" then

            Details =
                Details ..
                "\nActionText: " ..
                Prompt.ActionText

        end

        if Prompt.ObjectText ~= "" then

            Details =
                Details ..
                "\nObjectText: " ..
                Prompt.ObjectText

        end

        LogActivity(
            "PROMPT",
            Target,
            Details
        )

    end)

end

--==================================================
-- TOOL
--==================================================

local function MonitorTool(Tool)

    if not Tool:IsA("Tool") then
        return
    end

    if MonitoredTools[Tool] then
        return
    end

    MonitoredTools[Tool] = true

    Tool.Activated:Connect(function()

        LogActivity(
            "TOOL ACTIVATED",
            Tool,
            "Interaction: Tool.Activated"
        )

    end)

end

--==================================================
-- GUI BUTTON
--==================================================

local function MonitorGuiButton(Button)

    if not Button:IsA("GuiButton") then
        return
    end

    if IsYDashboardObject(Button) then
        return
    end

    if MonitoredButtons[Button] then
        return
    end

    MonitoredButtons[Button] = true

    Button.Activated:Connect(function()

        LogActivity(
            "GUI INTERACTION",
            Button,
            "Interaction: GuiButton.Activated"
        )

    end)

end

--==================================================
-- INITIAL SCAN
--==================================================

for _, Object in ipairs(
    Workspace:GetDescendants()
) do

    if Object:IsA("ClickDetector") then

        MonitorClickDetector(Object)

    elseif Object:IsA("ProximityPrompt") then

        MonitorPrompt(Object)

    end

end

for _, Object in ipairs(
    PlayerGui:GetDescendants()
) do

    if Object:IsA("GuiButton") then

        MonitorGuiButton(Object)

    end

end

--==================================================
-- NEW OBJECTS
--==================================================

Workspace.DescendantAdded:Connect(function(Object)

    if Object:IsA("ClickDetector") then

        MonitorClickDetector(Object)

    elseif Object:IsA("ProximityPrompt") then

        MonitorPrompt(Object)

    end

end)

PlayerGui.DescendantAdded:Connect(function(Object)

    if Object:IsA("GuiButton") then

        MonitorGuiButton(Object)

    end

end)

--==================================================
-- TOOLS
--==================================================

local function ScanTools()

    local Backpack =
        LocalPlayer:FindFirstChildOfClass(
            "Backpack"
        )

    if Backpack then

        for _, Tool in ipairs(
            Backpack:GetChildren()
        ) do

            MonitorTool(Tool)

        end

    end

    local Character =
        LocalPlayer.Character

    if Character then

        for _, Tool in ipairs(
            Character:GetChildren()
        ) do

            MonitorTool(Tool)

        end

    end

end

local function MonitorToolContainer(
    Container
)

    if not Container then
        return
    end

    Container.ChildAdded:Connect(
        function(Object)

            if Object:IsA("Tool") then

                MonitorTool(Object)

            end

        end
    )

end

local Backpack =
    LocalPlayer:FindFirstChildOfClass(
        "Backpack"
    )

if Backpack then
    MonitorToolContainer(Backpack)
end

LocalPlayer.CharacterAdded:Connect(
    function(Character)

        MonitorToolContainer(Character)

        task.wait(0.2)

        ScanTools()

    end
)

ScanTools()

--==================================================
-- MOVEMENT
--==================================================

local function SetupMovement(Character)

    local Humanoid =
        Character:WaitForChild("Humanoid")

    Humanoid.StateChanged:Connect(
        function(_, NewState)

            if NewState ==
                Enum.HumanoidStateType.Jumping then

                LogMovement(
                    "JUMPING",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Freefall then

                LogMovement(
                    "FALLING",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Landed then

                LogMovement(
                    "LANDED",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Climbing then

                LogMovement(
                    "CLIMBING",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Swimming then

                LogMovement(
                    "SWIMMING",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Seated then

                LogMovement(
                    "SEATED",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.Running then

                LogMovement(
                    "RUNNING",
                    Humanoid
                )

            elseif NewState ==
                Enum.HumanoidStateType.RunningNoPhysics then

                LogMovement(
                    "RUNNING",
                    Humanoid
                )

            end

        end
    )

end

if LocalPlayer.Character then

    SetupMovement(
        LocalPlayer.Character
    )

end

LocalPlayer.CharacterAdded:Connect(
    function(Character)

        LastMovement = nil

        SetupMovement(Character)

    end
)

--==================================================
-- TOGGLES
--==================================================

ActivityToggle.MouseButton1Click:Connect(
    function()

        ActivityEnabled =
            not ActivityEnabled

        if ActivityEnabled then

            ActivityToggle.Text =
                "ACTIVITY: ON"

            ActivityToggle.BackgroundColor3 =
                Color3.fromRGB(40, 120, 60)

        else

            ActivityToggle.Text =
                "ACTIVITY: OFF"

            ActivityToggle.BackgroundColor3 =
                Color3.fromRGB(120, 40, 40)

        end

    end
)

MovementToggle.MouseButton1Click:Connect(
    function()

        MovementEnabled =
            not MovementEnabled

        if MovementEnabled then

            MovementToggle.Text =
                "MOVEMENT: ON"

            MovementToggle.BackgroundColor3 =
                Color3.fromRGB(40, 120, 60)

        else

            MovementToggle.Text =
                "MOVEMENT: OFF"

            MovementToggle.BackgroundColor3 =
                Color3.fromRGB(120, 40, 40)

        end

    end
)

--==================================================
-- CLEAR
--==================================================

ActivityClear.MouseButton1Click:Connect(
    function()

        table.clear(ActivityLogs)

        SelectedActivity = nil

        RefreshActivity()
        ShowActivityDetails(nil)

    end
)

MovementClear.MouseButton1Click:Connect(
    function()

        table.clear(MovementLogs)

        SelectedMovement = nil
        LastMovement = nil

        RefreshMovement()
        ShowMovementDetails(nil)

    end
)

--==================================================
-- COPY ACTIVITY
--==================================================

ActivityCopy.MouseButton1Click:Connect(
    function()

        if not setclipboard then
            return
        end

        local Output = {}

        for _, Log in ipairs(ActivityLogs) do

            table.insert(
                Output,

                "[" ..
                Log.Time ..
                "] " ..
                Log.EventType ..

                "\nName: " ..
                Log.Name ..

                "\nClass: " ..
                Log.Class ..

                "\nPath: " ..
                Log.Path ..

                (
                    Log.Details ~= ""
                    and
                    "\nDetails: " ..
                    Log.Details
                    or
                    ""
                )

            )

        end

        setclipboard(
            table.concat(
                Output,
                "\n\n"
            )
        )

    end
)

--==================================================
-- COPY MOVEMENT
--==================================================

MovementCopy.MouseButton1Click:Connect(
    function()

        if not setclipboard then
            return
        end

        local Output = {}

        for _, Log in ipairs(
            MovementLogs
        ) do

            table.insert(
                Output,

                "[" ..
                Log.Time ..
                "] MOVEMENT: " ..
                Log.State

            )

        end

        setclipboard(
            table.concat(
                Output,
                "\n\n"
            )
        )

    end
)

--==================================================
-- TABS
--==================================================

ActivityTab.MouseButton1Click:Connect(
    function()

        ActivityPage.Visible = true
        MovementPage.Visible = false

    end
)

MovementTab.MouseButton1Click:Connect(
    function()

        ActivityPage.Visible = false
        MovementPage.Visible = true

    end
)

--==================================================
-- VISIBILITY
--==================================================

YButton.MouseButton1Click:Connect(
    function()

        Dashboard.Visible =
            not Dashboard.Visible

    end
)

CloseButton.MouseButton1Click:Connect(
    function()

        Dashboard.Visible = false

    end
)

--==================================================
-- LOCK
--==================================================

local Locked = false

LockButton.MouseButton1Click:Connect(
    function()

        Locked = not Locked

        if Locked then
            LockButton.Text = "🔒"
        else
            LockButton.Text = "🔓"
        end

    end
)

--==================================================
-- DRAGGING
--==================================================

local function MakeDraggable(
    Object,
    RespectLock
)

    local Dragging = false
    local DragStart
    local StartPosition

    Object.InputBegan:Connect(
        function(Input)

            if RespectLock and Locked then
                return
            end

            if Input.UserInputType ==
                Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
                Enum.UserInputType.Touch then

                Dragging = true

                DragStart =
                    Input.Position

                StartPosition =
                    Object.Position

                Input.Changed:Connect(
                    function()

                        if Input.UserInputState ==
                            Enum.UserInputState.End then

                            Dragging = false

                        end

                    end
                )

            end

        end
    )

    UserInputService.InputChanged:Connect(
        function(Input)

            if not Dragging then
                return
            end

            if Input.UserInputType ~=
                Enum.UserInputType.MouseMovement
            and Input.UserInputType ~=
                Enum.UserInputType.Touch then

                return

            end

            local Delta =
                Input.Position -
                DragStart

            Object.Position = UDim2.new(

                StartPosition.X.Scale,
                StartPosition.X.Offset +
                    Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset +
                    Delta.Y

            )

        end
    )

end

MakeDraggable(
    TitleBar,
    true
)

MakeDraggable(
    YButton,
    false
)

--==================================================
-- INITIAL DETAILS
--==================================================

ShowActivityDetails(nil)
ShowMovementDetails(nil)

print("YDashboard loaded.")
