local Settings = {
    Ignore = false,
    CallerCheck = false,
    ThreadCheck = false,
    
    Index = {
        FireServer = true,
        OnClientEvent = true,
        InvokeServer = true,
        OnClientInvoke = true,
        Fire = true,
        OnEvent = true,
        Invoke = true,
        OnInvoke = true,
        HTTP = true
    },
    
    Menu = {}
}


local HttpService = game:GetService("HttpService")


function Settings:Save()
    local Directory = "Identification/Tools/Remote Spy/Settings.cfg"
    writefile(Directory, HttpService:JSONEncode(
        Settings.Menu
    ))
end


function Settings:Load()
    local Directory = "Identification/Tools/Remote Spy/Settings.cfg"
    if not isfile(Directory) then
        return Settings:Save()
    end
    
    local Menu = HttpService:JSONDecode(readfile(Directory))
    if typeof(Menu) ~= "table" then return end
    
    for Key, Value in pairs(Menu) do
        Settings.Menu[Key] = Value
    end
end


return Settings