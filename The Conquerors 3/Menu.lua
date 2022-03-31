local Menu = {}

local protect_gui = function(Gui, Parent)
    if syn then
        syn.protect_gui(Gui)
        Gui.Parent = Parent
    elseif gethui then
        Gui.Parent = gethui()
    else
        Gui.Parent = Parent -- I really don't want this to be detected but yeah
    end
end


local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local TextService = game:GetService("TextService")


function CreateStroke(Parent, Color, Thickness, Transparency)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "Stroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
    UIStroke.Color = Color or Color3.new()
    UIStroke.Thickness = Thickness or 1
    UIStroke.Transparency = Transparency or 0
    UIStroke.Enabled = true
    UIStroke.Parent = Parent
    return UIStroke
end 


function Menu:Init()
    local Screen = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    protect_gui(Screen, CoreGui)
    Menu.Screen = Screen
    Menu.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end


function Menu:Window()

end


function Menu:Notify()
    local Notification = Instance.new("Frame")
    local Title = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local Content = Instance.new("TextLabel")

    Notification.Name = "Notification"
    Notification.Parent = game.StarterGui.ScreenGui
    Notification.BackgroundColor3 = Color3.fromRGB(17, 21, 20)
    Notification.BackgroundTransparency = 0.200
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(0, 10, 0, 8)
    Notification.Size = UDim2.new(0, 200, 0, 117)
    CreateStroke(Notification, Color3.fromRGB(65, 65, 80))

    Title.Name = "Title"
    Title.Parent = Notification
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 20)

    TextLabel.Parent = Title
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "Notification();"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top

    Content.Name = "Content"
    Content.Parent = Notification
    Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Content.BackgroundTransparency = 1.000
    Content.Position = UDim2.new(0, 0, 0.170940176, 0)
    Content.Size = UDim2.new(1, 0, 0, 97)
    Content.Font = Enum.Font.SourceSans
    Content.Text = "<insert text here>"
    Content.TextColor3 = Color3.fromRGB(255, 255, 255)
    Content.TextSize = 14.000
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
end


function Menu:SetVisible(Visible)
    Menu.Screen.Frame.Visible = Visible
end



return Menu