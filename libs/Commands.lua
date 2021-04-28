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

return Commands;
