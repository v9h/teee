local Commands = {}

function Commands.Add(Name, Aliases, Description, Function)
    local Command = {}
    Command.Name = Name
    Command.Aliases = Aliases or {}
    Command.Description = Description or ""
    table.insert(Commands, Command);

    function Command:Run(...)
        Function(...);
    end

    return Command;
end
        
function Commands.Check(Name, Prefix)
    local Args = string.split(Name, " ")
    local MessageCmd = table.remove(Args, 1)
    Prefix = Prefix and Prefix or ""

    for _, Command in ipairs(Commands) do
        if Prefix .. string.lower(Command.Name) == string.lower(MessageCmd) then
            local _, Error = pcall(function()
                Command:Run(Args)
                return Command.Name
            end)
            if Error then
                return "Error"
            end
        end
        for _, Alias in ipairs(Command.Aliases) do
            if Prefix .. string.lower(Alias) == string.lower(MessageCmd) then
                local _, Error = pcall(function()
                    Command:Run(Args)
                    return Command.Name, Alias
                end)
                if Error then
                    return "Error"
                end
            end
        end
    end
end

return Commands;
