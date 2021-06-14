local loadstring = loadstring

function CaseSwitch(Paramater, Dictionary, ...)
    local Case = Dictionary[Paramater]
    if Case then
        return Case(...)
    end
end

function LoadString(String)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Roblox-Games/main/" .. String))()
end

CaseSwitch(game.PlaceId, {
    [5872075530] = function()
        LoadString("Anarchy-Reborn.lua")
    end,
    [2158075212] = function()
        LoadString("Mining%20Tycoon.lua")
    end,
    [455366377] = function()
        return
    end,
    [4669040] = function()
        return
    end,
    [155615604] = function()
        return
    end
})
