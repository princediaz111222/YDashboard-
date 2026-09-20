--// Y Dashboard - Activity & Movement Monitor
--// Maximum: 100 entries per log
--// Logging is OFF by default

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local MAX_LOGS = 100

local ActivityEnabled = false
local MovementEnabled = false

local ActivityLogs = {}
local MovementLogs = {}

local SelectedActivityLog = ""
local SelectedMovementLog = ""

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
Dashboard.Size = UDim2.new(0, 700, 0, 450)
Dashboard.Position = UDim2.new(0.5, -350, 0.5, -225)
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
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "Y Dashboard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.Parent = Dashboard

--==================================================
-- TABS
--==================================================

local ActivityTab = Instance.new("TextButton")
ActivityTab.Size = UDim2.new(0, 150, 0, 32)
ActivityTab.Position = UDim2.new(0, 20, 0, 48)
ActivityTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ActivityTab.Text = "ACTIVITY"
ActivityTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityTab.TextSize = 12
ActivityTab.Font = Enum.Font.GothamBold
ActivityTab.Parent = Dashboard

local ActivityCorner = Instance.new("UICorner")
ActivityCorner.CornerRadius = UDim.new(0, 6)
ActivityCorner.Parent = ActivityTab

local MovementTab = Instance.new("TextButton")
MovementTab.Size = UDim2.new(0, 150, 0, 32)
MovementTab.Position = UDim2.new(0, 180, 0, 48)
MovementTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MovementTab.Text = "MOVEMENT"
MovementTab.TextColor3 = Color3.fromRGB(200, 200, 200)
MovementTab.TextSize = 12
MovementTab.Font = Enum.Font.GothamBold
MovementTab.Parent = Dashboard

local MovementCorner = Instance.new("UICorner")
MovementCorner.CornerRadius = UDim.new(0, 6)
MovementCorner.Parent = MovementTab

--==================================================
-- ACTIVITY PAGE
--==================================================

local ActivityPage = Instance.new("Frame")
ActivityPage.Size = UDim2.new(1, -40, 1, -95)
ActivityPage.Position = UDim2.new(0, 20, 0, 90)
ActivityPage.BackgroundTransparency = 1
ActivityPage.Parent = Dashboard

--==================================================
-- ACTIVITY ON/OFF
--==================================================

local ActivityToggle = Instance.new("TextButton")
ActivityToggle.Size = UDim2.new(0, 120, 0, 30)
ActivityToggle.Position = UDim2.new(0, 0, 0, 0)
ActivityToggle.BackgroundColor3 = Color3.fromRGB(75, 45, 45)
ActivityToggle.Text = "ACTIVITY: OFF"
ActivityToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityToggle.TextSize = 11
ActivityToggle.Font = Enum.Font.GothamBold
ActivityToggle.Parent = ActivityPage

local ActivityToggleCorner = Instance.new("UICorner")
ActivityToggleCorner.CornerRadius = UDim.new(0, 6)
ActivityToggleCorner.Parent = ActivityToggle

--==================================================
-- ACTIVITY LIST
--==================================================

local ActivityList = Instance.new("ScrollingFrame")
ActivityList.Size = UDim2.new(0, 315, 0, 300)
ActivityList.Position = UDim2.new(0, 0, 0, 40)
ActivityList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ActivityList.BorderSizePixel = 0
ActivityList.ScrollBarThickness = 5
ActivityList.CanvasSize = UDim2.new(0, 0, 0, 0)
ActivityList.Parent = ActivityPage

local ActivityListCorner = Instance.new("UICorner")
ActivityListCorner.CornerRadius = UDim.new(0, 8)
ActivityListCorner.Parent = ActivityList

local ActivityLayout = Instance.new("UIListLayout")
ActivityLayout.Padding = UDim.new(0, 3)
ActivityLayout.Parent = ActivityList

--==================================================
-- ACTIVITY INFO
--==================================================

local ActivityInfo = Instance.new("TextBox")
ActivityInfo.Size = UDim2.new(0, 325, 0, 300)
ActivityInfo.Position = UDim2.new(0, 325, 0, 0)
ActivityInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ActivityInfo.TextColor3 = Color3.fromRGB(230, 230, 230)
ActivityInfo.PlaceholderText = "Select an activity."
ActivityInfo.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
ActivityInfo.Text = ""
ActivityInfo.TextSize = 12
ActivityInfo.Font = Enum.Font.Code
ActivityInfo.TextXAlignment = Enum.TextXAlignment.Left
ActivityInfo.TextYAlignment = Enum.TextYAlignment.Top
ActivityInfo.MultiLine = true
ActivityInfo.ClearTextOnFocus = false
ActivityInfo.TextEditable = false
ActivityInfo.Parent = ActivityPage

local ActivityInfoCorner = Instance.new("UICorner")
ActivityInfoCorner.CornerRadius = UDim.new(0, 8)
ActivityInfoCorner.Parent = ActivityInfo

--==================================================
-- ACTIVITY COPY
--==================================================

local ActivityCopy = Instance.new("TextButton")
ActivityCopy.Size = UDim2.new(0, 155, 0, 35)
ActivityCopy.Position = UDim2.new(0, 325, 0, 310)
ActivityCopy.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ActivityCopy.Text = "COPY LOG"
ActivityCopy.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityCopy.TextSize = 11
ActivityCopy.Font = Enum.Font.GothamBold
ActivityCopy.Parent = ActivityPage

local ActivityClear = Instance.new("TextButton")
ActivityClear.Size = UDim2.new(0, 155, 0, 35)
ActivityClear.Position = UDim2.new(0, 490, 0, 310)
ActivityClear.BackgroundColor3 = Color3.fromRGB(65, 40, 40)
ActivityClear.Text = "CLEAR"
ActivityClear.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivityClear.TextSize = 11
ActivityClear.Font = Enum.Font.GothamBold
ActivityClear.Parent = ActivityPage

--==================================================
-- MOVEMENT PAGE
--==================================================

local MovementPage = Instance.new("Frame")
MovementPage.Size = UDim2.new(1, -40, 1, -95)
MovementPage.Position = UDim2.new(0, 20, 0, 90)
MovementPage.BackgroundTransparency = 1
MovementPage.Visible = false
MovementPage.Parent = Dashboard

--==================================================
-- MOVEMENT ON/OFF
--==================================================

local MovementToggle = Instance.new("TextButton")
MovementToggle.Size = UDim2.new(0, 120, 0, 30)
MovementToggle.Position = UDim2.new(0, 0, 0, 0)
MovementToggle.BackgroundColor3 = Color3.fromRGB(75, 45, 45)
MovementToggle.Text = "MOVEMENT: OFF"
MovementToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementToggle.TextSize = 11
MovementToggle.Font = Enum.Font.GothamBold
MovementToggle.Parent = MovementPage

local MovementToggleCorner = Instance.new("UICorner")
MovementToggleCorner.CornerRadius = UDim.new(0, 6)
MovementToggleCorner.Parent = MovementToggle

--==================================================
-- MOVEMENT LIST
--==================================================

local MovementList = Instance.new("ScrollingFrame")
MovementList.Size = UDim2.new(0, 315, 0, 300)
MovementList.Position = UDim2.new(0, 0, 0, 40)
MovementList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MovementList.BorderSizePixel = 0
MovementList.ScrollBarThickness = 5
MovementList.CanvasSize = UDim2.new(0, 0, 0, 0)
MovementList.Parent = MovementPage

local MovementListCorner = Instance.new("UICorner")
MovementListCorner.CornerRadius = UDim.new(0, 8)
MovementListCorner.Parent = MovementList

local MovementLayout = Instance.new("UIListLayout")
MovementLayout.Padding = UDim.new(0, 3)
MovementLayout.Parent = MovementList

--==================================================
-- MOVEMENT INFO
--==================================================

local MovementInfo = Instance.new("TextBox")
MovementInfo.Size = UDim2.new(0, 325, 0, 300)
MovementInfo.Position = UDim2.new(0, 325, 0, 0)
MovementInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MovementInfo.TextColor3 = Color3.fromRGB(230, 230, 230)
MovementInfo.PlaceholderText = "Select a movement event."
MovementInfo.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
MovementInfo.Text = ""
MovementInfo.TextSize = 12
MovementInfo.Font = Enum.Font.Code
MovementInfo.TextXAlignment = Enum.TextXAlignment.Left
MovementInfo.TextYAlignment = Enum.TextYAlignment.Top
MovementInfo.MultiLine = true
MovementInfo.ClearTextOnFocus = false
MovementInfo.TextEditable = false
MovementInfo.Parent = MovementPage

local MovementInfoCorner = Instance.new("UICorner")
MovementInfoCorner.CornerRadius = UDim.new(0, 8)
MovementInfoCorner.Parent = MovementInfo

--==================================================
-- MOVEMENT COPY / CLEAR
--==================================================

local MovementCopy = Instance.new("TextButton")
MovementCopy.Size = UDim2.new(0, 155, 0, 35)
MovementCopy.Position = UDim2.new(0, 325, 0, 310)
MovementCopy.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
MovementCopy.Text = "COPY LOG"
MovementCopy.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementCopy.TextSize = 11
MovementCopy.Font = Enum.Font.GothamBold
MovementCopy.Parent = MovementPage

local MovementClear = Instance.new("TextButton")
MovementClear.Size = UDim2.new(0, 155, 0, 35)
MovementClear.Position = UDim2.new(0, 490, 0, 310)
MovementClear.BackgroundColor3 = Color3.fromRGB(65, 40, 40)
MovementClear.Text = "CLEAR"
MovementClear.TextColor3 = Color3.fromRGB(255, 255, 255)
MovementClear.TextSize = 11
MovementClear.Font = Enum.Font.GothamBold
MovementClear.Parent = MovementPage

--==================================================
-- REBUILD LIST
--==================================================

local function RebuildActivityList()

	for _, Child in ipairs(ActivityList:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	for _, Entry in ipairs(ActivityLogs) do

		local Button = Instance.new("TextButton")

		Button.Size =
			UDim2.new(1, -10, 0, 32)

		Button.BackgroundColor3 =
			Color3.fromRGB(40, 40, 40)

		Button.TextColor3 =
			Color3.fromRGB(235, 235, 235)

		Button.TextSize = 10
		Button.Font = Enum.Font.Code
		Button.TextXAlignment =
			Enum.TextXAlignment.Left

		Button.TextTruncate =
			Enum.TextTruncate.AtEnd

		Button.Text =
			"  " .. Entry.Short

		Button.Parent = ActivityList

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Button

		Button.MouseButton1Click:Connect(
			function()

				SelectedActivityLog =
					Entry.Full

				ActivityInfo.Text =
					Entry.Full

			end
		)

	end

	ActivityList.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			ActivityLayout.AbsoluteContentSize.Y + 5
		)

end

local function RebuildMovementList()

	for _, Child in ipairs(MovementList:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	for _, Entry in ipairs(MovementLogs) do

		local Button = Instance.new("TextButton")

		Button.Size =
			UDim2.new(1, -10, 0, 32)

		Button.BackgroundColor3 =
			Color3.fromRGB(40, 40, 40)

		Button.TextColor3 =
			Color3.fromRGB(235, 235, 235)

		Button.TextSize = 10
		Button.Font = Enum.Font.Code
		Button.TextXAlignment =
			Enum.TextXAlignment.Left

		Button.TextTruncate =
			Enum.TextTruncate.AtEnd

		Button.Text =
			"  " .. Entry.Short

		Button.Parent = MovementList

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Button

		Button.MouseButton1Click:Connect(
			function()

				SelectedMovementLog =
					Entry.Full

				MovementInfo.Text =
					Entry.Full

			end
		)

	end

	MovementList.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			MovementLayout.AbsoluteContentSize.Y + 5
		)

end

--==================================================
-- ADD ACTIVITY
--==================================================

local function LogActivity(EventType, Object, Details)

	if not ActivityEnabled then
		return
	end

	local Name = "N/A"
	local Class = "N/A"
	local Path = "N/A"

	if Object then

		Name = Object.Name
		Class = Object.ClassName

		local Success, Result =
			pcall(function()
				return Object:GetFullName()
			end)

		if Success then
			Path = Result
		end

	end

	local Log = table.concat({
		"================================",
		"ACTIVITY EVENT",
		"================================",
		"",
		"TIME",
		os.date("%H:%M:%S"),
		"",
		"EVENT",
		EventType,
		"",
		"NAME",
		Name,
		"",
		"CLASS",
		Class,
		"",
		"PATH",
		Path,
		"",
		"DETAILS",
		Details or "(none)"
	}, "\n")

	table.insert(ActivityLogs, 1, {
		Short =
			EventType ..
			" • " ..
			Name,

		Full = Log
	})

	-- Keep newest 100

	if #ActivityLogs > MAX_LOGS then
		table.remove(ActivityLogs)
	end

	RebuildActivityList()

end

--==================================================
-- ADD MOVEMENT
--==================================================

local LastMovementEvent = nil

local function LogMovement(State)

	if not MovementEnabled then
		return
	end

	if LastMovementEvent == State then
		return
	end

	LastMovementEvent = State

	local Character =
		LocalPlayer.Character

	local Humanoid =
		Character and
		Character:FindFirstChildOfClass(
			"Humanoid"
		)

	local Root =
		Character and
		Character:FindFirstChild(
			"HumanoidRootPart"
		)

	local Path = "N/A"

	if Root then
		Path = Root:GetFullName()
	end

	local Speed = 0

	if Humanoid then
		Speed = Humanoid.WalkSpeed
	end

	local Log = table.concat({
		"================================",
		"MOVEMENT EVENT",
		"================================",
		"",
		"TIME",
		os.date("%H:%M:%S"),
		"",
		"EVENT",
		State,
		"",
		"CHARACTER",
		Character and Character.Name or "N/A",
		"",
		"ROOT PATH",
		Path,
		"",
		"WALK SPEED",
		tostring(Speed)
	}, "\n")

	table.insert(MovementLogs, 1, {
		Short = State,
		Full = Log
	})

	if #MovementLogs > MAX_LOGS then
		table.remove(MovementLogs)
	end

	RebuildMovementList()

end

--==================================================
-- ACTIVITY TOGGLE
--==================================================

ActivityToggle.MouseButton1Click:Connect(
	function()

		ActivityEnabled =
			not ActivityEnabled

		if ActivityEnabled then

			ActivityToggle.Text =
				"ACTIVITY: ON"

			ActivityToggle.BackgroundColor3 =
				Color3.fromRGB(40, 90, 55)

		else

			ActivityToggle.Text =
				"ACTIVITY: OFF"

			ActivityToggle.BackgroundColor3 =
				Color3.fromRGB(75, 45, 45)

		end

	end
)

--==================================================
-- MOVEMENT TOGGLE
--==================================================

MovementToggle.MouseButton1Click:Connect(
	function()

		MovementEnabled =
			not MovementEnabled

		if MovementEnabled then

			MovementToggle.Text =
				"MOVEMENT: ON"

			MovementToggle.BackgroundColor3 =
				Color3.fromRGB(40, 90, 55)

		else

			MovementToggle.Text =
				"MOVEMENT: OFF"

			MovementToggle.BackgroundColor3 =
				Color3.fromRGB(75, 45, 45)

		end

	end
)

--==================================================
-- CHARACTER MONITOR
--==================================================

local function MonitorCharacter(Character)

	local Humanoid =
		Character:WaitForChild("Humanoid")

	Character.ChildAdded:Connect(
		function(Child)

			if Child:IsA("Tool") then

				LogActivity(
					"TOOL EQUIPPED",
					Child,
					"Tool appeared inside the character."
				)

			end

		end
	)

	Character.ChildRemoved:Connect(
		function(Child)

			if Child:IsA("Tool") then

				LogActivity(
					"TOOL UNEQUIPPED",
					Child,
					"Tool was removed from the character."
				)

			end

		end
	)

	Humanoid.StateChanged:Connect(
		function(_, NewState)

			if NewState ==
				Enum.HumanoidStateType.Jumping then

				LogMovement("JUMPING")

			elseif NewState ==
				Enum.HumanoidStateType.Freefall then

				LogMovement("FALLING")

			elseif NewState ==
				Enum.HumanoidStateType.Landed then

				LogMovement("LANDED")

			elseif NewState ==
				Enum.HumanoidStateType.Climbing then

				LogMovement("CLIMBING")

			elseif NewState ==
				Enum.HumanoidStateType.Swimming then

				LogMovement("SWIMMING")

			elseif NewState ==
				Enum.HumanoidStateType.Running then

				LogMovement("RUNNING")

			elseif NewState ==
				Enum.HumanoidStateType.Seated then

				LogMovement("SEATED")

			end

		end
	)

end

if LocalPlayer.Character then
	MonitorCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(
	function(Character)

		LastMovementEvent = nil

		MonitorCharacter(Character)

	end
)

--==================================================
-- COPY ACTIVITY
--==================================================

ActivityCopy.MouseButton1Click:Connect(
	function()

		if SelectedActivityLog == "" then
			return
		end

		if setclipboard then

			setclipboard(
				SelectedActivityLog
			)

			ActivityCopy.Text =
				"COPIED!"

			task.delay(
				1,
				function()
					ActivityCopy.Text =
						"COPY LOG"
				end
			)

		end

	end
)

--==================================================
-- COPY MOVEMENT
--==================================================

MovementCopy.MouseButton1Click:Connect(
	function()

		if SelectedMovementLog == "" then
			return
		end

		if setclipboard then

			setclipboard(
				SelectedMovementLog
			)

			MovementCopy.Text =
				"COPIED!"

			task.delay(
				1,
				function()
					MovementCopy.Text =
						"COPY LOG"
				end
			)

		end

	end
)

--==================================================
-- CLEAR ACTIVITY
--==================================================

ActivityClear.MouseButton1Click:Connect(
	function()

		ActivityLogs = {}
		SelectedActivityLog = ""
		ActivityInfo.Text = ""

		RebuildActivityList()

	end
)

--==================================================
-- CLEAR MOVEMENT
--==================================================

MovementClear.MouseButton1Click:Connect(
	function()

		MovementLogs = {}
		SelectedMovementLog = ""
		MovementInfo.Text = ""

		RebuildMovementList()

	end
)

--==================================================
-- TAB SWITCHING
--==================================================

ActivityTab.MouseButton1Click:Connect(
	function()

		ActivityPage.Visible = true
		MovementPage.Visible = false

		ActivityTab.BackgroundColor3 =
			Color3.fromRGB(60, 60, 60)

		MovementTab.BackgroundColor3 =
			Color3.fromRGB(40, 40, 40)

	end
)

MovementTab.MouseButton1Click:Connect(
	function()

		ActivityPage.Visible = false
		MovementPage.Visible = true

		ActivityTab.BackgroundColor3 =
			Color3.fromRGB(40, 40, 40)

		MovementTab.BackgroundColor3 =
			Color3.fromRGB(60, 60, 60)

	end
)

--==================================================
-- LOCK
--==================================================

local Locked = false

LockButton.MouseButton1Click:Connect(
	function()

		Locked = not Locked

		LockButton.Text =
			Locked and "🔒" or "🔓"

	end
)

--==================================================
-- TOGGLE DASHBOARD
--==================================================

YButton.MouseButton1Click:Connect(
	function()

		Dashboard.Visible =
			not Dashboard.Visible

	end
)

--==================================================
-- DRAG Y BUTTON
--==================================================

local DraggingY = false
local DragStartY
local StartPosY

YButton.InputBegan:Connect(
	function(Input)

		if Locked then
			return
		end

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or Input.UserInputType ==
			Enum.UserInputType.Touch then

			DraggingY = true
			DragStartY = Input.Position
			StartPosY = YButton.Position

			Input.Changed:Connect(
				function()

					if Input.UserInputState ==
						Enum.UserInputState.End then

						DraggingY = false

					end

				end
			)

		end

	end
)

--==================================================
-- DRAG DASHBOARD
--==================================================

local DraggingDashboard = false
local DragStartDashboard
local StartDashboardPosition

Title.InputBegan:Connect(
	function(Input)

		if Locked then
			return
		end

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or Input.UserInputType ==
			Enum.UserInputType.Touch then

			DraggingDashboard = true
			DragStartDashboard = Input.Position
			StartDashboardPosition =
				Dashboard.Position

			Input.Changed:Connect(
				function()

					if Input.UserInputState ==
						Enum.UserInputState.End then

						DraggingDashboard = false

					end

				end
			)

		end

	end
)

--==================================================
-- INPUT MOVEMENT
--==================================================

UserInputService.InputChanged:Connect(
	function(Input)

		if DraggingY and not Locked then

			if Input.UserInputType ==
				Enum.UserInputType.MouseMovement
				or Input.UserInputType ==
				Enum.UserInputType.Touch then

				local Delta =
					Input.Position - DragStartY

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

		if DraggingDashboard and not Locked then

			if Input.UserInputType ==
				Enum.UserInputType.MouseMovement
				or Input.UserInputType ==
				Enum.UserInputType.Touch then

				local Delta =
					Input.Position -
					DragStartDashboard

				Dashboard.Position =
					UDim2.new(
						StartDashboardPosition.X.Scale,
						StartDashboardPosition.X.Offset + Delta.X,
						StartDashboardPosition.Y.Scale,
						StartDashboardPosition.Y.Offset + Delta.Y
					)

			end

		end

	end
)
