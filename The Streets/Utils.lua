local Utils = {}


local Raycast = import "Libraries/Raycast"


local wait = task.wait
local request = request or syn and syn.request or http and http.request


local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")


Utils.IsOriginal = game.PlaceId == 455366377 and true
Utils.IsPrison = game.PlaceId == 4669040 and true


function Utils.get_clipboard(): string
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

function Utils.set_clipboard(text: string)
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


function Utils.GetRichTextColor(Text: string, Color: string): string
    if typeof(Color) == "string" then
        return string.format("<font color = '#%s'>", Color) .. Text .. "</font>"
    end
    
    if typeof(Color) == "Color3" then
        local R, G, B = Utils.math_round(Color.R * 255, 2), Utils.math_round(Color.G * 255, 2), Utils.math_round(Color.B * 255, 2)
        return string.format("<font color = 'rgb(%s)'>", R .. G .. B) .. Text .. "</font>"
    end
end


function Utils.GetRoot(Player: Player): Part
    local Character = Player and Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")

    return Humanoid and Humanoid.RootPart
end


function Utils.GetTorso(Player: Player): Part
    local Character = Player and Player.Character
    local Torso = Character and Character:FindFirstChild("Torso")

    return Torso
end


function Utils.UserOwnsAsset(Player: Player, AssetId: string, AssetType: string): boolean
    --https://inventory.roblox.com/docs#!/Inventory/get_v1_users_userId_items_itemType_itemTargetId
    -- AssetType : "GamePass", "Asset", "Badge", "Bundle"
    local UserId = typeof(Player) == "Instance" and Player.UserId

    if UserId and AssetId and AssetType then
        -- Concatenation is faster than the %s pattern
        local Url = "https://inventory.roblox.com/v1/users/" .. UserId .. "/items/" .. AssetType .. "/" .. AssetId
        local Response = request({Url = Url})
        return string.find(Response.Body, "name") and true or false
    end

    return false
end


function Utils.IsBehindAWall(Part: BasePart, Part2: BasePart, Blacklist: table): boolean--, Instance?
    if not Part or not Part2 then return end

    Blacklist = typeof(Blacklist) == "table" and Blacklist or {}
    table.insert(Blacklist, workspace.CurrentCamera)
    table.insert(Blacklist, Players.LocalPlayer.Character)

    local CF = CFrame.new(Part.Position, Part2.Position)
    local Hit = Raycast.new(CF.Position, CF.LookVector * (Part.Position - Part2.Position).Magnitude, Blacklist)

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


function Utils.GetFolders(Directory: string): table
    local Folders = {}
    local Names = {}

    local function Recurse(Directory: string)
        for _, File in ipairs(listfiles(Directory)) do
            if isfolder(File) then
                table.insert(Folders, File)
                table.insert(Names, string.match(File, "[^/\\]+$"))
            end
        end
    end

    Recurse(Directory)
    return {Folders = Folders, Names = Names}
end


function Utils.GetFiles(Directory: string): table
    local Files = {}
    local Names = {}

    local function Recurse(Directory: string)
        for _, File in ipairs(listfiles(Directory)) do
            if isfile(File) then
                table.insert(Files, File)
                table.insert(Names, string.match(File, "[^/\\]+$"))
            elseif isfolder(File) then
                Recurse(File)
            end
        end
    end

    Recurse(Directory)
    return {Files = Files, Names = Names}
end


function Utils.math_round(Number: number, Scale: number): number
    assert(typeof(Number) == "number", "number expected for arguments #1, got '" .. typeof(Number) .. "'")
    return tonumber(string.format("%." .. (typeof(Scale) == "number" and Scale or 2) .. "f", Number))
end


function Utils.table_clone(Original: table): table
    local Clone = {}

    for k, v in pairs(Original) do
        if typeof(v) == "table" then
            v = Utils.table_clone(v)
        end
        Clone[k] = v
    end

    return Clone
end


return Utils
