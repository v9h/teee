local Network = {}

local Enums = import "Enums"
local Utils = import "Utils"
local PlayerManager = import "PlayerManager"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = PlayerManager.LocalPlayer


function Network:Send(Type: Enum_Item, ...)
    local Arguments = {...}

    local Backpack = LocalPlayer.Backpack

    if Utils.IsOriginal then
        local Stank = Backpack.Stank
        --local Input = Backpack.Input

        if Type == Enums.NETWORK.SET_GROUP then
            local GroupId = Arguments[1]
            local Tag = Arguments[2]

            if Tag then
                Stank:FireServer("pick", {
                    Name = GroupId,
                    TextLabel = {Text = Tag} -- max char count 100
                })
            else
                -- the normal one
            end
        elseif Type == Enums.NETWORK.LEAVE_GROUP then
            Stank:FireServer("leave")
        elseif Type == Enums.NETWORK.SET_HAT then
            local Hat = table.remove(Arguments, 1)
            assert(typeof(Hat) == "string", "string expected for #arguments 1, got '" .. typeof(Hat) .. "'")

            Stank:FireServer("rep", {
                typ = {Value = Hat}
            })
        elseif Type == Enums.NETWORK.REMOVE_HAT then
            Stank:FireServer("ren")
        elseif Type == Enums.NETWORK.SET_HAT_COLOR then
            local Color = table.remove(Arguments, 1)
            assert(typeof(Color) == "Color3", "Color3 expected for #arguments 1, got '" .. typeof(Color) .. "'")

            Stank:FireServer("color", {BackgroundColor3 = Color})
        end
    else

    end

    if Type == Enums.NETWORK.CHAT then
        local Message = table.remove(Arguments, 1)
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "All")
        return true
    elseif Type == Enums.NETWORK.ATTACK then
        if Utils.IsOriginal then
            local MouseType = Arguments[1]
            local Hit = Arguments[2]
            local IsShifting = Arguments[3]
            local Velocity = Arguments[4]

            MouseType = MouseType == 1 and "ml" or MouseType == 2 and "moff1"

            assert(MouseType == "ml" or MouseType == "moff1", "invalid argument, for #arguments 1, number <1, 2> expected, got '" .. typeof(MouseType) .. "'")
            assert(typeof(Hit) == "CFrame", "invalid argument, for #arguments 2, type \"CFrame\" expected, got '" .. typeof(Hit) .. "'")
            IsShifting = typeof(IsShifting) == "boolean" and IsShifting or false
            Velocity = typeof(Velocity) == "number" and Velocity or math.random(0, 16)

            Backpack.Input:FireServer(MouseType and "ml" or "moff", {
                mousehit = Hit,
                shift = IsShifting,
                velo = Velocity
            })

            return true
        else
            local Tool = Arguments[1]
            assert(typeof(Tool) == "Instance" and Tool:IsA("Tool"), "invalid argument, for #arguments1, 'Tool' expected, got '" .. typeof(Tool) .. "'")

            local Remote = Tool:FindFirstChild("Fire")
            if Remote:IsA("RemoteEvent") then
                local Hit = Arguments[2]
                assert(typeof(Hit) == "CFrame", "invalid argument, for #arguments 2, type \"CFrame\" expected, got '" .. typeof(Hit) .. "'")
                Remote:FireServer(Hit)
                return true
            end

            local Animation = Tool:FindFirstChild("Finish")
            if Animation:IsA("Animation") then
                local IsShifting = Arguments[2]
                IsShifting = typeof(IsShifting) == "boolean" and IsShifting or false
                Backpack.ServerTraits.Touch1:FireServer(Tool, 0, IsShifting, 0)
            end
        end
    elseif Type == Enums.NETWORK.DRAG then
        if Utils.IsOriginal then
            Backpack.Input:FireServer("e", {})
        else
            Backpack.ServerTraits.Drag:FireServer(true)
        end
    elseif Type == Enums.NETWORK.STOMP then
        if Utils.IsOriginal then
            Backpack.Input:FireServer("e", {})
        else
            local Tool = table.remove(Arguments, 1)
            -- assert(typeof(Animation) == "Instance" and Animation:IsA("Animation"), "")
            assert(typeof(Tool) == "Instance" and Tool:IsA("Tool"), "Tool expected for #arguments 1, got '" .. typeof(Tool) .. "'")
            Backpack.ServerTraits.Finish:FireServer(Tool)

            -- Backpack.ServerTraits.Finish:FireServer({
            --     Finish = Animation
            -- })
        end
    elseif Type == Enums.NETWORK.PLAY_BOOMBOX then
        local Tool = Arguments[1]
        local Audio = Arguments[2]
        
        assert(typeof(Tool == "Instance" and Tool:IsA("Tool")), "Tool expected for #arguments 1, got '" .. typeof(Tool) .. "'")
        assert(Tool.Name == "BoomBox", "Boombox expected for #arguments 1, got '" .. Tool.Name .. "'")

        Tool.RemoteEvent:FireServer("play", Audio)
    elseif Type == Enums.NETWORK.STOP_BOOMBOX then
        local Tool = table.remove(Arguments, 1)

        assert(typeof(Tool == "Instance" and Tool:IsA("Tool")), "Tool expected for #arguments 1, got '" .. typeof(Tool) .. "'")
        assert(Tool.Name == "BoomBox", "Boombox expected for #arguments 1, got '" .. Tool.Name .. "'")

        Tool.RemoteEvent:FireServer("stop")
    elseif Type == Enums.NETWORK.SET_SIGN_IMAGE then
    elseif Type == Enums.NETWORK.SPRAY_IMAGE then
        local Tool = table.remove(Arguments, 1)

        assert(typeof(Tool == "Instance" and Tool:IsA("Tool")), "Tool expected for #arguments 1, got '" .. typeof(Tool) .. "'")
        assert(Tool.Name == "Spray", "Spray expected for #arguments 1, got '" .. Tool.Name .. "'")
    elseif Type == Enums.NETWORK.INTERACTABLE_LOCK then
        local Interactable = table.remove(Arguments, 1)
        assert(typeof(Interactable) == "Instance" and Interactable:IsA("Model"), "")
        
        if Interactable.Name == "Door" then
            Interactable.Lock.ClickDetector.RemoteEvent:FireServer()
        --elseif Interactable.Name == "Window" then
           --Interactable.Move.Lock.ClickDetector.RemoteEvent:FireServer()
        end
    elseif Type == Enums.NETWORK.INTERACTABLE_CLICK then
        local Interactable = table.remove(Arguments, 1)
        assert(typeof(Interactable) == "Instance" and Interactable:IsA("Model"), "")
        
        if Interactable.Name == "Door" then
            Interactable.Click.ClickDetector.RemoteEvent:FireServer()
        elseif Interactable.Name == "Window" then
           Interactable.Move.Click.ClickDetector.RemoteEvent:FireServer()
        end
    elseif Type == Enums.NETWORK.INTERACTABLE_KNOCK then
        local Interactable = table.remove(Arguments, 1)
        assert(typeof(Interactable) == "Instance" and Interactable:IsA("Model"), "")

        if Interactable.Name == "Door" then
            Interactable.Knock.ClickDetector.RemoteEvent:FireServer()
        --elseif Interactable.Name == "Window" then
           --Interactable.Mod.Knock.ClickDetector.RemoteEvent:FireServer()
        end
    end
end


function Network:Add(Type: Enum_Item, Callback: any): RBXScriptConnection
    if Type == Enums.NETWORK.CHAT then
        return ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnNewMessage").OnClientEvent:Connect(Callback)
    elseif Type == Enums.NETWORK.TAG_REPLICATE then
        ReplicatedStorage:WaitForChild("TagReplicate").OnClientEvent:Connect(Callback)
    end
end


return Network
