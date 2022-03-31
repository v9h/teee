local Renderer = {}


function Renderer:WorldToScreen(Point)

end


function Renderer:Bind()

end


function Renderer:Trajectory()

end


function Renderer:Highlight(Model)
    if game:GetFastFlag("RenderHighlightPass3") then
        
    else
        setfflag("RenderHighlightPass3", "TRUE")
    end
end



return Renderer