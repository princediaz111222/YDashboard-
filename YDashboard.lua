--// Y Dashboard - Advanced Client Inspector

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
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Y Dashboard • Client Inspector"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.Parent = Dashboard

--==================================================
-- FILTER CREATOR
--==================================================

local function CreateFilter(Name, Placeholder, Position)

	local Box = Instance.new("TextBox")

	Box.Name = Name
	Box.Size = UDim2.new(0, 250, 0, 30)
	Box.Position = Position

	Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

	Box.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	Box.PlaceholderColor3 =
		Color3.fromRGB(125, 125, 125)

	Box.PlaceholderText = Placeholder

	Box.Text = ""

	Box.TextSize = 11
	Box.Font = Enum.Font.Gotham

	Box.ClearTextOnFocus = false

	Box.TextXAlignment =
		Enum.TextXAlignment.Left

	Box.Parent = Dashboard

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Box

	return Box

end

--==================================================
-- FILTERS
--==================================================

local NameFilter =
	CreateFilter(
		"NameFilter",
		"Name contains...",
		UDim2.new(0, 20, 0, 60)
	)

local ClassFilter =
	CreateFilter(
		"ClassFilter",
		"Class contains... (Model, Folder, Part)",
		UDim2.new(0, 20, 0, 96)
	)

local PathFilter =
	CreateFilter(
		"PathFilter",
		"Path contains...",
		UDim2.new(0, 20, 0, 132)
	)

local AttributeFilter =
	CreateFilter(
		"AttributeFilter",
		"Attribute name/value contains...",
		UDim2.new(0, 20, 0, 168)
	)

local TagFilter =
	CreateFilter(
		"TagFilter",
		"Tag contains...",
		UDim2.new(0, 20, 0, 204)
	)

local ValueFilter =
	CreateFilter(
		"ValueFilter",
		"Value contains...",
		UDim2.new(0, 20, 0, 240)
	)

--==================================================
-- SORT BUTTON
--==================================================

local SortButton = Instance.new("TextButton")
SortButton.Name = "SortButton"
SortButton.Size = UDim2.new(0, 250, 0, 30)
SortButton.Position = UDim2.new(0, 20, 0, 276)

SortButton.BackgroundColor3 =
	Color3.fromRGB(45, 45, 45)

SortButton.TextColor3 =
	Color3.fromRGB(235, 235, 235)

SortButton.Text =
	"Sort: Name A-Z"

SortButton.TextSize = 11
SortButton.Font = Enum.Font.Gotham

SortButton.Parent = Dashboard

local SortCorner = Instance.new("UICorner")
SortCorner.CornerRadius = UDim.new(0, 6)
SortCorner.Parent = SortButton

--==================================================
-- RESULTS
--==================================================

local Results = Instance.new("ScrollingFrame")
Results.Name = "Results"
Results.Size = UDim2.new(0, 250, 0, 130)
Results.Position = UDim2.new(0, 20, 0, 312)

Results.BackgroundColor3 =
	Color3.fromRGB(20, 20, 20)

Results.BorderSizePixel = 0
Results.ScrollBarThickness = 5

Results.CanvasSize =
	UDim2.new(0, 0, 0, 0)

Results.Parent = Dashboard

local ResultsCorner = Instance.new("UICorner")
ResultsCorner.CornerRadius = UDim.new(0, 8)
ResultsCorner.Parent = Results

local ResultsLayout = Instance.new("UIListLayout")
ResultsLayout.Padding = UDim.new(0, 3)
ResultsLayout.Parent = Results

--==================================================
-- INFORMATION BOX
--==================================================

local Info = Instance.new("TextBox")
Info.Name = "Info"

Info.Size =
	UDim2.new(0, 390, 0, 382)

Info.Position =
	UDim2.new(0, 290, 0, 60)

Info.BackgroundColor3 =
	Color3.fromRGB(20, 20, 20)

Info.TextColor3 =
	Color3.fromRGB(230, 230, 230)

Info.PlaceholderColor3 =
	Color3.fromRGB(120, 120, 120)

Info.PlaceholderText =
	"Select an object to inspect it."

Info.Text = ""

Info.TextSize = 12
Info.Font = Enum.Font.Code

Info.TextXAlignment =
	Enum.TextXAlignment.Left

Info.TextYAlignment =
	Enum.TextYAlignment.Top

Info.MultiLine = true
Info.ClearTextOnFocus = false
Info.TextEditable = false

Info.Parent = Dashboard

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = Info

--==================================================
-- OBJECT CACHE
--==================================================

local InspectableObjects = {}

--==================================================
-- CLEAR RESULTS
--==================================================

local function ClearResults()

	for _, Child in ipairs(Results:GetChildren()) do

		if Child:IsA("TextButton")
			or Child:IsA("TextLabel") then

			Child:Destroy()

		end

	end

end

--==================================================
-- GET ATTRIBUTE SEARCH TEXT
--==================================================

local function GetAttributeText(Object)

	local Parts = {}

	for Name, Value in pairs(
		Object:GetAttributes()
	) do

		table.insert(
			Parts,
			tostring(Name)
		)

		table.insert(
			Parts,
			tostring(Value)
		)

	end

	return string.lower(
		table.concat(Parts, " ")
	)

end

--==================================================
-- GET TAG SEARCH TEXT
--==================================================

local function GetTagText(Object)

	local Tags =
		CollectionService:GetTags(Object)

	return string.lower(
		table.concat(Tags, " ")
	)

end

--==================================================
-- GET VALUE SEARCH TEXT
--==================================================

local function GetValueText(Object)

	if Object:IsA("ValueBase") then

		return string.lower(
			tostring(Object.Value)
		)

	end

	return ""

end

--==================================================
-- CHECK FILTER
--==================================================

local function MatchesFilter(Object, Filter, Text)

	if Text == "" then
		return true
	end

	return string.find(
		Filter,
		Text,
		1,
		true
	) ~= nil

end

--==================================================
-- OBJECT MATCHING
--==================================================

local function ObjectMatches(Object)

	local Name =
		string.lower(Object.Name)

	local Class =
		string.lower(Object.ClassName)

	local Path =
		string.lower(Object:GetFullName())

	local Attributes =
		GetAttributeText(Object)

	local Tags =
		GetTagText(Object)

	local Value =
		GetValueText(Object)

	local NameSearch =
		string.lower(NameFilter.Text)

	local ClassSearch =
		string.lower(ClassFilter.Text)

	local PathSearch =
		string.lower(PathFilter.Text)

	local AttributeSearch =
		string.lower(AttributeFilter.Text)

	local TagSearch =
		string.lower(TagFilter.Text)

	local ValueSearch =
		string.lower(ValueFilter.Text)

	-- NAME

	if not MatchesFilter(
		Object,
		Name,
		NameSearch
	) then

		return false

	end

	-- CLASS

	if not MatchesFilter(
		Object,
		Class,
		ClassSearch
	) then

		return false

	end

	-- PATH

	if not MatchesFilter(
		Object,
		Path,
		PathSearch
	) then

		return false

	end

	-- ATTRIBUTES

	if not MatchesFilter(
		Object,
		Attributes,
		AttributeSearch
	) then

		return false

	end

	-- TAGS

	if not MatchesFilter(
		Object,
		Tags,
		TagSearch
	) then

		return false

	end

	-- VALUE

	if not MatchesFilter(
		Object,
		Value,
		ValueSearch
	) then

		return false

	end

	return true

end

--==================================================
-- INSPECT OBJECT
--==================================================

local function InspectObject(Object)

	local Lines = {}

	table.insert(Lines, "================================")
	table.insert(Lines, "        OBJECT INSPECTOR")
	table.insert(Lines, "================================")
	table.insert(Lines, "")

	table.insert(Lines, "NAME")
	table.insert(Lines, Object.Name)
	table.insert(Lines, "")

	table.insert(Lines, "CLASS")
	table.insert(Lines, Object.ClassName)
	table.insert(Lines, "")

	table.insert(Lines, "PATH")
	table.insert(Lines, Object:GetFullName())
	table.insert(Lines, "")

	--==================================================
	-- VALUE
	--==================================================

	if Object:IsA("ValueBase") then

		table.insert(
			Lines,
			"VALUE"
		)

		table.insert(
			Lines,
			tostring(Object.Value)
		)

		table.insert(Lines, "")

	end

	--==================================================
	-- ATTRIBUTES
	--==================================================

	table.insert(
		Lines,
		"================================"
	)

	table.insert(
		Lines,
		"ATTRIBUTES"
	)

	table.insert(
		Lines,
		"================================"
	)

	local Attributes =
		Object:GetAttributes()

	if next(Attributes) == nil then

		table.insert(
			Lines,
			"(none)"
		)

	else

		for Name, Value in pairs(
			Attributes
		) do

			table.insert(
				Lines,
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

	table.insert(Lines, "")

	--==================================================
	-- TAGS
	--==================================================

	table.insert(
		Lines,
		"================================"
	)

	table.insert(
		Lines,
		"TAGS"
	)

	table.insert(
		Lines,
		"================================"
	)

	local Tags =
		CollectionService:GetTags(Object)

	if #Tags == 0 then

		table.insert(
			Lines,
			"(none)"
		)

	else

		for _, Tag in ipairs(Tags) do

			table.insert(
				Lines,
				Tag
			)

		end

	end

	table.insert(Lines, "")

	--==================================================
	-- CHILDREN
	--==================================================

	table.insert(
		Lines,
		"================================"
	)

	table.insert(
		Lines,
		"CHILDREN"
	)

	table.insert(
		Lines,
		"================================"
	)

	local Children =
		Object:GetChildren()

	if #Children == 0 then

		table.insert(
			Lines,
			"(none)"
		)

	else

		for _, Child in ipairs(Children) do

			table.insert(
				Lines,
				Child.Name ..
				" [" ..
				Child.ClassName ..
				"]"
			)

			if Child:IsA("ValueBase") then

				table.insert(
					Lines,
					"    VALUE = " ..
					tostring(Child.Value)
				)

			end

			for Name, Value in pairs(
				Child:GetAttributes()
			) do

				table.insert(
					Lines,
					"    @" ..
					Name ..
					" = " ..
					tostring(Value)
				)

			end

		end

	end

	Info.Text =
		table.concat(Lines, "\n")

end

--==================================================
-- ADD RESULT
--==================================================

local function AddResult(Object)

	local Button =
		Instance.new("TextButton")

	Button.Size =
		UDim2.new(1, -10, 0, 32)

	Button.BackgroundColor3 =
		Color3.fromRGB(40, 40, 40)

	Button.TextColor3 =
		Color3.fromRGB(235, 235, 235)

	Button.TextSize = 10
	Button.Font = Enum.Font.Gotham

	Button.TextXAlignment =
		Enum.TextXAlignment.Left

	Button.TextTruncate =
		Enum.TextTruncate.AtEnd

	Button.Text =
		"  " ..
		Object.Name ..
		" [" ..
		Object.ClassName ..
		"]"

	Button.Parent = Results

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 6)

	Corner.Parent = Button

	Button.MouseButton1Click:Connect(
		function()

			InspectObject(Object)

		end
	)

end

--==================================================
-- SORT SYSTEM
--==================================================

local SortModes = {
	"Name A-Z",
	"Name Z-A",
	"Class A-Z",
	"Path A-Z",
	"Children Most",
	"Children Least"
}

local SortIndex = 1

local function SortObjects(List)

	local Mode =
		SortModes[SortIndex]

	table.sort(
		List,
		function(A, B)

			if Mode == "Name A-Z" then

				return string.lower(A.Name)
					< string.lower(B.Name)

			elseif Mode == "Name Z-A" then

				return string.lower(A.Name)
					> string.lower(B.Name)

			elseif Mode == "Class A-Z" then

				return string.lower(A.ClassName)
					< string.lower(B.ClassName)

			elseif Mode == "Path A-Z" then

				return string.lower(A:GetFullName())
					< string.lower(B:GetFullName())

			elseif Mode == "Children Most" then

				return #A:GetChildren()
					> #B:GetChildren()

			elseif Mode == "Children Least" then

				return #A:GetChildren()
					< #B:GetChildren()

			end

			return false

		end
	)

end

--==================================================
-- SEARCH
--==================================================

local function Search()

	ClearResults()

	local Matches = {}

	for _, Object in ipairs(
		InspectableObjects
	) do

		if Object.Parent
			and ObjectMatches(Object) then

			table.insert(
				Matches,
				Object
			)

		end

	end

	SortObjects(Matches)

	-- Keep UI responsive

	local Limit = math.min(
		#Matches,
		100
	)

	for Index = 1, Limit do

		AddResult(
			Matches[Index]
		)

	end

	Results.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			ResultsLayout.AbsoluteContentSize.Y + 5
		)

	SortButton.Text =
		"Sort: " ..
		SortModes[SortIndex] ..
		" • " ..
		tostring(#Matches) ..
		" matches"

end

--==================================================
-- SCAN CLIENT OBJECTS
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
		"[YDashboard] Client objects:",
		#InspectableObjects
	)

end

ScanInspectableObjects()

--==================================================
-- LIVE FILTERING
--==================================================

local Filters = {
	NameFilter,
	ClassFilter,
	PathFilter,
	AttributeFilter,
	TagFilter,
	ValueFilter
}

for _, Filter in ipairs(Filters) do

	Filter:GetPropertyChangedSignal(
		"Text"
	):Connect(function()

		Search()

	end)

end

--==================================================
-- SORT BUTTON
--==================================================

SortButton.MouseButton1Click:Connect(
	function()

		SortIndex += 1

		if SortIndex > #SortModes then
			SortIndex = 1
		end

		Search()

	end
)

--==================================================
-- LOCK SYSTEM
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
-- DASHBOARD TOGGLE
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

			DragStartY =
				Input.Position

			StartPosY =
				YButton.Position

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

			DragStartDashboard =
				Input.Position

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

		-- Y BUTTON

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

		-- DASHBOARD

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
