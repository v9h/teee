-- TO DO: More built in Gui Objects, like check box

-- Variables

local Vec2, Vec3 = Vector2.new, Vector3.new
local IsA, Clone, Destroy, GetChildren, GetDescendants, IsDescendantOf = game.IsA, game.Clone, game.Destroy, game.GetChildren, game.GetDescendants, game.IsDescendantOf

local CoreGui = game:GetService("CoreGui")

local Gui = {}
Gui.Screen = Instance.new("ScreenGui")
Gui.Screen.Parent = CoreGui

function SetProperties(Element, Data)
    for k, v in pairs(Data) do
        Element[k] = v
    end
end

Gui.Window = function(Data)
    local Data = Data or {}
    local Window = Instance.new("ImageLabel")
    Window.Parent = Gui.Screen
    Window.Active = true
    Window.BorderSizePixel = 0
    Window.Size = UDim2.new(0, 500, 0, 300)
    SetProperties(Window, Data)
    return Window
end

Gui.Text = function(Data)
    local Data = Data or {}

    local Text = Instance.new("TextLabel")
    Text.Parent = Gui.Screen
    Text.BackgroundTransparency = 1
    Text.BorderSizePixel = 0
    Text.Size = UDim2.new(0, 100, 0, 20)
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextSize = 14
    Text.Font = Enum.Font.Code
    Text.Text = ""
    SetProperties(Text, Data)
    return Text
end

Gui.Button = function(Data, OnClick)
    local Data = Data or {}
    local OnClick = OnClick or tostring

    local Button = Instance.new("TextButton")
    Button.Parent = Gui.Screen
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(0, 100, 0, 20)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Code
    Button.Text = ""
    Button.MouseButton1Click:Connect(OnClick)
    SetProperties(Button, Data)
    return Button
end

Gui.TextBox = function(Data, OnFocusLost)
    local Data = Data or {}
    local OnFocusLost = OnFocusLost or tostring

    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Gui.Screen
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(0, 100, 0, 20)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Code
    TextBox.Text = ""
    TextBox.FocusLost:Connect(OnFocusLost)
    SetProperties(TextBox, Data)
    return TextBox
end

Gui.Round = function(Element, Amount)
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Element
    UICorner.CornerRadius = UDim(0, Amount)
    return UICorner
end
