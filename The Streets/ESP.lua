-- R15 Support ?? ; might already exist never attempted; yeah like all of the configs are done by the user
-- Image and Text Offset;
-- Fix Boxes, Bars, Arrows
-- Corner 2D BOX
-- Chams
-- Outline Color Text
-- Gradient lines
-- Fix offscreen esp

if ESP and ESP.__CHECK and ESP.Clear then ESP:Clear() end

local ESP = {__CHECK = true}
local Drawn = {}

local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local render_object_exists = function(self)
    return syn and self.__OBJECT_EXISTS or isrenderobj and isrenderobj(self) or false
end

local RenderLoop


function RemoveDrawn(self, Item)
    if self then
        pcall(function()
            self:Remove()
        end)
    end
    pcall(function()
        Drawn[Item] = nil
    end)
end


function WorldToScreen(Position)
    local Vector, OnScreen = Camera:WorldToViewportPoint(Position)
    return Vector2.new(Vector.x, Vector.y), OnScreen, Vector.z
end


function DrawLine(Color, Transparency, From, To)
    local Line = Drawing.new("Line")
    Line.Color = Color or Color3.new(1, 1, 1)
    Line.Transparency = Transparency or 1
    Line.From = From or Vector2.new()
    Line.To = To or Vector2.new()
    Line.Visible = false
    Line.ZIndex = 1
    return Line
end


function DrawGradientLine(Gradient, From, To) -- snapline; trajectory; skeleton; bar
    local Lines = {}
    local Axis = (From.x - To.x) == 0 and "y" or "x"
    local Length = (Axis == "y" and math.abs(From.y - To.y)) or (Axis == "x" and math.abs(From.x - To.x))

    local Gradient_From = Gradient.From
    local Gradient_To = Gradient.To
    
    for i = 1, Length do
        local Percent = i / Length
        local Color = Color3.new(
            Gradient_From.r + (Gradient_To.r - Gradient_From.r) * Percent,
            Gradient_From.g + (Gradient_To.g - Gradient_From.g) * Percent,
            Gradient_From.b + (Gradient_To.b - Gradient_From.b) * Percent
        )

        local Line = DrawLine(Color, Gradient.Transparency, 
            Axis == "y" and Vector2.new(From.x, From.y + (To.y - From.y) * Percent) or Vector2.new(From.x + (To.x - From.x) * Percent, From.y),
            Axis == "y" and Vector2.new(To.x, To.y + (To.y - From.y) * Percent) or Vector2.new(To.x + (To.x - From.x) * Percent, To.y)
        )
        Lines[i] = Line
    end
end


function ESP:Clear()
    RenderLoop:Disconnect()
    for _, v in pairs(Drawn) do
        v:Remove()
    end
    Drawn = nil
    ESP = nil
end


function ESP.Arrow(self)
    assert(self and self:IsA("BasePart"), "missing root or root is not a basepart")
    local Arrow = {}
    Arrow.Type = "Arrow"
    Arrow.Visible = false
    Arrow.Filled = false
    Arrow.Root = self
    Arrow.Offset = 200

    Arrow.self = Drawing.new("Triangle")
    Arrow.self.Thickness = 1
    Arrow.self.Color = Color3.new(1, 1, 1)

    function Arrow:SetColor(Color, Transparency)
        if render_object_exists(Arrow.self) then
            Arrow.self.Color = typeof(Color) == "Color3" and Color or Arrow.self.Color
            Arrow.self.Transparency = typeof(Transparency) == "number" and Transparency or Arrow.self.Transparency
        end
    end

    function Arrow:SetVisible(Visible)
        if render_object_exists(Arrow.self) then
            Arrow.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end


    function Arrow.Remove()
        RemoveDrawn(Arrow.self, Arrow)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Arrow.Remove()
    end)

    Drawn[Arrow] = Arrow
    return Arrow
end


function ESP.Bar(self)
    assert(self and self:IsA("BasePart"), "missing root or root is not a basepart")
    local Bar = {}
    Bar.Type = "Bar"
    Bar.Root = self
    Bar.Value = 0
    Bar.Offset = 0
    Bar.Visible = false
    Bar.Points = {6, 7, 5, 5}
    Bar.Axis = "y"
    
    Bar.self = Drawing.new("Line")
    Bar.self.Color = Color3.new(1, 1, 1)
    Bar.self.Thickness = 1
    Bar.self.ZIndex = 2

    Bar.Outline = Drawing.new("Quad")
    Bar.Outline.Color = Color3.new()
    Bar.Outline.Thickness = 1

    function Bar:SetPoints(a, b, c, d)
        Bar.Points = {typeof(a) == "number" and a or 0, typeof(b) == "number" and b or 0, typeof(c) == "number" and c or 0, typeof(d) == "number" and d or 0}
    end

    function Bar:SetValue(Value:Percentage)
        local Value = typeof(Value) == "number" and Value or 100
        Bar.Value = math.clamp(Value, 0, 100) -- percetange
    end

    function Bar:GetValue()
        return Bar.Value
    end

    function Bar:SetColor(Color, Transparency)
        if render_object_exists(Bar.self) then
            Bar.self.Color = typeof(Color) == "Color3" and Color or Bar.self.Color
            Bar.self.Transparency = typeof(Transparency) == "number" and Transparency or Bar.self.Transparency
        end
    end

    function Bar:SetVisible(Visible)
        if render_object_exists(Bar.self) then
            Bar.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
        if render_object_exists(Bar.Outline) then
            Bar.Outline.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end

    function Bar.Remove()
        RemoveDrawn(Bar.self, Bar)
        RemoveDrawn(Bar.Outline, Bar)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Bar.Remove()
    end)

    Drawn[Bar] = Bar
    return Bar
end


function ESP.Box(self)
    assert(self and self:IsA("BasePart"), "missing root or root is not a BasePart")
    local Box = {}
    Box.Type = "Box"
    Box.Root = self
    Box.Visible = false
    Box.Points = {6, 7, 5, 5}

    Box.self = Drawing.new("Quad")
    Box.self.Color = Color3.new(1, 1, 1)
    Box.self.Thickness = 1
    Box.self.ZIndex = 2

    Box.Outline = Drawing.new("Quad")
    Box.Outline.Color = Color3.new()
    Box.Outline.Thickness = 1

    function Box:SetPoints(a, b, c, d)
        Box.Points = {typeof(a) == "number" and a or 0, typeof(b) == "number" and b or 0, typeof(c) == "number" and c or 0, typeof(d) == "number" and d or 0}
    end

    function Box:SetColor(Color, Transparency)
        if render_object_exists(Box.self) then
            Box.self.Color = typeof(Color) == "Color3" and Color or Box.self.Color
            Box.self.Transparency = typeof(Transparency) == "number" and Transparency or Box.self.Transparency
        end
    end

    function Box:SetVisible(Visible)
        if render_object_exists(Box.self) then
            Box.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
        if render_object_exists(Box.Outline) then
            Box.Outline.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end

    function Box.Remove()
        RemoveDrawn(Box.self, Box)
        RemoveDrawn(Box.Outline, Box)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Box.Remove()
    end)

    Drawn[Box] = Box
    return Box
end


function ESP.CornerBox(self)

end


--setfflag("RenderHighlightPass3", "True")
function ESP.Chams(self, Color, Transparency, Color2, Transparency2)
    local Chams = Instance.new("Highlight")
    Chams.FillColor = Color or Color3.new(1, 1, 1)
    Chams.FillTransparency = Transparency or 0
    Chams.OutlineColor = Color2 or Color3.new()
    Chams.OutlineTransparency = Transparency2 or 1
    Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Chams.Enabled = true
    Chams.Adornee = self
    Chams.Parent = self

    return Chams
end


function ESP.ViewBeam()
    local Line = Instance.new("LineHandleAdornment")
    Line.Name = "Line"
    Line.Length = Length
    Line.Thickness = Thickness
    Line.AlwaysOnTop = true
    Line.Color3 = Color or Color3.new(1, 1, 1)
    Line.Transparency = Transparency or 0
    Line.Visible = true
    Line.Adornee = Part
    Line.Parent = Part
end


function ESP.Skeleton(Points)
    local Skeleton = {}
    Skeleton.Type = "Skeleton"
    Skeleton.__OBJECT_EXISTS = true
    Skeleton.self = Skeleton
    Skeleton.Lines = {} -- head neck, torso, arms up, arm middles, arm hands, leg up, leg middles, leg feet
    Skeleton.Points = {}
    for _ = 1, 15 do
        table.insert(Skeleton.Lines, Drawing.new("Line"))
    end


    function Skeleton:UpdatePoints(Points)
        if typeof(Points) == "table" and #Points >= 15 then
            Skeleton.Points = Points
        else
            return error("Points: Vector3[] expected; amount of points needed [15]")
        end
    end


    function Skeleton:SetColor(Color, Transparency)
        local Color = typeof(Color) == "Color3" and Color or Color3.new(1, 1, 1)
        local Transparency = typeof(Transparency) == "number" and Transparency or 1

        for _, Line in ipairs(Skeleton.Lines) do
            Line.Color = Color
            Line.Transparency = Transparency
        end
    end


    function Skeleton:SetVisible(Visible)
        local Visible = typeof(Visible) == "boolean" and Visible or false

        for _, Line in ipairs(Skeleton.Lines) do
            Line.Visible = Visible
        end
    end


    function Skeleton.Remove()
        Drawn[Skeleton] = nil
        if not Skeleton.__OBJECT_EXISTS then return end
        Skeleton.__OBJECT_EXISTS = false

        for _, Line in ipairs(Skeleton.Lines) do
            Line:Remove()
        end
    end


    Skeleton:SetColor(Color3.new(1, 1, 1), 1)
    Drawn[Skeleton] = Skeleton
    return Skeleton
end


function ESP.Text(self)
    assert(self and self:IsA("BasePart"), "missing root or root is not a basepart")
    local Text = {}
    Text.Type = "Text"
    Text.Root = self
    Text.Offset = Vector2.new()
    Text.Visible = false
    
    Text.self = Drawing.new("Text")
    Text.self.Center = true

    function Text:SetText(String, Font, FontSize, Color, Transparency, Outline)
        if render_object_exists(Text.self) then
            Text.self.Transparency = Transparency or 1
            Text.self.Color = Color or Color3.new(1, 1, 1)
            Text.self.Size = FontSize or 16
            Text.self.Outline = Outline or true
            Text.self.Font = typeof(Font) == "number" and Font or typeof(Font) == "string" and Drawing.Fonts[Font] or 0
            Text.self.Text = String or ""
        end
    end

    function Text:SetVisible(Visible)
        if render_object_exists(Text.self) then
            Text.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end

    function Text.Remove()
        RemoveDrawn(Text.self, Text)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Text.Remove()
    end)

    Text:SetText()

    Drawn[Text] = Text
    return Text
end


function ESP.Image(self)
    assert(self and self:IsA("BasePart"), "missing root or root is not a basepart")
    local Image = {}
    Image.self = Drawing.new("Image")
    Image.Type = "Image"
    Image.Visible = false
    Image.Root = self
    Image.Offset = Vector2.new()

    function Image:SetSize(Size) -- Dynamic?
        Image.self.Size = typeof(Size) == "Vector2" and Size or Vector2.new()
    end

    function Image:SetImage(ImageId)
        pcall(function()
            Image.self.Data = typeof(ImageId) == "string" and game:HttpGet(ImageId) or ""
        end)
    end

    function Image:SetColor(Color, Transparency)
        --Image.self.Color = typeof(Color) == "Color3" and Color or Color3.new(1, 1, 1)
    end

    function Image:SetVisible(Visible)
        if render_object_exists(Image.self) then
            Image.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end

    function Image.Remove()
        RemoveDrawn(Image.self, Image)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Image.Remove()
    end)

    Image:SetImage()

    Drawn[Image] = Image
    return Image
end


function ESP.Snapline(self) -- I liked tracer more but whateva
    assert(self and self:IsA("BasePart"), "missing rootpart")
    local Snapline = {}
    Snapline.Type = "Snapline"
    Snapline.Visible = false
    Snapline.OffScreen = false
    Snapline.Root = self
    
    Snapline.self = Drawing.new("Line")
    Snapline.self.Thickness = Thickness or 1
    Snapline.self.Transparency = 1
    Snapline.self.Color = Color3.new(1, 1, 1)
    Snapline.self.From = Vector2.new(Camera.ViewportSize.x / 2, Camera.ViewportSize.y / 2)

    function Snapline:SetColor(Color, Transparency)
        if render_object_exists(Snapline.self) then
            Snapline.self.Color = typeof(Color) == "Color3" and Color or Snapline.self.Color
            Snapline.self.Transparency = typeof(Transparency) == "number" and Transparency or Snapline.self.Transparency
        end
    end

    function Snapline:SetVisible(Visible)
        if render_object_exists(Snapline.self) then
            Snapline.self.Visible = typeof(Visible) == "boolean" and Visible or false
        end
    end

    function Snapline.Remove()
        RemoveDrawn(Snapline.self, Snapline)
    end

    self.AncestryChanged:Connect(function(_, Parent)
        if Parent then return end
        Snapline.Remove()
    end)

    Drawn[Snapline] = Snapline
    return Snapline
end


function ESP.Trajectory(Points)
    local Trajectory = {}
    Trajectory.Type = "Trajectory"
    Trajectory.__OBJECT_EXISTS = true
    Trajectory.self = Trajectory
    Trajectory.Visible = true
    Trajectory.Points = Points
    Trajectory.Lines = {}

    if typeof(Points) == "table" then
        for _ = 1, #Points do
            table.insert(Trajectory.Lines, Drawing.new("Line"))
        end
    end


    function Trajectory:SetColor(Color, Transparency)
        local Color = typeof(Color) == "Color3" and Color or Color3.new(1, 1, 1)
        local Transparency = typeof(Transparency) == "number" and Transparency or 1

        for _, Line in ipairs(Trajectory.Lines) do
            Line.Color = Color
            Line.Transparency = Transparency
        end
    end


    function Trajectory:SetVisible(Visible)
        local Visible = typeof(Visible) == "boolean" and Visible or false

        for _, Line in ipairs(Trajectory.Lines) do
            Line.Visible = Visible
        end
    end


    function Trajectory.Remove()
        Trajectory.__OBJECT_EXISTS = false
        for _, Line in ipairs(Trajectory.Lines) do
            Line:Remove()
        end
        Drawn[Trajectory] = nil
        Trajectory = nil
    end


    Trajectory:SetColor(Color3.new(1, 1, 1), 1)
    
    Drawn[Trajectory] = Trajectory
    return Trajectory
end


function UpdateDrawnObjects()
    Camera = workspace.CurrentCamera

    if not Camera then return end
    local ScreenSize = Camera.ViewportSize

    for _, v in pairs(Drawn) do
        local self = v.self

        if not render_object_exists(self) then
            Drawn[v] = nil
            continue
        end

        if not v.Visible then
            v:SetVisible(false)
            continue
        end
        
        local Position
        local Outline = v.Outline
        local Type = v.Type

        if Type == "Snapline" then
            local Root = v.Root
            local Position, OnScreen, Depth = WorldToScreen(Root.Position)
            self.Visible = OnScreen

            if not OnScreen and v.OffScreen and Depth < 0 then
                -- make the position be angled towards the Root
                local Angle = math.atan2(Root.Position.y - Camera.CFrame.p.y, Root.Position.x - Camera.CFrame.p.x)
                Position = Vector2.new(Position.x + math.cos(Angle) * Depth, ScreenSize.y)

                self.Visible = true
            end

            if self.Visible then
                self.To = Position
            end
        elseif Type == "Arrow" then
            local Root = v.Root
            local Position, OnScreen = WorldToScreen(Root.Position)
            self.Visible = not OnScreen
            self.Filled = v.Filled

            if Position.x < 0 or Position.y < 0 or Position.x > ScreenSize.x or Position.y > ScreenSize.y then
                local ScreenCenter = ScreenSize / 2

                local Angle = ScreenCenter - Position
                local AngleYaw = math.rad(Angle.y)
    
                local NewPoint = Vector2.new(ScreenCenter.x + v.Offset * math.cos(AngleYaw), ScreenCenter.y + v.Offset * math.sin(AngleYaw))
    
                local Points = {}
                Points[1] = NewPoint - Vector2.new(10, 10)
                Points[2] = NewPoint + Vector2.new(25, 0)
                Points[3] = NewPoint + Vector2.new(-10, 10)
    
                local function RotateTriangle(Points, Rotation)
                    local Center = (Points[1] + Points[2] + Points[3]) / 3
                    local NewPoints = {}
                    for _, Point in ipairs(Points) do
                        local NewPoint = Point - Center
                        NewPoint = Vector2.new(NewPoint.x * math.cos(Rotation) - NewPoint.y * math.sin(Rotation), NewPoint.x * math.sin(Rotation) + NewPoint.y * math.cos(Rotation))
                        NewPoint = NewPoint + Center
                        table.insert(NewPoints, NewPoint)
                    end
                    
                    
                    self.PointA = NewPoints[1]
                    self.PointB = NewPoints[2]
                    self.PointC = NewPoints[3]
                end
    
    
                RotateTriangle(Points, AngleYaw)
            else
                self.Visible = false
                continue
            end
        elseif Type == "Text" then
            local Root = v.Root
            if Root then
                Position, self.Visible = WorldToScreen(Root.Position + Vector3.new(0, v.Offset.y, 0))
            end
            self.Position = Position + Vector2.new(0, -(self.TextBounds.y / 2))
        elseif Type == "Image" then
            local Root = v.Root
            if Root then
                Position, self.Visible = WorldToScreen(Root.Position + Vector3.new(0, v.Offset.y, 0))
            end
            self.Position = (Position - self.Size / 2)
        elseif Type == "Box" then
            local Root = v.Root
            if Root then
                local Origin = Root.Position
                local Position, OnScreen = WorldToScreen(Origin)
                self.Visible = OnScreen
                Outline.Visible = OnScreen
                if OnScreen then
                    local CF = Camera.CFrame
                    
                    local Points = v.Points
                    local Top = WorldToScreen(Origin + 0.5 * Points[1] * CF.UpVector)
                    local Bottom = WorldToScreen(Origin - 0.5 * Points[2] * CF.UpVector)
                    local Left = WorldToScreen(Origin - 0.5 * Points[3] * CF.RightVector)
                    local Right = WorldToScreen(Origin + 0.5 * Points[4] * CF.RightVector)

                    self.PointA = Vector2.new(Left.x, Top.y)
                    self.PointB = Vector2.new(Right.x, Top.y)
                    self.PointC = Vector2.new(Right.x, Bottom.y)
                    self.PointD = Vector2.new(Left.x, Bottom.y)

                    Outline.PointA = self.PointA + Vector2.new(-1, -1)
                    Outline.PointB = self.PointB + Vector2.new(1, -1)
                    Outline.PointC = self.PointC + Vector2.new(1, 1)
                    Outline.PointD = self.PointD + Vector2.new(-1, 1)
                end
            end
        elseif Type == "Bar" then
            local Root = v.Root
            if Root then
                local Origin = Root.Position
                local Position, OnScreen = WorldToScreen(Origin)
                self.Visible = OnScreen
                Outline.Visible = OnScreen
                if OnScreen then
                    local CF = Camera.CFrame

                    local Points = v.Points
                    local Top = WorldToScreen(Origin + 0.5 * Points[1] * CF.UpVector)
                    local Bottom = WorldToScreen(Origin - 0.5 * Points[2] * CF.UpVector)
                    local Left = WorldToScreen(Origin - 0.5 * Points[3] * CF.RightVector)
                    local Right = WorldToScreen(Origin + 0.5 * Points[4] * CF.RightVector)

                    if v.Axis == "y" then
                        local Value = Bottom.y + ((Top.y - Bottom.y) * v:GetValue() / 100)
                        self.To = Vector2.new(Right.x, Value)
                        self.From = Vector2.new(Left.x, Bottom.y)
                        Outline.PointA = Vector2.new(Left.x - 1, Top.y - 1)
                        Outline.PointB = Vector2.new(Left.x + 1, Top.y - 1)
                        Outline.PointC = Vector2.new(Left.x + 1, self.From.y + 1)
                        Outline.PointD = Vector2.new(Left.x - 1, self.From.y + 1)
                    elseif v.Axis == "x" then
                        local Value = Left.x + ((Right.x - Left.x) * v:GetValue() / 100)
                        self.To = Vector2.new(Value, Top.y)
                        self.From = Vector2.new(Left.x, Bottom.y)
                        Outline.PointA = Vector2.new(self.From.x - 1, self.To.y - 1)
                        Outline.PointB = Vector2.new(self.To.x + 1, self.To.y - 1)
                        Outline.PointC = Vector2.new(self.To.x + 1, self.From.y + 1)
                        Outline.PointD = Vector2.new(self.From.x - 1, self.From.y + 1)
                    end
                end
            end
        elseif Type == "Skeleton" then
            local Lines = v.Lines
            local Points = v.Points

            if typeof(Points) == "table" and #Points >= 15 then
                local Position, OnScreen = WorldToScreen(Points[1])
                for _, Line in ipairs(Lines) do Line.Visible = OnScreen end
                if OnScreen then
                    Lines[1].From = Position; Lines[1].To = Position -- Head
                    for i = 2, 3 do -- Neck, Pelvis
                        Lines[i].From = Lines[i - 1].To
                        Lines[i].To = WorldToScreen(Points[i])
                    end

                    -- limbs
                    local function Set(j, Origin)
                        Lines[j].From = Lines[Origin].To
                        Lines[j].To = WorldToScreen(Points[j])
                        for i = 1, 3 do
                            Lines[j + i].From = Lines[(j + i) - 1].To
                            Lines[j + i].To = WorldToScreen(Points[j + i])
                            if j + i == 15 then break end -- last point
                        end
                    end

                    Set(4, 2) -- Left arm
                    Set(7, 2) -- Right arm
                    Set(10, 3) -- Left leg
                    Set(13, 3) -- Right Leg
                end
            end
        elseif Type == "Trajectory" then
            local Lines = v.Lines
            local Points = v.Points

            if typeof(Points) == "table" and #Points > 0 then
                local From = WorldToScreen(Points[1])
                for i, Point in ipairs(Points) do
                    local Position, OnScreen = WorldToScreen(Point)
                    Lines[i].Visible = OnScreen
                    if OnScreen then
                        Lines[i].From = From
                        Lines[i].To = Position
                    end
                    From = Position
                end
            end
        end
    end
end


RenderLoop = RunService.RenderStepped:Connect(UpdateDrawnObjects)

return ESP
