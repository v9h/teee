local Colors = {
    ["black"] =	syn and "@@BLACK@@" or "Black",
    ["blue"] = syn and "@@BLUE@@" or "blue",
    ["green"] = syn and "@@GREEN@@" or "green",
    ["cyan"] = syn and "@@CYAN@@" or "cyan",
    ["red"]	= syn and "@@RED@@" or "red",
    ["magenta"] = syn and "@@MAGENTA@@" or "magenta",
    ["brown"] = "@@BROWN@@",
    ["light gray"] = "@@LIGHT_GRAY@@",
    ["Dark gray"] = "@@DARK_GRAY@@",
    ["light blue"] = "@@LIGHT_BLUE@@",
    ["light green"] = "@@LIGHT_GREEN@@",
    ["light cyan"] = "@@LIGHT_CYAN@@",
    ["light red"] = "@@LIGHT_RED@@",
    ["light magenta"] = "@@LIGHT_MAGENTA@@",
    ["yellow"] = syn and "@@YELLOW@@" or "yellow",
    ["white"] = syn and "@@WHITE@@" or "white"
}

local Console = {}
Console.WriteLine = function(Text)
    if syn then
        rconsoleprint(Colors[Console.ForegroundColor] or Colors["white"])
	end
    rconsoleprint(Text .. "\n", Colors[Console.ForegroundColor] or Colors["white"])
end
Console.ReadLine = rconsoleinput
Console.Clear = rconsoleclear
Console.ForegroundColor = "white"

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

if rconsolecreate then
    rconsolecreate()
end

return Console
