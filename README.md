# Identification

```lua
local SCRIPT_NAME = "Explorer"
local Loader = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularID/Identification/main/Loader.lua"))()
Loader(SCRIPT_NAME)
```


**Capitalization is important, you don't need to do "Script_Name/Source.lua" that is already included automatically, if you're a plugin/lua dev you use the _G.Import function, example**:

```lua
local CommandHandler = _G.Import("Common/Command Handler")
local CommonFunctions = _G.Import("The Streets/Common Functions")
```
