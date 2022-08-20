local PlayerManager = {}


local Utils = import "Utils"
local Events = import "Libraries/Events"


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


PlayerManager.LocalPlayer = Players.LocalPlayer or not Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

PlayerManager.PlayerAdded = Events.new()
PlayerManager.PlayerRemoved = Events.new()
PlayerManager.CharacterAdded = Events.new()
PlayerManager.CharacterRemoved = Events.new()


local function AddPlayerListeners(Player: Player, Character: Model)
    local Backpack = Player:WaitForChild("Backpack")
    local Humanoid = Character:WaitForChild("Humanoid")
    local Root = Humanoid.RootPart


    local function OnHumanoidDied()
        Player:SetAttribute("IsAlive", false)
        Player:SetAttribute("KnockedOut", false)
    end

    local function OnRootPartDestroyed()
        if not Root then return end
        Player:SetAttribute("RootPoint", Root.Position)
    end

    local function OnHealthChanged(Value: number)
        Player:SetAttribute("Health", Value)
    end

    local function OnStaminaChanged(Value: number)
        Player:SetAttribute("Stamina", Value)
    end


    local StaminaInstance = Utils.IsOriginal and Character:WaitForChild("Stamina")
    if not StaminaInstance then
        local ServerTraits = Backpack:WaitForChild("ServerTraits")
        StaminaInstance = ServerTraits:WaitForChild("Stann")
    end


    OnHealthChanged(Humanoid.Health)
    OnStaminaChanged(100)

    if Root then Root.Destroying:Once(OnRootPartDestroyed) else OnRootPartDestroyed() end
    Humanoid.Died:Once(OnHumanoidDied)
    Humanoid.HealthChanged:Connect(OnHealthChanged)
    StaminaInstance.Changed:Connect(OnStaminaChanged)
end


local function UpdatePlayersInfo(Step: number)
    local LocalPlayerRoot = Utils.GetRoot(PlayerManager.LocalPlayer)

    for _, Player in ipairs(Players:GetPlayers()) do -- 34 players; 4 attribute changes for each player; 34*4=136changes every step; 136*60 = 8160 changes every second
        local LastPosition = Player:GetAttribute("Position")
        if not LastPosition then continue end

        local Root = Utils.GetRoot(Player)

        if Root then
            local Position = Root.Position

            if Player ~= PlayerManager.LocalPlayer and LocalPlayerRoot then
                Player:SetAttribute("BehindWall", (IsBehindAWall(Root, LocalPlayerRoot, {LocalPlayerRoot.Parent})))
            end

            Player:SetAttribute("Distance", Utils.math_round(Player:DistanceFromCharacter(Position), 2))
            Player:SetAttribute("Velocity", (Position - LastPosition) / Step)
            Player:SetAttribute("Position", Position)
        else
            Player:SetAttribute("Distance", 0)
            Player:SetAttribute("Velocity", Vector3.new())
            Player:SetAttribute("Position", Vector3.new())
            Player:SetAttribute("BehindWall", false)
        end
    end
end


function PlayerManager:FindPlayersByName(Name: string): table
    Name = string.gsub(string.lower(tostring(Name)), "%s", "")

    local Matches = {}
    local PlayersTable = Players:GetPlayers()

    if Name == "me" then
        return {Player}
    -- elseif Name == "target" then
    --     return {Target}
    elseif Name == "all" then
        Matches = PlayersTable
        table.remove(Matches, table.find(Matches, Player))
        return Matches
    end

    for _, Player in ipairs(PlayersTable) do
        if Name == string.sub(string.lower(Player.Name), 1, #Name) then
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


function PlayerManager:GetPlayers(Blacklist: table): table
    local PlayersTable = {}
    Blacklist = typeof(Blacklist) == "table" and Blacklist or {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if table.find(Blacklist, Player) then continue end
        table.insert(PlayersTable, Player)
    end

    return PlayersTable
end


function PlayerManager:GetPlayersWithUserIds(UserIds: table): table
    local PlayersTable = {}

    for _, UserId in ipairs(UserIds) do
        table.insert(PlayersTable, Players:GetPlayerByUserId(UserId))
    end

    return PlayersTable
end


function PlayerManager:GetPlayersFromCharacters(Characters: table): table
    local PlayersTable = {}

    for _, Character in ipairs(Characters) do
        table.insert(PlayersTable, Players:GetPlayerFromCharacter(UserId))
    end

    return PlayersTable
end


function PlayerManager:Initialize()
    for _, Player in ipairs(Players:GetPlayers()) do
        OnPlayerAdded(Player)
    end
end


local function OnCharacterAdded(Player: Player, Character: Model)
    local Backpack = Player:WaitForChild("Backpack")
    local Humanoid = Character:WaitForChild("Humanoid")
    local Root = Humanoid.RootPart


    Player:SetAttribute("Vest", Utils.UserOwnsAsset(Player, 6967243, "GamePass"))
    Player:SetAttribute("AnimeGamePass", Utils.UserOwnsAsset(Player, 1082540, "GamePass") and true or false)

    Player:SetAttribute("Health", Humanoid.Health)
    Player:SetAttribute("IsAlive", true)
    Player:SetAttribute("KnockedOut", false)
    Player:SetAttribute("KnockOut", 0)
    Player:SetAttribute("RootPoint", Root and Root.Position)


    AddPlayerListeners(Player, Character)
    PlayerManager.CharacterAdded:Fire(Player, Character)
end


local function OnCharacterRemoving(Player: Player, Character: Model)
    Player:SetAttribute("IsAlive", false)
    Player:SetAttribute("KnockedOut", false)
    PlayerManager.CharacterRemoved:Fire(Player, Character)
end


local function OnPlayerAdded(Player: Player)



    PlayerManager.PlayerAdded:Fire(Player)

    if Player.Character then
        OnCharacterAdded(Player, Player.Character)
    end

    Player.CharacterAdded:Connect(function(Character)
        OnCharacterAdded(Player, Character)
    end)
    Player.CharacterRemoving:Connect(function(Character)
        OnCharacterRemoving(Player, Character)
    end)
end


local function OnPlayerRemoving(Player: Player)


    PlayerManager.PlayerRemoved:Fire(Player)
end


local function OnHeartbeat(Step: number)
    UpdatePlayersInfo(Step)
end


Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)
RunService.Heartbeat:Connect(OnHeartbeat)


return PlayerManager