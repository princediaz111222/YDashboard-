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

local Locked = false
local Terminated = false

local InstantInteract = false
local WalkSpeedEnabled = false
local FlyJumpEnabled = false
local PlayerESPEnabled = false

local WalkSpeedValue = 16

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
Title.Text = "Lennonhub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Dashboard

--==================================================
-- BUTTON FACTORIES
--==================================================

local function CreateButton(name, text, position)
	local Button = Instance.new("TextButton")
	Button.Name = name
	Button.Size = UDim2.new(0, 250, 0, 42)
	Button.Position = position
	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 14
	Button.Font = Enum.Font.GothamBold
	Button.Text = text
	Button.Parent = Dashboard

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	return Button
end

local function CreateSwitch(name, text, position)
	return CreateButton(
		name,
		text .. ": OFF",
		position
	)
end

--==================================================
-- EXECUTE
--==================================================

local ExecuteButton = CreateButton(
	"ExecuteButton",
	"Execute lennonhubV3",
	UDim2.new(0, 20, 0, 70)
)

--==================================================
-- INSTANT INTERACTION
--==================================================

local InstantInteractButton = CreateSwitch(
	"InstantInteractButton",
	"Instant Interaction",
	UDim2.new(0, 20, 0, 120)
)

--==================================================
-- RESET CHARACTER
--==================================================

local ResetButton = CreateButton(
	"ResetButton",
	"Reset Character",
	UDim2.new(0, 290, 0, 120)
)

--==================================================
-- WALK SPEED
--==================================================

local WalkSpeedButton = CreateSwitch(
	"WalkSpeedButton",
	"WalkSpeed",
	UDim2.new(0, 20, 0, 170)
)

local WalkSpeedBox = Instance.new("TextBox")
WalkSpeedBox.Name = "WalkSpeedBox"
WalkSpeedBox.Size = UDim2.new(0, 250, 0, 42)
WalkSpeedBox.Position = UDim2.new(0, 290, 0, 170)
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WalkSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
WalkSpeedBox.TextSize = 14
WalkSpeedBox.Font = Enum.Font.GothamBold
WalkSpeedBox.PlaceholderText = "WalkSpeed"
WalkSpeedBox.Text = "16"
WalkSpeedBox.ClearTextOnFocus = false
WalkSpeedBox.Parent = Dashboard

local WalkSpeedCorner = Instance.new("UICorner")
WalkSpeedCorner.CornerRadius = UDim.new(0, 8)
WalkSpeedCorner.Parent = WalkSpeedBox

--==================================================
-- FLY JUMP
--==================================================

local FlyJumpButton = CreateSwitch(
	"FlyJumpButton",
	"FlyJump",
	UDim2.new(0, 20, 0, 220)
)

--==================================================
-- PLAYER ESP
--==================================================

local PlayerESPButton = CreateSwitch(
	"PlayerESPButton",
	"Player ESP",
	UDim2.new(0, 290, 0, 220)
)

--==================================================
-- TERMINATE
--==================================================

local TerminateButton = CreateButton(
	"TerminateButton",
	"TERMINATE Y DASHBOARD",
	UDim2.new(0.5, -125, 1, -55)
)

TerminateButton.BackgroundColor3 = Color3.fromRGB(120, 35, 35)

--==================================================
-- EXECUTE
--==================================================

Connect(
	ExecuteButton.MouseButton1Click,
	function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/73260ee6e0b3892aa700a13e1fd7d3c9.lua"))()

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
		"Instant Interaction: " .. (enabled and "ON" or "OFF")
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
			WalkSpeedBox.Text = tostring(WalkSpeedValue)
		end
	end
)

Connect(
	WalkSpeedButton.MouseButton1Click,
	function()
		WalkSpeedEnabled = not WalkSpeedEnabled

		WalkSpeedButton.Text =
			"WalkSpeed: " .. (WalkSpeedEnabled and "ON" or "OFF")
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

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

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

	-- JumpRequest fires when the normal Roblox jump button
	-- is pressed/held, including mobile.
	FlyJumpConnection = UserInputService.JumpRequest:Connect(
		function()
			if Terminated or not FlyJumpEnabled then
				return
			end

			local Character = LocalPlayer.Character

			if not Character then
				return
			end

			local Humanoid =
				Character:FindFirstChildOfClass("Humanoid")

			local RootPart =
				Character:FindFirstChild("HumanoidRootPart")

			if not Humanoid or not RootPart then
				return
			end

			-- Keep the character airborne while Jump is requested.
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

			local CurrentVelocity =
				RootPart.AssemblyLinearVelocity

			RootPart.AssemblyLinearVelocity = Vector3.new(
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
			"FlyJump: " .. (FlyJumpEnabled and "ON" or "OFF")

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

	--==================================================
	-- HIGHLIGHT
	--==================================================

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "YPlayerESP"
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = Character
	Highlight.Parent = Character

	--==================================================
	-- NAME + HP BILLBOARD
	--==================================================

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "YPlayerInfo"
	Billboard.Adornee = Head
	Billboard.Size = UDim2.new(0, 200, 0, 45)

	-- Offset above the player's head.
	Billboard.StudsOffset = Vector3.new(0, 3, 0)

	-- Prevents the billboard from scaling with distance.
	Billboard.SizeOffset = Vector2.new(0, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = math.huge
	Billboard.Parent = Head

	local InfoLabel = Instance.new("TextLabel")
	InfoLabel.Name = "PlayerInfo"
	InfoLabel.Size = UDim2.new(1, 0, 1, 0)
	InfoLabel.BackgroundTransparency = 1
	InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	InfoLabel.TextStrokeTransparency = 0
	InfoLabel.TextScaled = false
	InfoLabel.TextSize = 14
	InfoLabel.Font = Enum.Font.GothamBold
	InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
	InfoLabel.TextYAlignment = Enum.TextYAlignment.Center
	InfoLabel.Parent = Billboard

	local function UpdateInfo()
		if not Humanoid or not Humanoid.Parent then
			return
		end

		local Health = math.max(0, math.floor(Humanoid.Health + 0.5))
		local MaxHealth = math.max(0, math.floor(Humanoid.MaxHealth + 0.5))

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

		-- Refresh every 1 second.
		if not ESPRefreshConnection.LastRefresh
			or os.clock() - ESPRefreshConnection.LastRefresh >= 1 then

			ESPRefreshConnection.LastRefresh = os.clock()

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
			local Character = LocalPlayer.Character

			local Humanoid =
				Character
				and Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				Humanoid.WalkSpeed = WalkSpeedValue
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
		LockButton.Text = Locked and "🔒" or "🔓"
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

		Dashboard.Visible = not Dashboard.Visible
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

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			DraggingY = true
			DragStartY = input.Position
			StartPosY = YButton.Position

			Connect(
				input.Changed,
				function()
					if input.UserInputState == Enum.UserInputState.End then
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

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local Delta = input.Position - DragStartY

			YButton.Position = UDim2.new(
				StartPosY.X.Scale,
				StartPosY.X.Offset + Delta.X,
				StartPosY.Y.Scale,
				StartPosY.Y.Offset + Delta.Y
			)

			LockButton.Position = UDim2.new(
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

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			DraggingDashboard = true
			DragStartDashboard = input.Position
			StartDashboardPosition = Dashboard.Position

			Connect(
				input.Changed,
				function()
					if input.UserInputState == Enum.UserInputState.End then
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

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local Delta = input.Position - DragStartDashboard

			Dashboard.Position = UDim2.new(
				StartDashboardPosition.X.Scale,
				StartDashboardPosition.X.Offset + Delta.X,
				StartDashboardPosition.Y.Scale,
				StartDashboardPosition.Y.Offset + Delta.Y
			)
		end
	end
)
