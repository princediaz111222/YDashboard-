--// YDashboard
--// Activity + Movement Monitor
--// Deep Client-Side Inspector

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MAX_LOGS = 100

local ActivityEnabled = false
local MovementEnabled = false

local ActivityLogs = {}
local MovementLogs = {}

local MonitoredClicks = {}
local MonitoredPrompts = {}
local MonitoredTools = {}
local MonitoredButtons = {}

local LastMovement = nil
local Locked = false

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
YButton.Active = true
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

Instance.new("UICorner", Dashboard).CornerRadius = UDim.new(0, 10)

--==================================================
-- TITLE BAR
--==================================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 20
TitleBar.Active = true
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
Title.ZIndex = 21
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
LockButton.ZIndex = 25
LockButton.Active = true
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
CloseButton.ZIndex = 25
CloseButton.Active = true
CloseButton.Parent = TitleBar

Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 7)

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.fromOffset(10, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 15
Content.Parent = Dashboard

--==================================================
-- TABS
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 38)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 20
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
    Button.ZIndex = 25
    Button.Active = true
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
    Page.ZIndex = 15
    Page.Parent = Content

    return Page
end

local ActivityPage = CreatePage()
local MovementPage = CreatePage()

ActivityPage.Visible = true

--==================================================
-- BUTTON CREATOR
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
    Button.ZIndex = 30
    Button.Active = true
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
-- LOG PANEL
--==================================================

local function CreatePanel(Parent, Position, Size)

    local Panel = Instance.new("ScrollingFrame")
    Panel.Size = Size
    Panel.Position = Position
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.BorderSizePixel = 0
    Panel.ScrollBarThickness = 5
    Panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    Panel.ScrollingDirection = Enum.ScrollingDirection.Y
    Panel.Active = true
    Panel.ZIndex = 20
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
-- HELPERS
--==================================================

local function ClearPanel(Panel)

    for _, Object in ipairs(Panel:GetChildren()) do

        if not Object:IsA("UIListLayout")
        and not Object:IsA("UIPadding") then

            Object:Destroy()

        end

    end

end

local function SafePath(Object)

    if not Object then
        return "nil"
    end

    local Success, Result = pcall(function()
        return Object:GetFullName()
    end)

    if Success then
        return Result
    end

    return Object.Name
end

local function SafeValue(Object)

    local Success, Value = pcall(function()
        return Object.Value
    end)

    if not Success then
        return nil
    end

    if typeof(Value) == "Instance" then

        if Value then
            return SafePath(Value)
        end

        return "nil"
    end

    return tostring(Value)
end

local function AddDetail(Panel, Text)

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
    Label.ZIndex = 25
    Label.Parent = Panel

end

--==================================================
-- DEEP INSPECTOR
--==================================================

local function InspectObject(Object)

    ClearPanel(ActivityDetails)

    if not Object then

        AddDetail(
            ActivityDetails,
            "No object selected."
        )

        return
    end

    AddDetail(
        ActivityDetails,
        "========== TARGET =========="
    )

    AddDetail(
        ActivityDetails,
        "Name: " .. Object.Name
    )

    AddDetail(
        ActivityDetails,
        "Class: " .. Object.ClassName
    )

    AddDetail(
        ActivityDetails,
        "Path: " .. SafePath(Object)
    )

    --==================================================
    -- ANCESTORS
    --==================================================

    AddDetail(
        ActivityDetails,
        "\n========== ANCESTORS =========="
    )

    local Ancestor = Object.Parent

    while Ancestor and Ancestor ~= game do

        AddDetail(
            ActivityDetails,
            Ancestor.Name ..
            " [" ..
            Ancestor.ClassName ..
            "]"
        )

        Ancestor = Ancestor.Parent

    end

    --==================================================
    -- ATTRIBUTES
    --==================================================

    AddDetail(
        ActivityDetails,
        "\n========== ATTRIBUTES =========="
    )

    local Attributes = Object:GetAttributes()
    local AttributeCount = 0

    for Name, Value in pairs(Attributes) do

        AttributeCount += 1

        AddDetail(
            ActivityDetails,
            tostring(Name) ..
            " = " ..
            tostring(Value) ..
            " [" ..
            typeof(Value) ..
            "]"
        )

    end

    if AttributeCount == 0 then

        AddDetail(
            ActivityDetails,
            "None"
        )

    end

    --==================================================
    -- DIRECT CHILDREN
    --==================================================

    AddDetail(
        ActivityDetails,
        "\n========== CHILDREN =========="
    )

    local Children = Object:GetChildren()

    if #Children == 0 then

        AddDetail(
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

            if Child:IsA("ValueBase") then

                Text =
                    Text ..
                    " = " ..
                    SafeValue(Child)

            end

            AddDetail(
                ActivityDetails,
                Text
            )

        end

    end

    --==================================================
    -- RECURSIVE VALUES
    --==================================================

    AddDetail(
        ActivityDetails,
        "\n========== ALL VALUES =========="
    )

    local ValueCount = 0

    local function ScanValues(Parent, Depth)

        if Depth > 10 then
            return
        end

        for _, Child in ipairs(Parent:GetChildren()) do

            if Child:IsA("ValueBase") then

                ValueCount += 1

                local Prefix =
                    string.rep("  ", Depth)

                AddDetail(
                    ActivityDetails,

                    Prefix ..
                    Child.Name ..
                    " [" ..
                    Child.ClassName ..
                    "] = " ..
                    SafeValue(Child) ..

                    "\n" ..
                    Prefix ..
                    "Path: " ..
                    SafePath(Child)
                )

            end

            ScanValues(
                Child,
                Depth + 1
            )

        end

    end

    pcall(function()
        ScanValues(Object, 0)
    end)

    if ValueCount == 0 then

        AddDetail(
            ActivityDetails,
            "None"
        )

    end

    --==================================================
    -- ALL DESCENDANTS
    --==================================================

    AddDetail(
        ActivityDetails,
        "\n========== DESCENDANTS =========="
    )

    local Descendants = Object:GetDescendants()

    if #Descendants == 0 then

        AddDetail(
            ActivityDetails,
            "None"
        )

    else

        -- Prevent a gigantic UI from being generated
        local Limit = math.min(
            #Descendants,
            300
        )

        for Index = 1, Limit do

            local Child =
                Descendants[Index]

            local Text =
                Child.Name ..
                " [" ..
                Child.ClassName ..
                "]"

            if Child:IsA("ValueBase") then

                Text =
                    Text ..
                    " = " ..
                    SafeValue(Child)

            end

            AddDetail(
                ActivityDetails,
                Text
            )

        end

        if #Descendants > Limit then

            AddDetail(
                ActivityDetails,

                "... " ..
                tostring(
                    #Descendants - Limit
                ) ..
                " more descendants ..."
            )

        end

    end

end

--==================================================
-- ACTIVITY DETAILS
--==================================================

local function ShowActivity(Log)

    if not Log then

        ClearPanel(ActivityDetails)

        AddDetail(
            ActivityDetails,
            "Tap an activity to inspect it."
        )

        return

    end

    InspectObject(Log.Object)

    -- Put interaction info at the top by inserting
    -- a small header isn't necessary; target data follows.
    -- The event information is preserved in the log itself.

end

--==================================================
-- MOVEMENT DETAILS
--==================================================

local function ShowMovement(Log)

    ClearPanel(MovementDetails)

    if not Log then

        AddDetail(
            MovementDetails,
            "Tap a movement event to inspect it."
        )

        return

    end

    AddDetail(
        MovementDetails,
        "========== MOVEMENT =========="
    )

    AddDetail(
        MovementDetails,
        "State: " .. Log.State
    )

    AddDetail(
        MovementDetails,
        "Time: " .. Log.Time
    )

    AddDetail(
        MovementDetails,
        "Humanoid: " .. Log.Humanoid
    )

    if LocalPlayer.Character then

        AddDetail(
            MovementDetails,
            "Character: " ..
            SafePath(
                LocalPlayer.Character
            )
        )

    end

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

        Button.ZIndex = 30
        Button.Active = true
        Button.AutoButtonColor = true

        Button.Parent = ActivityList

        Instance.new("UICorner", Button)
            .CornerRadius = UDim.new(0, 5)

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 5)
        Padding.Parent = Button

        Button.MouseButton1Click:Connect(function()

            ShowActivity(Log)

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

        Button.ZIndex = 30
        Button.Active = true

        Button.Parent = MovementList

        Instance.new("UICorner", Button)
            .CornerRadius = UDim.new(0, 5)

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.Parent = Button

        Button.MouseButton1Click:Connect(function()

            ShowMovement(Log)

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

    if not Object then
        return
    end

    if Object == ScreenGui
    or Object:IsDescendantOf(ScreenGui) then
        return
    end

    local Log = {

        Time = os.date("%H:%M:%S"),

        EventType = EventType,

        Name = Object.Name,

        Class = Object.ClassName,

        Path = SafePath(Object),

        Details = Details or "",

        Object = Object

    }

    table.insert(
        ActivityLogs,
        1,
        Log
    )

    if #ActivityLogs > MAX_LOGS then
        table.remove(ActivityLogs)
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

    table.insert(
        MovementLogs,
        1,
        {
            State = State,
            Time = os.date("%H:%M:%S"),
            Humanoid =
                Humanoid and
                Humanoid.Name or
                "nil"
        }
    )

    if #MovementLogs > MAX_LOGS then
        table.remove(MovementLogs)
    end

    RefreshMovement()

end

--==================================================
-- CLICK DETECTORS
--==================================================

local function MonitorClick(Detector)

    if MonitoredClicks[Detector] then
        return
    end

    MonitoredClicks[Detector] = true

    Detector.MouseClick:Connect(function(Player)

        if Player ~= LocalPlayer then
            return
        end

        local Target = Detector.Parent

        if not Target then
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
-- PROXIMITY PROMPTS
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

        if not Target then
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
-- TOOLS
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
-- GAME GUI
--==================================================

local function MonitorGuiButton(Button)

    if not Button:IsA("GuiButton") then
        return
    end

    if Button:IsDescendantOf(ScreenGui) then
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

        MonitorClick(Object)

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

        MonitorClick(Object)

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
-- TOOL SCAN
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

    if LocalPlayer.Character then

        for _, Tool in ipairs(
            LocalPlayer.Character:GetChildren()
        ) do

            MonitorTool(Tool)

        end

    end

end

local function MonitorToolContainer(Container)

    if not Container then
        return
    end

    Container.ChildAdded:Connect(function(Object)

        if Object:IsA("Tool") then
            MonitorTool(Object)
        end

    end)

end

local Backpack =
    LocalPlayer:FindFirstChildOfClass(
        "Backpack"
    )

if Backpack then
    MonitorToolContainer(Backpack)
end

LocalPlayer.CharacterAdded:Connect(function(Character)

    MonitorToolContainer(Character)

    task.wait(0.2)

    ScanTools()

end)

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
                Enum.HumanoidStateType.Running
            or NewState ==
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
    SetupMovement(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(Character)

    LastMovement = nil

    SetupMovement(Character)

end)

--==================================================
-- TOGGLES
--==================================================

ActivityToggle.MouseButton1Click:Connect(function()

    ActivityEnabled = not ActivityEnabled

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

end)

MovementToggle.MouseButton1Click:Connect(function()

    MovementEnabled = not MovementEnabled

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

end)

--==================================================
-- CLEAR
--==================================================

ActivityClear.MouseButton1Click:Connect(function()

    table.clear(ActivityLogs)

    RefreshActivity()

    ClearPanel(ActivityDetails)

    AddDetail(
        ActivityDetails,
        "Tap an activity to inspect it."
    )

end)

MovementClear.MouseButton1Click:Connect(function()

    table.clear(MovementLogs)

    LastMovement = nil

    RefreshMovement()

    ClearPanel(MovementDetails)

    AddDetail(
        MovementDetails,
        "Tap a movement event to inspect it."
    )

end)

--==================================================
-- COPY
--==================================================

ActivityCopy.MouseButton1Click:Connect(function()

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

end)

MovementCopy.MouseButton1Click:Connect(function()

    if not setclipboard then
        return
    end

    local Output = {}

    for _, Log in ipairs(MovementLogs) do

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

end)

--==================================================
-- TABS
--==================================================

ActivityTab.MouseButton1Click:Connect(function()

    ActivityPage.Visible = true
    MovementPage.Visible = false

end)

MovementTab.MouseButton1Click:Connect(function()

    ActivityPage.Visible = false
    MovementPage.Visible = true

end)

--==================================================
-- Y BUTTON
--==================================================

YButton.MouseButton1Click:Connect(function()

    Dashboard.Visible =
        not Dashboard.Visible

end)

--==================================================
-- CLOSE
--==================================================

CloseButton.MouseButton1Click:Connect(function()

    Dashboard.Visible = false

end)

--==================================================
-- LOCK
--==================================================

LockButton.MouseButton1Click:Connect(function()

    Locked = not Locked

    if Locked then
        LockButton.Text = "🔒"
    else
        LockButton.Text = "🔓"
    end

end)

--==================================================
-- DRAGGING
--==================================================

local function MakeDraggable(Object, RespectLock)

    local Dragging = false
    local DragStart
    local StartPosition

    Object.InputBegan:Connect(function(Input)

        if RespectLock and Locked then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()

                if Input.UserInputState ==
                    Enum.UserInputState.End then

                    Dragging = false

                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

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
            Input.Position - DragStart

        Object.Position = UDim2.new(

            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y

        )

    end)

end

MakeDraggable(TitleBar, true)
MakeDraggable(YButton, false)

--==================================================
-- INITIAL MESSAGE
--==================================================

ClearPanel(ActivityDetails)
AddDetail(
    ActivityDetails,
    "Tap an activity to inspect it."
)

ClearPanel(MovementDetails)
AddDetail(
    MovementDetails,
    "Tap a movement event to inspect it."
)

print("YDashboard loaded.")
