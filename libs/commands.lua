local Commands = {}

function Commands.add(Name, Function)
    local Removed = false
    local Command = {}
    Command.Name = Name
    Command.Description = ""
    table.insert(Commands, Command);

    function Command:descript(String)
        if Removed then
            error("attempt to call a nil value");
        else
            Command.Description = String
        end
    end

    function Command:run(...)
        local Args = {...}
        if Removed then
            error("attempt to call a nil value");
        else
            Function(Args);
        end
    end

    function Command:remove()
        Removed = true
    end

    return Command;
end

return Commands;
