--[[ TO DO:
Main Things > Configs, ESP, Code clean / Bug fixes
might be mem leak since gcinfo can go upto 100k+? maybe Lol
Performance Tests

fix set bar points on esp bars

esp fix; breaks idk
ammo text?
chams

SetVisibles for refreshmenusS
fix animations and animations refresh menu

menu clamping on bar indicator
indicator frame size off?

Right / Bottom bar position might be broken

add \n support for Clan Tag Tag
fix clan tag  animations (Forward, Normal, Reverse)

Auto Attack
Auto Fire Raycast hitpoints fix
Compare (Bullet_EndPosition - Shot(CFrame.Position)).Magnitude
SetPlayerChams ignore tools and other shit; fixed? i don't Know?
Menu fix on ???? WHAT AM I TALKING ABOUT WHAT DOES THIS MEAN

bar fade broken?
fix hidesprays


small spray & small boombox(maybe no need cuz we log audios already) library ui to find ids easily?

players list; fixed?
fix whitelist; owner only work on rejoin
GetCars?

custom models; umm maybe not Lo.
local chams overlay; lazy

Gun Chams Fix UsePartColor; fixed?

GetPlayer??
Nixon Drawing Library Straw Hat
The TF2 Spin Crosshair

Aimbot Auto Adjust Vector Velocity
Wireframe chams?
Gun outline chams

AntiAim:Desync (checkbox); Velocity (checkbox); remove only 1 type at a time
Resync Desynced antiaim
desync visualization is not happening since it's different for every client (I think)
Flipped Mode 

Brick Trajectory prediction LOL?
Animations Container
menu accent on ["on"] for keybinds while they are on
Replace gun animation ids with New ones
Remake bind system?
ADD TARGET INDICATORS local TargetInfo = Menu.Indicators()
Audio Play List, plays a new song when u die || when the song finishes || Maybe audio search func like the audio library
Crouch Remote True: Hides Name + Health || False: Shows Name + Health (ForceHideName) Disabled due to snake being retarded, but keeping this since he might add the feature back
FIX FLY DOUBLE KEY HOLD?
HIT DETECTION STILL SUCKS NUTS (RayCast Fix)

Silent Animation Table Check
]]

-- Fake Roblex : 6029419 && Roblex : 6029417 && Platinum Rolex : 6094781
-- Original cash timer 10$ every 1 minute or 14440 cash every day

-- Variables

local Time = os.clock()
if not game:IsLoaded() then game.Loaded:Wait() end


local wait = task.wait
local delay = task.delay
local spawn = task.spawn
local request = request or syn and syn.request or http and http.request
local secure_call = secure_call or syn and syn.secure_call or function(f, _, ...) return f(...) end -- Meh
local get_custom_asset = getcustomasset or syn and getsynasset
local queue_on_teleport = queue_on_teleport or syn and syn.queue_on_teleport
local websocket_connect = WebSocket and WebSocket.connect or syn and syn.websocket and syn.websocket.connect
local math_round = function(Number, Scale)
    return tonumber(string.format("%." .. Scale .. "f", Number))
end
local messagebox = messagebox or message_box or function()
    pcall(function()
        local Player = game:GetService("Players").LocalPlayer
        Player:Kick("Error 0x4; Executor doesn't support script functionality") -- if you bypass this and u get banned don't blame me
        game:shutdown()
    end)
end
local get_script_version = function()
    return "1.0.0"
end


local Stats = game:GetService("Stats")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Physics = game:GetService("PhysicsService")
local Lighting = game:GetService("Lighting")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Marketplace = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local NetworkClient = game:GetService("NetworkClient")
local ScriptContext = game:GetService("ScriptContext")
local ContextAction = game:GetService("ContextActionService")
local InsertService = game:GetService("InsertService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--[[
local WebSocketClient
pcall(function()
    WebSocketClient = websocket_connect and websocket_connect("wss://identification.glitch.me/", {
        headers = {
            ["user-agent"] = "Mozilla",
        }
    })
end)
]]


if not Import then return messagebox("Error 0x5; Something went wrong with initializing the script (couldn't load modules)", "Identification.cc", 0) end

local ESP
local Menu
local Console
local Commands
local ToolData
local DoorData

-- Importing the modules and yielding until they are loaded

spawn(function() ESP = Import("ESP") end)
spawn(function() Menu = Import("Menu") end)
spawn(function() Console = Import("Console") end)
spawn(function() Commands = Import("Commands") end)
spawn(function() ToolData = Import("Tool Data") end)
spawn(function() DoorData = Import("Door Data") end)

while not ESP or not Menu or not Console or not Commands or not ToolData or not DoorData do wait() end -- waiting for the modules to load...
getgenv().Import = nil  -- won't be used anymore


local Original = game.PlaceId == 455366377 and true


if not Original and game.PlaceId ~= 4669040 then
    return messagebox("Error 0x1; Place not supported", "Identification.cc", 0) -- why is the 2nd parameter title??
end

if (Original and game.PlaceVersion ~= 1508) or (not Original and game.PlaceVersion ~= 217) then
    return messagebox("Error 0x2; Script is not up to date with place version", "Identification.cc", 0)
end

if _G.Identification then
    return messagebox("Error 0x3; Script is already running", "Identification.cc", 0)
end


local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player:WaitForChild("Backpack")
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")
local Root = Humanoid.RootPart
local Tool = Character:FindFirstChildOfClass("Tool")
local PlayerGui = Player:WaitForChild("PlayerGui")
local HUD = PlayerGui and PlayerGui:WaitForChild("HUD")
local Camera = workspace.CurrentCamera
local TagSystem = Original and require(ReplicatedStorage:WaitForChild("TagSystem")) -- "creator" || "creatorslow" || "gunslow" || "action" || "Action" || "KO" || "Dragged" || "Dragging" || "reloading" || "equipedgun" || yes with 1 p he's retarded

_G.Identification = true

-- Config


local Config = {
    Aimbot = {
        Enabled = false,
        CollisionCheck = true, -- turn off if player is no-clipping?
        Visualize = false,
        TargetSelection = "Near Mouse",
        HitBox = "Torso",
        Radius = 100,
        Key = nil
    },
    AutoFire = {
        Enabled = false,
        Range = 50,
        Priority = "Head",
        Key = nil
    },
    CameraLock = {
        Enabled = false,
        Key = nil
    },
    Guns = {
        Glock = {
            HitBox = "Head"
        },
        Uzi = {
            HitBox = "Head"
        },
        Shotty = {
            HitBox = "Torso"
        },
        ["Sawed Off"] = {
            HitBox = "Torso"
        }
    },
    AlwaysGroundHit = {Enabled = false},
    StompSpam = {
        Enabled = false,
        Amount = 30
    },
    AutoStomp = {
        Enabled = false,
        Distance = 25,
        Target = "All",
        Key = nil
    },
    BulletTracers = { -- Technically beams But shut up
        Enabled = false,
        Color = Color3.new(1, 1, 1),
        Lifetime = 1,
        DisableTrails = false
    },
    BulletImpact = {
        Enabled = false,
        Color = Color3.new(1, 1, 1)
    },
    AntiAim = { -- Sorry what?
        Enabled = false,
        FakeVelocity = false,
        Desync = false,
        Key = nil
    },
    Flight = {
        Enabled = false,
        Rotation = true,
        Speed = 1,
        Key = nil
    },
    Blink = {
        Enabled = false,
        Speed = 1,
        Key = nil
    },
    Float = {
        Enabled = false,
        Key = nil
    },
    Noclip = {
        Enabled = false,
        Key = nil
    },
    RunSpeed = {Value = 24.5},
    WalkSpeed = {Value = 16},
    JumpPower = {Value = 37.5},
    CrouchSpeed = {Value = 8},
    NoSlow = {Enabled = false},
    God = {Enabled = false},
    InfiniteForceField = {Enabled = false},
    TeleportBypass = {Enabled = false},
    NoKnockOut = {Enabled = false},
    AntiGroundHit = {Enabled = false},
    AntiFling = {Enabled = false},
    InfiniteJump = {Enabled = false},
    InfiniteStamina = {Enabled = false},
    DeathTeleport = {Enabled = false},
    BrickTrajectory = {
        Enabled = true,
        Color = Color3.new(1, 1, 1),
        Transparency = 1
    },
    FakeLag = {
        Enabled = false,
        Visualize = false,
        Color = Color3.new(1, 1, 1),
        Transparency = 1,
        Limit = 0.3
    },
    Flipped = {Enabled = false},
    AutoFarm = {
        Enabled = false,
        Table = {Bat = false, Bottle = false, Brick = false, ["Stop Sign"] = false, ["Golf Club"] = false, Machete = false, Katana = false, Crowbar = false, Cash = true, Uzi = true, Shotty = true, ["Sawed Off"] = true}
    },
    AutoSort = {
        Enabled = false,
        Order = {Punch = false, Knife = false, Jutsu = false, Spray = false, BoomBox = false, Sign = false, Pipe = false, Glock = false, Shotty = false, Lockpick = false}
    },
    AutoCash = {Enabled = false},
    AutoPlay = {Enabled = false},
    AutoReconnect = {Enabled = true},
    AutoHeal = {Enabled = false},
    ClickOpen = {Enabled = false},
    ClickSpam = {Enabled = false},
    DoorAura = {Enabled = false},
    DoorMenu = {Enabled = false},
    EventLogs = {
        Enabled = false,
        Flags = {
            Damage = true,
            Death = false,
            Joined = false,
            Left = false,
            Buy = false,
            ["Picked up"] = false -- randomspawner
        },
        Colors = {
            Hit = Color3.fromRGB(160, 247, 30),
            Miss = Color3.fromRGB(255, 100, 100),
            Death = Color3.fromRGB(255, 100, 100),
            Joined = Color3.fromRGB(160, 247, 30),
            Left = Color3.fromRGB(255, 100, 100),
            Buy = Color3.fromRGB(160, 247, 30),
            Error = Color3.fromRGB(255, 100, 100),
            Success = Color3.fromRGB(160, 247, 30),
            ["Picked up"] = Color3.fromRGB(160, 247, 30)
        }
    },
    LagOnDragged = {Enabled = false},
    HideSprays = {Enabled = false},
    OpenDoors = {Enabled = false},
    CloseDoors = {Enabled = false},
    KnockDoors = {Enabled = false},
    NoDoors = {Enabled = false},
    NoSeats = {Enabled = false},
    Animations = {
        Run = {
            Enabled = false,
            Style = "Default"
        },
        Glock = {
            Enabled = false,
            Style = "Default"
        },
        Uzi = {
            Enabled = false,
            Style = "Default"
        },
        Shotty = {
            Enabled = false,
            Style = "Default"
        },
        ["Sawed Off"] = {
            Enabled = false,
            Style = "Default"
        }
    },
    Cars = {
        Enabled = false,
        Speed = 0,
        Height = 0
    },
    Attach = {
        Enabled = false,
        RefreshRate = 0
    },
    Follow = {Enabled = false},
    HatChanger = {
        Enabled = false,
        Color = Color3.new(1, 1, 1),
        Speed = 0,
        Sequence = false -- Cheat's sequence
    },
    ClanTag = {
        Enabled = false,
        Visualize = false,
        Tag = "pony-hook.pw",
        Type = "Static", --Forward || Reverse || Static || Blink || Normal || Cheat || Sequences({Tag = "nigger"}, {Tag=  "balls"}) || Boombox || Wave test 
        Prefix = "",
        Suffix = "",
        SpotifyToken = "",
        Speed = 0.2
        -- Maybe animation rules like "balls neverlose.cc": animate at #"balls" + 1 to #tag default 0 to #tag
    },
    ESP = {
        Enabled = false,
        ForceTarget = false, -- Only ESPs on Target
        TargetOverride = {
            Enabled = true,
            Color = Color3.new(1, 0, 0)
        },
        WhitelistOverride = {
            Enabled = true,
            Color = Color3.new()
        },
        Chams = {
            Enabled = false,
            Color = Color3.fromRGB(150, 120, 210),
            OutlineColor = Color3.new(),
            OutlineAutoColor = false,
            Transparency = 0,
            OutlineTransparency = 0,
            RenderMode = "Default",

            KnockedOut = {
                Enabled = false,
                Color = Color3.fromRGB(115, 15, 215),
                Material = "ForceField",
                Reflectance = 0,
                Transparency = 0
            },
            Local = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Material = "Plastic",
                Reflectance = 0,
                Transparency = 0
            }
        },
        Skeleton = {
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            Transparency = 1
        },
        Box = {
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            Transparency = 1,
            Type = "Default"
        },
        Bars = {
            Health = {
                Enabled = false,
                AutoColor = true, -- Based on the Player Health Red Low | Green High
                Position = "Left", -- Left, Right, Top, Bottom
                Color = Color3.new(1, 1, 1),
                Transparency = 1
            },
            KnockedOut = {
                Enabled = false,
                Position = "Top",
                Color = Color3.new(0, 0, 1),
                Transparency = 1
            },
            Ammo = {
                Enabled = false,
                Position = "Left",
                Color = Color3.new(1, 1, 1),
                Transparency = 1
            }
        },
        Snaplines = {
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            Transparency = 1,
            OffScreen = false
        },
        Arrows = {
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            Transparency = 1,
            Offset = 15
        },
        Font = {
            Font = "Plex",
            Size = 13,
            Color = Color3.new(1, 1, 1),
            Transparency = 1
        },
        Flags = {
            Name = {
                Enabled = false,
                Type = "User", -- User, Display
                Offset = Vector2.new(0, 3)
            },
            Weapon = {
                Icon = { -- ToolData["Knife"].Icon
                    Enabled = false,
                    Offset = Vector2.new(0, -3),
                    Color = Color3.new(1, 1, 1)
                },
                Text = { -- Weapon : Knife
                    Enabled = false,
                    Offset = Vector2.new(0, -5)
                }
            },
            Ammo = { -- Ammo : 8;5 (ammo, clips)
                Enabled = false,
                Offset = Vector2.new(0, -6)
            },
            Vest = {
                Enabled = false,
                Offset = Vector2.new(0, 5)
            },
            Health = { -- Health : 100
                Enabled = false,
                Offset = Vector2.new(3, 1),
                Color = Color3.new(0, 1, 0)
            },
            Stamina = { -- Stamina : 100
                Enabled = false,
                Offset = Vector2.new(3, 0),
                Color = Color3.new(0, 1, 0)
            },
            KnockedOut = { -- Knocked Out: 12.00
                Enabled = false,
                Offset = Vector2.new(3, -1),
                Color = Color3.new(0, 0, 1)
            },
            Distance = { -- Distance: 200 studs
                Enabled = false,
                Offset = Vector2.new(3, -2)
            },
            Velocity = { -- Velocity: getVelocity(p).Magnitude
                Enabled = false,
                Offset = Vector2.new(3, -3)
            }
        },
        Item = {
            Enabled = false,

            Snaplines = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Transparency = 1
            },
            Font = {
                Font = "Plex",
                Size = 13,
                Color = Color3.new(1, 1, 1),
                Transparency = 1
            },
            Flags = {
                Icon = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Name = {
                    Enabled = false,
                    Offset = Vector2.new(0, 3)
                },
                Distance = {
                    Enabled = false,
                    Offset = Vector2.new(0, -3)
                }
            }
        }
    },
    GunChams = {
        Enabled = false,
        Color = Color3.new(1, 1, 1),
        Material = "ForceField",
        Reflectance = 0,
        Transparency = 0
    },
    FieldOfView = {
        Enabled = false,
        Value = 70
    },
    View = {Enabled = false},
    Zoom = {
        Enabled = false,
        Value = 10
    },
    FirstPerson = {Enabled = false},
    HitMarkers = {
        Enabled = false,
        Fade = true,
        Color = Color3.new(1, 1, 1),
        Transparency = 1,
        Size = 5,
        Type = "Crosshair" -- Model
    },
    HitSound = {Enabled = false},
    Enviorment = {
        Time = {
            Enabled = false,
            Value = 0
        },
        Saturation = {
            Enabled = false,
            Value = 0
        },
        Ambient = {
            Enabled = false,
            [1] = {
                Color = Color3.new(1, 1, 1)
            },
            [2] = {
                Color = Color3.new(1, 1, 1)
            }
        },
        Skybox = {
            Enabled = false,
            Value = "None" --[[ Winter {
                SkyboxUp = "rbxassetid://7307290025"
                MoonTextureId = "rbxassetid://6444320592"
                SkyboxLf = "rbxassetid://7307284944"
                SkyboxBk = "rbxassetid://7307273436"
                SunTextureId = "rbxassetid://6196665106"
                SunAngularSize = 11
                SkyboxDn = "rbxassetid://7307275898"
                SkyboxRt = "rbxassetid://7307287254"
                SkyboxFt = "rbxassetid://7307282434"
        }]]
        }
    },
    Interface = {
        BarFade = {Enabled = false},
        RemoveUIElements = {Enabled = false},
        Chat = {Enabled = false},
        Watermark = {
            Enabled = false,
            Position = Vector2.new()
        },
        Indicators = {
            Enabled = false,
            Position = Vector2.new(),
            Flags = {
                Health = false,
                Stamina = false,
                KnockedOut = true,
                --GunCooldown = false, --(Tool.Info.Cooldown) Lol
                Target = false,
                FakeVelocity = false,
                --FakeLag = false,
                --AntiGroudHit = false,

            }
        },
        Keybinds = {
            Enabled = false,
            Position = Vector2.new()
        },
        FieldOfViewCircle = {
            Enabled = false,
            Filled = true,
            NumSides = 8,
            Color = Color3.new(),
            Transparency = 0.8,
            Thickness = 1
        },
        ShowAmmo = {Enabled = false}
    },

    Keybinds = {
        Commands = {},
    },
    Console = {Accent = "Cyan"},
    Menu = {
        Accent = Color3.new(0.3, 0, 1),
        Size = Vector2.new(500, 550),
        Key = Enum.KeyCode.Delete
    },
    Prefix = Enum.KeyCode.Quote
}

-- Initialize Localization

local Threads = {}
local Events = {FirstPerson = {}, Reset = nil}

local UserTable = {
    Admin = {
        [1892264393] = {
            Tag = "Elden",
            Color = Color3.fromRGB(115, 65, 190)
        },
        [156878502] = {
            Tag = "f6oor",
            Color = Color3.fromRGB(40, 80, 180)
        },
        [1552377192] = {
            Tag = "nixon",
            Color = Color3.fromRGB(40, 40, 40)
        },
        [481234921] = {
            Tag = "reestart",
            Color = Color3.fromRGB(105, 200, 40)
        },
        [1395537172] = {
            Tag = "xaxa",
            Color = Color3.fromRGB(210, 60, 75)
        }
    },
    Owners = {}, -- Bot usage
    Whitelisted = {} -- aimbot no target friends
}
UserTable.Whitelisted = isfile("Identification/Games/The Streets/Whitelist.dat") and string.split(readfile("Identification/Games/The Streets/Whitelist.dat"), "\n") or {}
UserTable.Owners = isfile("Identification/Games/The Streets/Owners.dat") and string.split(readfile("Identification/Games/The Streets/Owners.dat"), "\n") or {}


local Items = {}
local Seats = {}
local Doors = {}
local Drawn = {}
local Timers = {}
local Windows = {}
local Animations = {}
local AudioLogs = isfile("Identification/Games/The Streets/Audios.dat") and string.split(readfile("Identification/Games/The Streets/Audios.dat"), "\n") or {}
local DamageLogs = {} -- debounce
local ChatScheduler = {}

local BuyPart
local Target
local TargetLock
local SelectedTarget
local HitSound
local Crosshair

local CustomCharacter
local FloatPart
local FlyVelocity
local FlyAngularVelocity
local BrickTrajectory = ESP.Trajectory()
local FakeLagVisualizer = ESP.Skeleton()

local AimbotIndicator
local FieldOfViewCircle

local script_version = get_script_version()

local Ping = 0
local SendPing = 0
local ReceivePing = 0
local LastAudio = 0
local BulletTick = 0

local Buying = false
local Healing = false
local Dragged = false
local Running = false
local Dragging = false
local Spamming = false
local Crouching = false
local BarsFading = false
local Teleporting = false
local RefreshingCharacter = false

local DeathPosition = CFrame.new()
local AimbotVectorVelocityAmplifier = Vector3.new(2, 0, 2)

do
    CustomCharacter = Instance.new("Model")
    FloatPart = Instance.new("Part")
    FlyVelocity = Instance.new("BodyVelocity")
    FlyAngularVelocity = Instance.new("BodyAngularVelocity")

    FieldOfViewCircle = Drawing.new("Circle")
    
    Events.Reset = Instance.new("BindableEvent")
    
    Menu.Watermark = Menu.Watermark()
    Menu.Indicators = Menu.Indicators()
    Menu.Keybinds = Menu.Keybinds()
    Menu.BoomboxFrame = Instance.new("Frame")
    Menu.CommandBar = Instance.new("TextBox")

    local SubFolder = "Identification/Games/The Streets/"

    if not isfolder("Identification") then makefolder("Identification") end
    if not isfolder("Identification/Games") then makefolder("Identification/Games") end
    if not isfolder("Identification/Games/The Streets") then makefolder("Identification/Games/The Streets") end
    if not isfolder(SubFolder .. "bin") then makefolder(SubFolder .. "bin") end
    if not isfolder(SubFolder .. "Luas") then makefolder(SubFolder .. "Luas") end
    if not isfolder(SubFolder .. "Configs") then makefolder(SubFolder .. "Configs") end
    if not isfolder(SubFolder .. "bin/sounds") then makefolder(SubFolder .. "bin/sounds") end
    if not isfolder(SubFolder .. "bin/skyboxes") then makefolder(SubFolder .. "bin/skyboxes") end
    if not isfolder(SubFolder .. "bin/crosshairs") then makefolder(SubFolder .. "bin/crosshairs") end
    if not isfolder(SubFolder .. "bin/replays") then makefolder(SubFolder .. "bin/replays") end
    if not isfolder(SubFolder .. "bin/models") then makefolder(SubFolder .. "bin/models") end

    -- We read the values before this
    writefile(SubFolder .. "Whitelist.dat", table.concat(UserTable.Whitelisted, "\n"))
    writefile(SubFolder .. "Owners.dat", table.concat(UserTable.Owners, "\n"))

    if not isfile(SubFolder .. "Spam.dat") then writefile(SubFolder .. "Spam.dat", "") end
    if not isfile(SubFolder .. "bin/sounds/hitsound.mp3") then writefile(SubFolder .. "bin/sounds/hitsound.mp3", "") end
    if not isfile(SubFolder .. "bin/crosshairs/crosshair.png") then writefile(SubFolder .. "bin/crosshairs/crosshair.png", "") end
    if not isfile(SubFolder .. "bin/crosshairs/reload_crosshair.png") then writefile(SubFolder .. "bin/crosshairs/reload_crosshair.png", "") end

    HitSound = get_custom_asset(SubFolder .. "bin/sounds/hitsound.mp3")
    Crosshair = get_custom_asset(SubFolder .. "bin/crosshairs/crosshair.png")
end


-- Functions


function SaveConfig(Name)
    local function Iterate(Table)
        for k, v in pairs(Table) do
            local Type = typeof(v)
            if Type == "table" then
                Iterate(v)
            else
                if Type == "string" or Type == "number" or Type == "boolean" then
                    continue
                else
                    if Type == "Color3" then
                        Table[k] = "#" .. v:ToHex()
                    elseif Type == "EnumItem" then
                        Table[k] = "Enum:Type:" .. tostring(v.EnumType) .. ":Name:" .. v.Name
                    elseif Type == "Vector2" then
                        Table[k] = "Vector2: " .. tostring(v)
                    elseif Type == "Vector3" then
                        Table[k] = "Vector3: " .. tostring(v)
                    end
                end
            end
        end
    end

    local function DeepCopy(Original)
    	local Copy = {}
    	for k, v in pairs(Original) do
    		if typeof(v) == "table" then
    			v = DeepCopy(v)
    		end
    		Copy[k] = v
    	end
    	return Copy
    end


    local ConfigFile = "Identification/Games/The Streets/Configs/" .. Name .. ".cfg"
    local config_clone = DeepCopy(Config)
    Iterate(config_clone)
    writefile(ConfigFile, HttpService:JSONEncode(config_clone))
    Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):SetValue(Name .. ".cfg", GetFiles("Identification/Games/The Streets/Configs").Names)
end


function LoadConfig(Name)
    local function Iterate(Table)
        for k, v in pairs(Table) do
            local Type = typeof(v)
            if Type == "table" then
                Iterate(v)
            else
                if Type == "number" or Type == "boolean" then -- if it's a normal string then it won't pass the true_type check and will continue
                    continue
                else
                    if string.sub(v, 1, 1) == "#" then -- Color3 in hex
                        Table[k] = Color3.fromHex(v)
                    else
                        local true_type = string.match(v, "%w+")
                        if true_type == "Enum" then
                            local Values = string.split(v, ":")
                            local EnumType = Values[3]
                            local EnumName = Values[5]
                            Table[k] = Enum[EnumType][EnumName]
                        elseif true_type == "Vector2" then
                            local Values = string.split(string.match(v, "%-?%d+, %-?%d+"))
                            Table[k] = Vector2.new(Values[1], Values[2])
                        elseif true_type == "Vector3" then
                            local Values = string.split(string.match(v, "%-?%d+, %-?%d+, %-?%d+"))
                            Table[k] = Vector3.new(Values[1], Values[2], Values[3])
                        end
                    end
                end
            end
        end
    end

    local function DeepPatch(Original, Copy)
        for k, v in pairs(Original) do
            if typeof(Copy[k]) == "nil" then
                Copy[k] = v
            end
    		if typeof(v) == "table" then
    			DeepPatch(v, Copy[k] or {})
    		end
    	end
    end

    local ConfigFile = "Identification/Games/The Streets/Configs/" .. Name .. ".cfg"
    local _Config = HttpService:JSONDecode(readfile(ConfigFile))

    Iterate(_Config)
    DeepPatch(Config, _Config) -- if player made a config a while a go and the script got updated then the config will be invalid we need to patch the cfg
    Config = _Config
    
    RefreshMenu()

    ContextAction:BindAction("aimbotToggle", AimbotToggle, false, Config.Aimbot.Key)
    ContextAction:BindAction("AutoFireToggle", AutoFireToggle, false, Config.AutoFire.Key)
    ContextAction:BindAction("cameraLockToggle", CameraLockToggle, false, Config.CameraLock.Key)
    ContextAction:BindAction("flyToggle", FlyToggle, false, Config.Flight.Key)
    ContextAction:BindAction("blinkToggle", BlinkToggle, false, Config.Blink.Key)
    ContextAction:BindAction("floatToggle", FloatToggle, false, Config.Float.Key)
    ContextAction:BindAction("noclipToggle", NoclipToggle, false, Config.Noclip.Key)
    ContextAction:BindAction("antiAimToggle", AntiAimToggle, false, Config.AntiAim.Key)
    ContextAction:BindAction("commandBarToggle", CommandBarToggle, false, Config.Prefix)
    ContextAction:BindAction("menuToggle", MenuToggle, false, Config.Menu.Key)


    pcall(function()
        local ChatFrame = PlayerGui.Chat.Frame.ChatChannelParentFrame
        ChatFrame.Visible = Config.Interface.Chat.Enabled
    end)


    if Original and Config.HatChanger.Enabled then
        local Success, Result = coroutine.resume(Threads.HatChanger)
        if not Success then
            Console:Error("[HAT CHANGER] " .. Result)
        end
    end


    if Original and Config.ClanTag.Enabled then
        local Success, Result = coroutine.resume(Threads.ClanTagChanger)
        if not Success then
            Console:Error("[CLAN TAG] " .. Result)
        end
    end

    if Config.KnockDoors.Enabled then
        local Success, Result = coroutine.resume(Threads.KnockDoors)
        if not Success then
            Console:Error("[KNCOK DOORS] " .. Result)
        end
    end

    if Config.InfiniteForceField.Enabled then
        local Success, Result = coroutine.resume(Threads.InfiniteForceField)
        if not Success then
            Console:Error("[INFINITE FORCEFIELD] " .. Result)
        end
    end

    if Config.FakeLag.Enabled then
        local Success, Result = coroutine.resume(Threads.FakeLag)
        if not Success then
            Console:Error("[FAKE LAG] " .. Result)
        end
    end

    if not Original and Config.ClickSpam.Enabled then
        local Success, Result = coroutine.resume(Threads.ClickSpam)
        if not Success then
            Console:Error("[CLICK SPAM] " .. Result)
        end
    end

    if Config.Attach.Enabled then
        local Success, Result = coroutine.resume(Threads.Attach)
        if not Success then
            Console:Error("[ATTACH] " .. Result)
        end
    end

    if Config.ESP.Chams.Local.Enabled then
        SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
    else
        SetPlayerChams(Player)
    end


    Console.ForegroundColor = Config.Console.Accent
    Mouse.Icon = Crosshair
    UpdateAntiAim()
    UpdateSkybox()
end


function RefreshMenu()
    -- There ARE LIKE 200 MENU ITEMS TO UPDATE???

    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Enabled"):SetValue(Config.Aimbot.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Hotkey", "Aimbot Key"):SetValue(Config.Aimbot.Key)
    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Auto Fire"):SetValue(Config.AutoFire.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Slider", "Auto Fire Range"):SetValue(Config.AutoFire.Range)
    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Camera Lock"):SetValue(Config.CameraLock.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Hotkey", "Camera Lock Key"):SetValue(Config.CameraLock.Key)
    Menu:FindItem("Combat", "Aimbot", "ComboBox", "Target Hitbox"):SetValue(Config.Aimbot.HitBox)
    Menu:FindItem("Combat", "Aimbot", "ComboBox", "Target Selection"):SetValue(Config.Aimbot.TargetSelection)

    Menu:FindItem("Combat", "Other", "CheckBox", "Always Ground Hit"):SetValue(Config.AlwaysGroundHit.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Stomp Spam"):SetValue(Config.StompSpam.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Auto Attack"):SetValue(false)
    Menu:FindItem("Combat", "Other", "CheckBox", "Auto Stomp"):SetValue(Config.AutoStomp.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Stomp Spam"):SetValue(Config.StompSpam.Enabled)
    Menu:FindItem("Combat", "Other", "Slider", "Auto Stomp Range"):SetValue(Config.AutoStomp.Range)
    Menu:FindItem("Combat", "Other", "ComboBox", "Auto Stomp Target"):SetValue(Config.AutoStomp.Target)

    Menu:FindItem("Visuals", "ESP", "CheckBox", "Enabled"):SetValue(Config.ESP.Enabled)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Target Lock"):SetValue(Config.ESP.ForceTarget)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Target Override"):SetValue(Config.ESP.TargetOverride.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Target Override Color"):SetValue(Config.ESP.TargetOverride.Color, 1 - Config.ESP.TargetOverride.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Whitelist Override"):SetValue(Config.ESP.WhitelistOverride.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Whitelist Override Color"):SetValue(Config.ESP.WhitelistOverride.Color, 1 - Config.ESP.WhitelistOverride.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Box"):SetValue(Config.ESP.Box.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Box Color"):SetValue(Config.ESP.Box.Color, 1 - Config.ESP.Box.Transparency)
    Menu:FindItem("Visuals", "ESP", "ComboBox", "Box Type"):SetValue(Config.ESP.Box.Type)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Skeleton"):SetValue(Config.ESP.Skeleton.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Skeleton Color"):SetValue(Config.ESP.Skeleton.Color, 1 - Config.ESP.Skeleton.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Chams"):SetValue(Config.ESP.Chams.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams Color"):SetValue(Config.ESP.Chams.Color, Config.ESP.Chams.Transparency)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams Outline Color"):SetValue(Config.ESP.Chams.OutlineColor, Config.ESP.Chams.OutlineTransparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Chams Auto Outline Color"):SetValue(Config.ESP.Chams.AutoOutlineColor)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Knocked Out Chams"):SetValue(Config.ESP.Chams.KnockedOut.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked Out Chams Color"):SetValue(Config.ESP.Chams.KnockedOut.Color, Config.ESP.Chams.KnockedOut.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Snapline"):SetValue(Config.ESP.Snaplines.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Snapline Color"):SetValue(Config.ESP.Snaplines.Color, 1 - Config.ESP.Snaplines.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Snapline offscreen"):SetValue(Config.ESP.Snaplines.OffScreen)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Health Bar"):SetValue(Config.ESP.Bars.Health.Enabled)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Health Bar Auto Color"):SetValue(Config.ESP.Bars.Health.AutoColor)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Health Bar Color"):SetValue(Config.ESP.Bars.Health.Color, 1 - Config.ESP.Bars.Health.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Knocked Out Bar"):SetValue(Config.ESP.Bars.KnockedOut.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked Out Bar Color"):SetValue(Config.ESP.Bars.KnockedOut.Color, 1 - Config.ESP.Bars.KnockedOut.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Ammo Bar"):SetValue(Config.ESP.Bars.Ammo.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Ammo Bar Color"):SetValue(Config.ESP.Bars.Ammo.Color, 1 - Config.ESP.Bars.Ammo.Transparency)
    Menu:FindItem("Visuals", "ESP", "MultiSelect", "Flags"):SetValue({
        Name = Config.ESP.Flags.Name.Enabled,
        Weapon = Config.ESP.Flags.Weapon.Text.Enabled,
        Ammo = Config.ESP.Flags.Ammo.Enabled,
        Vest = Config.ESP.Flags.Vest.Enabled,
        Health = Config.ESP.Flags.Health.Enabled,
        Stamina = Config.ESP.Flags.Stamina.Enabled,
        ["Knocked Out"] = Config.ESP.Flags.KnockedOut.Enabled,
        Distance = Config.ESP.Flags.Distance.Enabled,
        Velocity = Config.ESP.Flags.Velocity.Enabled
    })
    Menu:FindItem("Visuals", "ESP", "ComboBox", "Font"):SetValue(Config.ESP.Font.Font)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Font Color"):SetValue(Config.ESP.Font.Color, 1 - Config.ESP.Font.Transparency)
    Menu:FindItem("Visuals", "ESP", "Slider", "Font Size"):SetValue(Config.ESP.Font.Size)

    Menu:FindItem("Visuals", "Local ESP", "CheckBox", "Chams"):SetValue(Config.ESP.Chams.Local.Enabled)
    Menu:FindItem("Visuals", "Local ESP", "ColorPicker", "Chams Color"):SetValue(Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Transparency)
    Menu:FindItem("Visuals", "Local ESP", "Slider", "Chams Reflectance"):SetValue(Config.ESP.Chams.Local.Reflectance)
    Menu:FindItem("Visuals", "Local ESP", "ComboBox", "Chams Material"):SetValue(Config.ESP.Chams.Local.Material)

    Menu:FindItem("Visuals", "Item ESP", "CheckBox", "Enabled"):SetValue(Config.ESP.Item.Enabled)
    Menu:FindItem("Visuals", "Item ESP", "CheckBox", "Name"):SetValue(Config.ESP.Item.Flags.Name.Enabled)
    Menu:FindItem("Visuals", "Item ESP", "CheckBox", "Distance"):SetValue(Config.ESP.Item.Flags.Distance.Enabled)
    Menu:FindItem("Visuals", "Item ESP", "CheckBox", "Snapline"):SetValue(Config.ESP.Item.Snaplines.Enabled)
    Menu:FindItem("Visuals", "Item ESP", "ColorPicker", "Snapline Color"):SetValue(Config.ESP.Item.Snaplines.Color, 1 - Config.ESP.Item.Snaplines.Transparency)
    Menu:FindItem("Visuals", "Item ESP", "CheckBox", "Icons"):SetValue(Config.ESP.Item.Flags.Icon.Enabled)
    Menu:FindItem("Visuals", "Item ESP", "ComboBox", "Font"):SetValue(Config.ESP.Item.Font.Font)
    Menu:FindItem("Visuals", "Item ESP", "ColorPicker", "Font Color"):SetValue(Config.ESP.Item.Font.Color, 1 - Config.ESP.Item.Font.Transparency)
    Menu:FindItem("Visuals", "Item ESP", "Slider", "Font Size"):SetValue(Config.ESP.Item.Font.Size)

    Menu:FindItem("Visuals", "Hit markers", "CheckBox", "Hit markers"):SetValue(Config.HitMarkers.Enabled)
    Menu:FindItem("Visuals", "Hit markers", "ComboBox", "Hit markers type"):SetValue(Config.HitMarkers.Type)
    Menu:FindItem("Visuals", "Hit markers", "ColorPicker", "Hit markers color"):SetValue(Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency)
    Menu:FindItem("Visuals", "Hit markers", "Slider", "Hit markers size"):SetValue(Config.HitMarkers.Size)
    Menu:FindItem("Visuals", "Hit markers", "CheckBox", "Hit sound"):SetValue(Config.HitMarkers.Sound)

    Menu:FindItem("Visuals", "World", "CheckBox", "Ambient Changer"):SetValue(Config.Enviorment.Ambient.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Ambient"):SetValue(Config.Enviorment.Ambient[1].Color, 0)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Outdoor Ambient"):SetValue(Config.Enviorment.Ambient[2].Color, 0)
    Menu:FindItem("Visuals", "World", "CheckBox", "World Time Changer"):SetValue(Config.Enviorment.Time.Enabled)
    Menu:FindItem("Visuals", "World", "Slider", "World Time"):SetValue(Config.Enviorment.Time.Value)
    Menu:FindItem("Visuals", "World", "CheckBox", "Saturation Changer"):SetValue(Config.Enviorment.Saturation.Enabled)
    Menu:FindItem("Visuals", "World", "Slider", "Saturation"):SetValue(Config.Enviorment.Saturation.Value)
    Menu:FindItem("Visuals", "World", "CheckBox", "Bullet impacts"):SetValue(Config.BulletImpact.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Bullet impacts color"):SetValue(Config.BulletImpact.Color, 1 - Config.BulletImpact.Transparency)
    Menu:FindItem("Visuals", "World", "CheckBox", "Bullet Tracers"):SetValue(Config.BulletTracers.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Bullet Tracers Color"):SetValue(Config.BulletTracers.Color)
    Menu:FindItem("Visuals", "World", "Slider", "Bullet Tracers Lifetime"):SetValue(Config.BulletTracers.Lifetime)
    Menu:FindItem("Visuals", "World", "CheckBox", "Disable Bullet Trails"):SetValue(Config.BulletTracers.DisableTrails)
    Menu:FindItem("Visuals", "World", "ComboBox", "Skybox"):SetValue(Config.Enviorment.Skybox.Value)

    Menu:FindItem("Visuals", "Other", "CheckBox", "Max Zoom Changer"):SetValue(Config.Zoom.Enabled)
    Menu:FindItem("Visuals", "Other", "Slider", "Max Zoom"):SetValue(Config.Zoom.Value)
    Menu:FindItem("Visuals", "Other", "CheckBox", "Field Of View Changer"):SetValue(Config.FieldOfView.Enabled)
    Menu:FindItem("Visuals", "Other", "Slider", "Field Of View"):SetValue(Config.FieldOfView.Value)
    Menu:FindItem("Visuals", "Other", "CheckBox", "First Person"):SetValue(Config.FirstPerson.Enabled)

    Menu:FindItem("Visuals", "Interface", "CheckBox", "Aimbot Vector Indicator"):SetValue(Config.Aimbot.Visualize)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Field Of View Circle"):SetValue(Config.Interface.FieldOfViewCircle.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Field Of View Circle Filled"):SetValue(Config.Interface.FieldOfViewCircle.Filled)
    Menu:FindItem("Visuals", "Interface", "Slider", "Field Of View Circle Sides"):SetValue(Config.Interface.FieldOfViewCircle.NumSides)
    Menu:FindItem("Visuals", "Interface", "ColorPicker", "Field Of View Circle Color"):SetValue(Config.Interface.FieldOfViewCircle.Color, 1 - Config.Interface.FieldOfViewCircle.Transparency)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Watermark"):SetValue(Config.Interface.Watermark.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Chat"):SetValue(Config.Interface.Chat.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Indicators"):SetValue(Config.Interface.Indicators.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Keybinds"):SetValue(Config.Interface.Keybinds.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Show Ammo"):SetValue(Config.Interface.ShowAmmo.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Remove UI Elements"):SetValue(Config.Interface.RemoveUIElements.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Bar Fade"):SetValue(Config.Interface.BarFade.Enabled)

    Menu:FindItem("Visuals", "Weapons", "CheckBox", "Gun Chams"):SetValue(Config.GunChams.Enabled)
    Menu:FindItem("Visuals", "Weapons", "ColorPicker", "Chams Color"):SetValue(Config.GunChams.Color, Config.GunChams.Transparency)
    Menu:FindItem("Visuals", "Weapons", "Slider", "Chams Reflectance"):SetValue(Config.GunChams.Reflectance)
    Menu:FindItem("Visuals", "Weapons", "ComboBox", "Chams Material"):SetValue(Config.GunChams.Material)

    Menu:FindItem("Visuals", "Hats", "CheckBox", "Hat Color Changer"):SetValue(Config.HatChanger.Enabled)
    Menu:FindItem("Visuals", "Hats", "CheckBox", "Hat Color Sequence"):SetValue(Config.HatChanger.Sequence)
    Menu:FindItem("Visuals", "Hats", "Slider", "Hat Color Rate"):SetValue(Config.HatChanger.Speed)
    Menu:FindItem("Visuals", "Hats", "ColorPicker", "Hat Color"):SetValue(Config.HatChanger.Color)

    Menu:FindItem("Player", "Movement", "Slider", "Walk Speed"):SetValue(Config.WalkSpeed.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Jump Power"):SetValue(Config.JumpPower.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Run Speed"):SetValue(Config.RunSpeed.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Crouch Speed"):SetValue(Config.CrouchSpeed.Value)
    Menu:FindItem("Player", "Movement", "CheckBox", "Blink"):SetValue(Config.Blink.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Blink Key"):SetValue(Config.Blink.Key)
    Menu:FindItem("Player", "Movement", "Slider", "Blink Speed"):SetValue(Config.Blink.Speed)
    Menu:FindItem("Player", "Movement", "CheckBox", "Flight"):SetValue(Config.Flight.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Flight Key"):SetValue(Config.Flight.Key)
    Menu:FindItem("Player", "Movement", "Slider", "Flight Speed"):SetValue(Config.Flight.Speed)
    Menu:FindItem("Player", "Movement", "CheckBox", "Float"):SetValue(Config.Float.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Float Key"):SetValue(Config.Float.Key)
    Menu:FindItem("Player", "Movement", "CheckBox", "Infinite Jump"):SetValue(Config.InfiniteJump.Enabled)
    Menu:FindItem("Player", "Movement", "CheckBox", "Noclip"):SetValue(Config.Noclip.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Noclip Key"):SetValue(Config.Noclip.Key)

    Menu:FindItem("Player", "Other", "CheckBox", "No Knock Out"):SetValue(Config.NoKnockOut.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "No Slow"):SetValue(Config.NoSlow.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Anti Ground Hit"):SetValue(Config.AntiGroundHit.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Anti Fling"):SetValue(Config.AntiFling.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Hide Tools"):SetValue(false)
    Menu:FindItem("Player", "Other", "CheckBox", "Death Teleport"):SetValue(Config.DeathTeleport.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Flipped"):SetValue(Config.Flipped.Enabled)

    Menu:FindItem("Player", "Anti-Aim", "CheckBox", "Enabled"):SetValue(Config.AntiAim.Enabled)
    Menu:FindItem("Player", "Anti-Aim", "Hotkey", "Anti Aim Key"):SetValue(Config.AntiAim.Key)
    Menu:FindItem("Player", "Anti-Aim", "ComboBox", "Anti Aim Type"):SetValue(Config.AntiAim.Type)

    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Cash"):SetValue(Config.AutoCash.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Farm"):SetValue(Config.AutoFarm.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Auto Farm Table"):SetValue(Config.AutoFarm.Table)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Play"):SetValue(Config.AutoPlay.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Reconnect"):SetValue(Config.AutoReconnect.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Sort"):SetValue(Config.AutoSort.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Auto Sort Order"):SetValue(Config.AutoSort.Order)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto Heal"):SetValue(Config.AutoHeal.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Click Open"):SetValue(Config.ClickOpen.Enabled)
    --Menu:FindItem("Misc", "Main", "CheckBox", "Chat Spam"):SetValue(Spamming)
    Menu:FindItem("Misc", "Main", "CheckBox", "Event Logs"):SetValue(Config.EventLogs.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Event Log Flags"):SetValue(Config.EventLogs.Flags)
    Menu:FindItem("Misc", "Main", "CheckBox", "Hide Sprays"):SetValue(Config.HideSprays.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Close Doors"):SetValue(Config.CloseDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Open Doors"):SetValue(Config.OpenDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Knock Doors"):SetValue(Config.KnockDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "No Doors"):SetValue(Config.NoDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "No Seats"):SetValue(Config.NoSeats.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Door Aura"):SetValue(Config.DoorAura.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Door Menu"):SetValue(Config.DoorMenu.Enabled)

    Menu:FindItem("Misc", "Animations", "CheckBox", "Run"):SetValue(Config.Animations.Run.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Run Animation"):SetValue(Config.Animations.Run.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Glock"):SetValue(Config.Animations.Glock.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Glock Animation"):SetValue(Config.Animations.Glock.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Uzi"):SetValue(Config.Animations.Uzi.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Uzi Animation"):SetValue(Config.Animations.Uzi.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Shotty"):SetValue(Config.Animations.Shotty.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Shotty Animation"):SetValue(Config.Animations.Shotty.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Sawed Off"):SetValue(Config.Animations["Sawed Off"].Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Sawed Off Animation"):SetValue(Config.Animations["Sawed Off"].Style)
    
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Infinite Stamina"):SetValue(Config.InfiniteStamina.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Infinite Force-Field"):SetValue(Config.InfiniteForceField.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Teleport Bypass"):SetValue(Config.TeleportBypass.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "God"):SetValue(Config.God.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Click Spam"):SetValue(Config.ClickSpam.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Lag On Dragged"):SetValue(Config.LagOnDragged.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Fake Lag"):SetValue(Config.FakeLag.Enabled)
    Menu:FindItem("Misc", "Exploits", "Slider", "Fake Lag Limit"):SetValue(Config.FakeLag.Limit)

    --Menu:FindItem("Misc", "Players", "ListBox", "Target"):SetValue(SelectedTarget, Players:GetPlayers())
    Menu:FindItem("Misc", "Players", "CheckBox", "Target Lock"):SetValue(TargetLock)
    Menu:FindItem("Misc", "Players", "Slider", "Priority"):SetValue(0)
    Menu:FindItem("Misc", "Players", "CheckBox", "Attach"):SetValue(Config.Attach.Enabled)
    Menu:FindItem("Misc", "Players", "Slider", "Attach Rate"):SetValue(Config.Attach.Rate)
    Menu:FindItem("Misc", "Players", "CheckBox", "View"):SetValue(Config.View.Enabled)
    Menu:FindItem("Misc", "Players", "CheckBox", "Follow"):SetValue(Config.Follow.Enabled)
    --Menu:FindItem("Misc", "Players", "CheckBox", "Whitelisted"):SetValue(false)
    --Menu:FindItem("Misc", "Players", "CheckBox", "Owner"):SetValue(false)

    Menu:FindItem("Misc", "Clan Tag", "CheckBox", "Enabled"):SetValue(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "CheckBox", "Enabled"):SetValue(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "CheckBox", "Visualize"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "CheckBox", "Visualize"):SetValue(Config.ClanTag.Visualize)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Tag"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Tag"):SetValue(Config.ClanTag.Tag)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Prefix"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Prefix"):SetValue(Config.ClanTag.Prefix)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Suffix"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Suffix"):SetValue(Config.ClanTag.Suffix)
    Menu:FindItem("Misc", "Clan Tag", "Slider", "Tag Speed"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "Slider", "Tag Speed"):SetValue(Config.ClanTag.Speed)
    Menu:FindItem("Misc", "Clan Tag", "ComboBox", "Tag Type"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "ComboBox", "Tag Type"):SetValue(Config.ClanTag.Type)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Spotify Token"):SetVisible(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan Tag", "TextBox", "Spotify Token"):SetValue(Config.ClanTag.SpotifyToken)

    Menu:FindItem("Settings", "Menu", "ColorPicker", "Menu Accent"):SetValue(Config.Menu.Accent)
    Menu:FindItem("Settings", "Menu", "Hotkey", "Prefix"):SetValue(Config.Prefix)
    Menu:FindItem("Settings", "Menu", "Hotkey", "Menu Key"):SetValue(Config.Menu.Key)
    Menu:FindItem("Settings", "Menu", "ComboBox", "Console Font Color"):SetValue(Config.Console.Accent, {"Cyan"})

    
    Menu.Keybinds.List.Aimbot:SetVisible(Config.Aimbot.Enabled)
    Menu.Keybinds.List["Camera Lock"]:SetVisible(Config.CameraLock.Enabled)
    Menu.Keybinds.List.Flight:SetVisible(Config.Flight.Enabled)
    Menu.Keybinds.List.Blink:SetVisible(Config.Blink.Enabled)
    Menu.Keybinds.List.Float:SetVisible(Config.Float.Enabled)
    Menu.Keybinds.List.Noclip:SetVisible(Config.Noclip.Enabled)

    Menu.Keybinds.List["Anti Aim"]:SetVisible(Config.AntiAim.Enabled)

    Menu.Watermark:SetVisible(Config.Interface.Watermark.Enabled)
    Menu.Indicators:SetVisible(Config.Interface.Indicators.Enabled)
    Menu.Keybinds:SetVisible(Config.Interface.Keybinds.Enabled)
end


function GetFiles(Directory)
    local Files = {}
    local Names = {}

    for _, v in ipairs(listfiles(Directory)) do
        local File
        if isfile(v) then
            File = v
        elseif isfolder(v) then
            for _, v2 in ipairs(listfiles(v)) do File = v2 end
        end
        File = string.gsub(File, Directory .. "\\", "")
        table.insert(Files, File)
        local Name = string.gsub(File, Directory, "")
        table.insert(Names, Name)
    end

    return {Files = Files, Names = Names}
end


function get_clipboard()
    while not iswindowactive() do wait() end

    local text_box = Instance.new("TextBox")
    text_box.Parent = CoreGui

    text_box:CaptureFocus()
    keypress(0x11)
    keypress(0x44)
    wait()
    keyrelease(0x11)
    keyrelease(0x44)
    text_box:ReleaseFocus()

    local clipboard = text_box.Text
    text_box:Destroy()
    return clipboard
end


function set_clipboard(text)
    while not iswindowactive() do wait() end

    local text_box = Instance.new("TextBox")
    text_box.Parent = CoreGui

    text_box.Text = text
    text_box:CaptureFocus()
    keypress(0x11)
    keypress(0x43)
    wait()
    keyrelease(0x11)
    keyrelease(0x43)
    text_box:ReleaseFocus()

    text_box:Destroy()
end


function GetSkyboxes()
    local Directory = "Identification/Games/The Streets/bin/skyboxes/"
    local Files = GetFiles(Directory)
    return {Skyboxes = Files.Files, Names = Files.Names}
end


function GetSelectedTarget()
    return Players:FindFirstChild(SelectedTarget or "")
end


function GetTarget()
    if not Root then return end
    local Selected
    local Radius = math.huge
    for _, _Player in ipairs(Players:GetPlayers()) do
        if (_Player == Player) or (table.find(UserTable.Whitelisted, tostring(_Player.UserId))) then continue end
        if _Player.Character then
            local _Root = Root -- _Root is equal to local player root
            local Root = GetRoot(_Player) -- Target root
            if Root then
                local Distance = 0
                if Config.Aimbot.TargetSelection == "Near Mouse" then
                    Distance = (Mouse.Hit.Position - Root.Position).Magnitude
                    if Distance > Config.Aimbot.Radius then continue end
                elseif Config.Aimbot.TargetSelection == "Near Player" then
                    if _Player:GetAttribute("KnockedOut") or not _Player:GetAttribute("IsAlive") then continue end
                    Distance = Player:DistanceFromCharacter(Root.Position)
                end
                if Distance < Radius then
                    Radius = Distance
                    Selected = _Player
                end
            end
        end
    end

    return Selected
end


function GetStompTarget()
    if Character and Root then
        local Ray = streets_raycast(Root.Position, Root.Position - Vector3.new(0, 2, 0), 3, Character)
        if Ray and Ray.Parent then
            local Humanoid = Ray.Parent:FindFirstChild("Humanoid")
            if Humanoid and Humanoid.Parent:FindFirstChild("KO") and Humanoid.Health > 0 then
                return Humanoid.Parent
            end
        end
    end
end


function GetPlayer(Name)
    local Matches = {}
    local Name = string.gsub(string.lower(tostring(Name)), "%s", "")
    local PlayersTable = Players:GetPlayers()

    if Name == "me" then
        return {Player}
    elseif Name == "target" then
        return {Target}
    elseif Name == "all" then
        Matches = PlayersTable
        table.remove(Matches, table.find(Matches, Player))
        return Matches
    end
    for _, Player in ipairs(PlayersTable) do
        if Name == string.sub(string.lower(tostring(Player)), 1, #Name) then
            table.insert(Matches, Player)
        end
    end
    if #Matches == 0 then
        for _, Player in ipairs(PlayersTable) do
            if Name == string.sub(string.lower(Player.DisplayName), 1, #Name) then
                table.insert(Matches, Player)
            end
        end
    end
    return Matches
end


function GetRoot(Player)
    local Character = Player and Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    return Humanoid and Humanoid.RootPart
end


function GetLimbs(Player)
    local Character = Player and Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Character and Humanoid then
        local LimbCount = 0
        local Limbs = {}
        local Blacklist = {"RightHand", "LeftHand", "RightFoot"}

        for _, v in ipairs(Character:GetChildren()) do
            if table.find(Blacklist, tostring(v)) then continue end
            local Limb = Humanoid:GetLimb(v)
            if Limb ~= Enum.Limb.Unknown then
                LimbCount += 1
                Limbs[Limb.Name] = v
            end
        end

        return Limbs, LimbCount >= 6 and true or false
    end

    return {}, false
end


function GetAnimation(Name)
    if typeof(Name) == "string" then
        if tonumber(Name) == nil then
            return Animations[Name].self
        else
            for k, v in pairs(Animations) do
                if v.Animation.AnimationId == "rbxassetid://" .. Name then
                    return v.self
                end
            end
        end
    end
end


function GetStamina(_Player)
    local Player = _Player or Player
    local Stamina = 100
    local StaminaInstance
    if Original then
        local Character = Player.Character
        StaminaInstance = Character and Character:FindFirstChild("Stamina")
        if StaminaInstance then
            Stamina = StaminaInstance.Value
        end
    else
        local Backpack = Player:FindFirstChild("Backpack")
        local ServerTraits = Backpack and Backpack:FindFirstChild("ServerTraits")
        StaminaInstance = ServerTraits and ServerTraits:FindFirstChild("Stann")
        if StaminaInstance then
            Stamina = StaminaInstance.Value
        end
    end

    return math_round(Stamina, 2)
end


function GetClanModel()
    local Model
    if Character then
        for _, v in ipairs(Character:GetChildren()) do
            if v:IsA("Model") then
                if v:FindFirstChild("f") then
                    Model = v
                    break
                end
            end
        end
    end

    return Model
end


function GetAimbotCFrame(Randomize)
    local Character = Target and Target.Character

    local HitPart = Character and (Character.FindFirstChild(Character, Config.Aimbot.HitBox) or Character.FindFirstChildWhichIsA(Character, "BasePart"))
    if not HitPart then return Mouse.Hit end

    local VectorVelocity = Target.GetAttribute(Target, "Velocity") or Vector3.new() -- Don't want to error the script
    VectorVelocity *= AimbotVectorVelocityAmplifier

    local Random = Vector3.new()
    if Randomize then
        Random = Vector3.new(math.random(-5, 5) / 10, math.random(-5, 5) / 10, math.random(-5, 5) / 10)
    end
    return HitPart.CFrame + Random + (VectorVelocity * Ping / 1000)
end


function GetTools(_Player, Type)
    local Player = _Player or Player
    local Character = Player.Character
    local Backpack = Player:FindFirstChild("Backpack")
    if not Character or not Backpack then return {} end

    local Tools = {}
    local BackpackTools = {}
    local CharacterTools = {}

    for _, v in ipairs(Character:GetChildren()) do
        if v:IsA("Tool") then table.insert(CharacterTools, v) end
    end

    for _, v in ipairs(Backpack:GetChildren()) do
        if v:IsA("Tool") then table.insert(BackpackTools, v) end
    end

    if Type == "Backpack" then return BackpackTools end
    if Type == "Character" then return CharacterTools end

    table.move(BackpackTools, 1, #BackpackTools, #Tools + 1, Tools)
    table.move(CharacterTools, 1, #CharacterTools, #Tools + 1, Tools)
    return Tools
end


function GetToolInfo(self, Property) -- Maybe use attributes to log ammo;
    if self then
        local Tool_Name = tostring(self)
        if Property then
            if Property == "Ammo" then
                local Ammo = self:FindFirstChild("Ammo")
                local Clips = self:FindFirstChild("Clips")
                local AmmoPerClip = 0

                if Tool_Name == "Glock" then
                    AmmoPerClip = 8
                elseif Tool_Name == "Uzi" then
                    AmmoPerClip = 14 -- ? i think
                elseif Tool_Name == "Shotty" then
                    AmmoPerClip = 4
                elseif Tool_Name == "Sawed Off" then
                    AmmoPerClip = 2
                    if not Original then -- prison is retarded
                        if Clips.Value == 4 then
                            AmmoPerClip = 4
                        end
                    end
                end

                if Ammo and Clips then return Ammo.Value, Clips.Value, AmmoPerClip end
                if self:GetAttribute("Gun") then return 0, 0, AmmoPerClip end
                return
            elseif Property == "IsGun" then
                local Guns = {"Glock", "Uzi", "Shotty", "Sawed Off"}
                return table.find(Guns, tostring(self)) and true or false
            end
        end
        return ToolData[Tool_Name]
    end
end



function GetModelParts(Model, Ignore)
    local Parts = {}
    for _, v in ipairs(Model:GetDescendants()) do
        if v:IsA("BasePart") then
            if Ignore then
                if table.find(Ignore, v) then continue end
            end
            table.insert(Parts, v)
        end
    end
    return Parts
end


function GetCash()
    local Cash
    local CashLabel = HUD and HUD:FindFirstChild("Cash")
    if CashLabel then
        Cash = string.gsub(CashLabel.Text, "%D", "")
        Cash = tonumber(Cash)
    end

    return Cash or 0
end


do
    -- Method by pobammer
    local FPS = 0
    local Start = os.clock()
    local LastIteration
    local FrameUpdateTable = {}

    spawn(function()
        while true do
            LastIteration = os.clock()
            for Index = #FrameUpdateTable, 1, -1 do
                FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
            end

            FrameUpdateTable[1] = LastIteration
            local Time = os.clock() - Start
            FPS = tostring(math.round(Time >= 1 and #FrameUpdateTable or #FrameUpdateTable / Time))
            RunService.Stepped:Wait()
        end

        Start = os.clock()
    end)

    function GetFrameRate()
        return FPS
    end
end


do
    local Buyers = {}

    local function get_name(Name, Count)
        if Buyers[Name] then
            if Count then
                local temp = Name .. Count
                if Buyers[temp] then
                    return get_name(Name, Count + 1)
                end
                Name = temp
            else
                return get_name(Name, 2)
            end
        end
        return Name
    end

    local function add_to_pad_list(ItemName, self)
        local Name = string.lower(tostring(self))
        if Name == "bought!" then
            local Event
            Event = self:GetPropertyChangedSignal("Name"):Connect(function()
                add_to_pad_list(ItemName, self)
            end)
            delay(20, Event.Disconnect, Event) -- if the buy pad is broken
        elseif string.find(Name, " | ") and string.find(Name, string.lower(ItemName)) then
            local BuyerName = get_name(string.lower(ItemName))
            Buyers[BuyerName] = { -- string_lower who cares
                Part = self.Head,
                Price = self.Head.ShopData.Price.Value
            }
        end
    end

    local Items = {"Uzi", "Glock", "Sawed Off", "Pipe", "Machete", "Golf Club", "Bat", "Bottle", "Spray", "Burger", "Chicken", "Drink", "Greenbull", "Ammo"}
    for _, ItemName in ipairs(Items) do
        for _, v in ipairs(workspace:GetChildren()) do
            add_to_pad_list(ItemName, v)
        end
    end

    function GetBuyPads()
        return Buyers
    end
end


do
    local Buyers = GetBuyPads()

    function GetItem(Name)
        local Item = Buyers[string.lower(Name)]
        return Item.Part, Item.Price
    end
end


function GetBrickTrajectoryPoints(Brick)
    local Handle = Brick:FindFirstChild("Handle")
    if not Handle then return end

    local Points = {}
    local MaxPoints = 100

    local Origin = Handle.Position
    local End = Mouse.Hit.Position
    if Target and Config.Aimbot.Enabled then
        local AimbotCFrame = GetAimbotCFrame()
        if AimbotCFrame then
            End = AimbotCFrame.Position
        end
    end

    local Direction = (End - Origin).Unit
    local Distance = (End - Origin).Magnitude

    local Speed = Brick.Speed.Value
    local Gravity = Brick.Gravity.Value

    local VelocityAmplifier:Vector3 = Player:GetAttribute("ServerVelocity") -- i think this is just a multiplier for the speed value?

    local Time = Distance / Speed
    local TimeStep = Time / MaxPoints

    local TimeSteps = {}
    for i = 1, MaxPoints do
        TimeSteps[i] = TimeStep * i
    end

    for _, Time in ipairs(TimeSteps) do
        table.insert(Points, Origin + Direction * Speed * Time + Vector3.new(0, -Gravity * Time * Time / 2, 0))
    end

    return Points
end


function GetHitPoints(Target)
    local Points = {}
    local tCharacter = Target.Character

    if Tool and Tool:GetAttribute("Gun") then
        if tCharacter then
            local Parts = {}
            for _, v in ipairs(tCharacter:GetDescendants()) do
                if v:IsA("BasePart") then
                    table.insert(Parts, v)
                end
            end
            
            for _, Part in ipairs(Parts) do
                local IsBehind, Hit = IsBehindAWall(Tool.Barrel, Part)
                if IsBehind == false then
                    if Hit and Hit.Instance:IsDescendantOf(tCharacter) then
                        table.insert(Points, Hit.Position)
                    end
                end
            end
        end
    end

    return Points
end


function GetAssetInfo(AssetId)
    local AssetId = tonumber(AssetId)
    if not AssetId then return end

    local Info = {}
    local Success, Result = pcall(function()
        Info = Marketplace:GetProductInfo(AssetId)
    end)
    if not Success then
        Console:Error("[GET ASSET INFO] " .. Result)
        wait(3)
        return GetAssetInfo(AssetId)
    end
    return Info
end


function IsBehindAWall(Part, Part2, Blacklist)
    if not Part or not Part2 then return end
    local CF = CFrame.new(Part.Position, Part2.Position)
    local Hit = Raycast(CF.Position, CF.LookVector * (Part.Position - Part2.Position).Magnitude, {Character, Camera})
    if Hit then
        local HitPart = Hit.Instance
        if HitPart then
            if HitPart == Part2 then
                return false, Hit
            else
                return true, Hit
            end
        end
    end

    return false
end


function IsDoorOpen(Door)
    local Vector = Door.WoodPart.Position
    for _, OpenVector in pairs(DoorData.Doors.Open) do
        if math.abs((Vector - OpenVector).Magnitude) < 1.15 then return true end
    end
    for _, ClosedVector in pairs(DoorData.Doors.Closed) do
        if math.abs((Vector - ClosedVector).Magnitude) < 1.15 then return false end
    end
end


function IsWindowOpen(Window)
    local Vector = Window.Move.Click.Position
    for _, OpenVector in pairs(DoorData.Windows.Open) do
        if math.abs((Vector - OpenVector).Magnitude) < 0.2 then return true end
    end
    for _, ClosedVector in pairs(DoorData.Windows.Closed) do
        if math.abs((Vector - ClosedVector).Magnitude) < 0.2 then return false end
    end
end


function IsInCar()
    local Jeep = workspace:FindFirstChild("Jeep")
    if Jeep then
        Jeep.Name = "_Jeep"
    else
        return false
    end
    local Jeep2 = workspace:FindFirstChild("Jeep")
    Jeep.Name = "Jeep"
    local Jeeps = {Jeep, Jeep2}
    for _, Jeep in ipairs(Jeeps) do
        local Seat = Jeep:FindFirstChild("DriveSeat")
        local IsSeated = IsOnSeat(Player, Seat) -- Don't use IsSeated that doesn't have Car Seats Cached
        if IsSeated then return Jeep end
    end
    return false
end


function IsOnSeat(_Player, Seat)
    local Player = _Player or Player
    if Seat then
        local Occupant = Seat.Occupant
        if Occupant and tostring(Occupant.Parent) == tostring(Player) then return true end
    end

    return false
end


function IsSeated(_Player, Seat)
    local Player = _Player or Player
    for _, Seat in pairs(Seats) do
        local Seated = IsOnSeat(Seat)
        if Seated then return Seated end
    end

    return false
end


function IsCharacterAlive(Character)
    if typeof(Character) == "Instance" and Character:IsA("Model") then
        local CurrentParent = Character.Parent
        return (Original and CurrentParent == workspace.Live) or (not Original and CurrentParent == workspace)
    end

    return false
end


function UserOwnsAsset(_Player, AssetId, AssetType)
    --https://inventory.roblox.com/docs#!/Inventory/get_v1_users_userId_items_itemType_itemTargetId
    -- AssetType : "GamePass", "Asset", "Badge", "Bundle"
    local Player = _Player or Player
    local UserId = typeof(Player) == "Instance" and Player.UserId or Player
    if UserId and AssetId and AssetType then
        -- Concatenation is faster than the %s pattern
        local Url = "https://inventory.roblox.com/v1/users/" .. UserId .. "/items/" .. AssetType .. "/" .. AssetId
        local Response = request({Url = Url})
        return string.find(Response.Body, "name") and true or false
    else
        return "Wrong arguments"
    end

    return false
end


function TeleportToPlace(Place_Id, Job_Id)
    if Job_Id then
        TeleportService:TeleportToPlaceInstance(Place_Id, Job_Id)
        if Job_Id == game.JobId then
            if (#Players:GetPlayers() == 1) or (#Players:GetPlayers() == Players.MaxPlayers) then
                Player:Kick("Rejoining server..")
            end
        end
    else
        TeleportService:Teleport(Place_Id)
    end
end


function Teleport(Destination)
    Teleporting = false
    local Event
    local Distance = Player:DistanceFromCharacter(Destination.Position)
    local Destination = CFrame.new(Destination.Position, Root.Orientation)
    if Distance < 50 or (Config.God.Enabled or Config.TeleportBypass.Enabled) then
        Root.CFrame = Destination
        Teleporting = false
        return true
    end

    Teleporting = true
    local Info = TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, Info, {CFrame = Destination})

    Root.CFrame = CFrame.new(Root.Position, Destination.Position)
    spawn(function()
        while Teleporting do wait() end
        Tween:Cancel()
    end)
    Tween.Completed:Connect(function() Teleporting = false end)
    Tween:Play()
    return Tween
end


function Chat(Message)
    Message = tostring(Message)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "All")
    --Players:Chat(Message)
    --ReplicatedStorage.Xbox:FireServer() ReplicatedStorage.Talk:FireServer(Message)
end


function SetAnimation(Name, Id)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://" .. Id
    Animations[Name] = {
        Animation = Animation,
        self = Humanoid:LoadAnimation(Animation)
    }
end


do
    local Event = Instance.new("BindableEvent")
    RunService:BindToRenderStep("fireEvent", 1, function() Event:Fire() end)

    local CFrameSending = false
    local VelocitySending = false

    local CFrameToSend
    local VelocityToSend, AngularVelocityToSend

    -- much easier with raknet but you know ._.

    function SetCharacterServerCFrame(CF)
        if Root and typeof(CF) == "CFrame" then
            CFrameToSend = CF
            if CFrameSending then return end
            CFrameSending = true

            spawn(function()
                RunService.Heartbeat:Wait()
                local LastCFrame = Root.CFrame
                Root.CFrame = CFrameToSend
                Player:SetAttribute("ServerVector", CFrameToSend.Position)
                CFrameSending = false

                Event.Event:Wait()
                Root.CFrame = LastCFrame
            end)
        end
    end

    function SetCharacterServerVelocity(Velocity, AngularVelocity)
        if Root and typeof(Velocity) == "Vector3" and typeof(AngularVelocity) == "Vector3" then
            VelocityToSend, AngularVelocityToSend = Velocity, AngularVelocity
            if VelocitySending then return end
            VelocitySending = true

            spawn(function()
                RunService.Heartbeat:Wait()
                local LastVelocity = Root.AssemblyLinearVelocity
                local LastAngularVelocity = Root.AssemblyAngularVelocity
                Root.AssemblyLinearVelocity = Velocity
                Root.AssemblyAngularVelocity = AngularVelocity
                Player:SetAttribute("ServerVelocity", Velocity)
                Player:SetAttribute("ServerAngularVelocity", AngularVelocity)
                VelocitySending = false

                Event.Event:Wait()
                Root.AssemblyLinearVelocity = LastVelocity
                Root.AssemblyAngularVelocity = LastAngularVelocity
            end)
        end
    end
end


function SetModelDefaults(Model, Ignore)
    if not Model:GetAttribute("DefaultsSet") then
        for _, Part in ipairs(GetModelParts(Model, Ignore)) do
            if Part:GetAttribute("DefaultTransparency") == 1 then continue end
            Part:SetAttribute("DefaultColor", Part.Color)
            Part:SetAttribute("DefaultMaterial", Part.Material.Name)
            Part:SetAttribute("DefaultReflectance", Part.Reflectance)
            Part:SetAttribute("DefaultTransparency", Part.Transparency)
            if Part:IsA("UnionOperation") then
                Part:SetAttribute("DefaultUsePartColor", Part.UsePartColor)
            end
        end
        Model:SetAttribute("DefaultsSet", true)
    end
end


function SetModelProperties(Model, Color, Material, Reflectance, Transparency, UsePartColor)
    for _, Part in ipairs(GetModelParts(Model)) do
        if Part:GetAttribute("DefaultTransparency") == 1 then continue end
        if Part:GetAttribute("DefaultColor") then
            Part.Color = typeof(Color) == "Color3" and Color or Part:GetAttribute("DefaultColor")
        end
        if Part:GetAttribute("DefaultMaterial") then
            Part.Material = typeof(Material) == "string" and Material or Part:GetAttribute("DefaultMaterial")
        end
        if Part:GetAttribute("DefaultReflectance") then
            Part.Reflectance = typeof(Reflectance) == "number" and Reflectance or Part:GetAttribute("DefaultReflectance")
        end
        if Part:GetAttribute("DefaultTransparency") then
            Part.Transparency = typeof(Transparency) == "number" and Transparency or Part:GetAttribute("DefaultTransparency")
        end
        if Part:IsA("UnionOperation") and Part:GetAttribute("DefaultUsePartColor") ~= nil then
            Part.UsePartColor = typeof(UsePartColor) == "boolean" and UsePartColor or Part:GetAttribute("DefaultUsePartColor") -- ?
        end
    end
end


function SetPlayerChams(Player, ...) -- not actual chams just changing the properties of players parts
    local Character = Player.Character
    if Character then
        SetModelProperties(Character, ...)
    end
end


function SetToolChams(Tool)
    if not Tool then return end
    SetModelDefaults(Tool)
    if Config.GunChams.Enabled then
        SetModelProperties(Tool, Config.GunChams.Color, Config.GunChams.Material, Config.GunChams.Reflectance, Config.GunChams.Transparency, true)
    else
        SetModelProperties(Tool)
    end
end


function SetHat(Name)
    pcall(function()
        local Stank = Backpack.Stank
        local Hat = Character and Character:FindFirstChild(Name)
        local Handle = Hat and Hat:FindFirstChild("Handle")
        if Handle then
            Stank:FireServer("rep", {
                typ = {Value = tostring(Hat)}
            }) -- Server does WhiteDecal.Parent = Character:FindFirstChild(A.typ.Value).Handle [a is the second argument], every player has a whitedecal instance
        else
            Stank:FireServer("ren")
        end
    end)
end


--https://developer.roblox.com/en-us/articles/BrickColor-Codes
function SetHatColor(_Color)
    local Color = _Color or Color3.new()
    pcall(function()
        local Stank = Backpack.Stank
        Stank:FireServer("color", {BackgroundColor3 = Color})
    end)
end


do
    local LastTag

    function SetClanTag(Tag)
        local Tag = typeof(Tag) == "string" and Tag or ""
        Tag = string.rep("\n", 100 - #Tag) .. Tag
        pcall(function()
            local Stank = Backpack.Stank
            HUD.Clan.Group.Title.AutoLocalize = false -- disable TextScraper lag; LocalizationService:StopTextScraper()
            Stank:FireServer("pick", {
                Name = 1, -- yeah no u have no choice in this u get the guest role
                TextLabel = {Text = Tag} -- max char count 100
            })
        end)
    end
end


function SetTimer(Name, Time)
    if Timers[Name] then return end -- Timer already exists
    local Timer = {
        Name = Name,
        Time = Time
    }

    local Thread = {self = nil, Running = true}

    
    function Timer:Set(Time)
        local Time = typeof(Time) == "number" and Time or 0
        Timer.Time = math_round(Time, 2)
    end

    function Timer:Get()
        return math_round(Timer.Time, 2)
    end

    function Timer:Start()
        local Tick = os.clock()
        Thread.self = coroutine.create(function()
            while true do
                if not Thread.Running then coroutine.yield() end
                Timer:Set(os.clock() - Tick)
                wait()
            end
        end)
        coroutine.resume(Thread.self)

        function Timer:Start()
            return error("Timer is already running")
        end
    end

    function Timer:Destroy()
        Thread.Running = false
        Timer.Time = 0
        Timers[Name] = nil
    end

    Timers[Name] = Timer
    return Timer
end


function AddKnockedOutTimer(Player)
    local Name = tostring(Player)
    local Timer = SetTimer(Name, 15)
    if not Timer then return end -- if already running the timer for this state

    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    local Health = Player:GetAttribute("Health")
    local IsAlive = Player:GetAttribute("IsAlive")
    
    if IsAlive and Character and Humanoid then
        spawn(function()
            local DownTime = 15 -- it's 30 when ko is less than hp but only on prison; and I can't check players ko value on prison so deal with it; well actually I can check my ko value but still DEAL with it
            
            Timer:Start()
            while (DownTime > Timer:Get()) and (Player and Player:GetAttribute("IsAlive")) do
                Player:SetAttribute("KnockOut", 15 - Timer:Get())
                wait()
            end
            Player:SetAttribute("KnockOut", 0)
            Timer:Destroy()
        end)
    end
end


function AddFirstPersonEventListeners()
    for _, v in ipairs(Events.FirstPerson) do v:Disconnect() end
    table.clear(Events.FirstPerson)

    if Character and Config.FirstPerson.Enabled then
        for _, Object in ipairs(Character:GetChildren()) do
            if Object:IsA("BasePart") and string.find(tostring(Object), "Arm") then
                Object.LocalTransparencyModifier = 0
                table.insert(Events.FirstPerson, Object:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
                    Object.LocalTransparencyModifier = 0
                end))
            end
        end
    end
end


function AddItem(Spawn)
    -- This Code is kinda ASS but whatever
    local function Set(Spawn, Name)
        Spawn:SetAttribute("Item", Name)
        Items[Spawn] = Spawn
        AddItemESP(Spawn)

        local Event
        local Touched
        Touched = Spawn.Touched:Connect(function(Part)
            if Event then return end
            local _Player = Player -- OUR LOCAL PLAYER
            local Player = Players:GetPlayerFromCharacter(Part.Parent)
            if Player then
                Event = Spawn.AncestryChanged:Connect(function(_, Parent)
                    if Parent then return end
                    Touched:Disconnect()
                    Event:Disconnect()

                    local Distance = math_round(_Player:DistanceFromCharacter(Part.Position), 2) -- DISTANCE FROM LOCAL PLAYER
                    local Color = string.format("<font color = '#%s'>", Config.EventLogs.Colors["Picked up"]:ToHex())
                    local Message = string.format("%s picked up a %s from %s", Color .. tostring(Player) .. " </font>", Color .. Name .. "</font>", Color .. Distance .. "</font> studs away")
                    Client.OnEvent({
                        GetName = function() return "picked_up" end,
                        GetValue = function() return Spawn end,
                        GetPlayer = function() return Player end
                    })
                    LogEvent("Picked up", Message, tick())
                end)
                delay(10, function()
                    Event:Disconnect()
                    Event = nil
                end)
            end
        end)

        return Spawn, Name
    end

    for _, v in ipairs(Spawn:GetDescendants()) do
        for k2, v2 in pairs(ToolData) do
            local Name = tostring(v)
            local ClassName = v.ClassName
            if ClassName == "Sound" then
                if string.find(tostring(v.SoundId), tostring(v2.EspId)) then return Set(Spawn, k2) end
            elseif ClassName == "SpecialMesh" then
                if string.find(tostring(v.MeshId), tostring(v2.EspId)) then return Set(Spawn, k2) end
            elseif ClassName == "MeshPart" then
                if string.find(tostring(v.MeshId), tostring(v2.EspId)) or string.find(tostring(v.TextureID), tostring(v2.EspId)) then
                    return Set(Spawn, k2)
                end
            end
        end
    end
end


function AddPlayerESP(_Player)
    if typeof(_Player) == "Instance" and _Player:IsA("Player") and _Player ~= Player then
    else
        return
    end

    local Player = _Player
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChild("Humanoid")
    local Head = Character:FindFirstChild("Head")
    local Torso = Character:FindFirstChild("Torso")
    
    if not Humanoid or not Head or not Torso then return end

    local Player_ESP
    
    local function Destroy_ESP()
        if typeof(Player_ESP) == "table" then
            for k, v in pairs(Player_ESP) do
                if typeof(v) == "table" then
                    v:Remove()
                end
            end

            Drawn[Player] = nil
        end
    end


    Player_ESP = {
        self = Player,
        Character = Character,
        Type = "Player",
        Destroy = Destroy_ESP,

        Chams = ESP.Chams(Character), -- becareful with this, it can be detected

        Name = ESP.Text(Head),
        Weapon = ESP.Text(Head),
        Ammo = ESP.Text(Head),
        Vest = ESP.Text(Head),
        Health = ESP.Text(Head),
        Stamina = ESP.Text(Head),
        KnockedOut = ESP.Text(Head),
        Distance = ESP.Text(Head),
        Velocity = ESP.Text(Head),

        Box = ESP.Box(Torso),
        --CornerBox = ESP.CornerBox(Torso),
        Skeleton = ESP.Skeleton(),

        HealthBar = ESP.Bar(Torso),
        AmmoBar = ESP.Bar(Torso),
        KnockedOutBar = ESP.Bar(Torso),

        WeaponIcon = ESP.Image(Torso),
        Snapline = ESP.Snapline(Config.Aimbot.HitBox == "Head" and Head or Torso),
        Arrow = ESP.Arrow(Torso)
    }

    Drawn[Player] = Player_ESP
    return Player_ESP
end


function AddItemESP(Item)
    local Item_ESP

    local function Destroy_ESP()
        if typeof(Item_ESP) == "table" then
            for k, v in pairs(Item_ESP) do
                if typeof(v) == "table" then
                    v:Remove()
                end
            end

            Drawn[Item] = nil
        end
    end

    Item_ESP = {
        self = Item,
        Type = "Item",
        Destroy = Destroy_ESP,
        Name = ESP.Text(Item),
        Distance = ESP.Text(Item),
        Icon = ESP.Image(Item),
        Snapline = ESP.Snapline(Item)
    }

    Drawn[Item] = Item_ESP
    return Item_ESP
end


function UpdateESP()
    local ESP = Config.ESP
    local ESP_Enabled = ESP.Enabled
    local ESP_Flags = ESP.Flags
    local ESP_Font = ESP.Font
    local ESP_Bars = ESP.Bars

    local ESP_Name = ESP_Flags.Name
    local ESP_Weapon = ESP_Flags.Weapon.Text
    local ESP_Weapon_Icon = ESP_Flags.Weapon.Icon
    local ESP_Ammo = ESP_Flags.Ammo
    local ESP_Vest = ESP_Flags.Vest
    local ESP_Health = ESP_Flags.Health
    local ESP_Stamina = ESP_Flags.Stamina
    local ESP_KnockedOut = ESP_Flags.KnockedOut
    local ESP_Distance = ESP_Flags.Distance
    local ESP_Velocity = ESP_Flags.Velocity

    local ESP_AmmoBar = ESP_Bars.Ammo
    local ESP_HealthBar = ESP_Bars.Health
    local ESP_KnockedOutBar = ESP_Bars.KnockedOut

    local ESP_Chams = ESP.Chams
    local ESP_Box = ESP.Box
    local ESP_Skeleton = ESP.Skeleton
    local ESP_Snaplines = ESP.Snaplines
    local ESP_Arrows = ESP.Arrows

    local Item_ESP = ESP.Item
    local Item_ESP_Enabled = Item_ESP.Enabled
    local Item_ESP_Flags = Item_ESP.Flags
    local Item_ESP_Font = Item_ESP.Font

    local Item_ESP_Name = Item_ESP_Flags.Name
    local Item_ESP_Distance = Item_ESP_Flags.Distance
    local Item_ESP_Icon = Item_ESP_Flags.Icon
    local Item_ESP_Snaplines = Item_ESP.Snaplines

    for k, v in pairs(Drawn) do
        local self = v.self
        local Type = v.Type

        if Type == "Player" then
            local Player = self
            local Character = v.Character
            if not Character or not Character:FindFirstAncestor(tostring(workspace)) then
                v.Destroy()
                continue
            end

            local Target = Player == Target and true or false
            local Admin = UserTable.Admin[Player.UserId]
            local Whitelisted = table.find(UserTable.Whitelisted, Player.UserId)
            local Distance = Player:GetAttribute("Distance")


            local function IS_VISIBLE()
                local TARGET_CHECK = true
                if ESP.ForceTarget then
                    TARGET_CHECK = Target
                end

                return ESP_Enabled and TARGET_CHECK
            end

            local FONT = ESP_Font.Font
            local FONT_SIZE = ESP_Font.Size
            local FONT_COLOR = (Admin and Admin.Color) or (Whitelisted and ESP.WhitelistOverride.Enabled and ESP.WhitelistOverride.Color) or (Target and ESP.TargetOverride.Enabled and ESP.TargetOverride.Color) or (ESP_Font.Color)
            local FONT_TRANSPARENCY = ESP_Font.Transparency
            local FONT_PUSH_AMOUNT = -6

            local function GET_FONT_PUSH()
                FONT_PUSH_AMOUNT -= 4
                return math.clamp(Distance / 100, 0.5, 10) * FONT_PUSH_AMOUNT
            end


            local TOP_BAR_PUSH = 7
            local LEFT_BAR_PUSH = 6
            local RIGHT_BAR_PUSH = 6
            local BOTTOM_BAR_PUSH = 7

            local function SET_BAR_POINTS(Bar, Position)
                if Position == "Top" then
                    Bar.Axis = "x"
                    Bar:SetPoints(TOP_BAR_PUSH, -TOP_BAR_PUSH, 6, 6)
                    TOP_BAR_PUSH -= 1
                elseif Position == "Left" then
                    Bar.Axis = "y"
                    Bar:SetPoints(6, 7, LEFT_BAR_PUSH, -LEFT_BAR_PUSH)
                    LEFT_BAR_PUSH += 1
                elseif Position == "Right" then
                    Bar.Axis = "y"
                    Bar:SetPoints(6, -7, RIGHT_BAR_PUSH, -RIGHT_BAR_PUSH)
                    RIGHT_BAR_PUSH += 1
                elseif Position == "Bottom" then
                    Bar.Axis = "x"
                    Bar:SetPoints(BOTTOM_BAR_PUSH, -BOTTOM_BAR_PUSH, 6, 6)
                    BOTTOM_BAR_PUSH += 1
                end
            end


            v.Chams:SetVisible(IS_VISIBLE() and ESP_Chams.Enabled)
            v.Chams:SetRenderMode(ESP_Chams.RenderMode)
            v.Chams:SetColor(ESP_Chams.Color, ESP_Chams.Transparency)
            if ESP_Chams.AutoOutlineColor then
                local Health = Player:GetAttribute("Health")
                v.Chams:SetOutlineColor(Color3.fromHSV((Health / 100) * 0.3, 1, 1), ESP_Chams.Transparency)
            else
                v.Chams:SetOutlineColor(ESP_Chams.OutlineColor, ESP_Chams.OutlineTransparency)
            end


            v.Name.Visible = IS_VISIBLE() and ESP_Name.Enabled
            v.Vest.Visible = IS_VISIBLE() and ESP_Vest.Enabled
            v.Health.Visible = IS_VISIBLE() and ESP_Health.Enabled
            v.Stamina.Visible = IS_VISIBLE() and ESP_Stamina.Enabled
            v.KnockedOut.Visible = IS_VISIBLE() and ESP_KnockedOut.Enabled
            v.Distance.Visible = IS_VISIBLE() and ESP_Distance.Enabled
            v.Velocity.Visible = IS_VISIBLE() and ESP_Velocity.Enabled


            if v.Name.Visible then
                v.Name.Offset = ESP_Name.Offset
                local Name = Admin and Admin.Tag or ESP_Name.Type == "User" and tostring(Player) or Player.DisplayName
                v.Name:SetText(Name, FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
            end
            
            do
                local Character = Player.Character
                local Tool = Player.Tool.Value

                v.Ammo.Visible = IS_VISIBLE() and ESP_Ammo.Enabled and Tool and Tool:GetAttribute("Gun") and true or false
                v.AmmoBar.Visible = IS_VISIBLE() and ESP_AmmoBar.Enabled and Tool and Tool:GetAttribute("Gun") and true or false
                v.Weapon.Visible = IS_VISIBLE() and ESP_Weapon.Enabled and Tool and true or false
                v.WeaponIcon.Visible = IS_VISIBLE() and ESP_Weapon_Icon.Enabled and Tool and true or false

                do
                    if v.Weapon.Visible then
                        v.Weapon.Offset = Vector2.new(0, GET_FONT_PUSH())
                        v.Weapon:SetText(string.format("Tool: [%s]", tostring(Tool)), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
                    end

                    if v.WeaponIcon.Visible then
                        v.WeaponIcon.Offset = ESP_Weapon_Icon.Offset
                        
                    end
                end

                do
                    local Ammo, Clips, AmmoPerClip
                    if v.Ammo.Visible then
                        Ammo, Clips, AmmoPerClip = GetToolInfo(Tool, "Ammo")
                        v.Ammo.Offset = Vector2.new(0, GET_FONT_PUSH())
                        v.Ammo:SetText(string.format("Ammo: [%s, %s]", Ammo, Clips), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
                    end

                    if v.AmmoBar.Visible then
                        if not Ammo then Ammo, Clips, AmmoPerClip = GetToolInfo(Tool, "Ammo") end
                        SET_BAR_POINTS(v.AmmoBar, ESP_AmmoBar.Position)
                        v.AmmoBar:SetValue((Ammo / AmmoPerClip) * 100)
                        v.AmmoBar:SetColor(ESP_AmmoBar.Color, ESP_AmmoBar.Transparency)
                    end
                end
            end
            
            if v.Vest.Visible then
                v.Vest.Offset = Vector2.new(0, GET_FONT_PUSH())
                v.Vest:SetText(string.format("Vest: [%s]", tostring(Player:GetAttribute("Vest"))), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
            end
            
            do
                local Health = Player:GetAttribute("Health")

                if v.Health.Visible then
                    v.Health.Offset = Vector2.new(0, GET_FONT_PUSH())
                    v.Health:SetText(string.format("Health: [%s]", tostring(Health)), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
                end

                v.HealthBar.Visible = IS_VISIBLE() and ESP_HealthBar.Enabled
                if v.HealthBar.Visible then
                    SET_BAR_POINTS(v.HealthBar, ESP_HealthBar.Position)
                    v.HealthBar:SetValue(Health)

                    if ESP_HealthBar.AutoColor then
                        v.HealthBar:SetColor(Color3.fromHSV((Health / 100) * 0.3, 1, 1))
                    else
                        v.HealthBar:SetColor(ESP_HealthBar.Color, ESP_HealthBar.Transparency)
                    end
                end
            end

            do
                local Timer = Player:GetAttribute("KnockOut")
                v.KnockedOutBar.Visible = IS_VISIBLE() and Timer > 0 and ESP_KnockedOutBar.Enabled
                if v.KnockedOutBar.Visible then
                    SET_BAR_POINTS(v.KnockedOutBar, ESP_KnockedOutBar.Position)
                    v.KnockedOutBar:SetValue((Timer / 15) * 100)
                    v.KnockedOutBar:SetColor(ESP_KnockedOutBar.Color, ESP_KnockedOutBar.Transparency)
                end
            end

            if v.Stamina.Visible then
                v.Stamina.Offset = Vector2.new(0, GET_FONT_PUSH())
                v.Stamina:SetText(string.format("Stamina: [%s]", Player:GetAttribute("Stamina")), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
            end

            if v.Distance.Visible then
                v.Distance.Offset = Vector2.new(0, GET_FONT_PUSH())
                v.Distance:SetText(string.format("Distance: [%s]", tostring(Distance)), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
            end

            if v.Velocity.Visible then
                v.Velocity.Offset = Vector2.new(0, GET_FONT_PUSH())
                local Velocity = Player:GetAttribute("Velocity") or Vector3.new()
                Velocity = tostring(math_round(Velocity.Magnitude, 2))
                v.Velocity:SetText(string.format("Velocity: [%s u/s]", Velocity), FONT, FONT_SIZE, FONT_COLOR, FONT_TRANSPARENCY, true)
            end

            v.Box.Visible = IS_VISIBLE() and ESP_Box.Enabled and ESP_Box.Type == "Default" or false
            --v.CornerBox.Visible = IS_VISIBLE() and ESP_Box.Enabled and ESP_Box.Type == "Corners" or false
            v.Snapline.Visible = IS_VISIBLE() and ESP_Snaplines.Enabled
            v.Snapline.OffScreen = ESP_Snaplines.OffScreen
            v.Arrow.Visible = IS_VISIBLE() and ESP_Arrows.Enabled
            v.Arrow.Offset = ESP_Arrows.Offset

            v.Skeleton.Visible = false
            if IS_VISIBLE() and ESP_Skeleton.Enabled then
                local Limbs, Success = GetLimbs(Player)
                v.Skeleton.Visible = Success and Player:GetAttribute("IsAlive") and true or false
                if v.Skeleton.Visible then
                    pcall(function()
                        v.Skeleton:UpdatePoints({
                            Limbs.Head.Position,
                            Limbs.Head.Neck.WorldPosition,
                            Limbs.Torso.Pelvis.WorldPosition,
    
                            Limbs.LeftArm.LeftShoulder.WorldPosition,
                            Limbs.LeftArm.Position,
                            Limbs.LeftArm.LeftHand.WorldPosition,
                            Limbs.RightArm.RightShoulder.WorldPosition,
                            Limbs.RightArm.Position,
                            Limbs.RightArm.RightHand.WorldPosition,
    
                            Limbs.LeftLeg.LeftHip.WorldPosition,
                            Limbs.LeftLeg.Position,
                            Limbs.LeftLeg.LeftFoot.WorldPosition,
                            Limbs.RightLeg.RightHip.WorldPosition,
                            Limbs.RightLeg.Position,
                            Limbs.RightLeg.RightFoot.WorldPosition,
                        })
                    end)
                end
            end

            if Admin then
                v.Skeleton:SetColor(Admin.Color, ESP_Skeleton.Transparency)
                v.Snapline:SetColor(Admin.Color, ESP_Snaplines.Transparency)
                v.Box:SetColor(Admin.Color, ESP_Box.Transparency)
                --v.CornerBox:SetColor(Admin.Color, ESP_Box.Transparency)
                v.Arrow:SetColor(Admin.Color, ESP_Arrows.Transparency)
            elseif Whitelisted and ESP.WhitelistOverride.Enabled then
                v.Skeleton:SetColor(ESP.WhitelistOverride.Color, ESP_Skeleton.Transparency)
                v.Snapline:SetColor(ESP.WhitelistOverride.Color, ESP_Snaplines.Transparency)
                v.Box:SetColor(ESP.WhitelistOverride.Color, ESP_Box.Transparency)
                --v.CornerBox:SetColor(ESP.WhitelistOverride.Color, ESP_Box.Transparency)
                v.Arrow:SetColor(Admin.Color, ESP_Arrows.Transparency)
            elseif Target and ESP.TargetOverride.Enabled then
                v.Skeleton:SetColor(ESP.TargetOverride.Color, ESP_Skeleton.Transparency)
                v.Snapline:SetColor(ESP.TargetOverride.Color, ESP_Snaplines.Transparency)
                v.Box:SetColor(ESP.TargetOverride.Color, ESP_Box.Transparency)
                --v.CornerBox:SetColor(ESP.TargetOverride.Color, ESP_Box.Transparency)
                v.Arrow:SetColor(ESP.TargetOverride.Color, ESP_Arrows.Transparency)
            else
                v.Skeleton:SetColor(ESP_Skeleton.Color, ESP_Skeleton.Transparency)
                v.Snapline:SetColor(ESP_Snaplines.Color, ESP_Snaplines.Transparency)
                v.Box:SetColor(ESP_Box.Color, ESP_Box.Transparency)
                --v.CornerBox:SetColor(ESP_Box.Color, ESP_Box.Transparency)
                v.Arrow:SetColor(ESP_Arrows.Color, ESP_Arrows.Transparency)
            end
        elseif Type == "Item" then
            if not self or not self:FindFirstAncestor(tostring(workspace)) then -- wait why Am I just not using a ancestry changed event ? :|
                v.Destroy()
                continue
            end

            local Item = self
            local Distance = Player:DistanceFromCharacter(Item.Position)

            local FONT_PUSH_AMOUNT = 0

            local function GET_FONT_PUSH()
                FONT_PUSH_AMOUNT -= 5
                return math.clamp(Distance / 200, 0, 10) * FONT_PUSH_AMOUNT
            end

            v.Name.Visible = Item_ESP_Enabled and Item_ESP_Name.Enabled
            if v.Name.Visible then
                local Item_Name = Item:GetAttribute("Item")
                v.Name.Offset = Vector2.new(0, GET_FONT_PUSH())
                v.Name:SetText(Item_Name, Item_ESP_Font.Font, Item_ESP_Font.Size, Item_ESP_Font.Color, Item_ESP_Font.Transparency, true)
            end

            v.Distance.Visible = Item_ESP_Enabled and Item_ESP_Distance.Enabled
            if v.Distance.Visible then
                local Distance = string.format("Distance: [%s]", tostring(math.round(Distance)))
                v.Distance.Offset = Vector2.new(0, GET_FONT_PUSH())
                v.Distance:SetText(Distance, Item_ESP_Font.Font, Item_ESP_Font.Size, Item_ESP_Font.Color, Item_ESP_Font.Transparency, true)
            end

            v.Icon.Visible = Item_ESP_Enabled and Item_ESP_Icon.Enabled
            if v.Icon.Visible then
                local Icon = ""
                v.Icon:SetSize(50, 50)
                v.Icon:SetImage(Icon)
                v.Icon:SetColor(Item_ESP_Icon.Color)
            end

            v.Snapline.Visible = Item_ESP_Enabled and Item_ESP_Snaplines.Enabled
            if v.Snapline.Visible then
                v.Snapline:SetColor(Item_ESP_Snaplines.Color, Item_ESP_Snaplines.Transparency)
            end
        end
    end
end


function UpdateInterface(Fade)
    pcall(function()
        local Bars = {HUD.HP, HUD.KO, HUD.Stam}
        local Buttons = {HUD.ImageButton, HUD.Mute} -- ImageButton-LowGFX
        if Original then
            table.insert(Buttons, HUD.Shop)
            table.insert(Buttons, HUD.Groups)
        end

        if Config.Interface.BarFade.Enabled then
            if BarsFading then return end
            if Fade then
                BarsFading = true
                local Info = TweenInfo.new(0.5)
                local Properties = {Transparency = 1}
    
                for _, Bar in ipairs(Bars) do
                    local Tween = TweenService:Create(Bar, Info, Properties)
                    local Tween2 = TweenService:Create(Bar.Bar, Info, Properties)
                    Tween:Play()
                    Tween2:Play()
                    Tween.Completed:Connect(function() BarsFading = false end)
                end
            else
                
                for _, Bar in ipairs(Bars) do
                    Bar.Transparency = 0
                    Bar.Bar.Transparency = 0
                end
            end
        else
            BarsFading = false
            for _, Bar in ipairs(Bars) do
                Bar.Transparency = 0
                Bar.Bar.Transparency = 0
            end
        end
        for _, Button in ipairs(Buttons) do Button.Visible = not Config.Interface.RemoveUIElements.Enabled end
    end)
end


function UpdateSkybox()
    local Skybox = Config.Enviorment.Skybox.Value
    local Skyboxes = GetSkyboxes().Skyboxes
    for k, v in pairs(Skyboxes) do
        if k == Skybox then
            local Success, Result = pcall(function()
                local Sky = Lighting.Sky
                Sky.SkyboxUp = get_custom_asset(readfile(Skybox .. "/Up.png"))
                Sky.SkyboxDn = get_custom_asset(readfile(Skybox .. "/Down.png"))
                Sky.SkyboxFt = get_custom_asset(readfile(Skybox .. "/Front.png"))
                Sky.SkyboxBk = get_custom_asset(readfile(Skybox .. "/Back.png"))
                Sky.SkyboxLf = get_custom_asset(readfile(Skybox .. "/Left.png"))
                Sky.SkyboxRt = get_custom_asset(readfile(Skybox .. "/Right.png"))
            end)
            if not Success then
                return Console:Error(Result)
            end
            break
        end
    end
end


function UpdateAntiAim()
    Animations.AntiAim.self:Stop()
    Menu.Indicators.List["Fake Velocity"]:SetVisible(false)
    if Config.AntiAim.Enabled then
        if Config.AntiAim.Type == "Velocity" then
            Menu.Indicators.List["Fake Velocity"]:SetVisible(true)
            local Success, Result = coroutine.resume(Threads.FakeVelocity)
            if not Success then
                Console:Error("[ANTI AIM] " .. Result)
            end
        elseif Config.AntiAim.Type == "Desync" then
            local DesyncKeyPoints = {1, 2, 6}
        end
    end
end


function UpdateFieldOfViewCircle()
    FieldOfViewCircle.Visible = Config.Interface.FieldOfViewCircle.Enabled
    if FieldOfViewCircle.Visible then
        local Location = UserInput:GetMouseLocation()
        FieldOfViewCircle.Position = Location

        FieldOfViewCircle.Thickness = Config.Interface.FieldOfViewCircle.Thickness
        FieldOfViewCircle.Transparency = Config.Interface.FieldOfViewCircle.Transparency
        FieldOfViewCircle.NumSides = Config.Interface.FieldOfViewCircle.NumSides
        FieldOfViewCircle.Radius = Config.Aimbot.Radius
        FieldOfViewCircle.Color = Config.Interface.FieldOfViewCircle.Color
        FieldOfViewCircle.Filled = Config.Interface.FieldOfViewCircle.Filled
    end
end


function UpdateAimbotIndicator()
    if (Config.Aimbot.Visualize and Config.Aimbot.Enabled) then
        AimbotIndicator:SetVisible(true)
        AimbotIndicator:SetPosition(UserInput:GetMouseLocation())
        AimbotIndicator:SetColor(Color3.fromRGB(100, 40, 175), 0)

        local Vector, OnScreen = Camera:WorldToViewportPoint(GetAimbotCFrame(false).Position)
        if OnScreen then
            AimbotIndicator:SetPosition(Vector2.new(Vector.x, Vector.y))
        end
    else
        AimbotIndicator:SetVisible(false)
    end
end


function BindKey(Name, Mode, Key, Command, Arguments)
    if Mode == "Add" then
        Config.Keybinds.Commands[Name] = {
            Key,
            Command,
            Arguments
        }
    elseif Mode == "Remove" then
        Config.Keybinds.Commands[Name] = nil
    end
end


function LogEvent(Flag, Message, Time:tick)
    if Config.EventLogs.Enabled and Config.EventLogs.Flags[Flag] then
        Menu.Notify(Message, 8)
    end
end


function BuyItem(Item_Name:string)
    local Item_Name = string.lower(Item_Name)
    local Items = {"Uzi", "Glock", "Sawed Off", "Pipe", "Machete", "Golf Club", "Bat", "Bottle", "Spray", "Burger", "Chicken", "Drink", "Ammo"}

    local Part, Price
    for _, v in ipairs(Items) do
        if string.find(string.lower(v), Item_Name) then
            for _, v2 in ipairs(workspace:GetChildren()) do
                local Name = string.lower(tostring(v2))
                if string.find(Name, " | ") and string.find(Name, Item_Name) then
                    pcall(function()
                        Part = v2.Head
                        Price = Part.ShopData.Price.Value
                    end)
                    break
                end
            end
            if not Part then
                return Menu.Notify(string.format("<font color = '#%s'>Item '" .. Item_Name .. "' was not found </font>", Config.EventLogs.Colors.Error:ToHex()))
            end
            if Price > GetCash() then
                return Menu.Notify(string.format("<font color = '#%s'>Not enough cash..</font>", Config.EventLogs.Colors.Error:ToHex()))
            end
            if Part then
                Buying = true
                BuyPart = Part
                delay(5, function()
                    Buying = false
                    BuyPart = nil
                end)
                spawn(function()
                    Part.Changed:Wait()
                    Buying = false
                    BuyPart = nil
                end)

                break -- This might be a line down Lol
            end
        end
    end
end


function CreateBulletImpact(Position, Color, Material)
    local Impact = Instance.new("Part")
    Impact.Anchored = true
    Impact.CanCollide = false
    Impact.Name = "BulletImpact"
    Impact.Color = Color or Color3.new(1, 1, 1)
    Impact.Material = Material or "ForceField"
    Impact.Position = Position
    Impact.Size = Vector3.new(0.2, 0.2, 0.2)
    Impact.Parent = Camera
    Debris:AddItem(Impact, 5)
    return Impact
end



function DrawLine(Color, Transparency, From, To)
    local Line = Drawing.new("Line")
    Line.Color = Color or Color3.new(1, 1, 1)
    Line.Transparency = Transparency or 1
    Line.From = From or Vector2.new()
    Line.To = To or Vector2.new()
    Line.Visible = false
    Line.ZIndex = 1
    return Line
end


function DrawCross(Size, Offset)
    local Cross = {}
    local Lines = {DrawLine(), DrawLine(), DrawLine(), DrawLine()}

    Cross.Alive = true
    Cross.Angle = false
    Cross.Size = typeof(Size) == "number" and Size or 20
    Cross.Offset = typeof(Offset) == "number" and Offset or 4

    function Cross:SetSize(Size)
        assert(typeof(Size) == "number", "Size must be a number")
        Cross.Size = Size
    end

    function Cross:SetOffset(Offset)
        assert(typeof(Offset) == "number", "Offset must be a number")
        Cross.Offset = Offset
    end
    
    function Cross:SetPosition(Position)
        if not Cross.Alive then return error("CROSS IS DEAD") end

        -- until I figure out a better way to do this and yes I need it to work by the angle to make it spin
        if Cross.Angle then
            Lines[1].From = Position + Vector2.new(0, -Cross.Offset)
            Lines[1].To = Position + Vector2.new(0, -Cross.Size)
            Lines[2].From = Position + Vector2.new(0, Cross.Offset)
            Lines[2].To = Position + Vector2.new(0, Cross.Size)

            Lines[3].From = Position + Vector2.new(-Cross.Offset, 0)
            Lines[3].To = Position + Vector2.new(-Cross.Size, 0)
            Lines[4].From = Position + Vector2.new(Cross.Offset, 0)
            Lines[4].To = Position + Vector2.new(Cross.Size, 0)
        else
            Lines[1].From = Position + Vector2.new(-Cross.Size, -Cross.Size)
            Lines[1].To = Position + Vector2.new(-Cross.Offset, -Cross.Offset)
            Lines[2].From = Position + Vector2.new(-Cross.Size, Cross.Size)
            Lines[2].To = Position + Vector2.new(-Cross.Offset, Cross.Offset)

            Lines[3].From = Position + Vector2.new(Cross.Size, -Cross.Size)
            Lines[3].To = Position + Vector2.new(Cross.Offset, -Cross.Offset)
            Lines[4].From = Position + Vector2.new(Cross.Size, Cross.Size)
            Lines[4].To = Position + Vector2.new(Cross.Offset, Cross.Offset)
        end
    end

    function Cross:Rotate(Angle)
        if not Cross.Alive then return error("CROSS IS DEAD") end
        Cross.Angle = not Cross.Angle
    end

    function Cross:SetColor(Color, Transparency)
        if not Cross.Alive then return error("CROSS IS DEAD") end
        Cross.Color = typeof(Color) == "Color3" and Color or Cross.Color
        Cross.Transparency = typeof(Transparency) == "number" and 1 - Transparency or Cross.Transparency
        for _, Line in ipairs(Lines) do
            Line.Color = Cross.Color
            Line.Transparency = Cross.Transparency
        end
    end
    
    function Cross:SetVisible(Visible)
        if not Cross.Alive then return error("CROSS IS DEAD") end
        for _, Line in ipairs(Lines) do
            Line.Visible = Visible and true or false
        end
    end

    function Cross:FadeIn(Callback)
        if not Cross.Alive then return error("CROSS IS DEAD") end
        spawn(function()
            for i = 1, 100 do
                if Cross.Alive then
                    Cross:SetColor(nil, 1 - i / 100)
                    wait()
                end
            end
            if typeof(Callback) == "function" then Callback() end
        end)
    end

    function Cross:FadeOut(Callback)
        if not Cross.Alive then return error("CROSS IS DEAD") end
        spawn(function()
            for i = 1, 100 do
                if Cross.Alive then
                    Cross:SetColor(nil, (i / 100))
                    wait()
                end
            end
            if typeof(Callback) == "function" then Callback() end
        end)
    end
    
    function Cross:Remove()
        if not Cross.Alive then return error("CROSS IS DEAD") end
        Cross.Alive = false
        for _, Line in ipairs(Lines) do
            Line:Remove()
        end
    end

    function Cross:Destroy() return Cross:Remove() end

    function Cross:IsAlive() return Cross.Alive end

    Cross:SetColor(Color3.new(1, 1, 1), 0)
    
    return Cross
end


-- Thanks to f6oor
local function DrawStrawHat(Player)
    local Head = Player and Player.Character and Player.Character:FindFirstChild("Head")
    if not Head then return end
    
    local Hat = Instance.new("ConeHandleAdornment")
    local Outline = Instance.new("CylinderHandleAdornment")
    
    Hat.Name = "Hat"
    Hat.Transparency = 0.8
    Hat.Color3 = Color3.new(1, 1, 1)
    Hat.Height = 0.8
    Hat.Radius = 1.5
    Hat.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
    Hat.SizeRelativeOffset = Vector3.new(0, 1.2, 0)
    Hat.AlwaysOnTop = true
    Hat.Adornee = Head
    Hat.Parent = Head
    
    Outline.Name = "Outline"
    Outline.Color3 = Color3.new()
    Outline.Height = 0.001
    Outline.Radius = 1.5
    Outline.InnerRadius = 1.504
    Outline.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
    Outline.SizeRelativeOffset = Vector3.new(0, 1.2 ,0)
    Outline.AlwaysOnTop = true
    Outline.Adornee = Head
    Outline.Parent = Hat
    
    return {}
end


function PlaySound(SoundId, Volume)
    assert(SoundId, "Missing soundId")
    local Sound = Instance.new("Sound")
    Sound.SoundId = SoundId
    Sound.Volume = Volume or 1
    Sound.PlayOnRemove = true
    Sound.Parent = SoundService
    Sound:Destroy()
end


function SortBackpack()
    if not Humanoid then return end
    local Tools = {}
    Humanoid:UnequipTools()
    for _, Tool in ipairs(GetTools()) do
        table.insert(Tools, Tool)
        Tool.Parent = nil
    end
    for k, v in pairs(Config.AutoSort.Order) do
        if not v then continue end
        for _, Tool in ipairs(Tools) do
            if tostring(Tool) == k then Tool.Parent = Backpack end
        end
    end
    -- if it's already in backpack it won't change the order
    for _, Tool in ipairs(Tools) do Tool.Parent = Backpack end
end


function TeleportBypass()
    if Config.TeleportBypass.Enabled then
        if Original then
            Backpack.Stank:FireServer("pick", {
                Name = " ",
                TextLabel = {Text = 1}
            })
        else
            local RootPart = GetRoot(Player)
            if tostring(RootPart) == "HumanoidRootPart" then
                Torso.Anchored = true
                RootPart:Destroy()
                Torso.Anchored = false
                Root = Torso
            end
        end
    else
        if not Character:FindFirstChildOfClass("Model") then
            if Original then Backpack.Stank:FireServer("leave") end
        end
    end
end


function PlayAnimationServer(Animation: instance)
    Backpack.ServerTraits.Finish:FireServer({
        Finish = Animation
    })
end


function EnableInfiniteStamina(Value: number)
    if Original or not Config.InfiniteStamina.Enabled then return end
    spawn(function()
        local Remote = Backpack:WaitForChild("ServerTraits"):WaitForChild("Touch1")
        local Sound = workspace.OneHoop.Score.Sound -- Don't ask okay
        -- Can't do damage since the server tries to clone the "Info" folder, can't send functions through a remote
        Remote:FireServer({
            Handle = {Swing = Sound},
            Info = {
                Stam = {Value = -(Value or math.huge)},
                Range = {Value = 0}
            }
        }, 0, false, 0)
    end)
end


function PlaySoundExploit(Sound)
    if Original or not Sound then return end
    spawn(function()
        local Remote = Backpack:WaitForChild("ServerTraits"):WaitForChild("Touch1")
        Remote:FireServer({
            Handle = {
                Hit = Sound, -- The Cloned "Parent" will be set after it tries to set the "Pitch" property, only sound has a pitch property
                Swing = Sound
            },
            Info = {
                Stam = {Value = 0},
                Range = {Value = 9e9}, --Can't use math.huge also every time you hit a player it will play it, ((PlayerCount - Local) + Swing) so always will play as many players there are
                Cooldown = {Value = 0}
            }
        }, 0, false, 0)
    end)
end


function RefreshCharacter()
    if RefreshingCharacter then return end
    RefreshingCharacter = true
    Character:WaitForChild("Humanoid")
    local Script = PlayerGui:FindFirstChild("LocalScript")
    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui")
    local EquippedTool = Tool

    SortBackpack()
    if EquippedTool then EquippedTool.Parent = Character end

    HUD.Parent = CoreGui
    ScreenGui.Parent = CoreGui
    Script.Parent = CoreGui

    Player.Character = nil
    Player.Character = Character
    delay(0, function()
        HUD.Parent = PlayerGui
        Script.Parent = PlayerGui
        ScreenGui.Parent = PlayerGui
    end)
    wait(Players.RespawnTime - 0.1)
    ResetCharacter()

    RefreshingCharacter = false
end


function ResetCharacter()
    if Original then
        --Character.Head:Destroy()
        Torso:Destroy() -- Server Kill + No lag while dragged
    else
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        Humanoid.Health = 0
    end
end


function Attack(CF)
    local CF = Target and Config.Aimbot.Enabled and GetAimbotCFrame(true) or CF

    if not Tool then return end

    if Original then
        -- Tool.CD is disabled for reg
        if TagSystem.has("reloading") then return end
        local Arguments = {
            shift = UserInput:IsKeyDown(Enum.KeyCode.LeftShift),
            mousehit = CF,
            velo = Root.AssemblyLinearVelocity.Magnitude or 16
        }

        Backpack.Input:FireServer("ml", Arguments)
        Backpack.Input:FireServer("moff1", Arguments)
    else
        if Tool:GetAttribute("Gun") then
            if not Tool.CD then return end -- Cooldown
            local AnimationId = string.gsub(Tool.Fires.AnimationId, "%D", "")
            GetAnimation(AnimationId):Play(0.1, 1, 2)
            Tool.Fire:FireServer(CF, true) -- we send the boolean true for telling the hook to ignore it (AutShoot)
        elseif Tool:FindFirstChild("Finish") then
            Backpack.ServerTraits.Touch1:FireServer(Tool, 0, UserInput:IsKeyDown(Enum.KeyCode.LeftShift), 0)
        end
    end
end


function Stomp(Amount)
    local Amount = typeof(Amount) == "number" and Amount or 1
    if Original then
        if Tool and Tool:FindFirstChild("Finish") then
            local Input = Backpack.Input
            for _ = 1, Amount do
                Input:FireServer("e", {})
            end
        end
    else
        local Finish = Backpack.ServerTraits.Finish
        if not Tool or Tool and not Tool:FindFirstChild("Finish") then
            Tool = Backpack:FindFirstChild("Punch")
        end
        for _ = 1, Amount do
            Finish:FireServer(Tool) -- does raycast if hitpart found Root.Position - Vector3.new(0, 2, 0) then if raycast.Parent:find humanoid kill humanoid and humanoid.Parent needs to have KO value
        end
    end
end


function Drag()
    if Character and not Dragging then
        if Original then
            Backpack.Input:FireServer("e", {})
        else
            Backpack.ServerTraits.Drag:FireServer(true)
        end
    end
end


function CanPlayerAttackVictim(Player, Victim, Range)
    if Player:GetAttribute("IsAlive") and Victim:GetAttribute("IsAlive") then
        local Root = GetRoot(Player)
        local vRoot = GetRoot(Victim)

        if Root and vRoot then
            if (vRoot - (Root.Position + (Root.CFrame.LookVector * Range / 2))).Magnitude < Range then
                local Hit = streets_raycast(Root.Position, TargetRoot.Position, 5, Character)
                if Hit == nil or Hit.Anchored == false then
                    return true
                end
            end
        end
    end

    return false
end


function streets_raycast(Start, End, Distance, Ignore)
	return workspace:FindPartOnRay(Ray.new(Start, CFrame.new(Start, End).LookVector * Distance), Ignore)
end


function Raycast(Position, Position_2, Blacklist)
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Blacklist
    RayParams.FilterDescendantsInstances = Blacklist
    return workspace:Raycast(Position, Position_2, RayParams)
end


function GripTool(Tool, Grip_CFrame)
    local Arm = Character:FindFirstChild("Right Arm")
    local Handle = Tool:FindFirstChild("Handle")
    if not Arm or not Handle then return end
    return Weld("RightGrip", Arm, Handle, Grip_CFrame)
end


function CreateJoint(Name, Part, CF)
    local Attachment = Instance.new("Attachment")
    Attachment.Name = Name
    Attachment.CFrame = CF
    Attachment.Parent = Part
    return Attachment
end


function Weld(Name, Part, Part2, CF, CF2)
    local Grip = Instance.new("Weld")
    Grip.Name = Name
    Grip.Part0 = Part
    Grip.Part1 = Part2
    Grip.Parent = Part
    Grip.C0 = CF or CFrame.new()
    Grip.C1 = CF2 or CFrame.new()
    return Grip
end


function CreateJoints(Player)
    local Limbs, Success = GetLimbs(Player)
    if Success then
        CreateJoint("Neck", Limbs.Head, CFrame.new(Vector3.new(0, -0.7, 0)))
        CreateJoint("Pelvis", Limbs.Torso, CFrame.new(Vector3.new(0, -0.7, 0)))

        CreateJoint("LeftShoulder", Limbs.LeftArm, CFrame.new(Vector3.new(0, 0.7, 0)))
        CreateJoint("LeftHand", Limbs.LeftArm, CFrame.new(Vector3.new(0, -0.9, 0)))
        CreateJoint("RightShoulder", Limbs.RightArm, CFrame.new(Vector3.new(0, 0.7, 0)))
        CreateJoint("RightHand", Limbs.RightArm, CFrame.new(Vector3.new(0, -0.9, 0)))

        CreateJoint("LeftHip", Limbs.LeftLeg, CFrame.new(Vector3.new(0, 0.7, 0)))
        CreateJoint("LeftFoot", Limbs.LeftLeg, CFrame.new(Vector3.new(0, -0.9, 0)))
        CreateJoint("RightHip", Limbs.RightLeg, CFrame.new(Vector3.new(0, 0.7, 0)))
        CreateJoint("RightFoot", Limbs.RightLeg, CFrame.new(Vector3.new(0, -0.9, 0)))
    end
end


function ResyncPlayer(Player)
    -- offset HumRoot > Torso :: GetANimations
    local Humanoid = Player and Player.Character and Player.Character:FindFirstChild("Humanoid")
    if Humanoid then
        local Animator = Humanoid and Humanoid:FindFirstChild("Animator")
        if Animator then
            local Root = GetRoot(Player)
            if tostring(Root) == "HumanoidRootPart" then
                local Torso = Character:FindFirstChild("Torso")
                if Torso then
                    local Magnitude = (Root.Position - Torso.Position).Magnitude
                    if Magnitude > 0.1 then
                        local Tracks = Humanoid:GetPlayingAnimationTracks()
                        for _, Track in ipairs(Tracks) do
                            if Track.Animation.AnimationId == "rbxassetid://215384594" then
                                local TimePosition = Track.TimePosition

                            end
                        end
                    end
                end
            end
        end
    end
end


function ShowDoorMenu(self) -- I hate this shitty code
    local Lock = self:FindFirstChild("Lock").ClickDetector.RemoteEvent
    local Locker = self:FindFirstChild("Locker")
    local Click = self:FindFirstChild("Click").ClickDetector.RemoteEvent
    if not Lock or not Locker or not Click then return end

    local BillboardGui = Instance.new("BillboardGui")
    local TopBar = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local LockButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local LastLabel = Instance.new("TextLabel")

    local LoopEvent
    
    BillboardGui.Name = "DoorMenu"
    BillboardGui.Active = true
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Adornee = self.WoodPart
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.ExtentsOffset = Vector3.new(2, 0, 0)
    BillboardGui.Parent = Menu.Screen

    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 15)
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.Code
    Title.Text = "Door Menu"
    Title.TextSize = 14
    Title.TextStrokeTransparency = 0.5
    Title.Parent = BillboardGui
    Menu.Line(Title)
    
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.2
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0, 0, 0, 15)
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.Parent = BillboardGui
    
    LockButton.BackgroundTransparency = 1
    LockButton.Position = UDim2.new(0.1, 0, 0.0, 0)
    LockButton.Size = UDim2.new(0.8, 0, 0.5, 0)
    LockButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    LockButton.Text = "Lock"
    LockButton.Parent = Frame
    LockButton.MouseButton1Click:Connect(function()
        Lock:FireServer()
        LoopEvent:Disconnect()
        BillboardGui:Destroy()
    end)
    
    LastLabel.BackgroundTransparency = 1
    LastLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
    LastLabel.Size = UDim2.new(0.8, 0, 0.5, 0)
    LastLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    LastLabel.Text = "Last: " .. (self.Last.Value or "Nobody")
    LastLabel.Parent = Frame
    
    LoopEvent = RunService.Heartbeat:Connect(function()
        local Distance = Player:DistanceFromCharacter(self.WoodPart.Position)
        if Distance > 8 or not Humanoid or Humanoid.Health <= 0 then
            BillboardGui:Destroy()
            LoopEvent:Disconnect()
        end
        LastLabel.Text = "Last: " .. (self.Last.Value or "Nobody")
        LockButton.Text = Locker.Value and "Unlock" or "Lock"
    end)
end



function Heartbeat(Step) -- after phys :: after heartbeat comes network stepped
    Camera = workspace.CurrentCamera
    if UserInput:GetFocusedTextBox() ~= Menu.CommandBar then OnCommandBarFocusLost() end
    for i, v in ipairs(ChatScheduler) do
        table.remove(ChatScheduler, i)
        spawn(OnChatted, v)
    end
    local SelectedTarget = GetSelectedTarget()
    Target = TargetLock and SelectedTarget or GetTarget()
    do
        local tCharacter = SelectedTarget and SelectedTarget.Character
        local tHumanoid = tCharacter and tCharacter:FindFirstChild("Humanoid")
        Camera.CameraSubject = Config.View.Enabled and (tHumanoid or Humanoid) or Humanoid
    end

    if Original then
        if TagSystem then
            Dragging = TagSystem.has(Character, "Dragging")
            Dragged = TagSystem.has(Character, "Dragged")
            
            if Dragged and Root and Config.LagOnDragged.Enabled then
                Root:Destroy()
                Root = Torso
            end
        end

        if Config.ClanTag.Visualize and not Config.TeleportBypass.Enabled then
            local ClanModel = GetClanModel() 
            local Head = ClanModel and ClanModel:FindFirstChild("Head")
            if Head then
                Head.Transparency = 0
            end
        end
    end

    for _, _Player in ipairs(Players:GetPlayers()) do -- 34 players; 4 attribute changes for each player; 34*4=136changes every step; 136*60 = 8160 changes every second
        local LastPosition = _Player:GetAttribute("Position")
        if not LastPosition then continue end

        local Root = GetRoot(_Player)

        if Root then
            local Position = Root.Position

            if Player ~= _Player then -- local player has custom thing
                _Player:SetAttribute("Stamina", GetStamina(_Player) or 0)
            end
            _Player:SetAttribute("Distance", math_round(Player:DistanceFromCharacter(Position), 2))
            _Player:SetAttribute("Velocity", (Position - LastPosition) / Step)
            _Player:SetAttribute("Position", Position)
        else
            _Player:SetAttribute("Distance", 0)
            _Player:SetAttribute("Velocity", Vector3.new())
            _Player:SetAttribute("Position", Vector3.new())
        end
    end

    --if Config.AutoAttack.Enabled then
        
    --end

    if Target and Target.Character then
        local _Root = GetRoot(Target)

        if _Root then
            if Config.AutoFire.Enabled then
                if Tool and Tool:GetAttribute("Gun") then
                    if Target:GetAttribute("IsAlive") and Target:GetAttribute("Health") > 0 then
                        if Target:GetAttribute("KnockOut") < (Ping / 1000) and not Target.Character:FindFirstChild("ForceField") then
                            local Barrel = Tool:FindFirstChild("Barrel")
                            local Ammo, Clips = GetToolInfo(Tool, "Ammo")
                            if Barrel and (Ammo > 0 or Clips > 0) then
                                if (Target:DistanceFromCharacter(Barrel.Position) < Config.AutoFire.Range) then
                                    local HitPoints = GetHitPoints(Target)
                                    if #HitPoints > 0 then
                                        Attack(CFrame.new(HitPoints[1]))
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if TargetLock then
                if _Root then
                    if Config.Follow.Enabled then
                        local Position = Target:GetAttribute("Position")
                        local TargetDistance = Target:GetAttribute("Distance")

                        Humanoid:MoveTo(Position)
                        if TargetDistance > 5 then
                            if Config.Flight.Enabled then
                                Root.CFrame = Root.CFrame:Lerp(_Root.CFrame, Config.Flight.Speed / TargetDistance)
                            end
                            if Config.Blink.Enabled then
                                Root.CFrame = Root.CFrame:Lerp(_Root.CFrame * CFrame.new(1, 0, 1), Config.Blink.Speed / TargetDistance)
                            end
                        end
                    end
                end
            end
        end
    end

    if Root and Humanoid and not Player:GetAttribute("KnockedOut") then
        if Config.AutoFarm.Enabled then
            for _, Item in pairs(Items) do
                if Config.AutoFarm.Table[Item:GetAttribute("Item")] then
                    Teleport(Item.CFrame)
                end
            end
        end

        if not Healing and Config.AutoHeal.Enabled and Player:GetAttribute("Health") < 88 then
            local Foods, HealCount = {}, 0
            for _, Tool in ipairs(GetTools()) do
                local Tool_Name = tostring(Tool)
                if Tool_Name == "Burger" or Tool_Name == "Chicken" then
                    table.insert(Foods, Tool)
                end
            end
            if #Foods > 0 then
                Healing = true
                Humanoid:UnequipTools()
                local FoodsToEat = {}
                for _, Food in ipairs(Foods) do
                    local FoodHealth = GetToolInfo(tostring(Food)).Health
                    if Player:GetAttribute("Health") + HealCount + FoodHealth < 110 then
                        HealCount += FoodHealth
                        table.insert(FoodsToEat, Food)
                    end
                end
                spawn(function()
                    for _, Food in ipairs(FoodsToEat) do
                        Food.Parent = Character
                        Food:Activate()
                        Food.Parent = Backpack
                    end
                    wait(1.8)
                    Healing = false
                end)
            end
        end

        if Buying and not Dragging then
            Root.CFrame = BuyPart.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end

        if not UserInput:GetFocusedTextBox() and UserInput:IsKeyDown(Enum.KeyCode.Space) then
            if Player:GetAttribute("Health") > 0 and Config.InfiniteJump.Enabled then
                Humanoid:ChangeState(3)
            end
        end

        for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            local AnimationId = string.gsub(Track.Animation.AnimationId, "%D", "")

            if Config.Animations.Glock.Enabled and Config.Animations.Glock.Style ~= "Default" then
                if AnimationId == "503285264" then Track:Stop() end
            elseif Config.Animations.Uzi.Enabled and Config.Animations.Uzi.Style ~= "Default" then
                if AnimationId == "503285264" then Track:Stop() end
            elseif Config.Animations.Shotty.Enabled and Config.Animations.Shotty.Style ~= "Default" then
                if AnimationId == "889390949" then Track:Stop() end
            elseif Config.Animations["Sawed Off"].Enabled and Config.Animations["Sawed Off"].Style ~= "Default" then
                if AnimationId == "889390949" then Track:Stop() end
            end

            if (not Tool or not Tool:GetAttribute("Gun")) then
                if AnimationId == "889968874" or AnimationId == "229339207" or AnimationId == "503285264" or AnimationId == "889390949" then
                    Track:Stop()
                end
            end

            if Tool then
                local Tool_Name = tostring(Tool)
                if Tool_Name == "Glock" or Tool_Name == "Uzi" then
                    if Config.Animations[Tool_Name].Enabled then
                        local Style = Config.Animations[Tool_Name].Style
                        if Style == "Style-2" then
                            Animations.Gun.self:Play()
                            Animations.Gun2.self:Stop()
                            Animations.Gun3.self:Stop()
                        elseif Style == "Style-3" then
                            Animations.Gun.self:Stop()
                            Animations.Gun2.self:Stop()
                            Animations.Gun3.self:Play()
                        end
                    end
                elseif Tool_Name == "Shotty" or Tool_Name == "Sawed Off" then
                    if Config.Animations[Tool_Name].Enabled then
                        local Style = Config.Animations[Tool_Name].Style
                        if Style == "Style-2" then
                            Animations.Gun.self:Play()
                            Animations.Gun2.self:Stop()
                            Animations.Gun3.self:Stop() --?
                        elseif Style == "Style-3" then
                            Animations.Gun.self:Stop()
                            Animations.Gun3.self:Stop()
                            Animations.Gun2.self:Play()
                            Animations.Gun2.self.TimePosition = 0.2
                            Animations.Gun2.self:AdjustSpeed(0)
                        end
                    end
                end
            end
        end
    end

    Ping = math_round(Stats.PerformanceStats.Ping:GetValue(), 2)
    SendPing = math_round(Stats.PerformanceStats.NetworkSent:GetValue(), 2)
    ReceivePing = math_round(Stats.PerformanceStats.NetworkReceived:GetValue(), 2)

    do
        local Stamina = GetStamina()
        if Player:GetAttribute("Stamina") ~= Stamina then
            OnStaminaChanged(Stamina)
        end
    end
end


function Stepped(_, Step) -- before phys
    UpdateESP()

    if Root and Humanoid then
        if Config.Float.Enabled then
            if not Player:GetAttribute("KnockedOut") then
                if Config.Flipped.Enabled then
                    FloatPart.Position = Root.Position - Vector3.new(0, 2.5, 0)
                else
                    FloatPart.Position = Root.Position - Vector3.new(0, 3.499, 0)
                end
                if UserInput:IsKeyDown(Enum.KeyCode.E) and not UserInput:GetFocusedTextBox() then
                    FloatPart.Position += Vector3.new(0, 0.4, 0)
                elseif UserInput:IsKeyDown(Enum.KeyCode.Q) and not UserInput:GetFocusedTextBox() then
                    FloatPart.Position -= Vector3.new(0, 0.4, 0)
                end
            end
        end

        if Player:GetAttribute("Health") > 0 and Player:GetAttribute("IsAlive") then
            if Config.Flight.Enabled then
                local LookVector = Camera.CFrame.LookVector
                local Car = IsInCar()

                FlyVelocity.Parent = Root
                FlyAngularVelocity.Parent = Root
                -- Root.AssemblyLinearVelocity = Vector3.new()

                if Car then
                    local Root = Car.Chassis
                    Car.PrimaryPart = Root

                    Root.CanCollide = false
                    Car:PivotTo(CFrame.new(Root.Position, Root.Position + LookVector))
                    if not UserInput:GetFocusedTextBox() then
                        if UserInput:IsKeyDown(Enum.KeyCode.W) then
                            Car:PivotTo(Root.CFrame + LookVector * Config.Flight.Speed)
                        end
                        if UserInput:IsKeyDown(Enum.KeyCode.A) then
                            Car:PivotTo(Root.CFrame * CFrame.new(-Config.Flight.Speed, 0, 0))
                        end
                        if UserInput:IsKeyDown(Enum.KeyCode.S) then
                            Car:PivotTo(Root.CFrame - LookVector * Config.Flight.Speed)
                        end
                        if UserInput:IsKeyDown(Enum.KeyCode.D) then
                            Car:PivotTo(Root.CFrame * CFrame.new(Config.Flight.Speed, 0, 0))
                        end
                    end
                else
                    Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                    Root.CFrame = Config.Flight.Rotation and CFrame.new(Root.Position, Root.Position + LookVector) or CFrame.new(Root.Position, Root.Position + LookVector * Vector3.new(1, 0, 1))
                    
                    local Velocity = Player:GetAttribute("Velocity")
                    fire_running_function(Velocity.Magnitude)

                    if not UserInput:GetFocusedTextBox() then
                        if UserInput:IsKeyDown(Enum.KeyCode.W) then
                            Root.CFrame += LookVector * Config.Flight.Speed
                        end
                        if UserInput:IsKeyDown(Enum.KeyCode.S) then
                            Root.CFrame -= LookVector * Config.Flight.Speed
                        end

                        if UserInput:IsKeyDown(Enum.KeyCode.A) then
                            if Config.Flight.Rotation or Config.Flipped.Enabled then
                                Root.CFrame += (Humanoid.MoveDirection * Config.Flight.Speed)
                            else
                                Root.CFrame *= CFrame.new(-Config.Flight.Speed, 0, 0)
                            end
                        end
                        if UserInput:IsKeyDown(Enum.KeyCode.D) then
                            if Config.Flight.Rotation or Config.Flipped.Enabled then
                                Root.CFrame += (Humanoid.MoveDirection * Config.Flight.Speed)
                            else
                                Root.CFrame *= CFrame.new(Config.Flight.Speed, 0, 0)
                            end
                        end
                    end

                end
            else
                -- Unfly
                FlyVelocity.Parent = nil
                FlyAngularVelocity.Parent = nil
            end

            if Config.Noclip.Enabled then
                local Head = Character:FindFirstChild("Head")
                if Head and Torso then
                    Head.CanCollide = false
                    Torso.CanCollide = false
                end
            end

            if Config.Blink.Enabled then
                local MoveDirection = Humanoid.MoveDirection
                if not UserInput:GetFocusedTextBox() and (UserInput:IsKeyDown(Enum.KeyCode.W) or UserInput:IsKeyDown(Enum.KeyCode.S) or UserInput:IsKeyDown(Enum.KeyCode.A) or UserInput:IsKeyDown(Enum.KeyCode.D)) then
                    Root.CFrame += ((MoveDirection.Magnitude > 0 and MoveDirection or Root.CFrame.LookVector) * Config.Blink.Speed)
                end
            end

            if Config.AntiFling.Enabled then
                if Root.AssemblyLinearVelocity.Magnitude > 200 or Root.AssemblyAngularVelocity.Magnitude > 200 then
                    Root.AssemblyLinearVelocity = Vector3.new()
                end
                for _, _Player in ipairs(Players:GetPlayers()) do
                    if _Player == Player then continue end
                    local Root = GetRoot(_Player)
                    local Character = _Player.Character
                    local Head = Character and Character:FindFirstChild("Head")
                    if Root then
                        Root.AssemblyLinearVelocity = Vector3.new()
                        Root.AssemblyAngularVelocity = Vector3.new()
                        Root.CanCollide = false
                    end
                    if Head then Head.CanCollide = false end
                end
            end

            if Config.Flipped.Enabled then
                local LookVector = Root.CFrame.LookVector
                Root.CFrame = CFrame.new(Root.Position, Root.Position + Vector3.new(1, 0, 0)) * CFrame.Angles(math.rad(180), 0, 0)
            end

            if Config.AutoStomp.Enabled and not Config.God.Enabled and not Player:GetAttribute("KnockedOut") and not Dragging and Ping < 500 and tostring(Root) == "HumanoidRootPart" then
                for _, _Player in ipairs(Players:GetPlayers()) do
                    if Config.AutoStomp.Target == "Target" then
                        if not GetSelectedTarget() ~= _Player then continue end
                    elseif Config.AutoStomp.Target == "Whitelist" then
                        if not table.find(UserTable.Whitelisted, tostring(_Player.UserId)) then continue end
                    elseif Config.AutoStomp.Target == "All" then
                        if table.find(UserTable.Whitelisted, tostring(_Player.UserId)) then continue end
                    end
                    local _Root = GetRoot(_Player)
                    if _Player ~= Player and _Root and tostring(_Root) == "HumanoidRootPart" and _Player:GetAttribute("KnockedOut") then
                        if Player:DistanceFromCharacter(_Root.Position) < Config.AutoStomp.Distance and _Player:GetAttribute("Health") > 0 then
                            Teleport(_Root.CFrame)
                            if GetStompTarget() then
                                Stomp()
                            end
                        end
                    end
                end
            end
        end

        if Config.DoorAura.Enabled then
            for _, Door in ipairs(Doors) do
                if Player:DistanceFromCharacter(Door.WoodPart.Position) < 10 then
                    local IsOpen = IsDoorOpen(Door)
                    if not IsOpen then
                        local Locker = Door:FindFirstChild("Locker")
                        if Locker and Locker.Value then
                            Door.Lock.ClickDetector.RemoteEvent:FireServer()
                        end
                        Door.Click.ClickDetector.RemoteEvent:FireServer()
                    end
                end
            end
            for _, Window in ipairs(Windows) do
                if Player:DistanceFromCharacter(Window.Move.Click.Position) < 10 then
                    local IsOpen = IsWindowOpen(Window)
                    if not IsOpen then
                        Window.Move.Click.ClickDetector.RemoteEvent:FireServer()
                    end
                end
            end
        end

        if Ping < 500 then
            if (Config.OpenDoors.Enabled or Config.CloseDoors.Enabled) then
                for _, Door in ipairs(Doors) do
                    if Door:FindFirstChild("Locker") and Door.Locker.Value then continue end
                    local IsOpen = IsDoorOpen(Door)
                    if IsOpen == nil then continue end
                    if IsOpen then
                        if not Config.CloseDoors.Enabled then continue end
                        Door.Click.ClickDetector.RemoteEvent:FireServer()
                    else
                        if not Config.OpenDoors.Enabled then continue end
                        Door.Click.ClickDetector.RemoteEvent:FireServer()
                    end
                end
            end
            if (Config.OpenDoors.Enabled or Config.CloseDoors.Enabled) then
                for _, Window in ipairs(Windows) do
                    local IsOpen = IsWindowOpen(Window)
                    if IsOpen == nil then continue end
                    if IsOpen then
                        if not Config.CloseDoors.Enabled then continue end
                        Window.Move.Click.ClickDetector.RemoteEvent:FireServer()
                    else
                        if not Config.OpenDoors.Enabled then continue end
                        Window.Move.Click.ClickDetector.RemoteEvent:FireServer()
                    end
                end
            end
        end
    end
end


function RenderStepped(Step)
    UpdateFieldOfViewCircle() -- Has check if visible anyway
    UpdateAimbotIndicator()

    if Config.Interface.Watermark.Enabled then
        Menu.Watermark:Update("Identification | " .. GetFrameRate() .. "fps | " .. math.round(Ping) .. "ms | " .. os.date("%X"))
    end

    local Timer = Player:GetAttribute("KnockOut") or 0
    if Timer > 0 then
        Menu.Indicators.List["Knocked Out"]:SetVisible(true)
        Menu.Indicators.List["Knocked Out"]:Update(math_round(Timer, 2), 0, 15)
    else
        Menu.Indicators.List["Knocked Out"]:SetVisible(false)
    end
    Menu.Indicators.List.Target:Update("[" .. tostring(Target) .. "]")
    do
        local SelectedTarget = GetSelectedTarget()
        if SelectedTarget then
            UpdatePlayerListInfo(SelectedTarget)
        end
    end
    Menu.Indicators.List["Bullet Tick"]:Update(BulletTick)
    do
        local StompTarget = GetStompTarget()
        Menu.Indicators.List["Stomp Target"]:Update(tostring(StompTarget))
    end

    Config.Interface.Keybinds.Position = Menu.Keybinds.AbsolutePosition
    Config.Interface.Watermark.Position = Menu.Watermark.AbsolutePosition
    Config.Interface.Indicators.Position = Menu.Indicators.AbsolutePosition

    do
        local StaminaTick = os.clock() - (Player:GetAttribute("StaminaTick") or os.clock())
        local HealthTick = os.clock() - (Player:GetAttribute("HealthTick") or os.clock())
        -- if stamina and health have been static for 1.2 seconds then lets fade the bars else lets unfade/keep them visible
        UpdateInterface((HealthTick > 1.2 and StaminaTick > 1.2) and true or false)
    end

    local AmmoLabel = HUD:FindFirstChild("Ammo")
    if AmmoLabel then
        if Tool and Tool:GetAttribute("Gun") then
            local Ammo, Clips = GetToolInfo(Tool, "Ammo")
            AmmoLabel.Text = Config.Interface.ShowAmmo.Enabled and (Clips .. " Clips\n" .. Ammo .. " Ammo") or AmmoLabel.Text
            AmmoLabel.Visible = true
        else
            AmmoLabel.Visible = false
        end
    end

    if BrickTrajectory then BrickTrajectory:Remove() BrickTrajectory = nil end
    if Config.BrickTrajectory.Enabled then
        if Tool and tostring(Tool) == "Brick" then
            local Points = GetBrickTrajectoryPoints(Tool)
            if typeof(Points) == "table" and #Points > 0 then
                BrickTrajectory = ESP.Trajectory(Points)
                BrickTrajectory:SetColor(Config.BrickTrajectory.Color, 0.5)
            end
        end
    end
end


function OnInput(Input, Process)
    local Object = Mouse.Target
    local Key = Input.KeyCode
    local Input = Input.UserInputType

    local function CheckInput(Comparison)
        if Key == Comparison or Input == Comparison then return true end
    end

    -- Command binds set by user
    if not Process then
        for _, Bind in pairs(Config.Keybinds.Commands) do
            if CheckInput(Bind[1]) then
                local Arguments = ""
                for _, v2 in ipairs(Bind[3]) do
                    Arguments ..= " " .. v2
                end
                Commands.Check(Bind[2] .. Arguments)
            end
        end
    end

    if CheckInput(Enum.KeyCode.E) then
        if Process then return end
        delay(0.1, function()
            if not UserInput:IsKeyDown(Key) then
                if Character and not Dragging and Config.StompSpam.Enabled then
                    if GetStompTarget() then
                        Stomp(Original and 50 or 200)
                    end
                end
            end
        end)
    end

    if CheckInput(Enum.UserInputType.MouseButton1) then
        if Process then return end
        if Config.ClickOpen.Enabled and Object and Object:IsA("BasePart") and Player:DistanceFromCharacter(Object.Position) < 7 then
            local Object_Name = tostring(Object)
            local Door = Object:FindFirstAncestor("Door")
            local Window = Object:FindFirstAncestor("Window", true)
            if (Door or Window) then
                if (Object_Name == "Part" or Object_Name == "Union" or Object_Name == "Click" or Object_Name == "Hinge" or Object_Name == "Glass" or tostring(Object.Parent) == "WoodPart") then
                    local Click = Door:FindFirstChild("Click", true)
                    if Click then
                        Click:FindFirstChildWhichIsA("RemoteEvent", true):FireServer()
                    end
                end
            end
        end
    end

    if CheckInput(Enum.UserInputType.MouseButton2) then
        if Process then return end
        if Object and Config.DoorMenu.Enabled then
            local Door = Object:FindFirstAncestor("Door")
            if tostring(Object) == "Door" or Door then
                local Distance = Player:DistanceFromCharacter(Object.Position)
                if Distance < 8 and not Menu.Screen:FindFirstChild("DoorMenu") then
                    ShowDoorMenu(Door)
                end
            end
        end
    end
end


function OnInputEnded(Input, Process)
    local Key = Input.KeyCode
    local Input = Input.UserInputType

    local function CheckInput(Comparison)
        if Key == Comparison or Input == Comparison then return true end
    end
end


function OnChatted(Message)
    Commands.Check(Message, string.char(Config.Prefix.Value))
end


function OnIdle()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end


function OnCommandBarFocusLost(CheckCommand)
    local CommandBar = Menu.CommandBar
    CommandBar:ReleaseFocus()
    CommandBar:TweenPosition(UDim2.new(0.5, -100, 1, 5), nil, nil, 0.2, true)
    local Success, Result = pcall(function()
        Commands.Check(CommandBar.Text)
    end)
    if not Success then
        Console:Error("[COMMAND ERROR] " .. Result)
    end
    CommandBar.Text = ""
end


function OnDeath()
    OnPlayerDeath(Player)
    Player:SetAttribute("IsAlive", false)
    Player:SetAttribute("KnockedOut", false)
    Dragging = false
    DeathPosition = CFrame.new(Root.Position, Root.Position + Root.CFrame.LookVector * Vector3.new(1, 0, 1))
end


function OnStateChange(Old, New)
    if (not Player:GetAttribute("KnockedOut") and Config.AntiGroundHit.Enabled) then
        if New == Enum.HumanoidStateType.FallingDown then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    if New == Enum.HumanoidStateType.PlatformStanding then
        Humanoid.PlatformStand = false
    end
end


function OnHealthChange(Health)
    if Health < Player:GetAttribute("Health") then -- if current health is less than last time then we give player the health_tick attribute
        Player:SetAttribute("HealthTick", os.clock())
    end
    Player:SetAttribute("Health", math_round(Health, 2))
end


function OnStaminaChanged(Stamina)
    if Stamina < Player:GetAttribute("Stamina") then -- if current stamina is less than last time then we give player the stamina_tick attribute
        Player:SetAttribute("StaminaTick", os.clock())
    end
    Player:SetAttribute("Stamina", Stamina)
end


function OnBackpackChildAdded(self)
    if self:IsA("Tool") then
        if self == Tool then
            Tool = nil
        end

        local Name = tostring(self)
        if GetToolInfo(self, "IsGun") then
            if not self:GetAttribute("Gun") then
                delay(0.1, function()
                    SetToolChams(self)
                    if tostring(self) == "Glock" or tostring(self) == "Uzi" then
                        self.Handle.CanCollide = false
                        self.Barrel.CanCollide = false
                    end
                end)
                self:SetAttribute("Gun", true)
            end
        elseif Name == "BoomBox" then
            Menu.BoomboxFrame.Visible = false
        elseif string.find(Name, "Cash") then
            if not Config.AutoCash.Enabled then return end
            local LastTool = Tool
            delay(0, function()
                Humanoid:UnequipTools()
                self.Parent = Character
                wait()
                self:Activate()
                wait()
                --self:Destroy() -- should be destroyed by server but glitches sometimes?
                if LastTool then
                    LastTool.Parent = Character
                end
            end)
        end
    end
end


function OnCharacterDescendantAdded(self)
    local Name = tostring(self)

    if Name == "Bone" then
        if Player:GetAttribute("KnockedOut") then return end
        for _, Object in ipairs(Character:GetDescendants()) do if Object:IsA("Trail") then Object:Destroy() end end
        OnPlayerKnockedOut(Player, true)
    elseif Name == "creator" and self:IsA("ObjectValue") then
        OnCreatorValueAdded(self)
    elseif Name == "Bullet" and self.Parent == Humanoid then
        OnBulletAdded(self)
    elseif self:IsA("Tool") then
        Tool = self
        if GetToolInfo(self, "IsGun") then
            SetToolChams(Tool)
            Tool:SetAttribute("Gun", true)
        elseif Name == "BoomBox" then
            Menu.BoomboxFrame.Visible = true
            Menu.BoomboxFrame.List.CanvasSize = UDim2.new()
            for _, Object in ipairs(Menu.BoomboxFrame.List:GetChildren()) do if Object:IsA("GuiButton") then Object:Destroy() end end
            spawn(function()
                for _, Id in ipairs(AudioLogs) do Menu.AddAudioButton(Id) end
            end)
        end
    elseif Name == "Dragging" then
        Dragging = true
    elseif Name == "Dragged" then
        Dragged = true
        if tostring(Root) == "HumanoidRootPart" and Config.LagOnDragged.Enabled then
            Dragged = true Torso.Anchored = true Root:Destroy() Torso.Anchored = false Root = Torso -- Fuck you it's ugly with newlines
        end
    end
end


function OnCharacterDescendantRemoving(self)
    local Name = tostring(self)

    if Name == "Bone" then
        Player:SetAttribute("KnockedOut", false)
    elseif Name == "Dragging" then
        Dragging = false
    elseif Name == "Dragged" then
        Dragged = false
    end
end


function OnCharacterAdded(_Character)
    Tool = nil
    Character = _Character
    HUD = PlayerGui:WaitForChild("HUD")
    Backpack = Player:WaitForChild("Backpack")
    Humanoid = Character:WaitForChild("Humanoid")
    Torso = Character:WaitForChild("Torso")
    Root = Humanoid.RootPart

    if Config.DeathTeleport.Enabled then
        if Config.TeleportBypass.Enabled then
            Root.CFrame = DeathPosition
        else
            delay(1, function() Teleport(DeathPosition) end)
        end
    end

    CustomCharacter.Parent = Character
    Player:SetAttribute("Vest", UserOwnsAsset(Player, 6967243, "GamePass"))
    Player:SetAttribute("KnockOut", 0)
    Player:SetAttribute("Position", Root.Position)
    Player:SetAttribute("Health", math_round(Humanoid.Health, 2))
    Player:SetAttribute("IsAlive", true)
    Player:SetAttribute("Stamina", math_round(GetStamina(), 2))

    get_running_function(Character)
    TeleportBypass()
    EnableInfiniteStamina()
    CreateJoints(Player)

    Humanoid.Died:Connect(OnDeath)
    Humanoid.StateChanged:Connect(OnStateChange)
    Humanoid.HealthChanged:Connect(OnHealthChange)
    Character.DescendantAdded:Connect(OnCharacterDescendantAdded)
    Character.DescendantRemoving:Connect(OnCharacterDescendantRemoving)
    Backpack.ChildAdded:Connect(OnBackpackChildAdded)

    do
        local Ignore = {}
        for _, v in ipairs(Character:GetChildren()) do
            if v:IsA("Tool") then
                for _, v2 in ipairs(v:GetDescendants()) do
                    table.insert(Ignore, v2)
                end
            end
        end
        SetModelDefaults(Character, Ignore)
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
        end
        if Player.UserId == 1552377192 then
            DrawStrawHat(Player)
        end
    end

    for _, Tool in ipairs(GetTools()) do OnBackpackChildAdded(Tool) end

    if Config.God.Enabled then
        if Original then
            -- Only 1 method by Cyrus, I know of
        else
            -- Method by Reestart; 
            -- Thanks to nixon for giving it to me
            local Animator = Humanoid:WaitForChild("Animator")
            Animator:Clone().Parent = Humanoid
            Animator:Destroy()
        end
        --Character:WaitForChild(Original and "Used" or "Right Leg"):Destroy()
    else
        Character:WaitForChild(Original and "GetMouse" or "Gun")
    end

    for _, Animation in pairs(Animations) do
        Animation.self = Humanoid:LoadAnimation(Animation.Animation) -- This has to be done after god mode
    end

    if Config.FirstPerson.Enabled then
        AddFirstPersonEventListeners()
    end

    --if Config.HideVest.Enabled and Player:GetAttribute("Vest") then Character:WaitForChild("BulletResist"):Destroy() end
    if Config.AutoPlay.Enabled then
        if LastAudio ~= 0 then
            if UserOwnsAsset(Player, 1159109, "GamePass") then
                local Boombox = Backpack:WaitForChild("BoomBox")
                local Remote = Boombox:WaitForChild("RemoteEvent")
                if Remote then
                    Boombox.Parent = Character
                    Remote:FireServer("play", LastAudio)
                    pcall(function() Boombox.BoomBoxu.Entry.TextBox.Text = Id end)
                    delay(1, function() Boombox.Parent = Backpack end)
                end
            end
        end
    end

    if Config.AutoSort.Enabled then SortBackpack() end

    delay(1, StarterGui.SetCore, StarterGui, "ResetButtonCallback", Events.Reset)
    Menu:FindItem("Visuals", "Hats", "ComboBox", "Hat"):SetValue("None", {"None", unpack(Humanoid:GetAccessories())})
end


function OnPlayerChatted(Type, Player, Message, Target)

end


function OnPlayerAdded(Player)
    Menu:FindItem("Misc", "Players", "ListBox", "Target"):SetValue(SelectedTarget, Players:GetPlayers())
    if Player == Players.LocalPlayer then return end

    local ToolValue = Instance.new("ObjectValue")
    ToolValue.Name = "Tool" ToolValue.Parent = Player

    local function OnCharacterAdded(Character)
        spawn(function()
            local Backpack = Player:WaitForChild("Backpack")
            local Humanoid = Character:WaitForChild("Humanoid")
            local Torso = Character:WaitForChild("Torso")
            local Root = Character:FindFirstChild("HumanoidRootPart")

            local SpawnPoint = Root and Root.Position or Torso.Position
            local RootPoint = SpawnPoint -- I think I can do somethings with this rootpoint if they have tpbypass on (PRISON)

            Player:SetAttribute("Vest", UserOwnsAsset(Player, 6967243, "GamePass"))
            Player:SetAttribute("Health", math_round(Humanoid.Health, 2))
            Player:SetAttribute("IsAlive", true)
            Player:SetAttribute("KnockOut", 0)
            Player:SetAttribute("Position", RootPoint)
            Player:SetAttribute("RootPoint", RootPoint)


            local function OnCharacterDescendantAdded(self)
                local Name = tostring(self)

                if Name == "creator" and self:IsA("ObjectValue") then
                    OnCreatorValueAdded(self)
                elseif Name == "Bone" then
                    if Player:GetAttribute("KnockedOut") then return end
                    for _, Object in ipairs(Character:GetDescendants()) do if Object:IsA("Trail") then Object:Destroy() end end
                    OnPlayerKnockedOut(Player, false)
                elseif self:IsA("Tool") then
                    ToolValue.Value = self
                    if GetToolInfo(self, "IsGun") then
                        self:SetAttribute("Gun", true)
                    end
                end
            end


            local function OnCharacterDescendantRemoving(self)
                local Name = tostring(self)
                if Name == "Bone" then
                    if Player:GetAttribute("KnockedOut") == false then return end
                    Player:SetAttribute("KnockedOut", false)
                    SetPlayerChams(Player)
                elseif self:IsA("Tool") then
                    ToolValue.Value = nil
                end
            end

            delay(1, function() -- Yielding for everything to load in properly
                if not Players:FindFirstChild(tostring(Player)) then return end
                if Character.Parent == nil or Humanoid.Health == 0 then return end
                CreateJoints(Player)
                if Player.UserId == 1552377192 then
                    DrawStrawHat(Player)
                end
                local Player_ESP = AddPlayerESP(Player)

                do
                    local Ignore = {}
                    for _, v in ipairs(Character:GetChildren()) do
                        if v:IsA("Tool") then
                            for _, v2 in ipairs(v:GetDescendants()) do
                                table.insert(Ignore, v2)
                            end
                        end
                    end
                    SetModelDefaults(Character, Ignore) -- wait for character to load I guess?
                end
            end)

            if Root then
                Root.AncestryChanged:Connect(function(_, Parent)
                    if not Parent then
                        Player:SetAttribute("RootPoint", RootPoint)
                    end
                end)
            end
            Character.DescendantAdded:Connect(OnCharacterDescendantAdded)
            Character.DescendantRemoving:Connect(OnCharacterDescendantRemoving)
            Humanoid.HealthChanged:Connect(function(Health)
                Player:SetAttribute("Health", math_round(Health, 2))
                if Player:GetAttribute("IsAlive") == false then return end
                Player:SetAttribute("IsAlive", Health > 0 and IsCharacterAlive(Character) and true or false)
            end)

            local HumanoidDiedEvent
            HumanoidDiedEvent = Humanoid.Died:Connect(function()
                HumanoidDiedEvent:Disconnect()
                OnPlayerDeath(Player)
                Player:SetAttribute("IsAlive", false)
                Player:SetAttribute("KnockedOut", false)
            end)

            Character.AncestryChanged:Connect(function(Parent)
                if not Parent then
                    OnPlayerDeath(Player)
                    Player:SetAttribute("IsAlive", false)
                    Player:SetAttribute("KnockedOut", false)
                end
            end)

            local Animator = Humanoid:FindFirstChild("Animator")
            if Animator then
                Animator.AnimationPlayed:Connect(function(Track)
                    if Track.Animation.AnimationId == "rbxassetid://215384594" then
                        ResyncPlayer(Player)
                    end
                end)
            end
        end)
    end

    if Player.Character then
        OnCharacterAdded(Player.Character)
        local Tool = Player.Character:FindFirstChildOfClass("Tool")
        if Tool then
            ToolValue.Value = Tool
            if GetToolInfo(Tool, "IsGun") then
                Tool:SetAttribute("Gun", true)
            end
        end
    end
    LogEvent("Joined", "\"" .. tostring(Player) .. "\" has joined the game", tick())
    Player.CharacterAdded:Connect(OnCharacterAdded)
end


function OnPlayerRemoving(Player)
    Menu:FindItem("Misc", "Players", "ListBox", "Target"):SetValue(SelectedTarget, Players:GetPlayers())
    LogEvent("Left", "\"" .. tostring(Player) .. "\" has left the game", tick())

    if Player == Target then
        Target = nil
    end

    if Player == Players.LocalPlayer then
        Console:Clear()
    end
end


function OnPlayerKnockedOut(Player:player, Local:bool)
    Player:SetAttribute("KnockedOut", true)
    AddKnockedOutTimer(Player)
    local Character = Player.Character
    if Local then
        if Config.NoKnockOut.Enabled then ResetCharacter() end
    else
        if Character then
            if Config.ESP.Chams.KnockedOut.Enabled then
                SetPlayerChams(Player, Config.ESP.Chams.KnockedOut.Color, Config.ESP.Chams.KnockedOut.Material, Config.ESP.Chams.KnockedOut.Reflectance, Config.ESP.Chams.KnockedOut.Transparency, true)
            else
                SetPlayerChams(Player)
            end
        end
    end
    Client.OnEvent({
        GetName = function() return "player_knockout" end,
        GetValue = function() return Player end
    })
end


function OnPlayerDamaged(Victim:player, Attacker:player, Damage:number, Time:tick)
    if typeof(Victim) ~= "Instance" or typeof(Attacker) ~= "Instance" then return end -- if not instance then ignore
    if not Victim:IsA("Player") or not Attacker:IsA("Player") then return end -- if it's the DUMMY or a GHOST? or a buypad?
    if Victim ~= Player and Attacker ~= Player then return end -- if it's not connected to localplayer then ignore

    -- damage
    local MessageLog
    for _, Log in ipairs(DamageLogs) do
        if (Log.Time - Time) < 0.1 then
            if Log.Victim == Victim and Log.Attacker == Attacker then
                return
            end
        end
    end

    local Index = #DamageLogs + 1
    table.insert(DamageLogs, {
        Victim = Victim,
        Attacker = Attacker,
        Damage = Damage,
        Time = Time
    })

    if Attacker == Player then
        if Config.HitSound.Enabled then
            PlaySound(HitSound, 0.8)
        end
        if Config.HitMarkers.Enabled and (Config.HitMarkers.Type == "Crosshair" or Config.HitMarkers.Type == "Crosshair + Model") then
            local Cross = DrawCross(Config.HitMarkers.Size, 8)
            Cross:SetColor(Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency)
            Cross:SetVisible(true)
            delay(1, function()
                if Config.HitMarkers.Fade then
                    Cross:FadeOut(Cross.Destroy)
                else
                    Cross:Destroy()
                end
            end)

            spawn(function()
                while Cross:IsAlive() do
                    --local Location = (Menu.ScreenSize + Vector2.new(0, 36)) / 2
                    local Location = UserInput:GetMouseLocation()
                    Cross:SetPosition(Location)
                    wait()
                end
            end)
        end
        local Color = string.format("<font color = '#%s'>", Config.EventLogs.Colors.Hit:ToHex())
        local Health = Victim:GetAttribute("Health") - Damage
        MessageLog = string.format("Damaged %s for %s (%s health remanining)", Color .. tostring(Victim) .. "</font>", Color .. Damage .. "</font>", Color .. Health .. "</font>")
    elseif Victim == Player then
        local Color = string.format("<font color = '#%s'>", Config.EventLogs.Colors.Miss:ToHex())
        local Health = Player:GetAttribute("Health") - Damage

        MessageLog = string.format("%s damaged you for %s (%s health remanining)", Color .. tostring(Attacker) .. "</font>", Color .. Damage .. "</font>", Color .. Health .. "</font>")
    end

    delay(0.2, table.remove, DamageLogs, Index)

    Client.OnEvent({
        GetName = function() return "player_damage" end,
        GetVictim = function() return Victim end,
        GetAttacker = function() return Attacker end
    })
    LogEvent("Damage", MessageLog, Time)
end


function OnPlayerDeath(Victim:player, Attacker:player)

    local Color = string.format("<font color = '#%s'>", Config.EventLogs.Colors.Death:ToHex())
    Client.OnEvent({
        GetName = function() return "player_death" end,
        GetVictim = function() return Victim end,
        GetAttacker = function() return Attacker end -- nil
    })
    LogEvent("Death", Color .. tostring(Victim) .. " died" .. "</font>", tick())
end


function OnLightingChanged(Property)
    if Config.Enviorment.Time.Enabled and Property == "TimeOfDay" then
        Lighting.TimeOfDay = Config.Enviorment.Time.Value
    end
    if Config.Enviorment.Ambient.Enabled then
        if Property == "Ambient" then
            Lighting.Ambient = Config.Enviorment.Ambient[1].Color
        end
        if Property == "OutdoorAmbient" then
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient[2].Color
        end
    end
end


function OnCreatorValueAdded(self)
    spawn(function()
        local Victim = Players:GetPlayerFromCharacter(self.Parent.Parent) -- Parented in humanoid
        local Attacker = Players:GetPlayerFromCharacter(self.Value)
        local Info = self:WaitForChild("Info", 10)
        local Damage = Info:FindFirstChild("Damage")
        if Damage then
            OnPlayerDamaged(Victim, Attacker, Damage.Value, tick())
        end
    end)
end


function OnBulletAdded(Bullet)
    if Bullet.Parent ~= Humanoid then return end
    BulletTick = math_round(os.clock() - FireTick, 5)

    local Origin = Bullet.Position

    spawn(function()
        Bullet:GetPropertyChangedSignal("Position"):Wait()
    
        local End = Bullet.Position
        local Direction = (End - Origin).Unit
        local Distance = 150
    
        if Config.BulletImpact.Enabled then CreateBulletImpact(End, Config.BulletImpact.Color) end
        if Target then
            Console:Warn("[DEBUG] Bullet position from target: " .. tostring(End - Target:GetAttribute("Position")))
            --Console:Warn("[DEBUG] Current Aimbot Vector Velocity Amplifier (" .. tostring(AimbotVectorVelocityAmplifier) .. ")")
        end
    
        -- TagSystem doesn't log Client damaged Player, so we have to raycast our bullets
        local Result = Raycast(Origin, Direction * Distance, {Camera, Character}) -- shouldn't this be done before the position change?
        local InterSection = Result and Result.Position or Origin + Direction
        local Distance = (Origin - InterSection).Magnitude
        local Part = Result and Result.Instance
    
        if Part then
            local Humanoid = Part.Parent:FindFirstChild("Humanoid") or Part.Parent.Parent:FindFirstChild("Humanoid")
            if Humanoid then
                if Original then -- not useful in prison, also the function isn't very reliable; snake please add damage logs in tagsystem
                    OnPlayerDamaged(Players:GetPlayerFromCharacter(Humanoid.Parent), Player, 0, tick())
                end
            end
        end
    
        if Config.HitMarkers.Enabled and (Config.HitMarkers.Type == "Model" or Config.HitMarkers.Type == "Crosshair + Model") then
            local Cross = DrawCross(Config.HitMarkers.Size, 4)
            Cross:SetColor(Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency)
            delay(1, function()
                if Config.HitMarkers.Fade then
                    Cross:FadeOut(Cross.Destroy)
                else
                    Cross:Destroy()
                end
            end)
            spawn(function()
                while Cross:IsAlive() do
                    local Position, Visible = Camera:WorldToViewportPoint(End)
                    Cross:SetVisible(Visible)
                    Cross:SetPosition(Vector2.new(Position.x, Position.y))
                    -- umm if some math god hits me up so true;
                    local Distance = (Camera.CFrame.Position - End).Magnitude
                    Cross:SetSize((Distance / 100) * 1 - Config.HitMarkers.Size)
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    end)


    spawn(function()
        local Trail = Bullet:WaitForChild("Trail")
        Bullet:WaitForChild("Attachment").Name = "Attachment0"
        Bullet:WaitForChild("Attachment").Name = "Attachment1"
        Trail.Enabled = not Config.BulletTracers.DisableTrails
        
        if Config.BulletTracers.Enabled and Config.BulletTracers.DisableTrails then -- Disable trails for bullet tracers
            local Tracer = Trail:Clone()
            Tracer.Color = ColorSequence.new(Config.BulletTracers.Color, Config.BulletTracers.Color)
            Tracer.Attachment0.Position = Vector3.new(0, -0.3, 0)
            Tracer.Attachment1.Position = Vector3.new(0, 0.3, 0)
            Tracer.Transparency = NumberSequence.new(0)
            --6091341618 ; 7151778302; 7071778278; 446111271; 3517446796; 7135001284; 7151842823; 7151777149; 5864341017; 6045867277; 6091329339; 6091474388; 1246346065
            Tracer.Texture = "rbxassetid://446111271"
            Tracer.TextureLength = 2
            Tracer.Lifetime = Config.BulletTracers.Lifetime / 1000 -- Clamped to Bullet Life
            Tracer.Enabled = true
            Tracer.Parent = Bullet
        end
        
        if Bullet.Parent == nil then Bullet.AncestryChanged:Wait() end
        Bullet.Parent = Camera -- Snake didn't account for LocalTransparency so if ur in first person we can now see them again
        delay(15, Bullet.Destroy, Bullet)
    end)
end


function OnWorkspaceChildAdded(self)
    local Name = tostring(self)
    
    if Name == "RandomSpawner" then
        delay(0, AddItem, self)
    elseif self:IsA("Decal") then
        if Config.HideSprays.Enabled then
            local Parent = self.Parent
            if Parent:IsA("Part") then
                local ObjectName = tostring(Parent)
                if string.find(ObjectName, "Spray") and not string.find(ObjectName, "$20") then
                    self.Transparency = 1

                    local Event
                    Event = self:GetPropertyChangedSignal("Transparency"):Connect(function()
                        if not Config.HideSprays.Enabled then return Event:Disconnect() end
                        self.Transparency = 1
                    end)

                    delay(2.5, Event.Disconnect, Event)
                end
            end
        end
    end
end


function OnWorkspaceChildRemoved(self)
    local Name = tostring(self)
    if Name == "RandomSpawner" then
        Items[self] = nil
    end
end


function OnGetMouseInvoke() -- Uuh but weguwarid why don't u just hook mouse.hit and mouse.target; FUCK U
    FireTick = os.clock()
    if Target and Target.Character and Config.Aimbot.Enabled then
        return GetAimbotCFrame(true) or Mouse.Hit, Target.Character
    end

    return Mouse.Hit, Mouse.Target
end


function OnTagReplicateEvent(State, Data)
    for _, v in pairs(Data) do
        for _, v2 in pairs(v) do
            local Name = v2.n
            
            if Name == "creator" then
                local Me = v2.m -- Incase player changes their name on client (Don't do that retard)
                local Tick = string.gsub(v2.t, tostring(Me) .. Name .. "0" , "") -- Thanks for adding this extra useless shit, retarded snake
                local Value = v2.v

                local Victim = Player
                local Attacker = Players:GetPlayerFromCharacter(Value)
                OnPlayerDamaged(Victim, Attacker, 0, Tick)
            end
        end
    end
end


-- Key bind toggles


function AimbotToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.Aimbot.Enabled = not Config.Aimbot.Enabled
        Menu:FindItem("Combat", "Aimbot", "CheckBox", "Enabled"):SetValue(Config.Aimbot.Enabled)
        Menu.Keybinds.List.Aimbot:Update(Config.Aimbot.Enabled and "on" or "off")
        Menu.Keybinds.List.Aimbot:SetVisible(Config.Aimbot.Enabled)
    end
end


function AutoFireToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.AutoFire.Enabled = not Config.AutoFire.Enabled
        Menu:FindItem("Combat", "Aimbot", "CheckBox", "Auto Fire"):SetValue(Config.AutoFire.Enabled)
    end
end


function CameraLockToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.CameraLock.Enabled = not Config.CameraLock.Enabled
        Menu:FindItem("Combat", "Aimbot", "CheckBox", "Camera Lock"):SetValue(Config.CameraLock.Enabled)
        Menu.Keybinds.List["Camera Lock"]:Update(Config.CameraLock.Enabled and "on" or "off")
        Menu.Keybinds.List["Camera Lock"]:SetVisible(Config.CameraLock.Enabled)
    end
end


function FlyToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.Flight.Enabled = not Config.Flight.Enabled
        if Humanoid and not Config.Flight.Enabled then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        Menu:FindItem("Player", "Movement", "CheckBox", "Flight"):SetValue(Config.Flight.Enabled)
        Menu.Keybinds.List.Flight:Update(Config.Flight.Enabled and "on" or "off")
        Menu.Keybinds.List.Flight:SetVisible(Config.Flight.Enabled)
    end
end


function BlinkToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.Blink.Enabled = not Config.Blink.Enabled
        Menu:FindItem("Player", "Movement", "CheckBox", "Blink"):SetValue(Config.Blink.Enabled)
        Menu.Keybinds.List.Blink:Update(Config.Blink.Enabled and "on" or "off")
        Menu.Keybinds.List.Blink:SetVisible(Config.Blink.Enabled)
    end
end


function FloatToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.Float.Enabled = not Config.Float.Enabled
        FloatPart.CanCollide = Config.Float.Enabled
        Menu:FindItem("Player", "Movement", "CheckBox", "Float"):SetValue(Config.Float.Enabled)
        Menu.Keybinds.List.Float:Update(Config.Float.Enabled and "on" or "off")
        Menu.Keybinds.List.Float:SetVisible(Config.Float.Enabled)
    end
end


function NoclipToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.Noclip.Enabled = not Config.Noclip.Enabled
        Menu:FindItem("Player", "Movement", "CheckBox", "Noclip"):SetValue(Config.Noclip.Enabled)
        Menu.Keybinds.List.Noclip:Update(Config.Noclip.Enabled and "on" or "off")
        Menu.Keybinds.List.Noclip:SetVisible(Config.Noclip.Enabled)
    end
end


function AntiAimToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Config.AntiAim.Enabled = not Config.AntiAim.Enabled
        UpdateAntiAim()
        Menu:FindItem("Player", "Anti-Aim", "CheckBox", "Enabled"):SetValue(Config.AntiAim.Enabled)
        Menu.Keybinds.List["Anti Aim"]:Update(Config.AntiAim.Enabled and "on" or "off")
        Menu.Keybinds.List["Anti Aim"]:SetVisible(Config.AntiAim.Enabled)
    end
end


function CommandBarToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        local CommandBar = Menu.CommandBar
        CommandBar:CaptureFocus()
        CommandBar:TweenPosition(UDim2.new(0.5, -100, 0.6, -10), nil, nil, 0.2, true)
        delay(0, function() CommandBar.Text = "" end)
    end
end


function MenuToggle(Action_Name, State, Input)
    if not State or State == Enum.UserInputState.Begin then
        Menu:SetVisible(not Menu.IsVisible)
    end
end


-- Game Hook

if Original then

    for _, Connection in ipairs(getconnections(ScriptContext.Error)) do
        if getfenv(Connection.Function).script == PlayerGui.LocalScript then
            Connection:Disable()
        end
    end

    --[[
    local OldHas
    OldHas = hookfunction(TagSystem.has, function(self, ...)
        local Arguments = {...}
        local Key = Arguments[1]
        if Config.NoSlow.Enabled or Config.God.Enabled then
            if Key == "gunslow" or Key == "creatorslow" or Key == "action" or Key == "Action" then return end
            -- CurrentSpeed = 0
        end
        return OldHas(self, ...)
    end)
    --]]
end


function get_running_function(Character)
    local Script = Character:WaitForChild("Animate")
    local Function

    for k, v in pairs(getreg()) do
        if typeof(v) == "function" and getfenv(v).script == Script then
            if getconstant(v, 1) == 0.01 then
                Function = v
                break
            end
        end
    end

    function fire_running_function(Amount) -- will overwrite
        if Function then
            Function(Amount / 10)
        end
    end
end


local Index, NewIndex, NameCall

function OnIndex(self, Key)
    local Caller = checkcaller()

    if not Caller then
        local Name = tostring(self)

        if (Config.NoSlow.Enabled or Config.God.Enabled) then
            if (Name == "Stamina" or Name == "Stann") and (Key == "Value") then
                return 100
            end
            if not Original then
                if self == Root and Key == "Anchored" and (Tool and Tool.GetAttribute(Tool, "Gun")) then
                    return false
                end
            end
        end

        if self == ScriptContext and Key == "Error" then
            return {connect = function() end} -- HACKED
        end

        if Name == "Namer" and Config.God.Enabled then return "Torso" end
        if Name == "LocalScript" and Key == "Disabled" then return false end
    end

    return Index(self, Key)
end


function OnNewIndex(self, Key, Value)
    local Caller = checkcaller()
    if Caller then return NewIndex(self, Key, Value) end

    if self == Mouse and Key == "Icon" then return end
    if Original and Key == "OnClientInvoke" and tostring(self) == "GetMouse" then Value = OnGetMouseInvoke end

    if self == Humanoid then
        if Key == "WalkSpeed" then
            local IsRunning = Value > 16
            local IsWalking = Value == 16
            local IsCrouching = Value == 8
            local Hit = Value == 2
            local CantMove = Value == 0

            Running = IsRunning
            Crouching = IsCrouching

            if (Config.NoSlow.Enabled or Config.God.Enabled) and (CantMove or Hit) then return end

            Value = (IsRunning and Config.RunSpeed.Value) or (IsCrouching and Config.CrouchSpeed.Value) or (IsWalking and Config.WalkSpeed.Value)
        end

        if Key == "JumpPower" then
            Value = (Value > 0 and Config.JumpPower.Value) or (Value == 0 and (Config.NoSlow.Enabled or Config.God.Enabled) and Config.JumpPower.Value or 0)
        end

        if Key == "AutoRotate" then Value = true end

        if (Key == "Jump" and not Value) and (Config.NoSlow.Enabled or Config.God.Enabled) then return end
        if Key == "Health" then return end
    end

    if Key == "CFrame" and self:IsDescendantOf(Character) then return end
    return NewIndex(self, Key, Value)
end


function OnNameCall(self, ...)
    local Arguments = {...}
    local Name = tostring(self)
    local Caller, Method = checkcaller(), getnamecallmethod()

    if self == Player and Method == "Kick" then return end

    if Method == "FireServer" then
        if self.Parent == ReplicatedStorage then
            -- This is kinda retarded LOL
            if string.find(Name, "l") and string.find(Name, "i") and #Name < 7 then return end
        end
        if Name == "SayMessageRequest" then
            table.insert(ChatScheduler, Arguments[1])
        end
        if Name == "Input" then
            local Key = Arguments[1]
            if Key == "bv" or Key == "hb" or Key == "ws" or Key == "strafe" then return end
            if Key == "ml" or Key == "moff1" then
                if not Arguments[2] then Arguments[2] = {} end
                -- MouseHit only thing required for attacking/unattacking
                -- Server indexes mousehit.p so we can also do {p = Vector3.new()}
                Arguments[2].mousehit = Mouse.Hit or CFrame.new()
                Arguments[2].velo = 16 -- just incase shift is somehow true
                if Target and Config.Aimbot.Enabled then
                    Arguments[2].mousehit = GetAimbotCFrame(true) or Mouse.Hit
                end
                if Config.AlwaysGroundHit.Enabled then
                    Arguments[2].shift = true
                end
                FireTick = os.clock()
            end
        end
        if Name == "Fire" then
            Arguments[1] = Mouse.Hit or CFrame.new()
            if Target and Config.Aimbot.Enabled and ((not Caller) or Arguments[2]) then -- Arguments[2] =  (AutShoot)
                Arguments[1] = GetAimbotCFrame(true) or Mouse.Hit
            end
            FireTick = os.clock()
        end
        if Name == "Touch1" then
            if Config.AlwaysGroundHit.Enabled then
                Arguments[3] = true
            end
        end
        if not Caller and Arguments[1] == "play" and Arguments[2] then
            LastAudio = Arguments[2]
            if not table.find(AudioLogs, LastAudio) then
                table.insert(AudioLogs, LastAudio)
                writefile("Identification/Games/The Streets/Audios.dat", table.concat(AudioLogs, "\n"))
            end
        end
    end

    if Method == "Destroy" or Method == "Remove" or Method == "destroy" or Method == "remove" then
        if FlyVelocity.Parent == self then
            FlyVelocity.Parent = nil
        end
        if FlyAngularVelocity.Parent == self then
            FlyAngularVelocity.Parent = nil
        end
    end

    if not Caller then
        if self.ClassName == "AnimationTrack" then
            local AnimationId = string.gsub(self.Animation.AnimationId, "%D", "")
            if Method == "Play" then
                if AnimationId == "458506542" or AnimationId == "8587081257" or AnimationId == "376653421" or AnimationId == "1484589375" then
                    if Config.Animations.Run.Enabled then
                        local Style = Config.Animations.Run.Style
                        self = Style == "Default" and Animations.Run.self or Style == "Style-2" and Animations.Run2.self or Animations.Run3.self
                    end
                    --Arguments[1] = Speed
                end
            end
            if Method == "Stop" then
                if AnimationId == "458506542" or AnimationId == "8587081257" or AnimationId == "376653421" or AnimationId == "1484589375" then
                    if Config.Animations.Run.Enabled then -- if we are running a custom anim then lets stop it too
                        local Style = Config.Animations.Run.Style
                        self = Style == "Default" and Animations.Run.self or Style == "Style-2" and Animations.Run2.self or Animations.Run3.self
                    end
                    --Animations.Run.self:Stop()
                    --Animations.Run2.self:Stop()
                    --Animations.Run3.self:Stop()
                end
            end
        end
        if Method == "Destroy" then
            if self == Character then return end
            if string.find(self.ClassName, "Body") then return end
        end
        if self == Character and Method == "BreakJoints" then return end
        if (Method == "WaitForChild" or Method == "FindFirstChild" or Method == "findFirstChild") then
            local Key = Arguments[1]
            if Config.NoSlow.Enabled and ((Key == "Action") or (Key == "Info" and self.ClassName ~= "Tool")) then return end -- Checks for OnHit :: Play Anim
            if self == Character and Key == "HumanoidRootPart" then
                Arguments[1] = "Torso"
            end
        end
    end
    
    return NameCall(self, unpack(Arguments))
end


--if u do getgenv().hookmetamethod then ur the retard not me fuck you
if not hookmetamethod then while true do end end -- just incase someone tries to use a krnl for this script, sorry for the crash but I would rather crash you than you getting banned
Index = hookmetamethod(game, "__index", OnIndex)
NewIndex = hookmetamethod(game, "__newindex", OnNewIndex)
NameCall = hookmetamethod(game, "__namecall", OnNameCall)


--local mt = getrawmetatable(game); setreadonly(mt, false); local old_namecall = mt.__namecall; mt.__namecall = function(...) return old_namecall(...) end


-- Commands

local CommandsList = [[
commands - lists all of the commands,
walkspeed [number] - sets your "walkspeed" to "number",
jumppower [number] - sets your "jumppower" to "number",
runspeed [number] - sets your "runspeed" to "number",
crouchspeed [number] - sets your "crouchspeed" to "number",
hipheight [number] - sets your "hipheight" to "number",
gravity [number] - sets the world "gravity" to "number",
blink - enables "blink mode",
unblink - disables "blink mode",
fly - enables "flight",
unfly - disables "flight",
float - enables "float",
unfloat - disables "float",
noclip - enables "noclip",
clip - disables "noclip",
god - enables "god mode",
ungod - disables "god mode",
rejoin - attempts to rejoin to the current server,
swap - teleports either to the streets or the prison,
goto [player] - teleports to the "player",
item [name] - if the item is found then it teleports you to the item,
play [id] - mass plays the selected "id",
bypass [the prison] - Attempts to give you tool and teleport bypass,

-- Console Commands --

clear - clears the output from the console,
]]

Commands.Add("walkspeed", {"ws"}, "", function(Arguments)
    Config.WalkSpeed.Value = Arguments[1] or 16
    Menu:FindItem("Player", "Movement", "Slider", "Walk Speed"):SetValue(Config.WalkSpeed.Value)
end)

Commands.Add("jumppower", {"jp"}, "", function(Arguments)
    Config.JumpPower.Value = Arguments[1] or 37.5
    Menu:FindItem("Player", "Movement", "Slider", "Jump Power"):SetValue(Config.JumpPower.Value)
end)

Commands.Add("runspeed", {"rs"}, "", function(Arguments)
    Config.RunSpeed.Value = Arguments[1] or 24.5
    Menu:FindItem("Player", "Movement", "Slider", "Run Speed"):SetValue(Config.RunSpeed.Value)
end)

Commands.Add("crouchspeed", {"cs"}, "", function(Arguments)
    Config.CrouchSpeed.Value = Arguments[1] or 8
    Menu:FindItem("Player", "Movement", "Slider", "Crouch Speed"):SetValue(Config.CrouchSpeed.Value)
end)

Commands.Add("hipheight", {"hh"}, "", function(Arguments)
    Humanoid.HipHeight = Arguments[1] or 0
end)

Commands.Add("gravity", {}, "", function(Arguments)
    workspace.Gravity = Arguments[1] or 196.05
end)

Commands.Add("blink", {"cfwalk"}, "", function()
    Config.Blink.Enabled = true
    Menu:FindItem("Player", "Movement", "CheckBox", "Blink"):SetValue(Config.Blink.Enabled)
end)

Commands.Add("unblink", {"uncfwalk"}, "", function()
    Config.Blink.Enabled = false
    Menu:FindItem("Player", "Movement", "CheckBox", "Blink"):SetValue(Config.Blink.Enabled)
end)

Commands.Add("fly", {"flight"}, "", function()
    FlyToggle()
end)

Commands.Add("unfly", {"noflight"}, "", function()
    Config.Flight.Enabled = false
    Menu:FindItem("Player", "Movement", "CheckBox", "Flight"):SetValue(Config.Flight.Enabled)
end)

Commands.Add("float", {"airwalk"}, "", function()
    Config.Float.Enabled = not Config.Float.Enabled
    FloatPart.CanCollide = Config.Float.Enabled
    Menu:FindItem("Player", "Movement", "CheckBox", "Float"):SetValue(Config.Float.Enabled)
end)

Commands.Add("unfloat", {"unairwalk"}, "", function()
    Config.Float.Enabled = false
    FloatPart.CanCollide = false
    Menu:FindItem("Player", "Movement", "CheckBox", "Float"):SetValue(Config.Float.Enabled)
end)

Commands.Add("noclip", {}, "", function()
    Config.Noclip.Enabled = true
    Menu:FindItem("Player", "Movement", "CheckBox", "Noclip"):SetValue(Config.Noclip.Enabled)
end)

Commands.Add("clip", {}, "", function()
    Config.Noclip.Enabled = false
    Menu:FindItem("Player", "Movement", "CheckBox", "Noclip"):SetValue(Config.Noclip.Enabled)
end)

Commands.Add("god", {}, "", function()
    Config.God.Enabled = true
    Menu:FindItem("Misc", "Exploits", "CheckBox", "God"):SetValue(Config.God.Enabled)
end)

Commands.Add("ungod", {}, "", function()
    Config.God.Enabled = false
    Menu:FindItem("Misc", "Exploits", "CheckBox", "God"):SetValue(Config.God.Enabled)
end)

Commands.Add("reset", {"re"}, "", RefreshCharacter)

Commands.Add("car", {"bringcar"}, "", function()
    local Jeep = workspace:FindFirstChild("Jeep")
    if Jeep then
        local Seat = Jeep:FindFirstChild("DriveSeat", true)
        if Seat then
            if Seat.Occupant then
                Menu.Notify("Car is occupied by someone else!", 5)
                return
            end
            if not IsSeated() then Seat:Sit(Humanoid) end
        end
    else
        Menu.Notify("Car not found!", 5)
    end
end)

Commands.Add("rejoin", {"rj"}, "", function()
    TeleportToPlace(game.PlaceId, game.JobId)
end)

Commands.Add("swap", {}, "", function()
    TeleportToPlace(Original and 4669040 or 455366377)
end)

Commands.Add("goto", {"to"}, "", function(Arguments)
    if not Arguments[1] then return end
    local Target = GetPlayer(Arguments[1])
    for _, Target in ipairs(Target) do
        local Root = GetRoot(Target)
        if Root then
            Teleport(Root.CFrame)
            break
        end
    end
end)

Commands.Add("item", {"get"}, "", function(Arguments)
    local Found, Part, Price
    local Item_Name = string.lower(table.concat(Arguments, " "))
    for _, Item in pairs(Items) do
        if string.lower(Item:GetAttribute("Item")) == Item_Name then
            Found = true
            Teleport(Item.CFrame)
            break
        end
    end
    if Original and not Found then BuyItem(Item_Name) end
end)

Commands.Add("play", {}, "", function(Arguments)
    local Audio = Arguments[1]
    local Remotes = {}
    for _, Tool in ipairs(GetTools()) do
        if tostring(Tool) == "BoomBox" then
            Tool.Parent = Character
            local Remote = Tool:FindFirstChildWhichIsA("RemoteEvent", true)
            if Remote then table.insert(Remotes, Remote) end
        end
    end

    delay(0, function()
        if Audio == "stop" then
            for _, Remote in ipairs(Remotes) do Remote:FireServer("stop") end
        else
            for _, Remote in ipairs(Remotes) do Remote:FireServer("play", Audio) end
        end
    end)
end)

Commands.Add("bypass", {}, "", function()
    if not Original then
        queue_on_teleport([[
            if not game:IsLoaded() then game.Loaded:Wait() end -- Synapse is shit
            game:GetService("TeleportService"):TeleportToPlaceInstance(4669040, game.JobId)
        ]])
        TeleportToPlace(game.PlaceId, game.JobId)
    end
end)

--[[
    Commands.Add("breakpads", {"breakbuypads"}, "", function()
        if Original then
            Humanoid:Destroy() -- Kicks you, disabling for now
            Backpack:Destroy() -- If This Replicated It Would Also Break Them
            BuyItem("Glock")
        end
    end)
]]

Commands.Add("key", {"bind"}, "", function(Arguments)
    local Name, Key, Command = table.remove(Arguments, 1), table.remove(Arguments, 1), table.remove(Arguments, 1)
    if Name and Key and Command then
        Name = string.lower(Name)
        Key = string.lower(Key)
        for _, v in ipairs(Enum.KeyCode:GetEnumItems()) do
            if Key == string.lower(v.Name) then Key = v break end
        end

        for _, v in ipairs(Enum.UserInputType:GetEnumItems()) do
            if Key == string.lower(v.Name) then Key = v break end
        end

        if Name and Key then
            BindKey(Name, "Remove")
            BindKey(Name, "Add", Key, Command, Arguments)
        end
    end
end)

Commands.Add("unkey", {"unbind"}, "", function(Arguments)
    local Name = Arguments[1]
    if Name then BindKey(string.lower(Name), "Remove") end
end)

Commands.Add("commands", {"cmds"}, "", function()
    Console:Write(CommandsList)
end)

Commands.Add("clear", {"cls"}, "", function()
    Console:Clear()
    Console:Write([[
$$$$$$\      $$\                      $$\     $$\  $$$$$$\  $$\                     $$\     $$\                     
\_$$  _|     $$ |                     $$ |    \__|$$  __$$\ \__|                    $$ |    \__|                    
  $$ |  $$$$$$$ | $$$$$$\  $$$$$$$\ $$$$$$\   $$\ $$ /  \__|$$\  $$$$$$$\ $$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\  
  $$ | $$  __$$ |$$  __$$\ $$  __$$\\_$$  _|  $$ |$$$$\     $$ |$$  _____|\____$$\\_$$  _|  $$ |$$  __$$\ $$  __$$\ 
  $$ | $$ /  $$ |$$$$$$$$ |$$ |  $$ | $$ |    $$ |$$  _|    $$ |$$ /      $$$$$$$ | $$ |    $$ |$$ /  $$ |$$ |  $$ |
  $$ | $$ |  $$ |$$   ____|$$ |  $$ | $$ |$$\ $$ |$$ |      $$ |$$ |     $$  __$$ | $$ |$$\ $$ |$$ |  $$ |$$ |  $$ |
$$$$$$\\$$$$$$$ |\$$$$$$$\ $$ |  $$ | \$$$$  |$$ |$$ |      $$ |\$$$$$$$\\$$$$$$$ | \$$$$  |$$ |\$$$$$$  |$$ |  $$ |
\______|\_______| \_______|\__|  \__|  \____/ \__|\__|      \__| \_______|\_______|  \____/ \__| \______/ \__|  \__|                                                                                                                                                                                                                                                                                                   
]])
    Console:Write("\nType 'cmds' to see the commands!")
end)

Commands.Add("steal", {"st", "log"}, "steal ([audio]/[decal]) from [player]", function(Arguments)
    local asset_type = string.lower(tostring(Arguments[1]))
    local player_name = Arguments[2]

    local Target = GetPlayer(player_name)[1]
    if not Target then
        return Menu.Notify(string.format("<font color = '#%s'>player_name for argument[2] expected</font>", Config.EventLogs.Colors.Error:ToHex()))
    end

    if asset_type == "audio" or asset_type == "sound" or asset_type == "radio" or asset_type == "boombox" then
        local Tools = GetTools(Target)
        if Tools then
            for _, Tool in ipairs(Tools) do
                if tostring(Tool) == "BoomBox" then
                    local sound = Tool:FindFirstChildWhichIsA("Sound", true)
                    local sound_id = sound and sound.SoundId
                    if sound_id then
                        setclipboard(sound_id)
                        return Menu.Notify(string.format("<font color = '#%s'>set audio_id rbxassetid://'%s' to your clipboard</font>", Config.EventLogs.Colors.Success:ToHex(), sound_id))
                    end
                end
            end

            return Menu.Notify(string.format("<font color = '#%s'>no audio from player '%s' found</font>", Config.EventLogs.Colors:ToHex(), tostring(Target)))
        end
    elseif asset_type == "decal" or asset_type == "spray" then
        local spray_part = workspace:FindFirstChild(tostring(Target) .. "Spray")
        if spray_part then
            local decal = spray_part:WaitForChild("Decal")
            local decal_id = string.match(decal.Texture, "%d+")
            if not Original then decal_id += 1 end
            setclipboard(decal_id)
            return Menu.Notify(string.format("<font color = '#%s'>set decal_id rbxassetid://'%s' to your clipboard</font>", Config.EventLogs.Colors.Success:ToHex(), decal_id))
        else
            return Menu.Notify(string.format("<font color = '#%s'>no decal from player '%s' found</font>", Config.EventLogs.Colors.Error:ToHex(), tostring(Target)))
        end
        -- sign check?
    else
        return Menu.Notify(string.format("<font color = '#%s'>asset-type for argument[1] expected</font>", Config.EventLogs.Colors.Error:ToHex()))
    end
end)


-- User Interface

do
    Menu.Accent = Config.Menu.Accent

    Menu.AddAudioButton = function(Id)
        local Asset = GetAssetInfo(Id)
        local Name = Asset and Asset.Name

        if typeof(Name) == "string" then
            local AudioButton = Instance.new("TextButton")
            AudioButton.BackgroundColor3 = Color3.new(1, 1, 1)
            AudioButton.Size = UDim2.new(1, 0, 0, 22)
            AudioButton.Text = Name
            AudioButton.TextColor3 = Color3.new()
            AudioButton.Font = Enum.Font.SourceSans
            AudioButton.TextSize = 22
            AudioButton.Parent = Menu.BoomboxFrame.List
            AudioButton.MouseButton1Click:Connect(function()
                pcall(function()
                    PlayerGui.BoomBoxu.Entry.TextBox.Text = Id
                    LastAudio = Id
                    for _, Object in ipairs(Character:GetChildren()) do
                        if tostring(Object) == "BoomBox" then Object.RemoteEvent:FireServer("play", Id) end
                    end
                end)
            end)

            Menu.BoomboxFrame.List.CanvasSize += UDim2.fromOffset(0, 22)
            return AudioButton
        end
    end
    

    Menu.Screen.Name = "Identification"
    Menu.SetTitle(Menu, string.format("Identification.%scc%s", "<font color = '#" .. Config.Menu.Accent:ToHex() .. "'>", "</font>")) -- Can't namecall since synapse is shit

    Menu.Tab("Combat")
    Menu.Tab("Visuals")
    Menu.Tab("Player")
    Menu.Tab("Misc")
    Menu.Tab("Settings")

    Menu.Container("Combat", "Aimbot", "Left")
    Menu.Container("Combat", "Other", "Right")
    Menu.Container("Player", "Movement", "Left")
    Menu.Container("Player", "Other", "Right")
    Menu.Container("Player", "Anti-Aim", "Right")
    Menu.Container("Visuals", "ESP", "Left")
    Menu.Container("Visuals", "Local ESP", "Left")
    Menu.Container("Visuals", "Item ESP", "Left")
    Menu.Container("Visuals", "Hit markers", "Left")
    Menu.Container("Visuals", "Other", "Right")
    Menu.Container("Visuals", "Interface", "Right")
    Menu.Container("Visuals", "World", "Right")
    Menu.Container("Visuals", "Weapons", "Right")
    Menu.Container("Visuals", "Hats", "Right"):SetVisible(Original)
    Menu.Container("Misc", "Main", "Left")
    Menu.Container("Misc", "Animations", "Left")
    Menu.Container("Misc", "Exploits", "Left")
    Menu.Container("Misc", "Players", "Right")
    Menu.Container("Misc", "Clan Tag", "Right"):SetVisible(Original)
    Menu.Container("Settings", "Demo Recorder", "Left")
    Menu.Container("Settings", "Settings", "Left")
    Menu.Container("Settings", "Menu", "Left")
    Menu.Container("Settings", "Configs", "Right")

    Menu.CheckBox("Combat", "Aimbot", "Enabled", Config.Aimbot.Enabled, function(Bool)
        AimbotToggle()
    end)

    Menu.Hotkey("Combat", "Aimbot", "Aimbot Key", Config.Aimbot.Key, function(KeyCode, State)
        Config.Aimbot.Key = KeyCode
        --[[
        Config.Keybinds.Client = {
            Key = KeyCode,
            State = State
        }]]
        ContextAction:BindAction("aimbotToggle", AimbotToggle, false, KeyCode)
    end)

    Menu.CheckBox("Combat", "Aimbot", "Auto Fire", Config.AutoFire.Enabled, function(Bool)
        AutoFireToggle()
    end)
    Menu.Slider("Combat", "Aimbot", "Auto Fire Range", 5, 150, Config.AutoFire.Range, nil, 1, function(Value)
        Config.AutoFire.Range = Value
    end)
    Menu.CheckBox("Combat", "Aimbot", "Camera Lock", Config.CameraLock.Enabled, function(Bool)
        Config.CameraLock.Enabled = Bool
    end)
    Menu.Hotkey("Combat", "Aimbot", "Camera Lock Key", Config.CameraLock.Key, function(KeyCode)
        Config.CameraLock.Key = KeyCode
        ContextAction:BindAction("cameraLockToggle", CameraLockToggle, false, Config.CameraLock.Key)
    end)
    Menu.ComboBox("Combat", "Aimbot", "Target Hitbox", Config.Aimbot.HitBox, {"Head", "Torso", "Root"}, function(String)
        Config.Aimbot.HitBox = String
    end)
    Menu.ComboBox("Combat", "Aimbot", "Target Selection", Config.Aimbot.TargetSelection, {"Near Player", "Near Mouse"}, function(String)
        Config.Aimbot.TargetSelection = String
    end)
    Menu.CheckBox("Combat", "Other", "Always Ground Hit", Config.AlwaysGroundHit.Enabled, function(Bool)
        Config.AlwaysGroundHit.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Stomp Spam", Config.StompSpam.Enabled, function(Bool)
        Config.StompSpam.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Auto Attack", false, function(Bool)
        Config.AutoAttack.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Auto Stomp", Config.AutoStomp.Enabled, function(Bool)
        Config.AutoStomp.Enabled = Bool
        --Menu.Indicators.List["Automatic Stomp"]:Update(Config.AutoStomp.Enabled)
    end)
    Menu.Slider("Combat", "Other", "Auto Stomp Range", 5, 50, Config.AutoStomp.Distance, nil, 1, function(Value)
        Config.AutoStomp.Distance = Value
    end)
    Menu.ComboBox("Combat", "Other", "Auto Stomp Target", Config.AutoStomp.Target, {"Target", "Whitelist", "All"}, function(String)
        Config.AutoStomp.Target = String
    end)
    Menu.Slider("Player", "Movement", "Walk Speed", 0, 500, Config.WalkSpeed.Value, nil, 1, function(Value)
        Config.WalkSpeed.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Jump Power", 0, 500, Config.JumpPower.Value, nil, 1, function(Value)
        Config.JumpPower.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Run Speed", 0, 500, Config.RunSpeed.Value, nil, 1, function(Value)
        Config.RunSpeed.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Crouch Speed", 0, 500, Config.CrouchSpeed.Value, nil, 1, function(Value)
        Config.CrouchSpeed.Value = Value
    end)
    Menu.CheckBox("Player", "Movement", "Blink", Config.Blink.Enabled, function(Bool)
        BlinkToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Blink Key", Config.Blink.Key, function(KeyCode)
        Config.Blink.Key = KeyCode
        ContextAction:BindAction("blinkToggle", BlinkToggle, false, Config.Blink.Key)
    end)
    Menu.Slider("Player", "Movement", "Blink Speed", 0.1, 20, Config.Blink.Speed, nil, 1, function(Value)
        Config.Blink.Speed = Value
    end)
    Menu.CheckBox("Player", "Movement", "Flight", Config.Flight.Enabled, function(Bool)
        FlyToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Flight Key", Config.Flight.Key, function(KeyCode)
        Config.Flight.Key = KeyCode
        ContextAction:BindAction("flyToggle", FlyToggle, false, KeyCode)
    end)
    Menu.Slider("Player", "Movement", "Flight Speed", 0.1, 20, Config.Flight.Speed, nil, 1, function(Value)
        Config.Flight.Speed = Value
    end)
    Menu.CheckBox("Player", "Movement", "Float", Config.Float.Enabled, function(Bool)
        FloatToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Float Key", Config.Float.Key, function(KeyCode)
        Config.Float.Key = KeyCode
        ContextAction:BindAction("floatToggle", FloatToggle, false, KeyCode)
    end)
    Menu.CheckBox("Player", "Movement", "Infinite Jump", Config.InfiniteJump.Enabled, function(Bool)
        Config.InfiniteJump.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Movement", "Noclip", Config.Noclip.Enabled, function(Bool)
        NoclipToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Noclip Key", Config.Noclip.Key, function(KeyCode)
        Config.Noclip.Key = KeyCode
        ContextAction:BindAction("noclipToggle", NoclipToggle, false, KeyCode)
    end)
    Menu.CheckBox("Player", "Other", "No Knock Out", Config.NoKnockOut.Enabled, function(Bool)
        Config.NoKnockOut.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "No Slow", Config.NoSlow.Enabled, function(Bool)
        Config.NoSlow.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Anti Ground Hit", Config.AntiGroundHit.Enabled, function(Bool)
        Config.AntiGroundHit.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Anti Fling", Config.AntiFling.Enabled, function(Bool)
        Config.AntiFling.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Hide Tools", HideTools, function(Bool) -- ??
        HideTools = Bool
    end)
    Menu.CheckBox("Player", "Other", "Death Teleport", Config.DeathTeleport.Enabled, function(Bool)
        Config.DeathTeleport.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Flipped", Config.Flipped.Enabled, function(Bool)
        Config.Flipped.Enabled = Bool
    end)

    Menu.CheckBox("Player", "Anti-Aim", "Enabled", Config.AntiAim.Enabled, function(Bool)
        AntiAimToggle()
        UpdateAntiAim()
    end)
    Menu.Hotkey("Player", "Anti-Aim", "Anti Aim Key", Config.AntiAim.Key, function(KeyCode)
        Config.AntiAim.Key = KeyCode
        ContextAction:BindAction("antiAimToggle", AntiAimToggle, false, Config.AntiAim.Key)
    end)
    Menu.ComboBox("Player", "Anti-Aim", "Anti Aim Type", Config.AntiAim.Type, {"Desync", "Velocity"}, function(String)
        Config.AntiAim.Type = String
        Menu.Keybinds.List["Anti Aim"]:Update("[" .. Config.AntiAim.Type .. "]")
        UpdateAntiAim()
    end)

    Menu.CheckBox("Visuals", "ESP", "Enabled", Config.ESP.Enabled, function(Bool)
        Config.ESP.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Target Lock", Config.ESP.ForceTarget, function(Bool)
        Config.ESP.ForceTarget = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Target Override", Config.ESP.TargetOverride.Enabled, function(Bool)
        Config.ESP.TargetOverride.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Target Override Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Target Override Color", Config.ESP.TargetOverride.Color, Config.ESP.TargetOverride.Transparency, function(Color, Transparency)
        Config.ESP.TargetOverride.Color = Color
        Config.ESP.TargetOverride.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Whitelist Override", Config.ESP.WhitelistOverride.Enabled, function(Bool)
        Config.ESP.WhitelistOverride.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Whitelist Override Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Whitelist Override Color", Config.ESP.WhitelistOverride.Color, Config.ESP.WhitelistOverride.Transparency, function(Color, Transparency)
        Config.ESP.WhitelistOverride.Color = Color
        Config.ESP.WhitelistOverride.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Box", Config.ESP.Box.Enabled, function(Bool)
        Config.ESP.Box.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Box Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "ComboBox", "Box Type"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Box Color", Config.ESP.Box.Color, 1 - Config.ESP.Box.Transparency, function(Color, Transparency)
        Config.ESP.Box.Color = Color
        Config.ESP.Box.Transparency = 1 - Transparency
    end)
    Menu.ComboBox("Visuals", "ESP", "Box Type", Config.ESP.Box.Type, {"Default", "Corners"}, function(String)
        Config.ESP.Box.Type = Value
    end)
    Menu.CheckBox("Visuals", "ESP", "Skeleton", Config.ESP.Skeleton.Enabled, function(Bool)
        Config.ESP.Skeleton.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Skeleton Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Skeleton Color", Config.ESP.Skeleton.Color, 1 - Config.ESP.Skeleton.Transparency, function(Color, Transparency)
        Config.ESP.Skeleton.Color = Color
        Config.ESP.Skeleton.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Chams", Config.ESP.Chams.Enabled, function(Bool)
        Config.ESP.Chams.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ComboBox", "Chams Render Mode"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams Outline Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "CheckBox", "Chams Auto Outline Color"):SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "ESP", "Chams Auto Outline Color", Config.ESP.Chams.AutoOutlineColor, function(Bool)
        Config.ESP.Chams.AutoOutlineColor = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Chams Color", Config.ESP.Chams.Color, Config.ESP.Chams.Transparency, function(Color, Transparency)
        Config.ESP.Chams.Color = Color
        Config.ESP.Chams.Transparency = Transparency
    end)
    Menu.ColorPicker("Visuals", "ESP", "Chams Outline Color", Config.ESP.Chams.OutlineColor, Config.ESP.Chams.OutlineTransparency, function(Color, Transparency)
        Config.ESP.Chams.OutlineColor = Color
        Config.ESP.Chams.OutlineTransparency = Transparency
    end)
    Menu.ComboBox("Visuals", "ESP", "Chams Render Mode", Config.ESP.Chams.RenderMode, {"Default", "Walls"}, function(String)
        Config.ESP.Chams.RenderMode = String
    end)
    Menu.CheckBox("Visuals", "ESP", "Knocked Out Chams", Config.ESP.Chams.KnockedOut.Enabled, function(Bool)
        Config.ESP.Chams.KnockedOut.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked Out Chams Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Knocked Out Chams Color", Config.ESP.Chams.KnockedOut.Color, Config.ESP.Chams.KnockedOut.Transparency, function(Color, Transparency)
        Config.ESP.Chams.KnockedOut.Color = Color
        Config.ESP.Chams.KnockedOut.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Snapline", Config.ESP.Snaplines.Enabled, function(Bool)
        Config.ESP.Snaplines.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Snapline Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "CheckBox", "Snapline offscreen"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Snapline Color", Config.ESP.Snaplines.Color, 1 - Config.ESP.Snaplines.Transparency, function(Color, Transparency)
        Config.ESP.Snaplines.Color = Color
        Config.ESP.Snaplines.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Snapline offscreen", Config.ESP.Snaplines.OffScreen, function(Bool)
        Config.ESP.Snaplines.OffScreen = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "OOF Arrows", Config.ESP.Arrows.Enabled, function(Bool)
        Config.ESP.Arrows.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "OOF Arrows Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "OOF Arrows Color", Config.ESP.Arrows.Color, 1 - Config.ESP.Arrows.Transparency, function(Color, Transparency)
        Config.ESP.Arrows.Color = Color
        Config.ESP.Arrows.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "ESP", "OOF Arrows offset", 5, 200, Config.ESP.Arrows.Offset, "px", 1, function(Int)
        Config.ESP.Arrows.Offset = Int
    end)
    Menu.CheckBox("Visuals", "ESP", "Health Bar", Config.ESP.Bars.Health.Enabled, function(Bool)
        Config.ESP.Bars.Health.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Health Bar Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "ESP", "CheckBox", "Health Bar Auto Color"):SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "ESP", "Health Bar Auto Color", Config.ESP.Bars.Health.AutoColor, function(Bool)
        Config.ESP.Bars.Health.AutoColor = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Health Bar Color"):SetVisible(not Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Health Bar Color", Config.ESP.Bars.Health.Color, 1 - Config.ESP.Bars.Health.Transparency, function(Color, Transparency)
        Config.ESP.Bars.Health.Color = Color
        Config.ESP.Bars.Health.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Knocked Out Bar", Config.ESP.Bars.KnockedOut.Enabled, function(Bool)
        Config.ESP.Bars.KnockedOut.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked Out Bar Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Knocked Out Bar Color", Config.ESP.Bars.KnockedOut.Color, 1 - Config.ESP.Bars.KnockedOut.Transparency, function(Color, Transparency)
        Config.ESP.Bars.KnockedOut.Color = Color
        Config.ESP.Bars.KnockedOut.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Ammo Bar", Config.ESP.Bars.Ammo.Enabled, function(Bool)
        Config.ESP.Bars.Ammo.Enabled = Bool
        Menu:FindItem("Visuals", "ESP", "ColorPicker", "Ammo Bar Color"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "ESP", "Ammo Bar Color", Config.ESP.Bars.Ammo.Color, 1 - Config.ESP.Bars.Ammo.Transparency, function(Color, Transparency)
        Config.ESP.Bars.Ammo.Color = Color
        Config.ESP.Bars.Ammo.Transparency = 1 - Transparency
    end)
    Menu.MultiSelect("Visuals", "ESP", "Flags", {
        Name = Config.ESP.Flags.Name.Enabled,
        Weapon = Config.ESP.Flags.Weapon.Text.Enabled,
        Ammo = Config.ESP.Flags.Ammo.Enabled,
        Vest = Config.ESP.Flags.Vest.Enabled,
        Health = Config.ESP.Flags.Health.Enabled,
        Stamina = Config.ESP.Flags.Stamina.Enabled,
        ["Knocked Out"] = Config.ESP.Flags.KnockedOut.Enabled,
        Distance = Config.ESP.Flags.Distance.Enabled,
        Velocity = Config.ESP.Flags.Velocity.Enabled
    }, function(Value)
        Config.ESP.Flags.Name.Enabled = Value["Name"]
        Config.ESP.Flags.Weapon.Text.Enabled = Value["Weapon"]
        Config.ESP.Flags.Ammo.Enabled = Value["Ammo"]
        Config.ESP.Flags.Vest.Enabled = Value["Vest"]
        Config.ESP.Flags.Health.Enabled = Value["Health"]
        Config.ESP.Flags.Stamina.Enabled = Value["Stamina"]
        Config.ESP.Flags.KnockedOut.Enabled = Value["Knocked Out"]
        Config.ESP.Flags.Distance.Enabled = Value["Distance"]
        Config.ESP.Flags.Velocity.Enabled = Value["Velocity"]
    end)
    Menu.ComboBox("Visuals", "ESP", "Font", Config.ESP.Font.Font, {"UI", "System", "Plex", "Monospace"}, function(String)
        Config.ESP.Font.Font = String
    end)
    Menu.ColorPicker("Visuals", "ESP", "Font Color", Config.ESP.Font.Color, 1 - Config.ESP.Font.Transparency, function(Color, Transparency)
        Config.ESP.Font.Color = Color
        Config.ESP.Font.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "ESP", "Font Size", 10, 32, Config.ESP.Font.Size, "px", 0, function(Value)
        Config.ESP.Font.Size = Value
    end)

    Menu.CheckBox("Visuals", "Local ESP", "Chams", Config.ESP.Chams.Local.Enabled, function(Bool)
        Config.ESP.Chams.Local.Enabled = Bool
        if Bool then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
        Menu:FindItem("Visuals", "Local ESP", "ColorPicker", "Chams Color"):SetVisible(Bool)
        Menu:FindItem("Visuals", "Local ESP", "Slider", "Chams Reflectance"):SetVisible(Bool)
        Menu:FindItem("Visuals", "Local ESP", "ComboBox", "Chams Material"):SetVisible(Bool)
    end)
    Menu.ColorPicker("Visuals", "Local ESP", "Chams Color", Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Transparency, function(Color, Transparency)
        Config.ESP.Chams.Local.Color = Color
        Config.ESP.Chams.Local.Transparency = Transparency
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.Slider("Visuals", "Local ESP", "Chams Reflectance", 0, 1, Config.ESP.Chams.Local.Reflectance, "", 2, function(Value)
        Config.ESP.Chams.Local.Reflectance = Value
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Value, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.ComboBox("Visuals", "Local ESP", "Chams Material", Config.ESP.Chams.Local.Material, {"ForceField", "Glass", "Plastic"}, function(String)
        Config.ESP.Chams.Local.Material = String
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, String, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.CheckBox("Visuals", "Local ESP", "Visualize Fake Lag", Config.FakeLag.Visualize, function(Bool)
        Config.FakeLag.Visualize = Bool
    end)
    Menu.ColorPicker("Visuals", "Local ESP", "Visualize Color", Config.FakeLag.Color, 1 - Config.FakeLag.Transparency, function(Color, Transparency)
        Config.FakeLag.Color = Color
        Config.FakeLag.Transparency = 1 - Transparency
    end)

    Menu.CheckBox("Visuals", "Item ESP", "Enabled", Config.ESP.Item.Enabled, function(Bool)
        Config.ESP.Item.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item ESP", "Name", Config.ESP.Item.Flags.Name.Enabled, function(Bool)
        Config.ESP.Item.Flags.Name.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item ESP", "Distance", Config.ESP.Item.Flags.Distance.Enabled, function(Bool)
        Config.ESP.Item.Flags.Distance.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item ESP", "Snapline", Config.ESP.Item.Snaplines.Enabled, function(Bool)
        Config.ESP.Item.Snaplines.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "Item ESP", "Snapline Color", Config.ESP.Item.Snaplines.Color, 1 - Config.ESP.Item.Snaplines.Transparency, function(Color, Transparency)
        Config.ESP.Item.Snaplines.Color = Color
        Config.ESP.Item.Snaplines.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "Item ESP", "Icons", Config.ESP.Item.Flags.Icon.Enabled, function(Bool)
        Config.ESP.Item.Flags.Icon.Enabled = Bool
    end)
    Menu.ComboBox("Visuals", "Item ESP", "Font", Config.ESP.Item.Font.Font, {"UI", "System", "Plex", "Monospace"}, function(String)
        Config.ESP.Item.Font.Font = String
    end)
    Menu.ColorPicker("Visuals", "Item ESP", "Font Color", Config.ESP.Item.Font.Color, 1 - Config.ESP.Item.Font.Transparency, function(Color, Transparency)
        Config.ESP.Item.Font.Color = Color
        Config.ESP.Item.Font.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "Item ESP", "Font Size", 10, 32, Config.ESP.Item.Font.Size, "px", 0, function(Value)
        Config.ESP.Item.Font.Size = Value
    end)

    Menu.CheckBox("Visuals", "Hit markers", "Hit markers", Config.HitMarkers.Enabled, function(Bool)
        Config.HitMarkers.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "Hit markers", "Hit markers color", Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency, function(Color, Transparency)
        Config.HitMarkers.Color = Color
        Config.HitMarkers.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "Hit markers", "Hit markers size", 5, 20, Config.HitMarkers.Size, nil, 0, function(Value)
        Config.HitMarkers.Size = Value
    end)
    Menu.ComboBox("Visuals", "Hit markers", "Hit markers type", Config.HitMarkers.Type, {"Crosshair", "Model", "Crosshair + Model"}, function(String)
        Config.HitMarkers.Type = String
    end)
    Menu.CheckBox("Visuals", "Hit markers", "Hit sound", Config.HitSound.Enabled, function(Bool)
        Config.HitSound.Enabled = Bool
    end)

    Menu.CheckBox("Visuals", "World", "Ambient Changer", Config.Enviorment.Ambient.Enabled, function(Bool)
        Config.Enviorment.Ambient.Enabled = Bool
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient[1].Color
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient[2].Color
        else
            Lighting.Ambient = Lighting:GetAttribute("DefaultAmbient")
            Lighting.OutdoorAmbient = Lighting:GetAttribute("DefaultOutdoorAmbient")
        end
    end)
    Menu.ColorPicker("Visuals", "World", "Ambient", Config.Enviorment.Ambient[1].Color, 0, function(Color)
        Config.Enviorment.Ambient[1].Color = Color
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient[1].Color
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient[2].Color
        end
    end)
    Menu.ColorPicker("Visuals", "World", "Outdoor Ambient", Config.Enviorment.Ambient[2].Color, 0, function(Color)
        Config.Enviorment.Ambient[2].Color = Color
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient[1].Color
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient[2].Color
        end
    end)
    Menu.CheckBox("Visuals", "World", "World Time Changer", Config.Enviorment.Time.Enabled, function(Bool)
        Config.Enviorment.Time.Enabled = Bool
    end)
    Menu.Slider("Visuals", "World", "World Time", 0, 24, Config.Enviorment.Time.Value, "h", 1, function(Value)
        Config.Enviorment.Time.Value = math.round(Value)
    end)
    Menu.CheckBox("Visuals", "World", "Saturation Changer", Config.Enviorment.Saturation.Enabled, function(Bool)
        Config.Enviorment.Saturation.Enabled = Bool
        Lighting.ColorCorrection.Saturation = Config.Enviorment.Saturation.Enabled and Config.Enviorment.Saturation.Value or 0
    end)
    Menu.Slider("Visuals", "World", "Saturation", -1, 0, Config.Enviorment.Saturation.Value, nil, 2, function(Value)
        Config.Enviorment.Saturation.Value = Value
        Lighting.ColorCorrection.Saturation = Config.Enviorment.Saturation.Enabled and Config.Enviorment.Saturation.Value or 0
    end)
    Menu.CheckBox("Visuals", "World", "Bullet impacts", Config.BulletImpact.Enabled, function(Bool)
        Config.BulletImpact.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "World", "Bullet impacts color", Config.BulletImpact.Color, Config.BulletImpact.Transparency, function(Color, Transparency)
        Config.BulletImpact.Color = Color
        Config.BulletImpact.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "World", "Bullet Tracers", Config.BulletTracers.Enabled, function(Bool)
        Config.BulletTracers.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "World", "Bullet Tracers Color", Config.BulletTracers.Color, 0, function(Color)
        Config.BulletTracers.Color = Color
    end)
    Menu.Slider("Visuals", "World", "Bullet Tracers Lifetime", 0, 6000, Config.BulletTracers.Lifetime, "ms", 1, function(Value)
        Config.BulletTracers.Lifetime = Value
    end)
    Menu.CheckBox("Visuals", "World", "Disable Bullet Trails", Config.BulletTracers.DisableTrails, function(Bool)
        Config.BulletTracers.DisableTrails = Bool
    end)
    Menu.ComboBox("Visuals", "World", "Skybox", Config.Enviorment.Skybox.Value, GetSkyboxes().Names, function(String)
        Config.Enviorment.Skybox.Value = String
        UpdateSkybox()
    end)

    Menu.CheckBox("Visuals", "Other", "Max Zoom Changer", Config.Zoom.Enabled, function(Bool)
        Config.Zoom.Enabled = Bool
        Player.CameraMaxZoomDistance = Config.Zoom.Enabled and Config.Zoom.Value or 20
    end)
    Menu.Slider("Visuals", "Other", "Max Zoom", 0, 1000, Config.Zoom.Value, nil, 1, function(Value)
        Config.Zoom.Value = Value
        Player.CameraMaxZoomDistance = Config.Zoom.Enabled and Config.Zoom.Value or 20
    end)
    Menu.CheckBox("Visuals", "Other", "Field Of View Changer", Config.FieldOfView.Enabled, function(Bool)
        Config.FieldOfView.Enabled = Bool
        Camera.FieldOfView = Config.FieldOfView.Enabled and Config.FieldOfView.Value or 70
    end)
    Menu.Slider("Visuals", "Other", "Field Of View", 0, 120, Config.FieldOfView.Value, "°", 1, function(Value)
        Config.FieldOfView.Value = Value
        Camera.FieldOfView = Config.FieldOfView.Enabled and Config.FieldOfView.Value or 70
    end)
    Menu.CheckBox("Visuals", "Other", "First Person", Config.FirstPerson.Enabled, function(Bool)
        Config.FirstPerson.Enabled = Bool
        if Bool then
            AddFirstPersonEventListeners()
        else
            for _, v in ipairs(Events.FirstPerson) do v:Disconnect() end
            table.clear(Events.FirstPerson)
        end
    end)

    Menu.CheckBox("Visuals", "Interface", "Aimbot Vector Indicator", Config.Aimbot.Visualize, function(Bool)
        Config.Aimbot.Visualize = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Field Of View Circle", Config.Interface.FieldOfViewCircle.Enabled, function(Bool)
        Config.Interface.FieldOfViewCircle.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Field Of View Circle Filled", Config.Interface.FieldOfViewCircle.Filled, function(Bool)
        Config.Interface.FieldOfViewCircle.Filled = Bool
    end)
    Menu.Slider("Visuals", "Interface", "Field Of View Circle Sides", 0, 16, Config.Interface.FieldOfViewCircle.NumSides, nil, 0, function(Value)
        Config.Interface.FieldOfViewCircle.NumSides = Value
    end)
    Menu.ColorPicker("Visuals", "Interface", "Field Of View Circle Color", Config.Interface.FieldOfViewCircle.Color, 1 - Config.Interface.FieldOfViewCircle.Transparency, function(Color, Transparency)
        Config.Interface.FieldOfViewCircle.Color = Color
        Config.Interface.FieldOfViewCircle.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "Interface", "Watermark", Config.Interface.Watermark.Enabled, function(Bool)
        Config.Interface.Watermark.Enabled = Bool
        Menu.Watermark:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Chat", Config.Interface.Chat.Enabled, function(Bool)
        Config.Interface.Chat.Enabled = Bool
        pcall(function()
            local ChatFrame = PlayerGui.Chat.Frame.ChatChannelParentFrame
            ChatFrame.Visible = Config.Interface.Chat.Enabled
        end)
    end)
    Menu.CheckBox("Visuals", "Interface", "Indicators", Config.Interface.Indicators.Enabled, function(Bool)
        Config.Interface.Indicators.Enabled = Bool
        Menu.Indicators:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Keybinds", Config.Interface.Keybinds.Enabled, function(Bool)
        Config.Interface.Keybinds.Enabled = Bool
        Menu.Keybinds:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Show Ammo", Config.Interface.ShowAmmo.Enabled, function(Bool)
        Config.Interface.ShowAmmo.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Remove UI Elements", Config.Interface.RemoveUIElements.Enabled, function(Bool)
        Config.Interface.RemoveUIElements.Enabled = Bool
        UpdateInterface()
    end)
    Menu.CheckBox("Visuals", "Interface", "Bar Fade", Config.Interface.BarFade.Enabled, function(Bool)
        Config.Interface.BarFade.Enabled = Bool
        UpdateInterface()
    end)

    Menu.CheckBox("Visuals", "Weapons", "Gun Chams", Config.GunChams.Enabled, function(Bool)
        Config.GunChams.Enabled = Bool
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.ColorPicker("Visuals", "Weapons", "Chams Color", Config.GunChams.Color, Config.GunChams.Transparency, function(Color, Transparency)
        Config.GunChams.Color = Color
        Config.GunChams.Transparency = Transparency
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.Slider("Visuals", "Weapons", "Chams Reflectance", 0, 1, Config.GunChams.Reflectance, nil, 1, function(Value)
        Config.GunChams.Reflectance = Value
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.ComboBox("Visuals", "Weapons", "Chams Material", Config.GunChams.Material, {"ForceField", "Glass", "Neon", "Plastic"}, function(Material)
        Config.GunChams.Material = Material
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)

    Menu.CheckBox("Visuals", "Hats", "Hat Color Changer", Config.HatChanger.Enabled, function(Bool)
        Config.HatChanger.Enabled = Original and Bool
        if Original and Bool then
            local Success, Result = coroutine.resume(Threads.HatChanger)
            if not Success then
                Console:Error("[HAT CHANGER] " .. Result)
            end
        end
        Menu:FindItem("Visuals", "Hats", "CheckBox", "Hat Color Sequence"):SetVisible(Original and Bool)
        Menu:FindItem("Visuals", "Hats", "Slider", "Hat Color Rate"):SetVisible(Original and Bool)
        Menu:FindItem("Visuals", "Hats", "ComboBox", "Hat"):SetVisible(Original and Bool)
        Menu:FindItem("Visuals", "Hats", "ColorPicker", "Hat Color"):SetVisible(Original and Bool)
    end)
    Menu.CheckBox("Visuals", "Hats", "Hat Color Sequence", Config.HatChanger.Sequence, function(Bool)
        Config.HatChanger.Sequence = Original and Bool
    end)
    Menu.Slider("Visuals", "Hats", "Hat Color Rate", 0, 5, Config.HatChanger.Speed, "s", 1, function(Value)
        Config.HatChanger.Speed = Value
    end)
    Menu.ComboBox("Visuals", "Hats", "Hat", "None", {"None", unpack(Humanoid:GetAccessories())}, function(Hat)
        SetHat(Hat)
    end)
    Menu.ColorPicker("Visuals", "Hats", "Hat Color", Config.HatChanger.Color, 0, function(Color)
        Config.HatChanger.Color = Color
    end)

    Menu.CheckBox("Misc", "Main", "Auto Cash", Config.AutoCash.Enabled, function(Bool)
        Config.AutoCash.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto Farm", Config.AutoFarm.Enabled, function(Bool)
        Config.AutoFarm.Enabled = Bool
        Menu:FindItem("Misc", "Main", "MultiSelect", "Auto Farm Table"):SetVisible(Bool)
    end)
    Menu.MultiSelect("Misc", "Main", "Auto Farm Table", Config.AutoFarm.Table, function(Items)
        Config.AutoFarm.Table = Items
    end)
    Menu.CheckBox("Misc", "Main", "Auto Play", Config.AutoPlay.Enabled, function(Bool)
        Config.AutoPlay.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto Reconnect", Config.AutoReconnect.Enabled, function(Bool)
        Config.AutoReconnect.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto Sort", Config.AutoSort.Enabled, function(Bool)
        Config.AutoSort.Enabled = Bool
        Menu:FindItem("Misc", "Main", "MultiSelect", "Auto Sort Order"):SetVisible(Bool)
    end)
    Menu.MultiSelect("Misc", "Main", "Auto Sort Order", Config.AutoSort.Order, function(Order)
        Config.AutoSort.Order = Order
    end)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Main", "Auto Heal", Config.AutoHeal.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.AutoHeal.Enabled = Bool
    end)):SetVisible(Original)
    Menu.CheckBox("Misc", "Main", "Click Open", Config.ClickOpen.Enabled, function(Bool)
        Config.ClickOpen.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Chat Spam", Spamming, function(Bool)
        Spamming = Bool
        if Bool then coroutine.resume(Threads.ChatSpam) end
        if not isfile("Identification/Games/The Streets/Spam.dat") then
            writefile("Identification/Games/The Streets/Spam.dat", "")
        end
    end)
    Menu.CheckBox("Misc", "Main", "Event Logs", Config.EventLogs.Enabled, function(Bool)
        Config.EventLogs.Enabled = Bool
        Menu:FindItem("Misc", "Main", "MultiSelect", "Event Log Flags"):SetVisible(Bool)
    end)
    Menu.MultiSelect("Misc", "Main", "Event Log Flags", Config.EventLogs.Flags, function(Flags)
        Config.EventLogs.Flags = Flags
    end)
    Menu.CheckBox("Misc", "Main", "Hide Sprays", Config.HideSprays.Enabled, function(Bool)
        Config.HideSprays.Enabled = Bool
        for _, Object in ipairs(workspace:GetChildren()) do
            if Object:IsA("Part") then
                local ObjectName = tostring(Object)
                if string.find(ObjectName, "Spray") and not string.find(ObjectName, "$20") then
                    local Decal = Object:WaitForChild("Decal")
                    local Transparency = Config.HideSprays.Enabled and 1 or 0
                    Decal.Transparency = Transparency

                    spawn(function()
                        local Event
                        Event = Decal:GetPropertyChangedSignal("Transparency"):Connect(function()
                            if not Config.HideSprays.Enabled then
                                return Event:Disconnect()
                            end
                            Decal.Transparency = Transparency
                        end)
                        delay(2.5, Event.Disconnect, Event)
                    end)
                end
            end
        end
    end)
    Menu.CheckBox("Misc", "Main", "Close Doors", Config.CloseDoors.Enabled, function(Bool)
        Config.CloseDoors.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Open Doors", Config.OpenDoors.Enabled, function(Bool)
        Config.OpenDoors.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Knock Doors", Config.KnockDoors.Enabled, function(Bool)
        Config.KnockDoors.Enabled = Bool
        if Bool then coroutine.resume(Threads.KnockDoors) end
    end)
    Menu.CheckBox("Misc", "Main", "No Doors", Config.NoDoors.Enabled, function(Bool)
        Config.NoDoors.Enabled = Bool
        for _, Door in ipairs(Doors) do
            for _, Object in ipairs(Door:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if Config.NoDoors.Enabled then
                        Object.Transparency = 1
                        Object.CanCollide = false
                    else
                        if not Object:GetAttribute("Ignore") then
                            Object.Transparency = 0
                        end
                        Object.CanCollide = true
                    end
                end
            end
        end
        for _, Window in ipairs(Windows) do
            for _, Object in ipairs(Window:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if Config.NoDoors.Enabled then
                        Object.Transparency = 1
                        Object.CanCollide = false
                    else
                        if not Object:GetAttribute("Ignore") then
                            Object.Transparency = 0
                        end
                        Object.CanCollide = true
                    end
                end
            end
        end
    end)
    Menu.CheckBox("Misc", "Main", "No Seats", Config.NoSeats.Enabled, function(Bool)
        Config.NoSeats.Enabled = Bool
        for _, Seat in pairs(Seats) do
            if Config.NoSeats.Enabled then
                Seat.Parent = nil
            else
                Seat.Parent = workspace
            end
        end
    end)
    Menu.CheckBox("Misc", "Main", "Door Aura", Config.DoorAura.Enabled, function(Bool)
        Config.DoorAura.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Door Menu", Config.DoorMenu.Enabled, function(Bool)
        Config.DoorMenu.Enabled = Bool
    end)

    Menu.CheckBox("Misc", "Animations", "Run", Config.Animations.Run.Enabled, function(Bool)
        Config.Animations.Run.Enabled = Bool
        Menu:FindItem("Misc", "Animations", "ComboBox", "Run Animation"):SetVisible(Bool)
    end)
    Menu.ComboBox("Misc", "Animations", "Run Animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Run.Style = String
        Animations.Run.self:Stop()
        Animations.Run2.self:Stop()
        Animations.Run3.self:Stop()
    end)
    Menu.CheckBox("Misc", "Animations", "Glock", Config.Animations.Glock.Enabled, function(Bool)
        Config.Animations.Glock.Enabled = Bool
        Menu:FindItem("Misc", "Animations", "ComboBox", "Glock Animation"):SetVisible(Bool)
    end)
    Menu.ComboBox("Misc", "Animations", "Glock Animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Glock.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Uzi", Config.Animations.Uzi.Enabled, function(Bool)
        Config.Animations.Uzi.Enabled = Bool
        Menu:FindItem("Misc", "Animations", "ComboBox", "Uzi Animation"):SetVisible(Bool)
    end)
    Menu.ComboBox("Misc", "Animations", "Uzi Animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Uzi.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Shotty", Config.Animations.Shotty.Enabled, function(Bool)
        Config.Animations.Shotty.Enabled = Bool
        Menu:FindItem("Misc", "Animations", "ComboBox", "Shotty Animation"):SetVisible(Bool)
    end)
    Menu.ComboBox("Misc", "Animations", "Shotty Animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Shotty.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Sawed Off", Config.Animations["Sawed Off"].Enabled, function(Bool)
        Config.Animations["Sawed Off"].Enabled = Bool
        Menu:FindItem("Misc", "Animations", "ComboBox", "Sawed Off Animation"):SetVisible(Bool)
    end)
    Menu.ComboBox("Misc", "Animations", "Sawed Off Animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations["Sawed Off"].Style = String
    end)

    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "Infinite Stamina", Config.InfiniteStamina.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.InfiniteStamina.Enabled = Bool
        EnableInfiniteStamina()
    end)):SetVisible(not Original)
    Menu.CheckBox("Misc", "Exploits", "Infinite Force-Field", Config.InfiniteForceField.Enabled, function(Bool)
        Config.InfiniteForceField.Enabled = Bool
        if Bool then coroutine.resume(Threads.InfiniteForceField) end
    end)
    Menu.CheckBox("Misc", "Exploits", "Teleport Bypass", Config.TeleportBypass.Enabled, function(Bool)
        Config.TeleportBypass.Enabled = Bool
        TeleportBypass()
    end)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "God", Config.God.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.God.Enabled = Bool
    end)):SetVisible(not Original)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "Click Spam", Config.ClickSpam.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.ClickSpam.Enabled = not Original and Bool
        if Bool then coroutine.resume(Threads.ClickSpam) end
    end)):SetVisible(not Original)
    Menu.CheckBox("Misc", "Exploits", "Lag On Dragged", Config.LagOnDragged.Enabled, function(Bool)
        Config.LagOnDragged.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Exploits", "Fake Lag", Config.FakeLag.Enabled, function(Bool)
        Config.FakeLag.Enabled = Bool
        if Bool then
            local Success, Result = coroutine.resume(Threads.FakeLag)
            if not Success then
                Console:Error("[FAKE LAG] " .. Result)
            end
        end
    end)
    Menu.Slider("Misc", "Exploits", "Fake Lag Limit", 3, 15, Config.FakeLag.Limit, "", 1, function(Value)
        Config.FakeLag.Limit = Value / 10
    end)
    Menu.Button("Misc", "Exploits", "Crash Server", function()
        local Success, Result = coroutine.resume(Threads.CrashServer)
        if not Success then
            Console:Error("[CRASH SERVER] " .. Result)
        end
    end)
    Menu.ListBox("Misc", "Players", "Target", false, Players:GetPlayers(), function(Player_Name)
        local Player = GetPlayer(Player_Name)[1]
        if not Player then return end
        SelectedTarget = tostring(Player)

        local Whitelist = table.find(UserTable.Whitelisted, tostring(Player.UserId)) and true or false
        local Owner = table.find(UserTable.Owners, tostring(Player.UserId)) and true or false
        Menu:FindItem("Misc", "Players", "CheckBox", "Whitelisted"):SetValue(Whitelist)
        Menu:FindItem("Misc", "Players", "CheckBox", "Owner"):SetValue(Owner)
    end)

    Menu.CheckBox("Misc", "Players", "Target Lock", TargetLock, function(Bool) TargetLock = Bool end)
    Menu.Button("Misc", "Players", "Copy Target User-Id", function()
        local Target = GetPlayer(SelectedTarget)[1]
        if Target then
            setclipboard(tostring(Target.UserId))
        end
    end)
    Menu.Slider("Misc", "Players", "Priority", 0, 3, 1, "", 0, function(Value)
        -- 0 don't attack target; > 0 attack target higher priority target
    end)
    Menu.CheckBox("Misc", "Players", "Attach", Config.Attach.Enabled, function(Bool)
        Config.Attach.Enabled = Bool
        if Bool then 
            local Success, Result = coroutine.resume(Threads.Attach)
            if not Success then
                Console:Error("[ATTACH] " .. Result)
            end
        else
            for _, Tool in ipairs(GetTools()) do
                local ToolInfo = GetToolInfo(tostring(Tool))
                if ToolInfo then
                    Tool.Grip = ToolInfo.Grip
                end
            end
        end
    end)
    Menu.Slider("Misc", "Players", "Attach Rate", 0, 3000, Config.Attach.RefreshRate, "ms", 1, function(Value)
        Config.Attach.RefreshRate = Value
    end)
    Menu.CheckBox("Misc", "Players", "View", Config.View.Enabled, function(Bool)
        Config.View.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Players", "Follow", Config.Follow.Enabled, function(Bool)
        Config.Follow.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Players", "Whitelisted", false, function(Bool)
        local UserId = GetSelectedTarget().UserId
        local Index = table.find(UserTable.Whitelisted, tostring(UserId))
        if Index then
            table.remove(UserTable.Whitelisted, Index)
        else
            table.insert(UserTable.Whitelisted, UserId)
        end
        writefile("Identification/Games/The Streets/Whitelist.dat", table.concat(UserTable.Whitelisted, "\n"))
    end)
    Menu.CheckBox("Misc", "Players", "Owner", false, function(Bool)
        local UserId = GetSelectedTarget().UserId
        local Index = table.find(UserTable.Owners, tostring(UserId))
        if Index then
            table.remove(UserTable.Owners, Index)
        else
            table.insert(UserTable.Owners, UserId)
        end
        writefile("Identification/Games/The Streets/Owners.dat", table.concat(UserTable.Owners, "\n"))
    end)
    do
        local Player_Info_Items = {}
        Player_Info_Items["Display name"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Display name: ?"))
        Player_Info_Items["Age"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Age: 0"))
        Player_Info_Items["Vest"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Vest: false"))
        Player_Info_Items["Origin"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Origin: (0; 0; 0)"))
        Player_Info_Items["Health"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Health: 0"))
        Player_Info_Items["Stamina"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Stamina: 0"))
        Player_Info_Items["Knocked out"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Knocked out: 0"))

        local function UpdateItemValue(Index, Value)
            Player_Info_Items[Index]:SetLabel(Value)
        end

        function UpdatePlayerListInfo(Player)
            if typeof(Player) == "Instance" and Player:IsA("Player") then
                UpdateItemValue("Display name", "Display name: " .. Player.DisplayName)
                UpdateItemValue("Age", "Age: " .. Player.AccountAge)
                do
                    local Vest = Player:GetAttribute("Vest")
                    UpdateItemValue("Vest", "Vest: " .. tostring(Vest))
                end
                do
                    local Position = Player:GetAttribute("Position")
                    if typeof(Position) == "Vector3" then
                        local Origin = tostring(math_round(Position.X, 2) .. "; " .. math_round(Position.Y, 2) .. "; " .. math_round(Position.Z, 2))
                        UpdateItemValue("Origin", "Origin: " .. Origin)
                    end
                end

                local Health = Player:GetAttribute("Health") or 0
                local Stamina = Player:GetAttribute("Stamina") or 0
                local KnockOut = math_round(Player:GetAttribute("KnockOut") or 0, 2)

                UpdateItemValue("Health", "Health: " .. tostring(Health))
                UpdateItemValue("Stamina", "Stamina: " .. tostring(Stamina))
                UpdateItemValue("Knocked out", "Knocked out: " .. tostring(KnockOut))
            end
        end
    end

    Menu.CheckBox("Misc", "Clan Tag", "Enabled", Config.ClanTag.Enabled, function(Bool)
        Config.ClanTag.Enabled = Bool
        if Bool then
            local Success, Result = coroutine.resume(Threads.ClanTagChanger)
            if not Success then
                Console:Error("[CLAN TAG] " .. Result)
            end
        end
        Menu:FindItem("Misc", "Clan Tag", "CheckBox", "Visualize"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "TextBox", "Tag"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "TextBox", "Prefix"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "TextBox", "Suffix"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "Slider", "Tag Speed"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "ComboBox", "Tag Type"):SetVisible(Bool)
        Menu:FindItem("Misc", "Clan Tag", "TextBox", "Spotify Token"):SetVisible(Bool)
    end)
    Menu.CheckBox("Misc", "Clan Tag", "Visualize", Config.ClanTag.Visualize, function(Bool)
        Config.ClanTag.Visualize = Bool
    end)
    Menu.TextBox("Misc", "Clan Tag", "Tag", Config.ClanTag.Tag, function(Tag)
        Config.ClanTag.Tag = Tag
    end)
    Menu.TextBox("Misc", "Clan Tag", "Prefix", Config.ClanTag.Prefix, function(Prefix)
        Config.ClanTag.Prefix = Prefix
    end)
    Menu.TextBox("Misc", "Clan Tag", "Suffix", Config.ClanTag.Suffix, function(Suffix)
        Config.ClanTag.Suffix = Suffix
    end)
    Menu.Slider("Misc", "Clan Tag", "Tag Speed", 0, 5, Config.ClanTag.Speed, "s", 2, function(Speed)
        Config.ClanTag.Speed = Speed
    end)
    Menu.ComboBox("Misc", "Clan Tag", "Tag Type", Config.ClanTag.Type, {"Static", "Blink", "Normal", "Forward", "Reverse", "Cheat", "Custom", "Info", "Boombox", "Spotify"}, function(Type)
        Config.ClanTag.Type = Type
        if Type == "Spotify" then
            Menu:FindItem("Misc", "Clan Tag", "TextBox", "Spotify Token"):SetVisible(true)
        else
            Menu:FindItem("Misc", "Clan Tag", "TextBox", "Spotify Token"):SetVisible(false)
        end
    end)
    Menu.TextBox("Misc", "Clan Tag", "Spotify Token", Config.ClanTag.SpotifyToken, function(Token)
        Config.ClanTag.SpotifyToken = Token
    end)

    do
        local DemoPlayer
        local Recording = false
        local RecordingName = ""

        local StatusLabel = Menu.GetItem(Menu, Menu.Label("Settings", "Demo Recorder", "Status: Not recording"))
        Menu.TextBox("Settings", "Demo Recorder", "Demo Name", "", function(String)
            RecordingName = String
        end)
        Menu.Button("Settings", "Demo Recorder", "Toggle Recording", function()
            Recording = not Recording
            if Recording then
                DemoPlayer:start()
            else
                DemoPlayer:stop()
                DemoPlayer:create()
            end
            local Status = Recording and "Recording..." or "Not recording"
            StatusLabel:SetLabel("Status: " .. Status)
        end)
        Menu.Button("Settings", "Demo Recorder", "Copy Replay Place", function()
            setclipboard("https://www.roblox.com/games/8869691226/Replay-House")
        end)
    end
    
    Menu.Button("Settings", "Settings", "Refresh", function()
        Menu:FindItem("Visuals", "World", "ComboBox", "Skybox"):SetValue(Config.Enviorment.Skybox.Value, GetSkyboxes().Names)
        HitSound = get_custom_asset("Identification/Games/The Streets/bin/sounds/hitsound.mp3") -- huh seems to automatically when file changes?
        Crosshair = get_custom_asset("Identification/Games/The Streets/bin/crosshairs/crosshair.png")
        Mouse.Icon = Crosshair
    end)

    Menu.Hotkey("Settings", "Menu", "Menu Key", Config.Menu.Key, function(KeyCode)
        Config.Menu.Key = KeyCode
        ContextAction:BindAction("menuToggle", MenuToggle, false, KeyCode)
    end)
    Menu.Hotkey("Settings", "Menu", "Prefix", Config.Prefix, function(KeyCode)
        Config.Prefix = KeyCode
        ContextAction:BindAction("commandBarToggle", CommandBarToggle, false, KeyCode)
    end)
    Menu.ColorPicker("Settings", "Menu", "Menu Accent", Config.Menu.Accent, 0, function(Color)
        Menu.Accent = Color
        Config.Menu.Accent = Color
        Menu:SetTitle(string.format("Identification.%scc%s", "<font color = '#" .. Color:ToHex() .. "'>", "</font>"))
    end)
    Menu.ComboBox("Settings", "Menu", "Console Font Color", Config.Console.Accent, {"Cyan"}, function(String)
        Config.Console.Accent = String
    end)

    Menu.TextBox("Settings", "Configs", "Config Name", "")
    Menu.ListBox("Settings", "Configs", "Configs", false, GetFiles("Identification/Games/The Streets/Configs/").Names, function(cfg_name)
        Menu:FindItem("Settings", "Configs", "TextBox", "Config Name"):SetValue(cfg_name)
    end)
    Menu.Button("Settings", "Configs", "Create", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "TextBox", "Config Name"):GetValue()
        -- file already exists?
        SaveConfig(cfg_name)
    end)
    Menu.Button("Settings", "Configs", "Save", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        Menu.Prompt("Are you sure you want to overwrite save  of'" .. cfg_name .. "' ?", function()
            SaveConfig(string.gsub(cfg_name, ".cfg", ""))
        end)
    end)
    Menu.Button("Settings", "Configs", "Load", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        LoadConfig(string.gsub(cfg_name, ".cfg", ""))
    end)
    Menu.Button("Settings", "Configs", "Delete", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        Menu.Prompt("Are you sure you want to delete '" .. cfg_name .. "' ?", function()
            delfile("Identification/Games/The Streets/Configs/" .. cfg_name)
            Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):SetValue("", GetFiles("Identification/Games/The Streets/Configs").Names)
        end)
    end)

    do
        local BoomboxText = Instance.new("TextLabel")
        local BoomboxList = Instance.new("ScrollingFrame")
        local BoomboxLayout = Instance.new("UIListLayout")

        Menu.BoomboxFrame.ClipsDescendants = true
        Menu.BoomboxFrame.Visible = false
        Menu.BoomboxFrame.Position = UDim2.new(0.375, 0, 0.65, 0)
        Menu.BoomboxFrame.Size = UDim2.new(0.25, 0, 0.25, 0)
        Menu.BoomboxFrame.Style = Enum.FrameStyle.RobloxRound
        Menu.BoomboxFrame.Parent = Menu.Screen

        BoomboxText.Name = "Text"
        BoomboxText.BackgroundTransparency = 1
        BoomboxText.Position = UDim2.new(0, 0, 0, -8)
        BoomboxText.Size = UDim2.new(1, 0, 0, 20)
        BoomboxText.Text = "Recently Played"
        BoomboxText.TextColor3 = Color3.new(1, 1, 1)
        BoomboxText.TextStrokeTransparency = 0
        BoomboxText.Font = Enum.Font.SourceSans
        BoomboxText.TextSize = 24
        BoomboxText.Parent = Menu.BoomboxFrame

        BoomboxList.Name = "List"
        BoomboxList.Active = true
        BoomboxList.BackgroundTransparency = 1
        BoomboxList.BorderSizePixel = 0
        BoomboxList.Position = UDim2.new(0, 0, 0, 20)
        BoomboxList.Size = UDim2.new(1, 0, 0, 150)
        BoomboxList.CanvasSize = UDim2.new()
        BoomboxList.ScrollBarThickness = 0
        BoomboxList.Parent = Menu.BoomboxFrame

        BoomboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
        BoomboxLayout.Padding = UDim.new(0, 5)
        BoomboxLayout.Parent = BoomboxList
    end

    Menu.CommandBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Menu.CommandBar.BackgroundTransparency = 0.2
    Menu.CommandBar.BorderSizePixel = 0
    Menu.CommandBar.Position = UDim2.new(0.5, -100, 1, 0)
    Menu.CommandBar.Size = UDim2.new(0, 200, 0, 20)
    Menu.CommandBar.Font = Enum.Font.Code
    Menu.CommandBar.PlaceholderColor3 = Color3.new(1, 1, 1)
    Menu.CommandBar.PlaceholderText = "Command bar [" .. string.char(Config.Prefix.Value) .. "]"
    Menu.CommandBar.Text = ""
    Menu.CommandBar.TextColor3 = Color3.new(1, 1, 1)
    Menu.CommandBar.TextSize = 14
    Menu.CommandBar.TextStrokeTransparency = 0.5
    Menu.CommandBar.Parent = Menu.Screen
    Menu.Line(Menu.CommandBar)

    Menu.Indicators.Add("Target", "Text", "nil")
    Menu.Indicators.Add("Knocked Out", "Bar", 0, 0, 15)
    Menu.Indicators.Add("Bullet Tick", "Text", 0)
    Menu.Indicators.Add("Stomp Target", "Text", 0)
    Menu.Indicators.Add("Fake Lag", "Bar", 0, 0, 15) -- 15 is 1.5 seconds
    Menu.Indicators.Add("Fake Velocity", "Text", "on")
    --Health = false,
    --Stamina = false,
    --GunCooldown = false, --(Tool.Info.Cooldown) Lol
    --FakeLag = false,
    --AntiGroudHit = false,

    Menu.Keybinds.Add("Aimbot", Config.Aimbot.Enabled and "on" or "off")
    Menu.Keybinds.Add("Camera Lock", Config.CameraLock.Enabled and "on" or "off")
    Menu.Keybinds.Add("Flight", Config.Flight.Enabled and "on" or "off")
    Menu.Keybinds.Add("Blink", Config.Blink.Enabled and "on" or "off")
    Menu.Keybinds.Add("Float", Config.Float.Enabled and "on" or "off")
    Menu.Keybinds.Add("Noclip", Config.Noclip.Enabled and "on" or "off")
    Menu.Keybinds.Add("Anti Aim", Config.AntiAim.Enabled and "on" or "off")

    Menu.Keybinds.List.Aimbot:SetVisible(Config.Aimbot.Enabled)
    Menu.Keybinds.List["Camera Lock"]:SetVisible(Config.CameraLock.Enabled)
    Menu.Keybinds.List.Flight:SetVisible(Config.Flight.Enabled)
    Menu.Keybinds.List.Blink:SetVisible(Config.Blink.Enabled)
    Menu.Keybinds.List.Float:SetVisible(Config.Float.Enabled)
    Menu.Keybinds.List.Noclip:SetVisible(Config.Noclip.Enabled)
    Menu.Keybinds.List["Anti Aim"]:SetVisible(Config.AntiAim.Enabled)
    Menu.Watermark:SetVisible(Config.Interface.Watermark.Enabled)
    Menu.Indicators:SetVisible(Config.Interface.Indicators.Enabled)
    Menu.Keybinds:SetVisible(Config.Interface.Keybinds.Enabled)
    Menu:SetTab("Combat")
end


function Initialize()
    pcall(function()
        local ChatFrame = PlayerGui.Chat.Frame.ChatChannelParentFrame
        ChatFrame.Position += UDim2.new(0, 0, 0, 420)
        if Config.Interface.Chat.Enabled then
            ChatFrame.Visible = true
        end
    end)

    --[[
        427729412, -- JUMP
        376654657, -- DIVE
        429404922, -- SIT
        413255557, -- ARM HOLD
        413612350, -- 2 ARM HOLD
        401045066, -- DRINK
        400468322, -- ANTI HEAD HIT
        433903719 -- Levitate Lol || Ghost
        8587081257; 376653421; 1357408709 -- default run
    ]]

    local AnimationIds = {
        BackFlip = 363364837, Chill = 526821274, Dab = 526812070, Kick = 376851671, Lay = 526815097, Pushups = 526813828, Sit = 178130996, Sit2 = 0, Situps = 526814775, Slide = 1461265895, Roll = 376654657,
        Gun = 889968874, Gun2 = 229339207, Gun3 = 889390949, Run = 8587081257, Run2 = 458506542, Run3 = 1484589375, Crouch = 8533780211, AntiAim = 215384594, AntiAim2 = 242203091,
        GlockIdle = 503285264, GlockFire = 503287783, GlockReload = 8533765435, ShottyIdle = 889390949, ShottyFire = 889391270, ShottyReload = 8533763280
    }
    for Name, Id in pairs(AnimationIds) do
        SetAnimation(Name, Id)
    end

    do
        local Sky = Lighting:FindFirstChildOfClass("Sky")
        local Blur = Instance.new("BlurEffect")
        local Bloom = Instance.new("BloomEffect")
        local SunRays = Original and Lighting:WaitForChild("SunRays") or Instance.new("SunRaysEffect")
        local Atmosphere = Instance.new("Atmosphere")
        local DepthOfField = Instance.new("DepthOfFieldEffect")

        Blur.Enabled = false
        Blur.Size = 0
        Blur.Parent = Lighting

        Bloom.Enabled = false
        Bloom.Size = 0
        Bloom.Intensity = 0
        Bloom.Threshold = 0
        Bloom.Parent = Lighting

        SunRays.Enabled = Original
        SunRays.Spread = 0
        SunRays.Intensity = 0
        SunRays.Parent = Lighting

        Atmosphere.Color = Color3.new(1, 1, 1)
        Atmosphere.Decay = Color3.new(1, 1, 1)
        Atmosphere.Glare = 0
        Atmosphere.Haze = 0
        Atmosphere.Offset = 0
        Atmosphere.Density = 0
        Atmosphere.Parent = Lighting

        DepthOfField.Enabled = false
        DepthOfField.FarIntensity = 0
        DepthOfField.NearIntensity = 0
        DepthOfField.FocusDistance = 0
        DepthOfField.InFocusRadius = 0
        DepthOfField.Parent = Lighting

        Lighting:SetAttribute("DefaultAmbient", Lighting.Ambient)
        Lighting:SetAttribute("DefaultOutdoorAmbient", Lighting.OutdoorAmbient)

        SunRays:SetAttribute("DefaultSpread", SunRays.Spread)
        SunRays:SetAttribute("DefaultIntensity", SunRays.Intensity)
    end

    AimbotIndicator = DrawCross(20, 4)
    AimbotIndicator:Rotate(90)

    CustomCharacter.Name = "CustomCharacter"

    FlyVelocity.Velocity = Vector3.new()
    FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    FlyAngularVelocity.AngularVelocity = Vector3.new() 
    FlyAngularVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

    FloatPart.Name = "Identification.Float"
    FloatPart.Transparency = 1
    FloatPart.Anchored = true
    FloatPart.CanCollide = Float
    FloatPart.Size = Vector3.new(100, 1, 100)
    FloatPart.Parent = workspace

    Events.Reset.Event:Connect(ResetCharacter)

    UpdateSkybox()
    OnCharacterAdded(Character) -- needs to yield

    for _, Player in ipairs(Players:GetPlayers()) do OnPlayerAdded(Player) end

    for _, Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
        local AnimationId = string.gsub(Track.Animation.AnimationId, "%D", "")
        if AnimationId == "8587081257" or AnimationId == "376653421" or AnimationId == "458506542" then Track:Stop() end -- Stopping the run animations
    end

    for Name, Pad in pairs(GetBuyPads()) do
        local Part = Pad.Part
        local Price = Pad.Price
        
        local Player
        local Debounce
        Part:GetPropertyChangedSignal("BrickColor"):Connect(function()
            if tostring(Part.BrickColor) ~= "Bright red" then
                Debounce = false
                Player = nil
                return
            end
            if Debounce or not Player then return end
            Debounce = true

            local Color = string.format("<font color = '#%s'>", Config.EventLogs.Colors.Buy:ToHex())
            local Message = string.format("%s bought a %s for %s", Color .. tostring(Player) .. " </font>", Color .. Name .. "</font>", Color .. "$" .. Price .. "</font>")
            Client.OnEvent({
                GetName = function() return "item_buy" end,
                GetPlayer = function() return Player end,
                GetPad = function() return Pad end
            })
            LogEvent("Buy", Message, tick())
            --delay(0.2, function() Debounce = false Player = nil end)
        end)
        Part.Touched:Connect(function(Part)
            if tostring(Part.BrickColor) == "Bright red" then return end
            Player = Players:GetPlayerFromCharacter(Part.Parent)
            Debounce = false
        end)
    end

    for _, v in ipairs(workspace:GetChildren()) do OnWorkspaceChildAdded(v) end

    for _, self in ipairs(workspace:GetDescendants()) do
        local Name = tostring(self)
        local ClassName = self.ClassName

        if (Name == "Door" or Name == "Window") and self:FindFirstChild("RemoteEvent", true) then
            if self:FindFirstChild("WoodPart") then
                table.insert(Doors, self)
            elseif self:FindFirstChild("Move") then
                table.insert(Windows, self)
            end
            for _, Object in ipairs(self:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if Object.Transparency == 1 then Object:SetAttribute("Ignore", true) end
                end
            end
        end

        if ClassName == "Seat" then -- Don't care about saving car seats, they don't matter;
            Seats[self] = self
            if Config.NoSeats.Enabled then self.Parent = nil end -- There are only 2 cars; I doubt u care about accidentally sitting on one
        end
    end

    spawn(function()
        pcall(function()
            Console:Init()
            Console.ForegroundColor = Config.Console.Accent
            Console:Clear()
            Console:Write([[
$$$$$$\      $$\                      $$\     $$\  $$$$$$\  $$\                     $$\     $$\                     
\_$$  _|     $$ |                     $$ |    \__|$$  __$$\ \__|                    $$ |    \__|                    
  $$ |  $$$$$$$ | $$$$$$\  $$$$$$$\ $$$$$$\   $$\ $$ /  \__|$$\  $$$$$$$\ $$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\  
  $$ | $$  __$$ |$$  __$$\ $$  __$$\\_$$  _|  $$ |$$$$\     $$ |$$  _____|\____$$\\_$$  _|  $$ |$$  __$$\ $$  __$$\ 
  $$ | $$ /  $$ |$$$$$$$$ |$$ |  $$ | $$ |    $$ |$$  _|    $$ |$$ /      $$$$$$$ | $$ |    $$ |$$ /  $$ |$$ |  $$ |
  $$ | $$ |  $$ |$$   ____|$$ |  $$ | $$ |$$\ $$ |$$ |      $$ |$$ |     $$  __$$ | $$ |$$\ $$ |$$ |  $$ |$$ |  $$ |
$$$$$$\\$$$$$$$ |\$$$$$$$\ $$ |  $$ | \$$$$  |$$ |$$ |      $$ |\$$$$$$$\\$$$$$$$ | \$$$$  |$$ |\$$$$$$  |$$ |  $$ |
\______|\_______| \_______|\__|  \__|  \____/ \__|\__|      \__| \_______|\_______|  \____/ \__| \______/ \__|  \__|                                                                                                                                                                                                                                                                                                   
]])
            Console:Write("\nType 'cmds' to see the commands!")

            function GetInput()
                local Message = string.lower(Console:Read(">"))
                local Output = Commands.Check(Message)
                if not Output then
                    Console:Warn("Warning: Command does not exist!")
                end

                GetInput()
            end

            GetInput()
        end)
    end)

    workspace.FallenPartsDestroyHeight = 0/0
    Mouse.Icon = Crosshair

    -- Initialize Binds || I don't particularly like camel case but Roblox uses it so...
    ContextAction:BindAction("aimbotToggle", AimbotToggle, false, Config.Aimbot.Key)
    ContextAction:BindAction("AutoFireToggle", AutoFireToggle, false, Config.AutoFire.Key)
    ContextAction:BindAction("cameraLockToggle", CameraLockToggle, false, Config.CameraLock.Key)
    ContextAction:BindAction("flyToggle", FlyToggle, false, Config.Flight.Key)
    ContextAction:BindAction("blinkToggle", BlinkToggle, false, Config.Blink.Key)
    ContextAction:BindAction("floatToggle", FloatToggle, false, Config.Float.Key)
    ContextAction:BindAction("noclipToggle", NoclipToggle, false, Config.Noclip.Key)
    ContextAction:BindAction("antiAimToggle", AntiAimToggle, false, Config.AntiAim.Key)
    ContextAction:BindAction("commandBarToggle", CommandBarToggle, false, Config.Prefix)
    ContextAction:BindAction("menuToggle", MenuToggle, false, Config.Menu.Key)

    RunService:BindToRenderStep("cameraLock", Enum.RenderPriority.Camera.Value - 1, function()
        if TargetLock and Config.CameraLock.Enabled then
            if Root and Humanoid and Player:GetAttribute("IsAlive") then
                local _Root = GetRoot(Target)
                if _Root then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, _Root.CFrame.Position)
                end
            end
        end
    end)

    -- Initialize Threads
    if Original then
        Threads.HatChanger = coroutine.create(function()
            local Sequence = {{delay = 0.2, color = "#413478"}, {delay = 0.2, color = "#483595"}, {delay = 0.2, color = "#634EB9"}, {delay = 0.2, color = "#9786DE"}, {delay = 0.2, color = "#FFB2B2"}, {delay = 0.2, color = "#F47D7D"}, {delay = 0.2, color = "#FF5555"}, {delay = 0.2, color = "#FF3232"}, {delay = 0.2, color = "#FF0000"}, {delay = 0.2, color = "#000000"}, {delay = 0.2, color = "#512626"}, {delay = 0.2, color = "#FFFFFF"}}
            local CurrentStep = 1

            while true do
                wait()
                if not Config.HatChanger.Enabled then coroutine.yield() end
                --BrickColor.random().Color

                if Config.HatChanger.Sequence then
                    if CurrentStep >= #Sequence then CurrentStep = 1 end
                    SetHatColor(Color3.fromHex(Sequence[CurrentStep].color))
                    wait(Sequence[CurrentStep].delay)
                    CurrentStep += 1
                else
                    SetHatColor(Config.HatChanger.Color)
                    wait(Config.HatChanger.Speed)
                end
            end
        end)


        -- pasted function don't know from who
        local function HMS(Seconds)
            local Minutes = (Seconds - Seconds % 60) / 60
            Seconds = Seconds - Minutes * 60
            local Hours = (Minutes - Minutes % 60) / 60
            Minutes = Minutes - Hours * 60
            return string.format("%02i", Minutes).. ":" ..string.format("%02i", Seconds)
        end

        
        local LastId = 0
        local LastName
        -- WTF IS THIS SHIT IM GONNA PUKE
        local function GetAudioName(Id)
            if LastId == Id then return LastName end
            LastId = Id

            local Asset = GetAssetInfo(Id)
            if Asset then
                Name = Asset.Name
                LastName = Name
                return Name
            end
        end


        --https://developer.spotify.com/console/get-users-currently-playing-track
        local function GetPlayingSpotifySong()
            local Url = "https://api.spotify.com/v1/me/player/currently-playing"
            local Response = request({
                Url = Url,
                Headers = {Authorization = "Bearer " .. Config.ClanTag.SpotifyToken}
            })
        
            if Response.StatusCode == 200 then
                return HttpService:JSONDecode(Response.Body)
            end
        end


        local CurrentClanTag = ""
        local ClanTagForward = false
        local ClanTagBlinking = false
        local ClanTagIteration = 0

        Threads.ClanTagChanger = coroutine.create(function()
            while true do
                wait()
                if not Config.ClanTag.Enabled then
                    coroutine.yield()
                end

                local Tag = Config.ClanTag.Tag
                local Type = Config.ClanTag.Type

                if Type == "Custom" then continue end -- Client.SetClanTag("")
                if Type == "Static" then
                    CurrentClanTag = Tag
                elseif Type == "Cheat" then
                    local TagSequences = {
                        "_________________", "I________________", "Id_______________", "Ide______________", "Iden_____________", "Ident____________", 
                        "Identi___________", "Identif__________", "Identifi_________", "Identific________", "Identifica_______", "Identificat______", 
                        "Identificati_____", "Identificatio____", "Identification___", "Identification.__", "Identification.c_", "Identification.cc"
                    }
                    ClanTagIteration = math.clamp(ClanTagIteration + 1, 0, #TagSequences + 1)
                    CurrentClanTag = TagSequences[ClanTagIteration]
                    if ClanTagIteration == #TagSequences then ClanTagIteration = 0 end
                elseif Type == "Normal" then
                    if ClanTagForward then
                        CurrentClanTag = string.sub(Tag, 1, ClanTagIteration)
                    else
                        CurrentClanTag = string.sub(Tag, 1, #Tag - ClanTagIteration)
                    end
                    if ClanTagIteration == #Tag + 1 then
                        ClanTagForward = not ClanTagForward
                        if ClanTagForward then CurrentClanTag = "" end
                        ClanTagIteration = 1
                        wait(0.5)
                    end
                    ClanTagIteration = math.clamp(ClanTagIteration + 1, 0, #Tag + 1)
                elseif Type == "Forward" then
                    CurrentClanTag = string.sub(Tag, 1, ClanTagIteration)
                    ClanTagIteration = math.clamp(ClanTagIteration + 1, 1, #Tag + 1)
                    if ClanTagIteration == #Tag + 1 then
                        ClanTagIteration = 0
                        wait(0.5) 
                    end
                elseif Type == "Reverse" then
                    CurrentClanTag = string.sub(Tag, 1, #Tag - ClanTagIteration)
                    ClanTagIteration = math.clamp(ClanTagIteration + 1, 1, #Tag + 1)
                    if ClanTagIteration == #Tag + 1 then
                        ClanTagIteration = 0
                        wait(0.5) 
                    end
                elseif Type == "Blink" then
                    CurrentClanTag = ClanTagBlinking and "" or Tag
                    ClanTagBlinking = not ClanTagBlinking
                elseif Type == "Boombox" then
                    local Boombox = Character and (Character:FindFirstChild("BoxModel") or Character:FindFirstChild("BoomBox"))
                    local Sound = Boombox and Boombox:FindFirstChild("SoundX", true)
                    if Sound then
                        local Id = string.gsub(Sound.SoundId, "%D", "")
                        Id = tonumber(Id)
                        if Id then
                            local Name = GetAudioName(Id)
                            if Name then
                                local Time = HMS(Sound.TimePosition) .. "/" .. HMS(Sound.TimeLength)
                                CurrentClanTag = "Playing: " .. Name .. "\n" .. "[" .. Time .. "]"
                            end
                        end
                    end
                elseif Type == "Spotify" then
                    local Data = GetPlayingSpotifySong()
                    if Data and Data.item then
                        local Name = Data.item.name
                        local Artist = Data.item.artists[1].name
                        local Progress = math.round(Data.progress_ms) / 1000
                        local Duration = math.round(Data.item.duration_ms) / 1000
                        local Time = HMS(Progress) .. "/" .. HMS(Duration)
                        CurrentClanTag = "Listening to\n" .. Name .. "\nBy: " .. Artist .. "\n" .. "[" .. Time .. "]"
                    end
                elseif Type == "Info" then
                    local ExecutorName, ExecutorVersion = identifyexecutor()
                    local Executor = "Executor: " .. ExecutorName .. " " .. ExecutorVersion
                    --local IsAFK = "IsAFK: "
                    local FPS = "FPS: " .. GetFrameRate()
                    local Ping = "Ping: " .. Ping .. "ms"
                    local LocalTime = os.date("Time: %X %p")
                    CurrentClanTag = Executor .. "\n" .. FPS .. "\n" .. Ping .. "\n" .. LocalTime
                end

                -- Limitting the Tag it self for Prefix and Suffix just incase
                if CurrentClanTag then
                    CurrentClanTag = string.sub(CurrentClanTag, 1, 100 - (#Config.ClanTag.Prefix + #Config.ClanTag.Suffix))
                    CurrentClanTag = Config.ClanTag.Prefix .. CurrentClanTag
                    CurrentClanTag ..= Config.ClanTag.Suffix
                end

                SetClanTag(CurrentClanTag)
                wait(Config.ClanTag.Speed)
            end
        end)
    else
        Threads.ClickSpam = coroutine.create(function()
            -- Prison Only
            while true do
                wait()
                if not Config.ClickSpam.Enabled then coroutine.yield() end
                if Ping > 500 then continue end
                for _, Player in ipairs(Players:GetPlayers()) do
                    if not Player.Character then continue end
                    for _, Tool in ipairs(GetTools(Player)) do
                        local Click = Tool:FindFirstChild("Click")
                        if not Click then continue end
                        Click:FireServer()
                    end
                end
            end
        end)
    end

    Threads.KnockDoors = coroutine.create(function()
        -- Windows don't have a knocking system
        while true do
            wait(0.2)
            if not Config.KnockDoors.Enabled then coroutine.yield() end
            if Ping > 500 then continue end
            for _, Door in ipairs(Doors) do
                if IsDoorOpen(Door) then continue end
                Door.Knock.ClickDetector.RemoteEvent:FireServer()
            end
        end
    end)

    Threads.Attach = coroutine.create(function()
        while true do
            if not Config.Attach.Enabled then coroutine.yield() end
            if Character then
                local RightArm = Character:FindFirstChild("Right Arm")
                local _Root = GetRoot(Target)
                if RightArm and Tool and _Root and Humanoid then
                    Tool.Grip = (RightArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)):ToObjectSpace(_Root.CFrame):Inverse()
                    Humanoid:EquipTool(Tool)
                end
                wait((Config.Attach.RefreshRate or 0) / 1000)
            end
            wait()
        end
    end)

    Threads.ChatSpam = coroutine.create(function()
        while true do
            if not Spamming then coroutine.yield() end
            pcall(function()
                local Messages = string.split(readfile("Identification/Games/The Streets/Spam.dat"), "\n")
                Chat(string.gsub(Messages[math.random(1, #Messages)], "%c", ""))
            end)
            wait(3.5)
        end
    end)

    Threads.InfiniteForceField = coroutine.create(function()
        while true do
            if not Config.InfiniteForceField.Enabled then coroutine.yield() end
            RefreshCharacter()
            wait(5)
        end
    end)

    Threads.FakeLag = coroutine.create(function()
        local Tick = 0
        local LastCFrame = Root and Root.CFrame
        local LastPoints
        
        while true do
            if not Config.FakeLag.Enabled then
                Menu.Indicators.List["Fake Lag"]:SetVisible(false)
                FakeLagVisualizer.Visible = false
                Tick = 0
                coroutine.yield()
            end

            Menu.Indicators.List["Fake Lag"]:SetVisible(true)
            FakeLagVisualizer.Visible = Config.FakeLag.Visualize
            if LastPoints and FakeLagVisualizer.Visible then
                FakeLagVisualizer:UpdatePoints(LastPoints)
                FakeLagVisualizer:SetColor(Config.FakeLag.Color, Config.FakeLag.Transparency)
            end

            if not Teleporting and Root and typeof(LastCFrame) == "CFrame" then
                SetCharacterServerCFrame(LastCFrame)

                local Randomization = math.random(-10, 10) / 100
                local Limit = Config.FakeLag.Limit + Randomization
                local Current = math_round(os.clock() - Tick, 2)

                Menu.Indicators.List["Fake Lag"]:Update(math.clamp(Current, 0, Limit), 0, Limit)
                if Current >= Limit then -- if it's more than the limit then lets get our new last position
                    LastCFrame = Root.CFrame

                    local Limbs, Success = GetLimbs(Player)
                    if Success then
                        pcall(function()
                            LastPoints = {
                                Limbs.Head.Position,
                                Limbs.Head.Neck.WorldPosition,
                                Limbs.Torso.Pelvis.WorldPosition,
        
                                Limbs.LeftArm.LeftShoulder.WorldPosition,
                                Limbs.LeftArm.Position,
                                Limbs.LeftArm.LeftHand.WorldPosition,
                                Limbs.RightArm.RightShoulder.WorldPosition,
                                Limbs.RightArm.Position,
                                Limbs.RightArm.RightHand.WorldPosition,
        
                                Limbs.LeftLeg.LeftHip.WorldPosition,
                                Limbs.LeftLeg.Position,
                                Limbs.LeftLeg.LeftFoot.WorldPosition,
                                Limbs.RightLeg.RightHip.WorldPosition,
                                Limbs.RightLeg.Position,
                                Limbs.RightLeg.RightFoot.WorldPosition
                            }
                        end)
                    end

                    Tick = os.clock()
                end
            end

            RunService.Stepped:Wait()
        end
    end)

    Threads.FakeVelocity = coroutine.create(function()
        while true do
            RunService.Stepped:Wait()
            if Config.AntiAim.Enabled and Config.AntiAim.Type == "Velocity" then
                SetCharacterServerVelocity(Vector3.new(100, 100, 100) * math.random(-10, 10), Vector3.new(100, 100, 100) * math.random(-10, 10))
            else
                coroutine.yield()
            end
        end
    end)

    Threads.CrashServer = coroutine.create(function()
        
    end)

    Threads.VersionCheck = coroutine.create(function()
        while true do
            wait(60)
            local Version = get_script_version()
            if Version ~= script_version then
                local Message = "Your version of the script is outdated, rejoin to get the latest build"
                Menu.Notify(Message, math.huge)
            end
        end
    end)

    for _, Thread in pairs(Threads) do
        coroutine.resume(Thread)
    end

    -- Global setup

    -- Also u can use GetAttribute

    getgenv().Client = {}
    Client.ESP = ESP
    Client.Menu = Menu
    Client.Config = Config

    Client.Chat = Chat
    Client.Attack = Attack
    Client.Stomp = Stomp
    Client.Drag = Drag
    Client.Teleport = Teleport
    Client.SetHat = SetHat
    Client.SetHatColor = SetHatColor
    Client.SetClanTag = SetClanTag
    Client.PlaySoundExploit = PlaySoundExploit
    Client.PlayAnimationServer = PlayAnimationServer
    Client.BuyItem = BuyItem
    Client.SetCharacterServerCFrame = SetCharacterServerCFrame
    Client.SetCharacterServerVelocity = SetCharacterServerVelocity
    
    Client.GetPing = function() return Ping, SendPing, ReceivePing end
    Client.GetTarget = function() return Target end
    Client.GetPlayer = GetPlayer
    Client.UserOwnsAsset = UserOwnsAsset
    Client.IsBehindAWall = IsBehindAWall
    Client.IsCharacterAlive = IsCharacterAlive

    Client.OnEvent = function(Event)

    end

    Client.GetCurrentVersion = function() return script_version end

    Client.Debug = {}
    Client.Debug.get_gc = function() return gcinfo() end
    Client.Debug.get_tables = function() return {Config = Config, Items = Items, Seats = Seats, Doors = Doors, Windows = Windows, Drawn = Drawn, Timers = Timers, DamageLogs = DamageLogs, AudioLogs = AudioLogs, Animations = Animations} end
    Client.Debug.get_drawn = function() return Drawn, ESP_Drawn end
    Client.Debug.get_threads = function() return Threads end


    RefreshMenu()
    Menu:SetVisible(true)
    Menu.Notify(string.format("Identification.cc took %s seconds to load in", "<font color = '#" .. Config.Menu.Accent:ToHex() .. "'>" .. (math_round((os.clock() - Time), 2)) .. "</font>"), 10)
end


Initialize()


-- Connections

RunService.Heartbeat:Connect(Heartbeat) -- laggy loop
RunService.Stepped:Connect(Stepped) -- laggy loop esp most likely
RunService.RenderStepped:Connect(RenderStepped)
UserInput.InputBegan:Connect(OnInput)
UserInput.InputEnded:Connect(OnInputEnded)
Player.Idled:Connect(OnIdle)
Player.CharacterAppearanceLoaded:Connect(OnCharacterAdded)
Players.PlayerChatted:Connect(OnPlayerChatted)
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)
Menu.CommandBar.FocusLost:Connect(OnCommandBarFocusLost)
workspace.ChildAdded:Connect(OnWorkspaceChildAdded)
workspace.ChildRemoved:Connect(OnWorkspaceChildRemoved)
Lighting.Changed:Connect(OnLightingChanged)
if Original then
    Character:WaitForChild("GetMouse").OnClientInvoke = OnGetMouseInvoke
    ReplicatedStorage:WaitForChild("TagReplicate").OnClientEvent:Connect(OnTagReplicateEvent)
end
--[[
if WebSocketClient then
    WebSocketClient:Send("user-id:" .. Player.UserId)
    WebSocketClient.OnMessage:Connect(function(Message)
        Menu.Notify("", Message)
    end)
else
    Menu.Notify("Warning", "Failed to connect to server")
end
]]
