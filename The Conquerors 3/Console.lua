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


function Console:Init()
    if rconsolecreate then rconsolecreate() end
    console_set_title("Identification.cc")
end


function Console:Clear()
    rconsoleclear()
end


function Console:Write(Message, Color, NoNewLine)
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


function Console:Read(Message, Color)
    Console:Write(Message, Color, true)
    return rconsoleinput()
end


function Console:ReadLine(...)
    Console:Read(...)
end


function Console:Warn(Message)
    Console:Write(Message, "Yellow")
end


function Console:Error(Message)
    Console:Write(Message, "Red")
end


getgenv().Console = Console


return Console