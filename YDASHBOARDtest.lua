--// YDashboard
--// LocalScript
--// For your own Roblox experience

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Player = Players.LocalPlayer

--==================================================
-- CLEAN OLD DASHBOARD
--==================================================

pcall(function()
	local old = Player.PlayerGui:FindFirstChild("YDashboard")
	if old then
		old:Destroy()
	end
end)

--==================================================
-- STATE
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

--==================================================
-- WAYPOINTS
--==================================================

local Waypoints = {}

--==================================================
-- CONNECTIONS
--==================================================

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

--==================================================
-- HELPERS
--==================================================

local ThemeObjects = {}

local function Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Connections, connection)
	return connection
end

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
-- CYBER EFFECTS
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
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 110, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 50, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 45, 80))
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
-- DASHBOARD DRAG
--==================================================

local DashboardDragBar = Create("Frame", {
	Parent = Dashboard,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 5),
	Size = UDim2.new(1, -20, 0, 65),
	ZIndex = Z.DragBar,
	Active = true
})

local DashboardDragging = false
local DashboardDragStart
local DashboardStartPos

Connect(DashboardDragBar.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		DashboardDragging = true
		DashboardDragStart = input.Position
		DashboardStartPos = Dashboard.Position

		local connection

		connection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				DashboardDragging = false
				connection:Disconnect()
			end
		end)
	end
end)

Connect(UIS.InputChanged, function(input)
	if not DashboardDragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - DashboardDragStart

	Dashboard.Position = UDim2.new(
		DashboardStartPos.X.Scale,
		DashboardStartPos.X.Offset + delta.X,
		DashboardStartPos.Y.Scale,
		DashboardStartPos.Y.Offset + delta.Y
	)

	Shadow.Position = UDim2.new(
		Dashboard.Position.X.Scale,
		Dashboard.Position.X.Offset - 5,
		Dashboard.Position.Y.Scale,
		Dashboard.Position.Y.Offset - 5
	)
end)

--==================================================
-- TABS
--==================================================

local TabHolder = Create("Frame", {
	Parent = Dashboard,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 15, 0, 85),
	Size = UDim2.new(1, -30, 0, 40),
	ZIndex = Z.Content
})

local function CreateTab(text, x)
	local button = Create("TextButton", {
		Parent = TabHolder,
		BackgroundColor3 = C().Panel2,
		Position = UDim2.new(0, x, 0, 0),
		Size = UDim2.new(0, 125, 0, 38),
		Text = text,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		AutoButtonColor = false,
		ZIndex = Z.Tabs,
		Active = true
	})

	AddCorner(button, 8)
	AddStroke(button, C().Stroke, 1)

	return button
end

local ExecuteTab = CreateTab("EXECUTE", 0)
local ToolsTab = CreateTab("TOOLS", 135)
local SettingsTab = CreateTab("SETTINGS", 270)

--==================================================
-- CONTENT
--==================================================

local ContentHolder = Create("Frame", {
	Parent = Dashboard,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 15, 0, 135),
	Size = UDim2.new(1, -30, 1, -150),
	ZIndex = Z.Content
})

--==================================================
-- NOTIFICATIONS
--==================================================

local NotificationHolder = Create("Frame", {
	Parent = ScreenGui,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -310, 0, 20),
	Size = UDim2.new(0, 290, 1, -40),
	ZIndex = Z.Notifications
})

local NotificationLayout = Create("UIListLayout", {
	Parent = NotificationHolder,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8)
})

local function Notify(title, message)
	if Terminated then
		return
	end

	local notification = Create("Frame", {
		Parent = NotificationHolder,
		BackgroundColor3 = C().Panel,
		BackgroundTransparency = 0.05,
		Size = UDim2.new(1, 0, 0, 65),
		ZIndex = Z.Notifications
	})

	AddCorner(notification, 10)
	AddStroke(notification, C().Accent, 1)

	Create("TextLabel", {
		Parent = notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 7),
		Size = UDim2.new(1, -24, 0, 20),
		Text = title,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Z.Notifications
	})

	Create("TextLabel", {
		Parent = notification,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 28),
		Size = UDim2.new(1, -24, 0, 28),
		Text = message,
		TextColor3 = C().SubText,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Z.Notifications
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
-- EXECUTE PAGE
--==================================================

Create("TextLabel", {
	Parent = ExecutePage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 20),
	Size = UDim2.new(1, -20, 0, 50),
	Text = "EXECUTE MODULES",
	TextColor3 = C().Text,
	Font = Enum.Font.GothamBlack,
	TextSize = 22,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = Z.Buttons
})

Create("TextLabel", {
	Parent = ExecutePage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 70),
	Size = UDim2.new(1, -20, 0, 60),
	Text = "Use this page for modules and commands belonging to your own experience.",
	TextColor3 = C().SubText,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = Z.Buttons
})

--==================================================
-- TOOLS SEARCH
--==================================================

local SearchBox = Create("TextBox", {
	Parent = ToolsPage,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 38),
	Text = "",
	PlaceholderText = "Search commands...",
	PlaceholderColor3 = C().SubText,
	TextColor3 = C().Text,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	ClearTextOnFocus = false,
	ZIndex = Z.Inputs
})

AddCorner(SearchBox, 8)
AddStroke(SearchBox, C().Stroke, 1)

local CategoryHolder = Create("Frame", {
	Parent = ToolsPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 48),
	Size = UDim2.new(1, 0, 0, 35),
	ZIndex = Z.Content
})

local Categories = {
	"All",
	"Movement",
	"Visual",
	"Utility",
	"Server",
	"Waypoints"
}

local CategoryButtons = {}

for i, category in ipairs(Categories) do
	local button = Create("TextButton", {
		Parent = CategoryHolder,
		BackgroundColor3 = category == "All" and C().Enabled or C().Panel2,
		Position = UDim2.new(0, (i - 1) * 105, 0, 0),
		Size = UDim2.new(0, 95, 0, 32),
		Text = category,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	CategoryButtons[category] = button
end

local CommandScroll = Create("ScrollingFrame", {
	Parent = ToolsPage,
	BackgroundColor3 = C().Panel,
	BackgroundTransparency = 0.2,
	Position = UDim2.new(0, 0, 0, 95),
	Size = UDim2.new(1, 0, 1, -95),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = C().Accent,
	BorderSizePixel = 0,
	ZIndex = Z.Content
})

AddCorner(CommandScroll, 10)

Create("UIListLayout", {
	Parent = CommandScroll,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 7)
})

Create("UIPadding", {
	Parent = CommandScroll,
	PaddingTop = UDim.new(0, 8),
	PaddingBottom = UDim.new(0, 8),
	PaddingLeft = UDim.new(0, 8),
	PaddingRight = UDim.new(0, 8)
})

--==================================================
-- COMMAND HELPERS
--==================================================

local CommandEntries = {}

local function AddCommand(name, category)
	local frame = Create("Frame", {
		Parent = CommandScroll,
		BackgroundColor3 = C().Panel2,
		Size = UDim2.new(1, -16, 0, 70),
		ZIndex = Z.Content
	})

	AddCorner(frame, 9)
	AddStroke(frame, C().Stroke, 1)

	Create("TextLabel", {
		Parent = frame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 10),
		Size = UDim2.new(0, 180, 0, 24),
		Text = name,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Z.Buttons
	})

	Create("TextLabel", {
		Parent = frame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 34),
		Size = UDim2.new(0, 180, 0, 18),
		Text = category,
		TextColor3 = C().SubText,
		Font = Enum.Font.Gotham,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Z.Buttons
	})

	local entry = {
		Frame = frame,
		Name = name,
		Category = category
	}

	table.insert(CommandEntries, entry)

	return frame
end

--==================================================
-- TOGGLE
--==================================================

local function AddToggle(frame, default, callback, xOffset)
	local state = default
	xOffset = xOffset or -95

	local button = Create("TextButton", {
		Parent = frame,
		BackgroundColor3 = state and C().Enabled or C().Disabled,
		Position = UDim2.new(1, xOffset, 0.5, -16),
		Size = UDim2.new(0, 85, 0, 32),
		Text = state and "ON" or "OFF",
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	Connect(button.MouseButton1Click, function()
		state = not state

		button.Text = state and "ON" or "OFF"
		button.BackgroundColor3 = state and C().Enabled or C().Disabled

		callback(state)
	end)

	return button
end

--==================================================
-- NUMBER INPUT
--==================================================

local function AddNumberInput(frame, defaultValue, callback)
	local box = Create("TextBox", {
		Parent = frame,
		BackgroundColor3 = C().Panel3,
		Position = UDim2.new(1, -195, 0.5, -16),
		Size = UDim2.new(0, 85, 0, 32),
		Text = tostring(defaultValue),
		PlaceholderText = "Value",
		TextColor3 = C().Text,
		PlaceholderColor3 = C().SubText,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		ClearTextOnFocus = false,
		ZIndex = Z.Inputs,
		Active = true
	})

	AddCorner(box, 7)
	AddStroke(box, C().Stroke, 1)

	local apply = Create("TextButton", {
		Parent = frame,
		BackgroundColor3 = C().Accent,
		Position = UDim2.new(1, -100, 0.5, -16),
		Size = UDim2.new(0, 90, 0, 32),
		Text = "APPLY",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBlack,
		TextSize = 9,
		AutoButtonColor = false,
		ZIndex = Z.Inputs,
		Active = true
	})

	AddCorner(apply, 7)

	local function Apply()
		local value = tonumber(box.Text)

		if value == nil then
			Notify("Input", "Please enter a valid number.")
			return
		end

		callback(value)
	end

	Connect(apply.MouseButton1Click, Apply)

	Connect(box.FocusLost, function(enterPressed)
		if enterPressed then
			Apply()
		end
	end)

	return box, apply
end

--==================================================
-- EXECUTE BUTTONS
--==================================================

local ExecuteButton = Create("TextButton", {
	Parent = ExecutePage,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0, 15, 0, 145),
	Size = UDim2.new(0, 250, 0, 45),
	Text = "Execute SAEV3",
	TextColor3 = C().Text,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	ZIndex = Z.Buttons,
	Active = true
})

AddCorner(ExecuteButton, 8)
AddStroke(ExecuteButton, C().Stroke, 1)

local ExecuteButton2 = Create("TextButton", {
	Parent = ExecutePage,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0, 285, 0, 145),
	Size = UDim2.new(0, 250, 0, 45),
	Text = "Execute SAEV4",
	TextColor3 = C().Text,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	ZIndex = Z.Buttons,
	Active = true
})

AddCorner(ExecuteButton2, 8)
AddStroke(ExecuteButton2, C().Stroke, 1)

local ExecuteButton3 = Create("TextButton", {
	Parent = ExecutePage,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0, 15, 0, 200),
	Size = UDim2.new(0, 250, 0, 45),
	Text = "Execute BloxFruit",
	TextColor3 = C().Text,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	ZIndex = Z.Buttons,
	Active = true
})

AddCorner(ExecuteButton3, 8)
AddStroke(ExecuteButton3, C().Stroke, 1)

--==================================================
-- EXECUTE
--==================================================

Connect (ExecuteButton.MouseButton1Click, function()
	Notify("Execute", "SAEV3 button clicked")
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/73260ee6e0b3892aa700a13e1fd7d3c9.lua"))()
end)

Connect (ExecuteButton2.MouseButton1Click, function()
	Notify("Execute", "SAEV4 button clicked")
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/4595fe31a5f7a8b4f4dd7071f3119ef7.lua"))()
end)


Connect (ExecuteButton3.MouseButton1Click, function()
	Notify("Execute", "BloxFruit button clicked")
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/main/MainV3.lua"))()
			
end)

--==================================================
-- WALKSPEED
--==================================================

do
	local frame = AddCommand("WalkSpeed", "Movement")

	AddToggle(frame, false, function(state)
		WalkSpeedEnabled = state

		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.WalkSpeed = state and WalkSpeedValue or 16
		end

		Notify(
			"WalkSpeed",
			state and ("Enabled: " .. tostring(WalkSpeedValue)) or "Disabled"
		)
	end, -290)

	AddNumberInput(frame, 16, function(value)
		WalkSpeedValue = value

		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if WalkSpeedEnabled and humanoid then
			humanoid.WalkSpeed = value
		end

		Notify("WalkSpeed", "Applied: " .. tostring(value))
	end)
end

--==================================================
-- JUMP POWER
--==================================================

do
	local frame = AddCommand("JumpPower", "Movement")

	AddToggle(frame, false, function(state)
		JumpPowerEnabled = state

		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = state and JumpPowerValue or 50
		end

		Notify(
			"JumpPower",
			state and ("Enabled: " .. tostring(JumpPowerValue)) or "Disabled"
		)
	end, -290)

	AddNumberInput(frame, 50, function(value)
		JumpPowerValue = value

		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if JumpPowerEnabled and humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = value
		end

		Notify("JumpPower", "Applied: " .. tostring(value))
	end)
end

--==================================================
-- GRAVITY
--==================================================

do
	local frame = AddCommand("Gravity", "Movement")

	AddToggle(frame, false, function(state)
		GravityEnabled = state

		if state then
			workspace.Gravity = GravityValue
			Notify("Gravity", "Enabled: " .. tostring(GravityValue))
		else
			workspace.Gravity = OriginalGravity
			Notify("Gravity", "Restored")
		end
	end, -290)

	AddNumberInput(frame, GravityValue, function(value)
		GravityValue = value

		if GravityEnabled then
			workspace.Gravity = value
		end

		Notify("Gravity", "Applied: " .. tostring(value))
	end)
end

--==================================================
-- NOCLIP
--==================================================

do
	local frame = AddCommand("Noclip", "Movement")

	AddToggle(frame, false, function(state)
		NoclipEnabled = state

		Notify("Noclip", state and "Enabled" or "Disabled")
	end)
end

--==================================================
-- FLY JUMP
--==================================================

do
	local frame = AddCommand("Fly Jump", "Movement")

	AddToggle(frame, false, function(state)
		FlyJumpEnabled = state

		Notify("Fly Jump", state and "Enabled" or "Disabled")
	end)
end

--==================================================
-- PLAYER ESP
--==================================================

local function RemoveESP()
	for player, objects in pairs(ESPObjects) do
		for _, object in pairs(objects) do
			pcall(function()
				object:Destroy()
			end)
		end

		ESPObjects[player] = nil
	end
end

local function CreateESP(player)
	if player == Player or not ESPEnabled then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local highlight = Instance.new("Highlight")

	highlight.Name = "YDashboardESP"
	highlight.FillTransparency = 0.75
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = character
	highlight.Parent = character

	ESPObjects[player] = {
		highlight
	}
end

local function RefreshESP()
	RemoveESP()

	if not ESPEnabled then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		CreateESP(player)
	end
end

do
	local frame = AddCommand("Player ESP", "Visual")

	AddToggle(frame, false, function(state)
		ESPEnabled = state
		RefreshESP()

		Notify("Player ESP", state and "Enabled" or "Disabled")
	end)
end

--==================================================
-- INSTANT INTERACTION
--==================================================

do
	local frame = AddCommand("Instant Interaction", "Utility")

	AddToggle(frame, false, function(state)
		InstantInteractionEnabled = state

		Notify(
			"Instant Interaction",
			state and "Enabled" or "Disabled"
		)
	end)
end

--==================================================
-- RESET CHARACTER
--==================================================

do
	local frame = AddCommand("Reset Character", "Utility")

	local button = Create("TextButton", {
		Parent = frame,
		BackgroundColor3 = C().Panel3,
		Position = UDim2.new(1, -100, 0.5, -16),
		Size = UDim2.new(0, 90, 0, 32),
		Text = "RESET",
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	Connect(button.MouseButton1Click, function()
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.Health = 0
		end

		Notify("Reset Character", "Character reset.")
	end)
end

--==================================================
-- SERVER INFO
--==================================================

do
	local frame = AddCommand("Server Info", "Server")

	local button = Create("TextButton", {
		Parent = frame,
		BackgroundColor3 = C().Panel3,
		Position = UDim2.new(1, -100, 0.5, -16),
		Size = UDim2.new(0, 90, 0, 32),
		Text = "SHOW",
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	Connect(button.MouseButton1Click, function()
		Notify(
			"Server Info",
			"Players: "
				.. tostring(#Players:GetPlayers())
				.. " | JobId: "
				.. string.sub(game.JobId, 1, 8)
		)
	end)
end

--==================================================
-- WAYPOINT CONTAINER
--==================================================

local WaypointContainer = Create("Frame", {
	Parent = ToolsPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 95),
	Size = UDim2.new(1, 0, 1, -95),
	Visible = false,
	ZIndex = Z.Content
})

--==================================================
-- WAYPOINT NAME INPUT
--==================================================

local WaypointNameBox = Create("TextBox", {
	Parent = WaypointContainer,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, -115, 0, 38),
	Text = "",
	PlaceholderText = "Enter waypoint name...",
	PlaceholderColor3 = C().SubText,
	TextColor3 = C().Text,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	ClearTextOnFocus = false,
	ZIndex = Z.Inputs,
	Active = true
})

AddCorner(WaypointNameBox, 8)
AddStroke(WaypointNameBox, C().Stroke, 1)

local WaypointSaveButton = Create("TextButton", {
	Parent = WaypointContainer,
	BackgroundColor3 = C().Accent,
	Position = UDim2.new(1, -105, 0, 0),
	Size = UDim2.new(0, 105, 0, 38),
	Text = "SAVE",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBlack,
	TextSize = 10,
	AutoButtonColor = false,
	ZIndex = Z.Inputs,
	Active = true
})

AddCorner(WaypointSaveButton, 8)

--==================================================
-- WAYPOINT LIST
--==================================================

local WaypointList = Create("ScrollingFrame", {
	Parent = WaypointContainer,
	BackgroundColor3 = C().Panel,
	BackgroundTransparency = 0.2,
	Position = UDim2.new(0, 0, 0, 48),
	Size = UDim2.new(1, 0, 1, -48),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = C().Accent,
	BorderSizePixel = 0,
	ZIndex = Z.Content
})

AddCorner(WaypointList, 10)

local WaypointLayout = Create("UIListLayout", {
	Parent = WaypointList,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 6)
})

Create("UIPadding", {
	Parent = WaypointList,
	PaddingTop = UDim.new(0, 7),
	PaddingBottom = UDim.new(0, 7),
	PaddingLeft = UDim.new(0, 7),
	PaddingRight = UDim.new(0, 7)
})

--==================================================
-- WAYPOINT CREATION
--==================================================

local function CreateWaypointButton(name)
	local button = Create("TextButton", {
		Parent = WaypointList,
		BackgroundColor3 = C().Panel2,
		Size = UDim2.new(1, -14, 0, 42),
		Text = name,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextWrapped = true,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)
	AddStroke(button, C().Stroke, 1)

	Connect(button.MouseButton1Click, function()
		local waypoint = Waypoints[name]

		if not waypoint then
			Notify("Waypoint", "Waypoint no longer exists.")
			return
		end

		local root = GetRoot()

		if not root then
			Notify("Waypoint", "Character not found.")
			return
		end

		root.CFrame = waypoint

		Notify(
			"Waypoint",
			"Teleported to " .. name
		)
	end)

	return button
end

Connect(WaypointSaveButton.MouseButton1Click, function()
	local name = WaypointNameBox.Text

	if not name or name:match("^%s*$") then
		Notify(
			"Waypoint",
			"Enter a waypoint name first."
		)
		return
	end

	name = name:match("^%s*(.-)%s*$")

	local root = GetRoot()

	if not root then
		Notify(
			"Waypoint",
			"Character not found."
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

	Waypoints[name] = root.CFrame

	CreateWaypointButton(name)

	WaypointNameBox.Text = ""

	Notify(
		"Waypoint",
		"Saved: " .. name
	)
end)

--==================================================
-- SETTINGS
--==================================================

local function CreateSettingRow(name, y)
	local row = Create("Frame", {
		Parent = SettingsPage,
		BackgroundColor3 = C().Panel2,
		Position = UDim2.new(0, 0, 0, y),
		Size = UDim2.new(1, 0, 0, 60),
		ZIndex = Z.Content
	})

	AddCorner(row, 9)
	AddStroke(row, C().Stroke, 1)

	Create("TextLabel", {
		Parent = row,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 8),
		Size = UDim2.new(0, 200, 0, 22),
		Text = name,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Z.Buttons
	})

	return row
end

--==================================================
-- THEME
--==================================================

do
	local row = CreateSettingRow("Theme", 0)

	local button = Create("TextButton", {
		Parent = row,
		BackgroundColor3 = C().Panel3,
		Position = UDim2.new(1, -120, 0.5, -16),
		Size = UDim2.new(0, 105, 0, 32),
		Text = CurrentTheme,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	Connect(button.MouseButton1Click, function()
		if CurrentTheme == "Dark" then
			CurrentTheme = "Light"
		else
			CurrentTheme = "Dark"
		end

		ApplyTheme()

		button.Text = CurrentTheme

		Notify(
			"Theme",
			"Theme changed to " .. CurrentTheme
		)
	end)
end

--==================================================
-- GUI SCALE
--==================================================

do
	local row = CreateSettingRow("GUI Scale", 70)

	AddNumberInput(row, 1, function(value)
		value = math.clamp(value, 0.5, 1)

		UIScale.Scale = value

		Notify(
			"GUI Scale",
			"Scale applied: " .. tostring(value)
		)
	end)
end

--==================================================
-- KEYBIND
--==================================================

do
	local row = CreateSettingRow("Keybind", 140)

	local button = Create("TextButton", {
		Parent = row,
		BackgroundColor3 = C().Panel3,
		Position = UDim2.new(1, -120, 0.5, -16),
		Size = UDim2.new(0, 105, 0, 32),
		Text = Keybind.Name,
		TextColor3 = C().Text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = Z.Buttons,
		Active = true
	})

	AddCorner(button, 7)

	local waitingForKey = false

	Connect(button.MouseButton1Click, function()
		waitingForKey = true
		button.Text = "PRESS KEY"

		Notify(
			"Keybind",
			"Press a keyboard key."
		)
	end)

	Connect(UIS.InputBegan, function(input, processed)
		if processed or not waitingForKey then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			Keybind = input.KeyCode
			button.Text = Keybind.Name
			waitingForKey = false

			Notify(
				"Keybind",
				"Set to " .. Keybind.Name
			)
		end
	end)
end

--==================================================
-- TERMINATE
--==================================================

local TerminateRow = CreateSettingRow("Terminate", 210)

local TerminateButton = Create("TextButton", {
	Parent = TerminateRow,
	BackgroundColor3 = Color3.fromRGB(170, 45, 65),
	Position = UDim2.new(1, -120, 0.5, -16),
	Size = UDim2.new(0, 105, 0, 32),
	Text = "TERMINATE",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBlack,
	TextSize = 9,
	AutoButtonColor = false,
	ZIndex = Z.Buttons,
	Active = true
})

AddCorner(TerminateButton, 7)

Connect(TerminateButton.MouseButton1Click, function()
	Terminated = true

	workspace.Gravity = OriginalGravity

	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 50
	end

	RemoveESP()

	for _, connection in ipairs(Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(Connections)

	pcall(function()
		ScreenGui:Destroy()
	end)
end)

--==================================================
-- PAGE SWITCHING
--==================================================

local function ShowPage(page)
	ExecutePage.Visible = false
	ToolsPage.Visible = false
	SettingsPage.Visible = false

	page.Visible = true
end

Connect(ExecuteTab.MouseButton1Click, function()
	ShowPage(ExecutePage)
end)

Connect(ToolsTab.MouseButton1Click, function()
	ShowPage(ToolsPage)
end)

Connect(SettingsTab.MouseButton1Click, function()
	ShowPage(SettingsPage)
end)

--==================================================
-- SEARCH
--==================================================

Connect(SearchBox:GetPropertyChangedSignal("Text"), function()
	SearchText = string.lower(SearchBox.Text)

	for _, entry in ipairs(CommandEntries) do
		local nameMatch =
			SearchText == ""
			or string.find(
				string.lower(entry.Name),
				SearchText,
				1,
				true
			)

		local categoryMatch =
			CurrentCategory == "All"
			or entry.Category == CurrentCategory

		entry.Frame.Visible = nameMatch and categoryMatch
	end
end)

--==================================================
-- CATEGORY FILTER
--==================================================

for category, button in pairs(CategoryButtons) do
	Connect(button.MouseButton1Click, function()
		CurrentCategory = category

		for name, otherButton in pairs(CategoryButtons) do
			otherButton.BackgroundColor3 =
				name == category
				and C().Enabled
				or C().Panel2
		end

		if category == "Waypoints" then
			CommandScroll.Visible = false
			WaypointContainer.Visible = true
		else
			CommandScroll.Visible = true
			WaypointContainer.Visible = false
		end

		for _, entry in ipairs(CommandEntries) do
			local nameMatch =
				SearchText == ""
				or string.find(
					string.lower(entry.Name),
					SearchText,
					1,
					true
				)

			local categoryMatch =
				category == "All"
				or entry.Category == category

			entry.Frame.Visible = nameMatch and categoryMatch
		end
	end)
end

--==================================================
-- NOCLIP
--==================================================

Connect(RunService.Stepped, function()
	if Terminated then
		return
	end

	if not NoclipEnabled then
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
end)

--==================================================
-- WALKSPEED / JUMPPOWER
--==================================================

Connect(RunService.Heartbeat, function()
	if Terminated then
		return
	end

	local character = Player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	if WalkSpeedEnabled then
		if humanoid.WalkSpeed ~= WalkSpeedValue then
			humanoid.WalkSpeed = WalkSpeedValue
		end
	end

	if JumpPowerEnabled then
		humanoid.UseJumpPower = true

		if humanoid.JumpPower ~= JumpPowerValue then
			humanoid.JumpPower = JumpPowerValue
		end
	end
end)

--==================================================
-- FLY JUMP
--==================================================

Connect(UIS.JumpRequest, function()
	if not FlyJumpEnabled then
		return
	end

	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:ChangeState(
			Enum.HumanoidStateType.Jumping
		)
	end
end)

--==================================================
-- INSTANT INTERACTION
--==================================================

Connect(ProximityPromptService.PromptButtonHoldBegan, function(prompt)
	if not InstantInteractionEnabled then
		return
	end

	prompt.HoldDuration = 0
end)

Connect(ProximityPromptService.PromptShown, function(prompt)
	if not InstantInteractionEnabled then
		return
	end

	prompt.HoldDuration = 0
end)

--==================================================
-- PLAYER EVENTS
--==================================================

Connect(Players.PlayerAdded, function(player)
	if ESPEnabled then
		task.wait(1)
		CreateESP(player)
	end
end)

Connect(Player.CharacterAdded, function(character)
	task.wait(0.5)

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		if WalkSpeedEnabled then
			humanoid.WalkSpeed = WalkSpeedValue
		end

		if JumpPowerEnabled then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = JumpPowerValue
		end
	end

	if ESPEnabled then
		RefreshESP()
	end
end)

--==================================================
-- Y BUTTON
--==================================================

local YButton = Create("TextButton", {
	Parent = ScaleHolder,
	BackgroundColor3 = Color3.fromRGB(20, 25, 40),
	Position = UDim2.new(0.5, -29, 0, 30),
	Size = UDim2.new(0, 58, 0, 58),
	Text = "Y",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBlack,
	TextSize = 27,
	AutoButtonColor = false,
	ZIndex = Z.YButton,
	Active = true
})

AddCorner(YButton, 16)

Create("UIGradient", {
	Parent = YButton,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 110, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 45, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 40, 75))
	}),
	Rotation = 45
})

local YStroke = Create("UIStroke", {
	Parent = YButton,
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 2,
	Transparency = 0.15
})

--==================================================
-- Y GLOW
--==================================================

task.spawn(function()
	while not Terminated and YButton.Parent do
		local tween1 = TweenService:Create(
			YStroke,
			TweenInfo.new(
				0.8,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Transparency = 0.65
			}
		)

		tween1:Play()
		tween1.Completed:Wait()

		if Terminated or not YButton.Parent then
			break
		end

		local tween2 = TweenService:Create(
			YStroke,
			TweenInfo.new(
				0.8,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Transparency = 0.05
			}
		)

		tween2:Play()
		tween2.Completed:Wait()
	end
end)

--==================================================
-- LOCK BUTTON
--==================================================

local LockButton = Create("TextButton", {
	Parent = ScaleHolder,
	BackgroundColor3 = C().Panel2,
	Position = UDim2.new(0.5, 36, 0, 43),
	Size = UDim2.new(0, 34, 0, 34),
	Text = "🔓",
	TextColor3 = C().Text,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	AutoButtonColor = false,
	ZIndex = Z.LockButton,
	Active = true
})

AddCorner(LockButton, 9)
AddStroke(LockButton, C().Stroke, 1)

local function UpdateLockPosition()
	local yPos = YButton.Position

	LockButton.Position = UDim2.new(
		yPos.X.Scale,
		yPos.X.Offset + 65,
		yPos.Y.Scale,
		yPos.Y.Offset + 12
	)
end

Connect(LockButton.MouseButton1Click, function()
	YLocked = not YLocked

	LockButton.Text = YLocked and "🔒" or "🔓"

	Notify(
		"Y Button",
		YLocked and "Position locked." or "Position unlocked."
	)
end)

--==================================================
-- Y SCREEN BOUNDS
--==================================================

local function GetScreenBounds()
	local camera = workspace.CurrentCamera

	if not camera then
		return 0, 0
	end

	local viewport = camera.ViewportSize
	local scale = UIScale.Scale

	local screenWidth = viewport.X / scale
	local screenHeight = viewport.Y / scale

	local buttonWidth =
		YButton.AbsoluteSize.X / scale

	local buttonHeight =
		YButton.AbsoluteSize.Y / scale

	local maxX = math.max(
		0,
		screenWidth - buttonWidth
	)

	local maxY = math.max(
		0,
		screenHeight - buttonHeight
	)

	return maxX, maxY
end

local function ClampYPosition(x, y)
	local maxX, maxY = GetScreenBounds()

	return math.clamp(x, 0, maxX),
		math.clamp(y, 0, maxY)
end

--==================================================
-- Y DRAG
--==================================================

Connect(YButton.InputBegan, function(input)
	if YLocked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		YDragging = true
		YMoved = false
		YPressStart = input.Position

		local connection

		connection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				YDragging = false

				if connection then
					connection:Disconnect()
				end
			end
		end)
	end
end)

Connect(UIS.InputChanged, function(input)
	if not YDragging then
		return
	end

	if YLocked then
		YDragging = false
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local movement = input.Position - YPressStart

	if movement.Magnitude > 4 then
		YMoved = true
	end

	local scale = UIScale.Scale

	local pointerX = input.Position.X / scale
	local pointerY = input.Position.Y / scale

	local buttonWidth =
		YButton.AbsoluteSize.X / scale

	local buttonHeight =
		YButton.AbsoluteSize.Y / scale

	local newX =
		pointerX - buttonWidth / 2

	local newY =
		pointerY - buttonHeight / 2

	newX, newY =
		ClampYPosition(newX, newY)

	YButton.Position = UDim2.new(
		0,
		newX,
		0,
		newY
	)

	UpdateLockPosition()
end)

--==================================================
-- Y CLICK
--==================================================

Connect(YButton.MouseButton1Click, function()
	if YMoved then
		YMoved = false
		return
	end

	DashboardOpen = not DashboardOpen

	Dashboard.Visible = DashboardOpen
	Shadow.Visible = DashboardOpen
	TabHolder.Visible = DashboardOpen
	ContentHolder.Visible = DashboardOpen
end)

--==================================================
-- KEYBIND
--==================================================

Connect(UIS.InputBegan, function(input, processed)
	if processed or Terminated then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard
		and input.KeyCode == Keybind then

		DashboardOpen = not DashboardOpen

		Dashboard.Visible = DashboardOpen
		Shadow.Visible = DashboardOpen
		TabHolder.Visible = DashboardOpen
		ContentHolder.Visible = DashboardOpen
	end
end)

--==================================================
-- CAMERA RESIZE
--==================================================

Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
	if not YLocked then
		local x = YButton.Position.X.Offset
		local y = YButton.Position.Y.Offset

		x, y = ClampYPosition(x, y)

		YButton.Position = UDim2.new(
			0,
			x,
			0,
			y
		)

		UpdateLockPosition()
	end
end)

--==================================================
-- INITIAL Y POSITION
--==================================================

task.defer(function()
	local camera = workspace.CurrentCamera

	if camera then
		local viewport = camera.ViewportSize
		local scale = UIScale.Scale

		local buttonWidth =
			YButton.AbsoluteSize.X / scale

		local x =
			(viewport.X / scale) / 2
			- buttonWidth / 2

		local y = 30

		x, y =
			ClampYPosition(x, y)

		YButton.Position = UDim2.new(
			0,
			x,
			0,
			y
		)

		UpdateLockPosition()
	end
end)

--==================================================
-- INITIAL NOTIFICATION
--==================================================

task.delay(0.5, function()
	if not Terminated then
		Notify(
			"YDashboard",
			"Dashboard initialized."
		)
	end
end)

--==================================================
-- SAFETY
--==================================================

Connect(ScreenGui.AncestryChanged, function()
	if not ScreenGui.Parent then
		Terminated = true
	end
end)
