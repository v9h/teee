local Colors = {
    ["Black"] =	"@@BLACK@@" or "Black",
    ["Blue"] = "@@BLUE@@" or "blue",
    ["Green"] = "@@GREEN@@" or "green",
    ["Cyan"] = "@@CYAN@@" or "cyan",
    ["Red"]	= "@@RED@@" or "red",
    ["Magenta"] = "@@MAGENTA@@" or "magenta",
    ["Brown"] = "@@BROWN@@",
    ["Light Gray"] = "@@LIGHT_GRAY@@",
    ["Dark Gray"] = "@@DARK_GRAY@@",
    ["Light Blue"] = "@@LIGHT_BLUE@@",
    ["Light Green"] = "@@LIGHT_GREEN@@",
    ["Light Cyan"] = "@@LIGHT_CYAN@@",
    ["Light Red"] = "@@LIGHT_RED@@",
    ["Light Magenta"] = "@@LIGHT_MAGENTA@@",
    ["Yellow"] = "@@YELLOW@@" or "yellow",
    ["White"] = "@@WHITE@@" or "white"
}

local Console = {}

Console.WriteLine = function(Text)
    if syn then
        rconsoleprint(Colors[Console.ForegroundColor] or Colors["White"])
    end
    rconsoleprint(Text .. "\n", Colors[Console.ForegroundColor])
end
Console.ReadLine = rconsoleinput
Console.Clear = rconsoleclear
Console.ForegroundColor = "Yellow"

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
