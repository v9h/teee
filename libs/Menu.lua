local delay = task.delay
local math_abs = math.abs
local math_clamp = math.clamp
local math_floor = math.floor
local math_round = math.round
local math_random = math.random
local table_clear = table.clear
local table_find = table.find
local table_concat = table.concat
local table_insert = table.insert
local table_remove = table.remove
local string_sub = string.sub
local string_char = string.char
local string_find = string.find
local string_gsub = string.gsub
local string_lower = string.lower
local string_upper = string.upper
local string_split = string.split
local string_format = string.format
local Instance_new = Instance.new
local UDim_new = UDim.new
local UDim2_new = UDim2.new
local Color3_fromRGB = Color3.fromRGB
local Color3_fromHSV = Color3.fromHSV
local ColorSequence_new = ColorSequence.new
local ColorSequenceKeypoint_new = ColorSequenceKeypoint.new

local Vec2 = Vector2.new
local IsA, Destroy, GetChildren = game.IsA, game.Destroy, game.GetChildren

local TextService = game:GetService("TextService")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Call, Mouse1, BindableButton, FollowFrame, FollowButton

local Main = Instance_new("ImageLabel")
local Notifications = Instance_new("Frame")
local TopBar = Instance_new("Frame")
local Title = Instance_new("TextLabel")
local Tabs = Instance_new("Frame")
local TabIndex = Instance_new("Frame")

local Menu = {}
Menu.Main = Main
Menu.Elements = {
    Text = {},
    Border = {},
    Background = {},
    Base = {}
}
Menu.Data = {}
Menu.Data.Color = Color3_fromRGB(255, 255, 255)
Menu.Data.BackgroundColor = Color3_fromRGB(20, 20, 20)

Menu.KeybindNames = {
    ["CONTROL"] = "CTRL",
    ["KEYPAD"] = "KP_",
    ["DELETE"] = "DEL",
    ["LOCK"] = "_LK",
    ["BACK"] = "BK",
    ["LEFT"] = "LT",
    ["UP"] = "UP",
    ["DOWN"] = "DN",
    ["RIGHT"] = "RT",
    ["DOUBLE"] = "DB",
    ["UNKNOWN"] = "...",
    ["MULTIPLY"] = "MUL",
    ["MOUSEBUTTON"] = "M"
}

Menu.Line = function(Position, Parent)
    local Frame = Instance_new("Frame")
    Frame.Parent = Parent
    Frame.BackgroundColor3 = Menu.Data.Color
    Frame.BorderSizePixel = 0
    Frame.Position = string_lower(Position) == "up" and UDim2_new() or UDim2_new(0, 0, 1, 0)
    Frame.Size = UDim2_new(1, 0, 0, 1)
    Menu.Elements.Background[Frame] = Frame
    return Frame
end

local Menu = setmetatable(Menu, {
    __newindex = function(Table, Key, Value)
        if Key == "Title" then
            Title.Text = Value
            return
        end
        if Key == "Color" then
            local Elements = Menu.Elements
            Menu.Data.Color = Value
            for _, v in ipairs(Elements.Text) do
                v.TextColor3 = Value
            end
            for _, v in ipairs(Elements.Border) do
                v.BorderColor3 = Value
            end
            for _, v in ipairs(Elements.Background) do
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

Menu.Screen = Instance_new("ScreenGui")
Menu.Screen.Parent = CoreGui

Main.Parent = Menu.Screen
Main.BackgroundColor3 = Menu.Data.BackgroundColor
Main.BorderColor3 = Color3_fromRGB()
Main.BorderSizePixel = 2
Main.Position = UDim2_new(0.5, -180, 0.5, -240)
Main.Size = UDim2_new(0, 360, 0, 480)
Main.ImageColor3 = Menu.Data.BackgroundColor
Main.ScaleType = Enum.ScaleType.Crop
Main.Active = true
Main.Visible = false
Main.Draggable = true
Main:GetPropertyChangedSignal("Position"):Connect(function()
    if FollowFrame and FollowButton then
        FollowFrame.Position = UDim2_new(0, FollowButton.AbsolutePosition.X, 0, FollowButton.AbsolutePosition.Y + FollowFrame:GetAttribute("FollowPosition"))
    end
end)

Notifications.Parent = Menu.Screen
Notifications.BackgroundTransparency = 1
Notifications.Size = UDim2_new(1, 0, 1.1, 0)
Notifications.Position = UDim2_new(0, 0, -0.1, 0)
Notifications.ChildRemoved:Connect(function()
    for i, Notification in ipairs(GetChildren(Notifications)) do
        Notification:TweenPosition(UDim2_new(0.8, -110, 0, i * 70), nil, nil, 0.4, true)
    end
end)

TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2_new(1, 0, 0, 15)

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2_new(0, 0, 0.5, 0)
Title.Font = Enum.Font.Code
Title.Text = ""
Title.TextColor3 = Color3_fromRGB(200, 200, 200)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.5

Tabs.Parent = Main
Tabs.BackgroundTransparency = 1
Tabs.Size = UDim2_new(1, -30, 1, -60)
Tabs.Position = UDim2_new(0, 15, 0, 45)
Tabs.ClipsDescendants = true

TabIndex.Parent = Main
TabIndex.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
TabIndex.BorderSizePixel = 0
TabIndex.Position = UDim2_new(0, 0, 0, 15)
TabIndex.Size = UDim2_new(1, 0, 0, 25)
TabIndex:SetAttribute("PushAmount", 0)
Menu.Line("Up", TabIndex)

Menu.Tab = function(Name)
    local Tab = Instance_new("Frame")
    local LeftSide = Instance_new("ScrollingFrame")
    local RightSide = Instance_new("ScrollingFrame")
    local AutoAlign = Instance_new("UIListLayout")
    local AutoAlign_2 = Instance_new("UIListLayout")
    local Button = Instance_new("TextButton")

    local function ChangeTab()
        for _, v in ipairs(GetChildren(Tabs)) do
            v.Visible = false
        end
        for _, v in ipairs(GetChildren(TabIndex)) do
            if IsA(v, "GuiButton") then
                v.BackgroundColor3 = Color3_fromRGB(20, 20, 20)
            end
        end
    
        Tab.Visible = true
        Button.BackgroundColor3 = Color3_fromRGB(15, 15, 15)

        if FollowFrame then
            Destroy(FollowFrame)
        end
    end

    Tab.Parent = Tabs
    Tab.Name = Name
    Tab.BackgroundTransparency = 1
    Tab.Position = UDim2_new(0, 0, 0, 15)
    Tab.Size = UDim2_new(1, 0, 1, -15)

    LeftSide.Parent = Tab
    LeftSide.Name = "Left"
    LeftSide.BackgroundTransparency = 1
    LeftSide.Position = UDim2_new(0, 2, 0, 0)
    LeftSide.Size = UDim2_new(0, 156, 1, 0)
    LeftSide.CanvasSize = UDim2_new(0, 0, 0, AutoAlign.AbsoluteContentSize.Y + 30)
    LeftSide.ScrollBarThickness = 0
    LeftSide.ClipsDescendants = false
    LeftSide.DescendantAdded:Connect(function()
        LeftSide.CanvasSize = UDim2_new(0, 0, 0, AutoAlign.AbsoluteContentSize.Y + 30)
    end)
    LeftSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if FollowFrame then
            Destroy(FollowFrame)
            FollowButton = nil
        end
    end)

    RightSide.Parent = Tab
    RightSide.Name = "Right"
    RightSide.BackgroundTransparency = 1
    RightSide.Position = UDim2_new(0, 172, 0, 0)
    RightSide.Size = UDim2_new(0, 156, 1, 0)
    RightSide.ScrollBarThickness = 0
    RightSide.ClipsDescendants = false
    RightSide.DescendantAdded:Connect(function()
        RightSide.CanvasSize = UDim2_new(0, 0, 0, AutoAlign_2.AbsoluteContentSize.Y + 30)
    end)
    RightSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if FollowFrame then
            Destroy(FollowFrame)
            FollowButton = nil
        end
    end)
    
    AutoAlign.Parent = LeftSide
    AutoAlign.Padding = UDim_new(0, 15)
    AutoAlign.SortOrder = Enum.SortOrder.LayoutOrder

    AutoAlign_2.Parent = RightSide
    AutoAlign_2.Padding = UDim_new(0, 15)
    AutoAlign_2.SortOrder = Enum.SortOrder.LayoutOrder
    
    Button.Parent = TabIndex
    Button.BackgroundColor3 = Color3_fromRGB(20, 20, 20)
    Button.BorderSizePixel = 0
    Button.Position = UDim2_new(0, TabIndex:GetAttribute("PushAmount"), 0, 1)
    Button.Size = UDim2_new(0, 60, 0, 24)
    Button.Font = Enum.Font.Code
    Button.Text = Name or ""
    Button.TextSize = 14
    Button.TextColor3 = Color3_fromRGB(220, 220, 220)
    Button.TextStrokeTransparency = 0.5
    Button.MouseButton1Click:Connect(function()
        ChangeTab()
    end)
    TabIndex:SetAttribute("PushAmount", TabIndex:GetAttribute("PushAmount") + 60)
    
    ChangeTab()

    return Tab, Button
end

Menu.Container = function(Tab, Name, Side)
    local Tab = Tabs[Tab]
    local Container = Instance_new("Frame")
    local Title = Instance_new("TextLabel")

    Container.Parent = Side == "Right" and Tab.Right or Tab.Left
    Container.Name = Name
    Container.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
    Container.BorderColor3 = Color3_fromRGB()
    Container.Size = UDim2_new(1, 0, 0, 5)
    Container:SetAttribute("PushAmount", 5)
    Menu.Line("Up", Container)

    Title.Parent = Container
    Title.BackgroundTransparency = 1
    Title.Position = UDim2_new(0, 40, 0, -8)
    Title.Font = Enum.Font.Code
    Title.Text = Name or ""
    Title.TextColor3 = Color3_fromRGB(200, 200, 200)
    Title.TextSize = 14
    Title.TextStrokeTransparency = 0.5

    return Container
end

Menu.Label = function(Tab, Container, Name)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Instance_new("TextLabel")
    Label.Parent = Container
    Label.Name = Name or ""
    Label.BackgroundTransparency = 1
    Label.Position = UDim2_new(0, 20, 0, Container:GetAttribute("PushAmount"))
    Label.Size = UDim2_new(0, 0, 0, 15)
    Label.Font = Enum.Font.Code
    Label.Text = Name or ""
    Label.TextColor3 = Color3_fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 0.5

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2_new(0, 0, 0, 20)

    return Label
end

Menu.Button = function(Tab, Container, Name, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Button = Instance_new("TextButton")
    Button.Parent = Container
    Button.Name = Name and Name .. "Button" or "Button"
    Button.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    Button.BorderColor3 = Menu.Data.BackgroundColor
    Button.Position = UDim2_new(0, 8, 0, Container:GetAttribute("PushAmount"))
    Button.Size = UDim2_new(0, 142, 0, 15)
    Button.Font = Enum.Font.Code
    Button.Text = Name or ""
    Button.TextColor3 = Color3_fromRGB(200, 200, 200)
    Button.TextSize = 14
    Button.TextStrokeTransparency = 0.5
    Button.MouseButton1Click:Connect(function()
        Button.TextColor3 = Color3_fromRGB(220, 220, 220)
        Callback(true)
        delay(0.3, function()
            Button.TextColor3 = Color3_fromRGB(200, 200, 200)
        end)
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2_new(0, 0, 0, 20)

    return Button
end

Menu.TextBox = function(Tab, Container, Name, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local TextBox = Instance_new("TextBox")
    TextBox.Parent = Container
    TextBox.Name = Name and Name .. "TextBox" or "Button"
    TextBox.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    TextBox.BorderColor3 = Menu.Data.BackgroundColor
    TextBox.Position = UDim2_new(0, 8, 0, Container:GetAttribute("PushAmount"))
    TextBox.Size = UDim2_new(0, 142, 0, 15)
    TextBox.Font = Enum.Font.Code
    TextBox.Text = Name or ""
    TextBox.TextColor3 = Color3_fromRGB(200, 200, 200)
    TextBox.TextSize = 14
    TextBox.ClearTextOnFocus = false
    TextBox.TextStrokeTransparency = 0.5
    TextBox.Focused:Connect(function()
        TextBox.TextColor3 = Color3_fromRGB(220, 220, 220)
    end)
    TextBox.FocusLost:Connect(function()
        TextBox.TextColor3 = Color3_fromRGB(200, 200, 200)
        Callback(TextBox.Text)
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2_new(0, 0, 0, 20)

    return TextBox
end

Menu.CheckBox = function(Tab, Container, Label, Bool, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local CheckBox = Instance_new("TextButton")
    CheckBox.Parent = Label
    CheckBox.Name = Label.Name .. " CheckBox"
    CheckBox.BackgroundColor3 = Bool and Menu.Data.Color or Color3_fromRGB(40, 40, 40)
    CheckBox.BorderColor3 = Menu.Data.BackgroundColor
    CheckBox.Position = UDim2_new(0, 5 + (#GetChildren(Label) * -20), 0, 2)
    CheckBox.Size = UDim2_new(0, 10, 0, 10)
    CheckBox.Text = ""
    CheckBox.MouseButton1Click:Connect(function()
        if CheckBox.BackgroundColor3 == Menu.Data.Color then
            CheckBox.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
            Callback(false)
            Menu.Elements.Background[CheckBox] = nil
        else
            CheckBox.BackgroundColor3 = Menu.Data.Color
            Callback(true)
            Menu.Elements.Background[CheckBox] = CheckBox
        end
    end)

    if Bool then
        Menu.Elements.Background[CheckBox] = CheckBox
    end

    return CheckBox
end

Menu.ColorPicker = function(Tab, Container, Label, Color, Callback)
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local ColorPicker = Label:FindFirstChild(Label.Name .. " ColorPicker")
    if ColorPicker then
        ColorPicker.Position -= UDim2_new(0, 20)
    end
    local ColorPicker = Instance_new("TextButton")
    ColorPicker.Parent = Label
    ColorPicker.Name = Label.Name .. " ColorPicker"
    ColorPicker.BackgroundColor3 = Color or Color3_fromRGB()
    ColorPicker.BorderColor3 = Menu.Data.BackgroundColor
    ColorPicker.Position = UDim2_new(0, 115, 0, 2.5)
    ColorPicker.Size = UDim2_new(0, 15, 0, 10)
    ColorPicker.Font = Enum.Font.Code
    ColorPicker.Text = ""
    ColorPicker.TextColor3 = Color3_fromRGB(200, 200, 200)
    ColorPicker.TextSize = 14
    ColorPicker.MouseButton1Click:Connect(function()
        local Hue, Saturation, Value
        local MainSliding, SideSliding

        if FollowFrame then
            Destroy(FollowFrame)
            FollowButton = nil
        end

        local Frame = Instance_new("Frame")
        local MainChanger = Instance_new("ImageButton")
        local SideChanger = Instance_new("TextButton")
        local ColorOutput = Instance_new("Frame")
        local MainInfo = Instance_new("TextLabel")
        local SideInfo = Instance_new("TextLabel")
        local FinishButton = Instance_new("TextButton")
        local GradientColors = Instance_new("UIGradient")

        local function Update()
            ColorOutput.BackgroundColor3 = Color3_fromHSV(Hue, Saturation, Value)
            MainChanger.ImageColor3 = Color3_fromHSV(Hue, Saturation, Value)
        end

        Frame.Parent = Menu.Screen
        Frame.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2_new(0, ColorPicker.AbsolutePosition.X, 0, ColorPicker.AbsolutePosition.Y + 15)
        Frame.Size = UDim2_new(0, 156, 0, 156)

        MainChanger.Parent = Frame
        MainChanger.BorderSizePixel = 0
        MainChanger.Position = UDim2_new(0, 5, 0, 5)
        MainChanger.Size = UDim2_new(0, 125, 0, 125)
        MainChanger.Image = "rbxassetid://6881151852"
        MainChanger.ImageColor3 = ColorPicker.BackgroundColor3
        MainChanger.MouseButton1Down:Connect(function(X, Y)
            local AbsolutePosition = MainChanger.AbsolutePosition
            local AbsoluteSize = MainChanger.AbsoluteSize
            MainSliding = true
            Y -= 40
            local XPercentage = math_clamp((X - AbsolutePosition.X) / AbsoluteSize.X, 0, 0.95)
            local YPercentage = math_clamp((Y - AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1)
            MainInfo.Position = UDim2_new(XPercentage, 0, YPercentage, 0)
            Saturation, Value = XPercentage, 1 - YPercentage
            Update()
        end)
        MainChanger.MouseButton1Up:Connect(function()
            MainSliding = false
        end)
        MainChanger.MouseMoved:Connect(function(X, Y)
            if MainSliding and Mouse1 then
                local AbsolutePosition = MainChanger.AbsolutePosition
                local AbsoluteSize = MainChanger.AbsoluteSize
                Y -= 40
                local XPercentage = math_clamp((X - AbsolutePosition.X) / AbsoluteSize.X, 0, 0.95)
                local YPercentage = math_clamp((Y - AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1)
                MainInfo.Position = UDim2_new(XPercentage, 0, YPercentage, 0)
                Saturation, Value = XPercentage, 1 - YPercentage
                Update()
            else
                MainSliding = false
            end
        end)

        SideChanger.Parent = Frame
        SideChanger.BorderSizePixel = 0
        SideChanger.Position = UDim2_new(0, 135, 0, 5)
        SideChanger.Size = UDim2_new(0, 15, 0, 125)
        SideChanger.Text = ""
        SideChanger.MouseButton1Down:Connect(function(_, Y)
            SideSliding = true
            Y -= 40
            local YPercentage = math_clamp((Y - SideChanger.AbsolutePosition.Y) / SideChanger.AbsoluteSize.Y, 0, 1)
            SideInfo.Position = UDim2_new(0, 0, YPercentage, -5)
            Hue = YPercentage
            Update()
        end)
        SideChanger.MouseButton1Up:Connect(function()
            SideSliding = false
        end)
        SideChanger.MouseMoved:Connect(function(_, Y)
            if SideSliding and Mouse1 then
                Y -= 35
                local YPercentage = math_clamp((Y - SideChanger.AbsolutePosition.Y) / SideChanger.AbsoluteSize.Y, 0, 1)
                SideInfo.Position = UDim2_new(0, 0, YPercentage, -5)
                Hue = YPercentage
                Update()
            else
                SideSliding = false
            end
        end)

        ColorOutput.Parent = Frame
        ColorOutput.BackgroundColor3 = ColorPicker.BackgroundColor3
        ColorOutput.BorderSizePixel = 0
        ColorOutput.Position = UDim2_new(0, 5, 0, 135)
        ColorOutput.Size = UDim2_new(0, 125, 0, 15)

        MainInfo.Parent = MainChanger
        MainInfo.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
        MainInfo.BorderColor3 = Menu.Data.BackgroundColor
        MainInfo.BorderSizePixel = 1
        MainInfo.Size = UDim2_new(0, 5, 0, 5)
        MainInfo.Text = ""

        SideInfo.Parent = SideChanger
        SideInfo.BackgroundColor3 = Color3_fromRGB(255, 255, 255)
        SideInfo.BorderColor3 = Menu.Data.BackgroundColor
        SideInfo.BorderSizePixel = 1
        SideInfo.Size = UDim2_new(0, 15, 0, 5)
        SideInfo.Text = ""

        FinishButton.Parent = Frame
        FinishButton.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
        FinishButton.BorderSizePixel = 0
        FinishButton.Position = UDim2_new(0, 135, 0, 135)
        FinishButton.Size = UDim2_new(0, 15, 0, 15)
        FinishButton.Font = Enum.Font.Code
        FinishButton.Text = "OK"
        FinishButton.TextColor3 = Color3_fromRGB(200, 200, 200)
        FinishButton.TextSize = 14
        FinishButton.MouseButton1Click:Connect(function()
            ColorPicker.BackgroundColor3 = ColorOutput.BackgroundColor3
            Callback(ColorOutput.BackgroundColor3)
            Destroy(Frame)
            FollowFrame = nil
        end)

        GradientColors.Parent = SideChanger
        GradientColors.Rotation = 90
        GradientColors.Color = ColorSequence_new({
            ColorSequenceKeypoint_new(0, Color3_fromRGB(255, 0, 0)),
            ColorSequenceKeypoint_new(0.166, Color3_fromRGB(255, 255, 0)),
            ColorSequenceKeypoint_new(0.33, Color3_fromRGB(0, 255, 0)),
            ColorSequenceKeypoint_new(0.49, Color3_fromRGB(0, 255, 255)),
            ColorSequenceKeypoint_new(0.66, Color3_fromRGB(0, 0, 255)),
            ColorSequenceKeypoint_new(0.83, Color3_fromRGB(255, 0, 255)),
            ColorSequenceKeypoint_new(1, Color3_fromRGB(170, 0, 255)),
        })

        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 15)
        FollowButton = ColorPicker
    end)

    return ColorPicker
end

Menu.ComboBox = function(Tab, Container, Name, Items, Selected, Callback)
    local Name = Name or ""
    local Items = Items or {}
    local Selected = Selected or ""
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local ComboBox = Instance_new("TextButton")
    for i, Item in ipairs(Items) do
        table_remove(Items, i)
        table_insert(Items, i, tostring(Item))
    end
    ComboBox.Parent = Container
    ComboBox.Name = Name
    ComboBox.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    ComboBox.BorderColor3 = Menu.Data.BackgroundColor
    ComboBox.Position = UDim2_new(0, 8, 0, Container:GetAttribute("PushAmount"))
    ComboBox.Size = UDim2_new(0, 142, 0, 15)
    ComboBox.Font = Enum.Font.Code
    ComboBox.Text = Selected and tostring(Selected) or "None"
    ComboBox.TextColor3 = Color3_fromRGB(200, 200, 200)
    ComboBox.TextSize = 14
    ComboBox.TextStrokeTransparency = 0.5
    ComboBox.MouseButton1Click:Connect(function()
        local Frame = Menu.Screen:FindFirstChild(Name)
        if Frame then
            Destroy(Frame)
            return
        end
        if FollowFrame then
            Destroy(FollowFrame)
            FollowButton = nil
        end
        local Frame = Instance_new("ScrollingFrame")

        Frame.Parent = Menu.Screen
        Frame.Name = Name or ""
        Frame.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
        Frame.BorderColor3 = Menu.Data.BackgroundColor
        Frame.Position = UDim2_new(0, ComboBox.AbsolutePosition.X, 0, ComboBox.AbsolutePosition.Y + 15)
        Frame.ScrollBarImageColor3 = Color3_fromRGB()
        Frame.ScrollBarThickness = 5
        Frame.Size = UDim2_new(0, 142, 0, #Items > 5 and 75 or #Items * 15)
        Frame.CanvasSize = #Items > 5 and UDim2_new(0, 0, 0, #Items * 15) or UDim2_new()
        Frame.ClipsDescendants = true
        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 15)
        FollowButton = ComboBox

        for _, Item in ipairs(Items) do
            local Button = Instance_new("TextButton")
            Button.Parent = Frame
            Button.Name = Item
            Button.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
            Button.BorderSizePixel = 0
            Button.Position = UDim2_new(0, 0, 0, #GetChildren(Frame) * 15 - 15)
            Button.Size = UDim2_new(1, 0, 0, 15)
            Button.Font = Enum.Font.Code
            Button.Text = Item
            Button.TextColor3 = ComboBox.Text ~= Item and Color3_fromRGB(200, 200, 200) or Menu.Data.Color
            Button.TextSize = 14
            Button.TextStrokeTransparency = 0.5
            Button.MouseButton1Click:Connect(function()
                ComboBox.Text = Item
                Callback(Item)
                Destroy(Frame)
            end)
        end
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 20)
    Container.Size += UDim2_new(0, 0, 0, 20)

    return ComboBox
end

Menu.MultiBox = function(Tab, Container, Name, Items, SelectedItems, Callback)
    local Name = Name or ""
    local Items = Items or {}
    local SelectedItems = SelectedItems or {}
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    for i, Item in ipairs(Items) do
        table_remove(Items, i)
        table_insert(Items, i, tostring(Item))
    end
    for i, SelectedItem in ipairs(SelectedItems) do
        table_remove(SelectedItems, i)
        table_insert(SelectedItems, i, tostring(SelectedItem))
    end
    local MultiBox = Instance_new("TextButton")
    MultiBox.Parent = Container
    MultiBox.Name = Name
    MultiBox.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    MultiBox.BorderColor3 = Menu.Data.BackgroundColor
    MultiBox.Position = UDim2_new(0, 8, 0, Container:GetAttribute("PushAmount"))
    MultiBox.Size = UDim2_new(0, 142, 0, 20)
    MultiBox.Font = Enum.Font.Code
    MultiBox.Text = SelectedItems and #SelectedItems > 0 and table_concat(SelectedItems, ", ") or "None"
    MultiBox.TextColor3 = Color3_fromRGB(200, 200, 200)
    MultiBox.TextSize = 14
    MultiBox.TextTruncate = Enum.TextTruncate.AtEnd
    MultiBox.TextStrokeTransparency = 0.5
    MultiBox.MouseButton1Click:Connect(function()
        local Frame = Menu.Screen:FindFirstChild(Name)
        if Frame then
            Destroy(Frame)
            return
        end
        if FollowFrame then
            Destroy(FollowFrame)
            FollowButton = nil
        end
        local Frame = Instance_new("ScrollingFrame")
        
        Frame.Parent = Menu.Screen
        Frame.Name = Name or ""
        Frame.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
        Frame.BorderColor3 = Menu.Data.BackgroundColor
        Frame.Position = UDim2_new(0, MultiBox.AbsolutePosition.X, 0, MultiBox.AbsolutePosition.Y + 20)
        Frame.ScrollBarImageColor3 = Color3_fromRGB()
        Frame.ScrollBarThickness = 5
        Frame.Size = UDim2_new(0, 142, 0, #Items > 5 and 80 or #Items * 15)
        Frame.CanvasSize = #Items > 5 and UDim2_new(0, 0, 0, #Items * 15) or UDim2_new()
        Frame.ClipsDescendants = true
        FollowFrame = Frame
        FollowFrame:SetAttribute("FollowPosition", 20)
        FollowButton = MultiBox

        for _, Item in ipairs(Items) do
            local Button = Instance_new("TextButton")
            Button.Parent = Frame
            Button.Name = Item
            Button.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
            Button.BorderSizePixel = 0
            Button.Position = UDim2_new(0, 0, 0, #GetChildren(Frame) * 15 - 15)
            Button.Size = UDim2_new(1, 0, 0, 15)
            Button.Font = Enum.Font.Code
            Button.Text = Item
            Button.TextColor3 = not string_find(MultiBox.Text, Item) and Color3_fromRGB(200, 200, 200) or Menu.Data.Color
            Button.TextSize = 14
            Button.TextStrokeTransparency = 0.5
            Button.MouseButton1Click:Connect(function()
                if table_find(SelectedItems, Item) then
                    for i, v in ipairs(SelectedItems) do
                        if v == Item then
                            table_remove(SelectedItems, i)
                        end
                    end
                    Button.TextColor3 = Color3_fromRGB(200, 200, 200)
                else
                    table_insert(SelectedItems, Item)
                    Button.TextColor3 = Menu.Data.Color
                end
                MultiBox.Text = #SelectedItems > 0 and table_concat(SelectedItems, ", ") or "None"
                Callback(SelectedItems)
            end)
        end
    end)

    Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") + 25)
    Container.Size += UDim2_new(0, 0, 0, 25)

    return MultiBox
end

Menu.Bindable = function(Tab, Container, Label, Key, Callback)
    local Key = Key or Enum.KeyCode.Unknown
    local Callback = Callback or tostring
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local Bindable = Instance_new("TextButton")
    Bindable.Parent = Label
    Bindable.Name = Label.Name .. " Bindable"
    Bindable.BackgroundTransparency = 1
    Bindable.Position = UDim2_new(0, 90, 0, 0)
    Bindable.Size = UDim2_new(0, 40, 0, 15)
    Bindable.Font = Enum.Font.Code
    local Text = string_upper(Key.Name)
    for k, v in pairs(Menu.KeybindNames) do
        if string_find(Text, k) then
            Text = string_gsub(Text, k, v)
        end
    end
    Bindable.Text = Text and "[" .. Text .. "]" or "[...]"
    Bindable.TextColor3 = Color3_fromRGB(180, 180, 180)
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

Menu.Slider = function(Tab, Container, Label, Min, Max, Init, Scale, Callback)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Label = Container[Label]
    local Callback = Callback or tostring

    local Slider = Instance_new("Frame")
    local Info = Instance_new("TextLabel")
    local Button = Instance_new("TextButton")
    local ValueBox = Instance_new("TextBox")

    local function UpdateSize(X)
        local Percentage = math_clamp((X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
        Info.Size = UDim2_new(Percentage, 0, 1, 0)
        ValueBox.Text = string_format("%." .. Slider:GetAttribute("Scale") .. "f", Slider:GetAttribute("Min") + Slider:GetAttribute("Max") * Percentage)
        Callback(tonumber(ValueBox.Text))
    end

    Min = Min or 0
    Max = Max or 100
    Max -= Min
    Label.Parent.Size += UDim2_new(0, 0, 0, 10)
    Label.Parent:SetAttribute("PushAmount", Label.Parent:GetAttribute("PushAmount") + 10)

    Slider.Parent = Label
    Slider.Name = Label.Text .. " Slider"
    Slider.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    Slider.BorderColor3 = Menu.Data.BackgroundColor
    Slider.Position = UDim2_new(0, -12, 0, 20)
    Slider.Size = UDim2_new(0, 142, 0, 5)
    Slider:SetAttribute("Init", Init or 0)
    Slider:SetAttribute("Min", Min)
    Slider:SetAttribute("Max", Max)
    Slider:SetAttribute("Scale", Scale or 1)
    Slider:SetAttribute("Sliding", false)

    Info.Parent = Slider
    Info.Name = "Info"
    Info.BackgroundColor3 = Menu.Data.Color
    Info.BorderSizePixel = 0
    Info.Size = UDim2_new(math_clamp((Slider:GetAttribute("Init") - Slider:GetAttribute("Min")) / Slider:GetAttribute("Max"), 0, 1), 0, 1, 0)
    Info.TextColor3 = Color3_fromRGB(200, 200, 200)
    Info.Text = ""
    Menu.Elements.Background[Info] = Info

    Button.Parent = Slider
    Button.Name = "Button"
    Button.BackgroundTransparency = 1
    Button.Position = UDim2_new(-0.1, 0, -1, 0)
    Button.Size = UDim2_new(1.2, 0, 2, 0)
    Button.Text = ""
    Button.MouseButton1Down:Connect(function(X)
        Slider:SetAttribute("Sliding", true)
        UpdateSize(X)
    end)
    Button.MouseButton1Up:Connect(function()
        Slider:SetAttribute("Sliding", false)
    end)
    Button.MouseMoved:Connect(function(X)
        if Slider:GetAttribute("Sliding") and Mouse1 then
            UpdateSize(X)
        else
            Slider:SetAttribute("Sliding", false)
        end
    end)

    ValueBox.Parent = Label
    ValueBox.Name = "Value"
    ValueBox.BackgroundColor3 = Color3_fromRGB(40, 40, 40)
    ValueBox.BorderSizePixel = 0
    ValueBox.Position = UDim2_new(0, 115, 0, 0)
    ValueBox.Size = UDim2_new(0, 15, 0, 15)
    ValueBox.Font = Enum.Font.Code
    ValueBox.Text = Slider:GetAttribute("Init")
    ValueBox.TextColor3 = Color3_fromRGB(200, 200, 200)
    ValueBox.TextSize = 14
    ValueBox.TextStrokeTransparency = 0.5
    ValueBox.FocusLost:Connect(function()
        local Whitelist = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."}
        local Text = ""
        for _, v in ipairs(string_split(ValueBox.Text, "")) do
            if table_find(Whitelist, v) then
                Text ..= v
            end
        end
        Text = tonumber(Text)
        local Min = Slider:GetAttribute("Min")
        local Max = Slider:GetAttribute("Max")
        local Value = Text and math_clamp(Text, Min, Max + Min) or Min
        Info.Size = Text and UDim2_new(math_clamp((Value - Min) / Max, 0, 1), 0, 1, 0) or UDim2_new(0, 0, 1, 0)
        ValueBox.Text = string_format("%." .. Slider:GetAttribute("Scale") .. "f", Value)
        Callback(Value)
    end)

    return {
        Slider = Slider,
        Info = Info, 
        Button = Button, 
        ValueBox = ValueBox
    }
end

Menu.Notify = function(Name, Message, Time)
    local Notification = Instance_new("ImageLabel")
    local Title = Instance_new("TextLabel")
    local Text = Instance_new("TextLabel")

    Notification.Parent = Notifications
    Notification.Name = "Notification"
    Notification.BackgroundColor3 = Menu.Data.BackgroundColor
    Notification.BorderColor3 =  Color3_fromRGB(0, 0, 0)
    Notification.BorderSizePixel = 2
    Notification:TweenPosition(UDim2_new(0.8, -110, 0, #GetChildren(Notifications) * 70))
    Notification.Size = UDim2_new(0, 220, 0, 60)
    Notification.Visible = true

    Title.Parent = Notification
    Title.Name = "Title"
    Title.BackgroundColor3 = Color3_fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2_new(1, 0, 0, 15)
    Title.Font = Enum.Font.Code
    Title.Text = Name
    Title.TextColor3 = Color3_fromRGB(200, 200, 200)
    Title.TextSize = 14
    Menu.Line("Up", Title)

    Text.Parent = Notification
    Text.Name = "Text"
    Text.BackgroundTransparency = 1
    Text.Position = UDim2_new(0.05, 0, 0, 20)
    Text.Size = UDim2_new(0.9, 0, 1, -20)
    Text.Font = Enum.Font.Code
    Text.Text = Message
    Text.TextColor3 = Color3_fromRGB(180, 180, 180)
    Text.TextSize = 14
    Text.TextWrapped = true
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Top

    delay(Time or 5, function()
        local Tween = Notification:TweenPosition(UDim2_new(1, 0, 0, Notification.AbsolutePosition.Y), nil, nil, 0.4, true, function()
            Destroy(Notification)
        end)
    end)

    return Notification
end

Menu.Update = function(Tab, Container, ...)
    local Container = Tabs[Tab].Left:FindFirstChild(Container) and Tabs[Tab].Left[Container] or Tabs[Tab].Right[Container]
    local Arguments = {...}
    local Item = Container[Arguments[2]]
    local Item_Name = Arguments[1]
    if Item_Name == "Label" or Item_name == "Button" or Item_Name == "TextBox" then
        Item.Text = Arguments[3]
    elseif Item_Name == "CheckBox" then
        local CheckBox = Item[Item.Name .. " CheckBox"]
        CheckBox.BackgroundColor3 = Arguments[3] and Menu.Data.Color or Color3_fromRGB(40, 40, 40)
        if Arguments[3] then
            Menu.Elements.Background[CheckBox] = CheckBox
        else
            Menu.Elements.Background[CheckBox] = nil
        end
    elseif Item_Name == "ColorPicker" then
        Item[Item.Name .. " ColorPicker"].BackgroundColor3 = Arguments[3] or Color3_fromRGB()
    elseif Item_Name == "ComboBox" then
        local Position, Name = Item.Position, Item.Name
        Destroy(Item)
        Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") - 20)
        Container.Size -= UDim2_new(0, 0, 0, 20)
        local ComboBox = Menu.ComboBox(Tab, Container.Name, Name, Arguments[3], Arguments[4], Arguments[5])
        ComboBox.Position = Position
    elseif Item_Name == "MultiBox" then
        local Position, Name = Item.Position, Item.Name
        Destroy(Item)
        Container:SetAttribute("PushAmount", Container:GetAttribute("PushAmount") - 25)
        Container.Size -= UDim2_new(0, 0, 0, 25)
        local MultiBox = Menu.MultiBox(Tab, Container.Name, Name, Arguments[3], Arguments[4], Arguments[5])
        MultiBox.Position = Position
    elseif Item_Name == "Bindable" then
        local Keybind = Arguments[3] or "..."
        Item[Item.Name .. " Bindable"].Text = "[" .. Keybind .. "]"
    elseif Item_Name == "Slider" then
        local Min, Max, Init, Scale = Arguments[3], Arguments[4], Arguments[5], Arguments[6]
        Item.Value.Text = Init
        local Item = Item[Item.Name .. " Slider"]
        Item:SetAttribute("Init", Init or 0)
        Item:SetAttribute("Min", Min or 0)
        Item:SetAttribute("Max", Max or 100)
        Item:SetAttribute("Scale", Scale or 0)
        Item.Info.Size = UDim2_new(math_clamp((Init - Min) / Max - Min, 0, 1), 0, 1, 0)
    end
end

Menu.OnInput = function(Input, Process)
    if BindableButton then
        local Keyboard = Input.UserInputType == Enum.UserInputType.Keyboard
        local Text = Keyboard and string_upper(Input.KeyCode.Name) or string_upper(Input.UserInputType.Name)
        for k, v in pairs(Menu.KeybindNames) do
            if string_find(Text, k) then
                Text = string_gsub(Text, k, v)
            end
        end
        BindableButton.Text = Text and "[" .. Text .. "]" or "[...]"
        Call(Keyboard and Input.KeyCode or Input.UserInputType)
        Call, BindableButton = nil, nil
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Mouse1 = true
    end
end

Menu.OnInputEnded = function(Input, Process)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Mouse1 = false
    end
end

UserInput.InputBegan:Connect(Menu.OnInput)
UserInput.InputEnded:Connect(Menu.OnInputEnded)

return Menu
