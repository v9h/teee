local Commands = {}

function Commands.Add(Name, Function)
    local Removed = false
    local Command = {}
    Command.Name = Name
    Command.Description = ""
    table.insert(Commands, Command);

    function Command:Descript(String)
        if Removed then
            error("attempt to call a nil value");
        else
            Command.Description = String
        end
    end

    function Command:Run(...)
        local Args = {...}
        if Removed then
            error("attempt to call a nil value");
        else
            Function(Args);
        end
    end

    function Command:Remove()
        Removed = true
    end

    return Command;
end

return Commands;
