--// YDashboard
--// LocalScript
--// For your own Roblox experience

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

pcall(function()
    local old = Player.PlayerGui:FindFirstChild("YDashboard")
    if old then
        old:Destroy()
    end
end)

--==================================================
-- VARIABLES
--==================================================

local Terminated = false
local DashboardOpen = true
local YLocked = false
local YDragging = false
local YMoved = false
local YPressStart = nil
local CurrentTheme = "Dark"

local WalkSpeedValue = 16
local WalkSpeedEnabled = false

local JumpPowerValue = 50
local JumpPowerEnabled = false

local GravityValue = 196.2
local GravityEnabled = false
local OriginalGravity = workspace.Gravity

local NoclipEnabled = false
local FlyJumpEnabled = false
local ESPEnabled = false
local InstantInteractionEnabled = false

local CurrentCategory = "All"
local SearchText = ""

local Waypoints = {}

local Connections = {}
local ESPObjects = {}

local Keybind = Enum.KeyCode.RightShift

--==================================================
-- THEMES
--==================================================

local Themes = {
    Dark = {
        Background = Color3.fromRGB(12, 14, 22),
        Panel = Color3.fromRGB(18, 21, 32),
        Panel2 = Color3.fromRGB(24, 27, 40),
        Panel3 = Color3.fromRGB(31, 35, 50),
        Text = Color3.fromRGB(235, 240, 255),
        SubText = Color3.fromRGB(150, 160, 180),
        Stroke = Color3.fromRGB(65, 75, 105),
        Enabled = Color3.fromRGB(40, 150, 255),
        Disabled = Color3.fromRGB(55, 60, 75),
        Accent = Color3.fromRGB(70, 150, 255)
    },

    Light = {
        Background = Color3.fromRGB(235, 238, 245),
        Panel = Color3.fromRGB(248, 249, 252),
        Panel2 = Color3.fromRGB(225, 229, 238),
        Panel3 = Color3.fromRGB(210, 215, 225),
        Text = Color3.fromRGB(20, 23, 30),
        SubText = Color3.fromRGB(80, 88, 105),
        Stroke = Color3.fromRGB(165, 170, 185),
        Enabled = Color3.fromRGB(30, 115, 220),
        Disabled = Color3.fromRGB(180, 185, 195),
        Accent = Color3.fromRGB(35, 120, 220)
    }
}

local function C()
    return Themes[CurrentTheme]
end

--==================================================
-- Z INDEX
--==================================================

local Z = {
    Shadow = 0,
    Dashboard = 5,
    Effects = 10,
    HeaderText = 90,
    DragBar = 95,
    Content = 100,
    Buttons = 110,
    Tabs = 110,
    Inputs = 120,
    YButton = 200,
    LockButton = 210,
    Notifications = 500
}

local ThemeObjects = {}

--==================================================
-- CONNECTION HANDLER
--==================================================

local function Connect(signal, callback)
    if Terminated then
        return
    end

    local connection = signal:Connect(callback)
    table.insert(Connections, connection)

    return connection
end

--==================================================
-- THEME OBJECT REGISTRATION
--==================================================

local function RegisterThemeObject(object, properties)
    table.insert(ThemeObjects, {
        Object = object,
        Properties = properties
    })
end

local function Create(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    RegisterThemeObject(object, properties)

    return object
end

local function AddCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object

    return corner
end

local function AddStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = object

    return stroke
end

--==================================================
-- APPLY THEME
--==================================================

local function ApplyTheme()
    for _, data in ipairs(ThemeObjects) do
        local object = data.Object
        local properties = data.Properties

        if object and object.Parent then
            for property, value in pairs(properties) do

                if property == "BackgroundColor3" then

                    if value == Themes.Dark.Background
                        or value == Themes.Light.Background then

                        object.BackgroundColor3 = C().Background

                    elseif value == Themes.Dark.Panel
                        or value == Themes.Light.Panel then

                        object.BackgroundColor3 = C().Panel

                    elseif value == Themes.Dark.Panel2
                        or value == Themes.Light.Panel2 then

                        object.BackgroundColor3 = C().Panel2

                    elseif value == Themes.Dark.Panel3
                        or value == Themes.Light.Panel3 then

                        object.BackgroundColor3 = C().Panel3

                    elseif value == Themes.Dark.Enabled
                        or value == Themes.Light.Enabled then

                        object.BackgroundColor3 = C().Enabled

                    elseif value == Themes.Dark.Disabled
                        or value == Themes.Light.Disabled then

                        object.BackgroundColor3 = C().Disabled

                    elseif value == Themes.Dark.Accent
                        or value == Themes.Light.Accent then

                        object.BackgroundColor3 = C().Accent
                    end

                elseif property == "TextColor3" then

                    if value == Themes.Dark.Text
                        or value == Themes.Light.Text then

                        object.TextColor3 = C().Text

                    elseif value == Themes.Dark.SubText
                        or value == Themes.Light.SubText then

                        object.TextColor3 = C().SubText
                    end

                elseif property == "PlaceholderColor3" then

                    if value == Themes.Dark.SubText
                        or value == Themes.Light.SubText then

                        object.PlaceholderColor3 = C().SubText
                    end

                elseif property == "ScrollBarImageColor3" then

                    if value == Themes.Dark.Accent
                        or value == Themes.Light.Accent then

                        object.ScrollBarImageColor3 = C().Accent
                    end
                end
            end
        end
    end
end

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Create("ScreenGui", {
    Name = "YDashboard",
    Parent = Player.PlayerGui,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local ScaleHolder = Create("Frame", {
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
})

local UIScale = Create("UIScale", {
    Parent = ScaleHolder,
    Scale = 1
})

--==================================================
-- SHADOW
--==================================================

local Shadow = Create("Frame", {
    Parent = ScaleHolder,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.35,
    Position = UDim2.new(0.5, -365, 0.5, -265),
    Size = UDim2.new(0, 730, 0, 550),
    ZIndex = Z.Shadow
})

AddCorner(Shadow, 16)

--==================================================
-- DASHBOARD
--==================================================

local Dashboard = Create("Frame", {
    Parent = ScaleHolder,
    BackgroundColor3 = C().Background,
    Position = UDim2.new(0.5, -360, 0.5, -260),
    Size = UDim2.new(0, 720, 0, 540),
    ZIndex = Z.Dashboard,
    Active = true
})

AddCorner(Dashboard, 15)

local DashboardStroke = AddStroke(
    Dashboard,
    C().Stroke,
    1
)

--==================================================
-- GLOW
--==================================================

local Glow = Create("Frame", {
    Parent = Dashboard,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 3),
    ZIndex = Z.Effects,
    Active = false
})

local GlowGradient = Create("UIGradient", {
    Parent = Glow,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(30, 110, 255)
        ),
        ColorSequenceKeypoint.new(
            0.5,
            Color3.fromRGB(150, 50, 255)
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(255, 45, 80)
        )
    })
})

local GlowStroke = Create("UIStroke", {
    Parent = Dashboard,
    Thickness = 1,
    Transparency = 0.3,
    Color = Color3.fromRGB(90, 110, 255)
})

--==================================================
-- HEADER
--==================================================

local Header = Create("Frame", {
    Parent = Dashboard,
    BackgroundColor3 = C().Panel,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 75),
    ZIndex = Z.Dashboard
})

AddCorner(Header, 15)

local HeaderCover = Create("Frame", {
    Parent = Header,
    BackgroundColor3 = C().Panel,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.5, 0),
    Size = UDim2.new(1, 0, 0.5, 0),
    ZIndex = Z.Dashboard
})

local Title = Create("TextLabel", {
    Parent = Header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 22, 0, 12),
    Size = UDim2.new(0, 300, 0, 30),
    Text = "YDashboard",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = Z.HeaderText
})

local Subtitle = Create("TextLabel", {
    Parent = Header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 24, 0, 42),
    Size = UDim2.new(0, 400, 0, 20),
    Text = "CYBER CONTROL INTERFACE",
    TextColor3 = C().SubText,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = Z.HeaderText
})

--==================================================
-- DASHBOARD DRAG BAR
--==================================================

local DashboardDragBar = Create("Frame", {
    Parent = Dashboard,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 5),
    Size = UDim2.new(1, -20, 0, 65),
    Active = true,
    ZIndex = Z.DragBar
})

local DashboardDragging = false
local DashboardDragStart
local DashboardStartPosition

Connect(
    DashboardDragBar.InputBegan,
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            DashboardDragging = true
            DashboardDragStart = input.Position
            DashboardStartPosition = Dashboard.Position

            local connection

            connection = input.Changed:Connect(function()
                if input.UserInputState ==
                    Enum.UserInputState.End then

                    DashboardDragging = false

                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end
)

Connect(
    UIS.InputChanged,
    function(input)

        if not DashboardDragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            local delta =
                input.Position - DashboardDragStart

            Dashboard.Position = UDim2.new(
                DashboardStartPosition.X.Scale,
                DashboardStartPosition.X.Offset + delta.X,
                DashboardStartPosition.Y.Scale,
                DashboardStartPosition.Y.Offset + delta.Y
            )

            Shadow.Position = UDim2.new(
                Dashboard.Position.X.Scale,
                Dashboard.Position.X.Offset + 5,
                Dashboard.Position.Y.Scale,
                Dashboard.Position.Y.Offset + 5
            )
        end
    end
)

--==================================================
-- TABS
--==================================================

local TabHolder = Create("Frame", {
    Parent = ScaleHolder,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, -345, 0.5, -175),
    Size = UDim2.new(0, 690, 0, 40),
    ZIndex = Z.Tabs
})

local function CreateTab(name, text, x)
    local button = Create("TextButton", {
        Parent = TabHolder,
        Name = name,
        BackgroundColor3 = C().Panel2,
        Position = UDim2.new(0, x, 0, 0),
        Size = UDim2.new(0, 125, 0, 38),
        Text = text,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        ZIndex = Z.Tabs
    })

    AddCorner(button, 8)

    return button
end

local ExecuteTab = CreateTab(
    "ExecuteTab",
    "EXECUTE",
    0
)

local ToolsTab = CreateTab(
    "ToolsTab",
    "TOOLS",
    135
)

local SettingsTab = CreateTab(
    "SettingsTab",
    "SETTINGS",
    270
)

--==================================================
-- CONTENT HOLDER
--==================================================

local ContentHolder = Create("Frame", {
    Parent = ScaleHolder,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, -345, 0.5, -125),
    Size = UDim2.new(0, 690, 0, 390),
    ZIndex = Z.Content
})

--==================================================
-- NOTIFICATIONS
--==================================================

local NotificationHolder = Create("Frame", {
    Parent = ScaleHolder,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -310, 0, 20),
    Size = UDim2.new(0, 290, 0, 400),
    ZIndex = Z.Notifications
})

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.Parent = NotificationHolder

local function Notify(title, message)

    if Terminated then
        return
    end

    local notification = Create("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = C().Panel,
        Size = UDim2.new(0, 280, 0, 65),
        ZIndex = Z.Notifications
    })

    AddCorner(notification, 8)
    AddStroke(notification, C().Stroke, 1)

    local titleLabel = Create("TextLabel", {
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 7),
        Size = UDim2.new(1, -24, 0, 20),
        Text = title,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = Z.Notifications + 1
    })

    local messageLabel = Create("TextLabel", {
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 29),
        Size = UDim2.new(1, -24, 0, 28),
        Text = message,
        TextColor3 = C().SubText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = Z.Notifications + 1
    })

    task.delay(3, function()
        if notification and notification.Parent then
            notification:Destroy()
        end
    end)
end

--==================================================
-- PAGES
--==================================================

local ExecutePage = Create("Frame", {
    Parent = ContentHolder,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = true,
    ZIndex = Z.Content
})

local ToolsPage = Create("Frame", {
    Parent = ContentHolder,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = false,
    ZIndex = Z.Content
})

local SettingsPage = Create("Frame", {
    Parent = ContentHolder,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Visible = false,
    ZIndex = Z.Content
})

--==================================================
-- PAGE SWITCHING
--==================================================

local function ShowPage(page)
    ExecutePage.Visible = page == ExecutePage
    ToolsPage.Visible = page == ToolsPage
    SettingsPage.Visible = page == SettingsPage
end

Connect(
    ExecuteTab.MouseButton1Click,
    function()
        ShowPage(ExecutePage)
    end
)

Connect(
    ToolsTab.MouseButton1Click,
    function()
        ShowPage(ToolsPage)
    end
)

Connect(
    SettingsTab.MouseButton1Click,
    function()
        ShowPage(SettingsPage)
    end
)

--==================================================
-- EXECUTE PAGE
--==================================================

local ExecuteTitle = Create("TextLabel", {
    Parent = ExecutePage,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 5),
    Size = UDim2.new(1, -30, 0, 30),
    Text = "EXECUTE MODULES",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ExecuteSubtitle = Create("TextLabel", {
    Parent = ExecutePage,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 35),
    Size = UDim2.new(1, -30, 0, 30),
    Text = "Use this page for modules and commands belonging to your own experience.",
    TextColor3 = C().SubText,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
})

local function CreateLargeButton(parent, name, text, position)
    local button = Create("TextButton", {
        Parent = parent,
        Name = name,
        BackgroundColor3 = C().Panel2,
        Position = position,
        Size = UDim2.new(0, 250, 0, 45),
        Text = text,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false
    })

    AddCorner(button, 8)
    AddStroke(button, C().Stroke, 1)

    return button
end

local ExecuteButton = CreateLargeButton(
    ExecutePage,
    "ExecuteButton",
    "Execute SAEV3",
    UDim2.new(0, 15, 0, 75)
)

local ExecuteButton2 = CreateLargeButton(
    ExecutePage,
    "ExecuteButton2",
    "Execute SAEV4",
    UDim2.new(0, 285, 0, 75)
)

local ExecuteButton3 = CreateLargeButton(
    ExecutePage,
    "ExecuteButton3",
    "Execute BloxFruit",
    UDim2.new(0, 15, 0, 130)
)

Connect(
    ExecuteButton.MouseButton1Click,
    function()
        Notify("Execute", "SAEV3 button clicked.")
    end
)

Connect(
    ExecuteButton2.MouseButton1Click,
    function()
        Notify("Execute", "SAEV4 button clicked.")
    end
)

Connect(
    ExecuteButton3.MouseButton1Click,
    function()
        Notify("Execute", "BloxFruit button clicked.")
    end
)

--==================================================
-- TOOLS PAGE
--==================================================

local SearchBox = Create("TextBox", {
    Parent = ToolsPage,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0, 15, 0, 5),
    Size = UDim2.new(1, -30, 0, 38),
    PlaceholderText = "Search commands...",
    PlaceholderColor3 = C().SubText,
    Text = "",
    TextColor3 = C().Text,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false
})

AddCorner(SearchBox, 8)
AddStroke(SearchBox, C().Stroke, 1)

local CategoryHolder = Create("Frame", {
    Parent = ToolsPage,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 50),
    Size = UDim2.new(1, -30, 0, 35)
})

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.FillDirection = Enum.FillDirection.Horizontal
CategoryLayout.Padding = UDim.new(0, 6)
CategoryLayout.Parent = CategoryHolder

local CommandScroll = Create("ScrollingFrame", {
    Parent = ToolsPage,
    BackgroundColor3 = C().Panel,
    Position = UDim2.new(0, 15, 0, 90),
    Size = UDim2.new(1, -30, 1, -90),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = C().Accent,
    BorderSizePixel = 0
})

AddCorner(CommandScroll, 8)

local CommandLayout = Instance.new("UIListLayout")
CommandLayout.Padding = UDim.new(0, 7)
CommandLayout.Parent = CommandScroll

local CommandEntries = {}

local function AddToggle(frame, default, callback, xOffset)

    local enabled = default

    local button = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = enabled and C().Enabled or C().Disabled,
        Position = UDim2.new(0, xOffset or 0, 0.5, -17),
        Size = UDim2.new(0, 120, 0, 34),
        Text = enabled and "ON" or "OFF",
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false
    })

    AddCorner(button, 7)

    Connect(
        button.MouseButton1Click,
        function()

            enabled = not enabled

            button.Text = enabled and "ON" or "OFF"
            button.BackgroundColor3 =
                enabled and C().Enabled or C().Disabled

            callback(enabled)
        end
    )

    return button
end

local function AddNumberInput(frame, defaultValue, callback)

    local box = Create("TextBox", {
        Parent = frame,
        BackgroundColor3 = C().Panel3,
        Position = UDim2.new(1, -250, 0.5, -17),
        Size = UDim2.new(0, 105, 0, 34),
        Text = tostring(defaultValue),
        TextColor3 = C().Text,
        PlaceholderColor3 = C().SubText,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ClearTextOnFocus = false
    })

    AddCorner(box, 7)

    local apply = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = C().Accent,
        Position = UDim2.new(1, -135, 0.5, -17),
        Size = UDim2.new(0, 120, 0, 34),
        Text = "APPLY",
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false
    })

    AddCorner(apply, 7)

    Connect(
        apply.MouseButton1Click,
        function()

            local value = tonumber(box.Text)

            if value == nil then
                box.Text = tostring(defaultValue)
                Notify("Input", "Enter a valid number.")
                return
            end

            callback(value)
        end
    )

    return box
end

--==================================================
-- COMMAND CREATOR
--==================================================

local function AddCommand(name, category, callback)

    local frame = Create("Frame", {
        Parent = CommandScroll,
        BackgroundColor3 = C().Panel2,
        Size = UDim2.new(1, -10, 0, 70)
    })

    AddCorner(frame, 8)
    AddStroke(frame, C().Stroke, 1)

    local title = Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 260, 0, 25),
        Text = name,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local categoryLabel = Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(0, 150, 0, 20),
        Text = category,
        TextColor3 = C().SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    table.insert(CommandEntries, {
        Frame = frame,
        Name = string.lower(name),
        Category = category
    })

    callback(frame)

    return frame
end

--==================================================
-- WALK SPEED
--==================================================

AddCommand(
    "WalkSpeed",
    "Movement",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)
                WalkSpeedEnabled = enabled
            end,
            285
        )

        AddNumberInput(
            frame,
            WalkSpeedValue,
            function(value)
                WalkSpeedValue = math.clamp(value, 0, 500)
            end
        )
    end
)

Connect(
    RunService.Heartbeat,
    function()

        if Terminated or not WalkSpeedEnabled then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end
)

--==================================================
-- JUMP POWER
--==================================================

AddCommand(
    "JumpPower",
    "Movement",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)
                JumpPowerEnabled = enabled
            end,
            285
        )

        AddNumberInput(
            frame,
            JumpPowerValue,
            function(value)
                JumpPowerValue = math.clamp(value, 0, 500)
            end
        )
    end
)

Connect(
    RunService.Heartbeat,
    function()

        if Terminated or not JumpPowerEnabled then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = JumpPowerValue
        end
    end
)

--==================================================
-- GRAVITY
--==================================================

AddCommand(
    "Gravity",
    "Movement",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)

                GravityEnabled = enabled

                if enabled then
                    workspace.Gravity = GravityValue
                else
                    workspace.Gravity = OriginalGravity
                end
            end,
            285
        )

        AddNumberInput(
            frame,
            GravityValue,
            function(value)

                GravityValue =
                    math.clamp(value, 0, 1000)

                if GravityEnabled then
                    workspace.Gravity = GravityValue
                end
            end
        )
    end
)

--==================================================
-- NOCLIP
--==================================================

AddCommand(
    "Noclip",
    "Movement",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)
                NoclipEnabled = enabled
            end,
            285
        )
    end
)

Connect(
    RunService.Stepped,
    function()

        if Terminated or not NoclipEnabled then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
            end
        end
    end
)

--==================================================
-- FLY JUMP
--==================================================

AddCommand(
    "Fly Jump",
    "Movement",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)
                FlyJumpEnabled = enabled
            end,
            285
        )
    end
)

Connect(
    UIS.JumpRequest,
    function()

        if Terminated or not FlyJumpEnabled then
            return
        end

        local character = Player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        local root =
            character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not root then
            return
        end

        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

        local velocity =
            root.AssemblyLinearVelocity

        root.AssemblyLinearVelocity =
            Vector3.new(
                velocity.X,
                60,
                velocity.Z
            )
    end
)

--==================================================
-- PLAYER ESP
--==================================================

local function RemoveESP(player)

    local data = ESPObjects[player]

    if not data then
        return
    end

    if data.Highlight then
        data.Highlight:Destroy()
    end

    if data.Billboard then
        data.Billboard:Destroy()
    end

    ESPObjects[player] = nil
end

local function AddESP(player)

    if player == Player then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local head =
        character:FindFirstChild("Head")

    if not humanoid or not head then
        return
    end

    RemoveESP(player)

    local highlight = Instance.new("Highlight")
    highlight.Name = "YPlayerESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "YPlayerInfo"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = math.huge
    billboard.Parent = head

    local info = Instance.new("TextLabel")
    info.Name = "PlayerInfo"
    info.Size = UDim2.fromScale(1, 1)
    info.BackgroundTransparency = 1
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.TextStrokeTransparency = 0
    info.TextSize = 14
    info.Font = Enum.Font.GothamBold
    info.TextXAlignment = Enum.TextXAlignment.Center
    info.TextYAlignment = Enum.TextYAlignment.Center
    info.Parent = billboard

    local function UpdateInfo()

        if not humanoid or not humanoid.Parent then
            return
        end

        local health =
            math.max(0, math.floor(humanoid.Health + 0.5))

        local maxHealth =
            math.max(0, math.floor(humanoid.MaxHealth + 0.5))

        info.Text =
            player.DisplayName
            .. " [" .. player.Name .. "]"
            .. "\nHP: "
            .. health
            .. " / "
            .. maxHealth
    end

    UpdateInfo()

    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        UpdateInfo = UpdateInfo
    }
end

local function UpdateESP()

    if Terminated then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= Player then

            if ESPEnabled then
                AddESP(player)
            else
                RemoveESP(player)
            end
        end
    end
end

AddCommand(
    "Player ESP",
    "Visual",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)

                ESPEnabled = enabled
                UpdateESP()
            end,
            285
        )
    end
)

Connect(
    RunService.Heartbeat,
    function()

        if Terminated or not ESPEnabled then
            return
        end

        for player, data in pairs(ESPObjects) do
            if data.UpdateInfo then
                data.UpdateInfo()
            end
        end
    end
)

Connect(
    Players.PlayerAdded,
    function(player)

        Connect(
            player.CharacterAdded,
            function()

                task.wait(0.2)

                if ESPEnabled and not Terminated then
                    AddESP(player)
                end
            end
        )
    end
)

Connect(
    Players.PlayerRemoving,
    function(player)
        RemoveESP(player)
    end
)

--==================================================
-- INSTANT INTERACTION
--==================================================

AddCommand(
    "Instant Interaction",
    "Utility",
    function(frame)

        AddToggle(
            frame,
            false,
            function(enabled)

                InstantInteractionEnabled = enabled

                if enabled then

                    for _, object in ipairs(
                        workspace:GetDescendants()
                    ) do

                        if object:IsA("ProximityPrompt") then
                            object.HoldDuration = 0
                        end
                    end
                end
            end,
            285
        )
    end
)

Connect(
    ProximityPromptService.PromptShown,
    function(prompt)

        if InstantInteractionEnabled
            and not Terminated then

            prompt.HoldDuration = 0
        end
    end
)

--==================================================
-- RESET CHARACTER
--==================================================

AddCommand(
    "Reset Character",
    "Utility",
    function(frame)

        local button = Create("TextButton", {
            Parent = frame,
            BackgroundColor3 = C().Disabled,
            Position = UDim2.new(1, -135, 0.5, -17),
            Size = UDim2.new(0, 120, 0, 34),
            Text = "RESET",
            TextColor3 = C().Text,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false
        })

        AddCorner(button, 7)

        Connect(
            button.MouseButton1Click,
            function()

                local character = Player.Character

                if not character then
                    return
                end

                local humanoid =
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.Health = 0
                end
            end
        )
    end
)

--==================================================
-- SERVER INFO
--==================================================

AddCommand(
    "Server Info",
    "Server",
    function(frame)

        local button = Create("TextButton", {
            Parent = frame,
            BackgroundColor3 = C().Panel3,
            Position = UDim2.new(1, -135, 0.5, -17),
            Size = UDim2.new(0, 120, 0, 34),
            Text = "INFO",
            TextColor3 = C().Text,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false
        })

        AddCorner(button, 7)

        Connect(
            button.MouseButton1Click,
            function()

                Notify(
                    "Server Info",
                    "Players: "
                    .. #Players:GetPlayers()
                    .. "\nJobId: "
                    .. string.sub(game.JobId, 1, 12)
                )
            end
        )
    end
)

--==================================================
-- SERVER HOP
--==================================================

AddCommand(
    "Server Hop",
    "Server",
    function(frame)

        local button = Create("TextButton", {
            Parent = frame,
            BackgroundColor3 = C().Accent,
            Position = UDim2.new(1, -135, 0.5, -17),
            Size = UDim2.new(0, 120, 0, 34),
            Text = "HOP",
            TextColor3 = C().Text,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false
        })

        AddCorner(button, 7)

        Connect(
            button.MouseButton1Click,
            function()

                if Terminated then
                    return
                end

                Notify(
                    "Server Hop",
                    "Teleporting to another public server..."
                )

                local success, errorMessage =
                    pcall(function()

                        TeleportService:Teleport(
                            game.PlaceId,
                            Player
                        )
                    end)

                if not success then

                    Notify(
                        "Server Hop",
                        "Teleport failed: "
                        .. tostring(errorMessage)
                    )
                end
            end
        )
    end
)

--==================================================
-- WAYPOINT SYSTEM
--==================================================

local WaypointContainer = Create("Frame", {
    Parent = ToolsPage,
    BackgroundColor3 = C().Panel,
    Position = UDim2.new(0, 15, 0, 90),
    Size = UDim2.new(1, -30, 1, -90),
    Visible = false
})

AddCorner(WaypointContainer, 8)

local WaypointNameBox = Create("TextBox", {
    Parent = WaypointContainer,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0, 12, 0, 12),
    Size = UDim2.new(1, -125, 0, 38),
    PlaceholderText = "Waypoint name...",
    PlaceholderColor3 = C().SubText,
    Text = "",
    TextColor3 = C().Text,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false
})

AddCorner(WaypointNameBox, 7)
AddStroke(WaypointNameBox, C().Stroke, 1)

local WaypointSaveButton = Create("TextButton", {
    Parent = WaypointContainer,
    BackgroundColor3 = C().Accent,
    Position = UDim2.new(1, -105, 0, 12),
    Size = UDim2.new(0, 93, 0, 38),
    Text = "ADD",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false
})

AddCorner(WaypointSaveButton, 7)

local WaypointList = Create("ScrollingFrame", {
    Parent = WaypointContainer,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 60),
    Size = UDim2.new(1, -24, 1, -72),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = C().Accent,
    BorderSizePixel = 0
})

local WaypointLayout = Instance.new("UIListLayout")
WaypointLayout.Padding = UDim.new(0, 7)
WaypointLayout.Parent = WaypointList

--==================================================
-- GET ROOT
--==================================================

local function GetRoot()

    local character = Player.Character

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- CREATE WAYPOINT BUTTON
--==================================================

local function CreateWaypointButton(name)

    local waypointData = Waypoints[name]

    if not waypointData then
        return
    end

    local frame = Create("Frame", {
        Parent = WaypointList,
        BackgroundColor3 = C().Panel2,
        Size = UDim2.new(1, -5, 0, 55)
    })

    AddCorner(frame, 7)
    AddStroke(frame, C().Stroke, 1)

    local nameLabel = Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -220, 1, 0),
        Text = name,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local gotoButton = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = C().Enabled,
        Position = UDim2.new(1, -195, 0.5, -17),
        Size = UDim2.new(0, 85, 0, 34),
        Text = "GOTO",
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false
    })

    AddCorner(gotoButton, 7)

    local deleteButton = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = C().Disabled,
        Position = UDim2.new(1, -102, 0.5, -17),
        Size = UDim2.new(0, 90, 0, 34),
        Text = "DELETE",
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false
    })

    AddCorner(deleteButton, 7)

    Connect(
        gotoButton.MouseButton1Click,
        function()

            local root = GetRoot()

            if not root then
                Notify(
                    "Waypoint",
                    "Character or HumanoidRootPart not found."
                )
                return
            end

            local savedWaypoint = Waypoints[name]

            if not savedWaypoint then
                return
            end

            root.CFrame =
                CFrame.new(savedWaypoint.Position)

            Notify(
                "Waypoint",
                "Teleported to " .. name
            )
        end
    )

    Connect(
        deleteButton.MouseButton1Click,
        function()

            if Waypoints[name] then
                Waypoints[name] = nil
            end

            if frame and frame.Parent then
                frame:Destroy()
            end

            Notify(
                "Waypoint",
                "Deleted " .. name
            )
        end
    )
end

--==================================================
-- ADD WAYPOINT
--==================================================

Connect(
    WaypointSaveButton.MouseButton1Click,
    function()

        local name =
            string.gsub(
                WaypointNameBox.Text,
                "^%s*(.-)%s*$",
                "%1"
            )

        if name == "" then

            Notify(
                "Waypoint",
                "Enter a valid waypoint name."
            )

            return
        end

        local root = GetRoot()

        if not root then

            Notify(
                "Waypoint",
                "Character or HumanoidRootPart not found."
            )

            return
        end

        if Waypoints[name] then

            Notify(
                "Waypoint",
                "A waypoint with that name already exists."
            )

            return
        end

        Waypoints[name] = {
            Position = root.Position
        }

        CreateWaypointButton(name)

        WaypointNameBox.Text = ""

        Notify(
            "Waypoint",
            "Added " .. name
        )
    end
)

--==================================================
-- CATEGORY BUTTONS
--==================================================

local Categories = {
    "All",
    "Movement",
    "Visual",
    "Utility",
    "Server",
    "Waypoints"
}

local CategoryButtons = {}

for _, category in ipairs(Categories) do

    local button = Create("TextButton", {
        Parent = CategoryHolder,
        BackgroundColor3 = C().Panel2,
        Size = UDim2.new(0, 82, 0, 32),
        Text = category,
        TextColor3 = C().Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false
    })

    AddCorner(button, 7)

    CategoryButtons[category] = button

    Connect(
        button.MouseButton1Click,
        function()

            CurrentCategory = category

            if category == "Waypoints" then

                CommandScroll.Visible = false
                WaypointContainer.Visible = true

            else

                CommandScroll.Visible = true
                WaypointContainer.Visible = false
            end

            for name, categoryButton in pairs(CategoryButtons) do

                if name == CurrentCategory then
                    categoryButton.BackgroundColor3 =
                        C().Enabled
                else
                    categoryButton.BackgroundColor3 =
                        C().Panel2
                end
            end

            for _, entry in ipairs(CommandEntries) do

                local categoryMatch =
                    CurrentCategory == "All"
                    or entry.Category == CurrentCategory

                local searchMatch =
                    SearchText == ""
                    or string.find(
                        entry.Name,
                        SearchText,
                        1,
                        true
                    )

                entry.Frame.Visible =
                    categoryMatch
                    and searchMatch
            end
        end
    )
end

--==================================================
-- SEARCH
--==================================================

Connect(
    SearchBox:GetPropertyChangedSignal("Text"),
    function()

        SearchText =
            string.lower(SearchBox.Text)

        for _, entry in ipairs(CommandEntries) do

            local categoryMatch =
                CurrentCategory == "All"
                or entry.Category == CurrentCategory

            local searchMatch =
                SearchText == ""
                or string.find(
                    entry.Name,
                    SearchText,
                    1,
                    true
                )

            entry.Frame.Visible =
                categoryMatch
                and searchMatch
        end
    end
)

--==================================================
-- SETTINGS
--==================================================

local SettingsTitle = Create("TextLabel", {
    Parent = SettingsPage,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 5),
    Size = UDim2.new(1, -30, 0, 30),
    Text = "SETTINGS",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ThemeButton = Create("TextButton", {
    Parent = SettingsPage,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0, 15, 0, 50),
    Size = UDim2.new(0, 250, 0, 42),
    Text = "Theme: Dark",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

AddCorner(ThemeButton, 8)

Connect(
    ThemeButton.MouseButton1Click,
    function()

        if CurrentTheme == "Dark" then
            CurrentTheme = "Light"
        else
            CurrentTheme = "Dark"
        end

        ThemeButton.Text =
            "Theme: " .. CurrentTheme

        ApplyTheme()
    end
)

local ScaleBox = Create("TextBox", {
    Parent = SettingsPage,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0, 285, 0, 50),
    Size = UDim2.new(0, 250, 0, 42),
    Text = "1",
    PlaceholderText = "GUI Scale 0.5 - 1",
    PlaceholderColor3 = C().SubText,
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ClearTextOnFocus = false
})

AddCorner(ScaleBox, 8)

Connect(
    ScaleBox.FocusLost,
    function()

        local value = tonumber(ScaleBox.Text)

        if not value then
            ScaleBox.Text = tostring(UIScale.Scale)
            return
        end

        value = math.clamp(value, 0.5, 1)

        UIScale.Scale = value
        ScaleBox.Text = tostring(value)
    end
)

local KeybindButton = Create("TextButton", {
    Parent = SettingsPage,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0, 15, 0, 105),
    Size = UDim2.new(0, 250, 0, 42),
    Text = "Keybind: RightShift",
    TextColor3 = C().Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

AddCorner(KeybindButton, 8)

local WaitingForKey = false

Connect(
    KeybindButton.MouseButton1Click,
    function()

        if WaitingForKey then
            return
        end

        WaitingForKey = true
        KeybindButton.Text = "Press a key..."

        local connection

        connection = UIS.InputBegan:Connect(
            function(input, processed)

                if processed then
                    return
                end

                if input.UserInputType ==
                    Enum.UserInputType.Keyboard then

                    Keybind = input.KeyCode

                    KeybindButton.Text =
                        "Keybind: "
                        .. Keybind.Name

                    WaitingForKey = false

                    if connection then
                        connection:Disconnect()
                    end
                end
            end
        )
    end
)

--==================================================
-- TERMINATE
--==================================================

local TerminateButton = Create("TextButton", {
    Parent = SettingsPage,
    BackgroundColor3 = Color3.fromRGB(120, 35, 35),
    Position = UDim2.new(0, 15, 0, 160),
    Size = UDim2.new(0, 250, 0, 42),
    Text = "TERMINATE Y DASHBOARD",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false
})

AddCorner(TerminateButton, 8)

--==================================================
-- Y BUTTON
--==================================================

local YButton = Create("TextButton", {
    Parent = ScaleHolder,
    BackgroundColor3 = Color3.fromRGB(50, 80, 255),
    Position = UDim2.new(0.5, -29, 0, 30),
    Size = UDim2.new(0, 58, 0, 58),
    Text = "Y",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 25,
    AutoButtonColor = false,
    ZIndex = Z.YButton
})

AddCorner(YButton, 14)

local YGradient = Create("UIGradient", {
    Parent = YButton,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(30, 110, 255)
        ),
        ColorSequenceKeypoint.new(
            0.5,
            Color3.fromRGB(150, 50, 255)
        ),
        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(255, 45, 80)
        )
    }),
    Rotation = 45
})

local YStroke = Instance.new("UIStroke")
YStroke.Color = Color3.fromRGB(255, 255, 255)
YStroke.Thickness = 1.5
YStroke.Transparency = 0.15
YStroke.Parent = YButton

--==================================================
-- LOCK BUTTON
--==================================================

local LockButton = Create("TextButton", {
    Parent = ScaleHolder,
    BackgroundColor3 = C().Panel2,
    Position = UDim2.new(0.5, 38, 0, 43),
    Size = UDim2.new(0, 32, 0, 32),
    Text = "🔓",
    TextColor3 = C().Text,
    TextSize = 15,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false,
    ZIndex = Z.LockButton
})

AddCorner(LockButton, 8)

--==================================================
-- Y BUTTON DRAG
--==================================================

Connect(
    YButton.InputBegan,
    function(input)

        if Terminated or YLocked then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            YDragging = true
            YMoved = false
            YPressStart = input.Position

            local startPosition =
                YButton.Position

            local connection

            connection = input.Changed:Connect(
                function()

                    if input.UserInputState ==
                        Enum.UserInputState.End then

                        YDragging = false

                        if connection then
                            connection:Disconnect()
                        end
                    end
                end
            )

            local changedConnection

            changedConnection = UIS.InputChanged:Connect(
                function(changedInput)

                    if not YDragging then
                        return
                    end

                    if changedInput.UserInputType ==
                        Enum.UserInputType.MouseMovement
                        or changedInput.UserInputType ==
                        Enum.UserInputType.Touch then

                        local delta =
                            changedInput.Position
                            - YPressStart

                        if math.abs(delta.X) > 5
                            or math.abs(delta.Y) > 5 then

                            YMoved = true
                        end

                        local x =
                            startPosition.X.Offset
                            + delta.X

                        local y =
                            startPosition.Y.Offset
                            + delta.Y

                        local camera =
                            workspace.CurrentCamera

                        if camera then

                            local viewport =
                                camera.ViewportSize

                            x = math.clamp(
                                x,
                                -viewport.X / 2 + 29,
                                viewport.X / 2 - 29
                            )

                            y = math.clamp(
                                y,
                                0,
                                viewport.Y - 88
                            )
                        end

                        YButton.Position =
                            UDim2.new(
                                0.5,
                                x,
                                0,
                                y
                            )

                        LockButton.Position =
                            UDim2.new(
                                0.5,
                                x + 67,
                                0,
                                y + 13
                            )
                    end
                end
            )

            task.delay(0.5, function()

                if changedConnection then
                    changedConnection:Disconnect()
                end
            end)
        end
    end
)

--==================================================
-- Y BUTTON CLICK
--==================================================

Connect(
    YButton.MouseButton1Click,
    function()

        if Terminated or YMoved then
            YMoved = false
            return
        end

        DashboardOpen = not DashboardOpen

        Dashboard.Visible = DashboardOpen
        Shadow.Visible = DashboardOpen
        TabHolder.Visible = DashboardOpen
        ContentHolder.Visible = DashboardOpen
    end
)

--==================================================
-- LOCK
--==================================================

Connect(
    LockButton.MouseButton1Click,
    function()

        if Terminated then
            return
        end

        YLocked = not YLocked

        LockButton.Text =
            YLocked and "🔒" or "🔓"
    end
)

--==================================================
-- KEYBIND
--==================================================

Connect(
    UIS.InputBegan,
    function(input, processed)

        if processed or Terminated then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.Keyboard
            and input.KeyCode == Keybind then

            DashboardOpen = not DashboardOpen

            Dashboard.Visible = DashboardOpen
            Shadow.Visible = DashboardOpen
            TabHolder.Visible = DashboardOpen
            ContentHolder.Visible = DashboardOpen
        end
    end
)

--==================================================
-- CHARACTER ADDED
--==================================================

Connect(
    Player.CharacterAdded,
    function()

        task.wait(0.2)

        if Terminated then
            return
        end

        if WalkSpeedEnabled then

            local character = Player.Character

            local humanoid =
                character
                and character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.WalkSpeed =
                    WalkSpeedValue
            end
        end

        if JumpPowerEnabled then

            local character = Player.Character

            local humanoid =
                character
                and character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower =
                    JumpPowerValue
            end
        end

        if ESPEnabled then
            UpdateESP()
        end
    end
)

--==================================================
-- TERMINATE
--==================================================

local function TerminateDashboard()

    if Terminated then
        return
    end

    Terminated = true

    workspace.Gravity =
        OriginalGravity

    local character = Player.Character

    if character then

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end

        for _, object in ipairs(
            character:GetDescendants()
        ) do

            if object:IsA("BasePart") then
                object.CanCollide = true
            end
        end
    end

    for player, data in pairs(ESPObjects) do

        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end
    end

    ESPObjects = {}

    for _, connection in ipairs(Connections) do

        if connection
            and connection.Connected then

            connection:Disconnect()
        end
    end

    Connections = {}

    if ScreenGui then
        ScreenGui:Destroy()
    end
end

Connect(
    TerminateButton.MouseButton1Click,
    TerminateDashboard
)

--==================================================
-- INITIAL STATE
--==================================================

ShowPage(ExecutePage)

if CategoryButtons.All then
    CategoryButtons.All.BackgroundColor3 =
        C().Enabled
end

Notify(
    "YDashboard",
    "Dashboard loaded successfully."
)
