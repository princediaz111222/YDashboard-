--// Y Dashboard
--// For use in your own Roblox experience.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- VARIABLES
--==================================================

--// Melee Aura
local MeleeAura = false
local MeleeRange = 15
local MeleeConnection

local Locked = false
local Terminated = false

local InstantInteract = false
local WalkSpeedEnabled = false
local FlyJumpEnabled = false
local PlayerESPEnabled = false

local WalkSpeedValue = 16
local LastESPRefresh = 0

local Connections = {}
local ESPObjects = {}

local DraggingY = false
local DragStartY
local StartPosY

local DraggingDashboard = false
local DragStartDashboard
local StartDashboardPosition

local FlyJumpConnection
local ESPRefreshConnection

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
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YDashboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- Y BUTTON
--==================================================

local YButton = Instance.new("TextButton")
YButton.Name = "YButton"
YButton.Size = UDim2.new(0, 55, 0, 55)
YButton.Position = UDim2.new(0.5, -27, 0, 20)
YButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
YButton.Text = "Y"
YButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YButton.TextSize = 24
YButton.Font = Enum.Font.GothamBold
YButton.Parent = ScreenGui

local YCorner = Instance.new("UICorner")
YCorner.CornerRadius = UDim.new(0, 12)
YCorner.Parent = YButton

--==================================================
-- LOCK BUTTON
--==================================================

local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(0, 32, 0, 32)
LockButton.Position = UDim2.new(0.5, 38, 0, 31)
LockButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LockButton.Text = "🔓"
LockButton.TextSize = 16
LockButton.Font = Enum.Font.Gotham
LockButton.Parent = ScreenGui

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockButton

--==================================================
-- DASHBOARD
--==================================================

local Dashboard = Instance.new("Frame")
Dashboard.Name = "Dashboard"
Dashboard.Size = UDim2.new(0, 600, 0, 450)
Dashboard.Position = UDim2.new(0.5, -300, 0.5, -225)
Dashboard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Dashboard.Visible = false
Dashboard.Parent = ScreenGui

local DashboardCorner = Instance.new("UICorner")
DashboardCorner.CornerRadius = UDim.new(0, 12)
DashboardCorner.Parent = Dashboard

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "YDashBoard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Dashboard

--==================================================
-- TAB BUTTONS
--==================================================

local ExecuteTab = Instance.new("TextButton")
ExecuteTab.Name = "ExecuteTab"
ExecuteTab.Size = UDim2.new(0, 270, 0, 35)
ExecuteTab.Position = UDim2.new(0, 20, 0, 55)
ExecuteTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ExecuteTab.Text = "EXECUTE"
ExecuteTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteTab.TextSize = 14
ExecuteTab.Font = Enum.Font.GothamBold
ExecuteTab.Parent = Dashboard

local ExecuteTabCorner = Instance.new("UICorner")
ExecuteTabCorner.CornerRadius = UDim.new(0, 8)
ExecuteTabCorner.Parent = ExecuteTab

local ToolsTab = Instance.new("TextButton")
ToolsTab.Name = "ToolsTab"
ToolsTab.Size = UDim2.new(0, 270, 0, 35)
ToolsTab.Position = UDim2.new(0, 310, 0, 55)
ToolsTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToolsTab.Text = "TOOLS"
ToolsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolsTab.TextSize = 14
ToolsTab.Font = Enum.Font.GothamBold
ToolsTab.Parent = Dashboard

local ToolsTabCorner = Instance.new("UICorner")
ToolsTabCorner.CornerRadius = UDim.new(0, 8)
ToolsTabCorner.Parent = ToolsTab

--==================================================
-- TAB FRAMES
--==================================================

local ExecuteFrame = Instance.new("Frame")
ExecuteFrame.Name = "ExecuteFrame"
ExecuteFrame.Size = UDim2.new(1, -40, 0, 300)
ExecuteFrame.Position = UDim2.new(0, 20, 0, 100)
ExecuteFrame.BackgroundTransparency = 1
ExecuteFrame.Visible = true
ExecuteFrame.Parent = Dashboard

local ToolsFrame = Instance.new("Frame")
ToolsFrame.Name = "ToolsFrame"
ToolsFrame.Size = UDim2.new(1, -40, 0, 300)
ToolsFrame.Position = UDim2.new(0, 20, 0, 100)
ToolsFrame.BackgroundTransparency = 1
ToolsFrame.Visible = false
ToolsFrame.Parent = Dashboard

--==================================================
-- BUTTON FACTORIES
--==================================================

local function CreateButton(parent, name, text, position)
	local Button = Instance.new("TextButton")

	Button.Name = name
	Button.Size = UDim2.new(0, 250, 0, 42)
	Button.Position = position
	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 14
	Button.Font = Enum.Font.GothamBold
	Button.Text = text
	Button.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	return Button
end

local function CreateSwitch(parent, name, text, position)
	return CreateButton(
		parent,
		name,
		text .. ": OFF",
		position
	)
end

--==================================================
-- SLIDER FACTORY
--==================================================

local function CreateSlider(
	parent,
	name,
	text,
	position,
	minValue,
	maxValue,
	defaultValue,
	callback
)
	local Frame = Instance.new("Frame")

	Frame.Name = name
	Frame.Size = UDim2.new(0, 250, 0, 55)
	Frame.Position = position
	Frame.BackgroundTransparency = 1
	Frame.Parent = parent

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, 0, 0, 20)
	Label.BackgroundTransparency = 1
	Label.Text = text .. ": " .. defaultValue
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 14
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local SliderBar = Instance.new("TextButton")

	SliderBar.Size = UDim2.new(1, 0, 0, 10)
	SliderBar.Position = UDim2.new(0, 0, 0, 30)
	SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	SliderBar.Text = ""
	SliderBar.AutoButtonColor = false
	SliderBar.Parent = Frame

	local SliderCorner = Instance.new("UICorner")
	SliderCorner.CornerRadius = UDim.new(1, 0)
	SliderCorner.Parent = SliderBar

	local Knob = Instance.new("Frame")

	Knob.Size = UDim2.new(0, 14, 0, 14)
	Knob.AnchorPoint = Vector2.new(0.5, 0.5)

	Knob.Position = UDim2.new(
		(defaultValue - minValue) / (maxValue - minValue),
		0,
		0.5,
		0
	)

	Knob.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	Knob.Parent = SliderBar

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local Dragging = false

	local function UpdateSlider(inputX)
		local Percent = math.clamp(
			(inputX - SliderBar.AbsolutePosition.X)
				/ SliderBar.AbsoluteSize.X,
			0,
			1
		)

		local Value = math.floor(
			minValue
			+ (maxValue - minValue) * Percent
		)

		Knob.Position = UDim2.new(
			Percent,
			0,
			0.5,
			0
		)

		Label.Text = text .. ": " .. Value

		callback(Value)
	end

	Connect(
		SliderBar.InputBegan,
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then

				Dragging = true
				UpdateSlider(input.Position.X)
			end
		end
	)

	Connect(
		UserInputService.InputChanged,
		function(input)
			if not Dragging then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then

				UpdateSlider(input.Position.X)
			end
		end
	)

	Connect(
		UserInputService.InputEnded,
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then

				Dragging = false
			end
		end
	)

	callback(defaultValue)
end

--==================================================
-- EXECUTE BUTTONS
--==================================================

local ExecuteButton = CreateButton(
	ExecuteFrame,
	"ExecuteButton",
	"Execute SAEV3",
	UDim2.new(0, 15, 0, 20)
)

local ExecuteButton2 = CreateButton(
	ExecuteFrame,
	"ExecuteButton2",
	"Execute SAEV4",
	UDim2.new(0, 285, 0, 20)
)

local ExecuteButton3 = CreateButton(
	ExecuteFrame,
	"ExecuteButton3",
	"Execute bloxfruit",
	UDim2.new(0, 15, 0, 75)
)

--==================================================
-- INSTANT INTERACTION
--==================================================

local InstantInteractButton = CreateSwitch(
	ToolsFrame,
	"InstantInteractButton",
	"Instant Interaction",
	UDim2.new(0, 15, 0, 20)
)

--==================================================
-- RESET CHARACTER
--==================================================

local ResetButton = CreateButton(
	ToolsFrame,
	"ResetButton",
	"Reset Character",
	UDim2.new(0, 285, 0, 20)
)

--==================================================
-- WALK SPEED
--==================================================

local WalkSpeedButton = CreateSwitch(
	ToolsFrame,
	"WalkSpeedButton",
	"WalkSpeed",
	UDim2.new(0, 15, 0, 75)
)

local WalkSpeedBox = Instance.new("TextBox")

WalkSpeedBox.Name = "WalkSpeedBox"
WalkSpeedBox.Size = UDim2.new(0, 250, 0, 42)
WalkSpeedBox.Position = UDim2.new(0, 285, 0, 75)
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WalkSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
WalkSpeedBox.TextSize = 14
WalkSpeedBox.Font = Enum.Font.GothamBold
WalkSpeedBox.PlaceholderText = "WalkSpeed"
WalkSpeedBox.Text = "16"
WalkSpeedBox.ClearTextOnFocus = false
WalkSpeedBox.Parent = ToolsFrame

local WalkSpeedCorner = Instance.new("UICorner")
WalkSpeedCorner.CornerRadius = UDim.new(0, 8)
WalkSpeedCorner.Parent = WalkSpeedBox

--==================================================
-- FLY JUMP
--==================================================

local FlyJumpButton = CreateSwitch(
	ToolsFrame,
	"FlyJumpButton",
	"FlyJump",
	UDim2.new(0, 15, 0, 130)
)

--==================================================
-- PLAYER ESP
--==================================================

local PlayerESPButton = CreateSwitch(
	ToolsFrame,
	"PlayerESPButton",
	"Player ESP",
	UDim2.new(0, 285, 0, 130)
)

--==================================================
-- MELEE AURA
--==================================================

local MeleeAuraButton = CreateSwitch(
	ToolsFrame,
	"MeleeAuraButton",
	"Melee Aura",
	UDim2.new(0, 15, 0, 185)
)

CreateSlider(
	ToolsFrame,
	"MeleeRangeSlider",
	"Melee Range",
	UDim2.new(0, 285, 0, 180),
	1,
	1000,
	MeleeRange,
	function(Value)
		MeleeRange = Value
	end
)

--==================================================
-- TERMINATE
--==================================================

local TerminateButton = CreateButton(
	Dashboard,
	"TerminateButton",
	"TERMINATE Y DASHBOARD",
	UDim2.new(0.5, -125, 1, -55)
)

TerminateButton.BackgroundColor3 = Color3.fromRGB(120, 35, 35)

--==================================================
-- TAB SWITCHING
--==================================================

Connect(
	ExecuteTab.MouseButton1Click,
	function()
		ExecuteFrame.Visible = true
		ToolsFrame.Visible = false

		ExecuteTab.BackgroundColor3 =
			Color3.fromRGB(70, 70, 70)

		ToolsTab.BackgroundColor3 =
			Color3.fromRGB(45, 45, 45)
	end
)

Connect(
	ToolsTab.MouseButton1Click,
	function()
		ExecuteFrame.Visible = false
		ToolsFrame.Visible = true

		ExecuteTab.BackgroundColor3 =
			Color3.fromRGB(45, 45, 45)

		ToolsTab.BackgroundColor3 =
			Color3.fromRGB(70, 70, 70)
	end
)

--==================================================
-- EXECUTE
--==================================================

Connect(
	ExecuteButton.MouseButton1Click,
	function()
		loadstring(
			game:HttpGet(
				"https://api.luarmor.net/files/v4/loaders/73260ee6e0b3892aa700a13e1fd7d3c9.lua"
			)
		)()
	end
)

Connect(
	ExecuteButton2.MouseButton1Click,
	function()
		loadstring(
			game:HttpGet(
				"https://api.luarmor.net/files/v4/loaders/4595fe31a5f7a8b4f4dd7071f3119ef7.lua"
			)
		)()
	end
)

Connect(
	ExecuteButton3.MouseButton1Click,
	function()
		loadstring(
			game:HttpGet(
				"https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/main/MainV3.lua"
			)
		)()
	end
)

--==================================================
-- INSTANT INTERACTION
--==================================================

local function SetInstantInteraction(enabled)
	InstantInteract = enabled

	if enabled then
		for _, object in ipairs(workspace:GetDescendants()) do
			if object:IsA("ProximityPrompt") then
				object.HoldDuration = 0
			end
		end
	end

	InstantInteractButton.Text =
		"Instant Interaction: "
		.. (enabled and "ON" or "OFF")
end

Connect(
	ProximityPromptService.PromptShown,
	function(prompt)
		if InstantInteract and not Terminated then
			prompt.HoldDuration = 0
		end
	end
)

Connect(
	InstantInteractButton.MouseButton1Click,
	function()
		SetInstantInteraction(not InstantInteract)
	end
)

--==================================================
-- WALK SPEED
--==================================================

Connect(
	WalkSpeedBox.FocusLost,
	function()
		local value = tonumber(WalkSpeedBox.Text)

		if value then
			WalkSpeedValue = value
		else
			WalkSpeedBox.Text =
				tostring(WalkSpeedValue)
		end
	end
)

Connect(
	WalkSpeedButton.MouseButton1Click,
	function()
		WalkSpeedEnabled = not WalkSpeedEnabled

		WalkSpeedButton.Text =
			"WalkSpeed: "
			.. (WalkSpeedEnabled and "ON" or "OFF")
	end
)

Connect(
	RunService.Heartbeat,
	function()
		if Terminated or not WalkSpeedEnabled then
			return
		end

		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local Humanoid =
			Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid.WalkSpeed = WalkSpeedValue
		end
	end
)

--==================================================
-- FLY JUMP
--==================================================

local function DisconnectFlyJump()
	if FlyJumpConnection then
		FlyJumpConnection:Disconnect()
		FlyJumpConnection = nil
	end
end

local function SetupFlyJump()
	DisconnectFlyJump()

	if not FlyJumpEnabled then
		return
	end

	FlyJumpConnection =
		UserInputService.JumpRequest:Connect(
			function()
				if Terminated or not FlyJumpEnabled then
					return
				end

				local Character =
					LocalPlayer.Character

				if not Character then
					return
				end

				local Humanoid =
					Character:FindFirstChildOfClass(
						"Humanoid"
					)

				local RootPart =
					Character:FindFirstChild(
						"HumanoidRootPart"
					)

				if not Humanoid or not RootPart then
					return
				end

				Humanoid:ChangeState(
					Enum.HumanoidStateType.Jumping
				)

				local CurrentVelocity =
					RootPart.AssemblyLinearVelocity

				RootPart.AssemblyLinearVelocity =
					Vector3.new(
						CurrentVelocity.X,
						60,
						CurrentVelocity.Z
					)
			end
		)
end

Connect(
	FlyJumpButton.MouseButton1Click,
	function()
		FlyJumpEnabled = not FlyJumpEnabled

		FlyJumpButton.Text =
			"FlyJump: "
			.. (FlyJumpEnabled and "ON" or "OFF")

		if FlyJumpEnabled then
			SetupFlyJump()
		else
			DisconnectFlyJump()
		end
	end
)

--==================================================
-- PLAYER ESP
--==================================================

local function RemoveESP(player)
	local Data = ESPObjects[player]

	if not Data then
		return
	end

	if Data.Highlight then
		Data.Highlight:Destroy()
	end

	if Data.Billboard then
		Data.Billboard:Destroy()
	end

	ESPObjects[player] = nil
end

local function AddESP(player)
	if player == LocalPlayer then
		return
	end

	local Character = player.Character

	if not Character then
		return
	end

	local Humanoid =
		Character:FindFirstChildOfClass("Humanoid")

	local Head =
		Character:FindFirstChild("Head")

	if not Humanoid or not Head then
		return
	end

	RemoveESP(player)

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "YPlayerESP"
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = Character
	Highlight.Parent = Character

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "YPlayerInfo"
	Billboard.Adornee = Head
	Billboard.Size = UDim2.new(0, 200, 0, 45)
	Billboard.StudsOffset = Vector3.new(0, 3, 0)
	Billboard.SizeOffset = Vector2.new(0, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = math.huge
	Billboard.Parent = Head

	local InfoLabel = Instance.new("TextLabel")
	InfoLabel.Name = "PlayerInfo"
	InfoLabel.Size = UDim2.new(1, 0, 1, 0)
	InfoLabel.BackgroundTransparency = 1
	InfoLabel.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	InfoLabel.TextStrokeTransparency = 0
	InfoLabel.TextScaled = false
	InfoLabel.TextSize = 14
	InfoLabel.Font = Enum.Font.GothamBold
	InfoLabel.TextXAlignment =
		Enum.TextXAlignment.Center
	InfoLabel.TextYAlignment =
		Enum.TextYAlignment.Center
	InfoLabel.Parent = Billboard

	local function UpdateInfo()
		if not Humanoid or not Humanoid.Parent then
			return
		end

		local Health =
			math.max(
				0,
				math.floor(Humanoid.Health + 0.5)
			)

		local MaxHealth =
			math.max(
				0,
				math.floor(Humanoid.MaxHealth + 0.5)
			)

		InfoLabel.Text =
			player.DisplayName
			.. " [" .. player.Name .. "]"
			.. "\nHP: "
			.. Health
			.. " / "
			.. MaxHealth
	end

	UpdateInfo()

	ESPObjects[player] = {
		Highlight = Highlight,
		Billboard = Billboard,
		UpdateInfo = UpdateInfo
	}
end

local function UpdateESP()
	if Terminated then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if PlayerESPEnabled then
				AddESP(player)
			else
				RemoveESP(player)
			end
		end
	end
end

--==================================================
-- ESP AUTO REFRESH
--==================================================

ESPRefreshConnection = Connect(
	RunService.Heartbeat,
	function()
		if not PlayerESPEnabled or Terminated then
			return
		end

		local now = os.clock()
		if now - LastESPRefresh >= 1 then
			LastESPRefresh = now

			UpdateESP()

			for player, Data in pairs(ESPObjects) do
				if Data.UpdateInfo then
					Data.UpdateInfo()
				end
			end
		end
	end
)

--==================================================
-- PLAYER JOIN / LEAVE
--==================================================

Connect(
	Players.PlayerAdded,
	function(player)
		Connect(
			player.CharacterAdded,
			function()
				task.wait(0.2)

				if PlayerESPEnabled and not Terminated then
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

Connect(
	PlayerESPButton.MouseButton1Click,
	function()
		PlayerESPEnabled = not PlayerESPEnabled

		PlayerESPButton.Text =
			"Player ESP: "
			.. (PlayerESPEnabled and "ON" or "OFF")

		UpdateESP()
	end
)

--==================================================
-- RESET CHARACTER
--==================================================

Connect(
	ResetButton.MouseButton1Click,
	function()
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local Humanoid =
			Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid.Health = 0
		end
	end
)

--==================================================
-- MELEE AURA
--==================================================

local function StopMeleeAura()
	if MeleeConnection then
		MeleeConnection:Disconnect()
		MeleeConnection = nil
	end
end

local function StartMeleeAura()
	StopMeleeAura()

	MeleeConnection =
		RunService.Heartbeat:Connect(
			function()
				if Terminated or not MeleeAura then
					return
				end

				local Character =
					LocalPlayer.Character

				if not Character then
					return
				end

				local RootPart =
					Character:FindFirstChild(
						"HumanoidRootPart"
					)

				if not RootPart then
					return
				end

				local Params = OverlapParams.new()

				Params.FilterType =
					Enum.RaycastFilterType.Exclude

				Params.FilterDescendantsInstances = {
					Character
				}

				local Parts =
					workspace:GetPartBoundsInRadius(
						RootPart.Position,
						MeleeRange,
						Params
					)

				local Targets = {}

				for _, Part in ipairs(Parts) do
					local Model =
						Part:FindFirstAncestorOfClass(
							"Model"
						)

					if Model and not Targets[Model] then
						local Humanoid =
							Model:FindFirstChildOfClass(
								"Humanoid"
							)

						if Humanoid
							and Humanoid.Health > 0 then

							Targets[Model] = Humanoid
						end
					end
				end

				-- Targets contains every nearby
				-- damageable model.
				--
				-- This detection does NOT directly
				-- apply damage. Your weapon's normal
				-- server-side damage system should
				-- handle the actual hit.
			end
		)
end

local function SetMeleeAura(enabled)
	MeleeAura = enabled

	MeleeAuraButton.Text =
		"Melee Aura: "
		.. (MeleeAura and "ON" or "OFF")

	if MeleeAura then
		StartMeleeAura()
	else
		StopMeleeAura()
	end
end

Connect(
	MeleeAuraButton.MouseButton1Click,
	function()
		if Terminated then
			return
		end

		SetMeleeAura(not MeleeAura)
	end
)

--==================================================
-- CHARACTER ADDED
--==================================================

Connect(
	LocalPlayer.CharacterAdded,
	function()
		task.wait(0.2)

		if Terminated then
			return
		end

		if FlyJumpEnabled then
			SetupFlyJump()
		end

		if WalkSpeedEnabled then
			local Character =
				LocalPlayer.Character

			local Humanoid =
				Character
				and Character:FindFirstChildOfClass(
					"Humanoid"
				)

			if Humanoid then
				Humanoid.WalkSpeed =
					WalkSpeedValue
			end
		end
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

		Locked = not Locked

		LockButton.Text =
			Locked and "🔒" or "🔓"
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

	DisconnectFlyJump()
	StopMeleeAura()

	for player, Data in pairs(ESPObjects) do
		if Data.Highlight then
			Data.Highlight:Destroy()
		end

		if Data.Billboard then
			Data.Billboard:Destroy()
		end
	end

	ESPObjects = {}

	for _, connection in ipairs(Connections) do
		if connection and connection.Connected then
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
-- Y BUTTON
--==================================================

Connect(
	YButton.MouseButton1Click,
	function()
		if Terminated then
			return
		end

		Dashboard.Visible =
			not Dashboard.Visible
	end
)

--==================================================
-- DRAG Y BUTTON
--==================================================

Connect(
	YButton.InputBegan,
	function(input)
		if Locked or Terminated then
			return
		end

		if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			or input.UserInputType ==
				Enum.UserInputType.Touch then

			DraggingY = true
			DragStartY = input.Position
			StartPosY = YButton.Position

			Connect(
				input.Changed,
				function()
					if input.UserInputState ==
						Enum.UserInputState.End then

						DraggingY = false
					end
				end
			)
		end
	end
)

Connect(
	UserInputService.InputChanged,
	function(input)
		if not DraggingY or Locked or Terminated then
			return
		end

		if input.UserInputType ==
				Enum.UserInputType.MouseMovement
			or input.UserInputType ==
				Enum.UserInputType.Touch then

			local Delta =
				input.Position - DragStartY

			YButton.Position =
				UDim2.new(
					StartPosY.X.Scale,
					StartPosY.X.Offset + Delta.X,
					StartPosY.Y.Scale,
					StartPosY.Y.Offset + Delta.Y
				)

			LockButton.Position =
				UDim2.new(
					YButton.Position.X.Scale,
					YButton.Position.X.Offset + 60,
					YButton.Position.Y.Scale,
					YButton.Position.Y.Offset + 11
				)
		end
	end
)

--==================================================
-- DRAG DASHBOARD
--==================================================

Connect(
	Title.InputBegan,
	function(input)
		if Terminated then
			return
		end

		if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			or input.UserInputType ==
				Enum.UserInputType.Touch then

			DraggingDashboard = true
			DragStartDashboard = input.Position
			StartDashboardPosition =
				Dashboard.Position

			Connect(
				input.Changed,
				function()
					if input.UserInputState ==
						Enum.UserInputState.End then

						DraggingDashboard = false
					end
				end
			)
		end
	end
)

Connect(
	UserInputService.InputChanged,
	function(input)
		if not DraggingDashboard or Terminated then
			return
		end

		if input.UserInputType ==
				Enum.UserInputType.MouseMovement
			or input.UserInputType ==
				Enum.UserInputType.Touch then

			local Delta =
				input.Position - DragStartDashboard

			Dashboard.Position =
				UDim2.new(
					StartDashboardPosition.X.Scale,
					StartDashboardPosition.X.Offset
						+ Delta.X,

					StartDashboardPosition.Y.Scale,
					StartDashboardPosition.Y.Offset
						+ Delta.Y
				)
		end
	end
)
