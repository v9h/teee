# identification-dev
Development of Identification.cc

# Loader.lua
```lua
local AuthToken = [[]] -- Personal Access Token
local ScriptName = "The Streets" -- Script Name here; ex : The Streets


local request = request or syn and syn.request


local FilePath = string.gsub(ScriptName, "%s", "%%20")
local Url = "https://" .. AuthToken .. "@raw.githubusercontent.com/RegularID/identification-dev/main/" .. FilePath .. "/Source.lua"

local Response = request({Url = Url})

getgenv().Import = function(Name)
    local Url = "https://" .. AuthToken .. "@raw.githubusercontent.com/RegularID/identification-dev/main/" .. FilePath .. "/" .. Name .. ".lua"
    local Reponse = request({Url = Url})
    return loadstring(Response.Body)()
end

loadstring(Response.Body)()
```

![image](https://user-images.githubusercontent.com/69537751/160294247-419c071c-dcfd-4f13-a557-3616b0ba8205.png)
