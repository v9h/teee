if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().self = {}

local Destroy = game.Destroy

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local floor = math.floor
local ServerStatsItem = Stats.Network.ServerStatsItem
local SendKbps = ServerStatsItem["Send kBps"]
local ReceiveKbps = ServerStatsItem["Receive kBps"]
local Ping = Stats.PerformanceStats.Ping

self.GetNetworkInfo = function()
    local IncomingKbps = "Incoming kBps: " .. floor(SendKbps:GetValue() * 1000)
    local OutgoingKbps = "Outgoing kBps: " .. floor(ReceiveKbps:GetValue() * 1000)
    local Latency = "Latency: " .. floor(Ping:GetValue()) .. "ms"
    local Tick = "Tick: " .. floor(tick())
    return IncomingKbps, OutgoingKbps, Latency, Tick
end

function self.GetClipboard()
    repeat
        wait()
    until isrbxactive()
    
    local Clipboard
    local TextBox = Instance.new("TextBox")
    
    TextBox.Parent = CoreGui
    TextBox:CaptureFocus()
    keypress(0xA2)
    keypress(0x56)
    keyrelease(0x56)
    keyrelease(0xA2)
    wait()
    Clipboard = TextBox.Text
    Destroy(TextBox)
    
    return Clipboard
end

self.getclipboard = self.GetClipboard

self.Players = Players
self.Player = Players.LocalPlayer
self.Character = Player.Character
