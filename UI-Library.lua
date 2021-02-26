local Library = {
    Title = ""
}

local RunService = game:GetService("RunService");
local UIS = game:GetService("UserInputService");

local TabCount = 0

local MouseHolding = false
local RecordButton = nil
local SliderButton = nil
local SliderInfo = nil
local SliderMaxValue = 0

local Settings = {
    ["Shade1"] = "255, 255, 255",
    ["Shade1B"] = 0,
    ["Shade2"] = "220, 220, 220",
    ["Shade2B"] = 0,
    ["Shade3"] = "200, 200, 200",
    ["Shade3B"] = 0,
    ["Shade4"] = "180, 180, 180",
    ["Shade4B"] = 0,
    ["Shade5"] = "160, 160, 160",
    ["Shade5B"] = 0,
    ["TextColor"] = "0, 0, 0",
    ["TextColor2"] = "50, 50, 50",
    ["SelectedTabTextColor"] = "",
    ["UnselectedTabTextColor"] = "",
    ["PrimaryColor"] = "85, 85, 255";
}

local function Color(String)
    local Colors = String:split(", ");
    local Color = Color3.fromRGB(unpack(Colors));
    return Color
end

local StarterGui = Instance.new("ScreenGui");
local MainFrame = Instance.new("Frame");
local TopBar = Instance.new("Frame");
local TextLabel = Instance.new("TextLabel");
local TabsHolder = Instance.new("Frame");
local UIGridLayout = Instance.new("UIGridLayout");
local Holder = Instance.new("Frame");

StarterGui.Parent = game:GetService("CoreGui");
StarterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = StarterGui
MainFrame.BackgroundColor3 = Color(Settings["Shade4"]);
MainFrame.BackgroundTransparency = Settings["Shade4B"]
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180);
MainFrame.Size = UDim2.new(0, 500, 0, 275);
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color(Settings["Shade1"]);
TopBar.BackgroundTransparency = Settings["Shade1B"]
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30);

TextLabel.Parent = TopBar
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 5, 0, 0);
TextLabel.Size = UDim2.new(0, 100, 0, 30);
TextLabel.Font = Enum.Font.GothamSemibold
TextLabel.Text = ""
TextLabel.TextColor3 = Color(Settings["TextColor"]);
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

TabsHolder.Parent = MainFrame
TabsHolder.BackgroundColor3 = Color(Settings["Shade2"]);
TabsHolder.BackgroundTransparency = Settings["Shade2B"]
TabsHolder.BorderSizePixel = 0
TabsHolder.Position = UDim2.new(0, 0, 0, 30);
TabsHolder.Size = UDim2.new(0, 500, 0, 25);

UIGridLayout.Parent = TabsHolder
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0, 0, 0, 0);

Holder.Parent = MainFrame
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0, 0, 0.2, 0);
Holder.Size = UDim2.new(0, 500, 0, 220);

function Library:NewTab(Title)
    TextLabel.Text = MainTitle
    TabCount = TabCount + 1
    UIGridLayout.CellSize = UDim2.new(0, 500 / TabCount, 1, 0);
    local Section;
    local AlreadySplit = false
    local Gui = {}
    local TextButton = Instance.new("TextButton");
    local Tab = Instance.new("Frame");
    local Splitter = Instance.new("Frame");
    local SectionHolder = Instance.new("Frame");
    local UIGridLayout = Instance.new("UIGridLayout");

    TextButton.Parent = TabsHolder
    TextButton.BackgroundColor3 = Color(Settings["Shade3"]);
    TextButton.BackgroundTransparency = Settings["Shade3B"]
    TextButton.BorderSizePixel = 0
    TextButton.Font = Enum.Font.GothamSemibold
    TextButton.Text = Title
    TextButton.TextColor3 = Color(Settings["TextColor"]);
    TextButton.TextSize = 12

    Tab.Parent = Holder
    Tab.BackgroundTransparency = 1
    Tab.Size = UDim2.new(0, 500, 0, 220);

    Splitter.Parent = Tab
    Splitter.BackgroundColor3 = Color(Settings["Shade5"]);
    Splitter.BackgroundTransparency = Settings["Shade5B"]
    Splitter.BorderSizePixel = 0
    Splitter.Position = UDim2.new(0.5, -10, 0, 0);
    Splitter.Size = UDim2.new(0, 20, 0, 220);

    SectionHolder.Parent = Tab
    SectionHolder.BackgroundTransparency = 1
    SectionHolder.Position = UDim2.new(0, 5, 0, 5);
    SectionHolder.Size = UDim2.new(0, 495, 0, 215);

    UIGridLayout.Parent = SectionHolder
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 25, 0, 0);
    UIGridLayout.CellSize = UDim2.new(0, 235, 1, 0);

    local function NewSection()
        Section = Instance.new("ScrollingFrame");
        local UIListLayout = Instance.new("UIListLayout");

        Section.Parent = SectionHolder
        Section.Active = true
        Section.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Section.BackgroundTransparency = 1
        Section.Size = UDim2.new(0, 100, 1, 0);
        Section.CanvasSize = UDim2.new(0, 0, 1, 0);
        Section.ScrollBarThickness = 0

        UIListLayout.Parent = Section
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local function ChangeTab()
        local Children = Holder:GetChildren();
        for _,Tab in ipairs(Children) do
            Tab.Visible = false
        end
        local Buttons = TabsHolder:GetChildren();
        for _,Button in ipairs(Buttons) do
            if Button:IsA("TextButton") then
                Button.TextColor3 = Color(Settings["TextColor2"]);
            end
        end
        Tab.Visible = true
        TextButton.TextColor3 = Color(Settings["TextColor"]);
    end

    NewSection();
    ChangeTab();
    TextButton.MouseButton1Click:Connect(ChangeTab);

    function Gui:Split()
        if AlreadySplit then
            warn("You can only split once per tab!")
            return
        end
        AlreadySplit = true
        NewSection();
    end

    function Gui:NewLabel(Text)
        local Gui = {}
        local Label = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");

        Label.Parent = Section
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 25);

        TextLabel.Parent = Label
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, 0, 0, 20);
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Text
        TextLabel.TextColor3 = Color(Settings["TextColor"]);
        TextLabel.TextSize = 10
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    end

    function Gui:NewButton(Text, Callback)
        local Button = Instance.new("Frame");
        local TextButton = Instance.new("TextButton");

        Button.Parent = Section
        Button.BackgroundTransparency = 1
        Button.Size = UDim2.new(1, 0, 0, 25);

        TextButton.Parent = Button
        TextButton.BackgroundColor3 = Color(Settings["Shade5"]);
        TextButton.BackgroundTransparency = Settings["Shade5B"]
        TextButton.BorderSizePixel = 0
        --TextButton.Position = UDim2.new(0, 0, 0, 0);
        TextButton.Size = UDim2.new(0, 85, 0, 20);
        TextButton.Font = Enum.Font.GothamSemibold
        TextButton.Text = Text
        TextButton.TextColor3 = Color(Settings["TextColor"]);
        TextButton.TextSize = 10

        local function OnClick()
            Callback();
        end

        TextButton.MouseButton1Click:Connect(OnClick);
    end

    function Gui:NewCheckbox(Text, Boolean, Callback)
        local Checkbox = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");
        local TextButton = Instance.new("TextButton");

        Checkbox.Parent = Section
        Checkbox.BackgroundTransparency = 1
        Checkbox.Size = UDim2.new(1, 0, 0, 25);

        TextLabel.Parent = Checkbox
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 115, 0, 20);
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Text
        TextLabel.TextColor3 = Color(Settings["TextColor"]);
        TextLabel.TextSize = 10
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        TextButton.Parent = Checkbox
        if Boolean then
            TextButton.BackgroundColor3 = Color(Settings["PrimaryColor"]);
        else
            TextButton.BackgroundColor3 = Color(Settings["Shade1"]);
            TextButton.BackgroundTransparency = Settings["Shade1B"]
        end
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0, 125, 0, 0);
        TextButton.Size = UDim2.new(0, 20, 0, 20);
        TextButton.Text = ""

        local function OnClick()
            if Boolean then
                TextButton.BackgroundColor3 = Color(Settings["Shade1"]);
                TextButton.BackgroundTransparency = Settings["Shade1B"]
            else
                TextButton.BackgroundColor3 = Color(Settings["PrimaryColor"]);
            end
            Boolean = not Boolean
            Callback();
        end

        TextButton.MouseButton1Click:Connect(OnClick);
    end

    function Gui:NewColorButton(Text, Col, Callback)
        local ColorButton = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");
        local TextButton = Instance.new("TextButton");

        ColorButton.Parent = Section
        ColorButton.BackgroundTransparency = 1
        ColorButton.Size = UDim2.new(1, 0, 0, 25);
        
        TextLabel.Parent = ColorButton
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 115, 0, 20);
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Text
        TextLabel.TextColor3 = Color(Settings["TextColor"]);
        TextLabel.TextSize = 10
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        TextButton.Parent = ColorButton
        TextButton.BackgroundColor3 = Color(Col);
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0, 125, 0, 0);
        TextButton.Size = UDim2.new(0, 20, 0, 20);
        TextButton.Text = ""

        local function OnClick()
            local Frame = Instance.new("Frame");
            local TextButton = Instance.new("TextButton");
            local TextBox = Instance.new("TextBox");
            local TextLabel = Instance.new("TextLabel");
            local Frame_2 = Instance.new("Frame");

            Frame.Parent = StarterGui
            Frame.Active = true
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BorderSizePixel = 0
            Frame.Position = UDim2.new(0.15, -50, 0.2, -50)
            Frame.Size = UDim2.new(0, 100, 0, 100)
            Frame.Draggable = true

            TextButton.Parent = Frame
            TextButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            TextButton.BorderSizePixel = 0
            TextButton.Position = UDim2.new(0, 0, 1, -20)
            TextButton.Size = UDim2.new(1, 0, 0, 20)
            TextButton.Font = Enum.Font.GothamSemibold
            TextButton.Text = "Apply Changes"
            TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextButton.TextSize = 12

            TextBox.Parent = Frame
            TextBox.BackgroundColor3 = Color3.fromRGB(220, 220, 220);
            TextBox.BorderSizePixel = 0
            TextBox.Position = UDim2.new(0.2, 0, 0, 5);
            TextBox.Size = UDim2.new(0, 60, 0, 20);
            TextBox.Font = Enum.Font.SourceSans
            TextBox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0);
            TextBox.PlaceholderText = "0"
            TextBox.Text = "0"
            TextBox.TextColor3 = Color3.fromRGB(0, 0, 0);
            TextBox.TextSize = 14

            TextLabel.Parent = Frame
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 0, 0, 5);
            TextLabel.Size = UDim2.new(0, 20, 0, 20);
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "R"
            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0);
            TextLabel.TextSize = 14

            local TextBox_2 = TextBox:Clone();
            TextBox_2.Parent = Frame
            TextBox_2.Position = UDim2.new(0.2, 0, 0, 30);

            local TextLabel_2 = TextLabel:Clone();
            TextLabel_2.Parent = Frame
            TextLabel_2.Position = UDim2.new(0, 0, 0, 30);
            TextLabel_2.Text = "G"

            local TextBox_3 = TextBox:Clone();
            TextBox_3.Parent = Frame
            TextBox_3.Position = UDim2.new(0.2, 0, 0, 55);

            local TextLabel_3 = TextLabel:Clone();
            TextLabel_3.Parent = Frame
            TextLabel_3.Position = UDim2.new(0, 0, 0, 55);
            TextLabel_3.Text = "B"

            Frame_2.Parent = Frame
            Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            Frame_2.BorderSizePixel = 0
            Frame_2.Position = UDim2.new(0.9, -5, 0.4, -35);
            Frame_2.Size = UDim2.new(0, 10, 0, 70);

            local function OnClick()
                local ColorButton = ColorButton:FindFirstChild("TextButton");
                local Col = Frame_2.BackgroundColor3
                Frame:Destroy();
                ColorButton.BackgroundColor3 = Col
                Callback(Col);
            end

            local function OnFocusLost()
                local R = tonumber(TextBox.Text);
                local G = tonumber(TextBox_2.Text);
                local B = tonumber(TextBox_3.Text);

                Frame_2.BackgroundColor3 = Color3.fromRGB(R, G, B);
            end

            TextBox.FocusLost:Connect(OnFocusLost);
            TextBox_2.FocusLost:Connect(OnFocusLost);
            TextBox_3.FocusLost:Connect(OnFocusLost);
            TextButton.MouseButton1Click:Connect(OnClick);
        end

        TextButton.MouseButton1Click:Connect(OnClick);
    end

    function Gui:NewBindable(Text, Key, Callback)
        local Bindable = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");
        local TextButton = Instance.new("TextButton");
        
        Bindable.Parent = Section
        Bindable.BackgroundTransparency = 1
        Bindable.Size = UDim2.new(1, 0, 0, 25)

        TextLabel.Parent = Bindable
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 85, 0, 20);
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Text
        TextLabel.TextColor3 = Color(Settings["TextColor"]);
        TextLabel.TextSize = 10
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        TextButton.Parent = Bindable
        TextButton.BackgroundColor3 = Color(Settings["Shade5"]);
        TextButton.BackgroundTransparency = Settings["Shade5B"]
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0, 95, 0, 0);
        TextButton.Size = UDim2.new(0, 50, 0, 20);
        TextButton.Font = Enum.Font.GothamSemibold
        TextButton.Text = Key.Name
        TextButton.TextColor3 = Color(Settings["TextColor"]);
        TextButton.TextSize = 10

        local function OnClick()
            if TextButton.Text == "Recording..." then
                return
            end
            TextButton.Text = "Recording..."
            RecordButton = TextButton
        end

        local function OnTextChanged()
            local Key;
            local Text = TextButton.Text
            if Text == "Recording..." then
                return
            end
            local _, Error = pcall(function()
                Key = Enum.KeyCode[Text]
            end)
            if Error then
                Key = Enum.UserInputType[Text]
            end
            Callback(Key);
        end

        TextButton.MouseButton1Click:Connect(OnClick);
        TextButton:GetPropertyChangedSignal("Text"):Connect(OnTextChanged);
    end

    function Gui:NewSlider(Text, Value, Min, Max, Callback)
        if Value > Max or Value < Min then
            warn("Slider's value cannot be more or less than the min or max parameter's given!");
            return
        end
        local Percentage = Value / Max
        local Slider = Instance.new("Frame");
        local TextLabel = Instance.new("TextLabel");
        local Frame = Instance.new("Frame");
        local TextButton = Instance.new("TextButton");
        local TextBox = Instance.new("TextBox");

        Slider.Parent = Section
        Slider.BackgroundTransparency = 1
        Slider.Position = UDim2.new(-0.0212765951, 0, 0.288372099, 0);
        Slider.Size = UDim2.new(1, 0, 0, 25);

        TextLabel.Parent = Slider
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 85, 0, 20);
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = Text
        TextLabel.TextColor3 = Color(Settings["TextColor"]);
        TextLabel.TextSize = 10
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        Frame.Parent = Slider
        Frame.BackgroundColor3 = Color(Settings["Shade5"]);
        Frame.BackgroundTransparency = Settings["Shade5B"]
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(0, 95, 0, 0);
        Frame.Size = UDim2.new(0, 100, 0, 20);

        TextButton.Parent = Frame
        TextButton.BackgroundColor3 = Color(Settings["PrimaryColor"]);
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(Percentage, 0, 0, 0);
        TextButton.Size = UDim2.new(0, 5, 1, 0);
        TextButton.Text = ""

        TextBox.Parent = Slider
        TextBox.BackgroundColor3 = Color(Settings["Shade5"]);
        TextBox.BackgroundTransparency = Settings["Shade5B"]
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0.86383, 0, 0, 0);
        TextBox.Size = UDim2.new(0, 25, 0, 20);
        TextBox.Font = Enum.Font.SourceSans
        TextBox.Text = Value
        TextBox.TextColor3 = Color(Settings["TextColor"]);
        TextBox.TextSize = 14

        local function OnDown()
            SliderButton = TextButton
            SliderInfo = TextBox
            SliderMaxValue = Max
        end

        local function OnRelease()
            SliderButton = nil
            SliderInfo = nil
            SliderMaxValue = 0
        end

        local function OnTextChanged()
            local Text = TextBox.Text
            local Length = Text:len();
            local MinLength = tostring(Min):len();
            local MaxLength = tostring(Max):len();
            local Value = tonumber(Text);
            if not Value then
                return
            end
            if (Value > Max or Value < Min) or (Length > MaxLength or Length < MinLength) then
                TextBox:ReleaseFocus();
                TextBox.Text = Min
                return
            end
            local Percentage = Value / Max
            TextButton.Position = UDim2.new(Percentage, 0, 0, 0);
            Callback(Value);
        end

        TextButton.MouseButton1Down:Connect(OnDown);
        TextButton.MouseButton1Up:Connect(OnRelease);
        TextBox:GetPropertyChangedSignal("Text"):Connect(OnTextChanged);
    end

    function Gui:NewGroupbox(Value, Boxes, Callback)
        local Count = #Boxes * 20
        local Groupbox = Instance.new("Frame");
        local TextButton = Instance.new("TextButton");
        local ScrollingFrame = Instance.new("ScrollingFrame");
        local UIListLayout = Instance.new("UIListLayout");

        Groupbox.Parent = Section
        Groupbox.BackgroundTransparency = 1
        Groupbox.Position = UDim2.new(0, 0, 0.581395328, 0);
        Groupbox.Size = UDim2.new(1, 0, 0.255813956, 25);

        TextButton.Parent = Groupbox
        TextButton.BackgroundTransparency = 1
        TextButton.Position = UDim2.new(0.5, -50, 0, 0);
        TextButton.Size = UDim2.new(0, 100, 0, 20);
        TextButton.Font = Enum.Font.GothamSemibold
        TextButton.Text = Value
        TextButton.TextColor3 = Color(Settings["TextColor"]);
        TextButton.TextSize = 10

        ScrollingFrame.Parent = Groupbox
        ScrollingFrame.Active = true
        ScrollingFrame.BackgroundColor3 = Color(Settings["Shade5"]);
        ScrollingFrame.BackgroundTransparency = Settings["Shade5B"]
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.Position = UDim2.new(0.5, -50, 0.6, -30);
        ScrollingFrame.Size = UDim2.new(0, 100, 0, 60);
        ScrollingFrame.Visible = false
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Count);
        ScrollingFrame.ScrollBarThickness = 6

        UIListLayout.Parent = ScrollingFrame
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function NewBox(Name)
            local TextButton_2 = Instance.new("TextButton");
            TextButton_2.Parent = ScrollingFrame
            TextButton_2.BackgroundColor3 = Color(Settings["Shade5"]);
            TextButton_2.BackgroundTransparency = Settings["Shade5B"]
            TextButton_2.BorderSizePixel = 0
            TextButton_2.Size = UDim2.new(0, 100, 0, 20);
            TextButton_2.Font = Enum.Font.GothamSemibold
            TextButton_2.Text = Name
            TextButton_2.TextColor3 = Color(Settings["TextColor"]);
            TextButton_2.TextSize = 10

            local function OnClick()
                Value = Name
                if TextButton.Text == Value then
                    ScrollingFrame.Visible = false
                    return
                end
                TextButton.Text = Value
                Callback(Value);
            end
            TextButton_2.MouseButton1Click:Connect(OnClick);
        end

        for i = 1, #Boxes do
            NewBox(Boxes[i]);
        end

        local function OnClick()
            ScrollingFrame.Visible = not ScrollingFrame.Visible
        end
        TextButton.MouseButton1Click:Connect(OnClick);

    end
    return Gui
end

function Library:ChangeColor(Setting, Color)
    Settings[Setting] = Color
end

local function InputBegan(Input, Process)
    local Key = Input.KeyCode
    local Type = Input.UserInputType
    if Type == Enum.UserInputType.MouseButton1 then
        MouseHolding = true
    end
    if RecordButton then
        RecordButton.Text = (Key.Name ~= "Unknown" and Key.Name or Type ~= "Unknown" and Type.Name);
        RecordButton = nil
    end
end

local function InputEnded(Input, Process)
    local Key = Input.KeyCode
    local Type = Input.UserInputType
    if Type == Enum.UserInputType.MouseButton1 then
        MouseHolding = false
        SliderButton = nil
    end
end

local function Loop()
    if MouseHolding then
        if not SliderButton or not SliderInfo or not SliderMaxValue then
            return
        end
        local MousePosition = UIS:GetMouseLocation();
        local SliderSize = SliderButton.Parent.AbsoluteSize
        local SliderPosition = SliderButton.Parent.AbsolutePosition
        local Position = (MousePosition.X - SliderPosition.X) / SliderSize.X
        local Percentage = math.clamp(Position, 0, 1);
        local Value = math.floor(Percentage * SliderMaxValue);
        SliderInfo.Text = Value
        SliderButton.Position = UDim2.new(Percentage, 0, 0, 0);
    end
end

UIS.InputBegan:Connect(InputBegan);
UIS.InputEnded:Connect(InputEnded);
RunService.RenderStepped:Connect(Loop);

return Library
