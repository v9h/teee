local Gui = {}

local CoreGui = game:GetService("CoreGui");
local RunService = game:GetService("RunService");
local UIS = game:GetService("UserInputService");

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Parent = CoreGui

local TabIndexCount = 0

local Notifications = {}

local function UpdateNotifications()
    local Count = -1
    for _,Notification in ipairs(Notifications) do
        Count += 1
        Notification:TweenPosition(UDim2.new(0.8, -110, Count / 8.5, -20), "InOut", "Quart", 0.5, true, nil);
    end
end

function Gui:Main()
    local Gui = {}
    local Base = Instance.new("Frame");
    local TabIndex = Instance.new("ScrollingFrame");
    local UIGridLayout = Instance.new("UIGridLayout");
    local Tabs = Instance.new("Frame");
    
    Base.Active = true
    Base.Draggable = true
    Base.Parent = ScreenGui
    Base.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    Base.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Base.BorderSizePixel = 2
    Base.Position = UDim2.new(0.5, -150, 0.5, -200);
    Base.Size = UDim2.new(0, 300, 0, 400);
    
    TabIndex.Parent = Base
    TabIndex.Active = true
    TabIndex.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    TabIndex.BorderSizePixel = 0
    TabIndex.Size = UDim2.new(1, 0, 0, 15);
    TabIndex.CanvasSize = UDim2.new(0, 0, 0, 0);
    TabIndex.ScrollBarThickness = 0
    
    UIGridLayout.Parent = TabIndex
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 2, 0, 0);
    UIGridLayout.CellSize = UDim2.new(0, 75, 1, 0);
    
    Tabs.Name = "Tabs"
    Tabs.Parent = Base
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Tabs.BorderSizePixel = 2
    Tabs.Position = UDim2.new(0.05, 0, 0, 25);
    Tabs.Size = UDim2.new(0.9, 0, 0, 360);

    function Gui:Tab(Title)
        Title = Title or ""
        local Tab = {}
        TabIndex.CanvasSize += UDim2.new(0, 77, 0, 0);
    
        local TabButton = Instance.new("TextButton");
        local TabFrame = Instance.new("ScrollingFrame");
        
        TabButton.Name = Title
        TabButton.Parent = TabIndex
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.Code
        TabButton.Text = Title
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200);
        TabButton.TextSize = 14
        
        TabFrame.Name = Title
        TabFrame.Parent = Tabs
        TabFrame.Visible = false
        TabFrame.Active = true
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1, 0, 1, 0);
        TabFrame.CanvasSize = UDim2.new(0, 0, 1, 0);
        TabFrame.ScrollBarThickness = 5
    
        function Tab:Text(Text)
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Parent = TabFrame
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1, 0, 0, 0);
            TextLabel.Font = Enum.Font.Code
            TextLabel.Text = Text or "string"
            TextLabel.TextColor3 = Color3.fromRGB(180, 180, 180);
            TextLabel.TextSize = 14
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y
            TextLabel.TextWrapped = true
        end
    
        function Tab:Button(Text)
            local TextButton = Instance.new("TextButton");
    
            
        end
    
        local function ChangeTab()
            for _,v in ipairs(Tabs:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            for _,v in ipairs(TabIndex:GetChildren()) do
                if v:IsA("TextButton") then
                    v.TextColor3 = Color3.fromRGB(180, 180, 180);
                end
            end
            TabFrame.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(200, 200, 200);
        end
    
        ChangeTab();
    
        local function OnClick()
            ChangeTab();
        end
    
        TabButton.MouseButton1Click:Connect(OnClick);
    
        return Tab;
    end
    return Gui;
end

function Gui:SearchFrame(Title)
    local Frame = Instance.new("Frame");
    local TopBar = Instance.new("Frame");
    local CloseButton = Instance.new("TextButton");
    local TextLabel = Instance.new("TextLabel");
    local Holder = Instance.new("ScrollingFrame");
    local UIListLayout = Instance.new("UIListLayout");

    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, -150, 0.5, -200);
    Frame.Size = UDim2.new(0, 300, 0, 400);
    Frame.Visible = false
    
    TopBar.Parent = Frame
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 15);

    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -15, 0, 0);
    CloseButton.Size = UDim2.new(0, 15, 1, 0);
    CloseButton.Font = Enum.Font.Code
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200);
    CloseButton.TextSize = 14

    TextLabel.Parent = TopBar
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = Title or ""
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel.TextSize = 14
    
    Holder.Name = "Holder"
    Holder.Parent = Frame
    Holder.Active = true
    Holder.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    Holder.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Holder.BorderSizePixel = 2
    Holder.Position = UDim2.new(0.05, 0, 0, 25);
    Holder.Size = UDim2.new(0.9, 0, 0, 360);
    Holder.CanvasSize = UDim2.new(0, 0, 1, 0);
    Holder.ScrollBarThickness = 5
    
    UIListLayout.Parent = Holder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function OnClick()
        Frame.Visible = false
    end

    CloseButton.MouseButton1Click:Connect(OnClick);
    
    return Frame;
end

function Gui:Notify(Title, Message)
    local Notification = Instance.new("Frame");
    local TextLabel = Instance.new("TextLabel");
    local TextLabel_2 = Instance.new("TextLabel");

    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
    Notification.BorderColor3 =  Color3.fromRGB(0, 0, 0);
    Notification.BorderSizePixel = 2
    Notification.Position = UDim2.new(0.8, -110, 0, -20);
    Notification:TweenPosition(UDim2.new(0.8, -110, #Notifications / 8.5, -20), "InOut", "Quart", 0.5, true, nil);
    Notification.Size = UDim2.new(0, 220, 0, 80);
    Notification.Visible = true
    
    TextLabel.Parent = Notification
    TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 0, 15);
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = Title
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel.TextSize = 14
    
    TextLabel_2.Parent = Notification
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.Position = UDim2.new(0.05, 0, 0, 20);
    TextLabel_2.Size = UDim2.new(0.9, 0, 1, -20);
    TextLabel_2.Font = Enum.Font.Code
    TextLabel_2.Text = Message
    TextLabel_2.TextColor3 = Color3.fromRGB(180, 180, 180);
    TextLabel_2.TextSize = 14
    TextLabel_2.TextWrapped = true
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel_2.TextYAlignment = Enum.TextYAlignment.Top

    table.insert(Notifications, Notification);

    spawn(function()
        wait(6);
        Notification:Destroy();
        table.remove(Notifications, 1);
        UpdateNotifications();
    end);
end

local function Loop()
    MouseLocation = UIS:GetMouseLocation();
    
end

local function OnInput(Input, Process)
    local Key = Input.KeyCode
    local Type = Input.UserInputType
    if RecordButton then
        RecordButton.Text = (Key.Name ~= "Unknown" and Key.Name or Type ~= "Unknown" and Type.Name);
        RecordButton = nil
    end
    if Process then
        return;
    end
end

local function OnInputEnded(Input, Process)
    local Key = Input.KeyCode
    local Type = Input.UserInputType
    if Process then
        return;
    end
end

RunService.RenderStepped:Connect(Loop);
UIS.InputBegan:Connect(OnInput);
UIS.InputEnded:Connect(OnInputEnded);

return Gui;
