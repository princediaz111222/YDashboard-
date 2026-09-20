--// Y Dashboard - Pet Inspector

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
-- PET SEARCH
--==================================================

local PetSearch = Instance.new("TextBox")
PetSearch.Name = "PetSearch"
PetSearch.Size = UDim2.new(0, 250, 0, 38)
PetSearch.Position = UDim2.new(0, 20, 0, 70)
PetSearch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PetSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
PetSearch.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
PetSearch.PlaceholderText = "Search pet/object..."
PetSearch.Text = ""
PetSearch.TextSize = 13
PetSearch.Font = Enum.Font.Gotham
PetSearch.ClearTextOnFocus = false
PetSearch.TextXAlignment = Enum.TextXAlignment.Left
PetSearch.Parent = Dashboard

local PetSearchCorner = Instance.new("UICorner")
PetSearchCorner.CornerRadius = UDim.new(0, 7)
PetSearchCorner.Parent = PetSearch

--==================================================
-- SEARCH RESULTS
--==================================================

local PetResults = Instance.new("ScrollingFrame")
PetResults.Name = "PetResults"
PetResults.Size = UDim2.new(0, 250, 0, 220)
PetResults.Position = UDim2.new(0, 20, 0, 115)
PetResults.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PetResults.BorderSizePixel = 0
PetResults.ScrollBarThickness = 5
PetResults.CanvasSize = UDim2.new(0, 0, 0, 0)
PetResults.Parent = Dashboard

local PetResultsCorner = Instance.new("UICorner")
PetResultsCorner.CornerRadius = UDim.new(0, 8)
PetResultsCorner.Parent = PetResults

local PetResultsLayout = Instance.new("UIListLayout")
PetResultsLayout.Padding = UDim.new(0, 3)
PetResultsLayout.Parent = PetResults

--==================================================
-- PET INFORMATION BOX
--==================================================

local PetInfo = Instance.new("TextBox")
PetInfo.Name = "PetInfo"
PetInfo.Size = UDim2.new(0, 290, 0, 265)
PetInfo.Position = UDim2.new(0, 290, 0, 70)
PetInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PetInfo.TextColor3 = Color3.fromRGB(230, 230, 230)
PetInfo.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
PetInfo.PlaceholderText = "Select an object to inspect it."
PetInfo.Text = ""
PetInfo.TextSize = 12
PetInfo.Font = Enum.Font.Code
PetInfo.TextXAlignment = Enum.TextXAlignment.Left
PetInfo.TextYAlignment = Enum.TextYAlignment.Top
PetInfo.MultiLine = true
PetInfo.ClearTextOnFocus = false
PetInfo.TextEditable = false
PetInfo.Parent = Dashboard

local PetInfoCorner = Instance.new("UICorner")
PetInfoCorner.CornerRadius = UDim.new(0, 8)
PetInfoCorner.Parent = PetInfo

--==================================================
-- CLIENT OBJECT CACHE
--==================================================

local InspectableObjects = {}

--==================================================
-- CLEAR SEARCH RESULTS
--==================================================

local function ClearPetResults()

	for _, child in ipairs(PetResults:GetChildren()) do

		if child:IsA("TextButton")
			or child:IsA("TextLabel") then

			child:Destroy()

		end

	end

end

--==================================================
-- INSPECT OBJECT
--==================================================

local function InspectObject(object)

	local Info = {}

	table.insert(Info, "================================")
	table.insert(Info, "        OBJECT INSPECTOR")
	table.insert(Info, "================================")
	table.insert(Info, "")

	table.insert(Info, "NAME")
	table.insert(Info, object.Name)
	table.insert(Info, "")

	table.insert(Info, "CLASS")
	table.insert(Info, object.ClassName)
	table.insert(Info, "")

	table.insert(Info, "PATH")
	table.insert(Info, object:GetFullName())
	table.insert(Info, "")

	--==================================================
	-- ATTRIBUTES
	--==================================================

	table.insert(Info, "================================")
	table.insert(Info, "ATTRIBUTES")
	table.insert(Info, "================================")

	local Attributes = object:GetAttributes()

	if next(Attributes) == nil then

		table.insert(Info, "(none)")

	else

		for Name, Value in pairs(Attributes) do

			table.insert(
				Info,
				"@" ..
				Name ..
				" = " ..
				tostring(Value) ..
				" [" ..
				typeof(Value) ..
				"]"
			)

		end

	end

	table.insert(Info, "")

	--==================================================
	-- TAGS
	--==================================================

	table.insert(Info, "================================")
	table.insert(Info, "TAGS")
	table.insert(Info, "================================")

	local Tags =
		CollectionService:GetTags(object)

	if #Tags == 0 then

		table.insert(Info, "(none)")

	else

		for _, Tag in ipairs(Tags) do
			table.insert(Info, Tag)
		end

	end

	table.insert(Info, "")

	--==================================================
	-- CHILDREN
	--==================================================

	table.insert(Info, "================================")
	table.insert(Info, "CHILDREN")
	table.insert(Info, "================================")

	local Children = object:GetChildren()

	if #Children == 0 then

		table.insert(Info, "(none)")

	else

		for _, Child in ipairs(Children) do

			table.insert(
				Info,
				Child.Name ..
				" [" ..
				Child.ClassName ..
				"]"
			)

			for Name, Value in pairs(
				Child:GetAttributes()
			) do

				table.insert(
					Info,
					"    @" ..
					Name ..
					" = " ..
					tostring(Value) ..
					" [" ..
					typeof(Value) ..
					"]"
				)

			end

			if Child:IsA("ValueBase") then

				table.insert(
					Info,
					"    VALUE = " ..
					tostring(Child.Value)
				)

			end

		end

	end

	PetInfo.Text =
		table.concat(Info, "\n")

end

--==================================================
-- ADD SEARCH RESULT
--==================================================

local function AddPetResult(object)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -10, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Button.TextColor3 = Color3.fromRGB(235, 235, 235)
	Button.TextSize = 11
	Button.Font = Enum.Font.Gotham
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.TextTruncate = Enum.TextTruncate.AtEnd

	Button.Text =
		"  " ..
		object.Name ..
		" [" ..
		object.ClassName ..
		"]"

	Button.Parent = PetResults

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button

	Button.MouseButton1Click:Connect(function()

		InspectObject(object)

	end)

end

--==================================================
-- SEARCH
--==================================================

local function SearchPets()

	ClearPetResults()

	local Search =
		string.lower(PetSearch.Text)

	if Search == "" then
		return
	end

	local Found = 0

	for _, object in ipairs(InspectableObjects) do

		local Name =
			string.lower(object.Name)

		local Path =
			string.lower(object:GetFullName())

		if string.find(Name, Search, 1, true)
			or string.find(Path, Search, 1, true) then

			AddPetResult(object)

			Found += 1

			if Found >= 50 then
				break
			end

		end

	end

	task.wait()

	PetResults.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			PetResultsLayout.AbsoluteContentSize.Y + 5
		)

end

--==================================================
-- BUILD OBJECT CACHE
--==================================================

local function ScanInspectableObjects()

	InspectableObjects = {}

	-- Workspace

	for _, Object in ipairs(
		workspace:GetDescendants()
	) do

		table.insert(
			InspectableObjects,
			Object
		)

	end

	-- ReplicatedStorage

	for _, Object in ipairs(
		ReplicatedStorage:GetDescendants()
	) do

		table.insert(
			InspectableObjects,
			Object
		)

	end

	-- LocalPlayer

	for _, Object in ipairs(
		LocalPlayer:GetDescendants()
	) do

		table.insert(
			InspectableObjects,
			Object
		)

	end

	print(
		"[YDashboard] Inspectable objects:",
		#InspectableObjects
	)

end

ScanInspectableObjects()

PetSearch:GetPropertyChangedSignal("Text"):Connect(function()

	SearchPets()

end)

--==================================================
-- LOCK SYSTEM
--==================================================

local Locked = false

LockButton.MouseButton1Click:Connect(function()

	Locked = not Locked

	LockButton.Text =
		Locked and "🔒" or "🔓"

end)

--==================================================
-- DASHBOARD TOGGLE
--==================================================

YButton.MouseButton1Click:Connect(function()

	Dashboard.Visible =
		not Dashboard.Visible

end)

--==================================================
-- DRAG Y BUTTON
--==================================================

local DraggingY = false
local DragStartY
local StartPosY

YButton.InputBegan:Connect(function(input)

	if Locked then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		DraggingY = true
		DragStartY = input.Position
		StartPosY = YButton.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				DraggingY = false

			end

		end)

	end

end)

--==================================================
-- DRAG DASHBOARD
--==================================================

local DraggingDashboard = false
local DragStartDashboard
local StartDashboardPosition

Title.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		DraggingDashboard = true
		DragStartDashboard = input.Position
		StartDashboardPosition = Dashboard.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				DraggingDashboard = false

			end

		end)

	end

end)

--==================================================
-- INPUT MOVEMENT
--==================================================

UserInputService.InputChanged:Connect(function(input)

	-- Y BUTTON

	if DraggingY and not Locked then

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

	-- DASHBOARD

	if DraggingDashboard then

		if input.UserInputType ==
			Enum.UserInputType.MouseMovement
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			local Delta =
				input.Position - DragStartDashboard

			Dashboard.Position =
				UDim2.new(
					StartDashboardPosition.X.Scale,
					StartDashboardPosition.X.Offset + Delta.X,
					StartDashboardPosition.Y.Scale,
					StartDashboardPosition.Y.Offset + Delta.Y
				)

		end

	end

end)
