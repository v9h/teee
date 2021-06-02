-- TO DO: Fix Color Picker[Image, Init, Position]

local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Call, Mouse1, BindableButton, FollowFrame, FollowButton

local Main = Instance.new("ImageLabel")
local Notifications = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Tabs = Instance.new("Frame")
local TabIndex = Instance.new("Frame")

local Gui = {}
Gui.Main = Main
Gui.Elements = {
    Text = {},
    Border = {},
    Background = {},
    Base = {}
}
Gui.Data = {}
Gui.Data.Color = Color3.fromRGB(255, 255, 255)
Gui.Data.BackgroundColor = Color3.fromRGB(20, 20, 20)

Gui.KeybindNames = {
    ["CONTROL"] = "CTRL",
    ["KEYPAD"] = "KP_",
    ["DELETE"] = "DEL",
    ["LOCK"] = "_LK",
    ["BACK"] = "B",
    ["LEFT"] = "L",
    ["UP"] = "U",
    ["DOWN"] = "D",
    ["RIGHT"] = "R",
    ["DOUBLE"] = "DB",
    ["UNKNOWN"] = "...",
    ["MULTIPLY"] = "MUL",
    ["MOUSEBUTTON"] = "M"
}

Gui.Line = function(Position, Parent)
    local Frame = Instance.new("Frame")
    Frame.Parent = Parent
    Frame.BackgroundColor3 = Gui.Data.Color
    Frame.BorderSizePixel = 0
    Frame.Position = string.lower(Position) == "up" and UDim2.new() or UDim2.new(0, 0, 1, 0)
    Frame.Size = UDim2.new(1, 0, 0, 1)
    table.insert(Gui.Elements.Background, Frame)
    return Frame
end

local Gui = setmetatable(Gui, {
    __newindex = function(Table, Key, Value)
        if Key == "Title" then
            Title.Text = Value
            return
        end
        if Key == "Color" then
            Gui.Data.Color = Value
            for _, v in ipairs(Gui.Elements.Text) do
                v.TextColor3 = Value
            end
            for _, v in ipairs(Gui.Elements.Border) do
                v.BorderColor3 = Value
            end
            for _, v in ipairs(Gui.Elements.Background) do
                v.BackgroundColor3 = Value
            end
            return
        end
        if Key == "Image" then
            Main.Image = Value
            return
        end
        rawset(Table, Key, Value)
    end
})

Gui.Screen = Instance.new("ScreenGui")
Gui.Screen.Parent = CoreGui

Main.Parent = Gui.Screen
Main.BackgroundColor3 = Gui.Data.BackgroundColor
Main.BorderColor3 = Color3.fromRGB()
Main.BorderSizePixel = 2
Main.Position = UDim2.new(0.5, -180, 0.5, -240)
Main.Size = UDim2.new(0, 360, 0, 480)
Main.ImageColor3 = Gui.Data.BackgroundColor
Main.ScaleType = Enum.ScaleType.Crop
Main.Active = true
Main.Visible = false
Main.Draggable = true
Main:GetPropertyChangedSignal("Position"):Connect(function()
    if FollowFrame and FollowButton then
        FollowFrame.Position = UDim2.new(0, FollowButton.AbsolutePosition.X, 0, FollowButton.AbsolutePosition.Y + FollowFrame:GetAttribute("FollowPosition"))
    end
end)

Notifications.Parent = Gui.Screen
Notifications.BackgroundTransparency = 1
Notifications.Size = UDim2.new(1, 0, 1.1, 0)
Notifications.Position = UDim2.new(0, 0, -0.1, 0)
Notifications.ChildRemoved:Connect(function()
    for i, Notification in ipairs(Notifications:GetChildren()) do
        Notification:TweenPosition(UDim2.new(0.8, -110, 0, i * 70), nil, nil, 0.4, true)
    end
end)

TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 15)

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.5, 0)
Title.Font = Enum.Font.Code
Title.Text = ""
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.5

Tabs.Parent = Main
Tabs.BackgroundTransparency = 1
Tabs.Size = UDim2.new(1, -30, 1, -60)
Tabs.Position = UDim2.new(0, 15, 0, 45)
Tabs.ClipsDescendants = true

TabIndex.Parent = Main
TabIndex.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabIndex.BorderSizePixel = 0
TabIndex.Position = UDim2.new(0, 0, 0, 15)
TabIndex.Size = UDim2.new(1, 0, 0, 25)
TabIndex:SetAttribute("PushAmount", 0)
Gui.Line("Up", TabIndex)

Gui.Tab = function(Name)
    local Tab = Instance.new("Frame")
    local LeftSide = Instance.new("ScrollingFrame")
    local RightSide = Instance.new("ScrollingFrame")
    local AutoAlign = Instance.new("UIListLayout")
    local AutoAlign_2 = Instance.new("UIListLayout")
    local Button = Instance.new("TextButton")

    local function ChangeTab()
        for _, v in ipairs(Tabs:GetChildren()) do
            v.Visible = false
        end
        for _, v in ipairs(TabIndex:GetChildren()) do
            if v:IsA("GuiButton") then
                v.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            end
        end
    
        Tab.Visible = true
        Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

        if FollowFrame then
            FollowFrame:Destroy()
        end
    end

    Tab.Parent = Tabs
    Tab.Name = Name
    Tab.BackgroundTransparency = 1
    Tab.Position = UDim2.new(0, 0, 0, 15)
    Tab.Size = UDim2.new(1, 0, 1, -15)

    LeftSide.Parent = Tab
    LeftSide.Name = "Left"
    LeftSide.BackgroundTransparency = 1
    LeftSide.Position = UDim2.new(0, 2, 0, 0)
    LeftSide.Size = UDim2.new(0, 156, 1, 0)
    LeftSide.CanvasSize = UDim2.new(0, 0, 0, AutoAlign.AbsoluteContentSize.Y + 30)
    LeftSide.ScrollBarThickness = 0
    LeftSide.ClipsDescendants = false
    LeftSide.DescendantAdded:Connect(function()
        LeftSide.CanvasSize = UDim2.new(0, 0, 0, AutoAlign.AbsoluteContentSize.Y + 30)
    end)
    LeftSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if FollowFrame then
            FollowFrame:Destroy()
            FollowButton = nil
        end
    end)

    RightSide.Parent = Tab
    RightSide.Name = "Right"
    RightSide.BackgroundTransparency = 1
    RightSide.Position = UDim2.new(0, 172, 0, 0)
    RightSide.Size = UDim2.new(0, 156, 1, 0)
    RightSide.ScrollBarThickness = 0
    RightSide.ClipsDescendants = false
    RightSide.DescendantAdded:Connect(function()
        RightSide.CanvasSize = UDim2.new(0, 0, 0, AutoAlign_2.AbsoluteContentSize.Y + 30)
    end)
    RightSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if FollowFrame then
            FollowFrame:Destroy()
            FollowButton = nil
        end
    end)
    
    AutoAlign.Parent = LeftSide
    AutoAlign.Padding = UDim.new(0, 15)

    AutoAlign_2.Parent = RightSide
    AutoAlign_2.Padding = UDim.new(0, 15)
    
    Button.Parent = TabIndex
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(0, TabIndex:GetAttribute("PushAmount"), 0, 1)
    Button.Size = UDim2.new(0, 60, 0, 24)
    Button.Font = Enum.Font.Code
    Button.Text = Name or ""
    Button.TextSize = 14
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextStrokeTransparency = 0.5
    Button.MouseButton1Click:Connect(function()
        ChangeTab()
    end)
    TabIndex:SetAttribute("PushAmount", TabIndex:GetAttribute("PushAmount") + 60)
    
    ChangeTab()

    return Tab, Button
end

Gui.Container = function(Tab, Name, Side)
    local Tab = Tabs[Tab]
    local Container = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    Container.Parent = Side == "Right" and Tab.Right or Tab.Left
    Container.Name = Name
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Container.BorderColor3 = Color3.fromRGB()
    Container.Size = UDim2.new(1, 0, 0, 5)
    Container:SetAttribute("PushAmount", 5)
    Gui.Line("Up", Container)

    Title.Parent = Container
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 40, 0, -8)
    Title.Font = Enum.Font.Code
    Title.Text = Name or ""
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 14
    Title.TextStrokeTransparency = 0.5

    return Container
end

Gui.Label = function(Tab, Container, Name)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.Name = Name or ""
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, Container:GetAttribute("PushAmount"))
    Label.Size = UDim2.new(0, 0, 0, 15)
    Label.Font = Enum.Font.Code
    Label.Text = Name or ""
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 0.5

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2.new(0, 0, 0, 20)

    return Label
end

Gui.Button = function(Tab, Container, Name, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.Name = Name and Name .. "Button" or "Button"
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderColor3 = Gui.Data.BackgroundColor
    Button.Position = UDim2.new(0, 8, 0, Container:GetAttribute("PushAmount"))
    Button.Size = UDim2.new(0, 142, 0, 15)
    Button.Font = Enum.Font.Code
    Button.Text = Name or ""
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 14
    Button.TextStrokeTransparency = 0.5
    Button.MouseButton1Click:Connect(function()
        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
        Callback(true)
        delay(0.3, function()
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2.new(0, 0, 0, 20)

    return Button
end

Gui.TextBox = function(Tab, Container, Name, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Container
    TextBox.Name = Name and Name .. "TextBox" or "Button"
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.BorderColor3 = Gui.Data.BackgroundColor
    TextBox.Position = UDim2.new(0, 8, 0, Container:GetAttribute("PushAmount"))
    TextBox.Size = UDim2.new(0, 142, 0, 15)
    TextBox.Font = Enum.Font.Code
    TextBox.Text = Name or ""
    TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.TextSize = 14
    TextBox.ClearTextOnFocus = false
    TextBox.TextStrokeTransparency = 0.5
    TextBox.Focused:Connect(function()
        TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    end)
    TextBox.FocusLost:Connect(function()
        TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        Callback(TextBox.Text)
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2.new(0, 0, 0, 20)

    return TextBox
end

Gui.CheckBox = function(Tab, Container, Label, Bool, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local CheckBox = Instance.new("TextButton")
    CheckBox.Parent = Label
    CheckBox.Name = Label.Name .. " CheckBox"
    CheckBox.BackgroundColor3 = Bool and Gui.Data.Color or Color3.fromRGB(40, 40, 40)
    CheckBox.BorderColor3 = Gui.Data.BackgroundColor
    CheckBox.Position = UDim2.new(0, 5 + (#Label:GetChildren() * -20), 0, 2)
    CheckBox.Size = UDim2.new(0, 10, 0, 10)
    CheckBox.Font = Enum.Font.Code
    CheckBox.Text = ""
    CheckBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    CheckBox.TextSize = 14
    CheckBox.MouseButton1Click:Connect(function()
        if CheckBox.BackgroundColor3 == Gui.Data.Color then
            CheckBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Callback(false)
            if table.find(Gui.Elements.Background, CheckBox) then
                for i, v in ipairs(Gui.Elements.Background) do
                    if v == CheckBox then
                        table.remove(Gui.Elements.Background, i)
                    end
                end
            end
        else
            CheckBox.BackgroundColor3 = Gui.Data.Color
            Callback(true)
            if not table.find(Gui.Elements.Background, CheckBox) then
                table.insert(Gui.Elements.Background, CheckBox)
            end
        end
    end)

    if Bool then
        table.insert(Gui.Elements.Background, CheckBox)
    end

    return CheckBox
end

Gui.ColorPicker = function(Tab, Container, Label, Color, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local ColorPicker = Label:FindFirstChild(Label.Name .. " ColorPicker")
    if ColorPicker then
        ColorPicker.Position -= UDim2.new(0, 20)
    end
    local ColorPicker = Instance.new("TextButton")
    ColorPicker.Parent = Label
    ColorPicker.Name = Label.Name .. " ColorPicker"
    ColorPicker.BackgroundColor3 = Color or Color3.fromRGB(40, 40, 40)
    ColorPicker.BorderColor3 = Gui.Data.BackgroundColor
    ColorPicker.Position = UDim2.new(0, 115, 0, 2.5)
    ColorPicker.Size = UDim2.new(0, 15, 0, 10)
    ColorPicker.Font = Enum.Font.Code
    ColorPicker.Text = ""
    ColorPicker.TextColor3 = Color3.fromRGB(200, 200, 200)
    ColorPicker.TextSize = 14
    ColorPicker.MouseButton1Click:Connect(function()
        local Hue, Saturation, Value
        local MainSliding, SideSliding

        if FollowFrame then
            FollowFrame:Destroy()
            FollowButton = nil
        end

        local Frame = Instance.new("Frame")
        local MainChanger = Instance.new("ImageButton")
        local SideChanger = Instance.new("TextButton")
        local ColorOutput = Instance.new("Frame")
        local MainInfo = Instance.new("TextLabel")
        local SideInfo = Instance.new("TextLabel")
        local FinishButton = Instance.new("TextButton")
        local GradientColors = Instance.new("UIGradient")

        local function Update(Type, ...)
            ColorOutput.BackgroundColor3 = Color3.fromHSV(Hue, Saturation, Value)
            MainChanger.ImageColor3 = Color3.fromHSV(Hue, Saturation, Value)
        end

        Frame.Parent = Gui.Screen
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(0, ColorPicker.AbsolutePosition.X, 0, ColorPicker.AbsolutePosition.Y + 15)
        Frame.Size = UDim2.new(0, 156, 0, 156)

        MainChanger.Parent = Frame
        MainChanger.BorderSizePixel = 0
        MainChanger.Position = UDim2.new(0, 5, 0, 5)
        MainChanger.Size = UDim2.new(0, 125, 0, 125)
        MainChanger.Image = "rbxassetid://6881151852"
        MainChanger.MouseButton1Down:Connect(function()
            MainSliding = true
            local X, Y = UserInput:GetMouseLocation().X, UserInput:GetMouseLocation().Y - 40
            local XPercentage = math.clamp((X - MainChanger.AbsolutePosition.X) / MainChanger.AbsoluteSize.X, 0, 1)
            local YPercentage = math.clamp((Y - MainChanger.AbsolutePosition.Y) / MainChanger.AbsoluteSize.Y, 0, 1)
            MainInfo.Position = UDim2.new(XPercentage, 0, YPercentage, 0)
            Saturation, Value = XPercentage, 1 - YPercentage
            Update()
        end)
        MainChanger.MouseButton1Up:Connect(function()
            MainSliding = false
        end)
        MainChanger.MouseMoved:Connect(function(X, Y)
            if MainSliding and Mouse1 then
                Y -= 40
                local XPercentage = math.clamp((X - MainChanger.AbsolutePosition.X) / MainChanger.AbsoluteSize.X, 0, 1)
                local YPercentage = math.clamp((Y - MainChanger.AbsolutePosition.Y) / MainChanger.AbsoluteSize.Y, 0, 1)
                MainInfo.Position = UDim2.new(XPercentage, 0, YPercentage, 0)
                Saturation, Value = XPercentage, 1 - YPercentage
                Update()
            else
                MainSliding = false
            end
        end)

        SideChanger.Parent = Frame
        SideChanger.BorderSizePixel = 0
        SideChanger.Position = UDim2.new(0, 135, 0, 5)
        SideChanger.Size = UDim2.new(0, 15, 0, 125)
        SideChanger.Text = ""
        SideChanger.MouseButton1Down:Connect(function()
            SideSliding = true
            local Y = UserInput:GetMouseLocation().Y - 40
            local YPercentage = math.clamp((Y - SideChanger.AbsolutePosition.Y) / SideChanger.AbsoluteSize.Y, 0, 1)
            SideInfo.Position = UDim2.new(0, 0, YPercentage, -5)
            Hue = YPercentage
            Update()
        end)
        SideChanger.MouseButton1Up:Connect(function()
            SideSliding = false
        end)
        SideChanger.MouseMoved:Connect(function(_, Y)
            if SideSliding and Mouse1 then
                Y -= 35
                local YPercentage = math.clamp((Y - SideChanger.AbsolutePosition.Y) / SideChanger.AbsoluteSize.Y, 0, 1)
                SideInfo.Position = UDim2.new(0, 0, YPercentage, -5)
                Hue = YPercentage
                Update()
            else
                SideSliding = false
            end
        end)

        ColorOutput.Parent = Frame
        ColorOutput.BackgroundColor3 = Color or Color3.fromRGB()
        ColorOutput.BorderSizePixel = 0
        ColorOutput.Position = UDim2.new(0, 5, 0, 135)
        ColorOutput.Size = UDim2.new(0, 125, 0, 15)

        MainInfo.Parent = MainChanger
        MainInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MainInfo.BorderColor3 = Gui.Data.BackgroundColor
        MainInfo.BorderSizePixel = 1
        MainInfo.Size = UDim2.new(0, 5, 0, 5)
        MainInfo.Text = ""

        SideInfo.Parent = SideChanger
        SideInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SideInfo.BorderColor3 = Gui.Data.BackgroundColor
        SideInfo.BorderSizePixel = 1
        SideInfo.Size = UDim2.new(0, 15, 0, 5)
        SideInfo.Text = ""

        FinishButton.Parent = Frame
        FinishButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        FinishButton.BorderSizePixel = 0
        FinishButton.Position = UDim2.new(0, 135, 0, 135)
        FinishButton.Size = UDim2.new(0, 15, 0, 15)
        FinishButton.Font = Enum.Font.Code
        FinishButton.Text = "OK"
        FinishButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        FinishButton.TextSize = 14
        FinishButton.MouseButton1Click:Connect(function()
            ColorPicker.BackgroundColor3 = ColorOutput.BackgroundColor3
            Callback(ColorOutput.BackgroundColor3)
            Frame:Destroy()
            FollowFrame = nil
        end)

        GradientColors.Parent = SideChanger
        GradientColors.Rotation = 90
        GradientColors.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.49, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255)),
        }

        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 15)
        FollowButton = ColorPicker

        Update()
    end)

    return ColorPicker
end

Gui.ComboBox = function(Tab, Container, Name, Items, Selected, Callback)
    local Name = Name or ""
    local Items = Items or {}
    local Selected = Selected or ""
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local ComboBox = Instance.new("TextButton")
    ComboBox.Parent = Container
    ComboBox.Name = Name
    ComboBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ComboBox.BorderColor3 = Gui.Data.BackgroundColor
    ComboBox.Position = UDim2.new(0, 8, 0, Container:GetAttribute("PushAmount"))
    ComboBox.Size = UDim2.new(0, 142, 0, 15)
    ComboBox.Font = Enum.Font.Code
    ComboBox.Text = Selected and Selected or "None"
    ComboBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    ComboBox.TextSize = 14
    ComboBox.TextStrokeTransparency = 0.5
    ComboBox.MouseButton1Click:Connect(function()
        local Frame = Gui.Screen:FindFirstChild(Name)
        if Frame then
            Frame:Destroy()
            return
        end
        if FollowFrame then
            FollowFrame:Destroy()
            FollowButton = nil
        end
        local Frame = Instance.new("ScrollingFrame")

        Frame.Parent = Gui.Screen
        Frame.Name = Name or ""
        Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame.BorderColor3 = Gui.Data.BackgroundColor
        Frame.Position = UDim2.new(0, ComboBox.AbsolutePosition.X, 0, ComboBox.AbsolutePosition.Y + 15)
        Frame.ScrollBarImageColor3 = Color3.fromRGB()
        Frame.ScrollBarThickness = 5
        Frame.Size = UDim2.new(0, 142, 0, #Items > 5 and 75 or #Items * 15)
        Frame.CanvasSize = #Items > 5 and UDim2.new(0, 0, 0, #Items * 15) or UDim2.new()
        Frame.ClipsDescendants = true
        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 15)
        FollowButton = ComboBox

        for _, Item in ipairs(Items) do
            local Button = Instance.new("TextButton")
            Button.Parent = Frame
            Button.Name = Item
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, #Frame:GetChildren() * 15 - 15)
            Button.Size = UDim2.new(1, 0, 0, 15)
            Button.Font = Enum.Font.Code
            Button.Text = Item
            Button.TextColor3 = ComboBox.Text ~= Item and Color3.fromRGB(200, 200, 200) or Gui.Data.Color
            Button.TextSize = 14
            Button.TextStrokeTransparency = 0.5
            Button.MouseButton1Click:Connect(function()
                ComboBox.Text = Item
                Callback(Item)
                Frame:Destroy()
            end)
        end
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2.new(0, 0, 0, 20)

    return ComboBox
end

Gui.MultiBox = function(Tab, Container, Name, Items, SelectedItems, Callback)
    local Name = Name or ""
    local Items = Items or {}
    local SelectedItems = SelectedItems or {}
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local MultiBox = Instance.new("TextButton")
    MultiBox.Parent = Container
    MultiBox.Name = Name
    MultiBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MultiBox.BorderColor3 = Gui.Data.BackgroundColor
    MultiBox.Position = UDim2.new(0, 8, 0, Container:GetAttribute("PushAmount"))
    MultiBox.Size = UDim2.new(0, 142, 0, 20)
    MultiBox.Font = Enum.Font.Code
    MultiBox.Text = SelectedItems and #SelectedItems > 0 and table.concat(SelectedItems, ", ") or "None"
    MultiBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    MultiBox.TextSize = 14
    MultiBox.TextTruncate = Enum.TextTruncate.AtEnd
    MultiBox.TextStrokeTransparency = 0.5
    MultiBox.MouseButton1Click:Connect(function()
        local Frame = Gui.Screen:FindFirstChild(Name)
        if Frame then
            Frame:Destroy()
            return
        end
        if FollowFrame then
            FollowFrame:Destroy()
            FollowButton = nil
        end
        local Frame = Instance.new("ScrollingFrame")
        
        Frame.Parent = Gui.Screen
        Frame.Name = Name or ""
        Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame.BorderColor3 = Gui.Data.BackgroundColor
        Frame.Position = UDim2.new(0, MultiBox.AbsolutePosition.X, 0, MultiBox.AbsolutePosition.Y + 20)
        Frame.ScrollBarImageColor3 = Color3.fromRGB()
        Frame.ScrollBarThickness = 5
        Frame.Size = UDim2.new(0, 142, 0, #Items > 5 and 80 or #Items * 15)
        Frame.CanvasSize = #Items > 5 and UDim2.new(0, 0, 0, #Items * 15) or UDim2.new()
        Frame.ClipsDescendants = true
        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 20)
        FollowButton = MultiBox

        for _, Item in ipairs(Items) do
            local Button = Instance.new("TextButton")
            Button.Parent = Frame
            Button.Name = Item
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 0, 0, #Frame:GetChildren() * 15 - 15)
            Button.Size = UDim2.new(1, 0, 0, 15)
            Button.Font = Enum.Font.Code
            Button.Text = Item
            Button.TextColor3 = not string.find(MultiBox.Text, Item) and Color3.fromRGB(200, 200, 200) or Gui.Data.Color
            Button.TextSize = 14
            Button.TextStrokeTransparency = 0.5
            Button.MouseButton1Click:Connect(function()
                if table.find(SelectedItems, Item) then
                    for i, v in ipairs(SelectedItems) do
                        if v == Item then
                            table.remove(SelectedItems, i)
                        end
                    end
                    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                else
                    table.insert(SelectedItems, Item)
                    Button.TextColor3 = Gui.Data.Color
                end
                MultiBox.Text = #SelectedItems > 0 and table.concat(SelectedItems, ", ") or "None"
                Callback(SelectedItems)
            end)
        end
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 25)
    Container.Size += UDim2.new(0, 0, 0, 25)

    return MultiBox
end

Gui.Bindable = function(Tab, Container, Label, Key, Callback)
    local Key = Key or Enum.KeyCode.Unknown
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local Bindable = Instance.new("TextButton")
    Bindable.Parent = Label
    Bindable.Name = Label.Name .. " Bindable"
    Bindable.BackgroundTransparency = 1
    Bindable.Position = UDim2.new(0, 90, 0, 0)
    Bindable.Size = UDim2.new(0, 40, 0, 15)
    Bindable.Font = Enum.Font.Code
    local Text = string.upper(Key.Name)
    for k, v in pairs(Gui.KeybindNames) do
        if string.find(Text, k) then
            Text = string.gsub(Text, k, v)
        end
    end
    Bindable.Text = Text and "[" .. Text .. "]" or "[...]"
    Bindable.TextColor3 = Color3.fromRGB(180, 180, 180)
    Bindable.TextSize = 14
    Bindable.TextXAlignment = Enum.TextXAlignment.Right
    Bindable.TextStrokeTransparency = 0.5
    Bindable.MouseButton1Click:Connect(function()
        Bindable.Text = "[...]"
        BindableButton = Bindable
        Call = Callback
    end)
    Bindable.MouseButton2Click:Connect(function()
        if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) or UserInput:IsKeyDown(Enum.KeyCode.RightControl) then
            Bindable.Text = "[...]"
            Callback()
        end
    end)

    return Bindable
end

Gui.Slider = function(Tab, Container, Label, Name, Min, Max, Init, Decimal, Callback)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local Callback = Callback or tostring

    local Slider = Instance.new("Frame")
    local Info = Instance.new("TextLabel")
    local Button = Instance.new("TextButton")
    local ValueBox = Instance.new("TextBox")

    Slider.Parent = Label
    Slider.Name = Name and Name .. " Slider" or "Slider"
    Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Slider.BorderColor3 = Gui.Data.BackgroundColor
    Slider.Position = UDim2.new(0, -12, 0, 20)
    Slider.Size = UDim2.new(0, 142, 0, 5)
    Slider:SetAttribute("Init", Init or 0)
    Slider:SetAttribute("Min", Min or 0)
    Slider:SetAttribute("Max", Max or 100)
    Slider:SetAttribute("Decimal", Decimal or 0)
    Slider:SetAttribute("Sliding", false)

    Info.Parent = Slider
    Info.Name = "Info"
    Info.BackgroundColor3 = Gui.Data.Color
    Info.BorderSizePixel = 0
    Info.Size = UDim2.new(math.clamp((Slider:GetAttribute("Init") - Slider:GetAttribute("Min")) / Slider:GetAttribute("Max"), 0, 1), 0, 1, 0)
    Info.TextColor3 = Color3.fromRGB(200, 200, 200)
    Info.Text = ""
    table.insert(Gui.Elements.Background, Info)

    Button.Parent = Slider
    Button.BackgroundTransparency = 1
    Button.Position = UDim2.new(-0.1, 0, -1, 0)
    Button.Size = UDim2.new(1.2, 0, 2, 0)
    Button.Text = ""
    Button.MouseButton1Down:Connect(function()
        print(Slider:GetAttribute("Max"))
        Slider:SetAttribute("Sliding", true)
        local Percentage = math.clamp((UserInput:GetMouseLocation().X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
        Info.Size = UDim2.new(Percentage, 0, 1, 0)
        ValueBox.Text = string.format("%." .. Slider:GetAttribute("Decimal") .. "f", Slider:GetAttribute("Min") + Slider:GetAttribute("Max") * Percentage)
        Callback(Percentage * Slider:GetAttribute("Max") + Slider:GetAttribute("Min"))
    end)
    Button.MouseButton1Up:Connect(function()
        Slider:SetAttribute("Sliding", false)
    end)
    Button.MouseMoved:Connect(function(X)
        if Slider:GetAttribute("Sliding") and Mouse1 then
            local Percentage = math.clamp((X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Info.Size = UDim2.new(Percentage, 0, 1, 0)
            ValueBox.Text = string.format("%." .. Slider:GetAttribute("Decimal") .. "f", Slider:GetAttribute("Min") + Slider:GetAttribute("Max") * Percentage)
            Callback(Percentage * Slider:GetAttribute("Max") + Slider:GetAttribute("Min"))
        else
            Slider:SetAttribute("Sliding", false)
        end
    end)

    ValueBox.Parent = Label
    ValueBox.Name = "Value"
    ValueBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ValueBox.BorderSizePixel = 0
    ValueBox.Position = UDim2.new(0, 115, 0, 0)
    ValueBox.Size = UDim2.new(0, 15, 0, 15)
    ValueBox.Font = Enum.Font.Code
    ValueBox.Text = Slider:GetAttribute("Init")
    ValueBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueBox.TextSize = 14
    ValueBox.TextStrokeTransparency = 0.5
    ValueBox.FocusLost:Connect(function()
        ValueBox.Text = tonumber(ValueBox.Text) or Slider:GetAttribute("Min")
        Value = math.clamp(tonumber(ValueBox.Text), Slider:GetAttribute("Min"), Slider:GetAttribute("Max"))
        ValueBox.Text = Value
        Info.Size = UDim2.new(math.clamp((Value - Slider:GetAttribute("Min")) / Slider:GetAttribute("Max"), 0, 1), 0, 1, 0)
        Callback(Value)
    end)

    Max -= Min
    Label.Parent.Size += UDim2.new(0, 0, 0, 10)
    Label.Parent:SetAttribute("PushAmount", Label.Parent:GetAttribute("PushAmount") + 10)

    return Slider, Info, Button, ValueBox
end

Gui.Notify = function(Name, Message, Time)
    local Notification = Instance.new("ImageLabel")
    local Title = Instance.new("TextLabel")
    local Text = Instance.new("TextLabel")

    Notification.Parent = Notifications
    Notification.Name = "Notification"
    Notification.BackgroundColor3 = Gui.Data.BackgroundColor
    Notification.BorderColor3 =  Color3.fromRGB(0, 0, 0)
    Notification.BorderSizePixel = 2
    Notification:TweenPosition(UDim2.new(0.8, -110, 0, #Notifications:GetChildren() * 70))
    Notification.Size = UDim2.new(0, 220, 0, 60)
    Notification.Visible = true

    Title.Parent = Notification
    Title.Name = "Title"
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 15)
    Title.Font = Enum.Font.Code
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 14
    Gui.Line("Up", Title)

    Text.Parent = Notification
    Text.Name = "Text"
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.new(0.05, 0, 0, 20)
    Text.Size = UDim2.new(0.9, 0, 1, -20)
    Text.Font = Enum.Font.Code
    Text.Text = Message
    Text.TextColor3 = Color3.fromRGB(180, 180, 180)
    Text.TextSize = 14
    Text.TextWrapped = true
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Top

    delay(Time or 5, function()
        local Tween = Notification:TweenPosition(UDim2.new(1, 0, 0, Notification.AbsolutePosition.Y), nil, nil, 0.4, true, function()
            Notification:Destroy()
        end)
    end)

    return Notification
end

Gui.Update = function(Tab, Container, ...)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local function CaseSwitch(Paramater, Dictionary, ...)
        local Case = Dictionary[Paramater]
        if Case then
            return Case(...)
        end
    end
    local Arguments = {...}
    local Item = Container[Arguments[2]]
    CaseSwitch(Arguments[1], {
        ["Label"] = function()
            Item.Text = Arguments[3]
        end,
        ["Button"] = function()
            Item.Text = Arguments[3]
        end,
        ["TextBox"] = function()
            Item.Text = Arguments[3]
        end,
        ["CheckBox"] = function()
            Item.BackgroundColor3 = Arguments[3] and Gui.Data.Color or Color3.fromRGB(40, 40, 40)
        end,
        ["ColorPicker"] = function()
            Item.BackgroundColor3 = Arguments[3] or Color3.fromRGB()
        end,
        ["ComboBox"] = function()
            Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") - 20)
            Container.Size -= UDim2.new(0, 0, 0, 20)
            local Position = Item.Position
            local ComboBox = Gui.ComboBox(Tab, Container.Name, Item.Name, Arguments[3], Arguments[4], Arguments[5])
            ComboBox.Position = Position
            Item:Destroy()
        end,
        ["MultiBox"] = function()
            Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") - 25)
            Container.Size -= UDim2.new(0, 0, 0, 25)
            local Position = Item.Position
            local MultiBox = Gui.MultiBox(Tab, Container.Name, Item.Name, Arguments[3], Arguments[4], Arguments[5])
            MultiBox.Position = Position
            Item:Destroy()
        end,
        ["Bindable"] = function()
            Item.Text = "[" .. Arguments[3] .. "]"
        end,
        ["Slider"] = function()
            local Min, Max, Init, Decimal = Arguments[3], Arguments[4], Arguments[5], Arguments[6]
            Item.Value.Text = Init
            local Item = Item[Item.Name .. " Slider"]
            Item:SetAttribute("Init", Init or 0)
            Item:SetAttribute("Min", Min or 0)
            Item:SetAttribute("Max", Max or 100)
            Item:SetAttribute("Decimal", Decimal or 0)
            Item.Info.Size = UDim2.new(math.clamp((Init - Min) / Max - Min, 0, 1), 0, 1, 0)
        end
    })
end

Gui.OnInput = function(Input, Process)
    if BindableButton then
        if Input.UserInputType == Enum.UserInputType.Keyboard then
            local Text = string.upper(Input.KeyCode.Name)
            for k, v in pairs(Gui.KeybindNames) do
                if string.find(Text, k) then
                    Text = string.gsub(Text, k, v)
                end
            end
            BindableButton.Text = Text and "[" .. Text .. "]" or "[...]"
            Call(Input.KeyCode)
        else
            local Text = string.upper(Input.UserInputType.Name)
            for k, v in pairs(Gui.KeybindNames) do
                if string.find(Text, k) then
                    Text = string.gsub(Text, k, v)
                end
            end
            BindableButton.Text = Text and "[" .. Text .. "]" or "[...]"
            Call(Input.UserInputType)
        end
        Call, BindableButton = nil, nil
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Mouse1 = true
    end
end

Gui.OnInputEnded = function(Input, Process)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Mouse1 = false
    end
end

UserInput.InputBegan:Connect(Gui.OnInput)
UserInput.InputEnded:Connect(Gui.OnInputEnded)

--Gui.Main.Visible = true

return Gui
