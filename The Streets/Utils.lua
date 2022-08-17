local Utils = {}


local CoreGui = game:GetService("CoreGui")


function get_clipboard(): string
    while not iswindowactive() do wait() end

    local text_box = Instance.new("TextBox")
    text_box.Parent = CoreGui

    text_box:CaptureFocus()

    keypress(0x11)
    keypress(0x44)

    wait()

    keyrelease(0x11)
    keyrelease(0x44)

    text_box:ReleaseFocus()

    local clipboard = text_box.Text
    text_box:Destroy()

    return clipboard
end

function set_clipboard(text: string)
    while not iswindowactive() do wait() end

    local text_box = Instance.new("TextBox")
    text_box.Parent = CoreGui

    text_box.Text = text
    text_box:CaptureFocus()
    keypress(0x11)
    keypress(0x43)

    wait()

    keyrelease(0x11)
    keyrelease(0x43)

    text_box:ReleaseFocus()
    text_box:Destroy()
end


function Utils.GetRichTextColor(Text: string, Color: string): string
    if typeof(Color) == "string" then
        return string.format("<font color = '#%s'>", Color) .. Text .. "</font>"
    end
    
    if typeof(Color) == "Color3" then
        local R, G, B = Utils.math_round(Color.R * 255, 2), Utils.math_round(Color.G * 255, 2), Utils.math_round(Color.B * 255, 2)
        return string.format("<font color = 'rgb(%s)'>", R .. G .. B) .. Text .. "</font>"
    end
end

function Utils.math_round(Number: number, Scale: number): number
    return tonumber(string.format("%." .. Scale .. "f", Number))
end


function Utils.table_clone(Original: table): table
    local Clone = {}
    
    for k, v in pairs(Original) do
        if typeof(v) == "table" then
            v = table_clone(v)
        end
        Clone[k] = v
    end
    
    return Clone
end


return Utils