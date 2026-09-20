--// Y Dashboard - UI Only

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

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
YButton.Position = UDim2.new(0, 20, 0.5, -27)
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
LockButton.Position = UDim2.new(0, 80, 0.5, -16)
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
Dashboard.Size = UDim2.new(0, 600, 0, 400)
Dashboard.Position = UDim2.new(0.5, -300, 0.5, -200)
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
Title.Text = "Y Dashboard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Dashboard

--==================================================
-- CHARACTER TAB
--==================================================

local CharacterTab = Instance.new("TextButton")
CharacterTab.Name = "CharacterTab"
CharacterTab.Size = UDim2.new(0, 140, 0, 40)
CharacterTab.Position = UDim2.new(0, 15, 0, 60)
CharacterTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
CharacterTab.Text = "CHARACTER"
CharacterTab.TextColor3 = Color3.fromRGB(255, 255, 255)
CharacterTab.TextSize = 14
CharacterTab.Font = Enum.Font.GothamBold
CharacterTab.Parent = Dashboard

local CharacterCorner = Instance.new("UICorner")
CharacterCorner.CornerRadius = UDim.new(0, 8)
CharacterCorner.Parent = CharacterTab

--==================================================
-- INSTANT INTERACT
--==================================================

local ProximityPromptService = game:GetService("ProximityPromptService")

local InstantInteractButton = Instance.new("TextButton")
InstantInteractButton.Name = "InstantInteract"
InstantInteractButton.Size = UDim2.new(0, 250, 0, 45)
InstantInteractButton.Position = UDim2.new(0, 20, 0, 120)
InstantInteractButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InstantInteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantInteractButton.TextSize = 15
InstantInteractButton.Font = Enum.Font.Gotham
InstantInteractButton.Text = "Instant Interact: ON"
InstantInteractButton.Parent = Dashboard

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = InstantInteractButton

local InstantInteract = true

local function UpdatePrompts()
	for _, object in ipairs(workspace:GetDescendants()) do
		if object:IsA("ProximityPrompt") then
			object.HoldDuration = InstantInteract and 0 or object.HoldDuration
		end
	end
end

UpdatePrompts()

ProximityPromptService.PromptShown:Connect(function(prompt)
	if InstantInteract then
		prompt.HoldDuration = 0
	end
end)

InstantInteractButton.MouseButton1Click:Connect(function()
	InstantInteract = not InstantInteract

	InstantInteractButton.Text =
		"Instant Interact: " .. (InstantInteract and "ON" or "OFF")

	if InstantInteract then
		UpdatePrompts()
	end
end)
--==================================================
-- DRAG Y BUTTON
--==================================================

local Locked = false
local DraggingY = false
local DragStartY
local StartPosY

YButton.MouseButton1Click:Connect(function()
	Dashboard.Visible = not Dashboard.Visible
end)

LockButton.MouseButton1Click:Connect(function()
	Locked = not Locked
	LockButton.Text = Locked and "🔒" or "🔓"
end)

YButton.InputBegan:Connect(function(input)
	if Locked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		DraggingY = true
		DragStartY = input.Position
		StartPosY = YButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				DraggingY = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not DraggingY or Locked then
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
end)

--==================================================
-- DRAG DASHBOARD
--==================================================

local DraggingDashboard = false
local DragStartDashboard
local StartDashboardPosition

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		DraggingDashboard = true
		DragStartDashboard = input.Position
		StartDashboardPosition = Dashboard.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				DraggingDashboard = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not DraggingDashboard then
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
end)
