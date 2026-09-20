--// Y Dashboard - UI Only

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

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
-- DATA TAB
--==================================================

local DataTab = Instance.new("TextButton")
DataTab.Name = "DataTab"
DataTab.Size = UDim2.new(0, 140, 0, 40)
DataTab.Position = UDim2.new(0, 165, 0, 60)
DataTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DataTab.Text = "DATA"
DataTab.TextColor3 = Color3.fromRGB(255, 255, 255)
DataTab.TextSize = 14
DataTab.Font = Enum.Font.GothamBold
DataTab.Parent = Dashboard

local DataCorner = Instance.new("UICorner")
DataCorner.CornerRadius = UDim.new(0, 8)
DataCorner.Parent = DataTab

--==================================================
-- INSTANT INTERACT
--==================================================

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
-- DATA PAGE
--==================================================

local DataPage = Instance.new("Frame")
DataPage.Name = "DataPage"
DataPage.Size = UDim2.new(1, -30, 1, -115)
DataPage.Position = UDim2.new(0, 15, 0, 110)
DataPage.BackgroundTransparency = 1
DataPage.Visible = false
DataPage.Parent = Dashboard

--==================================================
-- EGG STATUS
--==================================================

local EggStatus = Instance.new("Frame")
EggStatus.Name = "EggStatus"
EggStatus.Size = UDim2.new(1, -10, 0, 210)
EggStatus.Position = UDim2.new(0, 5, 0, 5)
EggStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
EggStatus.Parent = DataPage

local EggCorner = Instance.new("UICorner")
EggCorner.CornerRadius = UDim.new(0, 8)
EggCorner.Parent = EggStatus

local EggTitle = Instance.new("TextLabel")
EggTitle.Size = UDim2.new(1, -20, 0, 35)
EggTitle.Position = UDim2.new(0, 10, 0, 5)
EggTitle.BackgroundTransparency = 1
EggTitle.Text = "🥚 EXISTING EGGS"
EggTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
EggTitle.TextSize = 16
EggTitle.Font = Enum.Font.GothamBold
EggTitle.TextXAlignment = Enum.TextXAlignment.Left
EggTitle.Parent = EggStatus

local EggCount = Instance.new("TextLabel")
EggCount.Size = UDim2.new(0, 100, 0, 30)
EggCount.Position = UDim2.new(1, -110, 0, 7)
EggCount.BackgroundTransparency = 1
EggCount.Text = "0 eggs"
EggCount.TextColor3 = Color3.fromRGB(180, 180, 180)
EggCount.TextSize = 13
EggCount.Font = Enum.Font.Gotham
EggCount.Parent = EggStatus

local EggList = Instance.new("ScrollingFrame")
EggList.Name = "EggList"
EggList.Size = UDim2.new(1, -20, 0, 125)
EggList.Position = UDim2.new(0, 10, 0, 45)
EggList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
EggList.BorderSizePixel = 0
EggList.ScrollBarThickness = 5
EggList.CanvasSize = UDim2.new(0, 0, 0, 0)
EggList.Parent = EggStatus

local EggListCorner = Instance.new("UICorner")
EggListCorner.CornerRadius = UDim.new(0, 6)
EggListCorner.Parent = EggList

local EggLayout = Instance.new("UIListLayout")
EggLayout.Padding = UDim.new(0, 3)
EggLayout.Parent = EggList

local RefreshEggs = Instance.new("TextButton")
RefreshEggs.Size = UDim2.new(0, 120, 0, 30)
RefreshEggs.Position = UDim2.new(0, 10, 1, -35)
RefreshEggs.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
RefreshEggs.Text = "REFRESH"
RefreshEggs.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshEggs.TextSize = 12
RefreshEggs.Font = Enum.Font.GothamBold
RefreshEggs.Parent = EggStatus

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 6)
RefreshCorner.Parent = RefreshEggs

--==================================================
-- EGG SCANNER
--==================================================

local function IsEggObject(object)
	local name = string.lower(object.Name)

	return name:find("egg", 1, true) ~= nil
		or name:find("pet", 1, true) ~= nil
end

local function ClearEggList()
	for _, child in ipairs(EggList:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end

local function ScanEggs()

	ClearEggList()

	local Eggs = {}
	local Seen = {}

	for _, object in ipairs(workspace:GetDescendants()) do

		if IsEggObject(object) then

			local name = object.Name

			if not Seen[name] then
				Seen[name] = true

				table.insert(Eggs, {
					Name = name,
					Class = object.ClassName,
					Path = object:GetFullName()
				})
			end
		end
	end

	table.sort(Eggs, function(a, b)
		return a.Name:lower() < b.Name:lower()
	end)

	EggCount.Text = tostring(#Eggs) .. " eggs"

	if #Eggs == 0 then

		local Empty = Instance.new("TextLabel")
		Empty.Size = UDim2.new(1, -10, 0, 30)
		Empty.BackgroundTransparency = 1
		Empty.Text = "No egg objects found in Workspace."
		Empty.TextColor3 = Color3.fromRGB(150, 150, 150)
		Empty.TextSize = 13
		Empty.Font = Enum.Font.Gotham
		Empty.Parent = EggList

	else

		for _, egg in ipairs(Eggs) do

			local Row = Instance.new("TextLabel")
			Row.Size = UDim2.new(1, -10, 0, 27)
			Row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Row.Text =
				"🥚  " .. egg.Name .. "  [" .. egg.Class .. "]"
			Row.TextColor3 = Color3.fromRGB(235, 235, 235)
			Row.TextSize = 12
			Row.Font = Enum.Font.Gotham
			Row.TextXAlignment = Enum.TextXAlignment.Left
			Row.Parent = EggList

			local RowCorner = Instance.new("UICorner")
			RowCorner.CornerRadius = UDim.new(0, 5)
			RowCorner.Parent = Row
		end
	end

	task.wait()

	EggList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		EggLayout.AbsoluteContentSize.Y + 5
	)

	print("========== EGG STATUS ==========")

	for _, egg in ipairs(Eggs) do
		print(egg.Name, "|", egg.Class, "|", egg.Path)
	end

	print("Total unique eggs:", #Eggs)
	print("================================")
end

RefreshEggs.MouseButton1Click:Connect(ScanEggs)

--==================================================
-- DATA INSPECTOR
--==================================================

local DataPaths = {
	"Shared.Types.AssetItem",
	"Shared.Types.ActiveAssets",
	"Shared.Types.Index",
	"Shared.Util.AssetItems",
	"Shared.Util.AssetEarnings",
	"Shared.Modules.ItemDisplay",
	"Shared.Modules.AssetInfoBillboard",
	"Shared.Modules.CoreProfileManager",
}

local function GetPath(root, path)

	local object = root

	for part in path:gmatch("[^%.]+") do

		object = object:FindFirstChild(part)

		if not object then
			return nil
		end
	end

	return object
end

local function InspectData()

	local RS = game:GetService("ReplicatedStorage")

	print("")
	print("========================================")
	print("       YDASHBOARD DATA INSPECTOR")
	print("========================================")

	for _, path in ipairs(DataPaths) do

		print("")
		print("========== " .. path .. " ==========")

		local object = GetPath(RS, path)

		if not object then
			print("NOT FOUND")
			continue
		end

		print("Class:", object.ClassName)
		print("FullName:", object:GetFullName())

		print("-- Attributes --")

		local attributes = object:GetAttributes()

		if next(attributes) == nil then
			print("(none)")
		else
			for name, value in pairs(attributes) do
				print("@" .. name .. " =", value)
			end
		end

		print("-- Children --")

		local children = object:GetChildren()

		if #children == 0 then
			print("(no children)")
		else

			for i, child in ipairs(children) do

				print(
					string.format(
						"[%d] %s | %s",
						i,
						child.Name,
						child.ClassName
					)
				)

				for name, value in pairs(child:GetAttributes()) do
					print("    @" .. name .. " =", value)
				end

				if child:IsA("ValueBase") then
					print("    VALUE =", child.Value)
				end
			end
		end
	end

	print("")
	print("========================================")
	print("       DATA SCAN COMPLETE")
	print("========================================")
end

local InspectButton = Instance.new("TextButton")
InspectButton.Name = "InspectData"
InspectButton.Size = UDim2.new(0, 250, 0, 40)
InspectButton.Position = UDim2.new(0, 5, 0, 225)
InspectButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InspectButton.Text = "Inspect Pet/Data Folders"
InspectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InspectButton.TextSize = 14
InspectButton.Font = Enum.Font.Gotham
InspectButton.Parent = DataPage

local InspectCorner = Instance.new("UICorner")
InspectCorner.CornerRadius = UDim.new(0, 8)
InspectCorner.Parent = InspectButton

InspectButton.MouseButton1Click:Connect(InspectData)

--==================================================
-- TERMINATE
--==================================================

local TerminateButton = Instance.new("TextButton")
TerminateButton.Name = "TerminateButton"
TerminateButton.Size = UDim2.new(0, 250, 0, 40)
TerminateButton.Position = UDim2.new(0, 270, 0, 225)
TerminateButton.BackgroundColor3 = Color3.fromRGB(120, 35, 35)
TerminateButton.Text = "TERMINATE Y DASHBOARD"
TerminateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TerminateButton.TextSize = 14
TerminateButton.Font = Enum.Font.GothamBold
TerminateButton.Parent = DataPage

local TerminateCorner = Instance.new("UICorner")
TerminateCorner.CornerRadius = UDim.new(0, 8)
TerminateCorner.Parent = TerminateButton

TerminateButton.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

--==================================================
-- TAB SWITCHING
--==================================================

CharacterTab.MouseButton1Click:Connect(function()

	DataPage.Visible = false
	InstantInteractButton.Visible = true

	CharacterTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	DataTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

end)

DataTab.MouseButton1Click:Connect(function()

	DataPage.Visible = true
	InstantInteractButton.Visible = false

	CharacterTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	DataTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)

	ScanEggs()

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
