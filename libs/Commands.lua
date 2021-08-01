local Commands = {}

local string_split = string.split
local string_lower = string.lower
local table_insert = table.insert
local table_remove = table.remove

function Commands.Add(Name, Aliases, Description, Function)
    local Command = {}
    Command.Name = Name
    Command.Aliases = Aliases or {}
    Command.Description = Description or ""
    table_insert(Commands, Command)

    function Command:Run(...)
        Function(...)
    end

    return Command
end
        
function Commands.Check(Name, Prefix)
    local Arguments = string_split(Name, " ")
    local Comparison = string_lower(table_remove(Arguments, 1))
    Prefix = Prefix and Prefix or ""

    for _, Command in ipairs(Commands) do
        local Command_Name = Command.Name
        if Prefix .. string_lower(Command_Name) == Comparison then
            pcall(function()
                Command:Run(Arguments)
                return Command_Name
            end)
        end
        for _, Alias in ipairs(Command.Aliases) do
            if Prefix .. string_lower(Alias) == Comparison then
                pcall(function()
                    Command:Run(Arguments)
                    return Command_Name, Alias
                end)
            end
        end
    end
    return "Error"
end

return Commands
