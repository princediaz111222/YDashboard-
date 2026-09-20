--// Y DASHBOARD

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer


--==================================================
-- GUI
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
-- TABS
--==================================================

local function CreateTab(Name, Text, X)
    local Button = Instance.new("TextButton")

    Button.Name = Name
    Button.Size = UDim2.new(0, 125, 0, 40)
    Button.Position = UDim2.new(0, X, 0, 60)
    Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Dashboard

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    return Button
end

local CharacterTab = CreateTab("CharacterTab", "CHARACTER", 15)
local DataTab = CreateTab("DataTab", "DATA", 145)
local PetsTab = CreateTab("PetsTab", "PETS", 275)
local ClientTab = CreateTab("ClientTab", "CLIENT", 405)


--==================================================
-- PAGES
--==================================================

local function CreatePage(Name)
    local Page = Instance.new("Frame")

    Page.Name = Name
    Page.Size = UDim2.new(1, -30, 1, -115)
    Page.Position = UDim2.new(0, 15, 0, 110)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Dashboard

    return Page
end

local CharacterPage = CreatePage("CharacterPage")
local DataPage = CreatePage("DataPage")
local PetsPage = CreatePage("PetsPage")
local ClientPage = CreatePage("ClientPage")


--==================================================
-- CHARACTER PAGE
--==================================================

local CharacterTitle = Instance.new("TextLabel")
CharacterTitle.Size = UDim2.new(1, 0, 0, 35)
CharacterTitle.BackgroundTransparency = 1
CharacterTitle.Text = "CHARACTER"
CharacterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CharacterTitle.TextSize = 18
CharacterTitle.Font = Enum.Font.GothamBold
CharacterTitle.TextXAlignment = Enum.TextXAlignment.Left
CharacterTitle.Parent = CharacterPage


local InstantInteractButton = Instance.new("TextButton")
InstantInteractButton.Name = "InstantInteract"
InstantInteractButton.Size = UDim2.new(0, 250, 0, 45)
InstantInteractButton.Position = UDim2.new(0, 0, 0, 45)
InstantInteractButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InstantInteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantInteractButton.TextSize = 15
InstantInteractButton.Font = Enum.Font.Gotham
InstantInteractButton.Text = "Instant Interact: ON"
InstantInteractButton.Parent = CharacterPage

local InstantCorner = Instance.new("UICorner")
InstantCorner.CornerRadius = UDim.new(0, 8)
InstantCorner.Parent = InstantInteractButton


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

local DataTitle = Instance.new("TextLabel")
DataTitle.Size = UDim2.new(1, 0, 0, 35)
DataTitle.BackgroundTransparency = 1
DataTitle.Text = "DATA"
DataTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DataTitle.TextSize = 18
DataTitle.Font = Enum.Font.GothamBold
DataTitle.TextXAlignment = Enum.TextXAlignment.Left
DataTitle.Parent = DataPage


local EggStatus = Instance.new("TextLabel")
EggStatus.Size = UDim2.new(1, 0, 0, 30)
EggStatus.Position = UDim2.new(0, 0, 0, 35)
EggStatus.BackgroundTransparency = 1
EggStatus.Text = "Egg scanner ready"
EggStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
EggStatus.TextSize = 13
EggStatus.Font = Enum.Font.Gotham
EggStatus.TextXAlignment = Enum.TextXAlignment.Left
EggStatus.Parent = DataPage


local EggCount = Instance.new("TextLabel")
EggCount.Size = UDim2.new(1, 0, 0, 30)
EggCount.Position = UDim2.new(0, 0, 0, 60)
EggCount.BackgroundTransparency = 1
EggCount.Text = "Eggs found: 0"
EggCount.TextColor3 = Color3.fromRGB(255, 255, 255)
EggCount.TextSize = 14
EggCount.Font = Enum.Font.Gotham
EggCount.TextXAlignment = Enum.TextXAlignment.Left
EggCount.Parent = DataPage


local EggList = Instance.new("ScrollingFrame")
EggList.Size = UDim2.new(0, 250, 0, 180)
EggList.Position = UDim2.new(0, 0, 0, 90)
EggList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EggList.BorderSizePixel = 0
EggList.ScrollBarThickness = 6
EggList.Parent = DataPage

local EggLayout = Instance.new("UIListLayout")
EggLayout.Padding = UDim.new(0, 3)
EggLayout.Parent = EggList


local function ScanEggs()

    for _, child in ipairs(EggList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local Found = {}
    local Count = 0

    for _, object in ipairs(workspace:GetDescendants()) do

        local Name = string.lower(object.Name)

        if string.find(Name, "egg", 1, true) then

            if not Found[object.Name] then

                Found[object.Name] = true
                Count += 1

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -5, 0, 30)
                Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Text =
                    "  " ..
                    object.Name ..
                    " [" ..
                    object.ClassName ..
                    "]"
                Label.Parent = EggList
            end
        end
    end

    EggCount.Text = "Eggs found: " .. Count
    EggStatus.Text = "Scan complete"

    EggList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        EggLayout.AbsoluteContentSize.Y + 10
    )
end


local RefreshEggs = Instance.new("TextButton")
RefreshEggs.Size = UDim2.new(0, 250, 0, 40)
RefreshEggs.Position = UDim2.new(0, 270, 0, 90)
RefreshEggs.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshEggs.Text = "REFRESH EGGS"
RefreshEggs.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshEggs.TextSize = 14
RefreshEggs.Font = Enum.Font.GothamBold
RefreshEggs.Parent = DataPage

local RefreshEggCorner = Instance.new("UICorner")
RefreshEggCorner.CornerRadius = UDim.new(0, 8)
RefreshEggCorner.Parent = RefreshEggs

RefreshEggs.MouseButton1Click:Connect(ScanEggs)


--==================================================
-- DATA INSPECTOR
--==================================================

local InspectButton = Instance.new("TextButton")
InspectButton.Size = UDim2.new(0, 250, 0, 40)
InspectButton.Position = UDim2.new(0, 270, 0, 140)
InspectButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InspectButton.Text = "INSPECT REPLICATED DATA"
InspectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InspectButton.TextSize = 13
InspectButton.Font = Enum.Font.GothamBold
InspectButton.Parent = DataPage

local InspectCorner = Instance.new("UICorner")
InspectCorner.CornerRadius = UDim.new(0, 8)
InspectCorner.Parent = InspectButton


InspectButton.MouseButton1Click:Connect(function()

    print("")
    print("========== Y DASHBOARD DATA ==========")

    local Paths = {
        "Shared.Types.AssetItem",
        "Shared.Types.ActiveAssets",
        "Shared.Types.Index",
        "Shared.Util.AssetItems",
        "Shared.Util.AssetEarnings",
        "Shared.Modules.ItemDisplay",
        "Shared.Modules.AssetInfoBillboard",
        "Shared.Modules.CoreProfileManager"
    }

    for _, Path in ipairs(Paths) do

        print("")
        print("========== " .. Path .. " ==========")

        local Object = ReplicatedStorage

        for Part in Path:gmatch("[^%.]+") do
            Object = Object:FindFirstChild(Part)

            if not Object then
                break
            end
        end

        if Object then

            print("Class:", Object.ClassName)
            print("Path:", Object:GetFullName())

            print("-- ATTRIBUTES --")

            for Name, Value in pairs(Object:GetAttributes()) do
                print(
                    Name ..
                    " = " ..
                    tostring(Value)
                )
            end

            print("-- CHILDREN --")

            for _, Child in ipairs(Object:GetChildren()) do

                print(
                    Child.Name ..
                    " | " ..
                    Child.ClassName
                )

                if Child:IsA("ValueBase") then
                    print(
                        "VALUE =",
                        Child.Value
                    )
                end
            end

        else
            print("NOT FOUND")
        end
    end

    print("======================================")
end)


--==================================================
-- TERMINATE
--==================================================

local TerminateButton = Instance.new("TextButton")
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

local PetsTitle = Instance.new("TextLabel")
PetsTitle.Size = UDim2.new(1, 0, 0, 35)
PetsTitle.BackgroundTransparency = 1
PetsTitle.Text = "PETS"
PetsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PetsTitle.TextSize = 18
PetsTitle.Font = Enum.Font.GothamBold
PetsTitle.TextXAlignment = Enum.TextXAlignment.Left
PetsTitle.Parent = PetsPage


local PetsStatus = Instance.new("TextLabel")
PetsStatus.Size = UDim2.new(1, 0, 0, 30)
PetsStatus.Position = UDim2.new(0, 0, 0, 35)
PetsStatus.BackgroundTransparency = 1
PetsStatus.Text = "Pet scanner ready"
PetsStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
PetsStatus.TextSize = 13
PetsStatus.Font = Enum.Font.Gotham
PetsStatus.TextXAlignment = Enum.TextXAlignment.Left
PetsStatus.Parent = PetsPage


local PetsList = Instance.new("ScrollingFrame")
PetsList.Size = UDim2.new(1, 0, 0, 180)
PetsList.Position = UDim2.new(0, 0, 0, 70)
PetsList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PetsList.BorderSizePixel = 0
PetsList.ScrollBarThickness = 6
PetsList.Parent = PetsPage

local PetsLayout = Instance.new("UIListLayout")
PetsLayout.Padding = UDim.new(0, 3)
PetsLayout.Parent = PetsList


local function InspectPets()

    for _, Child in ipairs(PetsList:GetChildren()) do
        if Child:IsA("TextLabel") then
            Child:Destroy()
        end
    end

    local Found = 0

    for _, Object in ipairs(workspace:GetDescendants()) do

        local Name = string.lower(Object.Name)

        local LooksLikePet =
            Name:find("pet", 1, true)
            or Name:find("cat", 1, true)
            or Name:find("dog", 1, true)
            or Name:find("dragon", 1, true)

        if LooksLikePet then

            Found += 1

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -5, 0, 35)
            Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Text =
                "  " ..
                Object.Name ..
                " [" ..
                Object.ClassName ..
                "]"
            Label.Parent = PetsList

        end
    end

    PetsStatus.Text =
        "Pet objects found: " .. Found

    PetsList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        PetsLayout.AbsoluteContentSize.Y + 10
    )
end


local RefreshPets = Instance.new("TextButton")
RefreshPets.Size = UDim2.new(0, 200, 0, 40)
RefreshPets.Position = UDim2.new(0, 0, 1, -45)
RefreshPets.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshPets.Text = "SCAN PETS"
RefreshPets.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshPets.TextSize = 14
RefreshPets.Font = Enum.Font.GothamBold
RefreshPets.Parent = PetsPage

local PetsRefreshCorner = Instance.new("UICorner")
PetsRefreshCorner.CornerRadius = UDim.new(0, 8)
PetsRefreshCorner.Parent = RefreshPets

RefreshPets.MouseButton1Click:Connect(InspectPets)


--==================================================
-- CLIENT PAGE
--==================================================

local ClientTitle = Instance.new("TextLabel")
ClientTitle.Size = UDim2.new(1, 0, 0, 35)
ClientTitle.BackgroundTransparency = 1
ClientTitle.Text = "CLIENT EXPLORER"
ClientTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ClientTitle.TextSize = 18
ClientTitle.Font = Enum.Font.GothamBold
ClientTitle.TextXAlignment = Enum.TextXAlignment.Left
ClientTitle.Parent = ClientPage


local ClientStatus = Instance.new("TextLabel")
ClientStatus.Size = UDim2.new(1, 0, 0, 25)
ClientStatus.Position = UDim2.new(0, 0, 0, 35)
ClientStatus.BackgroundTransparency = 1
ClientStatus.Text = "Press SCAN CLIENT"
ClientStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
ClientStatus.TextSize = 12
ClientStatus.Font = Enum.Font.Gotham
ClientStatus.TextXAlignment = Enum.TextXAlignment.Left
ClientStatus.Parent = ClientPage


-- SEARCH BAR

local ClientSearch = Instance.new("TextBox")
ClientSearch.Name = "ClientSearch"
ClientSearch.Size = UDim2.new(1, 0, 0, 40)
ClientSearch.Position = UDim2.new(0, 0, 0, 60)
ClientSearch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ClientSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
ClientSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ClientSearch.PlaceholderText = "Search client objects..."
ClientSearch.Text = ""
ClientSearch.TextSize = 14
ClientSearch.Font = Enum.Font.Gotham
ClientSearch.ClearTextOnFocus = false
ClientSearch.Parent = ClientPage

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = ClientSearch


-- OBJECT LIST

local ClientList = Instance.new("ScrollingFrame")
ClientList.Name = "ClientList"
ClientList.Size = UDim2.new(1, 0, 0, 180)
ClientList.Position = UDim2.new(0, 0, 0, 105)
ClientList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ClientList.BorderSizePixel = 0
ClientList.ScrollBarThickness = 6
ClientList.CanvasSize = UDim2.new(0, 0, 0, 0)
ClientList.Parent = ClientPage

local ClientListCorner = Instance.new("UICorner")
ClientListCorner.CornerRadius = UDim.new(0, 8)
ClientListCorner.Parent = ClientList


local ClientLayout = Instance.new("UIListLayout")
ClientLayout.Padding = UDim.new(0, 4)
ClientLayout.Parent = ClientList


-- SCAN BUTTON

local RefreshClient = Instance.new("TextButton")
RefreshClient.Name = "RefreshClient"
RefreshClient.Size = UDim2.new(0, 200, 0, 40)
RefreshClient.Position = UDim2.new(0, 0, 1, -45)
RefreshClient.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshClient.Text = "SCAN CLIENT"
RefreshClient.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshClient.TextSize = 14
RefreshClient.Font = Enum.Font.GothamBold
RefreshClient.Parent = ClientPage

local ClientRefreshCorner = Instance.new("UICorner")
ClientRefreshCorner.CornerRadius = UDim.new(0, 8)
ClientRefreshCorner.Parent = RefreshClient


--==================================================
-- CLIENT EXPLORER LOGIC
--==================================================

local ClientObjects = {}


local function ClearClientList()

    for _, Child in ipairs(ClientList:GetChildren()) do

        if Child:IsA("TextButton") then
            Child:Destroy()
        end

    end
end


local function AddClientObject(Object)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.TextTruncate = Enum.TextTruncate.AtEnd

    Button.Text =
        "  " ..
        Object.Name ..
        " [" ..
        Object.ClassName ..
        "]"

    Button.Parent = ClientList


    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button


    Button.MouseButton1Click:Connect(function()

        local Path = Object:GetFullName()

        if setclipboard then
            setclipboard(Path)
            ClientStatus.Text =
                "Copied: " .. Path
        else
            ClientStatus.Text = Path
        end

    end)
end


local function RefreshClientList()

    ClearClientList()

    local Search =
        string.lower(ClientSearch.Text)

    local Found = 0

    for _, Object in ipairs(ClientObjects) do

        local Name =
            string.lower(Object.Name)

        local Path =
            string.lower(Object:GetFullName())

        if Search == ""
            or string.find(Name, Search, 1, true)
            or string.find(Path, Search, 1, true) then

            AddClientObject(Object)

            Found += 1
        end
    end


    ClientStatus.Text =
        "Showing " ..
        Found ..
        " / " ..
        #ClientObjects


    ClientList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        ClientLayout.AbsoluteContentSize.Y + 10
    )
end


local function ScanClient()

    ClientObjects = {}


    -- Workspace

    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        table.insert(
            ClientObjects,
            Object
        )

    end


    -- ReplicatedStorage

    for _, Object in ipairs(
        ReplicatedStorage:GetDescendants()
    ) do

        table.insert(
            ClientObjects,
            Object
        )

    end


    RefreshClientList()

    ClientStatus.Text =
        "Scanned " ..
        #ClientObjects ..
        " client-visible objects"
end


RefreshClient.MouseButton1Click:Connect(
    ScanClient
)


ClientSearch:GetPropertyChangedSignal(
    "Text"
):Connect(function()

    RefreshClientList()

end)


--==================================================
-- TAB SWITCHING
--==================================================

local function ShowPage(Page, ActiveTab)

    CharacterPage.Visible = false
    DataPage.Visible = false
    PetsPage.Visible = false
    ClientPage.Visible = false

    CharacterTab.BackgroundColor3 =
        Color3.fromRGB(55, 55, 55)

    DataTab.BackgroundColor3 =
        Color3.fromRGB(55, 55, 55)

    PetsTab.BackgroundColor3 =
        Color3.fromRGB(55, 55, 55)

    ClientTab.BackgroundColor3 =
        Color3.fromRGB(55, 55, 55)


    Page.Visible = true

    ActiveTab.BackgroundColor3 =
        Color3.fromRGB(75, 75, 75)
end


CharacterTab.MouseButton1Click:Connect(function()

    ShowPage(
        CharacterPage,
        CharacterTab
    )

end)


DataTab.MouseButton1Click:Connect(function()

    ShowPage(
        DataPage,
        DataTab
    )

end)


PetsTab.MouseButton1Click:Connect(function()

    ShowPage(
        PetsPage,
        PetsTab
    )

end)


ClientTab.MouseButton1Click:Connect(function()

    ShowPage(
        ClientPage,
        ClientTab
    )

end)


--==================================================
-- Y BUTTON / LOCK
--==================================================

local Locked = false

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

        DragStartDashboard =
            input.Position

        StartDashboardPosition =
            Dashboard.Position


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
            input.Position -
            DragStartDashboard


        Dashboard.Position =
            UDim2.new(
                StartDashboardPosition.X.Scale,
                StartDashboardPosition.X.Offset + Delta.X,
                StartDashboardPosition.Y.Scale,
                StartDashboardPosition.Y.Offset + Delta.Y
            )

    end

end)
