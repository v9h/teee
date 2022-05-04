# ponyhook-dev
Development of ponyhook.cc

# Loader.lua
```lua
local AuthToken = [[]]
local ScriptName = "The Streets" -- Script Name here; ex : The Streets


local request = request or syn and syn.request


local FilePath = string.gsub(ScriptName, "%s", "%%20")
local RepositoryPath = "https://" .. AuthToken .. "@raw.githubusercontent.com/RegularID/ponyhook-dev/main/" .. FilePath .. "/"

function Import(Name)
    local Name = string.gsub(Name, "%s", "%%20") -- Replacing Spaces with %20's
    local Url = RepositoryPath .. Name .. ".lua"
    local Response = request({Url = Url})
    return loadstring(Response.Body)()
end

getgenv().Import = Import
Import("Source")
```
