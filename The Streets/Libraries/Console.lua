local Console = {}
Console.ForegroundColor = "Light Gray"

local console_set_title = rconsolename or rconsolesettitle


local Colors = {
    --["Black"] = syn and "@@BLACK@@" or "Black",
    ["Blue"] = syn and "@@BLUE@@" or "blue",
    ["Green"] = syn and "@@GREEN@@" or "green",
    ["Cyan"] = syn and "@@CYAN@@" or "cyan",
    ["Red"]	= syn and "@@RED@@" or "red",
    ["Magenta"] = syn and "@@MAGENTA@@" or "magenta",
    ["Brown"] = syn and "@@BROWN@@",
    ["Light Gray"] = syn and "@@LIGHT_GRAY@@",
    ["Dark Gray"] = syn and "@@DARK_GRAY@@",
    ["Light Blue"] = syn and "@@LIGHT_BLUE@@",
    ["Light Green"] = syn and "@@LIGHT_GREEN@@",
    ["Light Cyan"] = syn and "@@LIGHT_CYAN@@",
    ["Light Red"] = syn and "@@LIGHT_RED@@",
    ["Light Magenta"] = syn and "@@LIGHT_MAGENTA@@",
    ["Yellow"] = syn and "@@YELLOW@@" or "yellow",
    ["White"] = syn and "@@WHITE@@" or "white"
}


function Console:Init()
    if rconsolecreate then rconsolecreate() end
    console_set_title("ponyhook.cc")
end


function Console:Clear()
    rconsoleclear()
end


function Console:Write(Message: string, Color: string, NoNewLine: boolean)
    if syn then
        if Color then
            rconsoleprint(Colors[Color])
        else
            rconsoleprint(Colors[Console.ForegroundColor])
        end
    end

    local Concatenation = NoNewLine and "" or "\n"
    local Bold = "b"
    local Underline = "u"
    rconsoleprint(tostring(Message) .. Concatenation, Colors[Color] or Colors[Console.ForegroundColor] or Colors.White)
end


function Console:WriteLine(...)
    Console:Write(...)
end


function Console:Read(Message: string, Color: string)
    Console:Write(Message, Color, true)
    return rconsoleinput()
end


function Console:ReadLine(...)
    Console:Read(...)
end


return Console
