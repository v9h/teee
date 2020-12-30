-- Identification
--The Streets / The Prison

--[[
    Fix: Tool positions, control script, and more, saving
    Add: Keybinds, commands frame, finish UI stuff, improve aimbot, add blacklist system
]]

if _G["IdentificationLoaded"] then
    warn("Already running!")
    return
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

_G["IdentificationLoaded"] = true

local Commands = {}

local Admins = {
    [1892264393] = {
        ["Tag"] = "RegularID [Owner]",
        ["TagColor"] = Color3.fromRGB(0, 0, 0);
    };
}

local ItemTeleports = {
    ["Uzi"] = CFrame.new(-273.242432, 4.07593727, 362.96463),
    ["Glock"] = CFrame.new(-973.093323, 3.40013051, -91.4979477),
    ["Sawed Off"] = CFrame.new(-249.405563, 3.80021477, -244.670639),
    ["Pipe"] = CFrame.new(-428.873779, 5.05670071, 236.733047),
    ["Machete"] = CFrame.new(-725.642761, 4.09996891, -80.24543),
    ["Golf Club"] = CFrame.new(-75.8615189, 4.68336582, -219.669724),
    ["Bat"] = CFrame.new(118.44648, 4.39918327, -60.5660248),
    ["Bottle"] = CFrame.new(-966.954651, 4.40027571, -157.431702),
    ["Spray"] = CFrame.new(126.217323, 4.40024042, -97.900383),
    ["Burger"] = CFrame.new(-723.62439, 4.37012291, 124.919189),
    ["Chicken"] = CFrame.new(-743.055664, 4.51182795, -43.1793213),
    ["Drink1"] = CFrame.new(-732.214539, 4.45025015, 125.235214),
    ["Drink2"] = CFrame.new(-742.684509, 4.51182842, -51.5775948),
    ["Ammo1"] = CFrame.new(108.268921, 4.23982, -66.7777252),
    ["Ammo2"] = CFrame.new(-59.4254913, 4.70361137, -212.631012),
    ["Ammo3"] = CFrame.new(-128.843369, 5.40023613, 94.1143265),
    ["Ammo4"] = CFrame.new(-890.887695, 4.40014601, -139.184128);
}
-- Variables

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
local Time = tick()

local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Market = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SavedInstances = Instance.new("Folder", ReplicatedStorage)
SavedInstances.Name = "Saved Instances"
SavedInstances = ReplicatedStorage["Saved Instances"]

local Character = Player.Character -- if player controlled then we have old character
local Humanoid = Player.Character:WaitForChild("Humanoid")
local TagSystem = ReplicatedStorage:FindFirstChild("TagSystem")
if TagSystem then
    TagSystem = require(TagSystem)
end

local Settings = {
    ["ItemSortTable"] = {
        ["Sign"] = nil,
        ["Knife"] = nil,
        ["Punch"] = 1,
        ["Pipe"] = 2,
        ["Jutsu"] = 3,
        ["Glock"] = 4,
        ["Shotty"] = 5,
        ["Spray"] = 6,
        ["BoomBox"] = 7,
        ["LockPick"] = 8;
    },

    ["Binds"] = {},

    ["CrosshairIcon"] = "",
    ["HitCrosshairIcon"] = "rbxassetid://4868902029",
    ["HitmarkerSound"] = "",

    ["Hit1"] = "455534850",
    ["Hit2"] = "455535422",
    ["Hit3"] = "455535875",
    ["Run"] = "376653421", -- 458506542
    ["Crouch"] = "327855546",
    ["IdleShotty"] = "503285264",
    ["IdleGlock"] = "889390949",
    ["FireShotty"] = "889391270",
    ["FireGlock"] = "503287783",
    ["ReloadShotty"] = "327869970",
    ["ReloadGlock"] = "327870302",

    ["AFK"] = false;
}

local Config = {
    ["AimbotKey"] = "R",
    ["Aimlock"] = false,
    ["SilentAim"] = true,
    ["AutoFire"] = false,
    ["Triggerbot"] = false,
    ["AimbotTarget"] = "Torso",

    ["NoStop"] = true,
    ["AlwaysRunPunch"] = false,
    ["SuperPunch"] = false,
    ["AutoSwitch"] = false,
    ["StompSpam"] = true,
    ["AutoStomp"] = false,
    ["AutoStompDistance"] = 10,

    ["PlayerESPKey"] = "L",
    ["Chams"] = false,
    ["ChamsColor"] = "0, 85, 255",
    ["Stamina"] = false,
    ["StaminaColor"] = "255, 255, 255",
    ["KO"] = false,
    ["KOColor"] = "255, 255, 255",
    ["Box"] = false,
    ["BoxColor"] = "255, 255, 255",
    ["Glow"] = false,
    ["GlowColor"] = "255, 255, 255",
    ["Info"] = false,
    ["InfoColor"] = "255, 255, 255",
    ["ItemEsp"] = true,
    ["GoodItemsOnly"] = false,

    ["BulletTracers"] = false,
    ["BulletTracersColor"] = "255, 255, 255",
    ["Watermark"] = true,
    ["States"] = true,
    ["ShowAmmo"] = true,
    ["DraggableUIObjects"] = false,
    ["Hitmarker"] = true,
    ["FadingUIObjects"] = false,

    ["GodMode"] = false,
    ["NoKO"] = false,

    ["WalkSpeedMod"] = false,
    ["WalkSpeed"] = 16,
    ["JumpPowerMod"] = false,
    ["JumpPower"] = 37.5,
    ["RunSpeedMod"] = false,
    ["RunSpeed"] = 24,
    ["CrouchSpeedMod"] = false,
    ["CrouchSpeed"] = 8,
    ["IgnoreActionSpeed"] = false,

    ["AnimeRun"] = false,
    ["AutoCash"] = "LeftControl",
    ["AntiAFK"] = false,
    ["AutoLock"] = false,
    ["AutoUnlock"] = false,
    ["AutoSort"] = false,
    ["HideGroups"] = false,
    ["MuteRadios"] = false,
    ["HideSprays"] = true,
    ["HideTPer"] = false,
    ["AutoEat"] = false,

    ["Skins"] = {
        ["Glock"] = "Default",
        ["Sawed Off"] = "Default",
        ["Shotty"] = "Default",
        ["Uzi"] = "Default";
    },

    ["PrefixKey"] = "Quote",
    ["MenuKey"] = "Delete",
    ["MainColor"] = "0, 85, 255",
    ["TextColor"] = "225, 225, 225",
    ["RadioVolume"] = 1,

    ["Whitelisted"] = {},
    ["FlySpeed"] = 2,
    ["FPSCap"] = 60,
    ["MouseLockKey"] = "LeftShift",
    ["Blink"] = false,
    ["BlinkSpeed"] = 2;
}

local OriginalGrips = {
    ["Sawed Off"] = CFrame.new(0.5, 0, -0.15, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Shotty"] = CFrame.new(0.5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Glock"] = CFrame.new(0.4, -0.1, 0, 0.008, 0, 0.1, 0, 1, 0, -0.1, 0, 0.008),
    ["Uzi"] = CFrame.new(0.4, -.2, -.2, 1, 0, 0, 0, 1, 0, 0, 0, 1);
}

local Keys = {
    ["Mouse1"] = false,
    ["Mouse2"] = false,
    ["Space"] = false,
    ["Shift"] = false,
    ["Control"] = false,
    ["E"] = false,
    ["W"] = false,
    ["A"] = false,
    ["S"] = false,
    ["D"] = false;
}

local Blacklisted = HttpService:JSONDecode(game:HttpGet("https://pastebin.com/raw/u2BSXAN9"))
local AdminCommands = {
    ["kick"] = {
        ["Function"] = function(Target, Message)
            Target:Kick(Message)
        end
    },

    ["rejoin"] = {
        ["Function"] = function(Target)
            TeleportService:Teleport(game.PlaceId, Target)
        end
    },

    ["kill"] = {
        ["Function"] = function(Target)
            if Target.Character then
                Target.Character:BreakJoints()
            end
        end
    },

    ["chat"] = {
        ["Function"] = function(Target, Message)
            if Target.Character then
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "All")
            end
        end
    },

    ["notify"] = {
        ["Function"] = function(Title, Message, Duration, Icon)
            game:GetService("StarterGui"):SetCore("SendNotification",{
                ["Title"] = Title,
                ["Text"] = Message,
                ["Duration"] = Duration,
                ["Icon"] = Icon;
            })
        end
    },

    ["blacklist"] = {
        ["Function"] = function(Target)
            table.insert(BlacklistTable["Blacklisted"], Target)
            TeleportService:Teleport(game.PlaceId, Target)
        end
    },

    ["unblacklist"] = {
        ["Function"] = function(Target)
            table.remove(BlacklistTable["Blacklisted"], Target)
        end
    };
}

local HeightValue = -3.5
local HealthCount = 0
local KOCount = 0
local LastDiedPosition = CFrame.new(0, 3, 0)
local TheStreetsId = 455366377
local ThePrisonId = 4669040
local SongId

local Aimbot = true
local Triggerbot = false
local SuperPunch = false
local PlayerEsp = false
local Hidden = false
local RemoteGun = false
local AttachGun = false
local AutoFarm = false
local AutoFarmCooldown = false
local DoorSpam = false
local Airwalk = false
local Noclip = false
local Flying = false
local Invisible = false
local AntiClaim = false
local TPBypass = false
local AutoPlay = false

local SelectedGunAnimation = "1"

local AimbotPlayer
local AnnoyPlayer
local EarRapePlayer

local Running = false
local Crouching = false
local Cooldown = false
local NoWalkMode

local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local LControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local ESPPlayers = {}

local SetClipboard = setclipboard or Clipboard.Set
local WriteFile = writefile

if Blacklisted[Player.UserId] then
    Player:Kick("Blacklisted!")
end

local function AddCommand(Name, Function)
    Commands[#Commands + 1] = {CmdName = Name, CmdFunction = Function}
end

local function FindCommand(CommandName)
    for _,v in pairs(Commands) do
        for _,v2 in pairs(v.CmdName) do
            if v2:lower() == CommandName:lower() then
                return v
            end
        end
    end
end

local function FindPlayer(Target)
    if Target == "" or Target == nil or Target:lower() == "me" then
        return Player.Name
    elseif Target:lower() == "all" then
        return Players:GetPlayers()
    elseif Target ~= nil then
        local Matches = {}
        for _,v in pairs(Players:GetPlayers()) do
            if string.lower(v.Name):match(string.lower(Target)) then
                table.insert(Matches, v)
            end
        end
        if Matches then
            return Matches[1]
        else
            return nil
        end
    end
end

local function Notify(Title, Message, Duration, Icon)
    StarterGui:SetCore("SendNotification",{
        ["Title"] = Title,
        ["Text"] = Message,
        ["Duration"] = Duration,
        ["Icon"] = Icon;
    })
end

local function SaveFile()
    if not WriteFile then return end
    if not isfolder("Identification") then
        makefolder("Identification")
    end
    if isfile("Identification//Identification.json") then
        WriteFile("Identification//Identification.json", HttpService:JSONEncode(Config))
    else
        Notify("Notification", "File not found making new a file.", 5, nil)
        WriteFile("Identification//Identification.json", HttpService:JSONEncode(Config))
    end
end

local function LoadFile()
    if WriteFile and readfile and isfile and isfolder then
        if not isfolder("Identification") or not isfile("Identification//Identification.json") then
            SaveFile()
        else
            Config = HttpService:JSONDecode(readfile("Identification//Identification.json"))
        end
    end
end

LoadFile()

local function ChangeTab(Tab, Button)
    for _,v in pairs(Tabs:GetChildren()) do
        if v:IsA("Frame") then
            if Tab.Name ~= v.Name then
                v.Visible = false
            end
        end
	end
	for _,v in pairs(TabsSelect:GetChildren()) do
		if v:IsA("TextButton") and Button.Name ~= v.Name then
			v.TextColor3 = Color3.fromRGB(180, 180, 180)
		end
	end
    Tab.Visible = true
    SelectedTabUnderline.Parent = Button
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function GetExploitName()
    return (syn and not is_sirhurt_closure and "Synapse X") or (XPROTECT and is_sirhurt_closure and "SirHurt") or (secure_load and SENTINEL_LOADED and "Sentinel") or (pebc_execute and PROTOSMASHER_LOADED and "Protosmasher") or (krnl and "KRNL") or (calamari and "Calamari") or "Unknown"
end

local function ReturnCam()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = "Custom"
    CurrentCamera.CameraSubject = Humanoid
end

local function ItemEspCreate(ItemName, Item)
    local Billboard = Instance.new("BillboardGui")
    local ItemLabel = Instance.new("TextLabel")
    Billboard.Parent = Item
    Billboard.Adornee  = Item
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 1, 0)
    Billboard.Size = UDim2.new(0, 5, 0, 5)
    ItemLabel.Parent = Billboard
    ItemLabel.BackgroundTransparency = 1
    ItemLabel.Position = UDim2.new(0, 0, 0, -40)
    ItemLabel.Size = UDim2.new(1, 0, 10, 0)
    ItemLabel.Text = tostring(ItemName)
    ItemLabel.TextSize = 22
    ItemLabel.Font = Enum.Font.SourceSans
    ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ItemLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ItemLabel.TextStrokeTransparency = 0.45
end

local function PlayerEspCreate(Target)
    local TargetChar = Target.Character
    local Head = TargetChar:FindFirstChild("Head")
    local Torso = TargetChar:FindFirstChild("Torso") or Target.Character:FindFirstChild("HumanoidRootPart")
    local LeftArm = TargetChar:FindFirstChild("Left Arm")
    local RightArm = TargetChar:FindFirstChild("Right Arm")
    local LeftLeg = TargetChar:FindFirstChild("Left Leg")
    local RightLeg = TargetChar:FindFirstChild("Right Leg")
    local ESPFolder = Instance.new("Folder")
    if TargetChar:FindFirstChild("ESP_" .. Target.Name) then
        TargetChar:FindFirstChild("ESP_" .. Target.Name):Destroy()
    end
    ESPFolder.Name = "ESP_" .. Target.Name
    ESPFolder.Parent = TargetChar
    if Config["Chams"] then
        local Colors = Config["ChamsColor"]:split(",")
        local Box = Instance.new("BoxHandleAdornment")
        Box.Size = Vector3.new(2, 1, 1)
        Box.Transparency = .5
        Box.Adornee = Head
        Box.Color3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        Box.Parent = ESPFolder
        local Box = Box:Clone()
        Box.Size = Vector3.new(2, 2, 1)
        Box.Adornee = Torso
        local Box = Box:Clone()
        Box.Size = Vector3.new(1, 2, 1)
        Box.Adornee = RightArm
        local Box = Box:Clone()
        Box.Adornee = LeftArm
        local Box = Box:Clone()
        Box.Adornee = RightLeg
        local Box = Box:Clone()
        Box.Adornee = LeftLeg
    end
    if Config["Stamina"] then
        local Colors = Config["StaminaColors"]:split(",")
        local Stamina = Target.Backpack:FindFirstChild("ServerTraits").Stann.Value

    end
    if Config["KO"] then
        local Colors = Config["KOColors"]:split(",")
        local KO = Target.Character:FindFirstChild("KO")
        if KO then

        end
    end
    if Config["Box"] then
        local Colors = Config["BoxColors"]:split(",")
        if Torso then
            local BillboardGui = Instance.new("BillboardGui")
            BillboardGui.Parent = ESPFolder
            BillboardGui.Adornee = Torso
            BillboardGui.Size = UDim2.new(0, 100, 0, 150)
            BillboardGui.AlwaysOnTop = true
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Parent = BillboardGui
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Size = UDim2.new(1, 0, 1, 0)
            ImageLabel.Image = "rbxassetid://6153838089"
            ImageLabel.ImageColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        end
    end
    if Config["Glow"] then
        local Colors = Config["GlowColors"]:split(",")
        local SelectionBox = Instance.new("SelectionBox")
        SelectionBox.Parent = ESPFolder
        SelectionBox.Adornee = Head
        SelectionBox.Color3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        SelectionBox.LineThickness = .01
        SelectionBox.SurfaceTransparency = 1
        local SelectionBox = SelectionBox:Clone()
        SelectionBox.Adornee = Torso
        local SelectionBox = SelectionBox:Clone()
        SelectionBox.Adornee = RightArm
        local SelectionBox = SelectionBox:Clone()
        SelectionBox.Adornee = LeftArm
        local SelectionBox = SelectionBox:Clone()
        SelectionBox.Adornee = RightLeg
        local SelectionBox = SelectionBox:Clone()
        SelectionBox.Adornee = LeftLeg
    end
    if Config["Info"] then
        local Colors = Config["InfoColors"]:split(",")
        local Name = Target.Name
        local Health = TargetChar:FindFirstChild("Humanoid").Health
        local Vest = TargetChar:FindFirstChild("BulletResist")
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Size = UDim2.new()
        BillboardGui.Parent = ESPFolder
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = BillboardGui
    end
end

local function CreateAmmoLabel(ParentTo)
    AmmoLabel = Instance.new("TextLabel")
    AmmoLabel.Name = "AmmoLabel"
    AmmoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AmmoLabel.BackgroundTransparency = 1
    AmmoLabel.Size = UDim2.new(0, 150, 0, 40)
    AmmoLabel.Position = UDim2.new(0, 0, 0, 100)
    AmmoLabel.Font = Enum.Font.Code
    AmmoLabel.Text = "Ammo"
    AmmoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmmoLabel.TextSize = 24
    AmmoLabel.TextWrapped = true
    AmmoLabel.Visible = false
    AmmoLabel.Parent = ParentTo
end

local function SetParent(v)
	if v then
		RunService.Stepped:Wait()
		v.Parent = ReplicatedStorage.nosee
	end
end
for _, v in pairs(CollectionService:GetTagged("Stand")) do
	SetParent(v)
end
CollectionService:GetInstanceAddedSignal("Stand"):Connect(SetParent)

local function Animate(Anim, AnimSpeed)
	if AnimSpeed == nil then
		AnimSpeed = 1
	end
	Player.Character.Humanoid:LoadAnimation(Anim):Play(0.1, 1, AnimSpeed)
end

local function StartFly()
    repeat Wait() until Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid")
	local T = Player.Character.HumanoidRootPart
	local Speed = 0
	local function Fly()
		Flying = true
		local BG = Instance.new("BodyGyro")
		local BV = Instance.new("BodyVelocity")
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		coroutine.wrap(function()
			repeat Wait()
				if Player.Character:FindFirstChildOfClass("Humanoid") then
					Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
				end
				if Control.L + Control.R ~= 0 or Control.F + Control.B ~= 0 or Control.Q + Control.E ~= 0 then
					Speed = 50
				elseif not (Control.L + Control.R ~= 0 or Control.F + Control.B ~= 0 or Control.Q + Control.E ~= 0) and Speed ~= 0 then
					Speed = 0
				end
				if (Control.L + Control.R) ~= 0 or (Control.F + Control.B) ~= 0 or (Control.Q + Control.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (Control.F + Control.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(Control.L + Control.R, (Control.F + Control.B + Control.Q + Control.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * Speed
					LControl = {F = Control.F, B = Control.B, L = Control.L, R = Control.R}
				elseif (Control.L + Control.R) == 0 and (Control.F + Control.B) == 0 and (Control.Q + Control.E) == 0 and Speed ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (LControl.F + LControl.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(LControl.L + LControl.R, (LControl.F + LControl.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * Speed
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not Flying
			Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			LControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			Speed = 0
			BG:Destroy()
			BV:Destroy()
			if Player.Character:FindFirstChildOfClass("Humanoid") then
				Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            end
		end)()
    end
    Fly()
end

local function StopFly()
    Flying = false
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
		Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
	end
end

local function Teleport(Object, Destination)
    if TPBypass then
        Object.CFrame = Destination
    else
        local TweenTeleport = TweenService:Create(
            Object,
            TweenInfo.new(1.75, Enum.EasingStyle.Linear),
            {CFrame = Destination + Vector3.new(0, 1, 0)}
        )
        TweenTeleport:Play()
        local Command = FindCommand("noclip")
        Command.CmdFunction(Args, Player)
        TweenTeleport.Completed:Connect(function()
            local Command = FindCommand("clip")
            Command.CmdFunction(Args, Player)
            AutoFarmCooldown = false
        end)
    end
end

local function PlayAudio(Id, VersionId)
    if VersionId then
        Id = "&ASSetversionid=" .. Id
    end
    for _,v in pairs(Player.Backpack:GetChildren()) do
        if v.Name == "BoomBox" then
            v.Parent = Player.Character
            Player.Character.BoomBox.RemoteEvent:FireServer("stop")
            v.Parent = Player.Backpack
        end
    end
    Wait(1)
    for _,v in pairs(Player.Backpack:GetChildren()) do
        if v.Name == "BoomBox" then
            v.Parent = Player.Character
            Player.Character.BoomBox.RemoteEvent:FireServer("play", Id)
            v.Parent = Player.Backpack
        end
    end
end

local function StopAnimation(Id)
    for _,v in pairs(Player.Character.Humanoid:GetPlayingAnimationTracks()) do
        if v.Animation.AnimationId == Id then
            v:Stop()
        end
    end
end

local SelectedTool = Player.Character:FindFirstChildOfClass("Tool")

local MapHolder = Instance.new("Model")
MapHolder.Parent = ReplicatedStorage
MapHolder.Name = "MAP"
local SprayHolder = Instance.new("Model")
SprayHolder.Name = "Sprays"
local BuyerHolder = Instance.new("Model")
BuyerHolder.Name = "Buyers"
BuyerHolder.Parent = MapHolder
local RandomSpawnsHolder = Instance.new("Model")
RandomSpawnsHolder.Name = "RandomSpawns"
local DoorHolder = Instance.new("Model")
DoorHolder.Name = "Doors"
DoorHolder.Parent = MapHolder
local MapParts = Instance.new("Model")
MapParts.Name = "MapParts"
MapParts.Parent = MapHolder
local SpawnHolder = Instance.new("Model")
SpawnHolder.Name = "Spawns"
SpawnHolder.Parent = MapHolder
local BuildingHolder = Instance.new("Model")
BuildingHolder.Name = "Buildings"
BuildingHolder.Parent = MapHolder
local UnAnchoredHolder = Instance.new("Model")
UnAnchoredHolder.Name = "UnAnchoredParts"
local UsedParts = Instance.new("Model")
UsedParts.Name = "UsedParts"
local Live
if game.PlaceId == ThePrisonId then
    Live = Instance.new("Folder")
    Live.Name = "Live"
    Live.Parent = workspace
end

for _,v in pairs(workspace:GetChildren()) do
    if v:IsA("Part") or v:IsA("Model") or v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("TrussPart") or v:IsA("WedgePart") or v:IsA("CornerWedgePart") then
        local head = v:FindFirstChild("Head")
        local shopdata
        if head then
            shopdata = head:FindFirstChild("ShopData")
        end
        if string.match(v.Name, "Spray") and v:IsA("Part") then
            v.Parent = SprayHolder
        elseif v.Name == "RandomSpawner" then
            v.Parent = RandomSpawnsHolder
        elseif shopdata then
            v.Parent = BuyerHolder
        elseif v:IsA("SpawnLocation") then
            v.Parent = SpawnHolder
        elseif v.Name == "Boards" then
            for _,v2 in pairs(v:GetChildren()) do
                v2.Name = "Plank"
                v2.Parent = UnAnchoredHolder
            end
            v:Destroy()
        elseif v.Name == "Soda" then
            v.Parent = UnAnchoredHolder
        elseif v:FindFirstChild("TPer") then
            v.Parent = workspace
        elseif v.Name == "Building" or v.Name == "House1" or v.Name == "House2" then
            v.Parent = BuildingHolder
        else
            v.Parent = MapParts
        end
    end
end

if game.PlaceId == ThePrisonId then
    for _,v in pairs(Players:GetPlayers()) do
        if v.Character then
            v.Character.Parent = Live
        end
        v.CharacterAdded:Connect(function(v2)
            v2.Parent = Live
        end)
    end
end

for _,v in pairs(MapHolder:GetDescendants()) do
    if v.Name == "Camera" and v:IsA("Model") then
        v.Parent = workspace
    elseif v.Name == "Door" then
        v.Parent = DoorHolder
    end
end

for _,v in pairs(MapParts:GetDescendants()) do
    if v:IsA("Part") and v.Anchored == false and v.BrickColor == "Dark stone grey" then
        v.Name = "Trash Can"
        v.Parent = UnAnchoredHolder
    end
end

MapHolder.Parent = workspace
SprayHolder.Parent = workspace
RandomSpawnsHolder.Parent = workspace
UnAnchoredHolder.Parent = workspace
UsedParts.Parent = workspace

local function ItemEsp()
    if Config["ItemEsp"] then
        local Bat = "rbxassetid://175024455"
        local Bottle = "rbxassetid://156444949"
        local Brick = "rbxassetid://376949878"
        local Cash = "rbxassetid://511726060"
        local Crowbar = "rbxassetid://546410481"
        local GolfClub = "rbxassetid://344936269"
        local Katana = "rbxassetid://344936319"
        local Matchete = "rbxassetid://154965929"
        local SawedOff = "rbxassetid://219397110"
        local Shotty = "142383762"
        local StopSign = "rbxassetid://861978247"
        local Uzi = "328964620"
        if Config["GoodItemsOnly"] then
            for _,v2 in pairs(RandomSpawnsHolder:GetDescendants()) do
                local v = v2:FindFirstAncestorOfClass("Part")
                if v then
                    if v.Name == "RandomSpawner" then
                        v = v
                    end
                end
                if v2:IsA("Sound") then
                    if v2.SoundId == Brick then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Brick", v);
                        end
                    end
                    if v2.SoundId == SawedOff then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Sawed Off", v);
                        end
                    end
                    if string.find(tostring(v2.SoundId), Shotty) then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Shotty", v);
                        end
                    end
                    if string.find(tostring(v2.SoundId), Uzi) then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Uzi", v);
                        end
                    end
                end
                if v2:IsA("MeshPart") then
                    if v2.MeshId == Cash then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Cash", v);
                        end
                    end
                end
            end
        else
            for _,v3 in pairs(RandomSpawnsHolder:GetDescendants()) do
                local v = v3:FindFirstAncestorOfClass("Part")
                    if v then
                        if v.Name == "RandomSpawner" then
                            v = v
                        end
                    end
                if v3:IsA("Sound") then
                    if v3.SoundId == Bat then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Bat", v);
                        end
                    end
                    if v3.SoundId == Bottle then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Bottle", v);
                        end
                    end
                    if v3.SoundId == Brick then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Brick", v);
                        end
                    end
                    if v3.SoundId == Crowbar then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Crowbar", v);
                        end
                    end
                    if v3.SoundId == GolfClub then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Golf Club", v);
                        end
                    end
                    if v3.SoundId == Katana then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Katana", v);
                        end
                    end
                    if v3.SoundId == Matchete then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Matchete", v);
                        end
                    end
                    if v3.SoundId == SawedOff then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Sawed Off", v);
                        end
                    end
                    if string.find(tostring(v3.SoundId), Shotty) then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Shotty", v);
                        end
                    end
                    if v3.SoundId == StopSign then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Stop Sign", v);
                        end
                    end
                    if string.find(tostring(v3.SoundId), Uzi) then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Uzi", v);
                        end
                    end
                end
                if v3:IsA("MeshPart") then
                    if v3.MeshId == Cash then
                        if not v:FindFirstChildOfClass("BillboardGui") then
                            ItemEspCreate("Cash", v);
                        end
                    end
                end
            end
        end
    end
end

local RandomNumber = 1
local RandomNumber_2 = 0

local function Attack()
    if SelectedTool.Name == "Camera" then
        return
    end
    if not AimbotPlayer or not Players:FindFirstChild(AimbotPlayer.Name) or not AimbotPlayer.Character or not AimbotPlayer.Character:FindFirstChild("Humanoid") then
        AimbotPlayer = nil
    end
    local Ammo = SelectedTool:FindFirstChild("Ammo")
    local FireEvent = SelectedTool:FindFirstChild("Fire")
    local MH = Mouse.Hit
    if Aimbot and Config["SilentAim"] and AimbotPlayer ~= nil and AimbotPlayer.Character and AimbotPlayer.Character:FindFirstChild("Head") and AimbotPlayer.Character:FindFirstChild("Torso") then
        local HitPart = AimbotPlayer.Character:FindFirstChild(Config["AimbotTarget"])
        local EnemyVelocity = HitPart.Velocity
        local PingToHit
        if Ping < 50 then
            PingToHit = 3
        elseif Ping < 85 then
            PingToHit = 3.5
        elseif Ping < 120 then
            PingToHit = 4
        elseif Ping < 155 then
            PingToHit = 4.5
        elseif Ping < 190 then
            PingToHit = 5
        elseif Ping < 235 then
            PingToHit = 5.5
        elseif Ping < 260 then
            PingToHit = 6
        elseif Ping < 295 then
            PingToHit = 6.5
        elseif Ping < 330 then
            PingToHit = 7
        elseif Ping < 365 then
            PingToHit = 7.5
        elseif Ping < 400 then
            PingToHit = 8
        elseif Ping < 435 then
            PingToHit = 8.5
        else
            PingToHit = 9
        end
        MH = HitPart.CFrame + EnemyVelocity / PingToHit
    end
    if game.PlaceId == TheStreetsId then
        if Config["AlwaysRunHit"] then
            Player.Backpack.Input:FireServer("ml", {
                mousehit = MH,
                shift = true,
                velo = 200,
            })
        else
            Player.Backpack.Input:FireServer("ml", {
                mousehit = MH,
                shift = Keys["Shift"],
                velo = Player.Character.HumanoidRootPart.Position.magnitude,
            })
        end
        if SelectedTool.Name == "Uzi" then
            Player.Backpack.Input:FireServer("moff1", {
                mousehit = MH,
                shift = Keys["Shift"],
                velo = Player.Character.HumanoidRootPart.Position.magnitude,
            })
        end
        if SelectedTool:FindFirstChild("Ammo") and not Config["NoStop"] then
            Keys["Shift"] = false
        end
    else
        if not Cooldown then
            if Player.Character:FindFirstChild("KO") then
                Cooldown = false
                return
            end
            if Player.Character:FindFirstChild("Action") then
                Cooldown = false
                return
            end
            if Player.Character:FindFirstChild("Dragging") then
                Cooldown = false
                return
            end
            Cooldown = true
            if FireEvent then
                if SelectedTool.Reloader.Value == true then
                    SelectedTool.Click:FireServer()
                    return
                end
                FireEvent:FireServer(MH)
                if SelectedTool:FindFirstChild("Fires") then
                    local Anim = Player.Character.Humanoid:LoadAnimation(SelectedTool.Fires)
                    Anim:Play(0.1, 1, 2)
                end
                if not Config["NoStop"] then
                    Keys["Shift"] = false
                end
            end
            if not Ammo and Player.Backpack.ServerTraits.Stann.Value > 0 and SelectedTool:FindFirstChild("Info") then
                if not SelectedTool:FindFirstChild("Punch" .. RandomNumber .. "") then
                    RandomNumber = 1
                end
                if Player.Character.HumanoidRootPart.Velocity.magnitude > 10 and Running then
                    Animate(SelectedTool.Running, 1)
                else
                    local AnimSpeed = 1
                    if SelectedTool.Info:FindFirstChild("AnimSpeed") then
                        AnimSpeed = SelectedTool.Info:FindFirstChild("AnimSpeed").Value
                    end
                    Animate(SelectedTool["Punch" .. RandomNumber .. ""], AnimSpeed)
                end
                if SelectedTool.Name == "Punch" then
                    local ToolHnadle
                    if SelectedTool["Punch" .. RandomNumber]:FindFirstChild("Namer") then
                        ToolHandle = Player.Character[SelectedTool["Punch" .. RandomNumber].Namer.Value]
                    else
                        Cooldown = false
                    end
                else
                    ToolHandle = SelectedTool.Handle
                end
                RandomNumber = RandomNumber + 1
                RandomNumber_2 = RandomNumber_2 + 1
                coroutine.wrap(function()
                    Wait(0.8)
                    if RandomNumber_2 == RandomNumber_2 then
                        RandomNumber = 1
                        RandomNumber_2 = 0
                    end
                end)()
                if Config["AlwaysRunHit"] then
                    Player.Backpack.ServerTraits.Touch1:FireServer(SelectedTool, ToolHandle, Config["AlwaysRunHit"], true)
                else
                    Player.Backpack.ServerTraits.Touch1:FireServer(SelectedTool, ToolHandle, Keys["Shift"], true)
                end
            end
            if SelectedTool:FindFirstChild("Info") then
                Wait(SelectedTool.Info.Cooldown.Value)
                Cooldown = false
            else
                Cooldown = false
            end
        end
    end
end

local function Stomp()
    if game.PlaceId == TheStreetsId then
        Player.Backpack.Input:FireServer("e", {})
    else
        local Tool = Player.Backpack:FindFirstChildOfClass("Tool") or SelectedTool
        if Tool:FindFirstChild("Ammo") then
            Tool = Player.Backpack:FindFirstChild("Punch")
        end
        Player.Backpack.ServerTraits.Finish:FireServer(Tool)
    end
end

local function LoadCheckBox(Box, State, ...)
    if Config[State] then
        local Colors = Config["MainColor"]:split(",")
        Box.BackgroundColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        if ... then
            local ColorButton = ...
            ColorButton.Visible = true
        end
    else
        Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

local function LoadColorButton(Button, Colors)
    local Colors = Config[Colors]:split(",")
    Button.BackgroundColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
end

local function LoadSlider(Object, SliderButton, Data)
    Object.Text = Config[Data]
    local Percentage = Config[Data] / 100
    local ButtonPosition = SliderButton.Position
    SliderButton.Position = UDim2.new(Percentage, 0, ButtonPosition.Y.Scale, ButtonPosition.Y.Offset)
end

local MainColorsBorder = {}
local MainColorsBackground = {}
local MainColorsText = {}

local function LoadMainColor(Object, Task)
    local Colors = Config["MainColor"]:split(",")
    if Task == "Border" then
        Object.BorderColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        table.insert(MainColorsBorder, Object)
    elseif Task == "Background" then
        Object.BackgroundColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        table.insert(MainColorsBackground, Object)
    elseif Task == "Text" then
        Object.TextColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        table.insert(MainColorsText, Object)
    end
end

local function RefreshMainColor()
    local Colors = Config["MainColor"]:split(",")
    for _,v in pairs(MainColorsBorder) do
        v.BorderColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
    end
    for _,v in pairs(MainColorsBackground) do
        v.BackgroundColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
    end
    for _,v in pairs(MainColorsText) do
        v.TextColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
    end
end

local GUI = {
	Identification = Instance.new("ScreenGui"),
	MainFrame = Instance.new("Frame"),
	TopBar = Instance.new("Frame"),
	Title = Instance.new("TextLabel"),
	TabSelect = Instance.new("Frame"),
	UIGridLayout = Instance.new("UIGridLayout"),
	CombatSelect = Instance.new("TextButton"),
	VisualsSelect = Instance.new("TextButton"),
	CharacterSelect = Instance.new("TextButton"),
	MiscSelect = Instance.new("TextButton"),
	SettingsSelect = Instance.new("TextButton"),
	TabHolder = Instance.new("Frame"),
	CombatTab = Instance.new("Frame"),
	CombatAimbotSection = Instance.new("Frame"),
	TextLabel = Instance.new("TextLabel"),
	AimlockCheckBox = Instance.new("TextButton"),
	TextLabel_2 = Instance.new("TextLabel"),
	TextLabel_3 = Instance.new("TextLabel"),
	SilentAimCheckBox = Instance.new("TextButton"),
    AutoFireCheckBox = Instance.new("TextButton"),
    TriggerbotCheckBox = Instance.new("TextButton"),
	TextLabel_4 = Instance.new("TextLabel"),
	TextLabel_5 = Instance.new("TextLabel"),
	AimbotHitBoxButton = Instance.new("TextButton"),
	TextLabel_6 = Instance.new("TextLabel"),
	AimbotKeyButton = Instance.new("TextButton"),
	HitboxesSelectionFrame = Instance.new("Frame"),
	TorsoHitboxSelect = Instance.new("TextButton"),
	HeadHitboxSelect = Instance.new("TextButton"),
	CombatOthersSection = Instance.new("Frame"),
	TextLabel_7 = Instance.new("TextLabel"),
	NoStopCheckBox = Instance.new("TextButton"),
	RunPunchCheckBox = Instance.new("TextButton"),
	SuperPunchCheckBox = Instance.new("TextButton"),
	TextLabel_8 = Instance.new("TextLabel"),
	TextLabel_9 = Instance.new("TextLabel"),
	TextLabel_10 = Instance.new("TextLabel"),
	AutoSwitchCheckBox = Instance.new("TextButton"),
	TextLabel_11 = Instance.new("TextLabel"),
	StompSpamCheckBox = Instance.new("TextButton"),
	TextLabel_12 = Instance.new("TextLabel"),
	AutoStompCheckBox = Instance.new("TextButton"),
	TextLabel_13 = Instance.new("TextLabel"),
	TextLabel_14 = Instance.new("TextLabel"),
	AutoStompDistanceSlider = Instance.new("TextButton"),
	AutoStompDistanceSliderButton = Instance.new("TextButton"),
	AutoStompDistanceAmount = Instance.new("TextLabel"),
	VisualsTab = Instance.new("Frame"),
	VisualsESPSection = Instance.new("Frame"),
	TextLabel_15 = Instance.new("TextLabel"),
	TextLabel_16 = Instance.new("TextLabel"),
	TextLabel_17 = Instance.new("TextLabel"),
	PlayerChamsCheckBox = Instance.new("TextButton"),
	PlayerESPKeyButton = Instance.new("TextButton"),
	PlayerStaminaCheckBox = Instance.new("TextButton"),
	PlayerKOCheckBox = Instance.new("TextButton"),
	TextLabel_18 = Instance.new("TextLabel"),
	TextLabel_19 = Instance.new("TextLabel"),
	PlayerBoxCheckBox = Instance.new("TextButton"),
	TextLabel_20 = Instance.new("TextLabel"),
	TextLabel_21 = Instance.new("TextLabel"),
	PlayerGlowCheckBox = Instance.new("TextButton"),
	PlayerInfoCheckBox = Instance.new("TextButton"),
	TextLabel_22 = Instance.new("TextLabel"),
	TextLabel_23 = Instance.new("TextLabel"),
	PlayerGlowColorButton = Instance.new("TextButton"),
	PlayerInfoColorButton = Instance.new("TextButton"),
	PlayerBoxColorButton = Instance.new("TextButton"),
	PlayerKOColorButton = Instance.new("TextButton"),
	PlayerStaminaColorButton = Instance.new("TextButton"),
	PlayerChamsColorButton = Instance.new("TextButton"),
	ItemESPEnabledCheckBox = Instance.new("TextButton"),
	TextLabel_24 = Instance.new("TextLabel"),
	ItemESPGoodItemsCheckBox = Instance.new("TextButton"),
	TextLabel_25 = Instance.new("TextLabel"),
	VisualsOthersSection = Instance.new("Frame"),
	TextLabel_26 = Instance.new("TextLabel"),
	TextLabel_27 = Instance.new("TextLabel"),
	BulletTracersCheckBox = Instance.new("TextButton"),
	BulletTracersColorButton = Instance.new("TextButton"),
	TextLabel_28 = Instance.new("TextLabel"),
	TextLabel_29 = Instance.new("TextLabel"),
	StatesCheckBox = Instance.new("TextButton"),
	HitmarkerSoundButton = Instance.new("TextButton"),
	TextLabel_30 = Instance.new("TextLabel"),
	HitmarkerSoundsSelectionFrame = Instance.new("Frame"),
	DefaultSoundSelect = Instance.new("TextButton"),
	NoneSoundSelect = Instance.new("TextButton"),
	WatermarkCheckBox = Instance.new("TextButton"),
    HitmarkerCheckBox = Instance.new("TextButton"),
    FadingUIObjects = Instance.new("TextButton"),
	TextLabel_31 = Instance.new("TextLabel"),
	TextLabel_32 = Instance.new("TextLabel"),
	ShowAmmoCheckBox = Instance.new("TextButton"),
	TextLabel_33 = Instance.new("TextLabel"),
	DraggableUIObjectsCheckBox = Instance.new("TextButton"),
	CharacterTab = Instance.new("Frame"),
	CharacterMainSection = Instance.new("Frame"),
	TextLabel_34 = Instance.new("TextLabel"),
	TextLabel_35 = Instance.new("TextLabel"),
	GodModeCheckBox = Instance.new("TextButton"),
	TextLabel_36 = Instance.new("TextLabel"),
	NoKOCheckBox = Instance.new("TextButton"),
	CharacterMovementSection = Instance.new("Frame"),
	TextLabel_37 = Instance.new("TextLabel"),
	WalkSpeedModCheckBox = Instance.new("TextButton"),
	TextLabel_38 = Instance.new("TextLabel"),
	WalkSpeedModSlider = Instance.new("TextButton"),
	WalkSpeedModSliderButton = Instance.new("TextButton"),
	WalkSpeedModAmount = Instance.new("TextLabel"),
	JumpPowerModCheckBox = Instance.new("TextButton"),
	TextLabel_39 = Instance.new("TextLabel"),
	RunSpeedModSlider = Instance.new("TextButton"),
	RunSpeedModSliderButton = Instance.new("TextButton"),
	RunSpeedModAmount = Instance.new("TextLabel"),
	TextLabel_40 = Instance.new("TextLabel"),
	RunSpeedModCheckBox = Instance.new("TextButton"),
	CrouchSpeedModSlider = Instance.new("TextButton"),
	CrouchSpeedModSliderButton = Instance.new("TextButton"),
	CrouchSpeedModAmount = Instance.new("TextLabel"),
	JumpPowerModSlider = Instance.new("TextButton"),
	JumpPowerModSliderButton = Instance.new("TextButton"),
	JumpPowerModAmount = Instance.new("TextLabel"),
	TextLabel_41 = Instance.new("TextLabel"),
	CrouchSpeedModCheckBox = Instance.new("TextButton"),
	TextLabel_42 = Instance.new("TextLabel"),
	IgnoreActionSpeedCheckBox = Instance.new("TextButton"),
	MiscellaneousTab = Instance.new("Frame"),
	MiscellaneousMainSection = Instance.new("Frame"),
	TextLabel_43 = Instance.new("TextLabel"),
	TextLabel_44 = Instance.new("TextLabel"),
	AnimeRunCheckBox = Instance.new("TextButton"),
	TextLabel_45 = Instance.new("TextLabel"),
	AutoCashCheckBox = Instance.new("TextButton"),
	TextLabel_46 = Instance.new("TextLabel"),
	AntiAFKCheckBox = Instance.new("TextButton"),
	TextLabel_47 = Instance.new("TextLabel"),
	AutoLockCheckBox = Instance.new("TextButton"),
	AutoUnlockCheckBox = Instance.new("TextButton"),
	TextLabel_48 = Instance.new("TextLabel"),
	AutoSortCheckBox = Instance.new("TextButton"),
	TextLabel_49 = Instance.new("TextLabel"),
	TextLabel_50 = Instance.new("TextLabel"),
	HideGroupsCheckBox = Instance.new("TextButton"),
	TextLabel_51 = Instance.new("TextLabel"),
	MuteRadiosCheckBox = Instance.new("TextButton"),
	TextLabel_52 = Instance.new("TextLabel"),
	HideSpraysCheckBox = Instance.new("TextButton"),
	TextLabel_53 = Instance.new("TextLabel"),
    HideTPerCheckBox = Instance.new("TextButton"),
    AutoEatCheckBox = Instance.new("TextButton"),
	MiscellaneousSkinChangerSection = Instance.new("Frame"),
	TextLabel_54 = Instance.new("TextLabel"),
	WeaponSelectionFrame = Instance.new("Frame"),
	GlockWeaponSelect = Instance.new("TextButton"),
	SawedOffWeaponSelect = Instance.new("TextButton"),
	ShottyWeaponSelect = Instance.new("TextButton"),
	UziWeaponSelect = Instance.new("TextButton"),
	WeaponSelectButton = Instance.new("TextButton"),
	TextLabel_55 = Instance.new("TextLabel"),
	SkinSelectionFrame = Instance.new("Frame"),
	DefaultSkinSelect = Instance.new("TextButton"),
	KawaiiSkinSelect = Instance.new("TextButton"),
	SatanicSkinSelect = Instance.new("TextButton"),
	GoldSkinSelect = Instance.new("TextButton"),
	NebulaSkinSelect = Instance.new("TextButton"),
	NoobSkinSelect = Instance.new("TextButton"),
	ToxicSkinSelect = Instance.new("TextButton"),
	SkinSelectButton = Instance.new("TextButton"),
	TextLabel_56 = Instance.new("TextLabel"),
	SkinPreviewFrame = Instance.new("ViewportFrame"),
	SkinSelectButton_2 = Instance.new("TextButton"),
	SettingsTab = Instance.new("Frame"),
	SettingsMainSection = Instance.new("Frame"),
	TextLabel_57 = Instance.new("TextLabel"),
	PrefixKeyButton = Instance.new("TextButton"),
	TextLabel_58 = Instance.new("TextLabel"),
	TextLabel_59 = Instance.new("TextLabel"),
	MenuKeyButton = Instance.new("TextButton"),
	TextColorButton = Instance.new("TextButton"),
    TextLabel_60 = Instance.new("TextLabel"),
    TextLabel_62 = Instance.new("TextLabel"),
    MainColorButton = Instance.new("TextButton"),
	RadioVolumeSlider = Instance.new("TextButton"),
	RadioVolumeSliderButton = Instance.new("TextButton"),
	RadioVolumeAmount = Instance.new("TextLabel"),
	TextLabel_61 = Instance.new("TextLabel"),
	UICorner_2 = Instance.new("UICorner"),
	OthersFrame = Instance.new("Frame"),
	WatermarkFrame = Instance.new("Frame"),
	WatermarkDataLabel = Instance.new("TextLabel"),
	StatesFrame = Instance.new("Frame"),
	StatesTopBar = Instance.new("Frame"),
	StatesTitle = Instance.new("TextLabel"),
	StatesHolderFrame = Instance.new("Frame"),
    CurrentTargetLabel = Instance.new("TextLabel"),
    AimbottingLabel = Instance.new("TextLabel"),
    NoclippingLabel = Instance.new("TextLabel"),
	HairFrame = Instance.new("Frame"),
	HairFrameTopBar = Instance.new("Frame"),
	HairFrameTitle = Instance.new("TextLabel"),
	HairFrameCloseButton = Instance.new("TextButton"),
	HairHolderFrame = Instance.new("Frame"),
	HairHatsHolder = Instance.new("Frame"),
	TemplateHairSelect = Instance.new("TextButton"),
	UIListLayout = Instance.new("UIListLayout"),
	HairColorsHolder = Instance.new("Frame"),
	UIGridLayout_2 = Instance.new("UIGridLayout"),
	HairScriptsHolder = Instance.new("Frame"),
	UIListLayout_2 = Instance.new("UIListLayout"),
	SequenceModeButton = Instance.new("TextButton"),
	RandomColorsModeButton = Instance.new("TextButton"),
	BuildMenuFrame = Instance.new("Frame"),
	BuildMenuFrameTopBar = Instance.new("Frame"),
	BuildMenuFrameTitle = Instance.new("TextLabel"),
	BuildMenuFrameCloseButton = Instance.new("TextButton"),
	BuildMenuHolderFrame = Instance.new("Frame"),
	BuildMenuUnanchoredHolder = Instance.new("ScrollingFrame"),
	TemplateUnanchoredButton = Instance.new("TextButton"),
	UIListLayout_3 = Instance.new("UIListLayout"),
	BuildMenuPreBuiltSection = Instance.new("Frame"),
	BuildMenuSwastikaButton = Instance.new("TextButton"),
	UIListLayout_4 = Instance.new("UIListLayout"),
	BuildMenuInvertedCrossButton = Instance.new("TextButton"),
	BuildMenuHutButton = Instance.new("TextButton"),
	BuildMenuSkateboardButton = Instance.new("TextButton"),
	BuildMenuArmorButton = Instance.new("TextButton"),
	BuildMenuPropertiesSection = Instance.new("Frame"),
	TextLabel_63 = Instance.new("TextLabel"),
	TextLabel_64 = Instance.new("TextLabel"),
	TextLabel_65 = Instance.new("TextLabel"),
	BuildMenuXPositionBox = Instance.new("TextBox"),
	BuildMenuYPositionBox = Instance.new("TextBox"),
	BuildMenuZPositionBox = Instance.new("TextBox"),
	TextLabel_66 = Instance.new("TextLabel"),
	TextLabel_67 = Instance.new("TextLabel"),
	BuildMenuXRotationBox = Instance.new("TextBox"),
	BuildMenuYRotationBox = Instance.new("TextBox"),
	BuildMenuZRotationBox = Instance.new("TextBox"),
	BuildMenuBringPartButton = Instance.new("TextButton"),
	BuildMenuPlacePartButton = Instance.new("TextButton"),
	BuildMenuMoveXButton = Instance.new("TextButton"),
	BuildMenuMoveYButton = Instance.new("TextButton"),
	BuildMenuMoveZButton = Instance.new("TextButton"),
	BuildMenuIncrementBox = Instance.new("TextBox"),
	CommandBarFrame = Instance.new("Frame"),
	CommandBarBox = Instance.new("TextBox");
}

GUI.Identification.Name = "Identification"
GUI.Identification.Parent = game:GetService("CoreGui")
GUI.Identification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

GUI.MainFrame.Name = "MainFrame"
GUI.MainFrame.Parent = GUI.Identification
GUI.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
GUI.MainFrame.BackgroundTransparency = 0.25
LoadMainColor(GUI.MainFrame, "Border")
GUI.MainFrame.BorderSizePixel = 2
GUI.MainFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
GUI.MainFrame.Size = UDim2.new(0, 606, 0, 342)
GUI.MainFrame.Visible = true
GUI.MainFrame.Active = true
GUI.MainFrame.Draggable = true

GUI.TopBar.Name = "TopBar"
GUI.TopBar.Parent = GUI.MainFrame
GUI.TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GUI.TopBar.BorderSizePixel = 0
GUI.TopBar.Size = UDim2.new(1, 0, 0.05, 0)

GUI.Title.Name = "Title"
GUI.Title.Parent = GUI.TopBar
GUI.Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.Title.BackgroundTransparency = 1
GUI.Title.BorderSizePixel = 0
GUI.Title.Position = UDim2.new(0.005, 0, 0, 0)
GUI.Title.Size = UDim2.new(0.4, 0, 1, 0)
GUI.Title.Font = Enum.Font.SourceSansSemibold
GUI.Title.Text = "Identification [" .. GetExploitName() .. "]"
GUI.Title.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.Title.TextScaled = true
GUI.Title.TextSize = 14
GUI.Title.TextWrapped = true
GUI.Title.TextXAlignment = Enum.TextXAlignment.Left

GUI.TabSelect.Name = "TabSelect"
GUI.TabSelect.Parent = GUI.MainFrame
GUI.TabSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TabSelect.BackgroundTransparency = 1
GUI.TabSelect.BorderSizePixel = 5
GUI.TabSelect.Position = UDim2.new(0, 0, 0.05, 0)
GUI.TabSelect.Size = UDim2.new(1, 0, 0.05, 0)

GUI.UIGridLayout.Parent = GUI.TabSelect
GUI.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
GUI.UIGridLayout.CellPadding = UDim2.new(0, 0, 0, 0)
GUI.UIGridLayout.CellSize = UDim2.new(0.2, 0, 1, 0)

GUI.CombatSelect.Name = "CombatSelect"
GUI.CombatSelect.Parent = GUI.TabSelect
GUI.CombatSelect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.CombatSelect.BackgroundTransparency = 0.65
GUI.CombatSelect.BorderSizePixel = 0
GUI.CombatSelect.Size = UDim2.new(0, 200, 0, 50)
GUI.CombatSelect.Font = Enum.Font.SourceSans
GUI.CombatSelect.Text = "Combat"
LoadMainColor(GUI.CombatSelect, "Text")
GUI.CombatSelect.TextSize = 14
GUI.CombatSelect.TextTransparency = 0.250

GUI.VisualsSelect.Name = "VisualsSelect"
GUI.VisualsSelect.Parent = GUI.TabSelect
GUI.VisualsSelect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.VisualsSelect.BackgroundTransparency = 0.65
GUI.VisualsSelect.BorderSizePixel = 0
GUI.VisualsSelect.Size = UDim2.new(0, 200, 0, 50)
GUI.VisualsSelect.Font = Enum.Font.SourceSans
GUI.VisualsSelect.Text = "Visuals"
GUI.VisualsSelect.TextColor3 = Color3.fromRGB(180, 180, 180)
GUI.VisualsSelect.TextSize = 14

GUI.CharacterSelect.Name = "CharacterSelect"
GUI.CharacterSelect.Parent = GUI.TabSelect
GUI.CharacterSelect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.CharacterSelect.BackgroundTransparency = 0.65
GUI.CharacterSelect.BorderSizePixel = 0
GUI.CharacterSelect.Size = UDim2.new(0, 200, 0, 50)
GUI.CharacterSelect.Font = Enum.Font.SourceSans
GUI.CharacterSelect.Text = "Character"
GUI.CharacterSelect.TextColor3 = Color3.fromRGB(180, 180, 180)
GUI.CharacterSelect.TextSize = 14

GUI.MiscSelect.Name = "MiscSelect"
GUI.MiscSelect.Parent = GUI.TabSelect
GUI.MiscSelect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.MiscSelect.BackgroundTransparency = 0.65
GUI.MiscSelect.BorderSizePixel = 0
GUI.MiscSelect.Size = UDim2.new(0, 200, 0, 50)
GUI.MiscSelect.Font = Enum.Font.SourceSans
GUI.MiscSelect.Text = "Miscellaneous"
GUI.MiscSelect.TextColor3 = Color3.fromRGB(180, 180, 180)
GUI.MiscSelect.TextSize = 14

GUI.SettingsSelect.Name = "SettingsSelect"
GUI.SettingsSelect.Parent = GUI.TabSelect
GUI.SettingsSelect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.SettingsSelect.BackgroundTransparency = 0.65
GUI.SettingsSelect.BorderSizePixel = 0
GUI.SettingsSelect.Size = UDim2.new(0, 200, 0, 50)
GUI.SettingsSelect.Font = Enum.Font.SourceSans
GUI.SettingsSelect.Text = "Settings"
GUI.SettingsSelect.TextColor3 = Color3.fromRGB(180, 180, 180)
GUI.SettingsSelect.TextSize = 14

GUI.TabHolder.Name = "TabHolder"
GUI.TabHolder.Parent = GUI.MainFrame
GUI.TabHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TabHolder.BackgroundTransparency = 1
GUI.TabHolder.Position = UDim2.new(0.05, 0, 0.15, 0)
GUI.TabHolder.Size = UDim2.new(0.9, 0, 0.8, 0)

GUI.CombatTab.Name = "CombatTab"
GUI.CombatTab.Parent = GUI.TabHolder
GUI.CombatTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.CombatTab.BackgroundTransparency = 1
GUI.CombatTab.BorderSizePixel = 0
GUI.CombatTab.Size = UDim2.new(1, 0, 1, 0)

GUI.CombatAimbotSection.Name = "CombatAimbotSection"
GUI.CombatAimbotSection.Parent = GUI.CombatTab
GUI.CombatAimbotSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.CombatAimbotSection, "Border")
GUI.CombatAimbotSection.BorderSizePixel = 2
GUI.CombatAimbotSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel.Parent = GUI.CombatAimbotSection
GUI.TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel.BackgroundTransparency = 1
GUI.TextLabel.BorderSizePixel = 0
GUI.TextLabel.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel.Font = Enum.Font.SourceSans
GUI.TextLabel.Text = "Aimbot"
GUI.TextLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel.TextSize = 14
GUI.TextLabel.TextWrapped = true
GUI.TextLabel.TextXAlignment = Enum.TextXAlignment.Left

GUI.AimlockCheckBox.Name = "AimlockCheckBox"
GUI.AimlockCheckBox.Parent = GUI.CombatAimbotSection
LoadCheckBox(GUI.AimlockCheckBox, "Aimlock")
GUI.AimlockCheckBox.BorderSizePixel = 0
GUI.AimlockCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.AimlockCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AimlockCheckBox.Font = Enum.Font.SourceSans
GUI.AimlockCheckBox.Text = ""
GUI.AimlockCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AimlockCheckBox.TextSize = 14

GUI.TextLabel_2.Parent = GUI.CombatAimbotSection
GUI.TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_2.BackgroundTransparency = 1
GUI.TextLabel_2.BorderSizePixel = 0
GUI.TextLabel_2.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_2.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_2.Font = Enum.Font.SourceSans
GUI.TextLabel_2.Text = "Aimlock"
GUI.TextLabel_2.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_2.TextSize = 14
GUI.TextLabel_2.TextWrapped = true
GUI.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_3.Parent = GUI.CombatAimbotSection
GUI.TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_3.BackgroundTransparency = 1
GUI.TextLabel_3.BorderSizePixel = 0
GUI.TextLabel_3.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_3.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_3.Font = Enum.Font.SourceSans
GUI.TextLabel_3.Text = "Silent Aim"
GUI.TextLabel_3.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_3.TextSize = 14
GUI.TextLabel_3.TextWrapped = true
GUI.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

GUI.SilentAimCheckBox.Name = "SilentAimCheckBox"
GUI.SilentAimCheckBox.Parent = GUI.CombatAimbotSection
LoadCheckBox(GUI.SilentAimCheckBox, "SilentAim")
GUI.SilentAimCheckBox.BorderSizePixel = 0
GUI.SilentAimCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.SilentAimCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.SilentAimCheckBox.Font = Enum.Font.SourceSans
GUI.SilentAimCheckBox.Text = ""
GUI.SilentAimCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.SilentAimCheckBox.TextSize = 14

GUI.AutoFireCheckBox.Name = "AutoFireCheckBox"
GUI.AutoFireCheckBox.Parent = GUI.CombatAimbotSection
LoadCheckBox(GUI.AutoFireCheckBox, "AutoFire")
GUI.AutoFireCheckBox.BorderSizePixel = 0
GUI.AutoFireCheckBox.Position = UDim2.new(0.05, 0, 0.325, 0)
GUI.AutoFireCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoFireCheckBox.Font = Enum.Font.SourceSans
GUI.AutoFireCheckBox.Text = ""
GUI.AutoFireCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoFireCheckBox.TextSize = 14

GUI.TextLabel_4.Parent = GUI.CombatAimbotSection
GUI.TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_4.BackgroundTransparency = 1
GUI.TextLabel_4.BorderSizePixel = 0
GUI.TextLabel_4.Position = UDim2.new(0.125, 0, 0.325, 0)
GUI.TextLabel_4.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_4.Font = Enum.Font.SourceSans
GUI.TextLabel_4.Text = "Auto Fire"
GUI.TextLabel_4.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_4.TextSize = 14
GUI.TextLabel_4.TextWrapped = true
GUI.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_5.Parent = GUI.CombatAimbotSection
GUI.TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_5.BackgroundTransparency = 1
GUI.TextLabel_5.BorderSizePixel = 0
GUI.TextLabel_5.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_5.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_5.Font = Enum.Font.SourceSans
GUI.TextLabel_5.Text = "Hitbox"
GUI.TextLabel_5.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_5.TextSize = 14
GUI.TextLabel_5.TextWrapped = true
GUI.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

GUI.AimbotHitBoxButton.Name = "AimbotHitBoxButton"
GUI.AimbotHitBoxButton.Parent = GUI.CombatAimbotSection
GUI.AimbotHitBoxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.AimbotHitBoxButton.BorderSizePixel = 0
GUI.AimbotHitBoxButton.Position = UDim2.new(0.1, 0, 0.45, 0)
GUI.AimbotHitBoxButton.Size = UDim2.new(0.4, 0, 0, 15)
GUI.AimbotHitBoxButton.Font = Enum.Font.SourceSans
GUI.AimbotHitBoxButton.Text = Config["AimbotTarget"]
GUI.AimbotHitBoxButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.AimbotHitBoxButton.TextSize = 14

GUI.TextLabel_6.Parent = GUI.CombatAimbotSection
GUI.TextLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_6.BackgroundTransparency = 1
GUI.TextLabel_6.BorderSizePixel = 0
GUI.TextLabel_6.Position = UDim2.new(0.035, 0, 0.1, 0)
GUI.TextLabel_6.Size = UDim2.new(0.3, 0, 0.05, 0)
GUI.TextLabel_6.Font = Enum.Font.SourceSans
GUI.TextLabel_6.Text = "Aimbot key"
GUI.TextLabel_6.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_6.TextSize = 14
GUI.TextLabel_6.TextWrapped = true
GUI.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left

GUI.AimbotKeyButton.Name = "AimbotKeyButton"
GUI.AimbotKeyButton.Parent = GUI.CombatAimbotSection
GUI.AimbotKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.AimbotKeyButton.BorderSizePixel = 0
GUI.AimbotKeyButton.Position = UDim2.new(0.35, 0, 0.1, 0)
GUI.AimbotKeyButton.Size = UDim2.new(0, 75, 0, 15)
GUI.AimbotKeyButton.Font = Enum.Font.SourceSans
GUI.AimbotKeyButton.Text = Config["AimbotKey"]
GUI.AimbotKeyButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.AimbotKeyButton.TextSize = 14

GUI.HitboxesSelectionFrame.Name = "HitboxesSelectionFrame"
GUI.HitboxesSelectionFrame.Parent = GUI.CombatAimbotSection
GUI.HitboxesSelectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HitboxesSelectionFrame.BackgroundTransparency = 1
GUI.HitboxesSelectionFrame.BorderSizePixel = 0
GUI.HitboxesSelectionFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
GUI.HitboxesSelectionFrame.Size = UDim2.new(0.4, 0, 0, 30)
GUI.HitboxesSelectionFrame.Visible = false

GUI.TorsoHitboxSelect.Name = "TorsoHitboxSelect"
GUI.TorsoHitboxSelect.Parent = GUI.HitboxesSelectionFrame
GUI.TorsoHitboxSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TorsoHitboxSelect.BackgroundTransparency = 1
GUI.TorsoHitboxSelect.BorderSizePixel = 0
GUI.TorsoHitboxSelect.Size = UDim2.new(1, 0, 0.5, 0)
GUI.TorsoHitboxSelect.Font = Enum.Font.SourceSans
GUI.TorsoHitboxSelect.Text = "Torso"
GUI.TorsoHitboxSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TorsoHitboxSelect.TextSize = 14

GUI.HeadHitboxSelect.Name = "HeadHitboxSelect"
GUI.HeadHitboxSelect.Parent = GUI.HitboxesSelectionFrame
GUI.HeadHitboxSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HeadHitboxSelect.BackgroundTransparency = 1
GUI.HeadHitboxSelect.BorderSizePixel = 0
GUI.HeadHitboxSelect.Position = UDim2.new(0, 0, 0.5, 0)
GUI.HeadHitboxSelect.Size = UDim2.new(1, 0, 0.5, 0)
GUI.HeadHitboxSelect.Font = Enum.Font.SourceSans
GUI.HeadHitboxSelect.Text = "Head"
GUI.HeadHitboxSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.HeadHitboxSelect.TextSize = 14

GUI.CombatOthersSection.Name = "CombatOthersSection"
GUI.CombatOthersSection.Parent = GUI.CombatTab
GUI.CombatOthersSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.CombatOthersSection, "Border")
GUI.CombatOthersSection.BorderSizePixel = 2
GUI.CombatOthersSection.Position = UDim2.new(0.55, 0, 0, 0)
GUI.CombatOthersSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_7.Parent = GUI.CombatOthersSection
GUI.TextLabel_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_7.BackgroundTransparency = 1
GUI.TextLabel_7.BorderSizePixel = 0
GUI.TextLabel_7.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_7.Font = Enum.Font.SourceSans
GUI.TextLabel_7.Text = "Others"
GUI.TextLabel_7.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_7.TextSize = 14
GUI.TextLabel_7.TextWrapped = true
GUI.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left

GUI.NoStopCheckBox.Name = "NoStopCheckBox"
GUI.NoStopCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.NoStopCheckBox, "NoStop")
GUI.NoStopCheckBox.BorderSizePixel = 0
GUI.NoStopCheckBox.Position = UDim2.new(0.05, 0, 0.1, 0)
GUI.NoStopCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.NoStopCheckBox.Font = Enum.Font.SourceSans
GUI.NoStopCheckBox.Text = ""
GUI.NoStopCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.NoStopCheckBox.TextSize = 14

GUI.RunPunchCheckBox.Name = "RunPunchCheckBox"
GUI.RunPunchCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.RunPunchCheckBox, "AlwaysRunPunch")
GUI.RunPunchCheckBox.BorderSizePixel = 0
GUI.RunPunchCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.RunPunchCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.RunPunchCheckBox.Font = Enum.Font.SourceSans
GUI.RunPunchCheckBox.Text = ""
GUI.RunPunchCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.RunPunchCheckBox.TextSize = 14

GUI.SuperPunchCheckBox.Name = "SuperPunchCheckBox"
GUI.SuperPunchCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.SuperPunchCheckBox, "SuperPunch")
GUI.SuperPunchCheckBox.BorderSizePixel = 0
GUI.SuperPunchCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.SuperPunchCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.SuperPunchCheckBox.Font = Enum.Font.SourceSans
GUI.SuperPunchCheckBox.Text = ""
GUI.SuperPunchCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.SuperPunchCheckBox.TextSize = 14

GUI.TextLabel_8.Parent = GUI.CombatOthersSection
GUI.TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_8.BackgroundTransparency = 1
GUI.TextLabel_8.BorderSizePixel = 0
GUI.TextLabel_8.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_8.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_8.Font = Enum.Font.SourceSans
GUI.TextLabel_8.Text = "No Stop"
GUI.TextLabel_8.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_8.TextSize = 14
GUI.TextLabel_8.TextWrapped = true
GUI.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_9.Parent = GUI.CombatOthersSection
GUI.TextLabel_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_9.BackgroundTransparency = 1
GUI.TextLabel_9.BorderSizePixel = 0
GUI.TextLabel_9.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_9.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_9.Font = Enum.Font.SourceSans
GUI.TextLabel_9.Text = "Always Run Punch"
GUI.TextLabel_9.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_9.TextSize = 14
GUI.TextLabel_9.TextWrapped = true
GUI.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_10.Parent = GUI.CombatOthersSection
GUI.TextLabel_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_10.BackgroundTransparency = 1
GUI.TextLabel_10.BorderSizePixel = 0
GUI.TextLabel_10.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_10.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_10.Font = Enum.Font.SourceSans
GUI.TextLabel_10.Text = "Super Punch"
GUI.TextLabel_10.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_10.TextSize = 14
GUI.TextLabel_10.TextWrapped = true
GUI.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoSwitchCheckBox.Name = "AutoSwitchCheckBox"
GUI.AutoSwitchCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.AutoSwitchCheckBox, "AutoSwitch")
GUI.AutoSwitchCheckBox.BorderSizePixel = 0
GUI.AutoSwitchCheckBox.Position = UDim2.new(0.05, 0, 0.325, 0)
GUI.AutoSwitchCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoSwitchCheckBox.Font = Enum.Font.SourceSans
GUI.AutoSwitchCheckBox.Text = ""
GUI.AutoSwitchCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoSwitchCheckBox.TextSize = 14

GUI.TextLabel_11.Parent = GUI.CombatOthersSection
GUI.TextLabel_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_11.BackgroundTransparency = 1
GUI.TextLabel_11.BorderSizePixel = 0
GUI.TextLabel_11.Position = UDim2.new(0.125, 0, 0.325, 0)
GUI.TextLabel_11.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_11.Font = Enum.Font.SourceSans
GUI.TextLabel_11.Text = "Auto Switch"
GUI.TextLabel_11.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_11.TextSize = 14
GUI.TextLabel_11.TextWrapped = true
GUI.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left

GUI.StompSpamCheckBox.Name = "StompSpamCheckBox"
GUI.StompSpamCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.StompSpamCheckBox, "StompSpam")
GUI.StompSpamCheckBox.BorderSizePixel = 0
GUI.StompSpamCheckBox.Position = UDim2.new(0.05, 0, 0.4, 0)
GUI.StompSpamCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.StompSpamCheckBox.Font = Enum.Font.SourceSans
GUI.StompSpamCheckBox.Text = ""
GUI.StompSpamCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.StompSpamCheckBox.TextSize = 14

GUI.TextLabel_12.Parent = GUI.CombatOthersSection
GUI.TextLabel_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_12.BackgroundTransparency = 1
GUI.TextLabel_12.BorderSizePixel = 0
GUI.TextLabel_12.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_12.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_12.Font = Enum.Font.SourceSans
GUI.TextLabel_12.Text = "Stomp Spam"
GUI.TextLabel_12.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_12.TextSize = 14
GUI.TextLabel_12.TextWrapped = true
GUI.TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoStompCheckBox.Name = "AutoStompCheckBox"
GUI.AutoStompCheckBox.Parent = GUI.CombatOthersSection
LoadCheckBox(GUI.AutoStompCheckBox, "AutoStomp")
GUI.AutoStompCheckBox.BorderSizePixel = 0
GUI.AutoStompCheckBox.Position = UDim2.new(0.05, 0, 0.475, 0)
GUI.AutoStompCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoStompCheckBox.Font = Enum.Font.SourceSans
GUI.AutoStompCheckBox.Text = ""
GUI.AutoStompCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoStompCheckBox.TextSize = 14

GUI.TextLabel_13.Parent = GUI.CombatOthersSection
GUI.TextLabel_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_13.BackgroundTransparency = 1
GUI.TextLabel_13.BorderSizePixel = 0
GUI.TextLabel_13.Position = UDim2.new(0.125, 0, 0.475, 0)
GUI.TextLabel_13.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_13.Font = Enum.Font.SourceSans
GUI.TextLabel_13.Text = "Auto Stomp"
GUI.TextLabel_13.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_13.TextSize = 14
GUI.TextLabel_13.TextWrapped = true
GUI.TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_14.Parent = GUI.CombatOthersSection
GUI.TextLabel_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_14.BackgroundTransparency = 1
GUI.TextLabel_14.BorderSizePixel = 0
GUI.TextLabel_14.Position = UDim2.new(0.125, 0, 0.55, 0)
GUI.TextLabel_14.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_14.Font = Enum.Font.SourceSans
GUI.TextLabel_14.Text = "Auto Stomp Distance"
GUI.TextLabel_14.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_14.TextSize = 14
GUI.TextLabel_14.TextWrapped = true
GUI.TextLabel_14.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoStompDistanceSlider.Name = "AutoStompDistanceSlider"
GUI.AutoStompDistanceSlider.Parent = GUI.CombatOthersSection
GUI.AutoStompDistanceSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.AutoStompDistanceSlider.BorderSizePixel = 0
GUI.AutoStompDistanceSlider.Position = UDim2.new(0.1, 0, 0.625, 0)
GUI.AutoStompDistanceSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.AutoStompDistanceSlider.Font = Enum.Font.SourceSans
GUI.AutoStompDistanceSlider.Text = ""
GUI.AutoStompDistanceSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.AutoStompDistanceSlider.TextSize = 14

GUI.AutoStompDistanceSliderButton.Name = "AutoStompDistanceSliderButton"
GUI.AutoStompDistanceSliderButton.Parent = GUI.AutoStompDistanceSlider
LoadMainColor(GUI.AutoStompDistanceSliderButton, "Background")
GUI.AutoStompDistanceSliderButton.BorderSizePixel = 0
GUI.AutoStompDistanceSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.AutoStompDistanceSliderButton.Font = Enum.Font.SourceSans
GUI.AutoStompDistanceSliderButton.Text = ""
GUI.AutoStompDistanceSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoStompDistanceSliderButton.TextSize = 14

GUI.AutoStompDistanceAmount.Name = "AutoStompDistanceAmount"
GUI.AutoStompDistanceAmount.Parent = GUI.AutoStompDistanceSlider
GUI.AutoStompDistanceAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.AutoStompDistanceAmount.BackgroundTransparency = 1
GUI.AutoStompDistanceAmount.BorderSizePixel = 0
GUI.AutoStompDistanceAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.AutoStompDistanceAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.AutoStompDistanceAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.AutoStompDistanceAmount, GUI.AutoStompDistanceSliderButton, "AutoStompDistance")
GUI.AutoStompDistanceAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.AutoStompDistanceAmount.TextSize = 14

GUI.VisualsTab.Name = "VisualsTab"
GUI.VisualsTab.Parent = GUI.TabHolder
GUI.VisualsTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.VisualsTab.BackgroundTransparency = 1
GUI.VisualsTab.BorderSizePixel = 0
GUI.VisualsTab.Size = UDim2.new(1, 0, 1, 0)
GUI.VisualsTab.Visible = false

GUI.VisualsESPSection.Name = "VisualsESPSection"
GUI.VisualsESPSection.Parent = GUI.VisualsTab
GUI.VisualsESPSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.VisualsESPSection, "Border")
GUI.VisualsESPSection.BorderSizePixel = 2
GUI.VisualsESPSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_15.Parent = GUI.VisualsESPSection
GUI.TextLabel_15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_15.BackgroundTransparency = 1
GUI.TextLabel_15.BorderSizePixel = 0
GUI.TextLabel_15.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_15.Font = Enum.Font.SourceSans
GUI.TextLabel_15.Text = "Player ESP"
GUI.TextLabel_15.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_15.TextSize = 14
GUI.TextLabel_15.TextWrapped = true
GUI.TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_16.Parent = GUI.VisualsESPSection
GUI.TextLabel_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_16.BackgroundTransparency = 1
GUI.TextLabel_16.BorderSizePixel = 0
GUI.TextLabel_16.Position = UDim2.new(0.035, 0, 0.1, 0)
GUI.TextLabel_16.Size = UDim2.new(0.3, 0, 0.05, 0)
GUI.TextLabel_16.Font = Enum.Font.SourceSans
GUI.TextLabel_16.Text = "Player ESP key"
GUI.TextLabel_16.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_16.TextSize = 14
GUI.TextLabel_16.TextWrapped = true
GUI.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_17.Parent = GUI.VisualsESPSection
GUI.TextLabel_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_17.BackgroundTransparency = 1
GUI.TextLabel_17.BorderSizePixel = 0
GUI.TextLabel_17.Position = UDim2.new(0.125, 0, 0.325, 0)
GUI.TextLabel_17.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_17.Font = Enum.Font.SourceSans
GUI.TextLabel_17.Text = "KO"
GUI.TextLabel_17.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_17.TextSize = 14
GUI.TextLabel_17.TextWrapped = true
GUI.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left

GUI.PlayerChamsCheckBox.Name = "PlayerChamsCheckBox"
GUI.PlayerChamsCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerChamsCheckBox, "Chams", GUI.PlayerChamsColorButton)
GUI.PlayerChamsCheckBox.BorderSizePixel = 0
GUI.PlayerChamsCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.PlayerChamsCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerChamsCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerChamsCheckBox.Text = ""
GUI.PlayerChamsCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerChamsCheckBox.TextSize = 14

GUI.PlayerESPKeyButton.Name = "PlayerESPKeyButton"
GUI.PlayerESPKeyButton.Parent = GUI.VisualsESPSection
GUI.PlayerESPKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.PlayerESPKeyButton.BorderSizePixel = 0
GUI.PlayerESPKeyButton.Position = UDim2.new(0.35, 0, 0.1, 0)
GUI.PlayerESPKeyButton.Size = UDim2.new(0, 75, 0, 15)
GUI.PlayerESPKeyButton.Font = Enum.Font.SourceSans
GUI.PlayerESPKeyButton.Text = Config["PlayerESPKey"]
GUI.PlayerESPKeyButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.PlayerESPKeyButton.TextSize = 14

GUI.PlayerStaminaCheckBox.Name = "PlayerStaminaCheckBox"
GUI.PlayerStaminaCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerStaminaCheckBox, "Stamina", GUI.PlayerStaminaColorButton)
GUI.PlayerStaminaCheckBox.BorderSizePixel = 0
GUI.PlayerStaminaCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.PlayerStaminaCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerStaminaCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerStaminaCheckBox.Text = ""
GUI.PlayerStaminaCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerStaminaCheckBox.TextSize = 14

GUI.PlayerKOCheckBox.Name = "PlayerKOCheckBox"
GUI.PlayerKOCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerKOCheckBox, "KO", GUI.PlayerKOColorButton)
GUI.PlayerKOCheckBox.BorderSizePixel = 0
GUI.PlayerKOCheckBox.Position = UDim2.new(0.05, 0, 0.325, 0)
GUI.PlayerKOCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerKOCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerKOCheckBox.Text = ""
GUI.PlayerKOCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerKOCheckBox.TextSize = 14

GUI.TextLabel_18.Parent = GUI.VisualsESPSection
GUI.TextLabel_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_18.BackgroundTransparency = 1
GUI.TextLabel_18.BorderSizePixel = 0
GUI.TextLabel_18.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_18.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_18.Font = Enum.Font.SourceSans
GUI.TextLabel_18.Text = "Chams"
GUI.TextLabel_18.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_18.TextSize = 14
GUI.TextLabel_18.TextWrapped = true
GUI.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_19.Parent = GUI.VisualsESPSection
GUI.TextLabel_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_19.BackgroundTransparency = 1
GUI.TextLabel_19.BorderSizePixel = 0
GUI.TextLabel_19.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_19.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_19.Font = Enum.Font.SourceSans
GUI.TextLabel_19.Text = "Stamina"
GUI.TextLabel_19.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_19.TextSize = 14
GUI.TextLabel_19.TextWrapped = true
GUI.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left

GUI.PlayerBoxCheckBox.Name = "PlayerBoxCheckBox"
GUI.PlayerBoxCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerBoxCheckBox, "Box", GUI.PlayerBoxColorButton)
GUI.PlayerBoxCheckBox.BorderSizePixel = 0
GUI.PlayerBoxCheckBox.Position = UDim2.new(0.05, 0, 0.4, 0)
GUI.PlayerBoxCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerBoxCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerBoxCheckBox.Text = ""
GUI.PlayerBoxCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerBoxCheckBox.TextSize = 14

GUI.TextLabel_20.Parent = GUI.VisualsESPSection
GUI.TextLabel_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_20.BackgroundTransparency = 1
GUI.TextLabel_20.BorderSizePixel = 0
GUI.TextLabel_20.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_20.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_20.Font = Enum.Font.SourceSans
GUI.TextLabel_20.Text = "Box"
GUI.TextLabel_20.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_20.TextSize = 14
GUI.TextLabel_20.TextWrapped = true
GUI.TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_21.Parent = GUI.VisualsESPSection
GUI.TextLabel_21.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_21.BackgroundTransparency = 1
GUI.TextLabel_21.BorderSizePixel = 0
GUI.TextLabel_21.Position = UDim2.new(0.125, 0, 0.475, 0)
GUI.TextLabel_21.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_21.Font = Enum.Font.SourceSans
GUI.TextLabel_21.Text = "Glow"
GUI.TextLabel_21.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_21.TextSize = 14
GUI.TextLabel_21.TextWrapped = true
GUI.TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left

GUI.PlayerGlowCheckBox.Name = "PlayerGlowCheckBox"
GUI.PlayerGlowCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerGlowCheckBox, "Glow", GUI.PlayerGlowColorButton)
GUI.PlayerGlowCheckBox.BorderSizePixel = 0
GUI.PlayerGlowCheckBox.Position = UDim2.new(0.05, 0, 0.475, 0)
GUI.PlayerGlowCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerGlowCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerGlowCheckBox.Text = ""
GUI.PlayerGlowCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerGlowCheckBox.TextSize = 14

GUI.PlayerInfoCheckBox.Name = "PlayerInfoCheckBox"
GUI.PlayerInfoCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.PlayerInfoCheckBox, "Info", GUI.PlayerInfoColorButton)
GUI.PlayerInfoCheckBox.BorderSizePixel = 0
GUI.PlayerInfoCheckBox.Position = UDim2.new(0.05, 0, 0.55, 0)
GUI.PlayerInfoCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerInfoCheckBox.Font = Enum.Font.SourceSans
GUI.PlayerInfoCheckBox.Text = ""
GUI.PlayerInfoCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerInfoCheckBox.TextSize = 14

GUI.TextLabel_22.Parent = GUI.VisualsESPSection
GUI.TextLabel_22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_22.BackgroundTransparency = 1
GUI.TextLabel_22.BorderSizePixel = 0
GUI.TextLabel_22.Position = UDim2.new(0.125, 0, 0.55, 0)
GUI.TextLabel_22.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_22.Font = Enum.Font.SourceSans
GUI.TextLabel_22.Text = "Info"
GUI.TextLabel_22.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_22.TextSize = 14
GUI.TextLabel_22.TextWrapped = true
GUI.TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_23.Parent = GUI.VisualsESPSection
GUI.TextLabel_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_23.BackgroundTransparency = 1
GUI.TextLabel_23.BorderSizePixel = 0
GUI.TextLabel_23.Position = UDim2.new(0, 0, 0.65, 0)
GUI.TextLabel_23.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_23.Font = Enum.Font.SourceSans
GUI.TextLabel_23.Text = "Item ESP"
GUI.TextLabel_23.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_23.TextSize = 14
GUI.TextLabel_23.TextWrapped = true
GUI.TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left

GUI.PlayerGlowColorButton.Name = "PlayerGlowColorButton"
GUI.PlayerGlowColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerGlowColorButton, "GlowColor")
GUI.PlayerGlowColorButton.BorderSizePixel = 0
GUI.PlayerGlowColorButton.Position = UDim2.new(0.5, 0, 0.475, 0)
GUI.PlayerGlowColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerGlowColorButton.Visible = false
GUI.PlayerGlowColorButton.Font = Enum.Font.SourceSans
GUI.PlayerGlowColorButton.Text = ""
GUI.PlayerGlowColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerGlowColorButton.TextSize = 14

GUI.PlayerInfoColorButton.Name = "PlayerInfoColorButton"
GUI.PlayerInfoColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerInfoColorButton, "InfoColor")
GUI.PlayerInfoColorButton.BorderSizePixel = 0
GUI.PlayerInfoColorButton.Position = UDim2.new(0.5, 0, 0.55, 0)
GUI.PlayerInfoColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerInfoColorButton.Visible = false
GUI.PlayerInfoColorButton.Font = Enum.Font.SourceSans
GUI.PlayerInfoColorButton.Text = ""
GUI.PlayerInfoColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerInfoColorButton.TextSize = 14

GUI.PlayerBoxColorButton.Name = "PlayerBoxColorButton"
GUI.PlayerBoxColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerBoxColorButton, "BoxColor")
GUI.PlayerBoxColorButton.BorderSizePixel = 0
GUI.PlayerBoxColorButton.Position = UDim2.new(0.5, 0, 0.4, 0)
GUI.PlayerBoxColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerBoxColorButton.Visible = false
GUI.PlayerBoxColorButton.Font = Enum.Font.SourceSans
GUI.PlayerBoxColorButton.Text = ""
GUI.PlayerBoxColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerBoxColorButton.TextSize = 14

GUI.PlayerKOColorButton.Name = "PlayerKOColorButton"
GUI.PlayerKOColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerKOColorButton, "KOColor")
GUI.PlayerKOColorButton.BorderSizePixel = 0
GUI.PlayerKOColorButton.Position = UDim2.new(0.5, 0, 0.325, 0)
GUI.PlayerKOColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerKOColorButton.Visible = false
GUI.PlayerKOColorButton.Font = Enum.Font.SourceSans
GUI.PlayerKOColorButton.Text = ""
GUI.PlayerKOColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerKOColorButton.TextSize = 14

GUI.PlayerStaminaColorButton.Name = "PlayerStaminaColorButton"
GUI.PlayerStaminaColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerStaminaColorButton, "StaminaColor")
GUI.PlayerStaminaColorButton.BorderSizePixel = 0
GUI.PlayerStaminaColorButton.Position = UDim2.new(0.5, 0, 0.25, 0)
GUI.PlayerStaminaColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerStaminaColorButton.Visible = false
GUI.PlayerStaminaColorButton.Font = Enum.Font.SourceSans
GUI.PlayerStaminaColorButton.Text = ""
GUI.PlayerStaminaColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerStaminaColorButton.TextSize = 14

GUI.PlayerChamsColorButton.Name = "PlayerChamsColorButton"
GUI.PlayerChamsColorButton.Parent = GUI.VisualsESPSection
LoadColorButton(GUI.PlayerChamsColorButton, "ChamsColor")
GUI.PlayerChamsColorButton.BorderSizePixel = 0
GUI.PlayerChamsColorButton.Position = UDim2.new(0.5, 0, 0.175, 0)
GUI.PlayerChamsColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.PlayerChamsColorButton.Visible = false
GUI.PlayerChamsColorButton.Font = Enum.Font.SourceSans
GUI.PlayerChamsColorButton.Text = ""
GUI.PlayerChamsColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.PlayerChamsColorButton.TextSize = 14

GUI.ItemESPEnabledCheckBox.Name = "ItemESPEnabledCheckBox"
GUI.ItemESPEnabledCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.ItemESPEnabledCheckBox, "ItemEsp")
GUI.ItemESPEnabledCheckBox.BorderSizePixel = 0
GUI.ItemESPEnabledCheckBox.Position = UDim2.new(0.05, 0, 0.75, 0)
GUI.ItemESPEnabledCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.ItemESPEnabledCheckBox.Font = Enum.Font.SourceSans
GUI.ItemESPEnabledCheckBox.Text = ""
GUI.ItemESPEnabledCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.ItemESPEnabledCheckBox.TextSize = 14

GUI.TextLabel_24.Parent = GUI.VisualsESPSection
GUI.TextLabel_24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_24.BackgroundTransparency = 1
GUI.TextLabel_24.BorderSizePixel = 0
GUI.TextLabel_24.Position = UDim2.new(0.125, 0, 0.75, 0)
GUI.TextLabel_24.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_24.Font = Enum.Font.SourceSans
GUI.TextLabel_24.Text = "Enabled"
GUI.TextLabel_24.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_24.TextSize = 14
GUI.TextLabel_24.TextWrapped = true
GUI.TextLabel_24.TextXAlignment = Enum.TextXAlignment.Left

GUI.ItemESPGoodItemsCheckBox.Name = "ItemESPGoodItemsCheckBox"
GUI.ItemESPGoodItemsCheckBox.Parent = GUI.VisualsESPSection
LoadCheckBox(GUI.ItemESPGoodItemsCheckBox, "GoodItemsOnly")
GUI.ItemESPGoodItemsCheckBox.BorderSizePixel = 0
GUI.ItemESPGoodItemsCheckBox.Position = UDim2.new(0.05, 0, 0.824999988, 0)
GUI.ItemESPGoodItemsCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.ItemESPGoodItemsCheckBox.Font = Enum.Font.SourceSans
GUI.ItemESPGoodItemsCheckBox.Text = ""
GUI.ItemESPGoodItemsCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.ItemESPGoodItemsCheckBox.TextSize = 14

GUI.TextLabel_25.Parent = GUI.VisualsESPSection
GUI.TextLabel_25.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_25.BackgroundTransparency = 1
GUI.TextLabel_25.BorderSizePixel = 0
GUI.TextLabel_25.Position = UDim2.new(0.125, 0, 0.824999988, 0)
GUI.TextLabel_25.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_25.Font = Enum.Font.SourceSans
GUI.TextLabel_25.Text = "Good Items Only"
GUI.TextLabel_25.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_25.TextSize = 14
GUI.TextLabel_25.TextWrapped = true
GUI.TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left

GUI.VisualsOthersSection.Name = "VisualsOthersSection"
GUI.VisualsOthersSection.Parent = GUI.VisualsTab
GUI.VisualsOthersSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.VisualsOthersSection, "Border")
GUI.VisualsOthersSection.BorderSizePixel = 2
GUI.VisualsOthersSection.Position = UDim2.new(0.55, 0, 0, 0)
GUI.VisualsOthersSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_26.Parent = GUI.VisualsOthersSection
GUI.TextLabel_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_26.BackgroundTransparency = 1
GUI.TextLabel_26.BorderSizePixel = 0
GUI.TextLabel_26.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_26.Font = Enum.Font.SourceSans
GUI.TextLabel_26.Text = "Others"
GUI.TextLabel_26.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_26.TextSize = 14
GUI.TextLabel_26.TextWrapped = true
GUI.TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_27.Parent = GUI.VisualsOthersSection
GUI.TextLabel_27.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_27.BackgroundTransparency = 1
GUI.TextLabel_27.BorderSizePixel = 0
GUI.TextLabel_27.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_27.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_27.Font = Enum.Font.SourceSans
GUI.TextLabel_27.Text = "Bullet Tracers"
GUI.TextLabel_27.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_27.TextSize = 14
GUI.TextLabel_27.TextWrapped = true
GUI.TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left

GUI.BulletTracersColorButton.Name = "BulletTracersColorButton"
GUI.BulletTracersColorButton.Parent = GUI.VisualsOthersSection
LoadMainColor(GUI.BulletTracersColorButton, "Background")
GUI.BulletTracersColorButton.BorderSizePixel = 0
GUI.BulletTracersColorButton.Position = UDim2.new(0.5, 0, 0.1, 0)
GUI.BulletTracersColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.BulletTracersColorButton.Visible = Config["BulletTracers"]
GUI.BulletTracersColorButton.Font = Enum.Font.SourceSans
GUI.BulletTracersColorButton.Text = ""
GUI.BulletTracersColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.BulletTracersColorButton.TextSize = 14

GUI.BulletTracersCheckBox.Name = "BulletTracersCheckBox"
GUI.BulletTracersCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.BulletTracersCheckBox, "BulletTracers", GUI.BulletTracersColorButton)
GUI.BulletTracersCheckBox.BorderSizePixel = 0
GUI.BulletTracersCheckBox.Position = UDim2.new(0.05, 0, 0.1, 0)
GUI.BulletTracersCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.BulletTracersCheckBox.Font = Enum.Font.SourceSans
GUI.BulletTracersCheckBox.Text = ""
GUI.BulletTracersCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.BulletTracersCheckBox.TextSize = 14

GUI.TextLabel_28.Parent = GUI.VisualsOthersSection
GUI.TextLabel_28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_28.BackgroundTransparency = 1
GUI.TextLabel_28.BorderSizePixel = 0
GUI.TextLabel_28.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_28.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_28.Font = Enum.Font.SourceSans
GUI.TextLabel_28.Text = "Watermark"
GUI.TextLabel_28.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_28.TextSize = 14
GUI.TextLabel_28.TextWrapped = true
GUI.TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_29.Parent = GUI.VisualsOthersSection
GUI.TextLabel_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_29.BackgroundTransparency = 1
GUI.TextLabel_29.BorderSizePixel = 0
GUI.TextLabel_29.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_29.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_29.Font = Enum.Font.SourceSans
GUI.TextLabel_29.Text = "States"
GUI.TextLabel_29.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_29.TextSize = 14
GUI.TextLabel_29.TextWrapped = true
GUI.TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left

GUI.StatesCheckBox.Name = "StatesCheckBox"
GUI.StatesCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.StatesCheckBox, "States")
GUI.StatesCheckBox.BorderSizePixel = 0
GUI.StatesCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.StatesCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.StatesCheckBox.Font = Enum.Font.SourceSans
GUI.StatesCheckBox.Text = ""
GUI.StatesCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.StatesCheckBox.TextSize = 14

GUI.HitmarkerSoundButton.Name = "HitmarkerSoundButton"
GUI.HitmarkerSoundButton.Parent = GUI.VisualsOthersSection
GUI.HitmarkerSoundButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.HitmarkerSoundButton.BorderSizePixel = 0
GUI.HitmarkerSoundButton.Position = UDim2.new(0.1, 0, 0.6, 0)
GUI.HitmarkerSoundButton.Size = UDim2.new(0.4, 0, 0, 15)
GUI.HitmarkerSoundButton.Font = Enum.Font.SourceSans
GUI.HitmarkerSoundButton.Text = "None"
GUI.HitmarkerSoundButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.HitmarkerSoundButton.TextSize = 14

GUI.TextLabel_30.Parent = GUI.VisualsOthersSection
GUI.TextLabel_30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_30.BackgroundTransparency = 1
GUI.TextLabel_30.BorderSizePixel = 0
GUI.TextLabel_30.Position = UDim2.new(0.125, 0, 0.55, 0)
GUI.TextLabel_30.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_30.Font = Enum.Font.SourceSans
GUI.TextLabel_30.Text = "Hitmarker Sound"
GUI.TextLabel_30.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_30.TextSize = 14
GUI.TextLabel_30.TextWrapped = true
GUI.TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left

GUI.HitmarkerSoundsSelectionFrame.Name = "HitmarkerSoundsSelectionFrame"
GUI.HitmarkerSoundsSelectionFrame.Parent = GUI.VisualsOthersSection
GUI.HitmarkerSoundsSelectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HitmarkerSoundsSelectionFrame.BackgroundTransparency = 1
GUI.HitmarkerSoundsSelectionFrame.BorderSizePixel = 0
GUI.HitmarkerSoundsSelectionFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
GUI.HitmarkerSoundsSelectionFrame.Size = UDim2.new(0.4, 0, 0, 30)
GUI.HitmarkerSoundsSelectionFrame.Visible = false

GUI.DefaultSoundSelect.Name = "DefaultSoundSelect"
GUI.DefaultSoundSelect.Parent = GUI.HitmarkerSoundsSelectionFrame
GUI.DefaultSoundSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.DefaultSoundSelect.BackgroundTransparency = 1
GUI.DefaultSoundSelect.BorderSizePixel = 0
GUI.DefaultSoundSelect.Size = UDim2.new(1, 0, 0.5, 0)
GUI.DefaultSoundSelect.Font = Enum.Font.SourceSans
GUI.DefaultSoundSelect.Text = "Default"
GUI.DefaultSoundSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.DefaultSoundSelect.TextSize = 14

GUI.NoneSoundSelect.Name = "NoneSoundSelect"
GUI.NoneSoundSelect.Parent = GUI.HitmarkerSoundsSelectionFrame
GUI.NoneSoundSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.NoneSoundSelect.BackgroundTransparency = 1
GUI.NoneSoundSelect.BorderSizePixel = 0
GUI.NoneSoundSelect.Position = UDim2.new(0, 0, 0.5, 0)
GUI.NoneSoundSelect.Size = UDim2.new(1, 0, 0.5, 0)
GUI.NoneSoundSelect.Font = Enum.Font.SourceSans
GUI.NoneSoundSelect.Text = "None"
GUI.NoneSoundSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.NoneSoundSelect.TextSize = 14

GUI.WatermarkCheckBox.Name = "WatermarkCheckBox"
GUI.WatermarkCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.WatermarkCheckBox, "Watermark")
GUI.WatermarkCheckBox.BorderSizePixel = 0
GUI.WatermarkCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.WatermarkCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.WatermarkCheckBox.Font = Enum.Font.SourceSans
GUI.WatermarkCheckBox.Text = ""
GUI.WatermarkCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.WatermarkCheckBox.TextSize = 14

GUI.HitmarkerCheckBox.Name = "HitmarkerCheckBox"
GUI.HitmarkerCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.HitmarkerCheckBox, "Hitmarker")
GUI.HitmarkerCheckBox.BorderSizePixel = 0
GUI.HitmarkerCheckBox.Position = UDim2.new(0.05, 0, 0.475, 0)
GUI.HitmarkerCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.HitmarkerCheckBox.Font = Enum.Font.SourceSans
GUI.HitmarkerCheckBox.Text = ""
GUI.HitmarkerCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.HitmarkerCheckBox.TextSize = 14

GUI.TextLabel_31.Parent = GUI.VisualsOthersSection
GUI.TextLabel_31.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_31.BackgroundTransparency = 1
GUI.TextLabel_31.BorderSizePixel = 0
GUI.TextLabel_31.Position = UDim2.new(0.125, 0, 0.475, 0)
GUI.TextLabel_31.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_31.Font = Enum.Font.SourceSans
GUI.TextLabel_31.Text = "Hitmarker"
GUI.TextLabel_31.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_31.TextSize = 14
GUI.TextLabel_31.TextWrapped = true
GUI.TextLabel_31.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_32.Parent = GUI.VisualsOthersSection
GUI.TextLabel_32.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_32.BackgroundTransparency = 1
GUI.TextLabel_32.BorderSizePixel = 0
GUI.TextLabel_32.Position = UDim2.new(0.125, 0, 0.325, 0)
GUI.TextLabel_32.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_32.Font = Enum.Font.SourceSans
GUI.TextLabel_32.Text = "Show Ammo"
GUI.TextLabel_32.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_32.TextSize = 14
GUI.TextLabel_32.TextWrapped = true
GUI.TextLabel_32.TextXAlignment = Enum.TextXAlignment.Left

GUI.ShowAmmoCheckBox.Name = "ShowAmmoCheckBox"
GUI.ShowAmmoCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.ShowAmmoCheckBox, "ShowAmmo")
GUI.ShowAmmoCheckBox.BorderSizePixel = 0
GUI.ShowAmmoCheckBox.Position = UDim2.new(0.05, 0, 0.325, 0)
GUI.ShowAmmoCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.ShowAmmoCheckBox.Font = Enum.Font.SourceSans
GUI.ShowAmmoCheckBox.Text = ""
GUI.ShowAmmoCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.ShowAmmoCheckBox.TextSize = 14

GUI.TextLabel_33.Parent = GUI.VisualsOthersSection
GUI.TextLabel_33.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_33.BackgroundTransparency = 1
GUI.TextLabel_33.BorderSizePixel = 0
GUI.TextLabel_33.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_33.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_33.Font = Enum.Font.SourceSans
GUI.TextLabel_33.Text = "Draggable UI Objects"
GUI.TextLabel_33.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_33.TextSize = 14
GUI.TextLabel_33.TextWrapped = true
GUI.TextLabel_33.TextXAlignment = Enum.TextXAlignment.Left

GUI.DraggableUIObjectsCheckBox.Name = "DraggableUIObjectsCheckBox"
GUI.DraggableUIObjectsCheckBox.Parent = GUI.VisualsOthersSection
LoadCheckBox(GUI.DraggableUIObjectsCheckBox, "DraggableUIObjects")
GUI.DraggableUIObjectsCheckBox.BorderSizePixel = 0
GUI.DraggableUIObjectsCheckBox.Position = UDim2.new(0.05, 0, 0.4, 0)
GUI.DraggableUIObjectsCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.DraggableUIObjectsCheckBox.Font = Enum.Font.SourceSans
GUI.DraggableUIObjectsCheckBox.Text = ""
GUI.DraggableUIObjectsCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.DraggableUIObjectsCheckBox.TextSize = 14

GUI.CharacterTab.Name = "CharacterTab"
GUI.CharacterTab.Parent = GUI.TabHolder
GUI.CharacterTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.CharacterTab.BackgroundTransparency = 1
GUI.CharacterTab.BorderSizePixel = 0
GUI.CharacterTab.Size = UDim2.new(1, 0, 1, 0)
GUI.CharacterTab.Visible = false

GUI.CharacterMainSection.Name = "CharacterMainSection"
GUI.CharacterMainSection.Parent = GUI.CharacterTab
GUI.CharacterMainSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.CharacterMainSection, "Border")
GUI.CharacterMainSection.BorderSizePixel = 2
GUI.CharacterMainSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_34.Parent = GUI.CharacterMainSection
GUI.TextLabel_34.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_34.BackgroundTransparency = 1
GUI.TextLabel_34.BorderSizePixel = 0
GUI.TextLabel_34.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_34.Font = Enum.Font.SourceSans
GUI.TextLabel_34.Text = "Character"
GUI.TextLabel_34.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_34.TextSize = 14
GUI.TextLabel_34.TextWrapped = true
GUI.TextLabel_34.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_35.Parent = GUI.CharacterMainSection
GUI.TextLabel_35.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_35.BackgroundTransparency = 1
GUI.TextLabel_35.BorderSizePixel = 0
GUI.TextLabel_35.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_35.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_35.Font = Enum.Font.SourceSans
GUI.TextLabel_35.Text = "God Mode"
GUI.TextLabel_35.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_35.TextSize = 14
GUI.TextLabel_35.TextWrapped = true
GUI.TextLabel_35.TextXAlignment = Enum.TextXAlignment.Left

GUI.GodModeCheckBox.Name = "GodModeCheckBox"
GUI.GodModeCheckBox.Parent = GUI.CharacterMainSection
LoadCheckBox(GUI.GodModeCheckBox, "GodMode")
GUI.GodModeCheckBox.BorderSizePixel = 0
GUI.GodModeCheckBox.Position = UDim2.new(0.05, 0, 0.1, 0)
GUI.GodModeCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.GodModeCheckBox.Font = Enum.Font.SourceSans
GUI.GodModeCheckBox.Text = ""
GUI.GodModeCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.GodModeCheckBox.TextSize = 14

GUI.TextLabel_36.Parent = GUI.CharacterMainSection
GUI.TextLabel_36.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_36.BackgroundTransparency = 1
GUI.TextLabel_36.BorderSizePixel = 0
GUI.TextLabel_36.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_36.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_36.Font = Enum.Font.SourceSans
GUI.TextLabel_36.Text = "No-KO"
GUI.TextLabel_36.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_36.TextSize = 14
GUI.TextLabel_36.TextWrapped = true
GUI.TextLabel_36.TextXAlignment = Enum.TextXAlignment.Left

GUI.NoKOCheckBox.Name = "NoKOCheckBox"
GUI.NoKOCheckBox.Parent = GUI.CharacterMainSection
LoadCheckBox(GUI.NoKOCheckBox, "NoKO")
GUI.NoKOCheckBox.BorderSizePixel = 0
GUI.NoKOCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.NoKOCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.NoKOCheckBox.Font = Enum.Font.SourceSans
GUI.NoKOCheckBox.Text = ""
GUI.NoKOCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.NoKOCheckBox.TextSize = 14

GUI.CharacterMovementSection.Name = "CharacterMovementSection"
GUI.CharacterMovementSection.Parent = GUI.CharacterTab
GUI.CharacterMovementSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.CharacterMovementSection, "Border")
GUI.CharacterMovementSection.BorderSizePixel = 2
GUI.CharacterMovementSection.Position = UDim2.new(0.55, 0, 0, 0)
GUI.CharacterMovementSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_37.Parent = GUI.CharacterMovementSection
GUI.TextLabel_37.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_37.BackgroundTransparency = 1
GUI.TextLabel_37.BorderSizePixel = 0
GUI.TextLabel_37.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_37.Font = Enum.Font.SourceSans
GUI.TextLabel_37.Text = "Movement"
GUI.TextLabel_37.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_37.TextSize = 14
GUI.TextLabel_37.TextWrapped = true
GUI.TextLabel_37.TextXAlignment = Enum.TextXAlignment.Left

GUI.WalkSpeedModCheckBox.Name = "WalkSpeedModCheckBox"
GUI.WalkSpeedModCheckBox.Parent = GUI.CharacterMovementSection
LoadCheckBox(GUI.WalkSpeedModCheckBox, "WalkSpeedMod")
GUI.WalkSpeedModCheckBox.BorderSizePixel = 0
GUI.WalkSpeedModCheckBox.Position = UDim2.new(0.05, 0, 0.1, 0)
GUI.WalkSpeedModCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.WalkSpeedModCheckBox.Font = Enum.Font.SourceSans
GUI.WalkSpeedModCheckBox.Text = ""
GUI.WalkSpeedModCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.WalkSpeedModCheckBox.TextSize = 14

GUI.TextLabel_38.Parent = GUI.CharacterMovementSection
GUI.TextLabel_38.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_38.BackgroundTransparency = 1
GUI.TextLabel_38.BorderSizePixel = 0
GUI.TextLabel_38.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_38.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_38.Font = Enum.Font.SourceSans
GUI.TextLabel_38.Text = "Walk speed Modifier"
GUI.TextLabel_38.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_38.TextSize = 14
GUI.TextLabel_38.TextWrapped = true
GUI.TextLabel_38.TextXAlignment = Enum.TextXAlignment.Left

GUI.WalkSpeedModSlider.Name = "WalkSpeedModSlider"
GUI.WalkSpeedModSlider.Parent = GUI.CharacterMovementSection
GUI.WalkSpeedModSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.WalkSpeedModSlider.BorderSizePixel = 0
GUI.WalkSpeedModSlider.Position = UDim2.new(0.1, 0, 0.175, 0)
GUI.WalkSpeedModSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.WalkSpeedModSlider.Font = Enum.Font.SourceSans
GUI.WalkSpeedModSlider.Text = ""
GUI.WalkSpeedModSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.WalkSpeedModSlider.TextSize = 14

GUI.WalkSpeedModSliderButton.Name = "WalkSpeedModSliderButton"
GUI.WalkSpeedModSliderButton.Parent = GUI.WalkSpeedModSlider
LoadMainColor(GUI.WalkSpeedModSliderButton, "Background")
GUI.WalkSpeedModSliderButton.BorderSizePixel = 0
GUI.WalkSpeedModSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.WalkSpeedModSliderButton.Font = Enum.Font.SourceSans
GUI.WalkSpeedModSliderButton.Text = ""
GUI.WalkSpeedModSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.WalkSpeedModSliderButton.TextSize = 14

GUI.WalkSpeedModAmount.Name = "WalkSpeedModAmount"
GUI.WalkSpeedModAmount.Parent = GUI.WalkSpeedModSlider
GUI.WalkSpeedModAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.WalkSpeedModAmount.BackgroundTransparency = 1
GUI.WalkSpeedModAmount.BorderSizePixel = 0
GUI.WalkSpeedModAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.WalkSpeedModAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.WalkSpeedModAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.WalkSpeedModAmount, GUI.WalkSpeedModSliderButton, "WalkSpeed")
GUI.WalkSpeedModAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.WalkSpeedModAmount.TextSize = 14

GUI.JumpPowerModCheckBox.Name = "JumpPowerModCheckBox"
GUI.JumpPowerModCheckBox.Parent = GUI.CharacterMovementSection
LoadCheckBox(GUI.JumpPowerModCheckBox, "JumpPowerMod")
GUI.JumpPowerModCheckBox.BorderSizePixel = 0
GUI.JumpPowerModCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.JumpPowerModCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.JumpPowerModCheckBox.Font = Enum.Font.SourceSans
GUI.JumpPowerModCheckBox.Text = ""
GUI.JumpPowerModCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.JumpPowerModCheckBox.TextSize = 14

GUI.TextLabel_39.Parent = GUI.CharacterMovementSection
GUI.TextLabel_39.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_39.BackgroundTransparency = 1
GUI.TextLabel_39.BorderSizePixel = 0
GUI.TextLabel_39.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_39.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_39.Font = Enum.Font.SourceSans
GUI.TextLabel_39.Text = "Jump power Modifier"
GUI.TextLabel_39.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_39.TextSize = 14
GUI.TextLabel_39.TextWrapped = true
GUI.TextLabel_39.TextXAlignment = Enum.TextXAlignment.Left

GUI.RunSpeedModSlider.Name = "RunSpeedModSlider"
GUI.RunSpeedModSlider.Parent = GUI.CharacterMovementSection
GUI.RunSpeedModSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.RunSpeedModSlider.BorderSizePixel = 0
GUI.RunSpeedModSlider.Position = UDim2.new(0.1, 0, 0.475, 0)
GUI.RunSpeedModSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.RunSpeedModSlider.Font = Enum.Font.SourceSans
GUI.RunSpeedModSlider.Text = ""
GUI.RunSpeedModSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.RunSpeedModSlider.TextSize = 14

GUI.RunSpeedModSliderButton.Name = "RunSpeedModSliderButton"
GUI.RunSpeedModSliderButton.Parent = GUI.RunSpeedModSlider
LoadMainColor(GUI.RunSpeedModSliderButton, "Background")
GUI.RunSpeedModSliderButton.BorderSizePixel = 0
GUI.RunSpeedModSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.RunSpeedModSliderButton.Font = Enum.Font.SourceSans
GUI.RunSpeedModSliderButton.Text = ""
GUI.RunSpeedModSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.RunSpeedModSliderButton.TextSize = 14

GUI.RunSpeedModAmount.Name = "RunSpeedModAmount"
GUI.RunSpeedModAmount.Parent = GUI.RunSpeedModSlider
GUI.RunSpeedModAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.RunSpeedModAmount.BackgroundTransparency = 1
GUI.RunSpeedModAmount.BorderSizePixel = 0
GUI.RunSpeedModAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.RunSpeedModAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.RunSpeedModAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.RunSpeedModAmount, GUI.RunSpeedModSliderButton, "RunSpeed")
GUI.RunSpeedModAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.RunSpeedModAmount.TextSize = 14

GUI.TextLabel_40.Parent = GUI.CharacterMovementSection
GUI.TextLabel_40.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_40.BackgroundTransparency = 1
GUI.TextLabel_40.BorderSizePixel = 0
GUI.TextLabel_40.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_40.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_40.Font = Enum.Font.SourceSans
GUI.TextLabel_40.Text = "Run Speed Modifier"
GUI.TextLabel_40.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_40.TextSize = 14
GUI.TextLabel_40.TextWrapped = true
GUI.TextLabel_40.TextXAlignment = Enum.TextXAlignment.Left

GUI.RunSpeedModCheckBox.Name = "WalkSpeedModCheckBox"
GUI.RunSpeedModCheckBox.Parent = GUI.CharacterMovementSection
GUI.RunSpeedModCheckBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.RunSpeedModCheckBox.BorderSizePixel = 0
GUI.RunSpeedModCheckBox.Position = UDim2.new(0.05, 0, 0.4, 0)
GUI.RunSpeedModCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.RunSpeedModCheckBox.Font = Enum.Font.SourceSans
GUI.RunSpeedModCheckBox.Text = ""
GUI.RunSpeedModCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.RunSpeedModCheckBox.TextSize = 14

GUI.CrouchSpeedModSlider.Name = "CrouchSpeedModSlider"
GUI.CrouchSpeedModSlider.Parent = GUI.CharacterMovementSection
GUI.CrouchSpeedModSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.CrouchSpeedModSlider.BorderSizePixel = 0
GUI.CrouchSpeedModSlider.Position = UDim2.new(0.1, 0, 0.625, 0)
GUI.CrouchSpeedModSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.CrouchSpeedModSlider.Font = Enum.Font.SourceSans
GUI.CrouchSpeedModSlider.Text = ""
GUI.CrouchSpeedModSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.CrouchSpeedModSlider.TextSize = 14

GUI.CrouchSpeedModSliderButton.Name = "CrouchSpeedModSliderButton"
GUI.CrouchSpeedModSliderButton.Parent = GUI.CrouchSpeedModSlider
LoadMainColor(GUI.CrouchSpeedModSliderButton, "Background")
GUI.CrouchSpeedModSliderButton.BorderSizePixel = 0
GUI.CrouchSpeedModSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.CrouchSpeedModSliderButton.Font = Enum.Font.SourceSans
GUI.CrouchSpeedModSliderButton.Text = ""
GUI.CrouchSpeedModSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.CrouchSpeedModSliderButton.TextSize = 14

GUI.CrouchSpeedModAmount.Name = "CrouchSpeedModAmount"
GUI.CrouchSpeedModAmount.Parent = GUI.CrouchSpeedModSlider
GUI.CrouchSpeedModAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.CrouchSpeedModAmount.BackgroundTransparency = 1
GUI.CrouchSpeedModAmount.BorderSizePixel = 0
GUI.CrouchSpeedModAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.CrouchSpeedModAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.CrouchSpeedModAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.CrouchSpeedModAmount, GUI.CrouchSpeedModSliderButton, "CrouchSpeed")
GUI.CrouchSpeedModAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.CrouchSpeedModAmount.TextSize = 14

GUI.JumpPowerModSlider.Name = "JumpPowerModSlider"
GUI.JumpPowerModSlider.Parent = GUI.CharacterMovementSection
GUI.JumpPowerModSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.JumpPowerModSlider.BorderSizePixel = 0
GUI.JumpPowerModSlider.Position = UDim2.new(0.1, 0, 0.325, 0)
GUI.JumpPowerModSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.JumpPowerModSlider.Font = Enum.Font.SourceSans
GUI.JumpPowerModSlider.Text = ""
GUI.JumpPowerModSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.JumpPowerModSlider.TextSize = 14

GUI.JumpPowerModSliderButton.Name = "JumpPowerModSliderButton"
GUI.JumpPowerModSliderButton.Parent = GUI.JumpPowerModSlider
LoadMainColor(GUI.JumpPowerModSliderButton, "Background")
GUI.JumpPowerModSliderButton.BorderSizePixel = 0
GUI.JumpPowerModSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.JumpPowerModSliderButton.Font = Enum.Font.SourceSans
GUI.JumpPowerModSliderButton.Text = ""
GUI.JumpPowerModSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.JumpPowerModSliderButton.TextSize = 14

GUI.JumpPowerModAmount.Name = "JumpPowerModAmount"
GUI.JumpPowerModAmount.Parent = GUI.JumpPowerModSlider
GUI.JumpPowerModAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.JumpPowerModAmount.BackgroundTransparency = 1
GUI.JumpPowerModAmount.BorderSizePixel = 0
GUI.JumpPowerModAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.JumpPowerModAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.JumpPowerModAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.JumpPowerModAmount, GUI.JumpPowerModSliderButton, "JumpPower")
GUI.JumpPowerModAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.JumpPowerModAmount.TextSize = 14

GUI.TextLabel_41.Parent = GUI.CharacterMovementSection
GUI.TextLabel_41.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_41.BackgroundTransparency = 1
GUI.TextLabel_41.BorderSizePixel = 0
GUI.TextLabel_41.Position = UDim2.new(0.125, 0, 0.55, 0)
GUI.TextLabel_41.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_41.Font = Enum.Font.SourceSans
GUI.TextLabel_41.Text = "Crouch Speed Modifier"
GUI.TextLabel_41.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_41.TextSize = 14
GUI.TextLabel_41.TextWrapped = true
GUI.TextLabel_41.TextXAlignment = Enum.TextXAlignment.Left

GUI.CrouchSpeedModCheckBox.Name = "CrouchSpeedModCheckBox"
GUI.CrouchSpeedModCheckBox.Parent = GUI.CharacterMovementSection
LoadCheckBox(GUI.CrouchSpeedModCheckBox, "CrouchSpeedMod")
GUI.CrouchSpeedModCheckBox.BorderSizePixel = 0
GUI.CrouchSpeedModCheckBox.Position = UDim2.new(0.05, 0, 0.55, 0)
GUI.CrouchSpeedModCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.CrouchSpeedModCheckBox.Font = Enum.Font.SourceSans
GUI.CrouchSpeedModCheckBox.Text = ""
GUI.CrouchSpeedModCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.CrouchSpeedModCheckBox.TextSize = 14

GUI.TextLabel_42.Parent = GUI.CharacterMovementSection
GUI.TextLabel_42.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_42.BackgroundTransparency = 1
GUI.TextLabel_42.BorderSizePixel = 0
GUI.TextLabel_42.Position = UDim2.new(0.125, 0, 0.699999988, 0)
GUI.TextLabel_42.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_42.Font = Enum.Font.SourceSans
GUI.TextLabel_42.Text = "Ignore Action Speed"
GUI.TextLabel_42.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_42.TextSize = 14
GUI.TextLabel_42.TextWrapped = true
GUI.TextLabel_42.TextXAlignment = Enum.TextXAlignment.Left

GUI.IgnoreActionSpeedCheckBox.Name = "IgnoreActionSpeedCheckBox"
GUI.IgnoreActionSpeedCheckBox.Parent = GUI.CharacterMovementSection
LoadCheckBox(GUI.IgnoreActionSpeedCheckBox, "IgnoreActionSpeed")
GUI.IgnoreActionSpeedCheckBox.BorderSizePixel = 0
GUI.IgnoreActionSpeedCheckBox.Position = UDim2.new(0.05, 0, 0.699999988, 0)
GUI.IgnoreActionSpeedCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.IgnoreActionSpeedCheckBox.Font = Enum.Font.SourceSans
GUI.IgnoreActionSpeedCheckBox.Text = ""
GUI.IgnoreActionSpeedCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.IgnoreActionSpeedCheckBox.TextSize = 14

GUI.MiscellaneousTab.Name = "MiscellaneousTab"
GUI.MiscellaneousTab.Parent = GUI.TabHolder
GUI.MiscellaneousTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.MiscellaneousTab.BackgroundTransparency = 1
GUI.MiscellaneousTab.BorderSizePixel = 0
GUI.MiscellaneousTab.Size = UDim2.new(1, 0, 1, 0)
GUI.MiscellaneousTab.Visible = false

GUI.MiscellaneousMainSection.Name = "MiscellaneousMainSection"
GUI.MiscellaneousMainSection.Parent = GUI.MiscellaneousTab
GUI.MiscellaneousMainSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.MiscellaneousMainSection, "Border")
GUI.MiscellaneousMainSection.BorderSizePixel = 2
GUI.MiscellaneousMainSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_43.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_43.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_43.BackgroundTransparency = 1
GUI.TextLabel_43.BorderSizePixel = 0
GUI.TextLabel_43.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_43.Font = Enum.Font.SourceSans
GUI.TextLabel_43.Text = "Miscellaneous"
GUI.TextLabel_43.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_43.TextSize = 14
GUI.TextLabel_43.TextWrapped = true
GUI.TextLabel_43.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_44.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_44.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_44.BackgroundTransparency = 1
GUI.TextLabel_44.BorderSizePixel = 0
GUI.TextLabel_44.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_44.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_44.Font = Enum.Font.SourceSans
GUI.TextLabel_44.Text = "Anime Run"
GUI.TextLabel_44.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_44.TextSize = 14
GUI.TextLabel_44.TextWrapped = true
GUI.TextLabel_44.TextXAlignment = Enum.TextXAlignment.Left

GUI.AnimeRunCheckBox.Name = "AnimeRunCheckBox"
GUI.AnimeRunCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AnimeRunCheckBox, "AnimeRun")
GUI.AnimeRunCheckBox.BorderSizePixel = 0
GUI.AnimeRunCheckBox.Position = UDim2.new(0.05, 0, 0.1, 0)
GUI.AnimeRunCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AnimeRunCheckBox.Font = Enum.Font.SourceSans
GUI.AnimeRunCheckBox.Text = ""
GUI.AnimeRunCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AnimeRunCheckBox.TextSize = 14

GUI.TextLabel_45.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_45.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_45.BackgroundTransparency = 1
GUI.TextLabel_45.BorderSizePixel = 0
GUI.TextLabel_45.Position = UDim2.new(0.125, 0, 0.175, 0)
GUI.TextLabel_45.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_45.Font = Enum.Font.SourceSans
GUI.TextLabel_45.Text = "Auto Cash"
GUI.TextLabel_45.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_45.TextSize = 14
GUI.TextLabel_45.TextWrapped = true
GUI.TextLabel_45.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoCashCheckBox.Name = "AutoCashCheckBox"
GUI.AutoCashCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AutoCashCheckBox, "AutoCash")
GUI.AutoCashCheckBox.BorderSizePixel = 0
GUI.AutoCashCheckBox.Position = UDim2.new(0.05, 0, 0.175, 0)
GUI.AutoCashCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoCashCheckBox.Font = Enum.Font.SourceSans
GUI.AutoCashCheckBox.Text = ""
GUI.AutoCashCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoCashCheckBox.TextSize = 14

GUI.TextLabel_46.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_46.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_46.BackgroundTransparency = 1
GUI.TextLabel_46.BorderSizePixel = 0
GUI.TextLabel_46.Position = UDim2.new(0.125, 0, 0.25, 0)
GUI.TextLabel_46.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_46.Font = Enum.Font.SourceSans
GUI.TextLabel_46.Text = "Anti AFK"
GUI.TextLabel_46.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_46.TextSize = 14
GUI.TextLabel_46.TextWrapped = true
GUI.TextLabel_46.TextXAlignment = Enum.TextXAlignment.Left

GUI.AntiAFKCheckBox.Name = "AntiAFKCheckBox"
GUI.AntiAFKCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AntiAFKCheckBox, "AntiAFK")
GUI.AntiAFKCheckBox.BorderSizePixel = 0
GUI.AntiAFKCheckBox.Position = UDim2.new(0.05, 0, 0.25, 0)
GUI.AntiAFKCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AntiAFKCheckBox.Font = Enum.Font.SourceSans
GUI.AntiAFKCheckBox.Text = ""
GUI.AntiAFKCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AntiAFKCheckBox.TextSize = 14

GUI.TextLabel_47.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_47.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_47.BackgroundTransparency = 1
GUI.TextLabel_47.BorderSizePixel = 0
GUI.TextLabel_47.Position = UDim2.new(0.125, 0, 0.325, 0)
GUI.TextLabel_47.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_47.Font = Enum.Font.SourceSans
GUI.TextLabel_47.Text = "Auto Lock"
GUI.TextLabel_47.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_47.TextSize = 14
GUI.TextLabel_47.TextWrapped = true
GUI.TextLabel_47.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoLockCheckBox.Name = "AutoLockCheckBox"
GUI.AutoLockCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AutoLockCheckBox, "AutoLock")
GUI.AutoLockCheckBox.BorderSizePixel = 0
GUI.AutoLockCheckBox.Position = UDim2.new(0.05, 0, 0.325, 0)
GUI.AutoLockCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoLockCheckBox.Font = Enum.Font.SourceSans
GUI.AutoLockCheckBox.Text = ""
GUI.AutoLockCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoLockCheckBox.TextSize = 14

GUI.AutoUnlockCheckBox.Name = "AutoUnlockCheckBox"
GUI.AutoUnlockCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AutoUnlockCheckBox, "AutoUnlock")
GUI.AutoUnlockCheckBox.BorderSizePixel = 0
GUI.AutoUnlockCheckBox.Position = UDim2.new(0.05, 0, 0.4, 0)
GUI.AutoUnlockCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoUnlockCheckBox.Font = Enum.Font.SourceSans
GUI.AutoUnlockCheckBox.Text = ""
GUI.AutoUnlockCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoUnlockCheckBox.TextSize = 14

GUI.TextLabel_48.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_48.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_48.BackgroundTransparency = 1
GUI.TextLabel_48.BorderSizePixel = 0
GUI.TextLabel_48.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_48.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_48.Font = Enum.Font.SourceSans
GUI.TextLabel_48.Text = "Auto Unlock"
GUI.TextLabel_48.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_48.TextSize = 14
GUI.TextLabel_48.TextWrapped = true
GUI.TextLabel_48.TextXAlignment = Enum.TextXAlignment.Left

GUI.AutoSortCheckBox.Name = "AutoSortCheckBox"
GUI.AutoSortCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.AutoSortCheckBox, "AutoSort")
GUI.AutoSortCheckBox.BorderSizePixel = 0
GUI.AutoSortCheckBox.Position = UDim2.new(0.05, 0, 0.475, 0)
GUI.AutoSortCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.AutoSortCheckBox.Font = Enum.Font.SourceSans
GUI.AutoSortCheckBox.Text = ""
GUI.AutoSortCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.AutoSortCheckBox.TextSize = 14

GUI.TextLabel_49.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_49.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_49.BackgroundTransparency = 1
GUI.TextLabel_49.BorderSizePixel = 0
GUI.TextLabel_49.Position = UDim2.new(0.125, 0, 0.475, 0)
GUI.TextLabel_49.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_49.Font = Enum.Font.SourceSans
GUI.TextLabel_49.Text = "Auto Sort"
GUI.TextLabel_49.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_49.TextSize = 14
GUI.TextLabel_49.TextWrapped = true
GUI.TextLabel_49.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_50.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_50.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_50.BackgroundTransparency = 1
GUI.TextLabel_50.BorderSizePixel = 0
GUI.TextLabel_50.Position = UDim2.new(0.125, 0, 0.55, 0)
GUI.TextLabel_50.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_50.Font = Enum.Font.SourceSans
GUI.TextLabel_50.Text = "Hide Groups"
GUI.TextLabel_50.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_50.TextSize = 14
GUI.TextLabel_50.TextWrapped = true
GUI.TextLabel_50.TextXAlignment = Enum.TextXAlignment.Left

GUI.HideGroupsCheckBox.Name = "HideGroupsCheckBox"
GUI.HideGroupsCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.HideGroupsCheckBox, "HideGroups")
GUI.HideGroupsCheckBox.BorderSizePixel = 0
GUI.HideGroupsCheckBox.Position = UDim2.new(0.05, 0, 0.55, 0)
GUI.HideGroupsCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.HideGroupsCheckBox.Font = Enum.Font.SourceSans
GUI.HideGroupsCheckBox.Text = ""
GUI.HideGroupsCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.HideGroupsCheckBox.TextSize = 14

GUI.TextLabel_51.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_51.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_51.BackgroundTransparency = 1
GUI.TextLabel_51.BorderSizePixel = 0
GUI.TextLabel_51.Position = UDim2.new(0.125, 0, 0.625, 0)
GUI.TextLabel_51.Rotation = 1
GUI.TextLabel_51.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_51.Font = Enum.Font.SourceSans
GUI.TextLabel_51.Text = "Mute Radios"
GUI.TextLabel_51.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_51.TextSize = 14
GUI.TextLabel_51.TextWrapped = true
GUI.TextLabel_51.TextXAlignment = Enum.TextXAlignment.Left

GUI.MuteRadiosCheckBox.Name = "MuteRadiosCheckBox"
GUI.MuteRadiosCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.MuteRadiosCheckBox, "MuteRadios")
GUI.MuteRadiosCheckBox.BorderSizePixel = 0
GUI.MuteRadiosCheckBox.Position = UDim2.new(0.05, 0, 0.625, 0)
GUI.MuteRadiosCheckBox.Rotation = 1
GUI.MuteRadiosCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.MuteRadiosCheckBox.Font = Enum.Font.SourceSans
GUI.MuteRadiosCheckBox.Text = ""
GUI.MuteRadiosCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.MuteRadiosCheckBox.TextSize = 14

GUI.TextLabel_52.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_52.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_52.BackgroundTransparency = 1
GUI.TextLabel_52.BorderSizePixel = 0
GUI.TextLabel_52.Position = UDim2.new(0.125, 0, 0.699999988, 0)
GUI.TextLabel_52.Rotation = 1
GUI.TextLabel_52.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_52.Font = Enum.Font.SourceSans
GUI.TextLabel_52.Text = "Hide Sprays"
GUI.TextLabel_52.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_52.TextSize = 14
GUI.TextLabel_52.TextWrapped = true
GUI.TextLabel_52.TextXAlignment = Enum.TextXAlignment.Left

GUI.HideSpraysCheckBox.Name = "HideSpraysCheckBox"
GUI.HideSpraysCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.HideSpraysCheckBox, "HideSprays")
GUI.HideSpraysCheckBox.BorderSizePixel = 0
GUI.HideSpraysCheckBox.Position = UDim2.new(0.05, 0, 0.699999988, 0)
GUI.HideSpraysCheckBox.Rotation = 1
GUI.HideSpraysCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.HideSpraysCheckBox.Font = Enum.Font.SourceSans
GUI.HideSpraysCheckBox.Text = ""
GUI.HideSpraysCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.HideSpraysCheckBox.TextSize = 14

GUI.TextLabel_53.Parent = GUI.MiscellaneousMainSection
GUI.TextLabel_53.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_53.BackgroundTransparency = 1
GUI.TextLabel_53.BorderSizePixel = 0
GUI.TextLabel_53.Position = UDim2.new(0.125, 0, 0.775, 0)
GUI.TextLabel_53.Rotation = 1
GUI.TextLabel_53.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_53.Font = Enum.Font.SourceSans
GUI.TextLabel_53.Text = "Hide TPer"
GUI.TextLabel_53.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_53.TextSize = 14
GUI.TextLabel_53.TextWrapped = true
GUI.TextLabel_53.TextXAlignment = Enum.TextXAlignment.Left

GUI.HideTPerCheckBox.Name = "HideTPerCheckBox"
GUI.HideTPerCheckBox.Parent = GUI.MiscellaneousMainSection
LoadCheckBox(GUI.HideTPerCheckBox, "HideTPer")
GUI.HideTPerCheckBox.BorderSizePixel = 0
GUI.HideTPerCheckBox.Position = UDim2.new(0.05, 0, 0.775, 0)
GUI.HideTPerCheckBox.Rotation = 1
GUI.HideTPerCheckBox.Size = UDim2.new(0, 15, 0, 15)
GUI.HideTPerCheckBox.Font = Enum.Font.SourceSans
GUI.HideTPerCheckBox.Text = ""
GUI.HideTPerCheckBox.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.HideTPerCheckBox.TextSize = 14

GUI.MiscellaneousSkinChangerSection.Name = "MiscellaneousSkinChangerSection"
GUI.MiscellaneousSkinChangerSection.Parent = GUI.MiscellaneousTab
GUI.MiscellaneousSkinChangerSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.MiscellaneousSkinChangerSection, "Border")
GUI.MiscellaneousSkinChangerSection.BorderSizePixel = 2
GUI.MiscellaneousSkinChangerSection.Position = UDim2.new(0.55, 0, 0, 0)
GUI.MiscellaneousSkinChangerSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_54.Parent = GUI.MiscellaneousSkinChangerSection
GUI.TextLabel_54.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_54.BackgroundTransparency = 1
GUI.TextLabel_54.BorderSizePixel = 0
GUI.TextLabel_54.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_54.Font = Enum.Font.SourceSans
GUI.TextLabel_54.Text = "Skin Changer"
GUI.TextLabel_54.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_54.TextSize = 14
GUI.TextLabel_54.TextWrapped = true
GUI.TextLabel_54.TextXAlignment = Enum.TextXAlignment.Left

GUI.WeaponSelectionFrame.Name = "WeaponSelectionFrame"
GUI.WeaponSelectionFrame.Parent = GUI.MiscellaneousSkinChangerSection
GUI.WeaponSelectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.WeaponSelectionFrame.BackgroundTransparency = 1
GUI.WeaponSelectionFrame.BorderSizePixel = 0
GUI.WeaponSelectionFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
GUI.WeaponSelectionFrame.Size = UDim2.new(0.4, 0, 0, 60)
GUI.WeaponSelectionFrame.Visible = false

GUI.GlockWeaponSelect.Name = "GlockWeaponSelect"
GUI.GlockWeaponSelect.Parent = GUI.WeaponSelectionFrame
GUI.GlockWeaponSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.GlockWeaponSelect.BackgroundTransparency = 1
GUI.GlockWeaponSelect.BorderSizePixel = 0
GUI.GlockWeaponSelect.Size = UDim2.new(1, 0, 0.25, 0)
GUI.GlockWeaponSelect.Font = Enum.Font.SourceSans
GUI.GlockWeaponSelect.Text = "Glock"
GUI.GlockWeaponSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.GlockWeaponSelect.TextSize = 14

GUI.SawedOffWeaponSelect.Name = "Sawed OffWeaponSelect"
GUI.SawedOffWeaponSelect.Parent = GUI.WeaponSelectionFrame
GUI.SawedOffWeaponSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SawedOffWeaponSelect.BackgroundTransparency = 1
GUI.SawedOffWeaponSelect.BorderSizePixel = 0
GUI.SawedOffWeaponSelect.Position = UDim2.new(0, 0, 0.5, 0)
GUI.SawedOffWeaponSelect.Size = UDim2.new(1, 0, 0.25, 0)
GUI.SawedOffWeaponSelect.Font = Enum.Font.SourceSans
GUI.SawedOffWeaponSelect.Text = "Sawed Off"
GUI.SawedOffWeaponSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.SawedOffWeaponSelect.TextSize = 14

GUI.ShottyWeaponSelect.Name = "ShottyWeaponSelect"
GUI.ShottyWeaponSelect.Parent = GUI.WeaponSelectionFrame
GUI.ShottyWeaponSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.ShottyWeaponSelect.BackgroundTransparency = 1
GUI.ShottyWeaponSelect.BorderSizePixel = 0
GUI.ShottyWeaponSelect.Position = UDim2.new(0, 0, 0.25, 0)
GUI.ShottyWeaponSelect.Size = UDim2.new(1, 0, 0.25, 0)
GUI.ShottyWeaponSelect.Font = Enum.Font.SourceSans
GUI.ShottyWeaponSelect.Text = "Shotty"
GUI.ShottyWeaponSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.ShottyWeaponSelect.TextSize = 14

GUI.UziWeaponSelect.Name = "UziWeaponSelect"
GUI.UziWeaponSelect.Parent = GUI.WeaponSelectionFrame
GUI.UziWeaponSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.UziWeaponSelect.BackgroundTransparency = 1
GUI.UziWeaponSelect.BorderSizePixel = 0
GUI.UziWeaponSelect.Position = UDim2.new(0, 0, 0.75, 0)
GUI.UziWeaponSelect.Size = UDim2.new(1, 0, 0.25, 0)
GUI.UziWeaponSelect.Font = Enum.Font.SourceSans
GUI.UziWeaponSelect.Text = "Uzi"
GUI.UziWeaponSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.UziWeaponSelect.TextSize = 14

GUI.WeaponSelectButton.Name = "WeaponSelectButton"
GUI.WeaponSelectButton.Parent = GUI.MiscellaneousSkinChangerSection
GUI.WeaponSelectButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.WeaponSelectButton.BorderSizePixel = 0
GUI.WeaponSelectButton.Position = UDim2.new(0.1, 0, 0.15, 0)
GUI.WeaponSelectButton.Size = UDim2.new(0.4, 0, 0, 15)
GUI.WeaponSelectButton.Font = Enum.Font.SourceSans
GUI.WeaponSelectButton.Text = "None"
GUI.WeaponSelectButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.WeaponSelectButton.TextSize = 14

GUI.TextLabel_55.Parent = GUI.MiscellaneousSkinChangerSection
GUI.TextLabel_55.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_55.BackgroundTransparency = 1
GUI.TextLabel_55.BorderSizePixel = 0
GUI.TextLabel_55.Position = UDim2.new(0.125, 0, 0.1, 0)
GUI.TextLabel_55.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_55.Font = Enum.Font.SourceSans
GUI.TextLabel_55.Text = "Weapon"
GUI.TextLabel_55.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_55.TextSize = 14
GUI.TextLabel_55.TextWrapped = true
GUI.TextLabel_55.TextXAlignment = Enum.TextXAlignment.Left

GUI.SkinSelectionFrame.Name = "SkinSelectionFrame"
GUI.SkinSelectionFrame.Parent = GUI.MiscellaneousSkinChangerSection
GUI.SkinSelectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SkinSelectionFrame.BackgroundTransparency = 1
GUI.SkinSelectionFrame.BorderSizePixel = 0
GUI.SkinSelectionFrame.Position = UDim2.new(0.1, 0, 0.55, 0)
GUI.SkinSelectionFrame.Size = UDim2.new(0.4, 0, 0, 100)
GUI.SkinSelectionFrame.Visible = false

GUI.DefaultSkinSelect.Name = "DefaultSkinSelect"
GUI.DefaultSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.DefaultSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.DefaultSkinSelect.BackgroundTransparency = 1
GUI.DefaultSkinSelect.BorderSizePixel = 0
GUI.DefaultSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.DefaultSkinSelect.Font = Enum.Font.SourceSans
GUI.DefaultSkinSelect.Text = "Default"
GUI.DefaultSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.DefaultSkinSelect.TextSize = 14

GUI.KawaiiSkinSelect.Name = "KawaiiSkinSelect"
GUI.KawaiiSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.KawaiiSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.KawaiiSkinSelect.BackgroundTransparency = 1
GUI.KawaiiSkinSelect.BorderSizePixel = 0
GUI.KawaiiSkinSelect.Position = UDim2.new(0, 0, 0.15, 0)
GUI.KawaiiSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.KawaiiSkinSelect.Font = Enum.Font.SourceSans
GUI.KawaiiSkinSelect.Text = "Kawaii"
GUI.KawaiiSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.KawaiiSkinSelect.TextSize = 14

GUI.SatanicSkinSelect.Name = "SatanicSkinSelect"
GUI.SatanicSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.SatanicSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SatanicSkinSelect.BackgroundTransparency = 1
GUI.SatanicSkinSelect.BorderSizePixel = 0
GUI.SatanicSkinSelect.Position = UDim2.new(0, 0, 0.3, 0)
GUI.SatanicSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.SatanicSkinSelect.Font = Enum.Font.SourceSans
GUI.SatanicSkinSelect.Text = "Satanic"
GUI.SatanicSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.SatanicSkinSelect.TextSize = 14

GUI.GoldSkinSelect.Name = "GoldSkinSelect"
GUI.GoldSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.GoldSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.GoldSkinSelect.BackgroundTransparency = 1
GUI.GoldSkinSelect.BorderSizePixel = 0
GUI.GoldSkinSelect.Position = UDim2.new(0, 0, 0.45, 0)
GUI.GoldSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.GoldSkinSelect.Font = Enum.Font.SourceSans
GUI.GoldSkinSelect.Text = "Gold"
GUI.GoldSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.GoldSkinSelect.TextSize = 14

GUI.NebulaSkinSelect.Name = "NebulaSkinSelect"
GUI.NebulaSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.NebulaSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.NebulaSkinSelect.BackgroundTransparency = 1
GUI.NebulaSkinSelect.BorderSizePixel = 0
GUI.NebulaSkinSelect.Position = UDim2.new(0, 0, 0.6, 0)
GUI.NebulaSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.NebulaSkinSelect.Font = Enum.Font.SourceSans
GUI.NebulaSkinSelect.Text = "Nebula"
GUI.NebulaSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.NebulaSkinSelect.TextSize = 14

GUI.NoobSkinSelect.Name = "NoobSkinSelect"
GUI.NoobSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.NoobSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.NoobSkinSelect.BackgroundTransparency = 1
GUI.NoobSkinSelect.BorderSizePixel = 0
GUI.NoobSkinSelect.Position = UDim2.new(0, 0, 0.75, 0)
GUI.NoobSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.NoobSkinSelect.Font = Enum.Font.SourceSans
GUI.NoobSkinSelect.Text = "Noob"
GUI.NoobSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.NoobSkinSelect.TextSize = 14

GUI.ToxicSkinSelect.Name = "ToxicSkinSelect"
GUI.ToxicSkinSelect.Parent = GUI.SkinSelectionFrame
GUI.ToxicSkinSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.ToxicSkinSelect.BackgroundTransparency = 1
GUI.ToxicSkinSelect.BorderSizePixel = 0
GUI.ToxicSkinSelect.Position = UDim2.new(0, 0, 0.9, 0)
GUI.ToxicSkinSelect.Size = UDim2.new(1, 0, 0.15, 0)
GUI.ToxicSkinSelect.Font = Enum.Font.SourceSans
GUI.ToxicSkinSelect.Text = "Toxic"
GUI.ToxicSkinSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.ToxicSkinSelect.TextSize = 14

GUI.SkinSelectButton.Name = "SkinSelectButton"
GUI.SkinSelectButton.Parent = GUI.MiscellaneousSkinChangerSection
GUI.SkinSelectButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.SkinSelectButton.BorderSizePixel = 0
GUI.SkinSelectButton.Position = UDim2.new(0.1, 0, 0.5, 0)
GUI.SkinSelectButton.Size = UDim2.new(0.4, 0, 0, 15)
GUI.SkinSelectButton.Font = Enum.Font.SourceSans
GUI.SkinSelectButton.Text = "None"
GUI.SkinSelectButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.SkinSelectButton.TextSize = 14

GUI.TextLabel_56.Parent = GUI.MiscellaneousSkinChangerSection
GUI.TextLabel_56.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_56.BackgroundTransparency = 1
GUI.TextLabel_56.BorderSizePixel = 0
GUI.TextLabel_56.Position = UDim2.new(0.125, 0, 0.45, 0)
GUI.TextLabel_56.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_56.Font = Enum.Font.SourceSans
GUI.TextLabel_56.Text = "Skin"
GUI.TextLabel_56.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_56.TextSize = 14
GUI.TextLabel_56.TextWrapped = true
GUI.TextLabel_56.TextXAlignment = Enum.TextXAlignment.Left

GUI.SkinPreviewFrame.BackgroundTransparency = 1
GUI.SkinPreviewFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SkinPreviewFrame.Name = "SkinPreviewFrame"
GUI.SkinPreviewFrame.Parent = GUI.MiscellaneousSkinChangerSection
GUI.SkinPreviewFrame.Position = UDim2.new(0.55, 0, 0.1, 0)

GUI.SkinSelectButton_2.Name = "SkinSelectButton"
GUI.SkinSelectButton_2.Parent = GUI.MiscellaneousSkinChangerSection
GUI.SkinSelectButton_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.SkinSelectButton_2.BorderSizePixel = 0
GUI.SkinSelectButton_2.Position = UDim2.new(0.55, 0, 0.5, 0)
GUI.SkinSelectButton_2.Size = UDim2.new(0.4, 0, 0, 15)
GUI.SkinSelectButton_2.Font = Enum.Font.SourceSans
GUI.SkinSelectButton_2.Text = "Apply"
GUI.SkinSelectButton_2.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.SkinSelectButton_2.TextSize = 14

GUI.SettingsTab.Name = "SettingsTab"
GUI.SettingsTab.Parent = GUI.TabHolder
GUI.SettingsTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SettingsTab.BackgroundTransparency = 1
GUI.SettingsTab.BorderSizePixel = 0
GUI.SettingsTab.Size = UDim2.new(1, 0, 1, 0)
GUI.SettingsTab.Visible = false

GUI.SettingsMainSection.Name = "SettingsMainSection"
GUI.SettingsMainSection.Parent = GUI.SettingsTab
GUI.SettingsMainSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.SettingsMainSection, "Border")
GUI.SettingsMainSection.BorderSizePixel = 2
GUI.SettingsMainSection.Size = UDim2.new(0.45, 0, 1, 0)

GUI.TextLabel_57.Parent = GUI.SettingsMainSection
GUI.TextLabel_57.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_57.BackgroundTransparency = 1
GUI.TextLabel_57.BorderSizePixel = 0
GUI.TextLabel_57.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_57.Font = Enum.Font.SourceSans
GUI.TextLabel_57.Text = "Settings"
GUI.TextLabel_57.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_57.TextSize = 14
GUI.TextLabel_57.TextWrapped = true
GUI.TextLabel_57.TextXAlignment = Enum.TextXAlignment.Left

GUI.PrefixKeyButton.Name = "PrefixKeyButton"
GUI.PrefixKeyButton.Parent = GUI.SettingsMainSection
GUI.PrefixKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.PrefixKeyButton.BorderSizePixel = 0
GUI.PrefixKeyButton.Position = UDim2.new(0.35, 0, 0.1, 0)
GUI.PrefixKeyButton.Size = UDim2.new(0, 75, 0, 15)
GUI.PrefixKeyButton.Font = Enum.Font.SourceSans
GUI.PrefixKeyButton.Text = Config["PrefixKey"]
GUI.PrefixKeyButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.PrefixKeyButton.TextSize = 14
GUI.PrefixKeyButton.TextWrapped = true

GUI.TextLabel_58.Parent = GUI.SettingsMainSection
GUI.TextLabel_58.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_58.BackgroundTransparency = 1
GUI.TextLabel_58.BorderSizePixel = 0
GUI.TextLabel_58.Position = UDim2.new(0.035, 0, 0.1, 0)
GUI.TextLabel_58.Size = UDim2.new(0.3, 0, 0.05, 0)
GUI.TextLabel_58.Font = Enum.Font.SourceSans
GUI.TextLabel_58.Text = "Prefix key"
GUI.TextLabel_58.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_58.TextSize = 14
GUI.TextLabel_58.TextWrapped = true
GUI.TextLabel_58.TextXAlignment = Enum.TextXAlignment.Left

GUI.TextLabel_59.Parent = GUI.SettingsMainSection
GUI.TextLabel_59.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_59.BackgroundTransparency = 1
GUI.TextLabel_59.BorderSizePixel = 0
GUI.TextLabel_59.Position = UDim2.new(0.035, 0, 0.175, 0)
GUI.TextLabel_59.Size = UDim2.new(0.3, 0, 0.05, 0)
GUI.TextLabel_59.Font = Enum.Font.SourceSans
GUI.TextLabel_59.Text = "Menu key"
GUI.TextLabel_59.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_59.TextSize = 14
GUI.TextLabel_59.TextWrapped = true
GUI.TextLabel_59.TextXAlignment = Enum.TextXAlignment.Left

GUI.MenuKeyButton.Name = "MenuKeyButton"
GUI.MenuKeyButton.Parent = GUI.SettingsMainSection
GUI.MenuKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.MenuKeyButton.BorderSizePixel = 0
GUI.MenuKeyButton.Position = UDim2.new(0.35, 0, 0.175, 0)
GUI.MenuKeyButton.Size = UDim2.new(0, 75, 0, 15)
GUI.MenuKeyButton.Font = Enum.Font.SourceSans
GUI.MenuKeyButton.Text = Config["MenuKey"]
GUI.MenuKeyButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.MenuKeyButton.TextSize = 14
GUI.MenuKeyButton.TextWrapped = true

GUI.TextLabel_62.Parent = GUI.SettingsMainSection
GUI.TextLabel_62.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_62.BackgroundTransparency = 1
GUI.TextLabel_62.BorderSizePixel = 0
GUI.TextLabel_62.Position = UDim2.new(0.035, 0, 0.25, 0)
GUI.TextLabel_62.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_62.Font = Enum.Font.SourceSans
GUI.TextLabel_62.Text = "Main Color"
GUI.TextLabel_62.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_62.TextSize = 14
GUI.TextLabel_62.TextWrapped = true
GUI.TextLabel_62.TextXAlignment = Enum.TextXAlignment.Left

GUI.MainColorButton.Name = "MainColorButton"
GUI.MainColorButton.Parent = GUI.SettingsMainSection
LoadColorButton(GUI.MainColorButton, "MainColor")
GUI.MainColorButton.BorderSizePixel = 0
GUI.MainColorButton.Position = UDim2.new(0.5, 0, 0.25, 0)
GUI.MainColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.MainColorButton.Font = Enum.Font.SourceSans
GUI.MainColorButton.Text = ""
GUI.MainColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.MainColorButton.TextSize = 14

GUI.TextColorButton.Name = "TextColorButton"
GUI.TextColorButton.Parent = GUI.SettingsMainSection
LoadColorButton(GUI.TextColorButton, "TextColor")
GUI.TextColorButton.BorderSizePixel = 0
GUI.TextColorButton.Position = UDim2.new(0.5, 0, 0.325, 0)
GUI.TextColorButton.Size = UDim2.new(0, 15, 0, 15)
GUI.TextColorButton.Font = Enum.Font.SourceSans
GUI.TextColorButton.Text = ""
GUI.TextColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.TextColorButton.TextSize = 14

GUI.TextLabel_60.Parent = GUI.SettingsMainSection
GUI.TextLabel_60.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_60.BackgroundTransparency = 1
GUI.TextLabel_60.BorderSizePixel = 0
GUI.TextLabel_60.Position = UDim2.new(0.035, 0, 0.325, 0)
GUI.TextLabel_60.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_60.Font = Enum.Font.SourceSans
GUI.TextLabel_60.Text = "Text Color"
GUI.TextLabel_60.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_60.TextSize = 14
GUI.TextLabel_60.TextWrapped = true
GUI.TextLabel_60.TextXAlignment = Enum.TextXAlignment.Left

GUI.RadioVolumeSlider.Name = "RadioVolumeSlider"
GUI.RadioVolumeSlider.Parent = GUI.SettingsMainSection
GUI.RadioVolumeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GUI.RadioVolumeSlider.BorderSizePixel = 0
GUI.RadioVolumeSlider.Position = UDim2.new(0.1, 0, 0.45, 0)
GUI.RadioVolumeSlider.Size = UDim2.new(0.5, 0, 0, 15)
GUI.RadioVolumeSlider.Font = Enum.Font.SourceSans
GUI.RadioVolumeSlider.Text = ""
GUI.RadioVolumeSlider.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.RadioVolumeSlider.TextSize = 14

GUI.RadioVolumeSliderButton.Name = "RadioVolumeSliderButton"
GUI.RadioVolumeSliderButton.Parent = GUI.RadioVolumeSlider
LoadMainColor(GUI.RadioVolumeSliderButton, "Background")
GUI.RadioVolumeSliderButton.BorderSizePixel = 0
GUI.RadioVolumeSliderButton.Position = UDim2.new(0.1, 0, 0, 0)
GUI.RadioVolumeSliderButton.Size = UDim2.new(0.05, 0, 1, 0)
GUI.RadioVolumeSliderButton.Font = Enum.Font.SourceSans
GUI.RadioVolumeSliderButton.Text = ""
GUI.RadioVolumeSliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GUI.RadioVolumeSliderButton.TextSize = 14

GUI.RadioVolumeAmount.Name = "RadioVolumeAmount"
GUI.RadioVolumeAmount.Parent = GUI.RadioVolumeSlider
GUI.RadioVolumeAmount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.RadioVolumeAmount.BackgroundTransparency = 1
GUI.RadioVolumeAmount.BorderSizePixel = 0
GUI.RadioVolumeAmount.Position = UDim2.new(0.25, 0, 0, 0)
GUI.RadioVolumeAmount.Size = UDim2.new(0.5, 0, 1, 0)
GUI.RadioVolumeAmount.Font = Enum.Font.SourceSans
LoadSlider(GUI.RadioVolumeAmount, GUI.RadioVolumeSliderButton, "RadioVolume")
GUI.RadioVolumeAmount.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.RadioVolumeAmount.TextSize = 14

GUI.TextLabel_61.Parent = GUI.SettingsMainSection
GUI.TextLabel_61.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_61.BackgroundTransparency = 1
GUI.TextLabel_61.BorderSizePixel = 0
GUI.TextLabel_61.Position = UDim2.new(0.125, 0, 0.4, 0)
GUI.TextLabel_61.Size = UDim2.new(0.5, 0, 0.05, 0)
GUI.TextLabel_61.Font = Enum.Font.SourceSans
GUI.TextLabel_61.Text = "Radio Volume"
GUI.TextLabel_61.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_61.TextSize = 14
GUI.TextLabel_61.TextWrapped = true
GUI.TextLabel_61.TextXAlignment = Enum.TextXAlignment.Left

GUI.UICorner_2.CornerRadius = UDim.new(0.05, 0)
GUI.UICorner_2.Parent = GUI.MainFrame

GUI.OthersFrame.Name = "OthersFrame"
GUI.OthersFrame.Parent = GUI.Identification
GUI.OthersFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.OthersFrame.BackgroundTransparency = 1
GUI.OthersFrame.BorderSizePixel = 0
GUI.OthersFrame.Position = UDim2.new(0, 0, -0.1, 0)
GUI.OthersFrame.Size = UDim2.new(1, 0, 1.1, 0)

GUI.WatermarkFrame.Name = "WatermarkFrame"
GUI.WatermarkFrame.Parent = GUI.OthersFrame
GUI.WatermarkFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
GUI.WatermarkFrame.BackgroundTransparency = 0.3
LoadMainColor(GUI.WatermarkFrame, "Border")
GUI.WatermarkFrame.Position = UDim2.new(0, 100, 0, 45)
GUI.WatermarkFrame.Size = UDim2.new(0, 250, 0, 20)

GUI.WatermarkDataLabel.Name = "WatermarkDataLabel"
GUI.WatermarkDataLabel.Parent = GUI.WatermarkFrame
GUI.WatermarkDataLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.WatermarkDataLabel.BackgroundTransparency = 1
GUI.WatermarkDataLabel.BorderSizePixel = 0
GUI.WatermarkDataLabel.Position = UDim2.new(0.025, 0, 0, 0)
GUI.WatermarkDataLabel.Size = UDim2.new(0.9, 0, 1, 0)
GUI.WatermarkDataLabel.Font = Enum.Font.SourceSansSemibold
GUI.WatermarkDataLabel.Text = "Identification | Game Name | FPS: 0 | Ping: 0"
GUI.WatermarkDataLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.WatermarkDataLabel.TextSize = 12
GUI.WatermarkDataLabel.TextWrapped = true
GUI.WatermarkDataLabel.TextXAlignment = Enum.TextXAlignment.Left

GUI.StatesFrame.Name = "StatesFrame"
GUI.StatesFrame.Parent = GUI.OthersFrame
GUI.StatesFrame.Active = true
GUI.StatesFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.StatesFrame.BackgroundTransparency = 0.3
LoadMainColor(GUI.StatesFrame, "Border")
GUI.StatesFrame.BorderSizePixel = 2
GUI.StatesFrame.Position = UDim2.new(0.005, 0, 0.15, 0)
GUI.StatesFrame.Size = UDim2.new(0, 200, 0, 230)
GUI.StatesFrame.Visible = Config["States"]
GUI.StatesFrame.Draggable = true

GUI.StatesTopBar.Name = "StatesTopBar"
GUI.StatesTopBar.Parent = GUI.StatesFrame
GUI.StatesTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GUI.StatesTopBar.BorderSizePixel = 0
GUI.StatesTopBar.Size = UDim2.new(1, 0, 0.1, 0)

GUI.StatesTitle.Name = "StatesTitle"
GUI.StatesTitle.Parent = GUI.StatesTopBar
GUI.StatesTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.StatesTitle.BackgroundTransparency = 1
GUI.StatesTitle.BorderSizePixel = 0
GUI.StatesTitle.Size = UDim2.new(1, 0, 1, 0)
GUI.StatesTitle.Font = Enum.Font.SourceSansLight
GUI.StatesTitle.Text = "States"
GUI.StatesTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.StatesTitle.TextSize = 20
GUI.StatesTitle.TextWrapped = true

GUI.StatesHolderFrame.Name = "StatesHolderFrame"
GUI.StatesHolderFrame.Parent = GUI.StatesFrame
GUI.StatesHolderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.StatesHolderFrame, "Border")
GUI.StatesHolderFrame.BorderSizePixel = 2
GUI.StatesHolderFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
GUI.StatesHolderFrame.Size = UDim2.new(0.9, 0, 0.8, 0)

GUI.CurrentTargetLabel.Name = "CurrentTargetLabel"
GUI.CurrentTargetLabel.Parent = GUI.StatesHolderFrame
GUI.CurrentTargetLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.CurrentTargetLabel.BackgroundTransparency = 1
GUI.CurrentTargetLabel.BorderSizePixel = 0
GUI.CurrentTargetLabel.Size = UDim2.new(1, 0, 0.1, 0)
GUI.CurrentTargetLabel.Font = Enum.Font.SourceSans
GUI.CurrentTargetLabel.Text = "Current Target: nil"
GUI.CurrentTargetLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.CurrentTargetLabel.TextScaled = true
GUI.CurrentTargetLabel.TextSize = 14
GUI.CurrentTargetLabel.TextWrapped = true

GUI.AimbottingLabel.Name = "AimbottingLabel"
GUI.AimbottingLabel.Parent = GUI.StatesHolderFrame
GUI.AimbottingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.AimbottingLabel.BackgroundTransparency = 1
GUI.AimbottingLabel.BorderSizePixel = 0
GUI.AimbottingLabel.Size = UDim2.new(1, 0, 0.1, 0)
GUI.AimbottingLabel.Position = UDim2.new(0, 0, 0.1, 0)
GUI.AimbottingLabel.Font = Enum.Font.SourceSans
GUI.AimbottingLabel.Text = "Aimbot: " .. tostring(Aimbot)
GUI.AimbottingLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.AimbottingLabel.TextScaled = true
GUI.AimbottingLabel.TextSize = 14
GUI.AimbottingLabel.TextWrapped = true

GUI.NoclippingLabel.Name = "NoclippingLabel"
GUI.NoclippingLabel.Parent = GUI.StatesHolderFrame
GUI.NoclippingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.NoclippingLabel.BackgroundTransparency = 1
GUI.NoclippingLabel.BorderSizePixel = 0
GUI.NoclippingLabel.Size = UDim2.new(1, 0, 0.1, 0)
GUI.NoclippingLabel.Position = UDim2.new(0, 0, 0.2, 0)
GUI.NoclippingLabel.Font = Enum.Font.SourceSans
GUI.NoclippingLabel.Text = "Noclip: " .. tostring(Noclip)
GUI.NoclippingLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.NoclippingLabel.TextScaled = true
GUI.NoclippingLabel.TextSize = 14
GUI.NoclippingLabel.TextWrapped = true

GUI.HairFrame.Name = "HairFrame"
GUI.HairFrame.Parent = GUI.OthersFrame
GUI.HairFrame.Active = true
GUI.HairFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.HairFrame.BackgroundTransparency = 0.3
LoadMainColor(GUI.HairFrame, "Border")
GUI.HairFrame.BorderSizePixel = 2
GUI.HairFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
GUI.HairFrame.Size = UDim2.new(0, 505, 0, 290)
GUI.HairFrame.Visible = false
GUI.HairFrame.Draggable = true

GUI.HairFrameTopBar.Name = "HairFrameTopBar"
GUI.HairFrameTopBar.Parent = GUI.HairFrame
GUI.HairFrameTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GUI.HairFrameTopBar.BorderSizePixel = 0
GUI.HairFrameTopBar.Size = UDim2.new(1, 0, 0.1, 0)

GUI.HairFrameTitle.Name = "HairFrameTitle"
GUI.HairFrameTitle.Parent = GUI.HairFrameTopBar
GUI.HairFrameTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HairFrameTitle.BackgroundTransparency = 1
GUI.HairFrameTitle.BorderSizePixel = 0
GUI.HairFrameTitle.Size = UDim2.new(1, 0, 1, 0)
GUI.HairFrameTitle.Font = Enum.Font.SourceSansLight
GUI.HairFrameTitle.Text = "Hair Colors"
GUI.HairFrameTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.HairFrameTitle.TextSize = 20
GUI.HairFrameTitle.TextWrapped = true

GUI.HairFrameCloseButton.Name = "HairFrameCloseButton"
GUI.HairFrameCloseButton.Parent = GUI.HairFrameTopBar
GUI.HairFrameCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HairFrameCloseButton.BackgroundTransparency = 1
GUI.HairFrameCloseButton.BorderSizePixel = 0
GUI.HairFrameCloseButton.Position = UDim2.new(0.94, 0, 0, 0)
GUI.HairFrameCloseButton.Size = UDim2.new(0.06, 0, 1, 0)
GUI.HairFrameCloseButton.Font = Enum.Font.SourceSans
GUI.HairFrameCloseButton.Text = "X"
GUI.HairFrameCloseButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.HairFrameCloseButton.TextScaled = true
GUI.HairFrameCloseButton.TextSize = 14
GUI.HairFrameCloseButton.TextWrapped = true

GUI.HairHolderFrame.Name = "HairHolderFrame"
GUI.HairHolderFrame.Parent = GUI.HairFrame
GUI.HairHolderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.HairHolderFrame, "Border")
GUI.HairHolderFrame.BorderSizePixel = 2
GUI.HairHolderFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
GUI.HairHolderFrame.Size = UDim2.new(0.9, 0, 0.8, 0)

GUI.HairHatsHolder.Name = "HairHatsHolder"
GUI.HairHatsHolder.Parent = GUI.HairHolderFrame
GUI.HairHatsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HairHatsHolder.BackgroundTransparency = 1
GUI.HairHatsHolder.BorderSizePixel = 0
GUI.HairHatsHolder.Size = UDim2.new(0.2, 0, 1, 0)

GUI.TemplateHairSelect.Name = "TemplateHairSelect"
GUI.TemplateHairSelect.Parent = GUI.HairHatsHolder
GUI.TemplateHairSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TemplateHairSelect.BackgroundTransparency = 1
GUI.TemplateHairSelect.BorderSizePixel = 0
GUI.TemplateHairSelect.Size = UDim2.new(1, 0, 0.1, 0)
GUI.TemplateHairSelect.Font = Enum.Font.SourceSans
GUI.TemplateHairSelect.Text = "Template Hair"
GUI.TemplateHairSelect.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TemplateHairSelect.TextSize = 14
GUI.TemplateHairSelect.Visible = false

GUI.UIListLayout.Parent = GUI.HairHatsHolder
GUI.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

GUI.HairColorsHolder.Name = "HairColorsHolder"
GUI.HairColorsHolder.Parent = GUI.HairHolderFrame
GUI.HairColorsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HairColorsHolder.BackgroundTransparency = 1
GUI.HairColorsHolder.BorderSizePixel = 0
GUI.HairColorsHolder.Position = UDim2.new(0.2, 0, 0.0450000018, 0)
GUI.HairColorsHolder.Size = UDim2.new(0.55, 0, 0.9, 0)

GUI.UIGridLayout_2.Parent = GUI.HairColorsHolder
GUI.UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
GUI.UIGridLayout_2.CellSize = UDim2.new(0, 37, 0, 37)

GUI.HairScriptsHolder.Name = "HairScriptsHolder"
GUI.HairScriptsHolder.Parent = GUI.HairHolderFrame
GUI.HairScriptsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.HairScriptsHolder.BackgroundTransparency = 1
GUI.HairScriptsHolder.BorderSizePixel = 0
GUI.HairScriptsHolder.Position = UDim2.new(0.754999995, 0, 0, 0)
GUI.HairScriptsHolder.Size = UDim2.new(0.245000005, 0, 1, 0)

GUI.UIListLayout_2.Parent = GUI.HairScriptsHolder
GUI.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

GUI.SequenceModeButton.Name = "SequenceModeButton"
GUI.SequenceModeButton.Parent = GUI.HairScriptsHolder
GUI.SequenceModeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.SequenceModeButton.BackgroundTransparency = 1
GUI.SequenceModeButton.BorderSizePixel = 0
GUI.SequenceModeButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.SequenceModeButton.Font = Enum.Font.SourceSans
GUI.SequenceModeButton.Text = "Sequence [Off]"
GUI.SequenceModeButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.SequenceModeButton.TextSize = 14

GUI.RandomColorsModeButton.Name = "RandomColorsModeButton"
GUI.RandomColorsModeButton.Parent = GUI.HairScriptsHolder
GUI.RandomColorsModeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.RandomColorsModeButton.BackgroundTransparency = 1
GUI.RandomColorsModeButton.BorderSizePixel = 0
GUI.RandomColorsModeButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.RandomColorsModeButton.Font = Enum.Font.SourceSans
GUI.RandomColorsModeButton.Text = "Random Colors [Off]"
GUI.RandomColorsModeButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.RandomColorsModeButton.TextSize = 14

GUI.BuildMenuFrame.Name = "BuildMenuFrame"
GUI.BuildMenuFrame.Parent = GUI.OthersFrame
GUI.BuildMenuFrame.Active = true
GUI.BuildMenuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GUI.BuildMenuFrame.BackgroundTransparency = 0.3
LoadMainColor(GUI.BuildMenuFrame, "Border")
GUI.BuildMenuFrame.BorderSizePixel = 2
GUI.BuildMenuFrame.Position = UDim2.new(0.25, 0, 0.15, 0)
GUI.BuildMenuFrame.Size = UDim2.new(0, 505, 0, 290)
GUI.BuildMenuFrame.Visible = false
GUI.BuildMenuFrame.Draggable = true

GUI.BuildMenuFrameTopBar.Name = "BuildMenuFrameTopBar"
GUI.BuildMenuFrameTopBar.Parent = GUI.BuildMenuFrame
GUI.BuildMenuFrameTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GUI.BuildMenuFrameTopBar.BorderSizePixel = 0
GUI.BuildMenuFrameTopBar.Size = UDim2.new(1, 0, 0.1, 0)

GUI.BuildMenuFrameTitle.Name = "BuildMenuFrameTitle"
GUI.BuildMenuFrameTitle.Parent = GUI.BuildMenuFrameTopBar
GUI.BuildMenuFrameTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuFrameTitle.BackgroundTransparency = 1
GUI.BuildMenuFrameTitle.BorderSizePixel = 0
GUI.BuildMenuFrameTitle.Size = UDim2.new(1, 0, 1, 0)
GUI.BuildMenuFrameTitle.Font = Enum.Font.SourceSansLight
GUI.BuildMenuFrameTitle.Text = "Build Menu"
GUI.BuildMenuFrameTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuFrameTitle.TextSize = 20
GUI.BuildMenuFrameTitle.TextWrapped = true

GUI.BuildMenuFrameCloseButton.Name = "BuildMenuFrameCloseButton"
GUI.BuildMenuFrameCloseButton.Parent = GUI.BuildMenuFrameTopBar
GUI.BuildMenuFrameCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuFrameCloseButton.BackgroundTransparency = 1
GUI.BuildMenuFrameCloseButton.BorderSizePixel = 0
GUI.BuildMenuFrameCloseButton.Position = UDim2.new(0.94, 0, 0, 0)
GUI.BuildMenuFrameCloseButton.Size = UDim2.new(0.06, 0, 1, 0)
GUI.BuildMenuFrameCloseButton.Font = Enum.Font.SourceSans
GUI.BuildMenuFrameCloseButton.Text = "X"
GUI.BuildMenuFrameCloseButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuFrameCloseButton.TextScaled = true
GUI.BuildMenuFrameCloseButton.TextSize = 14
GUI.BuildMenuFrameCloseButton.TextWrapped = true

GUI.BuildMenuHolderFrame.Name = "BuildMenuHolderFrame"
GUI.BuildMenuHolderFrame.Parent = GUI.BuildMenuFrame
GUI.BuildMenuHolderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadMainColor(GUI.BuildMenuHolderFrame, "Border")
GUI.BuildMenuHolderFrame.BorderSizePixel = 2
GUI.BuildMenuHolderFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
GUI.BuildMenuHolderFrame.Size = UDim2.new(0.9, 0, 0.8, 0)

GUI.BuildMenuUnanchoredHolder.Name = "BuildMenuUnanchoredHolder"
GUI.BuildMenuUnanchoredHolder.Parent = GUI.BuildMenuHolderFrame
GUI.BuildMenuUnanchoredHolder.Active = true
GUI.BuildMenuUnanchoredHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuUnanchoredHolder.BackgroundTransparency = 1
GUI.BuildMenuUnanchoredHolder.BorderSizePixel = 0
GUI.BuildMenuUnanchoredHolder.Size = UDim2.new(0.2, 0, 1, 0)
GUI.BuildMenuUnanchoredHolder.CanvasSize = UDim2.new(0, 0, 10, 0)
GUI.BuildMenuUnanchoredHolder.ScrollBarThickness = 4

GUI.TemplateUnanchoredButton.Name = "TemplateUnanchoredButton"
GUI.TemplateUnanchoredButton.Parent = GUI.BuildMenuUnanchoredHolder
GUI.TemplateUnanchoredButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TemplateUnanchoredButton.BackgroundTransparency = 1
GUI.TemplateUnanchoredButton.BorderSizePixel = 0
GUI.TemplateUnanchoredButton.Size = UDim2.new(1, 0, 0.01, 0)
GUI.TemplateUnanchoredButton.Visible = false
GUI.TemplateUnanchoredButton.Font = Enum.Font.SourceSans
GUI.TemplateUnanchoredButton.Text = "Template"
GUI.TemplateUnanchoredButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TemplateUnanchoredButton.TextSize = 14

GUI.UIListLayout_3.Parent = GUI.BuildMenuUnanchoredHolder
GUI.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

GUI.BuildMenuPreBuiltSection.Name = "BuildMenuPreBuiltSection"
GUI.BuildMenuPreBuiltSection.Parent = GUI.BuildMenuHolderFrame
GUI.BuildMenuPreBuiltSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuPreBuiltSection.BackgroundTransparency = 1
GUI.BuildMenuPreBuiltSection.BorderSizePixel = 0
GUI.BuildMenuPreBuiltSection.Position = UDim2.new(0.2, 0, 0, 0)
GUI.BuildMenuPreBuiltSection.Size = UDim2.new(0.2, 0, 1, 0)

GUI.BuildMenuSwastikaButton.Name = "BuildMenuSwastikaButton"
GUI.BuildMenuSwastikaButton.Parent = GUI.BuildMenuPreBuiltSection
GUI.BuildMenuSwastikaButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuSwastikaButton.BackgroundTransparency = 1
GUI.BuildMenuSwastikaButton.BorderSizePixel = 0
GUI.BuildMenuSwastikaButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.BuildMenuSwastikaButton.Font = Enum.Font.SourceSans
GUI.BuildMenuSwastikaButton.Text = "Swastika"
GUI.BuildMenuSwastikaButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuSwastikaButton.TextSize = 14

GUI.UIListLayout_4.Parent = GUI.BuildMenuPreBuiltSection
GUI.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

GUI.BuildMenuInvertedCrossButton.Name = "BuildMenuInvertedCrossButton"
GUI.BuildMenuInvertedCrossButton.Parent = GUI.BuildMenuPreBuiltSection
GUI.BuildMenuInvertedCrossButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuInvertedCrossButton.BackgroundTransparency = 1
GUI.BuildMenuInvertedCrossButton.BorderSizePixel = 0
GUI.BuildMenuInvertedCrossButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.BuildMenuInvertedCrossButton.Font = Enum.Font.SourceSans
GUI.BuildMenuInvertedCrossButton.Text = "Inverted Cross"
GUI.BuildMenuInvertedCrossButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuInvertedCrossButton.TextSize = 14

GUI.BuildMenuHutButton.Name = "BuildMenuHutButton"
GUI.BuildMenuHutButton.Parent = GUI.BuildMenuPreBuiltSection
GUI.BuildMenuHutButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuHutButton.BackgroundTransparency = 1
GUI.BuildMenuHutButton.BorderSizePixel = 0
GUI.BuildMenuHutButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.BuildMenuHutButton.Font = Enum.Font.SourceSans
GUI.BuildMenuHutButton.Text = "Hut"
GUI.BuildMenuHutButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuHutButton.TextSize = 14

GUI.BuildMenuSkateboardButton.Name = "BuildMenuSkateboardButton"
GUI.BuildMenuSkateboardButton.Parent = GUI.BuildMenuPreBuiltSection
GUI.BuildMenuSkateboardButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuSkateboardButton.BackgroundTransparency = 1
GUI.BuildMenuSkateboardButton.BorderSizePixel = 0
GUI.BuildMenuSkateboardButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.BuildMenuSkateboardButton.Font = Enum.Font.SourceSans
GUI.BuildMenuSkateboardButton.Text = "Skateboard"
GUI.BuildMenuSkateboardButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuSkateboardButton.TextSize = 14

GUI.BuildMenuArmorButton.Name = "BuildMenuArmorButton"
GUI.BuildMenuArmorButton.Parent = GUI.BuildMenuPreBuiltSection
GUI.BuildMenuArmorButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuArmorButton.BackgroundTransparency = 1
GUI.BuildMenuArmorButton.BorderSizePixel = 0
GUI.BuildMenuArmorButton.Size = UDim2.new(1, 0, 0.1, 0)
GUI.BuildMenuArmorButton.Font = Enum.Font.SourceSans
GUI.BuildMenuArmorButton.Text = "Armor"
GUI.BuildMenuArmorButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuArmorButton.TextSize = 14

GUI.BuildMenuPropertiesSection.Name = "BuildMenuPropertiesSection"
GUI.BuildMenuPropertiesSection.Parent = GUI.BuildMenuHolderFrame
GUI.BuildMenuPropertiesSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuPropertiesSection.BackgroundTransparency = 1
GUI.BuildMenuPropertiesSection.BorderSizePixel = 0
GUI.BuildMenuPropertiesSection.Position = UDim2.new(0.4, 0, 0, 0)
GUI.BuildMenuPropertiesSection.Size = UDim2.new(0.6, 0, 1, 0)

GUI.TextLabel_63.Parent = GUI.BuildMenuPropertiesSection
GUI.TextLabel_63.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_63.BackgroundTransparency = 1
GUI.TextLabel_63.Position = UDim2.new(0, 90, 0, 30)
GUI.TextLabel_63.Size = UDim2.new(0, 30, 0, 30)
GUI.TextLabel_63.Font = Enum.Font.SourceSans
GUI.TextLabel_63.Text = "X"
GUI.TextLabel_63.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_63.TextScaled = true
GUI.TextLabel_63.TextSize = 14
GUI.TextLabel_63.TextWrapped = true

GUI.TextLabel_64.Parent = GUI.BuildMenuPropertiesSection
GUI.TextLabel_64.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_64.BackgroundTransparency = 1
GUI.TextLabel_64.Position = UDim2.new(0, 120, 0, 30)
GUI.TextLabel_64.Size = UDim2.new(0, 30, 0, 30)
GUI.TextLabel_64.Font = Enum.Font.SourceSans
GUI.TextLabel_64.Text = "Y"
GUI.TextLabel_64.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_64.TextScaled = true
GUI.TextLabel_64.TextSize = 14
GUI.TextLabel_64.TextWrapped = true

GUI.TextLabel_65.Parent = GUI.BuildMenuPropertiesSection
GUI.TextLabel_65.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_65.BackgroundTransparency = 1
GUI.TextLabel_65.Position = UDim2.new(0, 150, 0, 30)
GUI.TextLabel_65.Size = UDim2.new(0, 30, 0, 30)
GUI.TextLabel_65.Font = Enum.Font.SourceSans
GUI.TextLabel_65.Text = "Z"
GUI.TextLabel_65.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.TextLabel_65.TextScaled = true
GUI.TextLabel_65.TextSize = 14
GUI.TextLabel_65.TextWrapped = true

GUI.BuildMenuXPositionBox.Name = "BuildMenuXPositionBox"
GUI.BuildMenuXPositionBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuXPositionBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuXPositionBox.BackgroundTransparency = 1
GUI.BuildMenuXPositionBox.BorderSizePixel = 0
GUI.BuildMenuXPositionBox.Position = UDim2.new(0, 90, 0, 60)
GUI.BuildMenuXPositionBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuXPositionBox.Font = Enum.Font.SourceSans
GUI.BuildMenuXPositionBox.Text = "0"
GUI.BuildMenuXPositionBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuXPositionBox.TextSize = 12
GUI.BuildMenuXPositionBox.TextWrapped = true

GUI.BuildMenuYPositionBox.Name = "BuildMenuYPositionBox"
GUI.BuildMenuYPositionBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuYPositionBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuYPositionBox.BackgroundTransparency = 1
GUI.BuildMenuYPositionBox.BorderSizePixel = 0
GUI.BuildMenuYPositionBox.Position = UDim2.new(0, 120, 0, 60)
GUI.BuildMenuYPositionBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuYPositionBox.Font = Enum.Font.SourceSans
GUI.BuildMenuYPositionBox.Text = "0"
GUI.BuildMenuYPositionBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuYPositionBox.TextSize = 12
GUI.BuildMenuYPositionBox.TextWrapped = true

GUI.BuildMenuZPositionBox.Name = "BuildMenuZPositionBox"
GUI.BuildMenuZPositionBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuZPositionBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuZPositionBox.BackgroundTransparency = 1
GUI.BuildMenuZPositionBox.BorderSizePixel = 0
GUI.BuildMenuZPositionBox.Position = UDim2.new(0, 150, 0, 60)
GUI.BuildMenuZPositionBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuZPositionBox.Font = Enum.Font.SourceSans
GUI.BuildMenuZPositionBox.Text = "0"
GUI.BuildMenuZPositionBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuZPositionBox.TextSize = 12
GUI.BuildMenuZPositionBox.TextWrapped = true

GUI.TextLabel_66.Parent = GUI.BuildMenuPropertiesSection
GUI.TextLabel_66.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_66.BackgroundTransparency = 1
GUI.TextLabel_66.BorderSizePixel = 0
GUI.TextLabel_66.Position = UDim2.new(0, 0, 0, 60)
GUI.TextLabel_66.Size = UDim2.new(0, 90, 0, 30)
GUI.TextLabel_66.Font = Enum.Font.SourceSans
GUI.TextLabel_66.Text = "Position"
GUI.TextLabel_66.TextColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_66.TextSize = 16

GUI.TextLabel_67.Parent = GUI.BuildMenuPropertiesSection
GUI.TextLabel_67.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_67.BackgroundTransparency = 1
GUI.TextLabel_67.BorderSizePixel = 0
GUI.TextLabel_67.Position = UDim2.new(0, 0, 0, 90)
GUI.TextLabel_67.Size = UDim2.new(0, 90, 0, 30)
GUI.TextLabel_67.Font = Enum.Font.SourceSans
GUI.TextLabel_67.Text = "Rotation"
GUI.TextLabel_67.TextColor3 = Color3.fromRGB(255, 255, 255)
GUI.TextLabel_67.TextSize = 16

GUI.BuildMenuXRotationBox.Name = "BuildMenuXRotationBox"
GUI.BuildMenuXRotationBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuXRotationBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuXRotationBox.BackgroundTransparency = 1
GUI.BuildMenuXRotationBox.BorderSizePixel = 0
GUI.BuildMenuXRotationBox.Position = UDim2.new(0, 90, 0, 90)
GUI.BuildMenuXRotationBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuXRotationBox.Font = Enum.Font.SourceSans
GUI.BuildMenuXRotationBox.Text = "0"
GUI.BuildMenuXRotationBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuXRotationBox.TextSize = 12
GUI.BuildMenuXRotationBox.TextWrapped = true

GUI.BuildMenuYRotationBox.Name = "BuildMenuYRotationBox"
GUI.BuildMenuYRotationBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuYRotationBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuYRotationBox.BackgroundTransparency = 1
GUI.BuildMenuYRotationBox.BorderSizePixel = 0
GUI.BuildMenuYRotationBox.Position = UDim2.new(0, 120, 0, 90)
GUI.BuildMenuYRotationBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuYRotationBox.Font = Enum.Font.SourceSans
GUI.BuildMenuYRotationBox.Text = "0"
GUI.BuildMenuYRotationBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuYRotationBox.TextSize = 12
GUI.BuildMenuYRotationBox.TextWrapped = true

GUI.BuildMenuZRotationBox.Name = "BuildMenuZRotationBox"
GUI.BuildMenuZRotationBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuZRotationBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuZRotationBox.BackgroundTransparency = 1
GUI.BuildMenuZRotationBox.BorderSizePixel = 0
GUI.BuildMenuZRotationBox.Position = UDim2.new(0, 150, 0, 90)
GUI.BuildMenuZRotationBox.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuZRotationBox.Font = Enum.Font.SourceSans
GUI.BuildMenuZRotationBox.Text = "0"
GUI.BuildMenuZRotationBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuZRotationBox.TextSize = 12
GUI.BuildMenuZRotationBox.TextWrapped = true

GUI.BuildMenuBringPartButton.Name = "BuildMenuBringPartButton"
GUI.BuildMenuBringPartButton.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuBringPartButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuBringPartButton.BackgroundTransparency = 1
GUI.BuildMenuBringPartButton.BorderSizePixel = 0
GUI.BuildMenuBringPartButton.Position = UDim2.new(0, 0, 0, 120)
GUI.BuildMenuBringPartButton.Size = UDim2.new(0, 90, 0, 30)
GUI.BuildMenuBringPartButton.Font = Enum.Font.SourceSans
GUI.BuildMenuBringPartButton.Text = "Bring Part"
GUI.BuildMenuBringPartButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuBringPartButton.TextSize = 14

GUI.BuildMenuPlacePartButton.Name = "BuildMenuPlacePartButton"
GUI.BuildMenuPlacePartButton.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuPlacePartButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuPlacePartButton.BackgroundTransparency = 1
GUI.BuildMenuPlacePartButton.BorderSizePixel = 0
GUI.BuildMenuPlacePartButton.Position = UDim2.new(0, 90, 0, 120)
GUI.BuildMenuPlacePartButton.Size = UDim2.new(0, 90, 0, 30)
GUI.BuildMenuPlacePartButton.Font = Enum.Font.SourceSans
GUI.BuildMenuPlacePartButton.Text = "Place Part"
GUI.BuildMenuPlacePartButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuPlacePartButton.TextSize = 14

GUI.BuildMenuMoveXButton.Name = "BuildMenuMoveXButton"
GUI.BuildMenuMoveXButton.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuMoveXButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuMoveXButton.BackgroundTransparency = 1
GUI.BuildMenuMoveXButton.BorderSizePixel = 0
GUI.BuildMenuMoveXButton.Position = UDim2.new(0, 90, 0, 0)
GUI.BuildMenuMoveXButton.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuMoveXButton.Font = Enum.Font.SourceSans
GUI.BuildMenuMoveXButton.Text = "+/-"
GUI.BuildMenuMoveXButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuMoveXButton.TextScaled = true
GUI.BuildMenuMoveXButton.TextSize = 14
GUI.BuildMenuMoveXButton.TextWrapped = true

GUI.BuildMenuMoveYButton.Name = "BuildMenuMoveYButton"
GUI.BuildMenuMoveYButton.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuMoveYButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuMoveYButton.BackgroundTransparency = 1
GUI.BuildMenuMoveYButton.BorderSizePixel = 0
GUI.BuildMenuMoveYButton.Position = UDim2.new(0, 120, 0, 0)
GUI.BuildMenuMoveYButton.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuMoveYButton.Font = Enum.Font.SourceSans
GUI.BuildMenuMoveYButton.Text = "+/-"
GUI.BuildMenuMoveYButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuMoveYButton.TextScaled = true
GUI.BuildMenuMoveYButton.TextSize = 14
GUI.BuildMenuMoveYButton.TextWrapped = true

GUI.BuildMenuMoveZButton.Name = "BuildMenuMoveZButton"
GUI.BuildMenuMoveZButton.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuMoveZButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuMoveZButton.BackgroundTransparency = 1
GUI.BuildMenuMoveZButton.BorderSizePixel = 0
GUI.BuildMenuMoveZButton.Position = UDim2.new(0, 150, 0, 0)
GUI.BuildMenuMoveZButton.Size = UDim2.new(0, 30, 0, 30)
GUI.BuildMenuMoveZButton.Font = Enum.Font.SourceSans
GUI.BuildMenuMoveZButton.Text = "+/-"
GUI.BuildMenuMoveZButton.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuMoveZButton.TextScaled = true
GUI.BuildMenuMoveZButton.TextSize = 14
GUI.BuildMenuMoveZButton.TextWrapped = true

GUI.BuildMenuIncrementBox.Name = "BuildMenuIncrementBox"
GUI.BuildMenuIncrementBox.Parent = GUI.BuildMenuPropertiesSection
GUI.BuildMenuIncrementBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.BuildMenuIncrementBox.BackgroundTransparency = 1
GUI.BuildMenuIncrementBox.BorderSizePixel = 0
GUI.BuildMenuIncrementBox.Position = UDim2.new(0, 180, 0, 120)
GUI.BuildMenuIncrementBox.Size = UDim2.new(0, 90, 0, 30)
GUI.BuildMenuIncrementBox.Font = Enum.Font.SourceSans
GUI.BuildMenuIncrementBox.PlaceholderColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuIncrementBox.PlaceholderText = "Default: 0.5"
GUI.BuildMenuIncrementBox.Text = ""
GUI.BuildMenuIncrementBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.BuildMenuIncrementBox.TextSize = 12
GUI.BuildMenuIncrementBox.TextWrapped = true

GUI.CommandBarFrame.Name = "CommandBarFrame"
GUI.CommandBarFrame.Parent = GUI.OthersFrame
LoadMainColor(GUI.CommandBarFrame, "Background")
GUI.CommandBarFrame.BackgroundTransparency = 0.250
GUI.CommandBarFrame.BorderSizePixel = 0
GUI.CommandBarFrame.Position = UDim2.new(0, 0, 0, 100)
GUI.CommandBarFrame.Size = UDim2.new(1, 0, 0, 30)
GUI.CommandBarFrame.Visible = false

GUI.CommandBarBox.Name = "CommandBarBox"
GUI.CommandBarBox.Parent = GUI.CommandBarFrame
GUI.CommandBarBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GUI.CommandBarBox.BackgroundTransparency = 1
GUI.CommandBarBox.BorderSizePixel = 0
GUI.CommandBarBox.Size = UDim2.new(1, 0, 1, 0)
GUI.CommandBarBox.Font = Enum.Font.SourceSans
GUI.CommandBarBox.Text = ""
GUI.CommandBarBox.TextColor3 = Color3.fromRGB(225, 225, 225)
GUI.CommandBarBox.TextSize = 16
GUI.CommandBarBox.TextWrapped = true

local Recording = false
local RecordButton
local Sliding = false
local SliderButton
local Slider
local SliderData
local SlidingStep = 0

local function ShowColorPicker(Button, Change)
    local Frame = Instance.new("Frame")
end

local function ChangeTab(Tab, Button)
    for _,v in pairs(GUI.TabHolder:GetChildren()) do
        if v:IsA("Frame") then
            if v.Name ~= Tab.Name then
                v.Visible = false
            end
        end
    end
    for _,v in pairs(GUI.TabSelect:GetChildren()) do
        if v:IsA("TextButton") then
            if v.Name ~= Button.Name then
                v.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
    end
    Tab.Visible = true
    LoadMainColor(Button, "Text")
end

local function CheckBox(Box, State, ...)
    if Config[State] then
        Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Config[State] = false
        if ... then
            local ColorButton = ...
            ColorButton.Visible = false
        end
    else
        local Colors = Config["MainColor"]:split(",")
        Box.BackgroundColor3 = Color3.fromRGB(Colors[1], Colors[2], Colors[3])
        Config[State] = true
        if ... then
            local ColorButton = ...
            ColorButton.Visible = true
        end
    end
    SaveFile()
end

local function SelectionBox(Frame)
    if Frame.Visible == true then
        Frame.Visible = false
    else
        Frame.Visible = true
    end
end

local function SliderStep(Number, Factor)
    if Factor ~= 0 then
        return math.floor(Number / Factor + .5) * Factor
    else
        return Number
    end
end

local function UpdateSliderInfo(Object, Value)
    Config[string.gsub(Object.Name, "Slider", "")] = Value
end

local function UpdateKeyBoxes()
    Config["AimbotKey"] = GUI.AimbotKeyButton.Text
    Config["PlayerESPKey"] = GUI.PlayerESPKeyButton.Text
    Config["PrefixKey"] = GUI.PrefixKeyButton.Text
    Config["MenuKey"] = GUI.MenuKeyButton.Text
end

GUI.CommandBarBox.Focused:Connect(function()
    Wait()
    GUI.CommandBarBox.Text = ""
end)

GUI.CombatSelect.MouseButton1Click:Connect(function()
    ChangeTab(GUI.CombatTab, GUI.CombatSelect)
end)

GUI.VisualsSelect.MouseButton1Click:Connect(function()
    ChangeTab(GUI.VisualsTab, GUI.VisualsSelect)
end)

GUI.CharacterSelect.MouseButton1Click:Connect(function()
    ChangeTab(GUI.CharacterTab, GUI.CharacterSelect)
end)

GUI.MiscSelect.MouseButton1Click:Connect(function()
    ChangeTab(GUI.MiscellaneousTab, GUI.MiscSelect)
end)

GUI.SettingsSelect.MouseButton1Click:Connect(function()
    ChangeTab(GUI.SettingsTab, GUI.SettingsSelect)
end)

GUI.AimbotKeyButton.MouseButton1Click:Connect(function()
    Recording = true
    RecordButton = GUI.AimbotKeyButton
    GUI.AimbotKeyButton.Text = "Recording.."
end)

GUI.AimlockCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AimlockCheckBox, "Aimlock")
end)

GUI.SilentAimCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.SilentAimCheckBox, "SilentAim")
end)

GUI.AutoFireCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AutoFireCheckBox, "AutoFire")
end)

GUI.AimbotHitBoxButton.MouseButton1Click:Connect(function()
    SelectionBox(GUI.HitboxesSelectionFrame)
end)

GUI.HeadHitboxSelect.MouseButton1Click:Connect(function()
    GUI.HitboxesSelectionFrame.Visible = false
    GUI.AimbotHitBoxButton.Text = "Head"
    Config["AimbotTarget"] = "Head"
    SaveFile()
end)

GUI.TorsoHitboxSelect.MouseButton1Click:Connect(function()
    GUI.HitboxesSelectionFrame.Visible = false
    GUI.AimbotHitBoxButton.Text = "Torso"
    Config["AimbotTarget"] = "Torso"
    SaveFile()
end)

GUI.NoStopCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.NoStopCheckBox, "NoStop")
end)

GUI.RunPunchCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.RunPunchCheckBox, "AlwaysRunPunch")
end)

GUI.SuperPunchCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.SuperPunchCheckBox, "SuperPunch")
end)

GUI.AutoSwitchCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AutoSwitchCheckBox, "AutoSwitch")
end)

GUI.StompSpamCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.StompSpamCheckBox, "StompSpam")
end)

GUI.AutoStompCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AutoStompCheckBox, "AutoStomp")
end)

GUI.AutoStompDistanceSliderButton.MouseButton1Down:Connect(function()
    Sliding = true
    Slider = GUI.AutoStompDistanceSlider
    SliderData = GUI.AutoStompDistanceAmount
    SliderButton = GUI.AutoStompDistanceSliderButton
end)

GUI.PlayerESPKeyButton.MouseButton1Click:Connect(function()
    Recording = true
    RecordButton = GUI.PlayerESPKeyButton
    GUI.PlayerESPKeyButton.Text = "Recording.."
end)

GUI.PlayerChamsCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerChamsCheckBox, "Chams", GUI.PlayerChamsColorButton)
end)

GUI.PlayerChamsColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerChamsColorButton, "ChamsColor")
end)

GUI.PlayerStaminaCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerStaminaCheckBox, "Stamina", GUI.PlayerStaminaColorButton)
end)

GUI.PlayerStaminaColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerStaminaColorButton, "StaminaColor")
end)

GUI.PlayerKOCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerKOCheckBox, "KO", GUI.PlayerKOColorButton)
end)

GUI.PlayerKOColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerKOColorButton, "KOColor")
end)

GUI.PlayerBoxCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerBoxCheckBox, "Box", GUI.PlayerBoxColorButton)
end)

GUI.PlayerBoxColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerBoxColorButton, "BoxColor")
end)

GUI.PlayerGlowCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerGlowCheckBox, "Glow", GUI.PlayerGlowColorButton)
end)

GUI.PlayerGlowColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerGlowColorButton, "GlowColor")
end)

GUI.PlayerInfoCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.PlayerInfoCheckBox, "Info", GUI.PlayerInfoColorButton)
end)

GUI.PlayerInfoColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.PlayerInfoColorButton, "InfoColor")
end)

GUI.ItemESPEnabledCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.ItemESPEnabledCheckBox, "ItemEsp")
end)

GUI.ItemESPGoodItemsCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.ItemESPGoodItemsCheckBox, "GoodItemsOnly")
end)

GUI.BulletTracersCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.BulletTracersCheckBox, "BulletTracers", GUI.BulletTracersColorButton)
end)

GUI.BulletTracersColorButton.MouseButton1Click:Connect(function()
    ShowColorPicker(GUI.BulletTracersColorButton, "BulletTracersColor")
end)

GUI.WatermarkCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.WatermarkCheckBox, "Watermark")
end)

GUI.StatesCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.StatesCheckBox, "States")
end)

GUI.ShowAmmoCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.ShowAmmoCheckBox, "ShowAmmo")
end)

GUI.DraggableUIObjectsCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.DraggableUIObjectsCheckBox, "DraggableUIObjects")
end)

GUI.HitmarkerCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.HitmarkerCheckBox, "Hitmarker")
end)

GUI.HitmarkerSoundButton.MouseButton1Click:Connect(function()
    SelectionBox(GUI.HitmarkerSoundsSelectionFrame)
end)

GUI.NoneSoundSelect.MouseButton1Click:Connect(function()
    GUI.HitmarkerSoundsSelectionFrame.Visible = false
    GUI.HitmarkerSoundButton.Text = "None"
    Config["HitmarkerSound"] = "None"
    SaveFile()
end)

GUI.DefaultSoundSelect.MouseButton1Click:Connect(function()
    GUI.HitmarkerSoundsSelectionFrame.Visible = false
    GUI.HitmarkerSoundButton.Text = "Default"
    Config["HitmarkerSound"] = "Default"
    SaveFile()
end)

GUI.GodModeCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.GodModeCheckBox, "GodMode")
end)

GUI.NoKOCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.NoKOCheckBox, "NoKO")
end)

GUI.WalkSpeedModCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.WalkSpeedModCheckBox, "WalkSpeedMod")
end)

GUI.WalkSpeedModSliderButton.MouseButton1Down:Connect(function()
    Sliding = true
    Slider = GUI.WalkSpeedModSlider
    SliderData = GUI.WalkSpeedModAmount
    SliderButton = GUI.WalkSpeedModSliderButton
end)

GUI.JumpPowerModCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.JumpPowerModCheckBox, "JumpPowerMod")
end)

GUI.JumpPowerModSliderButton.MouseButton1Down:Connect(function()
    Sliding = true
    Slider = GUI.JumpPowerModSlider
    SliderData = GUI.JumpPowerModAmount
    SliderButton = GUI.JumpPowerModSliderButton
end)

GUI.RunSpeedModCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.RunSpeedModCheckBox, "RunSpeedMod")
end)

GUI.RunSpeedModSliderButton.MouseButton1Down:Connect(function()
    Sliding = true
    Slider = GUI.RunSpeedModSlider
    SliderData = GUI.RunSpeedModAmount
    SliderButton = GUI.RunSpeedModSliderButton
end)

GUI.AutoLockCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AutoLockCheckBox, "AutoLock")
end)

GUI.AutoUnlockCheckBox.MouseButton1Click:Connect(function()
    CheckBox(GUI.AutoUnlockCheckBox, "AutoUnlock")
end)

if game.PlaceId == TheStreetsId then
    GUI.BuildMenuSwastikaButton.MouseButton1Click:Connect(function()
        local HumPart = Player.Character.HumanoidRootPart
        local pos1 = Vector3.new(0, 4.5, 0)
        local pos2 = Vector3.new(0, -4.5, 0)
        local pos3 = Vector3.new(5, 0, 0)
        local pos4 = Vector3.new(-5, 0, 0)
        local pos5 = Vector3.new(8.5, 5, 0)
        local pos6 = Vector3.new(-3.5, 9.5, 0)
        local pos7 = Vector3.new(-10, -3.5, 0)
        local pos8 = Vector3.new(3.5, -9.5, 0)
        local rot1 = Vector3.new(90, 0, 0)
        local rot2 = Vector3.new(0, 90, 90)
        local count = 0
        for _,v in pairs(UnAnchoredHolder:GetChildren()) do
            if v.Name == "Boards" then
                for _,v2 in pairs(v:GetChildren()) do
                    if v2:IsA("Part") and count < 9 then
                        count = count + 1
                        v2.Position = HumPart.Position
                        v2.Name = "Part" .. tostring(count)
                        v2.Parent = workspace
                    end
                end
            end
        end
        workspace.Part1.Position = HumPart.Position + pos1; workspace.Part1.Rotation = rot1
        workspace.Part2.Position = HumPart.Position + pos2; workspace.Part2.Rotation = rot1
        workspace.Part3.Position = HumPart.Position + pos3; workspace.Part3.Rotation = rot2
        workspace.Part4.Position = HumPart.Position + pos4; workspace.Part4.Rotation = rot2
        workspace.Part5.Position = HumPart.Position + pos5; workspace.Part5.Rotation = rot1
        workspace.Part6.Position = HumPart.Position + pos6; workspace.Part6.Rotation = rot2
        workspace.Part7.Position = HumPart.Position + pos7; workspace.Part7.Rotation = rot1
        workspace.Part8.Position = HumPart.Position + pos8; workspace.Part8.Rotation = rot2
        workspace.Part1.Anchored = true; workspace.Part1.Parent = UsedParts
        workspace.Part2.Anchored = true; workspace.Part2.Parent = UsedParts
        workspace.Part3.Anchored = true; workspace.Part3.Parent = UsedParts
        workspace.Part4.Anchored = true; workspace.Part4.Parent = UsedParts
        workspace.Part5.Anchored = true; workspace.Part5.Parent = UsedParts
        workspace.Part6.Anchored = true; workspace.Part6.Parent = UsedParts
        workspace.Part7.Anchored = true; workspace.Part7.Parent = UsedParts
        workspace.Part8.Anchored = true; workspace.Part8.Parent = UsedParts
    end)

    GUI.BuildMenuInvertedCrossButton.MouseButton1Click:Connect(function()
        local HumPart = Player.Character.HumanoidRootPart
        local pos1 = Vector3.new()
        local pos2 = Vector3.new(0, 8.6, 0)
        local pos3 = Vector3.new(0, 2, 0)
        local rot1 = Vector3.new(90, 0, 0)
        local rot2 = Vector3.new(0, 90, 90)
        local count = 0
        for _,v in pairs(UnAnchoredHolder:GetChildren()) do
            if v.Name == "Plank" and count < 4 then
                count = count + 1
                v.Position = HumPart.Position
                v.Parent = workspace
            end
        end
        workspace.Part1.Position = HumPart.Position + pos1; workspace.Part1.Rotation = rot1
        workspace.Part2.Position = HumPart.Position + pos2; workspace.Part2.Rotation = rot1
        workspace.Part3.Position = HumPart.Position + pos3; workspace.Part3.Rotation = rot2
        workspace.Part1.Anchored = true; workspace.Part1.Parent = UsedParts
        workspace.Part2.Anchored = true; workspace.Part2.Parent = UsedParts
        workspace.Part3.Anchored = true; workspace.Part3.Parent = UsedParts
    end)

    local function GetHats()
        for _,v in pairs(Player.Character:GetChildren()) do
            if v:IsA("Accessory") then
                local Hair
                local HairButton = GUI.TemplateHairSelect:Clone()
                HairButton.Text = v.Name
                HairButton.Visible = true
                for _,v in pairs(Player.PlayerGui.HUD.Clan.Group.Reps:GetChildren()) do
                    if v:IsA("TextButton") and v:FindFirstChild("typ") then
                        if v.typ.Value == HairButton.Text then
                            Hair = v
                        end
                    end
                end
                HairButton.MouseButton1Click:Connect(function()
                    print(HairButton.Text)
                    Player.Backpack.Stank:FireServer("rep", Hair)
                end)
            end
        end
    end
    GetHats()
    for _,v in pairs(Player.PlayerGui.HUD.Clan.Group.cs:GetChildren()) do
        if v:IsA("TextButton") then
            local v2 = v:Clone()
            v2.Parent = GUI.HairColorsHolder
            v2.MouseButton1Click:Connect(function()
                if not v2:FindFirstChild("Selected") then
                    local Selected = Instance.new("StringValue")
                    Selected.Name = "Selected"
                    Selected.Parent = v2
                    LoadMainColor(v2, "Border")
                    table.insert(Config["SelectedHairColors"]) 
                    Player.Backpack.Stank:FireServer("color", v)
                else
                    v2.BorderColor3 = Color3.fromRGB(255, 255, 255)
                    v2:FindFirstChild("Selected"):Destroy()
                end
            end)
        end
    end
    GUI.HairFrameCloseButton.MouseButton1Click:Connect(function()
        GUI.HairFrame.Visible = false
    end)
end

GUI.CommandBarBox.FocusLost:Connect(function()
    GUI.CommandBarFrame.Visible = false
    if GUI.CommandBarBox.Text ~= "" then
        local Message = GUI.CommandBarBox.Text
        if Admins[Player.UserId] then
            
        end
        local Args = {}
        for v in string.gmatch(Message,"[^%s]+") do
            table.insert(Args, v)
        end
        local Command = FindCommand(table.remove(Args, 1))
        if Command then
            Command.CmdFunction(Args, Player)
        end
    end
end)

AddCommand({"commands", "cmds"},function(Args, Speaker)
    
end)

AddCommand({"whitelist", "wl"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if Target then
		if not table.find(Config["Whitelisted"], Target) then
			table.insert(Config["Whitelisted"], Target)
		end
	end
end)

AddCommand({"unwhitelist", "unwl"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if Target then
		if table.find(Config["Whitelisted"], Target) then
			table.remove(Config["Whitelisted"], Target)
		end
	end
end)

AddCommand({"swapplace", "streets", "prison"},function(Args, Speaker)
    if game.PlaceId ~= 455366377 then
        TeleportService:Teleport(455366377)
    else 
        TeleportService:Teleport(4669040)
    end
end)

AddCommand({"servers", "serverlist"},function(Args, Speaker)
    
end)

AddCommand({"mute", "muteboomboxes", "muteradios"},function(Args, Speaker)
    Config["MuteBoomboxes"] = true
    LoadCheckBox(GUI.MuteRadiosCheckBox, "MuteRadios")
end)

AddCommand({"unmute", "unmuteboomboxes", "unmuteradios"},function(Args, Speaker)
    Config["MuteBoomboxes"] = false
    LoadCheckBox(GUI.MuteRadiosCheckBox, "MuteRadios")
end)

AddCommand({"nospray", "hidesprays"},function(Args, Speaker)
    Config["HideSprays"] = true
    LoadCheckBox(GUI.HideSpraysCheckBox, "HideSprays")
end)

AddCommand({"unnospray", "unhidesprays"},function(Args, Speaker)
    Config["HideSprays"] = false
    LoadCheckBox(GUI.HideSpraysCheckBox, "HideSprays")
end)

AddCommand({"logdecal", "logspray"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") and v.Name:find(Target.Name) then
            local SprayId = v:FindFirstChildOfClass("Decal").Texture
            SetClipboard(SprayId)
        end
    end
end)

AddCommand({"logaudio", "logsound"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetBackpack = Target:FindFirstChild("Backpack")
    local TargetChar = Target.Character
    local Boombox = TargetBackpack:FindFirstChild("BoomBox")
    if not Boombox then
        Boombox = TargetChar:FindFirstChild("BoomBox")
    end
    if not Boombox then
        Notify("Warning", "This player does not have a boombox", 5, nil)
    else
        local Sound = Boombox:FindFirstChild("Handle"):FindFirstChildOfClass("Sound")
        SetClipboard(tostring(Sound.SoundId))
    end
end)

AddCommand({"doorspam", "doors"},function(Args, Speaker)
    DoorSpam = true
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if DoorSpam then
            Wait(1)
            for _,v in pairs(DoorHolder:GetChildren()) do
                if v.Name == "Door" then
                    for _,v2 in pairs(v:GetChildren()) do
                        if v2.Name == "Locker" then
                            if v2.Value == false then
                                if v:FindFirstChild("Click") then
                                    v.Click.ClickDetector.RemoteEvent:FireServer()
                                end
                            end
                        end
                    end
                end
            end
        else
            RS:Disconnect()
        end
    end)
end)

AddCommand({"undoorspam", "undoors"},function(Args, Speaker)
    DoorSpam = false
end)

AddCommand({"gunclickspam", "clickspam"},function(Args, Speaker)
    if game.PlaceId == ThePrisonId then
        GunClickSpam = true
        local RS
        RS = game:GetService("RunService").Stepped:Connect(function()
            if GunClickSpam then
                Wait(.5)
                for _,v in pairs(Players:GetDescendants()) do
                    if v.Name == "Click" and v:IsA("RemoteEvent") then
                        v:FireServer()
                    end
                end
                for _,v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Click" and v:IsA("RemoteEvent") then
                        v:FireServer()
                    end
                end
            else
                RS:Disconnect()
            end
        end)
    end
end)

AddCommand({"ungunclickspam", "unclickspam"},function(Args, Speaker)
    GunClickSpam = false
end)

AddCommand({"control"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        local AnimateScript = TargetChar:FindFirstChild("Animate")
        if AnimateScript then
            AnimateScript:Clone().Parent = TargetChar
        end
        Player.PlayerGui.HUD.Parent = SavedInstances
        Player.Character = Players[Target.Name].Character
        workspace.CurrentCamera.CameraSubject = TargetChar
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"kill"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        TargetChar:BreakJoints()
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"invisible"},function(Args, Speaker)
    local HumRoot = Player.Character:FindFirstChild("HumanoidRootPart")
    Invisible = true
    local Box = Instance.new("BoxHandleAdornment")
    Box.Size = Vector3.new(2, 2, 1)
    Box.Transparency = .5
    Box.Adornee = HumRoot
    Box.Color3 = Color3.fromRGB(0, 85, 255)
    Box.Parent = HumRoot
    HumRoot.CanCollide = true
    local PlatformPart = Instance.new("Part")
    PlatformPart.Parent = HumRoot
    PlatformPart.Anchored = true
    PlatformPart.Transparency = 1
    for _,v in pairs(HumRoot:GetChildren()) do
        if v:IsA("Attachment") or v:IsA("Motor6D") then
            v:Destroy()
        end
    end
    for _,v in pairs(Player.Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Anchored = true
        end
    end
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if Invisible and Player.Character and HumRoot and PlatformPlat then
            PlatformPart.CFrame = HumRoot.CFrame - Vector3.new(0, .1, 0)
        else
            Invisible = false
            RS:Disconnect()
        end
    end)
end)

AddCommand({"noclip"},function(Args, Speaker)
    local Command = FindCommand("clip")
    Command.CmdFunction(Args, Player)
    local Target
    if not Args or not Args[1] then
        Target = Speaker
        Noclip = true
        GUI.NoclippingLabel.Text = "Noclip: true"
    else
        Target = FindPlayer(Args[1])
    end
    local RS
    if Target.Name == Player.Name then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Player.Character and Noclip then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name ~= "Part" then
                        v.CanCollide = false
                    end
                end
            else
                GUI.NoclippingLabel.Text = "Noclip: false"
                Noclip = false
                RS:Disconnect()
            end
        end)
    elseif isnetworkowner(Target.Character:FindFirstChild("HumanoidRootPart")) then
        local NoclipValue = Instance.new("StringValue")
        NoclipValue.Name = "Noclipping"
        NoclipValue.Parent = Target.Character
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character and Target.Character:FindFirstChild("Noclipping") then
                for _, v in pairs(Target.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true and v.Name ~= "Part" then
                        v.CanCollide = false
                    end
                end
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"clip"},function(Args, Speaker)
    local Target
    if not Args or not Args[1] then
        Target = Speaker
        GUI.NoclippingLabel.Text = "Noclip: false"
        Noclip = false
    else
        Target = FindPlayer(Args[1])
    end
    if Target.Character:FindFirstChild("Noclipping") then
        Target.Character:FindFirstChild("Noclipping"):Destroy()
    end
end)

AddCommand({"stun"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Target then
        Target = Speaker
    end
    local TargetChar = Target.Character
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        for _,v in pairs(TargetChar:GetDescendants()) do
            if v:IsA("Part") then
                v.Anchored = true
            end
        end
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
    
end)

AddCommand({"unstun"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Target then
        Target = Speaker
    end
    local TargetChar = Target.Character
    for _,v in pairs(TargetChar:GetDescendants()) do
        if v:IsA("Part") then
            v.Anchored = false
        end
    end
end)

AddCommand({"bring"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        Teleport(TargetChar.HumanoidRootPart, Player.Character.HumanoidRootPart.CFrame)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"speed", "walkspeed", "ws"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Target then
        Target = Speaker
    end
    local TargetChar = Target.Character
    local ws = Args[2]
    if not ws then
        ws = 25
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character then
                TargetChar.Humanoid.WalkSpeed = ws
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"jumppower", "jp"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Target then
        Target = Speaker
    end
    local TargetChar = Target.Character
    local jp = Args[2]
    if not jp then
        jp = 50
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character then
                TargetChar.Humanoid.WalkSpeed = jp
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"hipheight", "hheight", "hh"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Target then
        Target = Speaker
    end
    local TargetChar = Target.Character
    local hh = Args[2]
    if not hh then
        hh = 5
    end
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        TargetChar.Humanoid.HipHeight = hh
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"follow"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local Target2
    local TargetChar = Target.Character
    if not Args[2] then
        Target2 = Character
    else
        Target2 = FindPlayer(Args[2])
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character and TargetChar.Humanoid and Target2 and Target2.Character and Target2.Character.HumanoidRootPart then
                TargetChar.Humanoid:MoveTo(Target2.Character["HumanoidRootPart"].Position)
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"unfollow"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local Target2
    local TargetChar = Target.Character
    if not Args[2] then
        Target2 = Character
    else
        Target2 = FindPlayer(Args[2])
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character and TargetChar.Humanoid and Target2 and Target2.Character and Target2.Character.HumanoidRootPart then
                TargetChar.Humanoid:MoveTo(Target2.Character["HumanoidRootPart"].Position)
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"copymoves"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local Target2
    local TargetChar = Target.Character
    local Target2Char
    if not Args[2] then
        Target2 = Player
        Target2Char = Player.Character
    else
        Target2 = FindPlayer(Args[2])
        Target2Char = Target2.Character
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and TargetChar and TargetChar.HumanoidRootPart and Target2 and Target2Char and Target2Char.HumanoidRootPart then
                TargetChar.HumanoidRootPart.CFrame = Target2Char.HumanoidRootPart.CFrame + Target2Char.HumanoidRootPart.CFrame.LookVector + Vector3.new(5, 0, 0)
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"uncopymoves"},function(Args, Speaker)
    
end)

AddCommand({"spin"},function(Args, Speaker)
    local Target
    if not Args or not Args[1] then
        Target = Speaker
        Spin = true
    else
        Target = FindPlayer(Args[1])
    end
    local TargetChar = Target.Character
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
                if Target and Target.Character and TargetChar:FindFirstChild("HumanoidRootPart") then
                    TargetChar.HumanoidRootPart.CFrame = CFrame.new(TargetChar.HumanoidRootPart.Position) * CFrame.fromEulerAnglesXYZ(0, math.rad(math.random(-180, 0)), 0)
                else
                    RS:Disconnect()
                end
            end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"unspin"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    if not Args[1] then
        Target = Speaker
        Spin = false
    end
    local TargetChar = Target.Character
end)

AddCommand({"van"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character and TargetChar.HumanoidRootPart then
                if game.PlaceId == ThePrisonId then
                    TargetChar.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-31.1705208, 3.19999814, 219.837738))
                else

                end
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"wastemoney"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target and Target.Character and TargetChar.Humanoid then
                Wait()
                TargetChar.HumanoidRootPart.CFrame = ItemTeleports["Glock"]
                Wait()
                TargetChar.HumanoidRootPart.CFrame = ItemTeleports["Uzi"]
                Wait()
                TargetChar.HumanoidRootPart.CFrame = ItemTeleports["Sawed Off"]
                Wait()
                if TargetChar.Humanoid.Sit then
                    TargetChar.Humanoid.Sit = false
                end
                TargetChar.Humanoid.Jump = true
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"reset", "respawn"},function(Args, Speaker)
    Player.Character:BreakJoints()
end)

AddCommand({"anticlaim", "antiattach"},function(Args, Speaker)
    AntiClaim = true
end)

AddCommand({"rejoin", "rj"},function(Args, Speaker)
    TeleportService:Teleport(game.PlaceId, Player)
end)

AddCommand({"fly"},function(Args, Speaker)
    if Flying then
        StopFly()
    else
        StartFly()
    end
end)

AddCommand({"flyspeed"},function(Args, Speaker)
    if Args[1] then
        Config["FlySpeed"] = Args[1]
    else
        Config["FlySpeed"] = 2
    end
end)

AddCommand({"float", "airwalk"},function(Args, Speaker)
    Airwalk = true
    local FloatPart = Instance.new("Part")
    FloatPart.Parent = Player.Character
    FloatPart.Anchored = true
    FloatPart.Transparency = 1
    FloatPart.Size = Vector3.new(30, 1, 30)
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Airwalk then
            FloatPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, HeightValue, 0)
        else
            Airwalk = false
            FloatPart:Destroy()
            RS:Disconnect()
        end
    end)
end)

AddCommand({"unfly"},function(Args, Speaker)
    StopFly()
end)

AddCommand({"unfloat", "unairwalk"},function(Args, Speaker)
    Airwalk = false
end)

AddCommand({"goto", "to"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    Teleport(Player.Character.HumanoidRootPart, Target.Character.HumanoidRootPart.CFrame)
end)

AddCommand({"keybind", "bind"},function(Args, Speaker)
    if Args[1] then
		local Keybind = string.sub(tostring(Args[1]), 1, 3)
		if Args[2] then
			table.remove(Args, 1)
			local KeybindCommand = table.concat(Args, " ")
            table.insert(Settings["Binds"], KeybindCommand .."//".. Keybind)
            Notify("Notification", "Bound " .. Keybind .. " to " .. KeybindCommand, nil, 5)
			SaveFile()
		end
	end
end)

AddCommand({"clearkeybinds", "clearbinds"},function(Args, Speaker)
    Settings["Binds"] = {}
    Notify("Warning", "All keybinds have been removed!", nil, 5)
    SaveFile()
end)

AddCommand({"buildmenu"},function(Args, Speaker)
    GUI.BuildMenuFrame.Visible = true
end)

AddCommand({"haircolors", "hairmenu"},function(Args, Speaker)
    GUI.HairFrame.Visible = true
end)

AddCommand({"armor", "protection"},function(Args, Speaker)
    
end)

AddCommand({"spawnfling"},function(Args, Speaker)
    
end)

AddCommand({"loopfling"},function(Args, Speaker)
    
end)

AddCommand({"loopflingall"},function(Args, Speaker)
    
end)

AddCommand({"resetparts", "refreshparts", "reparts"},function(Args, Speaker)
    for _,v in pairs(UsedParts:GetDescendants()) do
        if v:IsA("Part") then
            v.Anchored = false
            v.Position = Player.Character.HumanoidRootPart.Position
            v.Name = "Part"
            v.Parent = UnAnchoredHolder.Boards
        end
    end
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") and not v.Anchored then
            v.Anchored = false
            v.Position = Player.Character.HumanoidRootPart.Position
            v.Name = "Part"
            v.Parent = UnAnchoredHolder.Boards
        end
    end
end)

AddCommand({"uncontrol"},function(Args, Speaker)
    SavedInstances.HUD.Parent = Player.PlayerGui
    Player.Character = Character
    workspace.CurrentCamera.CameraSubject = Player.Character
end)

AddCommand({"defend"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local ToDefend = FindPlayer(Args[2])

    if not table.find(DefendPlayers, Target) then
        table.insert(DefendPlayers, Target)
    end
    local RS
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        RS = game:GetService("RunService").Stepped:Connect(function()
            if Target.Character and ToDefend.Character then
                TargetChar.HumanoidRootPart.CFrame = ToDefend.HumanoidRootPart.CFrame + ToDefend.HumanoidRootPart.CFrame.LookVector
            else
                RS:Disconnect()
            end
        end)
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"blink"},function(Args, Speaker)
    if Args[1] then
        Config["BlinkSpeed"] = tonumber(Args[1])
    else
        Config["BlinkSpeed"] = 1
    end
    Config["Blink"] = true
end)

AddCommand({"unblink"},function(Args, Speaker)
    Config["Blink"] = false
end)

AddCommand({"god", "godmode"},function(Args, Speaker)
    Player.Character:BreakJoints()
    Player.CharacterAdded:Connect(function(Character)
        if ThePrisonId then
            Character:WaitForChild("Right Leg"):Destroy()
        end
        for _,v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("NumberValue") then
                v:Destroy()
            end
        end
    end)
    Notify("Warning", "This breaks the server a little bit.", 5, nil)
end)

AddCommand({"annoy"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
end)

AddCommand({"earrape"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local SoundId = Args[2]
    if not SoundId then
        SoundId = 4929899599
    end
    for i,v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name == "BoomBox" then
            Count = Count + i
            local Event = v:FindFirstChildOfClass("RemoteEvent")
            if Event then
                Event:FireServer("play", tostring(SoundId))
            end
            v.Parent = Player.Character
        end
    end
    Notify("Hint", "Use godmode for multiple boomboxes by giving them with an alt or from a friend", 5, nil)
    Notify("Hint", "if ur in the prison rejoin until ur tools don't work and then let a friend give u new boomboxes", 5, nil)
end)

AddCommand({"unearrape"},function(Args, Speaker)
    for _,v in pairs(Player.Character:GetChildren()) do
        if v.Name == "BoomBox" then
            
        end
    end
end)

AddCommand({"buy"},function(Args, Speaker)
    local Item = Args[1]
    for i,v in pairs(ItemTeleports) do
        if Item:lower() == i:lower() then
            Teleport(Player.Character.HumanoidRootPart, v)
        end
    end
end)

AddCommand({"reload"},function(Args, Speaker)
    local Target
    if not Args or not Args[1] then
        Target = Speaker
    else
        Target = FindPlayer(Args[1])
    end
    Teleport(Target.Character.HumanoidRootPart, ItemTeleports["Ammo1"])
end)

AddCommand({"heal"},function(Args, Speaker)
    local Target
    if not Args or not Args[1] then
        Target = Speaker
    else
        Target = FindPlayer(Args[1])
    end
    if isnetworkowner(TargetChar:FindFirstChild("HumanoidRootPart")) then
        Teleport(Target.Character.HumanoidRootPart, ItemTeleports["Burger"])
    else
        Notify("Warning", "The player must be dragged by you", 5, nil)
    end
end)

AddCommand({"givetool"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local Character = Player.Character
    Camera.CameraSubject = Target.Character
    local Humanoid = Character.Humanoid
    for _,v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            v.Parent = Player.Character
        end
    end
    Humanoid:Clone().Parent = Character
    Humanoid:Destroy()
    while Character and RunService.Stepped:Wait() do
        Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
    end
end)

AddCommand({"afk"},function(Args, Speaker)
    Settings["AFK"] = true
    Notify("Warning", "People can still teleport you", 5, nil)
    Notify("Warning", "Delete the tpers with the command noteleport", 5, nil)
end)

AddCommand({"unafk"},function(Args, Speaker)
    Settings["AFK"] = false
    Notify("Notification", "Turned off AFK", 5, nil)
end)

AddCommand({"autofarm"},function(Args, Speaker)
    Settings["AFK"] = true
    AutoFarm = true
    Notify("Notification", "Turned on autofarm", 5, nil)
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if AutoFarm and Player.Character then
            local ToGoto
            local LastToGoto
            for _,v in pairs(workspace.RandomSpawns:GetChildren()) do
                if v.Name == "RandomSpawner" then
                    ToGoto = v.CFrame
                end
            end
            if ToGoto and Player.Character:FindFirstChild("HumanoidRootPart") and not AutoFarmCooldown then
                AutoFarmCooldown = true
                Teleport(Player.Character.HumanoidRootPart, ToGoto)
            end
        else
            RS:Disconnect()
        end
    end)
end)

AddCommand({"unautofarm"},function(Args, Speaker)
    AutoFarm = false
    AutoFarmCooldown = false
    Notify("Notification", "Turned off autofarm", 5, nil)
end)

AddCommand({"itemesp"},function(Args, Speaker)
    Config["ItemEsp"] = true
    ItemEsp()
    Notify("Notification", "Turned on itemesp", 5, nil)
end)

AddCommand({"unitemesp", "noitemesp"},function(Args, Speaker)
    Config["ItemEsp"] = false
    for _,v in pairs(workspace.RandomSpawns:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
    Notify("Notification", "Turned off itemesp", 5, nil)
end)

AddCommand({"sodagun"},function(Args, Speaker)
    
end)

AddCommand({"axe"},function(Args, Speaker)
    
end)

AddCommand({"grabknife"},function(Args, Speaker)
    
end)

AddCommand({"shield", "protect"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    Protect = true
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if Target and Target.Character and Player.Character and Protect then
            Player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame + Target.Character.HumanoidRootPart.CFrame.LookVector
        end
    end)
end)

AddCommand({"unshield", "unprotect"},function(Args, Speaker)
    Protect = false
end)

AddCommand({"notp", "noteleport"},function(Args, Speaker)
    local ArmouredTruck = workspace:FindFirstChild("Armoured Truck")
    local TPer = workspace:FindFirstChild("TPer")
    if ArmouredTruck then
        ArmouredTruck.Parent = SavedInstances
    end
    if TPer then
        ArmouredTruck.Parent = SavedInstances
    end
    Notify("Success", "Hid the teleporters", 5, nil)
end)

AddCommand({"ping", "getping", "chatping"},function(Args, Speaker)
    local PingTick = tick()
    game:GetService("RobloxReplicatedStorage").GetServerVersion:InvokeServer()
    local Ping = tick() - PingTick
    Ping = math.floor(Ping * 1000)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Current ping: " .. tostring(Ping), "All")
end)

AddCommand({"mouselockkey", "mlmkey", "mouselock"},function(Args, Speaker)
    if Args[1] then
        Player.PlayerScripts.PlayerModule.CameraModule.MouseLockController.BoundKeys.Value = Args[1]
    end
end)

AddCommand({"remotegun", "rgun"},function(Args, Speaker)
    RemoteGun = true
    AttachGun = false
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position) * CFrame.fromEulerAnglesXYZ(0, math.rad(-90), 0)
    for _,v in pairs(Player.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Anchored = true
        end
    end
end)

AddCommand({"unremotegun", "unrgun"},function(Args, Speaker)
    RemoteGun = false
    for _,v in pairs(Player.Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Anchored = false
        end
    end
    for _,v in pairs(Player.Character:GetChildren()) do
        if v:IsA("Tool") then
            if v.Name == "Sawed Off" then
                v.Grip = OriginalGrips["Sawed Off"]
            elseif v.Name == "Shotty" then
                v.Grip = OriginalGrips["Shotty"]
            elseif v.Name == "Glock" then
                v.Grip = OriginalGrips["Glock"]
            elseif v.Name == "Uzi" then
                v.Grip = OriginalGrips["Uzi"]
            end
        end
    end
    for _,v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            if v.Name == "Sawed Off" then
                v.Grip = OriginalGrips["Sawed Off"]
            elseif v.Name == "Shotty" then
                v.Grip = OriginalGrips["Shotty"]
            elseif v.Name == "Glock" then
                v.Grip = OriginalGrips["Glock"]
            elseif v.Name == "Uzi" then
                v.Grip = OriginalGrips["Uzi"]
            end
        end
    end
end)

AddCommand({"attachgun", "agun"},function(Args, Speaker)
    AttachGunTarget = FindPlayer(Args[1])
    AttachGun = true
    RemoteGun = false
end)

AddCommand({"unattachgun", "unagun"},function(Args, Speaker)
    AttachGun = false
end)

AddCommand({"target"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    AimbotPlayer = Target
    GUI.CurrentTargetLabel.Text = "Current Target: " .. Target.Name
end)

AddCommand({"esp"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    table.insert(ESPPlayers, Target)
    if PlayerEsp then
        PlayerEspCreate(Target)
    end
end)

AddCommand({"unesp"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    table.remove(ESPPlayers, Target)
    local ESPFolder = Target:FindFirstChild("ESP_" .. Target.Name)
    if ESPFolder then
        ESPFolder:Destroy()
    end
end)

AddCommand({"view"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    local TargetChar = Target.Character
    workspace.CurrentCamera.CameraSubject = TargetChar
end)

AddCommand({"unview"},function(Args, Speaker)
    workspace.CurrentCamera.CameraSubject = Live:FindFirstChild(Player.Name)
end)

AddCommand({"fov"},function(Args, Speaker)
    if Args[1] then
        Camera.FieldOfView = Args[1]
    else
        Camera.FieldOfView = 70
    end
end)

AddCommand({"loopattach"},function(Args, Speaker)
    local Target = FindPlayer(Args[1])
    LoopAttach = true
    local RS
    RS = game:GetService("RunService").Stepped:Connect(function()
        if Target and LoopAttach then
            if Player.Character and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CameraSubject = Target.Character
                local Character = Player.Character
                local Humanoid = Character.Humanoid
                Humanoid:Clone().Parent = Character
                Humanoid:Destroy()
                local Tool = Player.Backpack:FindFirstChildOfClass("Tool")
                Tool.Grip = CFrame.new(tonumber("inf"), tonumber("inf"), tonumber("inf"))
                Tool.Parent = Character
                Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
            end
        else
            LoopAttach = false
            RS:Disconnect()
        end
    end)
end)

AddCommand({"tpbypass"},function(Args, Speaker)
    if TPBypass then
        TPBypass = false
    else
        TPBypass = true
    end
end)

AddCommand({"fpscap"},function(Args, Speaker)
    if setfpscap then
        if Args[1] then
            local FPS = tonumber(Args[1])
            if FPS < 1000 then
                Config["FPSCap"] = FPS
                setfpscap(FPS)
            end
        else
            Config["FPSCap"] = 244
            setfpscap(244)
        end
    end
end)

AddCommand({"gunanim", "gunanimation"},function(Args, Speaker)
    if Args[1] then
        SelectedGunAnimation = Args[1]
        Notify("Notification", "Selected gun animation: " .. Args[1], 5, nil)
    else
        SelectedGunAnimation = nil
        Notify("Notification", "Gun animations were removed", 5, nil)
    end
end)

AddCommand({"autoplay"},function(Args, Speaker)
    if Args[1] then
        SongId = Args[1]
        AutoPlay = not AutoPlay
    end
end)

AddCommand({"taunt"},function(Args, Speaker)
    local Message = {"When was the last time you went outside, vampire fhag?","Here's 20 cents, call all your friends and give me back the change","You must have been born on a highway, because that's where most accidents happen","Your family tree is a cactus, because everybody on it is aprick",}
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message[math.random(#Message)], "All")
end)

AddCommand({"joke"},function(Args, Speaker)
    local Joke = HttpService:JSONDecode(game:HttpGet("https://official-joke-api.appspot.com/random_joke"))
    local Question = Joke["setup"]
    local Answer = Joke["punchline"]
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Question, "All")
    Wait(3)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Answer, "All")
end)

AddCommand({"superpunch", "supapunch", "flingpunch"},function(Args, Speaker)
    if SelectedTool then
        SelectedTool.Parent = Player.Character
    end
    local Punch = Player.Character:FindFirstChild("Punch")
    if not Punch then
        Punch = Player.Backpack:FindFirstChild("Punch")
    end
    Punch.Parent = Backpack
    Punch.Grip = CFrame.new(math.pow(math.huge, math.huge) * math.huge, math.pow(math.huge, math.huge) * math.huge, math.pow(math.huge, math.huge) * math.huge)
    Punch.Parent = Player.Character
end)
--[[
local CommandDescs = {}
CommandDescs[#CommandDescs + 1] = {Name = "commands/cmds", Desc = "Opens the commands frame"}
CommandDescs[#CommandDescs + 1] = {Name = "whilelist/wl", Desc = "Whitelists a player"}
CommandDescs[#CommandDescs + 1] = {Name = "unwhilelist/unwl", Desc = "Unwhitelists a player"}
CommandDescs[#CommandDescs + 1] = {Name = "swapplace/streets/prison", Desc = "Teleports you in to the second game"}
CommandDescs[#CommandDescs + 1] = {Name = "mute/muteboomboxes/muteradios", Desc = "Mutes others' boomboxes"}
CommandDescs[#CommandDescs + 1] = {Name = "unmute/unmuteboomboxes/unmuteradios", Desc = "Unmutes others' boomboxes"}
CommandDescs[#CommandDescs + 1] = {Name = "unnospray/unhidesprays", Desc = "Stops hiding the sprays"}
CommandDescs[#CommandDescs + 1] = {Name = "controlplayer/control", Desc = "Control a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "uncontrolplayer/uncontrol", Desc = "Uncontrol the player you are controlling"}
CommandDescs[#CommandDescs + 1] = {Name = "killplayer", Desc = "Kill a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "breakplayer", Desc = "Break a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "bringplayer", Desc = "Bring a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "followplayer", Desc = "Make the player you have dragged follow someone"}
CommandDescs[#CommandDescs + 1] = {Name = "defendplayer", Desc = "Make the player you dragged defend someone"}
CommandDescs[#CommandDescs + 1] = {Name = "wastemoney", Desc = "Waste money from the player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "speedplayer/wsplayer", Desc = "Give speed to a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "jumpplayer/jpplayer", Desc = "Give jump power to a player you have dragged"}
CommandDescs[#CommandDescs + 1] = {Name = "stopplayer", Desc = "Removes the commands you gave the dragged player"}
CommandDescs[#CommandDescs + 1] = {Name = "blink", Desc = "Adds blink"}
CommandDescs[#CommandDescs + 1] = {Name = "unblink", Desc = "Removes blink"}
CommandDescs[#CommandDescs + 1] = {Name = "god/godmode", Desc = "Adds godmode on for this life"}
CommandDescs[#CommandDescs + 1] = {Name = "annoy", Desc = "Annoys the target"}
CommandDescs[#CommandDescs + 1] = {Name = "earrape", Desc = "Spams all of your boomboxes in the targets head"}
CommandDescs[#CommandDescs + 1] = {Name = "unearrape", Desc = "Stops earraping the target"}
CommandDescs[#CommandDescs + 1] = {Name = "buy", Desc = "Teleports you to the item shop location"}
CommandDescs[#CommandDescs + 1] = {Name = "reload", Desc = "Teleports you to a random ammo store"}
CommandDescs[#CommandDescs + 1] = {Name = "heal", Desc = "Teleports you to the burger place"}
CommandDescs[#CommandDescs + 1] = {Name = "autofarm", Desc = "Enables autofarm"}
CommandDescs[#CommandDescs + 1] = {Name = "unautofarm", Desc = "Disables autofarm"}
CommandDescs[#CommandDescs + 1] = {Name = "itemesp", Desc = "Enables item esp"}
CommandDescs[#CommandDescs + 1] = {Name = "unitemesp/noitemesp", Desc = "Disables item esp"}
CommandDescs[#CommandDescs + 1] = {Name = "sodagun", Desc = "Gives you the soda gun"}
CommandDescs[#CommandDescs + 1] = {Name = "shield/protect", Desc = "Loop teleports you to the targets front"}
CommandDescs[#CommandDescs + 1] = {Name = "unshield/unprotect", Desc = "Stops protecting the target"}
CommandDescs[#CommandDescs + 1] = {Name = "notp/noteleport", Desc = "Hides the teleporters"}
CommandDescs[#CommandDescs + 1] = {Name = "ping/getping/chatping", Desc = "Chats your ping"}
CommandDescs[#CommandDescs + 1] = {Name = "mouselockkey/mlkey/mouselock", Desc = "Changes your mouselock key to the 2nd argument"}
CommandDescs[#CommandDescs + 1] = {Name = "aimlock/camlock/aimbot", Desc = "Aimlocks onto the targets target part"}
CommandDescs[#CommandDescs + 1] = {Name = "unaimlock/uncamlock/unaimbot", Desc = "Stops aimlocking"}
CommandDescs[#CommandDescs + 1] = {Name = "silentaim/silent/sa", Desc = "Silent aimbots the target"}
CommandDescs[#CommandDescs + 1] = {Name = "unsilentaim/unsilent/unsa", Desc = "Stops silent aimbotting the target"}
CommandDescs[#CommandDescs + 1] = {Name = "remotegun/rgun", Desc = "Enables remote gun mode"}
CommandDescs[#CommandDescs + 1] = {Name = "unremotegun/unrgun", Desc = "Disables remote gun mode"}
CommandDescs[#CommandDescs + 1] = {Name = "attachgun/agun", Desc = "Attaches your gun to the target"}
CommandDescs[#CommandDescs + 1] = {Name = "unattachgun/unagun", Desc = "Removes the attachment from your gun to the target"}
CommandDescs[#CommandDescs + 1] = {Name = "rainbowhats", Desc = "Enables rainbow hats mode"}
CommandDescs[#CommandDescs + 1] = {Name = "unrainbowhats", Desc = "Disables rainbow hats mode"}

for i = 1, #CommandDescs do
    CmdCount = i + 1
	local CommandDesc = Instance.new("TextLabel")
	CommandDesc.Size = UDim2.new(1, 0, .02, 0)
    CommandDesc.TextSize = 8
    CommandDesc.BackgroundTransparency = 1
    CommandDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
    CommandDesc.Text = CommandDescs[i].Name .. " | " .. CommandDescs[i].Desc
	CommandDesc.Parent = CommandsHolder
end

CommandCount.Text = "Commands [" .. tostring(CmdCount) .. " ]"
--]]

local HUD = Player.PlayerGui:WaitForChild("HUD")
local AntiCheat = Player.PlayerGui:FindFirstChild("LocalScript")
local Crouch = Instance.new("Animation") Crouch.AnimationId = "http://www.roblox.com/item.aspx?id=327855546"
local Hit1 = Instance.new("Animation") Hit1.AnimationId = "https://www.roblox.com/item.aspx?id=455534850"
local Hit2 = Instance.new("Animation") Hit2.AnimationId = "https://www.roblox.com/item.aspx?id=455535422"
local Hit3 = Instance.new("Animation") Hit3.AnimationId = "https://www.roblox.com/item.aspx?id=455535875"
local Run = Instance.new("Animation") Run.AnimationId = "https://www.roblox.com/item.aspx?id=458506542"
--Run.AnimationId = "https://www.roblox.com/item.aspx?id=376653421"
local IdleShotty = Instance.new("Animation") IdleShotty.AnimationId = "https://www.roblox.com/item.aspx?id=503285264"
local IdleGlock = Instance.new("Animation") IdleGlock.AnimationId = "https://www.roblox.com/item.aspx?id=889390949"
local FireShotty = Instance.new("Animation") FireShotty.AnimationId = "https://www.roblox.com/item.aspx?id=889391270"
local FireGlock = Instance.new("Animation") FireGlock.AnimationId = "https://www.roblox.com/item.aspx?id=503287783"
local ReloadGlock = Instance.new("Animation") ReloadGlock.AnimationId = "http://www.roblox.com/item.aspx?id=327869970"
local ReloadShotty = Instance.new("Animation") ReloadShotty.AnimationId = "http://www.roblox.com/item.aspx?id=327870302"

local GunAnimation1 = Instance.new("Animation") GunAnimation1.AnimationId = "rbxassetid://889968874"
local GunAnimation2 = Instance.new("Animation") GunAnimation2.AnimationId = "rbxassetid://229339207"
local IdleAnimation
local RunAnim = Humanoid:LoadAnimation(Run)
local CrouchAnim = Humanoid:LoadAnimation(Crouch)

if AntiCheat then
    AntiCheat.Disabled = true
    AntiCheat:Destroy()
end

Player.PlayerGui.ChildAdded:Connect(function(v)
    if v.Name == "LocalScript" then
        v.Disabled = true
        coroutine.wrap(function()
            v.Disabled = true
            v:Destroy()
        end)()
    end
    if v.Name == "HUD" then
        CreateAmmoLabel(v)
    end
end)

local function HealthChanged()
    if AutoEat then
        if Humanoid.Health < 76 then
            local LastTool = SelectedTool
            if SelectedTool then
                SelectedTool.Parent = Player.Backpack
            end
            for i,v in pairs(Player.Backpack:GetChildren()) do
                if v.Name == "Burger" and HealthCount < 1 then
                    HealthCount = HealthCount + i
                    v.Parent = Player.Character
                    v:Activate()
                    v.Parent = Player.Backpack
                end
            end
            if LastTool then
                LastTool.Parent = Player.Character
            end
        end
        HealthCount = 0
    end
end

local function CharacterChildAdded(v)
    if v:IsA("Tool") then
        if game.PlaceId == ThePrisonId and not _G["BFGTEST"] then
            Player.Backpack.ServerTraits.Tool:FireServer(SelectedTool)
            if v:FindFirstChild("Idle") then
                if IdleAnimation ~= nil then
                    IdleAnimation:Stop()
                end
                IdleAnimation = Player.Character.Humanoid:LoadAnimation(v.Idle)
                IdleAnimation:Play()
            end
        end
        if Player.Backpack:FindFirstChild(v.Name) and not v:FindFirstChild("Safe") then
            if AntiClaim then
                if v.Name == "Punch" or v.Name == "Knife" or v.Name == "Sign" or v.Name == "Pipe" then
                    Wait()
                    v:Destroy()
                end
                coroutine.wrap(function()
                    workspace.FallenPartsDestroyHeight = -5
                    v.Parent = game.Players.LocalPlayer.Backpack
                    local StringValue = Instance.new("StringValue")
                    StringValue.Name = "Safe"
                    StringValue.Parent = v
                end)
            end
        end
        workspace.FallenPartsDestroyHeight = -5000
        SelectedTool = v
        local Ammo = SelectedTool:FindFirstChild("Ammo")
        if SelectedTool and Ammo and SelectedTool:FindFirstChild("Ammo") then
            SelectedTool.Ammo.Changed:Connect(function()
                if SelectedTool and Ammo and AmmoLabel then
                    AmmoLabel.Text = SelectedTool.Ammo.Value .. " Ammo"
                end
            end)
            if AmmoLabel then
                AmmoLabel.Text = SelectedTool.Ammo.Value .. " Ammo"
                AmmoLabel.Visible = true
            end
        end
        if v.Name == "Cash" or v.Name == "Fat Cash" then
            if Config["AutoCash"] then
                v.Parent = Player.Backpack
                v:Activate()
            end
        end
        if SelectedTool.Name == "Punch" and Config["SuperPunch"] then
            SelectedTool.Parent = Backpack
            SelectedTool.Grip = CFrame.new(math.pow(math.huge, math.huge) * math.huge, math.pow(math.huge, math.huge) * math.huge, math.pow(math.huge, math.huge) * math.huge)
            SelectedTool.Parent = Player.Character
        end
    end
end

local function CharacterChildRemoved(v)
    if game.PlaceId == ThePrisonId and not _G["BFGTEST"] then
        if SelectedTool ~= nil and SelectedTool.Parent ~= Player.Character then
            SelectedTool = nil
            Player.Backpack.ServerTraits.Tool:FireServer(SelectedTool)
            if IdleAnimation ~= nil then
                IdleAnimation:Stop()
            end
        end
    end
    if v:IsA("Tool") then
        AmmoLabel.Visible = false
    end
    if SelectedTool ~= nil and SelectedTool.Parent ~= Character then
        AmmoLabel.Visible = false
        SelectedTool = nil
    end
end

local function CharacterDescendantAdded(v)
    if OriginalGrips[v.Name] and SelectedGunAnimation ~= nil then
        Wait()
        if v.Name ~= "Shotty" and v.Name ~= "Sawed Off" or SelectedGunAnimation == "1" then
			Player.Character.Humanoid:LoadAnimation(GunAnimation1):Play()
		else
			local Track = Player.Character.Humanoid:LoadAnimation(GunAnimation2)
			Track:Play()
			Wait()
			Track:AdjustSpeed(0)
		end 
    end
    if v.Name == "Bone" and Config["NoKO"] then
        Player.Character:BreakJoints()
    end
end

local function CharacterDescendantRemoving(v)
    if OriginalGrips[v.Name] then
        StopAnimation(GunAnimation1.AnimationId)
        StopAnimation(GunAnimation2.AnimationId)
    end
end

local function HumanoidDied()
    if Player.Character:FindFirstChild("HumanoidRootPart") then
        LastDiedPosition = Player.Character.HumanoidRootPart.CFrame
    else
        LastDiedPosition = LastDiedPosition
    end
    StopFly()
    Cooldown = false
    Flying = false
    GUI.NoclippingLabel.Text = "Noclip: false"
    Noclip = false
end

local HealthChangedEvent = Player.Character.Humanoid.HealthChanged:Connect(HealthChanged)
local HumanoidDiedEvent = Player.Character.Humanoid.Died:Connect(HumanoidDied)
local CharacterChildAddedEvent = Player.Character.ChildAdded:Connect(CharacterChildAdded, v)
local CharacterChildRemovedEvent = Player.Character.ChildRemoved:Connect(CharacterChildRemoved, v)
local CharacterDescendantAddedEvent = Player.Character.DescendantAdded:Connect(CharacterDescendantAdded, v)
local CharacterDescendantRemovingEvent = Player.Character.DescendantRemoving:Connect(CharacterDescendantRemoving, v)


Player.CharacterAdded:Connect(function(Character)
    if Config["GodMode"] then
        if ThePrisonId then
            Character:WaitForChild("Right Leg"):Destroy()
        end
        for _,v in pairs(Character:GetChildren()) do
            if v:IsA("NumberValue") then
                v:Destroy()
            end
        end
    end
    if game.PlaceId == ThePrisonId then
        local RootPart = Character:WaitForChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
        RootPart.CFrame = CFrame.new(LastDiedPosition.X, 3.25, LastDiedPosition.Z)
    end
    GUI.NoclippingLabel.Text = "Noclip: false"
    Noclip = false
    Flying = false
    Cooldown = false
    Character:WaitForChild("Humanoid")
    if AutoPlay then
        PlayAudio(SongId)
    end
    RunAnim = Character.Humanoid:LoadAnimation(Run)
    CrouchAnim = Character.Humanoid:LoadAnimation(Crouch)
    HealthChangedEvent:Disconnect()
    HumanoidDiedEvent:Disconnect()
    CharacterChildAddedEvent:Disconnect()
    CharacterChildRemovedEvent:Disconnect()
    CharacterDescendantAddedEvent:Disconnect()
    CharacterDescendantRemovingEvent:Disconnect()
    HealthChangedEvent = Character.Humanoid.HealthChanged:Connect(HealthChanged)
    HumanoidDiedEvent = Character.Humanoid.Died:Connect(HumanoidDied)
    CharacterChildAddedEvent = Player.Character.ChildAdded:Connect(CharacterChildAdded, v)
    CharacterChildRemovedEvent = Player.Character.ChildRemoved:Connect(CharacterChildRemoved, v)
    CharacterDescendantAddedEvent = Player.Character.DescendantAdded:Connect(CharacterDescendantAdded, v)
    CharacterDescendantRemovingEvent = Player.Character.DescendantRemoving:Connect(CharacterDescendantRemoving, v)
    
    if Config["AutoSort"] then
        for _,v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = SavedInstances
            end
        end
        for _,v in pairs(SavedInstances:GetChildren()) do
            if v:IsA("Tool") then
                -- Settings["ItemSortTable"]
            end
        end
    end
end)

Player.DescendantAdded:Connect(function(v)
    if Config["AutoCash"] then
        if v:IsA("Tool") and v.Name == "Cash" or v.Name == "Fat Cash" then
            local LastTool = SelectedTool
            if SelectedTool then
                SelectedTool.Parent = Player.Backpack
            end
            Wait()
            v.Parent = Player.Character
            v:Activate()
            if LastTool then
                LastTool.Parent = Player.Character
            end
        end
    end
end)

if Player.Character:FindFirstChild("KO") then
    Player.Character.KO.Changed:Connect(function()
        if Config["NoKO"] then
            if Player.Character.KO.Value <= 0 then
                Player.Character:BreakJoints()
            end
        end
        if AutoEat then
            if Player.Character.KO.Value < 30 then
                local LastTool = SelectedTool
                if SelectedTool then
                    SelectedTool.Parent = Player.Backpack
                end
                for i,v in pairs(Player.Backpack:GetChildren()) do
                    if v.Name == "Drink" and KOCount < 1 then
                        KOCount = KOCount + i
                        v.Parent = Character
                        v:Activate()
                        v.Parent = Player.Backpack
                    end
                end
                if LastTool then
                    LastTool.Parent = Player.Character
                end
            end
            KOCount = 0
        end
    end)
end

Mouse.Idle:Connect(function()
    local Target = Mouse.Target
    if Target and Target:FindFirstChild("ClickDetector") then
        Mouse.Icon = "rbxgameasset://Images/MouseCIon"
        return
    end
    Mouse.Icon = ""
end)

workspace.ChildAdded:Connect(function(v)
    ItemEsp()
    if string.find(v.Name, "Spray") and v:IsA("Part") then
        Wait(2)
        v.Locked = false
        v.Parent = SprayHolder
    end
    if v.Name == "RandomSpawner" then
        Wait(2)
        v.Parent = RandomSpawnsHolder
    end
end)

workspace.DescendantAdded:Connect(function(v)
    if Config["GodMode"] then
        if v.Name == Player.Name then
            for _,v in pairs(v:GetDescendants()) do
                if v:IsA("NumberValue") then 
					v:Destroy()
				end 
            end
        end
    end
    if v:IsA("ObjectValue") and v.Name == "creator" and v.Parent.Parent.Name == Player.Name then
		local Target = v.Value
		pcall(function()
			print(Target, "attacked", v.Parent.Parent.Name)
		end)
	end
    if v:IsA("Trail") and v.Name == "Trail" then
        if Config["BulletTracers"] then
            local Colors = Config["BulletTracersColor"]:split(",")
            v.Color = ColorSequence.new(Color3.fromRGB(Colors[1], Colors[2], Colors[3]))
            v.Lifetime = 5
            game:GetService("Debris"):AddItem(BulletTracer, 5)
        end
        if v.Parent.Name == "Humanoid" then
            if Config["HitCrosshairIcon"] ~= "" then
                Mouse.Icon = Config["HitCrosshairIcon"]
                Wait(1)
                Mouse.Icon = Config["CrosshairIcon"]
            end
            if Config["HitmarkerSound"] ~= "None" then
                local S = Instance.new("Sound", v)
                S.SoundId = "rbxassetid://4491275997"
                S.PlayOnRemove = true
                S.Volume = 3
                S:Destroy()
            end
        end
    end
    if Config["HideSprays"] then
        if v:IsA("Part") and v.Name:find("Spray") then
            Wait()
            v.Locked = false
            v:Destroy()
        end
    end
end)

Player.Idled:Connect(function()
    if AFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if game.PlaceId == ThePrisonId then
        plr.CharacterAdded:Connect(function(v)
            v.Parent = Live
        end)
    end
    if Blacklisted[Player.UserId] then

    end
    if Admins[Player.UserId] then

    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == Player then
        SaveFile()
    end
end)

Player.Chatted:Connect(function(Message)
    if Admins[Player.UserId] then
        local CmdPrefix = string.sub(Message, 1, 1)
        if CmdPrefix == string.char(Enum.KeyCode[Config["PrefixKey"]].Value) then
            Message = string.sub(Message, 2)
            local Args = {}
            for v in string.gmatch(Message,"[^%s]+") do
                table.insert(Args, v)
            end
            local Command = AdminCommands(table.remove(Args, 1))
            if Command and Args[1] then
                Command["Function"](Args[1], table.concat(Args, " "), Player)
            end
        end
    end
    local CmdPrefix = string.sub(Message, 1, 1)
    if CmdPrefix == string.char(Enum.KeyCode[Config["PrefixKey"]].Value) then
        Message = string.sub(Message, 2)
		local Args = {}
		for v in string.gmatch(Message,"[^%s]+") do
			table.insert(Args, v)
        end
        local Command = FindCommand(table.remove(Args, 1))
        if Command then
            if Player.PlayerGui:FindFirstChild("LocalScript") then
                Player.PlayerGui["LocalScript"].Disabled = true
                Player.PlayerGui["LocalScript"]:Destroy()
            end
            Wait()
            Command.CmdFunction(Args, Player)
        end
    end
end)

UIS.InputBegan:Connect(function(Input, GameProcess)
    if Recording and RecordButton ~= nil then
        RecordButton.Text = Input.KeyCode.Name
        UpdateKeyBoxes()
        Recording = false
        RecordButton = nil
    else
        Recording = false
    end
    if Input.KeyCode == Enum.KeyCode.LeftControl then
		CrouchAnim:Play(0.1, 1, 1)
        Keys["Control"] = true
        if game.PlaceId == ThePrisonId then
            Player.Backpack.ServerTraits.Crouch:FireServer(true)
        end
    end
    if Input.KeyCode == Enum.KeyCode.LeftShift then
		Keys["Shift"] = true
    end
    if GameProcess then
        return
    end
    if Input.KeyCode.Name == Config["AimbotKey"] then
        if Aimbot then
            GUI.AimbottingLabel.Text = "Aimbot: false"
            Aimbot = false
        else
            GUI.AimbottingLabel.Text = "Aimbot: true"
            Aimbot = true
        end
    end
    if Input.KeyCode.Name == Config["PlayerESPKey"] then
        if PlayerEsp then
            for _,v in pairs(Players:GetPlayers()) do
                if v.Character then
                    local ESPFolder = v.Character:FindFirstChild("ESPFolder" .. v.Name)
                    if ESPFolder then
                        ESPFolder:Destroy()
                    end
                end
            end
            PlayerEsp = false
        else
            for _,v in pairs(ESPPlayers) do
                if v.Character then
                    PlayerEspCreate(v)
                end
            end
            PlayerEsp = true
        end
    end
    if Input.KeyCode.Name == Config["PrefixKey"] then
        GUI.CommandBarFrame.Visible = true
        GUI.CommandBarBox:CaptureFocus()
    end
    if Input.KeyCode.Name == Config["MenuKey"] then
        if Hidden then
            Hidden = false
            GUI.MainFrame.Visible = true
        else
            Hidden = true
            GUI.MainFrame.Visible = false
        end
    end
    if Airwalk then
        if Input.KeyCode == Enum.KeyCode.E then
            HeightValue = HeightValue + .5
        end
        if Input.KeyCode == Enum.KeyCode.Q then
            HeightValue = HeightValue - .5
        end
    end
	if Input.KeyCode == Enum.KeyCode.E then
        Keys["E"] = true
        for i = 1, 3 do
            Wait(.05)
            if not Keys["E"] then
                break
            end
        end
        if Keys["E"] then
            if game.PlaceId == TheStreetsId then
                Player.Backpack.Input:FireServer("drag", {})
            else
                Player.Backpack.ServerTraits.Drag:FireServer(true)
            end
        else
            Stomp()
            if Config["StompSpam"] then
                for i = 1, 30 do
                    Stomp()
                end
            end
		end
	end
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Keys["Mouse2"] = true
	end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        local MouseTarget = Mouse.Target
        if MouseTarget then
            local TargetChar
            if MouseTarget:IsA("Part") and MouseTarget.Name ~= "Handle" or MouseTarget:IsA("Accessory") then
                TargetChar = MouseTarget.Parent
            elseif MouseTarget.Name == "Handle" then
                TargetChar = MouseTarget.Parent.Parent
            elseif MouseTarget.Name == "Roblex" and MouseTarget:IsA("Model") then
                TargetChar = MouseTarget.Parent.Parent
            else
                TargetChar = MouseTarget.Parent
            end
            if TargetChar:FindFirstChild("Humanoid") then
                AimbotPlayer = Players:GetPlayerFromCharacter(TargetChar)
                GUI.CurrentTargetLabel.Text = "Current Target: " .. AimbotPlayer.Name
            end
        end
		Keys["Mouse1"] = true
        if SelectedTool then
            Attack()
		else
            if MouseTarget and MouseTarget:FindFirstChild("ClickDetector") then
                local Door = MouseTarget.Parent
                local Locker = Door:FindFirstChild("Locker")
                local Lock = Door:FindFirstChild("Lock") 
                local Click = Door:FindFirstChild("Click")
                if Config["AutoUnlock"] then
                    if Locker and Lock then
                        if Locker.Value == true then
                            local r2 = Lock:FindFirstChildOfClass("ClickDetector"):FindFirstChildOfClass("RemoteEvent")
                            if r2 then
                                r2:FireServer()
                                if Click then
                                    local OpenEvent = Click:FindFirstChild("ClickDetector"):FindFirstChild("RemoteEvent")
                                    if OpenEvent then
                                        OpenEvent:FireServer()
                                    end
                                end
                            end
                        end
                    end
                end
                if MouseTarget.ClickDetector:FindFirstChild("RemoteEvent") then
                    if MouseTarget ~= Click:FindFirstChild("ClickDetector"):FindFirstChild("RemoteEvent") then
                        MouseTarget.ClickDetector.RemoteEvent:FireServer()
                    end
				end
                if Config["AutoLock"] then
                    if Locker and Lock then
                        if Locker.Value == false then
                            local r = Lock:FindFirstChild("ClickDetector"):FindFirstChild("RemoteEvent")
                            r:FireServer()
                        end
                    end
                end
				if MouseTarget.Name == "Peep" then
					Camera.CameraType = "Scriptable"
					Camera.CoordinateFrame = CFrame.new(MouseTarget.Position + MouseTarget.CFrame.lookVector * 0.5, MouseTarget.Position + MouseTarget.CFrame.lookVector * 2 - Vector3.new(0, 0.5, 0))
					Camera.FieldOfView = 120
					ReturnCam()
				end
			end
		end
    end
	if Input.KeyCode == Enum.KeyCode.W then
		Keys["W"] = true
	end
	if Input.KeyCode == Enum.KeyCode.A then
		Keys["A"] = true
	end
	if Input.KeyCode == Enum.KeyCode.D then
		Keys["D"] = true
	end
	if Input.KeyCode == Enum.KeyCode.S then
        Keys["S"] = true
        if not Config["NoStop"] then
            RunAnim:Stop()
            Running = false
        end
	end
    if Input.KeyCode == Enum.KeyCode.Space then
		Keys["Space"] = true
    end
    if Flying then
        if Input.KeyCode == Enum.KeyCode.W then
            Control.F = Config["FlySpeed"]
        elseif Input.KeyCode == Enum.KeyCode.S then
            Control.B = - Config["FlySpeed"]
        elseif Input.KeyCode == Enum.KeyCode.A then
            Control.L = - Config["FlySpeed"]
        elseif Input.KeyCode == Enum.KeyCode.D then 
            Control.R = Config["FlySpeed"]
        end
    end
    for _,v in pairs(Settings["Binds"]) do
		local CurrentKey = string.match(v, "[%a%d]+$")
		if string.len(CurrentKey) == 1 then
			if Key == string.sub(v, #v, #v) then
                local CommandToExecute = string.match(v, "^[%w%s]+")
                print("Check Complete")
                ExecuteCommand(Config["PrefixKey"] .. tostring(CommandToExecute))
			end
		else
			if string.lower(string.sub(tostring(CurrentKey), 1, 1)) == "f" then
				local CommandToExecute = string.match(v, "^[%w%s]+")
				local HotkeyAdjust = tonumber(string.sub(CurrentKey, 2, 3)) + 25
				if string.byte(Key) == HotkeyAdjust then
                    ExecuteCommand(Config["PrefixKey"] .. tostring(CommandToExecute))
				end
			end
		end
    end
end)

UIS.InputEnded:Connect(function(Input, GameProcess)
    if Input.KeyCode == Enum.KeyCode.LeftShift then
		Keys["Shift"] = false
    end
    if Input.KeyCode == Enum.KeyCode.LeftControl then
		Keys["Control"] = false
        CrouchAnim:Stop()
        if game.PlaceId == ThePrisonId then
            Player.Backpack.ServerTraits.Crouch:FireServer(true)
        end
    end
    if Sliding and Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Sliding = false
        SliderButton = nil
        Slider = nil
        SliderData = nil
    end
    if GameProcess then
        return
    end
	if Input.KeyCode == Enum.KeyCode.S then
		Keys["S"] = false
	end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if SelectedTool ~= nil and SelectedTool:FindFirstChild("Ammo") and Input.UserInputType == Enum.UserInputType.Touch then
			return
        end
        if game.PlaceId == TheStreetsId then
            Player.Backpack.Input:FireServer("moff1", {
                mousehit = Mouse.Hit,
                shift = Keys["Shift"],
                velo = Player.Character.HumanoidRootPart.Position.magnitude,
            })
        end
    end
    if Input.KeyCode == Enum.KeyCode.E then
        if game.PlaceId == TheStreetsId then
            Player.Backpack.Input:FireServer("dragoff", {})
        else
            if Player.Character:FindFirstChild("Dragging") then
                Player.Backpack.ServerTraits.Drag:FireServer(false)
            end
        end
		Keys["E"] = false
    end
	if Input.KeyCode == Enum.KeyCode.W then
		Keys["W"] = false
	end
	if Input.KeyCode == Enum.KeyCode.A then
		Keys["A"] = false
	end
	if Input.KeyCode == Enum.KeyCode.D then
		Keys["D"] = false
	end
	if Input.KeyCode == Enum.KeyCode.S then
		Keys["S"] = false
    end
    if Input.KeyCode == Enum.KeyCode.Space then
		Keys["Space"] = false
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Keys["Mouse1"] = false
	end
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Keys["Mouse2"] = false
    end
    if Airwalk then
        if Input.KeyCode == Enum.KeyCode.E then
            HeightValue = HeightValue - .5
        end
        if Input.KeyCode == Enum.KeyCode.Q then
            HeightValue = HeightValue + .5
        end
    end
    if Flying then
        if Input.KeyCode == Enum.KeyCode.W then
            Control.F = 0
        elseif Input.KeyCode == Enum.KeyCode.S then
            Control.B = - 0
        elseif Input.KeyCode == Enum.KeyCode.A then
            Control.L = - 0
        elseif Input.KeyCode == Enum.KeyCode.D then 
            Control.R = 0
        end
    end
end)

local LastIteration, Start
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function(Delta)
    if Sliding then
        local MousePosition = UIS:GetMouseLocation().X
        local ButtonPosition = SliderButton.Position
        local SliderPosition = Slider.AbsolutePosition.X
        local SliderSize = Slider.AbsoluteSize.X
        local Position = SliderStep((MousePosition - SliderPosition) / SliderSize, SlidingStep)
        local Percentage = math.clamp(Position, 0, 1)
        SliderData.Text = math.floor(Percentage * 100)
        UpdateSliderInfo(Slider, tonumber(SliderData.Text))
        SliderButton.Position = UDim2.new(Percentage, 0, ButtonPosition.Y.Scale, ButtonPosition.Y.Offset)
    end
    HumanoidRootPart = Player.Character:WaitForChild("HumanoidRootPart", 2)
    if HumanoidRootPart and Config["Blink"] and Keys["Shift"] then
        Player.Character.Humanoid.WalkSpeed = 0
        Player.Character.Humanoid.JumpPower = 0
        if Keys["W"] then
    		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config["BlinkSpeed"])
    	end 
        --[[
        if Keys["A"] then
    		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(-Config["BlinkSpeed"], 0, 0)
    	end
        if Keys["S"] then
    		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, Config["BlinkSpeed"])
    	end
        if Keys["D"] then
    		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(Config["BlinkSpeed"], 0 ,0)
        end
        --]]
        if Keys["Space"] then
    		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, Config["BlinkSpeed"] / 2, 0)
    	end
    end
	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end
	FrameUpdateTable[1] = LastIteration
	local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
    CurrentFPS = math.floor(CurrentFPS)
    if not Ping then
        Ping = 0
    end
	GUI.WatermarkDataLabel.Text = "Identification | " .. Market:GetProductInfo(game.PlaceId).Name .. " | fps: " .. tostring(CurrentFPS):sub(1, 3) .. " | ping: " .. Ping .. "ms"
    StarterGui:SetCore("ResetButtonCallback", true)
    Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    local HumSpeed = Config["WalkSpeed"]
    if Player.Character.Humanoid.Sit and not Player.Character.Humanoid.PlatformStand then
        Player.Character.Humanoid.AutoRotate = false
    else
        Player.Character.Humanoid.AutoRotate = true
    end
    if Keys["Shift"] and not Keys["S"] and HumanoidRootPart then
        HumSpeed = Config["RunSpeed"]
        if not Running and HumanoidRootPart.Velocity.magnitude > 2 then
            Running = true
            RunAnim:Play(0.1, 1, 1.2)
        elseif Running and HumanoidRootPart.Velocity.magnitude < 2 then
            RunAnim:Stop()
            Running = false
        end
    elseif Running then
        Running = false
        RunAnim:Stop()
    end
    if Keys["Control"] or Crouching then
        HumSpeed = Config["CrouchSpeed"]
        CrouchAnim:AdjustSpeed(HumanoidRootPart.Velocity.magnitude / 10)
    end
    Player.Character.Humanoid.JumpPower = Config["JumpPower"]
    if game.PlaceId == TheStreetsId then
        if TagSystem.has(Character, "action") or TagSystem.has(Character, "Action") then
            if Config["ActionSpeed"] ~= nil then
                HumSpeed = Config["ActionSpeed"]
            end
        end
    end
    if NoWalkMode then
        Player.Character.Humanoid.WalkSpeed = 0
    else
        Player.Character.Humanoid.WalkSpeed = HumSpeed
    end
    if not AimbotPlayer then
        GUI.CurrentTargetLabel.Text = "Current Target: nil"
        AimbotPlayer = nil
    end
    if Aimbot and Config["Aimlock"] and AimbotPlayer ~= nil and AimbotPlayer.Character and AimbotPlayer.Character:FindFirstChild("Head") and AimbotPlayer.Character:FindFirstChild("Torso") then
        if AimbotPlayer.Character:FindFirstChildOfClass("Humanoid") and AimbotPlayer.Character.Humanoid.Health == 0 then return end
        local HitPart = AimbotPlayer.Character:FindFirstChild(Config["AimbotTarget"])
        local EnemyVelocity = HitPart.Velocity
        if SelectedTool and AimbotPlayer and AimbotPlayer.Character then
            local PingToHit
            if Ping < 50 then
                PingToHit = 3
            elseif Ping < 85 then
                PingToHit = 3.5
            elseif Ping < 120 then
                PingToHit = 4
            elseif Ping < 155 then
                PingToHit = 4.5
            elseif Ping < 190 then
                PingToHit = 5
            elseif Ping < 235 then
                PingToHit = 5.5
            elseif Ping < 260 then
                PingToHit = 6
            elseif Ping < 295 then
                PingToHit = 6.5
            elseif Ping < 330 then
                PingToHit = 7
            elseif Ping < 365 then
                PingToHit = 7.5
            elseif Ping < 400 then
                PingToHit = 8
            elseif Ping < 435 then
                PingToHit = 8.5
            else
                PingToHit = 9
            end
            ToHit = HitPart.Position + EnemyVelocity / PingToHit
            ToHit = CFrame.new(ToHit)
            if HitPart then
                Camera.CoordinateFrame = CFrame.new(Camera.CoordinateFrame.p, ToHit.p)
            else
                local Head = AimbotPlayer.Character:FindFirstChild("Head")
                local Torso = AimbotPlayer.Character:FindFirstChild("Torso") or AimbotPlayer.Character:FindFirstChild("HumanoidRootPart")
                local Arms = AimbotPlayer.Character:FindFirstChild("Right Arm") or AimbotPlayer.Character:FindFirstChild("Left Arm")
                local Legs = AimbotPlayer.Character:FindFirstChild("Right Leg") or AimbotPlayer.Character:FindFirstChild("Left Leg")
                if Head then
                    HitPart = Head
                elseif Torso then
                    HitPart = Torso
                elseif Arms then
                    HitPart = Arms
                elseif Legs then
                    HitPart = Legs
                end
                ToHit = HitPart.Position + EnemyVelocity / PingToHit
                ToHit = CFrame.new(ToHit)
                Camera.CoordinateFrame = CFrame.new(Camera.CoordinateFrame.p, ToHit.p)
            end
        end
    end
    if SelectedTool then
        if not SelectedTool:FindFirstChild("Ammo") and SelectedTool:FindFirstChild("Info") then
            if Config["AutoStomp"] then
                if Player.Character then
                    for _,v in pairs(Players:GetPlayers()) do
                        if not table.find(Config["Whitelisted"], v) then
                            if v ~= Player and v.Character and v.Character:FindFirstChild("Torso") and v.Character:FindFirstChild("Bone", true) and not v.Character:FindFirstChild("Dragged") then
                                if (v.Character.Torso.Position - Player.Character.HumanoidRootPart.Position).magnitude < Config["AutoStompDistance"] and v.Character.Humanoid.Health ~= 0 then
                                    Player.Character.HumanoidRootPart.CFrame = v.Character.Torso.CFrame
                                    Stomp()
                                end
                            end
                        end
                    end
                end
            end
        end
        if SelectedTool:FindFirstChild("Ammo") then
            if Config["AutoFire"] then
                if Player.Character then
                    for _,v in pairs(Players:GetPlayers()) do
                        if not table.find(Config["Whitelisted"], v) then
                            if v ~= Player and AimbotPlayer and v.Character and v.Charcater:FindFirstChild(Config["AimbotTarget"]) then
                                local HitPart = v.Charcater:FindFirstChild(Config["AimbotTarget"])
                                local Length = (Player.Character.HumanoidRootPart.Position - HitPart.Position).Unit
                                local Ray = Ray.new(HitPart.Position, HitPart.CFrame.LookVector * Length)
                                local Wall, HitPosition, Normal, Material = workspace:FindPartOnRayWithWhitelist(Ray, {PlayersInterior.Build.InteriorElements})
                                if not Wall then
                                    Wait(.05)
                                    Attack()
                                end
                            end
                        end
                    end
                end
            end
            if SelectedTool.Name == "Uzi" and SelectedTool.Ammo.Value > 0 and Keys["Mouse1"] then
                Wait(.025)
                Attack()
            end
            if Invisible then
                SelectedTool.Grip = worldCF:ToWorldSpace(Player.Character.HumanoidRootPart.CFrame)
            end
            if AttachGun and AttachGunTarget and AttachGunTarget.Character and AttachGunTarget.Character:FindFirstChild("HumanoidRootPart") then
                SelectedTool.Grip = worldCF:ToWorldSpace(AttachGunTarget.Character.HumanoidRootPart.CFrame)
            end
            if RemoteGun then
                Camera.CameraSubject = SelectedTool:FindFirstChild("Handle")
                if Keys["W"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new((Config["RemoteGunSpeed"] / 10) * -1, (Config["RemoteGunSpeed"] / 10) * -1, Config["RemoteGunSpeed"])
                end
                if Keys["A"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new(Config["RemoteGunSpeed"], 0, 0)
                end
                if Keys["S"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new((Config["RemoteGunSpeed"] / 10), (Config["RemoteGunSpeed"] / 10), -Config["RemoteGunSpeed"])
                end
                if Keys["D"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new(-Config["RemoteGunSpeed"], 0, 0)
                end
                if Keys["Space"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new(0, -Config["RemoteGunSpeed"], 0)
                end
                if Keys["Shift"] then 
                    SelectedTool.Grip = SelectedTool.Grip * CFrame.new(0, Config["RemoteGunSpeed"], 0)
                end
            else
                Camera.CameraSubject = Player.Character.Humanoid
            end
            if Config["Triggerbot"] then
                
            end
        end
    end
    settings().Physics.AllowSleep = false
    Player.MaximumSimulationRadius = math.huge
    setsimulationradius(math.huge)
end)

Start = tick()

if Config["Watermark"] then
    game:GetService("CoreGui"):WaitForChild("TopBar").TopBarFrame.RightFrame.HealthBar:Destroy()
end

if Config["ItemEsp"] then
    ItemEsp()
end

if Config["ShowAmmo"] then
    CreateAmmoLabel(Player.PlayerGui.HUD)
    local Ammo
    if SelectedTool then
        Ammo = SelectedTool:FindFirstChild("Ammo")
    end
    if SelectedTool and Ammo then
        SelectedTool.Ammo.Changed:Connect(function()
            if Ammo then
                AmmoLabel.Text = SelectedTool.Ammo.Value .. " Ammo"
            end
        end)
        AmmoLabel.Text = SelectedTool.Ammo.Value .. " Ammo"
        AmmoLabel.Visible = true
    end
end

Player.PlayerGui.Chat.Frame.Active = true
Player.PlayerGui.Chat.Frame.Draggable = true
Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Position = Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(0, 0),Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Size.Y)
Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Size = UDim2.new(1, 0, 1, -46)
Player.PlayerGui.Chat.Frame.Position = UDim2.new(0, 0, 0, 145)

while Wait(.05) do
    local PingTick = tick()
    game:GetService("RobloxReplicatedStorage").GetServerVersion:InvokeServer()
    Ping = tick() - PingTick
    Ping = math.floor(Ping * 1000)
end
