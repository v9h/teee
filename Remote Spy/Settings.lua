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


local function CreateDirectory()
    local Directory = "ponyhook/Tools/Remote Spy/"
    if not isfolder(Directory) then makefolder(Directory) end
end


function Settings:Save()
    CreateDirectory()
    local Directory = "ponyhook/Tools/Remote Spy/Settings.cfg"
    writefile(Directory, HttpService:JSONEncode(
        Settings.Menu
    ))
end


function Settings:Load()
    CreateDirectory()
    local Directory = "ponyhook/Tools/Remote Spy/Settings.cfg"
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
