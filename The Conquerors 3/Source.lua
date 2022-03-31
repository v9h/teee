--[[
    bind module
    event handler not initializing when executed before game load
    Hide Plants
    NUKE HAX?!
    Unit safe points? Keybind + Mouse1 to set safe point, if unit has low hp it will goto safe point and then back;
    Auto Oil // Magnitude check || Already going towards oil check
    Auto Plant Smart position
    Show levels in lobby by their names

    Auto Bot:
        Auto Power Plant or on keybind near ur character,
        Auto Oil,
        Auto Skin??? // Test
    Visuals:
        Show Mines,
        Show Cash and CPM,
        Remove Construction Soldiers "Construct" Button,
        All unit info on hover (Range, Health, Damage, Reload Time)
        Unit logger (Plane: Heavy plane(x8))
    Misc:
        Queue units/buildings? ex: queue("Place", "Power Plant", delay(40)); queue("Move", Vector3.new(50, 5, 2), delay(50))
        Chat Spammer,
        Rally Points,
        Event Logs:
            Nuke Built,
            Nuke Sent (Magnitude check (25 studs maybe) near ur units if magnitude check is nil then warn the closest enemy)
            Is Attacking you
    Settings:
        // The usual
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local IS_LOBBY = game.PlaceId == 8377997 and true or false


local wait = task.wait
local delay = task.delay
local spawn = task.spawn


local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player.PlayerGui
local ClientScript = PlayerGui.ScreenGui:FindFirstChild("LocalScript", true)
local MouseHover = not IS_LOBBY and PlayerGui.ScreenGui:FindFirstChild("MouseoverSpecial", true):FindFirstChildOfClass("TextButton") -- if MouseHover.Text == "Construct" then hide() end
local Share = not IS_LOBBY and require(ClientScript.Modules.Share)

local Menu
local Console
local Network
local Renderer
local Pathfinder
local EventHandler

spawn(function() Menu = Import("Menu") end)
spawn(function() Console = Import("Console") end)
if not IS_LOBBY then spawn(function() Network = Import("Network") end) end
spawn(function() Renderer = Import("Renderer") end)
if not IS_LOBBY then spawn(function() Pathfinder = Import("Pathfinder") end) end
spawn(function() EventHandler = Import("Events") end)

while not Menu or not Console or not Renderer or not EventHandler do wait() end
if not IS_LOBBY then
    while not Network or not Pathfinder do wait() end
end

local Config = {
    MoveResolver = {
        Enabled = true -- Click Move :: Resolved to Pathfinder(Units, Mouse.Hit)
    },
    AutoOil = {
        Enabled = true
    },
    AutoPlant = {
        Enabled = true, -- DOESNT WORK DON'T ENABLE
        Type = "Power Plant",
        SuperCheck = false -- only if it's a supercrystal
    },

    ShowMines = {
        Enabled = true
    },

    ShowCash = {
        Enabled = false,
    },

    ShowLevels = {
        Enabled = false
    },

    Indicators = {
        Enabled = false,
        Flags = {

        }
    },
    Keybinds = {},
    Removals = {
        Hover = {
            Construct = true,
            Garrison = true,
            Load = true, -- basically ungarrison for transport units
            ["Oil Rig"] = true
        },
        Others = {
            Fog = true,
        }
    },

    EventLogger = {
        Enabled = false,
        Flags = {

        }
    }
}


local Producers = {
    --[[
        Template = {
            Waypoint = Vector3.new()
        }
    ]]
}


local Threads = {}


-- // Functions \\


function GetRoundTime()
    return workspace.RoundSettings.RoundTime.Value
end


function GetPlayerStats(Player)

end


function GetPlayerFromTeam(TeamColor)
    for _, v in ipairs(Players:GetPlayers()) do
        if tostring(v.TeamColor) == tostring(TeamColor) then return v end
    end
end


function GetTeamColor(Player)
    return tostring(Player.TeamColor)
end


function GetTeamInfo(Team)

end


function GetTeamUnits(Team)
    local Teams = workspace.Teams:FindFirstChild(Team)
    if Teams then
        return Teams:GetChildren()
    end
end


function GetTeamProducing(Team)

end


function GetSelectedUnits()
    return {}
end


do
    if typeof(Share) == "table" then
        local InfoTable
        for _, v in pairs(Share) do
            if typeof(v) == "table" then
                for k2 in pairs(v) do
                    if k2 == "Landmine" then
                        InfoTable = v
                        break
                    end
                end
            end
        end

        function GetUnitInfo()
            local Info = InfoTable[Name]
            if Info.Type ~= "Building" then print(Info.Type) end
            return {
                Type = Info.Type,
                Cost = Info.Cost
            }
        end
    end
end


function GetClosest(Part, Parts)
    local Closest
    local Magnitude = math.huge
    for _, v in ipairs(Parts) do
        local magnitude = (Part.Position - v.Position).Magnitude
        if magnitude < Magnitude then
            Magnitude = magnitude
            Closest = v
        end
    end
    
    return Closest
end


function GetIncomeSpots()
    local Map = workspace.Map
    local EnergyCrystals = Map.EnergyCrystals
    local OilSpots = Map.OilSpots

    local Crystals = {}
    local Oils = {}

    for _, Crystal in ipairs(EnergyCrystals:GetChildren()) do
        local Base = Crystal.Torso
        local Using = Base.Using:FindFirstChild(GetTeamColor(Player)) -- Error here for some reason
        local Super = Base:FindFirstChild("SuperCrystal")

        Crystals[Crystal] = {
            self = Crystal,
            Using = Using and true or false,
            Super = Super and true or false,
            CFrame = Base.CFrame
        }
    end

    for _, Oil in ipairs(OilSpots:GetChildren()) do
        local Base = Oil.Torso
        local Using = Base.Using:FindFirstChild(GetTeamColor(Player))
        Oils[Oil] = {
            self = Oil,
            Using = Using and true or false,
            CFrame = Base.CFrame
        }
    end

    return {
        Crystals = Crystals,
        Oils = Oils
    }
end


function Loop()
    for Name, Enabled in pairs(Config.Removals.Hover) do
        if Enabled then
            if MouseHover then
                if string.find(string.lower(MouseHover.Text), string.lower(Name)) then
                    MouseHover.Visible = false
                    break
                else
                    MouseHover.Visible = true
                end
            end
        end
    end

    if Config.ShowMines.Enabled then
        local Mines = workspace.jiliIlI:GetChildren()
        for _, Mine in ipairs(Mines) do
            local Base = Mine.Torso
            if Base.Transparency == 1 then
                Base.Transparency = 0
            end
        end
    else
        local Mines = workspace.jiliIlI:GetChildren()
        for _, Mine in ipairs(Mines) do
            local Base = Mine.Torso
            local Team = Base.Team
            if Team == GetTeamColor(Player) then continue end
            if Base.Transparency == 0 then
                Base.Transparency = 1
            end
        end
    end
end


function Initialize()
    Console:Init()
    Menu:Init()
    EventHandler:Init()

    -- // Threads \\ --

    Threads.AutoOil = coroutine.create(function()
        while true do
            wait(1)
            if not Config.AutoOil.Enabled then coroutine.yield() end
            local OilShips = {}
            local OilParts = {}
            local OilSpots = GetIncomeSpots().Oils
    
            for _, Unit in ipairs(GetTeamUnits(GetTeamColor(Player))) do
                if tostring(Unit) == "Oil Ship" then
                    table.insert(OilShips, Unit)
                end
            end

            for _, Oil in pairs(OilSpots) do
                if not Oil.Using then
                    table.insert(OilParts, Oil.self.Torso)
                end
            end
    
            for _, OilShip in ipairs(OilShips) do
                local ShipBase = OilShip.Torso
                local ShipPosition = ShipBase.Position

                for _, Oil in pairs(OilSpots) do
                    local OilPosition = Oil.CFrame.Position
                    if not Oil.Using then
                        if (ShipPosition - OilPosition).Magnitude < 10 then
                            Network:Send("Activate", {OilShip})
                        end
                    end
                end

                if OilShip:GetAttribute("WaypointSet") then continue end

                local OilSpot = GetClosest(ShipBase, OilParts)
                if not OilSpot then
                    Console:Warn("[SOURCE] NO OIL SPOTS LEFT FOR OIL SHIPS")
                end
                local OilPosition = OilSpot.Position
                local ShipVelocity = ShipBase:FindFirstChild("BodyVelocity")

                if ShipVelocity then
                    local Velocity = ShipVelocity.Velocity
                    if Velocity == Vector3.new() then
                        OilShip:SetAttribute("WaypointSet", true)
                        delay(5, function()
                            OilShip:SetAttribute("WaypointSet", nil)
                        end)

                        local Path = Pathfinder:GetPath(OilShip, OilPosition + Vector3.new(0, 1, 0), {
                            Water = 0 -- only water?
                        })
                        
                        if not Path then return end

                        local CurrentPointIndex = 2
                        local Points = Path:GetWaypoints()
                        if Points then
                            Network:Send("Move", {
                                {OilShip}, {Points[2].Position}
                            })
                            for i = 3, #Points do
                                CurrentPointIndex = i
                                Network:Send("MOVE", {
                                    {OilShip}, {Points[i].Position}, true
                                })
                            end
                        end
                    end
                end
            end
        end
    end)


    Threads.AutoPlant = coroutine.create(function()
        while true do
            wait(0.2)
            if not Config.AutoPlant.Enabled then coroutine.yield() end
            local PlantType = Config.AutoPlant.Type
            local SuperCheck = Config.AutoPlant.SuperCheck
            
            local Cash = Player:GetAttribute("Cash")
            if Cash and Cash > GetUnitInfo(PlantType).Cost then
                local EnergyCrystals = GetIncomeSpots().Crystals
                for _, Crystal in pairs(EnergyCrystals) do
                    if not Crystal.Using then
                        if not Crystal.Super and SuperCheck then
                        else
                            local PartsInRadius = workspace:GetPartBoundsInRadius(Crystal.CFrame.Position, 15)
                            for _, Part in ipairs(PartsInRadius) do
                                if Part:IsDescendantOf(workspace.Teams[GetTeamColor(Player)]) then

                                end
                            end
                            for _, Unit in ipairs(GetTeamUnits(GetTeamColor(Player))) do
                                local Torso = Unit:FindFirstChild("Torso")
                                if not Torso then continue end
                                local Position = Torso.Position * Vector3.new(1, 0, 1)
                                if ((Position * Vector3.new(1, 0, 1)) - (Crystal.CFrame.Position * Vector3.new(1, 0, 1))).Magnitude < 10 then
                                    -- Simulates the building
                                    --Remotes.lllIIi:FireServer(0, v3.jliIll(99, 99, 9999) + v3.jliIll(0, v439.Y / 2, 0), 0, u36.Base.CFrame, 0);
                                    local Height = Crystal.CFrame.Position.Y - 0.40 -- All crystals should be same height so we good?
                                    Position += Vector3.new(0, Height, 0)
                                    Network:Send("PLACE", {
                                        PlantType, CFrame.new(Position, Vector3.new()), Crystal.self
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end)


    if IS_LOBBY then -- LOBBY CHECK
        local Menus = PlayerGui:WaitForChild("ScreenGui"):FindFirstChild("RIGHT_SECTION", true):WaitForChild("Menus")
        local PlayersFrame = Menus:WaitForChild("PlayersFrame"):WaitForChild("ScrollingFrame")
        local RoomPlayersFrame = Menus:WaitForChild("RoomPlayersFrame"):WaitForChild("ScrollingFrame")

        local function OnChildAdded(Frame)
            local LevelCircle = Frame:WaitForChild("LevelCircle")
            LevelCircle:GetPropertyChangedSignal("Visible"):Connect(function()
                    LevelCircle.Visible = true
            end)
            LevelCircle.Visible = true
        end

        for _, v in ipairs(PlayersFrame:GetChildren()) do
            if v:IsA("Frame") then OnChildAdded(v) end
        end

        for _, v in ipairs(RoomPlayersFrame:GetChildren()) do
            if v:IsA("Frame") then OnChildAdded(v) end
        end


        PlayersFrame.ChildAdded:Connect(OnChildAdded)
        RoomPlayersFrame.ChildAdded:Connect(OnChildAdded)

        return Console:Write("[SOURCE] Lobby Mode Activated", "Light Blue")
    end


    
    for _, Thread in pairs(Threads) do
        coroutine.resume(Thread)
    end

    PlayerGui:WaitForChild("Chat"):WaitForChild("Frame").Visible = false
    Console:Write("[SOURCE] Finished initializing")
end


Initialize()
if IS_LOBBY then return end


-- // Connections \\

UserInput.InputBegan:Connect(function(Input, Process)
    if Process then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Config.MoveResolver.Enabled then
            local Units = GetSelectedUnits()
            if Units then
                local Position = Mouse.Hit.Position
                if Position then
                    for _, Unit in ipairs(Units) do
                        local UnitType = GetUnitInfo(Unit).Type
                        local Costs = {}
                        --if UnitType == "Air" then end do nothing
                        if UnitType == "Building" then
                            continue
                        elseif UnitType == "Naval" then
                            Costs.Water = 0
                        else
                            Costs.Water = math.huge
                        end

                        local Path = Pathfinder:GetPath(Unit, Position, Costs)
                        if Path then
                            local CurrentPointIndex = 0
                            local Points = Path:GetWaypoints()

                            Network:Send("Move", {
                                {Unit}, {Points[2].Position}
                            })
                            for i = 3, #Points do
                                CurrentPointIndex = i
                                Network:Send("MOVE", {
                                    {Unit}, {Points[i].Position}, true
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end)


Network:Hook("SELECTED_UNITS", function(Caller, Arguments)
    function GetSelectedUnits()
        return unpack(Arguments)
    end

    return Arguments
end)


Network:Hook("MOVE", function(Caller, Arguments)
    if not Caller and Config.MoveResolver.Enabled then
        return nil
    end

    return Arguments
end)


EventHandler:Bind("CASH_CHANGED", function(Event)
    local Team = Event:GetTeam()
    local Player = GetPlayerFromTeam(Team)
    if Player then -- Could be THE AI
        Player:SetAttribute("Cash", Event:GetCash())
        Player:SetAttribute("CashPerMinute", Event:GetCashPerMinute())
    end
end)

EventHandler:Bind("SELLING_XP_CHANGED", function(Event)
    local Team = Event:GetTeam()
    local Player = GetPlayerFromTeam(Team)
    if Player then
        Player:SetAttribute("SELLING_XP", Event:GetValue())
    end
end)

EventHandler:Bind("COUNTER_CHANGED", function(Event)

end)

EventHandler:Bind("RESEARCH_CHANGED", function(Event)

end)

EventHandler:Bind("PRODUCER_CHANGED", function(Event)
    local Team = Event:GetTeam()
    local Player = GetPlayerFromTeam(Team)
end)

EventHandler:Bind("UNIT_ADDED", function(Event)
    local Team = Event:GetTeam()
    local _Player = GetPlayerFromTeam(Team)
    
    if _Player == Player then
        local Unit = Event:GetUnit()
        if tostring(Unit) == "Oil Ship" then
            
        end
    end
end)

EventHandler:Bind("UNIT_CHANGED", function(Event)
    local Team = Event:GetTeam()
    local Player = GetPlayerFromTeam(Team)
end)

EventHandler:Bind("UNIT_DEATH", function(Event)
    local Team = Event:GetTeam()
    local Player = GetPlayerFromTeam(Team)
end)

RunService.Heartbeat:Connect(Loop)
