--// Y Dashboard - UI Only

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
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
-- PETS TAB
--==================================================

local PetsTab = Instance.new("TextButton")
PetsTab.Name = "PetsTab"
PetsTab.Size = UDim2.new(0, 140, 0, 40)
PetsTab.Position = UDim2.new(0, 315, 0, 60)
PetsTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PetsTab.Text = "PETS"
PetsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
PetsTab.TextSize = 14
PetsTab.Font = Enum.Font.GothamBold
PetsTab.Parent = Dashboard

local PetsCorner = Instance.new("UICorner")
PetsCorner.CornerRadius = UDim.new(0, 8)
PetsCorner.Parent = PetsTab

--==================================================
-- CLIENT TAB
--==================================================

local ClientTab = Instance.new("TextButton")
ClientTab.Name = "ClientTab"
ClientTab.Size = UDim2.new(0, 125, 0, 40)
ClientTab.Position = UDim2.new(0, 465, 0, 60)
ClientTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ClientTab.Text = "CLIENT"
ClientTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ClientTab.TextSize = 14
ClientTab.Font = Enum.Font.GothamBold
ClientTab.Parent = Dashboard

local ClientCorner = Instance.new("UICorner")
ClientCorner.CornerRadius = UDim.new(0, 8)
ClientCorner.Parent = ClientTab

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
			object.HoldDuration =
				InstantInteract and 0 or object.HoldDuration
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
		"Instant Interact: " ..
		(InstantInteract and "ON" or "OFF")

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
-- PETS PAGE
--==================================================

local PetsPage = Instance.new("Frame")
PetsPage.Name = "PetsPage"
PetsPage.Size = UDim2.new(1, -30, 1, -115)
PetsPage.Position = UDim2.new(0, 15, 0, 110)
PetsPage.BackgroundTransparency = 1
PetsPage.Visible = false
PetsPage.Parent = Dashboard

local PetsTitle = Instance.new("TextLabel")
PetsTitle.Size = UDim2.new(1, -20, 0, 35)
PetsTitle.Position = UDim2.new(0, 10, 0, 5)
PetsTitle.BackgroundTransparency = 1
PetsTitle.Text = "🐾 AVAILABLE PETS"
PetsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PetsTitle.TextSize = 17
PetsTitle.Font = Enum.Font.GothamBold
PetsTitle.TextXAlignment = Enum.TextXAlignment.Left
PetsTitle.Parent = PetsPage

local PetsCount = Instance.new("TextLabel")
PetsCount.Size = UDim2.new(0, 150, 0, 30)
PetsCount.Position = UDim2.new(1, -160, 0, 7)
PetsCount.BackgroundTransparency = 1
PetsCount.Text = "0 available"
PetsCount.TextColor3 = Color3.fromRGB(180, 180, 180)
PetsCount.TextSize = 13
PetsCount.Font = Enum.Font.Gotham
PetsCount.Parent = PetsPage

local PetsList = Instance.new("ScrollingFrame")
PetsList.Name = "PetsList"
PetsList.Size = UDim2.new(1, -20, 0, 215)
PetsList.Position = UDim2.new(0, 10, 0, 45)
PetsList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PetsList.BorderSizePixel = 0
PetsList.ScrollBarThickness = 5
PetsList.CanvasSize = UDim2.new(0, 0, 0, 0)
PetsList.Parent = PetsPage

local PetsListCorner = Instance.new("UICorner")
PetsListCorner.CornerRadius = UDim.new(0, 8)
PetsListCorner.Parent = PetsList

local PetsLayout = Instance.new("UIListLayout")
PetsLayout.Padding = UDim.new(0, 4)
PetsLayout.Parent = PetsList

local RefreshPets = Instance.new("TextButton")
RefreshPets.Size = UDim2.new(0, 150, 0, 35)
RefreshPets.Position = UDim2.new(0, 10, 0, 270)
RefreshPets.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
RefreshPets.Text = "REFRESH PETS"
RefreshPets.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshPets.TextSize = 13
RefreshPets.Font = Enum.Font.GothamBold
RefreshPets.Parent = PetsPage

local RefreshPetsCorner = Instance.new("UICorner")
RefreshPetsCorner.CornerRadius = UDim.new(0, 7)
RefreshPetsCorner.Parent = RefreshPets

--==================================================
-- STEALABLE PET SCANNER
--==================================================

local function IsStealablePet(object)

	local name = string.lower(object.Name)

	local LooksLikePet =
		name:find("pet", 1, true) ~= nil
		or name:find("cat", 1, true) ~= nil
		or name:find("dog", 1, true) ~= nil
		or name:find("dragon", 1, true) ~= nil

	if not LooksLikePet then
		return false
	end

	local Attributes = object:GetAttributes()

	for attribute, value in pairs(Attributes) do

		local key = string.lower(attribute)

		if key == "stealable"
			or key == "cansteal"
			or key == "isstealable"
			or key == "availabletosteal" then

			if value == true then
				return true
			end

		end

	end

	for _, tag in ipairs(CollectionService:GetTags(object)) do

		if string.lower(tag) == "stealable" then
			return true
		end

	end

	return false

end

local function ClearPets()

	for _, child in ipairs(PetsList:GetChildren()) do

		if child:IsA("TextLabel") then
			child:Destroy()
		end

	end

end

local function ScanStealablePets()

	ClearPets()

	local Pets = {}

	for _, object in ipairs(workspace:GetDescendants()) do

		if IsStealablePet(object) then

			table.insert(Pets, {
				Name = object.Name,
				Class = object.ClassName,
				Path = object:GetFullName()
			})

		end

	end

	table.sort(Pets, function(a, b)
		return a.Name:lower() < b.Name:lower()
	end)

	PetsCount.Text = tostring(#Pets) .. " available"

	if #Pets == 0 then

		local Empty = Instance.new("TextLabel")
		Empty.Size = UDim2.new(1, -10, 0, 35)
		Empty.BackgroundTransparency = 1
		Empty.Text = "No explicitly stealable pets detected."
		Empty.TextColor3 = Color3.fromRGB(150, 150, 150)
		Empty.TextSize = 13
		Empty.Font = Enum.Font.Gotham
		Empty.Parent = PetsList

	else

		for _, pet in ipairs(Pets) do

			local Row = Instance.new("TextLabel")

			Row.Size = UDim2.new(1, -10, 0, 45)
			Row.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

			Row.Text =
				"🐾  " .. pet.Name ..
				"\n    " .. pet.Class ..
				" | " .. pet.Path

			Row.TextColor3 = Color3.fromRGB(235, 235, 235)
			Row.TextSize = 12
			Row.Font = Enum.Font.Gotham
			Row.TextXAlignment = Enum.TextXAlignment.Left
			Row.TextYAlignment = Enum.TextYAlignment.Center
			Row.Parent = PetsList

			local RowCorner = Instance.new("UICorner")
			RowCorner.CornerRadius = UDim.new(0, 6)
			RowCorner.Parent = Row

		end

	end

	task.wait()

	PetsList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		PetsLayout.AbsoluteContentSize.Y + 5
	)

	print("========== STEALABLE PETS ==========")

	for _, pet in ipairs(Pets) do
		print(pet.Name, "|", pet.Class, "|", pet.Path)
	end

	print("Available stealable pets:", #Pets)
	print("====================================")

end

RefreshPets.MouseButton1Click:Connect(ScanStealablePets)

--==================================================
-- CLIENT PAGE
--==================================================

local ClientPage = Instance.new("Frame")
ClientPage.Name = "ClientPage"
ClientPage.Size = UDim2.new(1, -30, 1, -115)
ClientPage.Position = UDim2.new(0, 15, 0, 110)
ClientPage.BackgroundTransparency = 1
ClientPage.Visible = false
ClientPage.Parent = Dashboard

--==================================================
-- CLIENT TITLE
--==================================================

local ClientTitle = Instance.new("TextLabel")
ClientTitle.Size = UDim2.new(1, -20, 0, 30)
ClientTitle.Position = UDim2.new(0, 10, 0, 0)
ClientTitle.BackgroundTransparency = 1
ClientTitle.Text = "CLIENT EXPLORER"
ClientTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ClientTitle.TextSize = 17
ClientTitle.Font = Enum.Font.GothamBold
ClientTitle.TextXAlignment = Enum.TextXAlignment.Left
ClientTitle.Parent = ClientPage

--==================================================
-- CLIENT STATUS
--==================================================

local ClientStatus = Instance.new("TextLabel")
ClientStatus.Size = UDim2.new(1, -20, 0, 25)
ClientStatus.Position = UDim2.new(0, 10, 0, 30)
ClientStatus.BackgroundTransparency = 1
ClientStatus.Text = "Press SCAN CLIENT first."
ClientStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
ClientStatus.TextSize = 12
ClientStatus.Font = Enum.Font.Gotham
ClientStatus.TextXAlignment = Enum.TextXAlignment.Left
ClientStatus.Parent = ClientPage

--==================================================
-- CLIENT SEARCH
--==================================================

local ClientSearch = Instance.new("TextBox")
ClientSearch.Name = "ClientSearch"
ClientSearch.Size = UDim2.new(1, -20, 0, 38)
ClientSearch.Position = UDim2.new(0, 10, 0, 55)
ClientSearch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ClientSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
ClientSearch.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
ClientSearch.PlaceholderText = "Search name or path..."
ClientSearch.Text = ""
ClientSearch.TextSize = 13
ClientSearch.Font = Enum.Font.Gotham
ClientSearch.ClearTextOnFocus = false
ClientSearch.TextXAlignment = Enum.TextXAlignment.Left
ClientSearch.Parent = ClientPage

local ClientSearchCorner = Instance.new("UICorner")
ClientSearchCorner.CornerRadius = UDim.new(0, 7)
ClientSearchCorner.Parent = ClientSearch

--==================================================
-- CLIENT LIST
--==================================================

local ClientList = Instance.new("ScrollingFrame")
ClientList.Name = "ClientList"
ClientList.Size = UDim2.new(1, -20, 0, 190)
ClientList.Position = UDim2.new(0, 10, 0, 100)
ClientList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ClientList.BorderSizePixel = 0
ClientList.ScrollBarThickness = 5
ClientList.CanvasSize = UDim2.new(0, 0, 0, 0)
ClientList.Parent = ClientPage

local ClientListCorner = Instance.new("UICorner")
ClientListCorner.CornerRadius = UDim.new(0, 8)
ClientListCorner.Parent = ClientList

local ClientLayout = Instance.new("UIListLayout")
ClientLayout.Padding = UDim.new(0, 3)
ClientLayout.Parent = ClientList

--==================================================
-- CLIENT SCAN BUTTON
--==================================================

local RefreshClient = Instance.new("TextButton")
RefreshClient.Name = "RefreshClient"
RefreshClient.Size = UDim2.new(0, 150, 0, 35)
RefreshClient.Position = UDim2.new(0, 10, 0, 295)
RefreshClient.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
RefreshClient.Text = "SCAN CLIENT"
RefreshClient.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshClient.TextSize = 13
RefreshClient.Font = Enum.Font.GothamBold
RefreshClient.Parent = ClientPage

local RefreshClientCorner = Instance.new("UICorner")
RefreshClientCorner.CornerRadius = UDim.new(0, 7)
RefreshClientCorner.Parent = RefreshClient

--==================================================
-- CLIENT EXPLORER
--==================================================

local ClientObjects = {}

local function ClearClientList()

	for _, child in ipairs(ClientList:GetChildren()) do

		if child:IsA("TextButton")
			or child:IsA("TextLabel") then

			child:Destroy()

		end

	end

end

local function AddClientObject(object)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -10, 0, 38)
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

	Button.Parent = ClientList

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button

	Button.MouseButton1Click:Connect(function()

		local Path = object:GetFullName()

		if setclipboard then

			setclipboard(Path)

			ClientStatus.Text =
				"Copied: " .. Path

		else

			ClientStatus.Text =
				Path

		end

	end)

end

local function RefreshClientList()

	ClearClientList()

	local Search =
		string.lower(ClientSearch.Text)

	local Found = 0

	for _, object in ipairs(ClientObjects) do

		local Name =
			string.lower(object.Name)

		local Path =
			string.lower(object:GetFullName())

		if Search ~= ""
			and (
				string.find(Name, Search, 1, true)
				or string.find(Path, Search, 1, true)
			) then

			AddClientObject(object)

			Found += 1

			-- Prevent accidentally creating thousands
			-- of GUI elements at once.
			if Found >= 150 then
				break
			end

		end

	end

	if Search == "" then

		ClientStatus.Text =
			"Scanned " ..
			#ClientObjects ..
			" objects. Type something to search."

	elseif Found >= 150 then

		ClientStatus.Text =
			"Showing first 150 matching objects."

	else

		ClientStatus.Text =
			"Found " ..
			Found ..
			" matching objects."

	end

	task.wait()

	ClientList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		ClientLayout.AbsoluteContentSize.Y + 5
	)

end

local function ScanClient()

	ClientObjects = {}

	ClientStatus.Text =
		"Scanning Workspace..."

	for _, object in ipairs(workspace:GetDescendants()) do

		table.insert(
			ClientObjects,
			object
		)

	end

	ClientStatus.Text =
		"Scanning ReplicatedStorage..."

	for _, object in ipairs(
		ReplicatedStorage:GetDescendants()
	) do

		table.insert(
			ClientObjects,
			object
		)

	end

	table.sort(ClientObjects, function(a, b)

		return a:GetFullName():lower()
			<
			b:GetFullName():lower()

	end)

	RefreshClientList()

	if ClientSearch.Text == "" then

		ClientStatus.Text =
			"Scanned " ..
			#ClientObjects ..
			" objects. Type something to search."

	end

	print("")
	print("========================================")
	print("          CLIENT EXPLORER")
	print("========================================")
	print("Client-visible objects:", #ClientObjects)
	print("========================================")

end

RefreshClient.MouseButton1Click:Connect(function()
	ScanClient()
end)

ClientSearch:GetPropertyChangedSignal("Text"):Connect(function()

	if #ClientObjects > 0 then
		RefreshClientList()
	end

end)

--==================================================
-- TAB SWITCHING
--==================================================

local function ResetTabs()

	CharacterTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 45)

	DataTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 45)

	PetsTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 45)

	ClientTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 45)

end

CharacterTab.MouseButton1Click:Connect(function()

	ResetTabs()

	CharacterTab.BackgroundColor3 =
		Color3.fromRGB(55, 55, 55)

	DataPage.Visible = false
	PetsPage.Visible = false
	ClientPage.Visible = false

	InstantInteractButton.Visible = true

end)

DataTab.MouseButton1Click:Connect(function()

	ResetTabs()

	DataTab.BackgroundColor3 =
		Color3.fromRGB(55, 55, 55)

	DataPage.Visible = true
	PetsPage.Visible = false
	ClientPage.Visible = false

	InstantInteractButton.Visible = false

	ScanEggs()

end)

PetsTab.MouseButton1Click:Connect(function()

	ResetTabs()

	PetsTab.BackgroundColor3 =
		Color3.fromRGB(55, 55, 55)

	DataPage.Visible = false
	PetsPage.Visible = true
	ClientPage.Visible = false

	InstantInteractButton.Visible = false

	ScanStealablePets()

end)

ClientTab.MouseButton1Click:Connect(function()

	ResetTabs()

	ClientTab.BackgroundColor3 =
		Color3.fromRGB(55, 55, 55)

	DataPage.Visible = false
	PetsPage.Visible = false
	ClientPage.Visible = true

	InstantInteractButton.Visible = false

end)

--==================================================
-- Y BUTTON / LOCK
--==================================================

local Locked = false
local DraggingY = false
local DragStartY
local StartPosY

YButton.MouseButton1Click:Connect(function()

	Dashboard.Visible =
		not Dashboard.Visible

end)

LockButton.MouseButton1Click:Connect(function()

	Locked = not Locked

	LockButton.Text =
		Locked and "🔒" or "🔓"

end)

--==================================================
-- DRAG Y BUTTON
--==================================================

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

UserInputService.InputChanged:Connect(function(input)

	if not DraggingY or Locked then
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

UserInputService.InputChanged:Connect(function(input)

	if not DraggingDashboard then
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
				StartDashboardPosition.X.Offset + Delta.X,
				StartDashboardPosition.Y.Scale,
				StartDashboardPosition.Y.Offset + Delta.Y
			)

	end

end)
