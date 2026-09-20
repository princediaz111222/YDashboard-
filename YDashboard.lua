--// YDashboard Base

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YDashboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- Y BUTTON
--==================================================

local YButton = Instance.new("TextButton")
YButton.Name = "YButton"
YButton.Size = UDim2.fromOffset(48, 48)
YButton.Position = UDim2.new(0, 20, 0.5, -24)
YButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
YButton.BorderSizePixel = 0
YButton.Text = "Y"
YButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YButton.TextSize = 21
YButton.Font = Enum.Font.GothamBold
YButton.AutoButtonColor = true
YButton.ZIndex = 100
YButton.Parent = ScreenGui

local YCorner = Instance.new("UICorner")
YCorner.CornerRadius = UDim.new(1, 0)
YCorner.Parent = YButton

--==================================================
-- DASHBOARD
--==================================================

local Dashboard = Instance.new("Frame")
Dashboard.Name = "Main"
Dashboard.Size = UDim2.fromOffset(700, 450)
Dashboard.Position = UDim2.new(0.5, -350, 0.5, -225)
Dashboard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Dashboard.BorderSizePixel = 0
Dashboard.Visible = true
Dashboard.ZIndex = 10
Dashboard.Parent = ScreenGui

local DashboardCorner = Instance.new("UICorner")
DashboardCorner.CornerRadius = UDim.new(0, 10)
DashboardCorner.Parent = Dashboard

--==================================================
-- TITLE BAR
--==================================================

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Dashboard

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Cover bottom corners of title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 11
TitleFix.Parent = TitleBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "YDashboard"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = TitleBar

--==================================================
-- LOCK BUTTON
--==================================================

local LockButton = Instance.new("TextButton")
LockButton.Name = "Lock"
LockButton.Size = UDim2.fromOffset(34, 34)
LockButton.Position = UDim2.new(1, -82, 0, 6)
LockButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LockButton.BorderSizePixel = 0
LockButton.Text = "🔓"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 15
LockButton.Font = Enum.Font.GothamBold
LockButton.ZIndex = 12
LockButton.Parent = TitleBar

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 7)
LockCorner.Parent = LockButton

--==================================================
-- CLOSE BUTTON
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -42, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 12
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.fromOffset(10, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Dashboard

-- Placeholder
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, 0, 0, 40)
Welcome.Position = UDim2.new(0, 0, 0.5, -20)
Welcome.BackgroundTransparency = 1
Welcome.Text = "YDashboard"
Welcome.TextColor3 = Color3.fromRGB(150, 150, 150)
Welcome.TextSize = 18
Welcome.Font = Enum.Font.Gotham
Welcome.ZIndex = 12
Welcome.Parent = Content

--==================================================
-- DASHBOARD VISIBILITY
--==================================================

YButton.MouseButton1Click:Connect(function()
    Dashboard.Visible = not Dashboard.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    Dashboard.Visible = false
end)

--==================================================
-- LOCK SYSTEM
--==================================================

local Locked = false

LockButton.MouseButton1Click:Connect(function()

    Locked = not Locked

    if Locked then
        LockButton.Text = "🔒"
        LockButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    else
        LockButton.Text = "🔓"
        LockButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end

end)

--==================================================
-- DRAG FUNCTION
--==================================================

local function MakeDraggable(Object, CheckLocked)

    local Dragging = false
    local DragStart
    local StartPosition

    Object.InputBegan:Connect(function(Input)

        if CheckLocked and Locked then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()

                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Delta = Input.Position - DragStart

        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end)

end

-- Dashboard locked independently
MakeDraggable(TitleBar, true)

-- Y button can always be moved
MakeDraggable(YButton, false)

print("YDashboard loaded.")
