local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local Camera = Workspace.CurrentCamera

local Draw = Drawing

local ESP = {}

function ESP:Text(Text, Part)
    local BillboardGui = Instance.new("BillboardGui");
    local TextLabel = Instance.new("TextLabel");

    BillboardGui.Parent = Part
    BillboardGui.Adornee = Part
    BillboardGui.AlwaysOnTop = true
    BillboardGui.ExtentsOffset = Vector3.new(0, 2, 0);
    BillboardGui.Size = UDim2.new(1, 0, 1, 0);

    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 0, 0, 0);
    TextLabel.Size = UDim2.new(1, 0, 0, 15);
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel.TextSize = 18
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center

    return TextLabel;
end

return ESP;
