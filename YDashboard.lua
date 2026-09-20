--// YDashboard - Activity + Movement Monitor
--// Activity monitoring uses normal client-visible Roblox interaction events.
--// No remote spying / hooking / source extraction.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local MAX_LOGS = 100

local ActivityEnabled = false
local MovementEnabled = false

local ActivityLogs = {}
local MovementLogs = {}

local ActivityConnections = {}
local MovementConnections = {}

local MonitoredTools = {}
local MonitoredButtons = {}
local MonitoredPrompts = {}
local MonitoredClicks = {}

local LastMovementEvent = nil

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
YButton.Size = UDim2.new(0, 45, 0, 45)
YButton.Position = UDim2.new(0, 20, 0.5, -22)
YButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
YButton.BorderSizePixel = 0
YButton.Text = "Y"
YButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YButton.TextSize = 22
YButton.Font = Enum.Font.GothamBold
YButton.Parent = ScreenGui

local YCorner = Instance.new("UICorner")
YCorner.CornerRadius = UDim.new(1, 0)
YCorner.Parent = YButton

--==================================================
-- DASHBOARD
--==================================================

local Dashboard = Instance.new("Frame")
Dashboard.Name = "Dashboard"
Dashboard.Size = UDim2.new(0, 700, 0, 450)
Dashboard.Position = UDim2.new(0.5, -350, 0.5, -225)
Dashboard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Dashboard.BorderSizePixel = 0
Dashboard.Visible = true
Dashboard.Parent = ScreenGui

local DashboardCorner = Instance.new("UICorner")
DashboardCorner.CornerRadius = UDim.new(0, 10)
DashboardCorner.Parent = Dashboard

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "YDashboard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Dashboard

--==================================================
-- CLOSE / TOGGLE
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Dashboard

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    Dashboard.Visible = false
end)

YButton.MouseButton1Click:Connect(function()
    Dashboard.Visible = not Dashboard.Visible
end)

--==================================================
-- TAB BAR
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Dashboard

local function CreateTab(name, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 120, 1, 0)
    Button.Position = UDim2.new(0, position, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = TabBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    return Button
end

local ActivityTab = CreateTab("ACTIVITY", 0)
local MovementTab = CreateTab("MOVEMENT", 130)

--==================================================
-- PAGE CREATOR
--==================================================

local function CreatePage()
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, -20, 1, -105)
    Page.Position = UDim2.new(0, 10, 0, 95)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Dashboard

    return Page
end

local ActivityPage = CreatePage()
local MovementPage = CreatePage()

ActivityPage.Visible = true

--==================================================
-- TOGGLE CREATOR
--==================================================

local function CreateToggle(parent, text, position, callback)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 110, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    Button.BorderSizePixel = 0
    Button.Text = text .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    local Enabled = false

    Button.MouseButton1Click:Connect(function()

        Enabled = not Enabled

        if Enabled then
            Button.Text = text .. ": ON"
            Button.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
        else
            Button.Text = text .. ": OFF"
            Button.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        end

        callback(Enabled)
    end)

    return Button
end

--==================================================
-- LOG HELPERS
--==================================================

local ActivityInfo
local MovementInfo
local ActivityList
local MovementList

local function GetObjectPath(Object)

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

local function GetObjectInfo(Object)

    if not Object then
        return "Object: nil"
    end

    local Lines = {}

    table.insert(Lines, "Name: " .. Object.Name)
    table.insert(Lines, "Class: " .. Object.ClassName)
    table.insert(Lines, "Path: " .. GetObjectPath(Object))

    return table.concat(Lines, "\n")
end

local function AddToList(ListObject, Text)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -5, 0, 28)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ListObject

    return Label
end

local function RefreshActivity()

    for _, Child in ipairs(ActivityList:GetChildren()) do
        if Child:IsA("TextLabel") then
            Child:Destroy()
        end
    end

    for _, Entry in ipairs(ActivityLogs) do
        AddToList(ActivityList, Entry)
    end

    ActivityList.CanvasSize =
        UDim2.new(0, 0, 0, #ActivityLogs * 30)

    ActivityInfo.Text = table.concat(ActivityLogs, "\n\n")
end

local function RefreshMovement()

    for _, Child in ipairs(MovementList:GetChildren()) do
        if Child:IsA("TextLabel") then
            Child:Destroy()
        end
    end

    for _, Entry in ipairs(MovementLogs) do
        AddToList(MovementList, Entry)
    end

    MovementList.CanvasSize =
        UDim2.new(0, 0, 0, #MovementLogs * 30)

    MovementInfo.Text = table.concat(MovementLogs, "\n\n")
end

--==================================================
-- ACTIVITY LOGGER
--==================================================

local function LogActivity(EventType, Object, Details)

    if not ActivityEnabled then
        return
    end

    local Time = os.date("%H:%M:%S")

    local ObjectName = "nil"
    local ObjectClass = "nil"
    local ObjectPath = "nil"

    if Object then
        ObjectName = Object.Name
        ObjectClass = Object.ClassName
        ObjectPath = GetObjectPath(Object)
    end

    local Entry =
        "[" .. Time .. "] " ..
        EventType ..
        "\n" ..
        "Name: " .. ObjectName ..
        "\n" ..
        "Class: " .. ObjectClass ..
        "\n" ..
        "Path: " .. ObjectPath

    if Details and Details ~= "" then
        Entry = Entry .. "\nDetails: " .. Details
    end

    table.insert(ActivityLogs, 1, Entry)

    if #ActivityLogs > MAX_LOGS then
        table.remove(ActivityLogs)
    end

    RefreshActivity()
end

--==================================================
-- MOVEMENT LOGGER
--==================================================

local function LogMovement(State)

    if not MovementEnabled then
        return
    end

    if State == LastMovementEvent then
        return
    end

    LastMovementEvent = State

    local Time = os.date("%H:%M:%S")

    local Entry =
        "[" .. Time .. "] MOVEMENT: " .. State

    table.insert(MovementLogs, 1, Entry)

    if #MovementLogs > MAX_LOGS then
        table.remove(MovementLogs)
    end

    RefreshMovement()
end

--==================================================
-- ACTIVITY UI
--==================================================

local ActivityToggle = CreateToggle(
    ActivityPage,
    "ACTIVITY",
    UDim2.new(0, 0, 0, 0),
    function(Enabled)

        ActivityEnabled = Enabled

    end
)

local ActivityClear = Instance.new("TextButton")
ActivityClear.Size = UDim2.new(0, 80, 0, 35)
ActivityClear.Position = UDim2.new(0, 120, 0, 0)
ActivityClear.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ActivityClear.BorderSizePixel = 0
ActivityClear.Text = "CLEAR"
ActivityClear.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityClear.TextSize = 12
ActivityClear.Font = Enum.Font.GothamBold
ActivityClear.Parent = ActivityPage

Instance.new("UICorner", ActivityClear).CornerRadius = UDim.new(0, 7)

ActivityClear.MouseButton1Click:Connect(function()

    table.clear(ActivityLogs)

    RefreshActivity()

end)

local ActivityCopy = Instance.new("TextButton")
ActivityCopy.Size = UDim2.new(0, 80, 0, 35)
ActivityCopy.Position = UDim2.new(0, 210, 0, 0)
ActivityCopy.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ActivityCopy.BorderSizePixel = 0
ActivityCopy.Text = "COPY"
ActivityCopy.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityCopy.TextSize = 12
ActivityCopy.Font = Enum.Font.GothamBold
ActivityCopy.Parent = ActivityPage

Instance.new("UICorner", ActivityCopy).CornerRadius = UDim.new(0, 7)

ActivityCopy.MouseButton1Click:Connect(function()

    if setclipboard then
        setclipboard(ActivityInfo.Text)
    end

end)

--==================================================
-- ACTIVITY LIST
--==================================================

ActivityList = Instance.new("ScrollingFrame")
ActivityList.Size = UDim2.new(0.48, -5, 1, -50)
ActivityList.Position = UDim2.new(0, 0, 0, 45)
ActivityList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ActivityList.BorderSizePixel = 0
ActivityList.ScrollBarThickness = 5
ActivityList.CanvasSize = UDim2.new(0, 0, 0, 0)
ActivityList.Parent = ActivityPage

Instance.new("UICorner", ActivityList).CornerRadius = UDim.new(0, 7)

--==================================================
-- ACTIVITY INFO
--==================================================

ActivityInfo = Instance.new("TextBox")
ActivityInfo.Size = UDim2.new(0.52, -5, 1, -50)
ActivityInfo.Position = UDim2.new(0.48, 5, 0, 45)
ActivityInfo.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ActivityInfo.BorderSizePixel = 0
ActivityInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
ActivityInfo.TextSize = 12
ActivityInfo.Font = Enum.Font.Code
ActivityInfo.TextXAlignment = Enum.TextXAlignment.Left
ActivityInfo.TextYAlignment = Enum.TextYAlignment.Top
ActivityInfo.MultiLine = true
ActivityInfo.ClearTextOnFocus = false
ActivityInfo.TextEditable = false
ActivityInfo.TextWrapped = false
ActivityInfo.Text = ""
ActivityInfo.Parent = ActivityPage

Instance.new("UICorner", ActivityInfo).CornerRadius = UDim.new(0, 7)

--==================================================
-- MOVEMENT UI
--==================================================

local MovementToggle = CreateToggle(
    MovementPage,
    "MOVEMENT",
    UDim2.new(0, 0, 0, 0),
    function(Enabled)

        MovementEnabled = Enabled

    end
)

local MovementClear = Instance.new("TextButton")
MovementClear.Size = UDim2.new(0, 80, 0, 35)
MovementClear.Position = UDim2.new(0, 120, 0, 0)
MovementClear.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MovementClear.BorderSizePixel = 0
MovementClear.Text = "CLEAR"
MovementClear.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementClear.TextSize = 12
MovementClear.Font = Enum.Font.GothamBold
MovementClear.Parent = MovementPage

Instance.new("UICorner", MovementClear).CornerRadius = UDim.new(0, 7)

MovementClear.MouseButton1Click:Connect(function()

    table.clear(MovementLogs)
    LastMovementEvent = nil

    RefreshMovement()

end)

local MovementCopy = Instance.new("TextButton")
MovementCopy.Size = UDim2.new(0, 80, 0, 35)
MovementCopy.Position = UDim2.new(0, 210, 0, 0)
MovementCopy.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MovementCopy.BorderSizePixel = 0
MovementCopy.Text = "COPY"
MovementCopy.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementCopy.TextSize = 12
MovementCopy.Font = Enum.Font.GothamBold
MovementCopy.Parent = MovementPage

Instance.new("UICorner", MovementCopy).CornerRadius = UDim.new(0, 7)

MovementCopy.MouseButton1Click:Connect(function()

    if setclipboard then
        setclipboard(MovementInfo.Text)
    end

end)

--==================================================
-- MOVEMENT LIST
--==================================================

MovementList = Instance.new("ScrollingFrame")
MovementList.Size = UDim2.new(0.48, -5, 1, -50)
MovementList.Position = UDim2.new(0, 0, 0, 45)
MovementList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MovementList.BorderSizePixel = 0
MovementList.ScrollBarThickness = 5
MovementList.CanvasSize = UDim2.new(0, 0, 0, 0)
MovementList.Parent = MovementPage

Instance.new("UICorner", MovementList).CornerRadius = UDim.new(0, 7)

--==================================================
-- MOVEMENT INFO
--==================================================

MovementInfo = Instance.new("TextBox")
MovementInfo.Size = UDim2.new(0.52, -5, 1, -50)
MovementInfo.Position = UDim2.new(0.48, 5, 0, 45)
MovementInfo.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MovementInfo.BorderSizePixel = 0
MovementInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
MovementInfo.TextSize = 12
MovementInfo.Font = Enum.Font.Code
MovementInfo.TextXAlignment = Enum.TextXAlignment.Left
MovementInfo.TextYAlignment = Enum.TextYAlignment.Top
MovementInfo.MultiLine = true
MovementInfo.ClearTextOnFocus = false
MovementInfo.TextEditable = false
MovementInfo.TextWrapped = false
MovementInfo.Text = ""
MovementInfo.Parent = MovementPage

Instance.new("UICorner", MovementInfo).CornerRadius = UDim.new(0, 7)

--==================================================
-- TAB SWITCHING
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
-- ACTIVITY MONITOR
--==================================================

local function MonitorClickDetector(Detector)

    if MonitoredClicks[Detector] then
        return
    end

    MonitoredClicks[Detector] = true

    Detector.MouseClick:Connect(function(Player)

        if Player == LocalPlayer then

            local Target = Detector.Parent

            LogActivity(
                "CLICK",
                Target,
                "Interaction: ClickDetector"
            )

        end

    end)

end

local function MonitorProximityPrompt(Prompt)

    if MonitoredPrompts[Prompt] then
        return
    end

    MonitoredPrompts[Prompt] = true

    Prompt.Triggered:Connect(function(Player)

        if Player == LocalPlayer then

            local Target = Prompt.Parent

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

        end

    end)

end

--==================================================
-- TOOL MONITOR
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
            "Tool.Activated"
        )

    end)

    Tool.Equipped:Connect(function()

        LogActivity(
            "TOOL EQUIPPED",
            Tool,
            "Tool.Equipped"
        )

    end)

    Tool.Unequipped:Connect(function()

        LogActivity(
            "TOOL UNEQUIPPED",
            Tool,
            "Tool.Unequipped"
        )

    end)

end

--==================================================
-- GUI BUTTON MONITOR
--==================================================

local function MonitorGuiButton(Button)

    if not Button:IsA("GuiButton") then
        return
    end

    if MonitoredButtons[Button] then
        return
    end

    MonitoredButtons[Button] = true

    Button.Activated:Connect(function()

        LogActivity(
            "GUI CLICK",
            Button,
            "GuiButton.Activated"
        )

    end)

end

--==================================================
-- INITIAL SCAN
--==================================================

local function ScanWorkspace()

    for _, Object in ipairs(Workspace:GetDescendants()) do

        if Object:IsA("ClickDetector") then
            MonitorClickDetector(Object)

        elseif Object:IsA("ProximityPrompt") then
            MonitorProximityPrompt(Object)

        end

    end

end

local function ScanTools()

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then

        for _, Object in ipairs(Backpack:GetChildren()) do
            MonitorTool(Object)
        end

    end

    local Character = LocalPlayer.Character

    if Character then

        for _, Object in ipairs(Character:GetChildren()) do
            MonitorTool(Object)
        end

    end

end

local function ScanGui()

    for _, Object in ipairs(PlayerGui:GetDescendants()) do

        if Object:IsA("GuiButton") then
            MonitorGuiButton(Object)
        end

    end

end

ScanWorkspace()
ScanTools()
ScanGui()

--==================================================
-- NEW OBJECT MONITORING
--==================================================

Workspace.DescendantAdded:Connect(function(Object)

    if Object:IsA("ClickDetector") then
        MonitorClickDetector(Object)

    elseif Object:IsA("ProximityPrompt") then
        MonitorProximityPrompt(Object)

    end

end)

PlayerGui.DescendantAdded:Connect(function(Object)

    if Object:IsA("GuiButton") then
        MonitorGuiButton(Object)
    end

end)

--==================================================
-- BACKPACK / CHARACTER TOOL MONITORING
--==================================================

local function MonitorContainer(Container)

    if not Container then
        return
    end

    Container.ChildAdded:Connect(function(Object)

        if Object:IsA("Tool") then
            MonitorTool(Object)
        end

    end)

end

local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

if Backpack then
    MonitorContainer(Backpack)
end

LocalPlayer.CharacterAdded:Connect(function(Character)

    MonitorContainer(Character)

    task.wait(0.2)

    ScanTools()

    if MovementEnabled then
        LastMovementEvent = nil
    end

end)

--==================================================
-- MOVEMENT MONITOR
--==================================================

local function SetupMovement(Character)

    local Humanoid = Character:WaitForChild("Humanoid")

    table.clear(MovementConnections)

    local StateConnection =
        Humanoid.StateChanged:Connect(function(_, NewState)

            if not MovementEnabled then
                return
            end

            if NewState == Enum.HumanoidStateType.Jumping then

                LogMovement("JUMPING")

            elseif NewState == Enum.HumanoidStateType.Freefall then

                LogMovement("FALLING")

            elseif NewState == Enum.HumanoidStateType.Landed then

                LogMovement("LANDED")

            elseif NewState == Enum.HumanoidStateType.Climbing then

                LogMovement("CLIMBING")

            elseif NewState == Enum.HumanoidStateType.Swimming then

                LogMovement("SWIMMING")

            elseif NewState == Enum.HumanoidStateType.Seated then

                LogMovement("SEATED")

            elseif NewState == Enum.HumanoidStateType.Running then

                LogMovement("RUNNING")

            elseif NewState == Enum.HumanoidStateType.RunningNoPhysics then

                LogMovement("RUNNING")

            end

        end)

    table.insert(MovementConnections, StateConnection)

end

if LocalPlayer.Character then
    SetupMovement(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(Character)

    SetupMovement(Character)

end)

--==================================================
-- DRAGGING
--==================================================

local function MakeDraggable(Object)

    local Dragging = false
    local DragStart
    local StartPosition

    Object.InputBegan:Connect(function(Input)

        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()

                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then

            local Delta = Input.Position - DragStart

            Object.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )

        end

    end)

end

MakeDraggable(YButton)
MakeDraggable(Dashboard)

--==================================================
-- LOCK BUTTON
--==================================================

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 35, 0, 35)
LockButton.Position = UDim2.new(1, -85, 0, 5)
LockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LockButton.BorderSizePixel = 0
LockButton.Text = "🔓"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 15
LockButton.Font = Enum.Font.GothamBold
LockButton.Parent = Dashboard

Instance.new("UICorner", LockButton).CornerRadius = UDim.new(0, 7)

local Locked = false

LockButton.MouseButton1Click:Connect(function()

    Locked = not Locked

    if Locked then

        LockButton.Text = "🔒"

    else

        LockButton.Text = "🔓"

    end

end)

print("YDashboard loaded.")
