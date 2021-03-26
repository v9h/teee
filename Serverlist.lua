local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local TeleportService = game:GetService("TeleportService");
local CoreGui = game:GetService("CoreGui");

local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/libs/ui-library.lua"))();
local Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

local Serverlist = Gui:SearchFrame();
Serverlist.Visible = true
local Serverlist = Serverlist.Holder

local function CreateInfo(PCount, Ping, FPS, SlowGame, JobId, Thumbnails)
    Serverlist.CanvasSize += UDim2.new(0, 0, 0, 40);
    local Frame = Instance.new("Frame");
    local PlayerCount = Instance.new("TextLabel");
    local JoinButton = Instance.new("TextButton");
    local PingFPS = Instance.new("TextLabel");
    local Slow = Instance.new("TextLabel");
    local PlayersThumbnails = Instance.new("Frame");
    local UIGridLayout = Instance.new("UIGridLayout");
    
    Frame.Parent = Serverlist
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 0, 0, 40);
    
    PlayerCount.Parent = Frame
    PlayerCount.BackgroundTransparency = 1
    PlayerCount.Size = UDim2.new(0, 125, 0, 20);
    PlayerCount.Font = Enum.Font.Code
    PlayerCount.Text = PCount
    PlayerCount.TextColor3 = Color3.fromRGB(200, 200, 200);
    PlayerCount.TextSize = 14
    
    JoinButton.Parent = Frame
    JoinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
    JoinButton.BorderSizePixel = 0
    JoinButton.Position = UDim2.new(0, 0, 0, 20);
    JoinButton.Size = UDim2.new(0, 125, 0, 20);
    JoinButton.Font = Enum.Font.Code
    JoinButton.Text = "Join"
    JoinButton.TextColor3 = Color3.fromRGB(200, 200, 200);
    JoinButton.TextSize = 14
    
    PingFPS.Parent = Frame
    PingFPS.BackgroundTransparency = 1
    PingFPS.Position = UDim2.new(1, -125, 0, 0);
    PingFPS.Size = UDim2.new(0, 125, 0, 20);
    PingFPS.Font = Enum.Font.Code
    PingFPS.Text = Ping .. "ms /" .. FPS .. "fps"
    PingFPS.TextColor3 = Color3.fromRGB(200, 200, 200);
    PingFPS.TextSize = 14
    
    Slow.Parent = Frame
    Slow.BackgroundTransparency = 1
    Slow.Position = UDim2.new(1, -125, 0, 20);
    Slow.Size = UDim2.new(0, 125, 0, 20);
    Slow.Visible = SlowGame
    Slow.Font = Enum.Font.Code
    Slow.Text = "Slow Game"
    Slow.TextColor3 = Color3.fromRGB(255, 170, 0);
    Slow.TextSize = 14
    
    PlayersThumbnails.Parent = Frame
    PlayersThumbnails.BackgroundTransparency = 1
    PlayersThumbnails.Position = UDim2.new(0, 0, 0, 40);
    PlayersThumbnails.Size = UDim2.new(1, 0, 1, 0);
    
    UIGridLayout.Parent = PlayersThumbnails
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 2, 0, 2);
    UIGridLayout.CellSize = UDim2.new(0, 20, 0, 20);
    --[[
    for _,Thumbnail in ipairs(Thumbnails) do
        Count += 1
        writefile(Folder .. Count .. ".png", game:HttpGet(Thumbnail));
        local Image = Instance.new("ImageLabel");
        Image.Parent = PlayersThumbnails
        Image.BackgroundTransparency = 1
        Image.Size = UDim2.new(0, 100, 0, 100);
        Image.Image = GetAsset(Folder .. Count .. ".png");
    end
    --]]
    local function OnClick()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, JobId, Players.LocalPlayer);
    end

    JoinButton.MouseButton1Click:Connect(OnClick);
end

local function ClearBase()
    for _,v in ipairs(Serverlist:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy();
        end
    end
    Serverlist.CanvasSize = UDim2.new(0, 0, 1, 0);
end

local function Update()
    ClearBase();
    local GetServers;
    if not syn then
        GetServers = request({
            Url = Url,
            Method = "GET"
        });
    else
        GetServers = syn.request({
            Url = Url,
            Method = "GET"
        });
    end
    local Servers = HttpService:JSONDecode(GetServers.Body);
    for _,Server in ipairs(Servers.data) do
        if not Server.playing or not Server.maxPlayers then
            continue;
        end
        local PlayersCapacity = Server.playing .. "/ " .. Server.maxPlayers
        local Ping = Server.ping
        local FPS = math.round(Server.fps);
        --local SlowGame = Server.slowGame
        local JobId = Server.id
        --local Thumbnails = Servers.thumbnails
        CreateInfo(PlayersCapacity, Ping, FPS, false, JobId);
    end
end

Update();

while wait(5) do
    Update();
end
