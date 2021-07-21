local DUPE_AMOUNT = 5
local FILE_NAME = "DupeTracker.txt"

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local File = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/libs/File.lua"))()

local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport
local wrap, insert, random = coroutine.wrap, table.insert, math.random
local IsA, Clone, Destroy, GetChildren = game.IsA, game.Clone, game.Destroy, game.GetChildren

if not File.Read(FILE_NAME) or File.Read(FILE_NAME) == "0" then
    File.Write(FILE_NAME, DUPE_AMOUNT)
    return
else
    DUPE_AMOUNT = File.Read(FILE_NAME)
    print(DUPE_AMOUNT)
end

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local DupePosition = CFrame.new(random(-2e5, 2e5), 2e5, random(-2e5, 2e5))

function GrabTools(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    for _, v in ipairs(GetChildren(Workspace)) do
        if IsA(v, "Tool") and v:GetAttribute(Player.Name) then
            Humanoid:EquipTool(v)
            v.Handle.Anchored = false
        end
    end
end

function GetTools(Player)
    local Tools = {}
    pcall(function()
        table.foreach({GetChildren(Player.Character), GetChildren(Player.Backpack)}, function(_, v)
            for _, v2 in ipairs(v) do
                if IsA(v2, "Tool") then
                    insert(Tools, v2)
                    v2:SetAttribute(Player.Name, true)
                end
            end
        end)
    end)
    return Tools
end

GrabTools(Character)

for _ = 1, DUPE_AMOUNT do
    Character = Player.Character or Player.CharacterAdded:Wait()
    local Backpack = Player:WaitForChild("Backpack")
    local Humanoid = Character:WaitForChild("Humanoid")
    local Root = Humanoid.Torso
    
    Root.CFrame = DupePosition
    wait(0.1)
    Root.Anchored = true
    Clone(Humanoid).Parent = Character
    Destroy(Humanoid)
    local PlayerCount = #Players:GetPlayers()
    if Players.RespawnTime > 3 and PlayerCount > 1 and PlayerCount < Players.MaxPlayers then
        queue_on_teleport([[
            game.Loaded:Wait()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/Dupe%20Tools.lua"))()
        ]])
        File.Write(FILE_NAME, tonumber(File.Read(FILE_NAME)) - 1)
        delay(0, function()
            TeleportService:Teleport(game.PlaceId, Player)
        end)
    else
        wait(Players.RespawnTime - 0.5)
    end

	for _, v in ipairs(GetTools(Player)) do
		v.Parent = Character
		v.Handle.Anchored = true
		v.Parent = Workspace
	end
    
    Character:BreakJoints()
    Player.CharacterAdded:Wait()
end

wait()
GrabTools(Player.Character or Player.CharacterAdded:Wait())
