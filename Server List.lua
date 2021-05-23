local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LoopEvent, Wait
local Url = "https://games.roblox.com/v1/games/".. game.PlaceId .."/servers/Public?sortOrder=Asc&limit=100"

local Screen = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Underline = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local ServerHolder = Instance.new("ScrollingFrame")
local PlaceIdText = Instance.new("TextLabel")
local JobIdText = Instance.new("TextLabel")
local PlaceIdBox = Instance.new("TextBox")
local JobIdBox = Instance.new("TextBox")
local JoinButton = Instance.new("TextButton")

Screen.Parent = CoreGui
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Parent = Screen
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Active = true
Main.Draggable = true

TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 15)

Title.Parent = TopBar
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 0, 1, 0)
Title.Font = Enum.Font.Code
Title.Text = "Identification | Server List"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextStrokeTransparency = 0.5
Title.TextXAlignment = Enum.TextXAlignment.Left

Underline.Parent = TopBar
Underline.BackgroundColor3 = Color3.fromRGB(170, 85, 150)
Underline.BorderColor3 = Color3.fromRGB(170, 85, 150)
Underline.BorderSizePixel = 0
Underline.Position = UDim2.new(0, 0, 1, 0)
Underline.Size = UDim2.new(1, 0, 0, 2)

CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0, 287, 0, 2)
CloseButton.Size = UDim2.new(0, 11, 0, 11)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = ""
CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.TextSize = 14
CloseButton.MouseButton1Click:Connect(function()
    LoopEvent:Disconnect()
    Screen:Destroy()
end)

ServerHolder.Parent = Main
ServerHolder.Active = true
ServerHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ServerHolder.BorderSizePixel = 0
ServerHolder.Position = UDim2.new(0, 10, 0, 50)
ServerHolder.Size = UDim2.new(0, 280, 0, 340)
ServerHolder.CanvasSize = UDim2.new(0, 0, 1, 0)
ServerHolder.ScrollBarThickness = 4

function CreateInfo(Ping, FPS, Id, Playing, MaxPlayers, Tokens)
    if not Ping or not FPS or not Id or not Playing or not MaxPlayers then return end

    local CopyWait, TokenWait

    local InfoHolder = Instance.new("Frame")
    local ServerInfo = Instance.new("TextLabel")
    local CopyButton = Instance.new("TextButton")
    local TeleportButton = Instance.new("TextButton")
    local GetTokensButton = Instance.new("TextButton")

    InfoHolder.Parent = ServerHolder
    InfoHolder.BackgroundTransparency = 1
    InfoHolder.Position = UDim2.new(0, 10, 0, (#ServerHolder:GetChildren() - 1) * 40)
    InfoHolder.Size = UDim2.new(0, 260, 0, 40)

    ServerInfo.Parent = InfoHolder
    ServerInfo.BackgroundTransparency = 1
    ServerInfo.Size = UDim2.new(1, 0, 0, 20)
    ServerInfo.Font = Enum.Font.Code
    ServerInfo.Text = "Players:" .. Playing .. "/" .. MaxPlayers .. ", Ping:" .. Ping .. "ms, FPS:" .. string.format("%.2f", FPS) .. "fps"
    ServerInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    ServerInfo.TextSize = 14
    ServerInfo.TextStrokeTransparency = 0.5

    CopyButton.Parent = InfoHolder
    CopyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CopyButton.BorderSizePixel = 0
    CopyButton.Position = UDim2.new(0, 0, 0, 20)
    CopyButton.Size = UDim2.new(0, 75, 0, 20)
    CopyButton.Font = Enum.Font.Code
    CopyButton.Text = "Copy"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 14
    CopyButton.TextStrokeTransparency = 0.5
    CopyButton.MouseButton1Click:Connect(function()
        if CopyWait then return end
        CopyWait = true
        CopyButton.Text = "Copied!"
        CopyButton.TextColor3 = Color3.fromRGB(170, 85, 150)
        setclipboard(Id)
        wait(2)
        CopyButton.Text = "Copy"
        CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CopyWait = false
    end)

    TeleportButton.Parent = InfoHolder
    TeleportButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Position = UDim2.new(0, 90, 0, 20)
    TeleportButton.Size = UDim2.new(0, 75, 0, 20)
    TeleportButton.Font = Enum.Font.Code
    TeleportButton.Text = game.JobId ~= Id and "Teleport" or "Already In!"
    TeleportButton.TextColor3 = game.JobId ~= Id and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 85, 150)
    TeleportButton.TextSize = 14
    TeleportButton.TextStrokeTransparency = 0.5
    TeleportButton.MouseButton1Click:Connect(function()
        if Id == game.JobId then return end
        TeleportService:TeleportToPlaceInstance(PlaceIdBox.Text, Id, Players.LocalPlayer)
    end)

    GetTokensButton.Parent = InfoHolder
    GetTokensButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    GetTokensButton.BorderSizePixel = 0
    GetTokensButton.Position = UDim2.new(0, 180, 0, 20)
    GetTokensButton.Size = UDim2.new(0, 75, 0, 20)
    GetTokensButton.Font = Enum.Font.Code
    GetTokensButton.Text = "Get Tokens"
    GetTokensButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetTokensButton.TextSize = 14
    GetTokensButton.TextStrokeTransparency = 0.5
    GetTokensButton.MouseButton1Click:Connect(function()
        if Tokens then
            if TokenWait then return end
            TokenWait = true
            GetTokensButton.Text = "Copied Tokens!"
            GetTokensButton.TextColor3 = Color3.fromRGB(170, 85, 150)
            setclipboard(table.concat(Tokens, ", "))
            wait(2)
            GetTokensButton.Text = "Get Tokens"
            GetTokensButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TokenWait = false
        end
    end)
end

PlaceIdText.Parent = Main
PlaceIdText.BackgroundTransparency = 1
PlaceIdText.Position = UDim2.new(0, 115, 0, 25)
PlaceIdText.Size = UDim2.new(0, 75, 0, 20)
PlaceIdText.Font = Enum.Font.Code
PlaceIdText.Text = "Place Id:"
PlaceIdText.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceIdText.TextSize = 14
PlaceIdText.TextStrokeTransparency = 0.5

JobIdText.Parent = Main
JobIdText.BackgroundTransparency = 1
JobIdText.Position = UDim2.new(0, 0, 0, 25)
JobIdText.Size = UDim2.new(0, 75, 0, 20)
JobIdText.Font = Enum.Font.Code
JobIdText.Text = "Job Id:"
JobIdText.TextColor3 = Color3.fromRGB(255, 255, 255)
JobIdText.TextSize = 14
JobIdText.TextStrokeTransparency = 0.5

PlaceIdBox.Parent = Main
PlaceIdBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlaceIdBox.BorderSizePixel = 0
PlaceIdBox.Position = UDim2.new(0, 185, 0, 25)
PlaceIdBox.Size = UDim2.new(0, 50, 0, 20)
PlaceIdBox.Font = Enum.Font.Code
PlaceIdBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
PlaceIdBox.Text = game.PlaceId
PlaceIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceIdBox.TextSize = 14
PlaceIdBox.TextTruncate = Enum.TextTruncate.AtEnd
PlaceIdBox.FocusLost:Connect(function()
    Url = "https://games.roblox.com/v1/games/".. PlaceIdBox.Text .."/servers/Public?sortOrder=Asc&limit=100"
end)

JobIdBox.Parent = Main
JobIdBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
JobIdBox.BorderSizePixel = 0
JobIdBox.Position = UDim2.new(0, 65, 0, 25)
JobIdBox.Size = UDim2.new(0, 50, 0, 20)
JobIdBox.Font = Enum.Font.Code
JobIdBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
JobIdBox.Text = game.JobId
JobIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JobIdBox.TextSize = 14
JobIdBox.TextTruncate = Enum.TextTruncate.AtEnd

JoinButton.Parent = Main
JoinButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
JoinButton.BorderSizePixel = 0
JoinButton.Position = UDim2.new(0, 240, 0, 25)
JoinButton.Size = UDim2.new(0, 50, 0, 20)
JoinButton.Font = Enum.Font.Code
JoinButton.Text = "Join"
JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinButton.TextSize = 14
JoinButton.TextStrokeTransparency = 0.5
JoinButton.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(PlaceIdBox.Text, JobIdBox.Text, Players.LocalPlayer)
end)

function Loop()
    local _, Error = pcall(function()
        if Wait then return end
        Wait = true
        ServerHolder:ClearAllChildren()
        local Servers = HttpService:JSONDecode(game:HttpGetAsync(Url)).data
        for _, Server in ipairs(Servers) do
            CreateInfo(Server.ping, Server.fps, Server.id, Server.playing, Server.maxPlayers, Server.playerTokens)
        end
        wait(3)
        Wait = false
    end)
    if Error then
        Wait = false
    end
end

LoopEvent = RunService.Stepped:Connect(Loop)
