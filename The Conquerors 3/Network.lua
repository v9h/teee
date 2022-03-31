-- // Network Module \\ --
-- // TODO Make requests be overwritten (avoids overflood and disconnection); Make the remotes be in a remotes table instead of Functions table


local Network = {}
local Scheduled = {}


local wait = task.wait
local spawn = task.spawn
local secure_call = securecall or secure_call or syn.secure_call

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local pShare = require(ReplicatedStorage:WaitForChild("PShare"))
for k, v in pairs(pShare) do
    pRemotes = v
end

local Remotes = {
    BUY = pRemotes.liIljll,
    RESEARCH = pRemotes.jIIiiI,
    PLACE = pRemotes.Iliill,
    MOVE = pRemotes.jjiIIi,
    ACTIVATE = pRemotes.ilIIjI,
    CANCEL = pRemotes.ilIlli,
    SELL = pRemotes.ijiIIiI,
    CHAT = pRemotes.jIjlIi,
    -- lazy currently
    --EQUIP_SKIN = pRemotes.,
    --EQUIP_FLAG = pRemotes.,
    --EQUIP_PACKAGE = pRemotes.,
    --EQUIP_HAT = pRemotes.,
    --EQUIP_GUN = pRemotes.,

    SELECTED_UNITS = ReplicatedStorage.ljljjli
}


local Functions = {
    BUY = function(Name, Spawner)
        Remotes.BUY:FireServer(Name, Spawner)
        --self:FireServer("HeavyTank", workspace.Teams:FindFirstChild("Bright yellow"):FindFirstChild("Tank Factory"))
    end,
    RESEARCH = function(self)
        -- TeamSettings[local team].jljjijj[research]
        Remotes.RESEARCH:FireServer(self)
    end,
    PLACE = function(Name, CF, ...) -- Make this unit based so automatic Vector
        local Building = ReplicatedStorage.Units[Name] -- // only a test
        local Vector = Vector3.new(99, 99 + (Building:GetModelSize().Y / 2), 9999) -- Retard

        Remotes.PLACE:FireServer(Name, Vector, workspace.Teams[tostring(Player.TeamColor)], CF, ...) -- ... is if it's a crystal
    end,
    MOVE = function(Units, Positions, Waypoint)
        Remotes.MOVE:FireServer({
            isAWaypoint = Waypoint or false,
            Position = Positions,
            ["IjlIjlj"] = Units
        })
    end,
    ACTIVATE = function(Unit)
        Remotes.ACTIVATE:FireServer({Unit}) -- Yes it's in a table
    end,
    CANCEL = function(Unit)
        Remotes.CANCEL:FireServer("???") -- Lol
    end,
    SELL = function(Unit)
        Remotes.SELL:FireServer(Unit)
    end,
    CHAT = function(Message, Type) -- Type : "Ally" | "Global"
        Remotes.CHAT:FireServer(Message, Type, 1)
    end,
    EQUIP_SKIN = function(Name)
        Remotes.EQUIP_SKIN:FireServer(Name)
    end,
    EQUIP_FLAG = function(Name)
        Remotes.EQUIP_FLAG:FireServer(Name)
    end,
    EQUIP_PACKAGE = function(ID)
        Remotes.EQUIP_PACKAGE:FireServer(ID)
    end,
    EQUIP_HAT = function(ID)
        Remotes.EQUIP_PACKAGE:FireServer(ID)
    end,
    EQUIP_GUN = function(ID)
        Remotes.EQUIP_GUN:FireServer(ID)
    end
}


function Network:Send(Name, Arguments)
    if typeof(Name) ~= "string" then
        return Console:Error("[NETWORK] REQUEST_NAME expected 'string' got " .. typeof(Name))
    end

    Name = string.upper(Name)
    local Function = Functions[Name]
    if Function then
        Console:Write("[NETWORK] Sending " .. tostring(Name) .. " request")
        Function(unpack(Arguments))
    else
        Console:Error("[NETWORK] Remote " .. Name .. " not found")
    end
end


function Network:Hook(Name, Callback)
    if typeof(Name) ~= "string" then
        return Console:Error("[NETWORK] REQUEST_NAME expected 'string' got " .. typeof(Name))
    end

    local Remote = Remotes[string.upper(Name)]
    if Remote then
        local NameCall
        NameCall = hookmetamethod(game, "__namecall", function(self, ...)
            local Arguments = {...}
            local Caller, Method = checkcaller(), getnamecallmethod()

            if Method == "FireServer" or Method == "InvokeServer" then
                if self == Remote then
                    Arguments = Callback(checkcaller(), Arguments)
                    if Arguments == nil then return end
                end
            end

            return NameCall(self, unpack(Arguments))
        end)
    else
        return Console:Error("[NETWORK] Remote " .. Name .. " not found")
    end
end


getgenv().Network = Network


spawn(function()
    while true do
        for _, v in ipairs(Scheduled) do

        end
        wait(0.1)
    end
end)


return Network
