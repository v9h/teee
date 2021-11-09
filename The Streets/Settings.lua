local WEBSOCKET_SERVER = "wss://identification.glitch.me/" -- Thanks to glitch for free hosting
local Assets = {
    "rbxassetid://363364837",
    "rbxassetid://526821274",
    "rbxassetid://526812070",
    "rbxassetid://376851671",
    "rbxassetid://526815097",
    "rbxassetid://526813828",
    "rbxassetid://178130996",
    "rbxassetid://526814775",
    "rbxassetid://503259904",
    "rbxassetid://889968874",
    "rbxassetid://229339207",
    "rbxassetid://889390949",
    "rbxassetid://376653421",
    "rbxassetid://458506542",
    "rbxassetid://327855546",
    "rbxassetid://215384594",
    "rbxassetid://242203091"
}


local wait = task.wait
local websocket_connect = syn and syn.websocket.connect or WebSocket and WebSocket.connect


local Marketplace = game:GetService("MarketplaceService")
local ContentProvider = game:GetService("ContentProvider")


local UpdateStatus = Instance.new("BindableEvent")


local Settings = {
    GameInfo = {
        Name = "The Streets",
        Places = {
            [455366377] = {
                Version = 1499
            },
            [4669040] = {
                Version = 215
            }
        }
    },
    Preload = {
        Steps = 7,
        Initialize = function()
            UpdateStatus:Fire("Waiting for game to load...", 1)
            if not game:IsLoaded() then game.Loaded:Wait() end
            UpdateStatus:Fire("Loading into game \"" .. "The Streets" .. " \"", 2)
            --wait(1)
            UpdateStatus:Fire("Attempting to connect to server...", 3)
            local Connected = pcall(function()
                websocket_connect(WEBSOCKET_SERVER, {
                    headers = {
                        ["user-agent"] = "Mozilla",
                    }
                })
            end)
            UpdateStatus:Fire(Connected and "Connected to the server" or "Failed to connect to server", 4)
            --if not Connected then return end -- I don't actually care about this that much right now
            --wait(1)
            local LoadedContent = 0
            UpdateStatus:Fire("Preloading content...", 5)
            ContentProvider:PreloadAsync(Assets, function()
                LoadedContent += 1
                UpdateStatus:Fire("Preloading content...(" .. #Assets .. "/" .. LoadedContent .. ")", 6)
            end)
            UpdateStatus:Fire(true, 7)
        end,
        OnStatusChanged = UpdateStatus.Event
    }
}


return Settings
