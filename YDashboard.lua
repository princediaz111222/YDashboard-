--// YDashboard
--// Activity + Movement Monitor
--// YDashboard's own activity is ignored.

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

local MonitoredClicks = {}
local MonitoredPrompts = {}
local MonitoredTools = {}
local MonitoredButtons = {}

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

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 7)
LockCorner.Parent = LockButton

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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

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

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

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
-- BUTTON HELPER
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

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button

    return Button
end

--==================================================
-- ACTIVITY CONTROLS
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

--==================================================
-- MOVEMENT CONTROLS
--==================================================

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
-- LOG PANEL CREATOR
--==================================================

local function CreateLogPanel(Parent)

    local Panel = Instance.new("ScrollingFrame")
    Panel.Size = UDim2.new(1, 0, 1, -45)
    Panel.Position = UDim2.fromOffset(0, 45)
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.BorderSizePixel = 0
    Panel.ScrollBarThickness = 5
    Panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    Panel.ScrollingDirection = Enum.ScrollingDirection.Y
    Panel.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Panel

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.PaddingRight = UDim.new(0, 8)
    Padding.Parent = Panel

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Panel

    return Panel
end

local ActivityList = CreateLogPanel(ActivityPage)
local MovementList = CreateLogPanel(MovementPage)

--==================================================
-- LOG TEXT BOX
--==================================================

local ActivityInfo = Instance.new("TextBox")
ActivityInfo.Size = UDim2.new(1, -16, 1, -16)
ActivityInfo.Position = UDim2.fromOffset(8, 8)
ActivityInfo.BackgroundTransparency = 1
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
ActivityInfo.Visible = false
ActivityInfo.Parent = ActivityList

local MovementInfo = ActivityInfo:Clone()
MovementInfo.Text = ""
MovementInfo.Parent = MovementList

--==================================================
-- FORMAT OBJECT
--==================================================

local function GetPath(Object)

    if not Object then
        return "nil"
    end

    local Success, Result = pcall(function()
        return Object:GetFullName()
    end)

    return Success and Result or Object.Name
end

local function IsYDashboardObject(Object)

    if not Object then
        return false
    end

    return Object == ScreenGui
        or Object:IsDescendantOf(ScreenGui)
end

--==================================================
-- REFRESH ACTIVITY
--==================================================

local function RefreshActivity()

    for _, Child in ipairs(ActivityList:GetChildren()) do
        if Child:IsA("TextLabel") then
            Child:Destroy()
        end
    end

    for Index, Entry in ipairs(ActivityLogs) do

        local Label = Instance.new("TextLabel")
        Label.LayoutOrder = Index
        Label.Size = UDim2.new(1, -5, 0, 65)
        Label.AutomaticSize = Enum.AutomaticSize.Y
        Label.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Label.BorderSizePixel = 0
        Label.Text = Entry
        Label.TextColor3 = Color3.fromRGB(225, 225, 225)
        Label.TextSize = 12
        Label.Font = Enum.Font.Code
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Top
        Label.TextWrapped = true
        Label.Parent = ActivityList

        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop = UDim.new(0, 7)
        Padding.PaddingBottom = UDim.new(0, 7)
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 8)
        Padding.Parent = Label

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Label
    end

    ActivityInfo.Text = table.concat(ActivityLogs, "\n\n")
end

--==================================================
-- REFRESH MOVEMENT
--==================================================

local function RefreshMovement()

    for _, Child in ipairs(MovementList:GetChildren()) do
        if Child:IsA("TextLabel") then
            Child:Destroy()
        end
    end

    for Index, Entry in ipairs(MovementLogs) do

        local Label = Instance.new("TextLabel")
        Label.LayoutOrder = Index
        Label.Size = UDim2.new(1, -5, 0, 32)
        Label.AutomaticSize = Enum.AutomaticSize.Y
        Label.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Label.BorderSizePixel = 0
        Label.Text = Entry
        Label.TextColor3 = Color3.fromRGB(225, 225, 225)
        Label.TextSize = 12
        Label.Font = Enum.Font.Code
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Center
        Label.TextWrapped = true
        Label.Parent = MovementList

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 8)
        Padding.Parent = Label

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Label
    end

    MovementInfo.Text = table.concat(MovementLogs, "\n\n")
end

--==================================================
-- ACTIVITY LOGGER
--==================================================

local function LogActivity(EventType, Object, Details)

    if not ActivityEnabled then
        return
    end

    -- Ignore YDashboard completely
    if IsYDashboardObject(Object) then
        return
    end

    local Time = os.date("%H:%M:%S")

    local Name = "nil"
    local Class = "nil"
    local Path = "nil"

    if Object then
        Name = Object.Name
        Class = Object.ClassName
        Path = GetPath(Object)
    end

    local Entry =
        "[" .. Time .. "] " .. EventType ..
        "\nName: " .. Name ..
        "\nClass: " .. Class ..
        "\nPath: " .. Path

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

local LastMovement = nil

local function LogMovement(State)

    if not MovementEnabled then
        return
    end

    if State == LastMovement then
        return
    end

    LastMovement = State

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
-- ACTIVITY TOGGLE
--==================================================

ActivityToggle.MouseButton1Click:Connect(function()

    ActivityEnabled = not ActivityEnabled

    if ActivityEnabled then
        ActivityToggle.Text = "ACTIVITY: ON"
        ActivityToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
    else
        ActivityToggle.Text = "ACTIVITY: OFF"
        ActivityToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    end

end)

--==================================================
-- MOVEMENT TOGGLE
--==================================================

MovementToggle.MouseButton1Click:Connect(function()

    MovementEnabled = not MovementEnabled

    if MovementEnabled then
        MovementToggle.Text = "MOVEMENT: ON"
        MovementToggle.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
    else
        MovementToggle.Text = "MOVEMENT: OFF"
        MovementToggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    end

end)

--==================================================
-- CLEAR
--==================================================

ActivityClear.MouseButton1Click:Connect(function()

    table.clear(ActivityLogs)
    RefreshActivity()

end)

MovementClear.MouseButton1Click:Connect(function()

    table.clear(MovementLogs)
    LastMovement = nil
    RefreshMovement()

end)

--==================================================
-- COPY
--==================================================

ActivityCopy.MouseButton1Click:Connect(function()

    if setclipboard then
        setclipboard(table.concat(ActivityLogs, "\n\n"))
    end

end)

MovementCopy.MouseButton1Click:Connect(function()

    if setclipboard then
        setclipboard(table.concat(MovementLogs, "\n\n"))
    end

end)

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

        local Details = "Interaction: ProximityPrompt"

        if Prompt.ActionText ~= "" then
            Details = Details ..
                "\nActionText: " ..
                Prompt.ActionText
        end

        if Prompt.ObjectText ~= "" then
            Details = Details ..
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
            "Tool.Activated"
        )

    end)

end

--==================================================
-- GAME GUI BUTTONS
--==================================================

local function MonitorGuiButton(Button)

    if not Button:IsA("GuiButton") then
        return
    end

    if MonitoredButtons[Button] then
        return
    end

    -- Never monitor YDashboard buttons
    if IsYDashboardObject(Button) then
        return
    end

    MonitoredButtons[Button] = true

    Button.Activated:Connect(function()

        LogActivity(
            "GUI INTERACTION",
            Button,
            "GuiButton.Activated"
        )

    end)

end

--==================================================
-- INITIAL SCAN
--==================================================

for _, Object in ipairs(Workspace:GetDescendants()) do

    if Object:IsA("ClickDetector") then
        MonitorClickDetector(Object)

    elseif Object:IsA("ProximityPrompt") then
        MonitorPrompt(Object)

    end

end

for _, Object in ipairs(PlayerGui:GetDescendants()) do

    if Object:IsA("GuiButton") then
        MonitorGuiButton(Object)
    end

end

--==================================================
-- DYNAMIC OBJECTS
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
-- TOOL MONITORING
--==================================================

local function ScanTools()

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then
        for _, Tool in ipairs(Backpack:GetChildren()) do
            MonitorTool(Tool)
        end
    end

    local Character = LocalPlayer.Character

    if Character then
        for _, Tool in ipairs(Character:GetChildren()) do
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

local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

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

    local Humanoid = Character:WaitForChild("Humanoid")

    Humanoid.StateChanged:Connect(function(_, NewState)

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

end

if LocalPlayer.Character then
    SetupMovement(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(Character)

    SetupMovement(Character)

end)

--==================================================
-- VISIBILITY
--==================================================

YButton.MouseButton1Click:Connect(function()

    Dashboard.Visible = not Dashboard.Visible

end)

CloseButton.MouseButton1Click:Connect(function()

    Dashboard.Visible = false

end)

--==================================================
-- LOCK
--==================================================

local Locked = false

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

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Delta = Input.Position - DragStart

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

print("YDashboard loaded.")
