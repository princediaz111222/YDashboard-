local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "YDashboard"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--==================================================
-- DASHBOARD
--==================================================

local dashboard = Instance.new("Frame")
dashboard.Name = "Dashboard"
dashboard.Size = UDim2.new(0, 600, 0, 400)
dashboard.Position = UDim2.new(0.5, -300, 0.5, -200)
dashboard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
dashboard.BorderSizePixel = 0
dashboard.Parent = gui

local dashboardCorner = Instance.new("UICorner")
dashboardCorner.CornerRadius = UDim.new(0, 14)
dashboardCorner.Parent = dashboard

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 45)
title.Position = UDim2.new(0, 15, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Y Dashboard"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dashboard

--==================================================
-- TABS
--==================================================

local characterTab = Instance.new("TextButton")
characterTab.Size = UDim2.new(0, 140, 0, 35)
characterTab.Position = UDim2.new(0, 20, 0, 50)
characterTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
characterTab.Text = "CHARACTER"
characterTab.TextColor3 = Color3.fromRGB(255, 255, 255)
characterTab.TextSize = 14
characterTab.Font = Enum.Font.GothamBold
characterTab.Parent = dashboard

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 8)
cCorner.Parent = characterTab

local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0, 140, 0, 35)
espTab.Position = UDim2.new(0, 170, 0, 50)
espTab.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.TextSize = 14
espTab.Font = Enum.Font.GothamBold
espTab.Parent = dashboard

local eCorner = Instance.new("UICorner")
eCorner.CornerRadius = UDim.new(0, 8)
eCorner.Parent = espTab

local iconsTab = Instance.new("TextButton")
iconsTab.Size = UDim2.new(0, 140, 0, 35)
iconsTab.Position = UDim2.new(0, 320, 0, 50)
iconsTab.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
iconsTab.Text = "📦 ICONS"
iconsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
iconsTab.TextSize = 14
iconsTab.Font = Enum.Font.GothamBold
iconsTab.Parent = dashboard

local iCorner = Instance.new("UICorner")
iCorner.CornerRadius = UDim.new(0, 8)
iCorner.Parent = iconsTab

--==================================================
-- PAGES
--==================================================

local characterPage = Instance.new("Frame")
characterPage.Size = UDim2.new(1, -40, 1, -100)
characterPage.Position = UDim2.new(0, 20, 0, 95)
characterPage.BackgroundTransparency = 1
characterPage.Parent = dashboard

local espPage = Instance.new("Frame")
espPage.Size = UDim2.new(1, -40, 1, -100)
espPage.Position = UDim2.new(0, 20, 0, 95)
espPage.BackgroundTransparency = 1
espPage.Visible = false
espPage.Parent = dashboard

local iconsPage = Instance.new("Frame")
iconsPage.Size = UDim2.new(1, -40, 1, -100)
iconsPage.Position = UDim2.new(0, 20, 0, 95)
iconsPage.BackgroundTransparency = 1
iconsPage.Visible = false
iconsPage.Parent = dashboard

--==================================================
-- BUTTON CREATOR
--==================================================

local function makeButton(parent, y, text)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 220, 0, 50)
	button.Position = UDim2.new(0, 0, 0, y)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 17
	button.Font = Enum.Font.GothamBold
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = button

	return button
end

--==================================================
-- INSTANT INTERACT
--==================================================

local instantInteract = true

local instantButton = makeButton(
	characterPage,
	0,
	"Instant Interact: ON"
)

local function updatePrompt(prompt)

	if prompt:IsA("ProximityPrompt") and instantInteract then
		prompt.HoldDuration = 0
	end

end

for _, obj in ipairs(Workspace:GetDescendants()) do
	updatePrompt(obj)
end

Workspace.DescendantAdded:Connect(function(obj)

	if instantInteract then
		updatePrompt(obj)
	end

end)

instantButton.MouseButton1Click:Connect(function()

	instantInteract = not instantInteract

	instantButton.Text =
		"Instant Interact: " ..
		(instantInteract and "ON" or "OFF")

	if instantInteract then

		for _, obj in ipairs(Workspace:GetDescendants()) do
			updatePrompt(obj)
		end

	end

end)

--==================================================
-- PIN
--==================================================

local pinnedPosition = nil

local pinButton = makeButton(
	characterPage,
	60,
	"📍 Pin Location"
)

pinButton.MouseButton1Click:Connect(function()

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then

		pinnedPosition = root.Position
		pinButton.Text = "📍 Location Pinned!"

		task.delay(1.5, function()

			if pinnedPosition then
				pinButton.Text = "📍 Pin Location"
			end

		end)

	end

end)

--==================================================
-- WALK FUNCTION
--==================================================

local walkingToPin = false
local walkConnection

local function stopWalking()

	walkingToPin = false

	if walkConnection then
		walkConnection:Disconnect()
		walkConnection = nil
	end

end

local function startWalkingToPin()

	if not pinnedPosition then
		return false
	end

	if walkingToPin then
		return true
	end

	walkingToPin = true

	walkConnection = RunService.RenderStepped:Connect(function()

		if not walkingToPin or not pinnedPosition then
			return
		end

		local character = player.Character
		local humanoid =
			character and character:FindFirstChildOfClass("Humanoid")
		local root =
			character and character:FindFirstChild("HumanoidRootPart")

		if not humanoid or not root then
			stopWalking()
			return
		end

		local direction = pinnedPosition - root.Position

		direction = Vector3.new(
			direction.X,
			0,
			direction.Z
		)

		if direction.Magnitude < 2 then
			stopWalking()
			return
		end

		humanoid:Move(direction.Unit, false)

	end)

	return true
end

--==================================================
-- WALK TO PIN BUTTON
--==================================================

local walkButton = makeButton(
	characterPage,
	120,
	"🚶 Walk to Pin"
)

walkButton.MouseButton1Click:Connect(function()

	if walkingToPin then

		stopWalking()
		walkButton.Text = "🚶 Walk to Pin"

		return
	end

	if not pinnedPosition then

		walkButton.Text = "❌ No Pin!"

		task.delay(1.5, function()
			walkButton.Text = "🚶 Walk to Pin"
		end)

		return
	end

	startWalkingToPin()
	walkButton.Text = "🛑 Stop Walking"

end)

RunService.RenderStepped:Connect(function()

	if not walkingToPin then

		if walkButton.Text == "🛑 Stop Walking" then
			walkButton.Text = "🚶 Walk to Pin"
		end

		return
	end

end)

--==================================================
-- GRAB -> WALK TO PIN
--==================================================

local grabToPin = true
local grabWalking = false
local grabWalkConnection

local function stopGrabWalking()

	grabWalking = false

	if grabWalkConnection then
		grabWalkConnection:Disconnect()
		grabWalkConnection = nil
	end

end

local function walkFromGrabToPin()

	if not pinnedPosition then
		return
	end

	stopGrabWalking()

	grabWalking = true

	grabWalkConnection = RunService.RenderStepped:Connect(function()

		if not grabWalking or not pinnedPosition then
			stopGrabWalking()
			return
		end

		local character = player.Character
		local humanoid =
			character and character:FindFirstChildOfClass("Humanoid")
		local root =
			character and character:FindFirstChild("HumanoidRootPart")

		if not humanoid or not root then
			stopGrabWalking()
			return
		end

		local direction = pinnedPosition - root.Position

		direction = Vector3.new(
			direction.X,
			0,
			direction.Z
		)

		if direction.Magnitude < 2 then
			stopGrabWalking()
			return
		end

		humanoid:Move(direction.Unit, false)

	end)

end

ProximityPromptService.PromptTriggered:Connect(function(
	prompt,
	triggeredPlayer
)

	if not grabToPin then
		return
	end

	if triggeredPlayer ~= player then
		return
	end

	if not pinnedPosition then
		return
	end

	stopWalking()
	walkButton.Text = "🚶 Walk to Pin"

	walkFromGrabToPin()

end)

--==================================================
-- ANTI RAGDOLL
--==================================================

local antiRagdoll = false

local ragdollButton = makeButton(
	characterPage,
	180,
	"Anti-Ragdoll: OFF"
)

ragdollButton.MouseButton1Click:Connect(function()

	antiRagdoll = not antiRagdoll

	ragdollButton.Text =
		"Anti-Ragdoll: " ..
		(antiRagdoll and "ON" or "OFF")

end)

RunService.RenderStepped:Connect(function()

	if not antiRagdoll then
		return
	end

	local character = player.Character
	local humanoid =
		character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then

		local state = humanoid:GetState()

		if state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown then

			humanoid:ChangeState(
				Enum.HumanoidStateType.GettingUp
			)

		end
	end

end)

--==================================================
-- ESP SETTINGS
--==================================================

local playerESP = true
local objectESP = true

local playerDirectionLines = true
local objectDirectionLines = true

local playerESPObjects = {}
local objectESPObjects = {}

local espFolder = Instance.new("Folder")
espFolder.Name = "Y_ESP"
espFolder.Parent = Workspace

--==================================================
-- FIND ACTUAL PROMPT TARGET
--==================================================

local function getPromptTarget(prompt)

	local parent = prompt.Parent

	if parent:IsA("BasePart") then
		return parent
	end

	if parent:IsA("Attachment") then

		if parent.Parent:IsA("BasePart") then
			return parent.Parent
		end

	end

	if parent:IsA("Model") then

		if parent.PrimaryPart then
			return parent.PrimaryPart
		end

		return parent:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

	end

	return nil
end

--==================================================
-- GET TARGET PART
--==================================================

local function getTargetPart(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

	end

	return nil
end

--==================================================
-- NAME LABEL
--==================================================

local function createNameLabel(
	targetPart,
	name,
	isPlayer
)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "YNameESP"
	billboard.Adornee = targetPart
	billboard.Size = UDim2.new(0, 180, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 1000
	billboard.Parent = espFolder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextSize = 14
	label.Font = Enum.Font.GothamBold
	label.TextStrokeTransparency = 0.25

	label.TextColor3 =
		isPlayer
		and Color3.fromRGB(255, 90, 90)
		or Color3.fromRGB(90, 255, 130)

	label.Parent = billboard

	return billboard
end

--==================================================
-- CREATE ESP
--==================================================

local function createESP(
	object,
	isPlayer,
	displayName
)

	local targetPart = getTargetPart(object)

	if not targetPart then
		return
	end

	local storage =
		isPlayer
		and playerESPObjects
		or objectESPObjects

	if storage[object] then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "YHighlight"
	highlight.Adornee = object
	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillTransparency = 0.65
	highlight.OutlineTransparency = 0

	if isPlayer then

		highlight.FillColor =
			Color3.fromRGB(255, 70, 70)

	else

		highlight.FillColor =
			Color3.fromRGB(70, 255, 120)

	end

	highlight.OutlineColor =
		Color3.fromRGB(255, 255, 255)

	highlight.Parent = espFolder

	local label = createNameLabel(
		targetPart,
		displayName or object.Name,
		isPlayer
	)

	local targetAttachment =
		Instance.new("Attachment")

	targetAttachment.Name = "YESPTarget"
	targetAttachment.Parent = targetPart

	local character = player.Character
	local root =
		character and character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not root then

		highlight:Destroy()
		label:Destroy()
		targetAttachment:Destroy()

		return
	end

	local sourceAttachment =
		Instance.new("Attachment")

	sourceAttachment.Name = "YESPSource"
	sourceAttachment.Parent = root

	local beam = Instance.new("Beam")
	beam.Name = "YDirectionLine"
	beam.Attachment0 = sourceAttachment
	beam.Attachment1 = targetAttachment
	beam.FaceCamera = true
	beam.Width0 = 0.06
	beam.Width1 = 0.06
	beam.LightEmission = 1
	beam.Transparency =
		NumberSequence.new(0.15)

	if isPlayer then

		beam.Color =
			ColorSequence.new(
				Color3.fromRGB(255, 70, 70)
			)

		beam.Enabled = playerDirectionLines

	else

		beam.Color =
			ColorSequence.new(
				Color3.fromRGB(70, 255, 120)
			)

		beam.Enabled = objectDirectionLines

	end

	beam.Parent = espFolder

	storage[object] = {
		Highlight = highlight,
		Label = label,
		Beam = beam,
		Source = sourceAttachment,
		Target = targetAttachment
	}

end

--==================================================
-- REMOVE ESP
--==================================================

local function removeESP(object, isPlayer)

	local storage =
		isPlayer
		and playerESPObjects
		or objectESPObjects

	local data = storage[object]

	if not data then
		return
	end

	for _, item in pairs(data) do

		if typeof(item) == "Instance" then
			item:Destroy()
		end

	end

	storage[object] = nil

end

--==================================================
-- OBJECT ESP
--==================================================

local function updateObjectESP()

	for _, prompt in ipairs(
		Workspace:GetDescendants()
	) do

		if prompt:IsA("ProximityPrompt") then

			local target =
				getPromptTarget(prompt)

			if target and objectESP then

				createESP(
					target,
					false,
					target.Name
				)

			end
		end
	end

	for object in pairs(objectESPObjects) do

		local stillHasPrompt = false

		for _, prompt in ipairs(
			object:GetDescendants()
		) do

			if prompt:IsA("ProximityPrompt") then
				stillHasPrompt = true
				break
			end

		end

		if object:FindFirstChildWhichIsA(
			"ProximityPrompt"
		) then
			stillHasPrompt = true
		end

		if not stillHasPrompt then
			removeESP(object, false)
		end

	end

end

--==================================================
-- PLAYER ESP
--==================================================

local function updatePlayerESP()

	for _, plr in ipairs(
		Players:GetPlayers()
	) do

		if plr ~= player then

			local character = plr.Character

			if character then

				if playerESP then

					createESP(
						character,
						true,
						plr.Name
					)

				else

					removeESP(
						character,
						true
					)

				end

			end
		end
	end

end

--==================================================
-- ICONS PAGE
--==================================================

local iconScroll = Instance.new("ScrollingFrame")
iconScroll.Size = UDim2.new(1, 0, 1, 0)
iconScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
iconScroll.BorderSizePixel = 0
iconScroll.ScrollBarThickness = 6
iconScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
iconScroll.Parent = iconsPage

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = iconScroll

local iconLayout = Instance.new("UIGridLayout")
iconLayout.CellSize = UDim2.new(0, 125, 0, 150)
iconLayout.CellPadding = UDim2.new(0, 10, 0, 10)
iconLayout.SortOrder = Enum.SortOrder.LayoutOrder
iconLayout.Parent = iconScroll

local iconEntries = {}

--==================================================
-- CLONE OBJECT FOR VIEWPORT
--==================================================

local function cloneForViewport(object)

	if not object or not object.Parent then
		return nil
	end

	local clone

	local success = pcall(function()
		clone = object:Clone()
	end)

	if not success or not clone then
		return nil
	end

	for _, item in ipairs(clone:GetDescendants()) do

		if item:IsA("Script")
			or item:IsA("LocalScript")
			or item:IsA("ModuleScript")
			or item:IsA("ProximityPrompt")
			or item:IsA("Highlight") then

			item:Destroy()

		end

	end

	return clone
end

--==================================================
-- CREATE / REFRESH OBJECT ICON
--==================================================

local function createObjectIcon(object)

	local entry = iconEntries[object]

	if not object or not object.Parent then
		return
	end

	local targetPart = getTargetPart(object)

	if not targetPart then
		return
	end

	if not entry then

		local card = Instance.new("Frame")
		card.Name = "ObjectCard"
		card.Size = UDim2.new(0, 125, 0, 150)
		card.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		card.BorderSizePixel = 0
		card.Parent = iconScroll

		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 9)
		cardCorner.Parent = card

		local viewport = Instance.new("ViewportFrame")
		viewport.Name = "ObjectPreview"
		viewport.Size = UDim2.new(1, -10, 0, 105)
		viewport.Position = UDim2.new(0, 5, 0, 5)
		viewport.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
		viewport.BorderSizePixel = 0
		viewport.Parent = card

		local viewportCorner = Instance.new("UICorner")
		viewportCorner.CornerRadius = UDim.new(0, 7)
		viewportCorner.Parent = viewport

		local camera = Instance.new("Camera")
		camera.Parent = viewport
		viewport.CurrentCamera = camera

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -8, 0, 32)
		nameLabel.Position = UDim2.new(0, 4, 0, 112)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextSize = 13
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextWrapped = true
		nameLabel.Parent = card

		entry = {
			Card = card,
			Viewport = viewport,
			Camera = camera,
			NameLabel = nameLabel,
			LastRefresh = 0
		}

		iconEntries[object] = entry

	end

	entry.NameLabel.Text = object.Name

	-- Refresh the preview from the CURRENT game object
	if tick() - entry.LastRefresh >= 1 then

		entry.LastRefresh = tick()

		for _, child in ipairs(entry.Viewport:GetChildren()) do

			if not child:IsA("Camera") then
				child:Destroy()
			end

		end

		local clone = cloneForViewport(object)

		if clone then

			clone.Parent = entry.Viewport

			local previewPart

			if clone:IsA("BasePart") then

				previewPart = clone

			elseif clone:IsA("Model") then

				previewPart =
					clone.PrimaryPart
					or clone:FindFirstChildWhichIsA(
						"BasePart",
						true
					)

			end

			if previewPart then

				local size

				if clone:IsA("Model") then

					local _, modelSize =
						clone:GetBoundingBox()

					size = modelSize

				else

					size = previewPart.Size

				end

				local biggest =
					math.max(
						size.X,
						size.Y,
						size.Z
					)

				local distance =
					math.max(biggest * 2.5, 3)

				entry.Camera.CFrame =
					CFrame.lookAt(
						previewPart.Position
							+ Vector3.new(
								distance,
								distance * 0.5,
								distance
							),
						previewPart.Position
					)

			end

		end

	end

end

--==================================================
-- REMOVE ICON
--==================================================

local function removeObjectIcon(object)

	local entry = iconEntries[object]

	if entry then

		if entry.Card then
			entry.Card:Destroy()
		end

		iconEntries[object] = nil

	end

end

--==================================================
-- UPDATE ICONS
--==================================================

local function updateObjectIcons()

	for object in pairs(objectESPObjects) do

		if object and object.Parent then

			createObjectIcon(object)

		else

			removeObjectIcon(object)

		end

	end

	for object in pairs(iconEntries) do

		if not objectESPObjects[object] then
			removeObjectIcon(object)
		end

	end

end

iconLayout:GetPropertyChangedSignal(
	"AbsoluteContentSize"
):Connect(function()

	iconScroll.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			iconLayout.AbsoluteContentSize.Y + 10
		)

end)

--==================================================
-- NEW OBJECTS
--==================================================

Workspace.DescendantAdded:Connect(function(obj)

	if obj:IsA("ProximityPrompt") then

		task.wait()

		if objectESP then
			updateObjectESP()
			updateObjectIcons()
		end

	end

end)

--==================================================
-- NEW PLAYERS
--==================================================

Players.PlayerAdded:Connect(function(plr)

	plr.CharacterAdded:Connect(function(character)

		task.wait(0.5)

		if playerESP then

			createESP(
				character,
				true,
				plr.Name
			)

		end

	end)

end)

Players.PlayerRemoving:Connect(function(plr)

	if plr.Character then

		removeESP(
			plr.Character,
			true
		)

	end

end)

--==================================================
-- ESP UI LANES
--==================================================

local playerLane = Instance.new("Frame")
playerLane.Name = "PlayerLane"
playerLane.Size = UDim2.new(0.48, 0, 0, 160)
playerLane.Position = UDim2.new(0, 0, 0, 0)
playerLane.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
playerLane.BorderSizePixel = 0
playerLane.Parent = espPage

local playerLaneCorner = Instance.new("UICorner")
playerLaneCorner.CornerRadius = UDim.new(0, 10)
playerLaneCorner.Parent = playerLane

local objectLane = Instance.new("Frame")
objectLane.Name = "ObjectLane"
objectLane.Size = UDim2.new(0.48, 0, 0, 160)
objectLane.Position = UDim2.new(0.52, 0, 0, 0)
objectLane.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
objectLane.BorderSizePixel = 0
objectLane.Parent = espPage

local objectLaneCorner = Instance.new("UICorner")
objectLaneCorner.CornerRadius = UDim.new(0, 10)
objectLaneCorner.Parent = objectLane

--==================================================
-- LANE TITLES
--==================================================

local playerTitle = Instance.new("TextLabel")
playerTitle.Size = UDim2.new(1, 0, 0, 35)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = "👤 PLAYERS"
playerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTitle.TextSize = 16
playerTitle.Font = Enum.Font.GothamBold
playerTitle.Parent = playerLane

local objectTitle = Instance.new("TextLabel")
objectTitle.Size = UDim2.new(1, 0, 0, 35)
objectTitle.BackgroundTransparency = 1
objectTitle.Text = "📦 OBJECTS"
objectTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
objectTitle.TextSize = 16
objectTitle.Font = Enum.Font.GothamBold
objectTitle.Parent = objectLane

--==================================================
-- ESP BUTTON CREATOR
--==================================================

local function makeESPButton(parent, y, text)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 45)
	button.Position = UDim2.new(0, 10, 0, y)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	return button

end

--==================================================
-- PLAYER COMMANDS
--==================================================

local playerESPButton = makeESPButton(
	playerLane,
	40,
	"Player ESP: ON"
)

local playerLineButton = makeESPButton(
	playerLane,
	95,
	"Direction Lines: ON"
)

--==================================================
-- OBJECT COMMANDS
--==================================================

local objectESPButton = makeESPButton(
	objectLane,
	40,
	"Grab/Object ESP: ON"
)

local objectLineButton = makeESPButton(
	objectLane,
	95,
	"Direction Lines: ON"
)

--==================================================
-- PLAYER ESP TOGGLE
--==================================================

playerESPButton.MouseButton1Click:Connect(function()

	playerESP = not playerESP

	playerESPButton.Text =
		"Player ESP: " ..
		(playerESP and "ON" or "OFF")

	if playerESP then

		updatePlayerESP()

	else

		for object in pairs(
			playerESPObjects
		) do

			removeESP(
				object,
				true
			)

		end

	end

end)

--==================================================
-- PLAYER DIRECTION TOGGLE
--==================================================

playerLineButton.MouseButton1Click:Connect(function()

	playerDirectionLines =
		not playerDirectionLines

	playerLineButton.Text =
		"Direction Lines: " ..
		(playerDirectionLines and "ON" or "OFF")

	for _, data in pairs(
		playerESPObjects
	) do

		if data.Beam then
			data.Beam.Enabled =
				playerDirectionLines
		end

	end

end)

--==================================================
-- OBJECT ESP TOGGLE
--==================================================

objectESPButton.MouseButton1Click:Connect(function()

	objectESP = not objectESP

	objectESPButton.Text =
		"Grab/Object ESP: " ..
		(objectESP and "ON" or "OFF")

	if objectESP then

		updateObjectESP()
		updateObjectIcons()

	else

		for object in pairs(
			objectESPObjects
		) do

			removeESP(
				object,
				false
			)

		end

		for object in pairs(iconEntries) do
			removeObjectIcon(object)
		end

	end

end)

--==================================================
-- OBJECT DIRECTION TOGGLE
--==================================================

objectLineButton.MouseButton1Click:Connect(function()

	objectDirectionLines =
		not objectDirectionLines

	objectLineButton.Text =
		"Direction Lines: " ..
		(objectDirectionLines and "ON" or "OFF")

	for _, data in pairs(
		objectESPObjects
	) do

		if data.Beam then
			data.Beam.Enabled =
				objectDirectionLines
		end

	end

end)

--==================================================
-- ESP REFRESH
--==================================================

task.spawn(function()

	while gui.Parent do

		if playerESP then
			updatePlayerESP()
		end

		if objectESP then
			updateObjectESP()
			updateObjectIcons()
		end

		task.wait(1)

	end

end)

--==================================================
-- TABS
--==================================================

characterTab.MouseButton1Click:Connect(function()

	characterPage.Visible = true
	espPage.Visible = false
	iconsPage.Visible = false

	characterTab.BackgroundColor3 =
		Color3.fromRGB(60, 60, 70)

	espTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

	iconsTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

end)

espTab.MouseButton1Click:Connect(function()

	characterPage.Visible = false
	espPage.Visible = true
	iconsPage.Visible = false

	characterTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

	espTab.BackgroundColor3 =
		Color3.fromRGB(60, 60, 70)

	iconsTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

end)

iconsTab.MouseButton1Click:Connect(function()

	characterPage.Visible = false
	espPage.Visible = false
	iconsPage.Visible = true

	characterTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

	espTab.BackgroundColor3 =
		Color3.fromRGB(45, 45, 50)

	iconsTab.BackgroundColor3 =
		Color3.fromRGB(60, 60, 70)

	updateObjectIcons()

end)

--==================================================
-- Y BUTTON
--==================================================

local toggle = Instance.new("TextButton")
toggle.Name = "YButton"
toggle.Size = UDim2.new(0, 55, 0, 55)
toggle.Position = UDim2.new(0, 20, 0.5, -27)
toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
toggle.Text = "Y"
toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextSize = 30
toggle.Font = Enum.Font.GothamBlack
toggle.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggle

--==================================================
-- LOCK
--==================================================

local lock = Instance.new("TextButton")
lock.Name = "LockButton"
lock.Size = UDim2.new(0, 35, 0, 35)
lock.Position = UDim2.new(0, 80, 0.5, -17)
lock.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
lock.Text = "🔓"
lock.TextSize = 18
lock.Parent = gui

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 9)
lockCorner.Parent = lock

local locked = false

lock.MouseButton1Click:Connect(function()

	locked = not locked
	lock.Text = locked and "🔒" or "🔓"

end)

--==================================================
-- SHOW / HIDE
--==================================================

toggle.MouseButton1Click:Connect(function()

	dashboard.Visible =
		not dashboard.Visible

end)

--==================================================
-- Y BUTTON DRAG
--==================================================

local dragging = false
local dragStart
local startPos

toggle.InputBegan:Connect(function(input)

	if locked then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = toggle.Position

	end

end)

toggle.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if locked or not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - dragStart

		toggle.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		lock.Position = UDim2.new(
			toggle.Position.X.Scale,
			toggle.Position.X.Offset + 60,
			toggle.Position.Y.Scale,
			toggle.Position.Y.Offset + 10
		)

	end

end)

--==================================================
-- DASHBOARD DRAG
--==================================================

local dashboardDragging = false
local dashboardDragStart
local dashboardStartPos

title.Active = true

title.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dashboardDragging = true
		dashboardDragStart = input.Position
		dashboardStartPos = dashboard.Position

	end

end)

title.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dashboardDragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dashboardDragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - dashboardDragStart

		dashboard.Position = UDim2.new(
			dashboardStartPos.X.Scale,
			dashboardStartPos.X.Offset + delta.X,
			dashboardStartPos.Y.Scale,
			dashboardStartPos.Y.Offset + delta.Y
		)

	end

end)

--==================================================
-- DASHBOARD RESIZE HANDLE
--==================================================

local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 28, 0, 28)
resizeHandle.Position = UDim2.new(1, -28, 1, -28)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(150, 150, 150)
resizeHandle.TextSize = 18
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.Parent = dashboard

local resizing = false
local resizeStart
local resizeStartSize

resizeHandle.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		resizing = true
		resizeStart = input.Position
		resizeStartSize = dashboard.Size

	end

end)

resizeHandle.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		resizing = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not resizing then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - resizeStart

		local newWidth = math.max(
			400,
			resizeStartSize.X.Offset + delta.X
		)

		local newHeight = math.max(
			300,
			resizeStartSize.Y.Offset + delta.Y
		)

		dashboard.Size = UDim2.new(
			0,
			newWidth,
			0,
			newHeight
		)

	end

end)
