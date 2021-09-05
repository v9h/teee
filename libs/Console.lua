local Console = {}
Console.Colors = {
    --["Black"] = syn and "@@BLACK@@" or "Black",
    ["Blue"] = syn and "@@BLUE@@" or "blue",
    ["Green"] = syn and "@@GREEN@@" or "green",
    ["Cyan"] = syn and "@@CYAN@@" or "cyan",
    ["Red"]	= syn and "@@RED@@" or "red",
    ["Magenta"] = syn and "@@MAGENTA@@" or "magenta",
    ["Brown"] = "@@BROWN@@",
    ["Light Gray"] = "@@LIGHT_GRAY@@",
    ["Dark Gray"] = "@@DARK_GRAY@@",
    ["Light Blue"] = "@@LIGHT_BLUE@@",
    ["Light Green"] = "@@LIGHT_GREEN@@",
    ["Light Cyan"] = "@@LIGHT_CYAN@@",
    ["Light Red"] = "@@LIGHT_RED@@",
    ["Light Magenta"] = "@@LIGHT_MAGENTA@@",
    ["Yellow"] = syn and "@@YELLOW@@" or "yellow",
    ["White"] = syn and "@@WHITE@@" or "white"
}
Console.WriteLine = function(Text)
    if syn then
        rconsoleprint(Console.Colors[Console.ForegroundColor] or Console.Colors["White"])
    end
    rconsoleprint(Text .. "\n", Console.Colors[Console.ForegroundColor] or Console.Colors["White"])
end
Console.ReadLine = function(Text)
    if Text then
        if syn then
            rconsoleprint(Console.Colors[Console.ForegroundColor] or Console.Colors["White"])
        end
        rconsoleprint(Text, Console.Colors[Console.ForegroundColor] or Console.Colors["White"])
    end
    rconsoleinput()
end
Console.Clear = rconsoleclear
Console.ForegroundColor = "White"

local Console = setmetatable(Console, {
    __newindex = function (Table, Key, Value)
        if Key == "Title" then
            if syn then
                rconsolename(Value)
            else
                rconsolesettitle(Value)
            end
        end
    end
})

return Console
