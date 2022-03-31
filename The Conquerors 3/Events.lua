-- // Event Handler Module \\ --


local EventHandler = {}
local EventListeners = {}

local IS_LOBBY = game.PlaceId == 8377997 and true or false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventEnums = {
    GAME_STARTED = {
        "GetGamemode"
    },
    GAME_ENDED = {},
    CASH_CHANGED = {
        "GetTeam",
        "GetCashPerMinute",
        "GetCPM",
        "GetCash"
    },
    SELLING_XP_CHANGED = {
        "GetTeam",
        "GetValue"
    },
    COUNTER_CHANGED = {
        "GetTeam",
        "GetType", -- Building, Navy, Plane
        "GetCapacity",
        "GetValue" -- return TeamSettings[Team].Counters.Soldier.Value
    },
    RESEARCH_CHANGED = {
        "GetTeam",
        "GetStatus", -- "Cancelled", "Finished", "Started", etc.
        "GetUnit", -- "Soldier cap 3", "Juggernaut", etc.
    },
    DAMAGE_CHANGED = {
        "GetTeam",
        "GetValue"
    },
    HEAL_CHANGED = {
        "GetTeam",
        "GetValue"
    },
    PRODUCER_CHANGED = { -- Barracks, Naval Shipyard, Tank Factory, Airport, etc.
        "GetUnit",
        "GetQueued" -- Return type userdata; with progress and team color and name
    },
    UNIT_CHANGED = {
        "GetUnit",
        "GetTeam"
    },
    UNIT_DEATH = {
        "GetUnit",
        "GetTeam"
    },
    UNIT_ADDED = {
        "GetUnit",
        "GetTeam",
        "GetSpawner",
        "IsBuilding"
    },
    PLAYER_JOINED = {
        "GetTeam",
        "GetValue",
        "GetLevel",
        "GetTimePlayed"
    },
    PLAYER_LEFT = {
        "GetTeam",
        "GetValue"
    }
}


function EventHandler:Bind(Name, Callback)
    if typeof(Name) ~= "string" then
        return Console:Error("[EVENT HANDLER] EVENT_NAME expected 'string' got " .. typeof(Name))
    end

    Name = string.upper(Name)
    local Event = EventEnums[Name]
    if Event then
        table.insert(EventListeners, {
            Name = Name,
            Callback = Callback
        })
    else
        return Console:Error("[ERROR] NO EVENT FOUND NAMED " .. Name)
    end
end


function NewEvent(Name, Arguments)
    local Event = newproxy(true)
    local Meta = getmetatable(Event)
    Meta.__tostring = function() return "[EVENT OBJECT] " .. tostring(Name) end
    Meta.__index = function(self, Key)
        if string.lower(Key) == "name" then return Name end
        if Arguments then
            for k, v in pairs(Arguments) do
                if k == Key then
                    return v
                end
            end
        end
    end

    return Event
end


function OnEventTriggered(Event)
    for _, v in ipairs(EventListeners) do -- EventListeners
        if Event.Name == v.Name then
            v.Callback(Event)
        end
    end
end



function EventHandler:Init()
    Console:Write("[EVENT HANDLER] Initializing...")

    if not IS_LOBBY then

        local TeamSettings = workspace:WaitForChild("TeamSettings", math.huge)
        local RoundSettings = workspace:WaitForChild("RoundSettings", math.huge)

        local RoundTime = RoundSettings:WaitForChild("RoundTime", math.huge)
        local Teams = workspace:WaitForChild("Teams", math.huge)

        while RoundTime.Value == 0 do wait() end

        OnEventTriggered(NewEvent("GAME_STARTED", {
            GetGamemode = function()
                return workspace.RoundSettings["New_Lobby"].CurrentGame.Gamemode.Value
            end,
            GetRoundId = function()
                return workspace.RoundSettings.RoundId.Value
            end
        }))

        RoundSettings.ShowEndRound.Changed:Connect(function()
            if RoundSettings.ShowEndRound.Value then
                OnEventTriggered(NewEvent("GAME_ENDED"))
            end
        end)

        if game.PlaceId == 380840554 then -- survival ai bot
            while Players.MaxPlayers ~= #TeamSettings:GetChildren() - 1 do wait() end
        else
            while Players.MaxPlayers ~= #TeamSettings:GetChildren() do wait() end
        end
        for _, Setting in ipairs(TeamSettings:GetChildren()) do
            local Cash = Setting:WaitForChild("Cash", math.huge)
            local CashPerMinute = Setting:WaitForChild("CashPerMinute", math.huge)
            local Allies = Setting:WaitForChild("Allies", math.huge)
            local Counters = Setting:WaitForChild("Counters", math.huge)
            local DamageDealt = Setting:WaitForChild("DamageDealt", math.huge)
            local DamageHealed = Setting:WaitForChild("DamageHealed", math.huge)
            local TeamNumber = Setting:WaitForChild("TeamNumber", math.huge)
            
            local ResearchInfo
            local SellingXPAvailable
            while not ResearchInfo do
                local Upgrade = Setting:FindFirstChild("SoldierCapUpgrade1", true)
                if Upgrade then
                    ResearchInfo = Upgrade.Parent
                end
                wait()
            end

            while not SellingXPAvailable do
                local Found = Setting:FindFirstChild("SellingXPAvailable", true)
                if Found then
                    SellingXPAvailable = Found.Parent
                end
                wait()
            end

            for _, ResearchUnit in ipairs(ResearchInfo:GetChildren()) do
                local Cost = ResearchUnit:FindFirstChild("Cost")
                local Progress = ResearchUnit:FindFirstChild("Progress")
                local Time = ResearchUnit:FindFirstChild("ResearchTime")
                local Purchased = ResearchUnit:FindFirstChild("Purchased")
                local Done = ResearchUnit:FindFirstChild("Done")


                Progress.Changed:Connect(function()

                end)
                Done.Changed:Connect(function()

                end)
            end

            Cash.Changed:Connect(function()
                OnEventTriggered(NewEvent("CASH_CHANGED", {
                    GetTeam = function() return tostring(Setting) end,
                    GetCash = function() return Cash.Value end,
                    GetValue = function() return Cash.Value end,
                    GetCPM = function() return CashPerMinute.Value end,
                    GetCashPerMinute = function() return CashPerMinute.Value end
                }))
            end)
            CashPerMinute.Changed:Connect(function()
                OnEventTriggered(NewEvent("CASH_CHANGED", {
                    GetTeam = function() return tostring(Setting) end,
                    GetCash = function() return Cash.Value end,
                    GetValue = function() return Cash.Value end,
                    GetCPM = function() return CashPerMinute.Value end,
                    GetCashPerMinute = function() return CashPerMinute.Value end
                }))
            end)

            DamageDealt.Changed:Connect(function()
                OnEventTriggered(NewEvent("DAMAGE_CHANGED", {
                    GetTeam = function() return tostring(Setting) end,
                    GetValue = function() return DamageDealt.Value end
                }))
            end)
            DamageHealed.Changed:Connect(function()
                OnEventTriggered(NewEvent("HEAL_CHANGED", {
                    GetTeam = function() return tostring(Setting) end,
                    GetValue = function() return DamageHealed.Value end
                }))
            end)

            SellingXPAvailable.Changed:Connect(function()
                OnEventTriggered(NewEvent("SELLING_XP_CHANGED", {
                    GetTeam = function() return tostring(Setting) end,
                    GetValue = function() return SellingXPAvailable.Value end
                }))
            end)
        end

        for _, Team in ipairs(Teams:GetChildren()) do
            local function AddUnitListener(self)
                if not self then return end
                local Torso = self:FindFirstChild("Torso")
                if Torso then
                    local Health = Torso:FindFirstChild("Health")
                    local MaxHealth = Torso:FindFirstChild("MaxHealth")
                    local BuildProgress = Torso:FindFirstChild("BuildProgress")
                    local Producing = Torso:FindFirstChild("Producing")
                    local Garrisoned = Torso:FindFirstChild("Garrisoned")
                    local OnFire = Torso:FindFirstChild("OnFire")

                    local BodyVelocity = Torso:FindFirstChild("BodyVelocity")


                    if Health then
                        Health.Changed:Connect(function()
                            OnEventTriggered(NewEvent("UNIT_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetValue = function() return Health.Value end,
                                GetProperty = function() return "Health" end
                            }))
                        end)
                    end


                    if OnFire then
                        OnFire.Changed:Connect(function()
                            OnEventTriggered(NewEvent("UNIT_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetValue = function() return OnFire.Value end,
                                GetProperty = function() return "OnFire" end
                            }))
                        end)
                    end


                    if BuildProgress then
                        BuildProgress.Changed:Connect(function()
                            OnEventTriggered(NewEvent("UNIT_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetProperty = function() return "Progress" end,
                                GetValue = function() return BuildProgress.Value end
                            }))
                        end)
                    end


                    if Garrisoned then
                        Garrisoned.ChildAdded:Connect(function(self)

                        end)
                        Garrisoned.ChildRemoved:Connect(function(self)
                            
                        end)
                    end


                    if Producing then
                        Producing.ChildAdded:Connect(function(self)
                            OnEventTriggered(NewEvent("PRODUCER_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetStatus = function() return "Started" end
                            }))
                            local Progress = self:FindFirstChild("Progress")
                            if Progress then
                                Progress.Changed:Connect(function()
                                    OnEventTriggered(NewEvent("PRODUCER_CHANGED", {
                                        GetTeam = function() return tostring(Team) end,
                                        GetUnit = function() return self end,
                                        GetStatus = function() return "Progress" end,
                                        GetValue = function() return Progress.Value end
                                    }))
                                end)
                            end
                        end)
                        Producing.ChildRemoved:Connect(function(self)
                            OnEventTriggered(NewEvent("PRODUCER_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetStatus = function() return "Remove" end,
                                --GetValue = function() return Progress.Value end
                            }))
                        end)
                    end


                    if BodyVelocity then
                        BodyVelocity:GetPropertyChangedSignal("Velocity"):Connect(function()
                            OnEventTriggered(NewEvent("UNIT_CHANGED", {
                                GetTeam = function() return tostring(Team) end,
                                GetUnit = function() return self end,
                                GetValue = function() return BodyVelocity.Velocity end,
                                GetProperty = function() return "Velocity" end
                            }))
                        end)
                    end


                    Torso:GetPropertyChangedSignal("Position"):Connect(function()
                        OnEventTriggered(NewEvent("UNIT_CHANGED", {
                            GetTeam = function() return tostring(Team) end,
                            GetUnit = function() return self end,
                            GetValue = function() return Torso.Position end,
                            GetProperty = function() return "Position" end
                        }))
                    end)
                end
            end

            for _, Unit in ipairs(Team:GetChildren()) do
                OnEventTriggered(NewEvent("UNIT_ADDED", {
                    GetTeam = function() return tostring(Team) end,
                    GetProducer = function() return end,
                    GetUnit = function() return self end
                }))
                AddUnitListener(Unit)
            end

            Team.ChildAdded:Connect(function(self)
                OnEventTriggered(NewEvent("UNIT_ADDED", {
                    GetTeam = function() return tostring(Team) end,
                    GetProducer = function()
                        local Producers
                        for _, Unit in ipairs(Team:GetChildren()) do
                            local Torso = Unit:FindFirstChild("Torso")
                            if Torso then
                                local Producing = Torso:FindFirstChild("Producing")
                                if Producing then
                                    table.insert(Producers, Unit)
                                end
                            end
                        end

                        local Producer
                        local Magnitude = math.huge
                        for _, Unit in ipairs(Producers) do
                            local _Magnitude = (self.Torso.Position - Unit.Torso.Position).Magnitude
                            if _Magnitude < Magnitude then
                                Producer = Unit
                                Magnitude = _Magnitude
                            end
                        end

                        return Producer
                    end,
                    GetUnit = function() return self end
                }))
                AddUnitListener(Unit)
            end)
            Team.ChildRemoved:Connect(function(self)
                OnEventTriggered(NewEvent("UNIT_DEATH", {
                    GetTeam = function() return tostring(Team) end,
                    GetUnit = function() return self end
                }))
            end)
        end
    end
    Console:Write("[EVENT HANDLER] Initialized Event Handler")
end

Players.PlayerAdded:Connect(function(Player)
    local Level
    local TimePlayed

    if game.PlaceId == 8377997 then
        local PlayerValues = Player:WaitForChild("PlayerValues")
        Level = PlayerValues:WaitForChild("Level").Value
        TimePlayed = PlayerValues:WaitForChild("TimePlayedTC3").Value
    else

    end

    OnEventTriggered(NewEvent("PLAYER_JOINED", {
        GetTeam = function() return tostring(Player.TeamColor) end,
        GetValue = function() return Player end,
        GetLevel = function() return Level end,
        GetTimePlayed = function() return TimePlayed end
    }))
end)


Players.PlayerRemoving:Connect(function(Player)
    OnEventTriggered(NewEvent("PLAYER_LEFT", {
        GetTeam = function() return tostring(Player.TeamColor) end,
        GetValue = function() return Player end
    }))
end)


getgenv().Events = EventHandler


return EventHandler