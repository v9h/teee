local DUPE_AMOUNT = 5
local FILE_NAME = "DupeTracker.txt"

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local File = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/libs/File.lua"))()

local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport
local wrap, insert, foreach, random = coroutine.wrap, table.insert, table.foreach, math.random
local IsA, Clone, Destroy, GetChildren = game.IsA, game.Clone, game.Destroy, game.GetChildren

if not File.Read(FILE_NAME) or File.Read(FILE_NAME) == "0" then
    File.Write(FILE_NAME, DUPE_AMOUNT)
    return
else
    DUPE_AMOUNT = File.Read(FILE_NAME)
end

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local DupePosition = CFrame.new(random(-2e5, 2e5), 2e5, random(-2e5, 2e5))

function GrabTools(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    for _, v in ipairs(GetChildren(Workspace)) do
        if IsA(v, "Tool") then
            Humanoid:EquipTool(v)
            v.Handle.Anchored = false
        end
    end
end

function GetTools(Player)
    local Tools = {}
    pcall(function()
        foreach({GetChildren(Player.Character), GetChildren(Player.Backpack)}, function(_, v)
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
print("Grab tools")

for _ = 1, DUPE_AMOUNT do
    Character = Player.Character or Player.CharacterAdded:Wait()
    local Backpack = Player:WaitForChild("Backpack")
    local Humanoid = Character:WaitForChild("Humanoid")
    local Root = Humanoid.Torso
	
    GrabTools(Character)
    Root.CFrame = DupePosition
    wait(0.1)
    Root.Anchored = true
    Clone(Humanoid).Parent = Character
    Destroy(Humanoid)
    File.Write(FILE_NAME, tonumber(File.Read(FILE_NAME)) - 1)
    
    local PlayerCount = #Players:GetPlayers()
    if Players.RespawnTime > 3 and PlayerCount > 1 and PlayerCount < Players.MaxPlayers then
        queue_on_teleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/Dupe%20Tools.lua"))()
        ]])
        delay(0, function()
            TeleportService:Teleport(game.PlaceId, Player)
        end)
    else
        wait(Players.RespawnTime - 0.2)
    end

	for _, v in ipairs(GetTools(Player)) do
		v.Parent = Character
		v.Handle.Anchored = true
		v.Parent = Workspace
	end
    
    Character:BreakJoints()
    Player.CharacterAdded:Wait()
end

GrabTools(Player.Character or Player.CharacterAdded:Wait())
