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
