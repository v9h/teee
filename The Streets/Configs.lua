local Configs = {}


local Utils = import "Utils"

local HttpService = game:GetService("HttpService")


local Config = {
    Aimbot = {
        Enabled = false,
        CollisionCheck = true, -- turn off if player is no-clipping?
        Visualize = false,
        TargetSelection = "Near mouse",
        HitBox = "Torso",
        Radius = 100,
        VelocityMultiplier = 1,
        Key = nil,
		
	Prediction = {
	    Method = "Default",
	    VelocityPredictionAmount = 10,
	    VelocityMultiplier = 1
	}
    },
    AutoFire = {
        Enabled = false,
        Range = 50,
        Priority = "Head",
	VelocityCheck = {
	    Enabled = false,
	    MaxVelocity = 0
	},
        Key = nil
    },
    CameraLock = {
        Enabled = false,
	Mode = "RenderStepped",
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
        Type = "Velocity",
        Key = nil,

		Motionless = { -- still technically velocity but it doesn't fling you every where
			AutomaticallySetAxisValues = true, 
			
			X = {Minimum = -1000, Maximum = 1000},
			Y = {Minimum = -1000, Maximum = 1000},
			Z = {Minimum = -1000, Maximum = 1000}
		}
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
	BuyAmmo = {Key = nil},
	TeleportBack = {Enabled = false},
    DisableToolCollision = {Enabled = false},
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
    AntiChatLog = {Enabled = true},
    AutoHeal = {Enabled = false},
    ClickOpen = {Enabled = false},
    ClickSpam = {Enabled = false},
    NoGunDelay = {Enabled = false},
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
	Sequence = {
	    Enabled = false,
	    Colors = {},
	    Delay = 0.5
	}
    },
    ClanTag = {
        Enabled = false,
        Visualize = false,
        Tag = "",
        Type = "Cheat", --Forward || Reverse || Static || Blink || Normal || Cheat || Sequences({Tag = "???"}, {Tag=  "???"}) || Boombox || Wave test 
        Prefix = "",
        Suffix = "",
        SpotifyToken = "",
        Speed = 0.2
        -- Maybe animation rules like "??? neverlose.cc": animate at #"???" + 1 to #tag default 0 to #tag
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
            WallsColor = Color3.new(),
            WallsTransparency = 0,

            KnockedOut = {
                Enabled = false,
                Color = Color3.fromRGB(115, 15, 215),
                Material = "Force field",
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
        Material = "Force field",
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
            Colors = {
                Ambient = Color3.new(1, 1, 1),
                OutdoorAmbient = Color3.new(1, 1, 1)
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
        Chat = {
            Enabled = false,
            Position = 0,
        },
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
            Filled = false,
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


Configs.Config = Config


function Configs:Save(Name: string)
    local function Iterate(Table: table)
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

    local ConfigFile = "ponyhook/Games/The Streets/Configs/" .. Name .. ".cfg"
    local config_clone = Utils.table_clone(self.Config)

    Iterate(config_clone)
    writefile(ConfigFile, HttpService:JSONEncode(config_clone))
end


function Configs:Load(Name: string): table
    local function Iterate(Table: table)
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

    local function DeepPatch(Original: table, Copy: table)
        for k, v in pairs(Original) do
            if typeof(Copy[k]) ~= typeof(Original[k]) then
                Copy[k] = v
            end

    		if typeof(v) == "table" then
    			DeepPatch(v, Copy[k] or {})
    		end
    	end
    end

    local ConfigFile = "ponyhook/Games/The Streets/Configs/" .. Name .. ".cfg"
    local _Config = HttpService:JSONDecode(readfile(ConfigFile))

    Iterate(_Config)
    DeepPatch(self.Config, _Config) -- if player made a config a while a go and the script got updated then the config will be invalid we need to patch the cfg
    self.Config = _Config

    return self.Config
end


return Configs
