-- // Fix notification tweening
-- // Tool Tips?
-- // Menu Effects (OnHover, OnClick)


local Menu = {}
local Tabs = {}
local Items = {}
local EventObjects = {} -- For updating items on menu property change
local Notifications = {}

local Scaling = {True = false, Origin = nil, Size = nil}
local Dragging = {Gui = nil, True = false}
local Draggables = {}

local HotkeyRemoveKey = Enum.KeyCode.LeftControl
local Selected = {
    Frame = nil,
    Item = nil,
    Offset = UDim2.new(),
    Follow = false
}
local SelectedTabLines = {}


local wait = task.wait
local delay = task.delay
local spawn = task.spawn
local protect_gui = function(Gui, Parent)
    if syn and syn.protect_gui then
        syn.protect_gui(Gui)
        Gui.Parent = Parent
    elseif gethui then
        Gui.Parent = gethui()
    else
        Gui.Parent = Parent
    end
end


local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")


local __Menu = {}
setmetatable(Menu, {
    __index = function(self, Key) return __Menu[Key] end,
    __newindex = function(self, Key, Value)
        __Menu[Key] = Value
        
        if Key == "Hue" or Key == "ScreenSize" then return end

        for _, Object in pairs(EventObjects) do Object:Update() end
        for _, Notification in pairs(Notifications) do Notification:Update() end
    end
})


Menu.Accent = Color3.fromHex("#8F30A7")
Menu.Font = Enum.Font.SourceSans
Menu.Transparency = false
Menu.BackgroundIsTransparent = true
Menu.IsVisible = false
Menu.Rounded = false
Menu.Dim = false
Menu.Hue = 0
Menu.ItemColor = Color3.fromRGB(30, 30, 30)
Menu.BorderColor = Color3.fromRGB(45, 45, 45)
Menu.ScreenSize = Vector2.new()
Menu.MinSize = Vector2.new(300, 400)
Menu.MaxSize = Vector2.new(800, 750)


function AddEventListener(self, Update)
    table.insert(EventObjects, {
        self = self,
        Update = Update
    })
end


function CreateCorner(Parent, Pixels)
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "Corner"
    UICorner.Parent = Parent
    return UICorner
end


function CreateStroke(Parent, Color, Thickness, Transparency)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "Stroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
    UIStroke.Color = Color or Color3.new()
    UIStroke.Thickness = Thickness or 1
    UIStroke.Transparency = Transparency or 0
    UIStroke.Enabled = true
    UIStroke.Parent = Parent
    return UIStroke
end 


function CreateLine(Parent, Size, Position, Color)
    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.BackgroundColor3 = typeof(Color) == "Color3" and Color or Menu.Accent
    Line.BorderSizePixel = 0
    Line.Size = Size or UDim2.new(1, 0, 0, 1)
    Line.Position = Position or UDim2.new()
    Line.Parent = Parent

    if Line.BackgroundColor3 == Menu.Accent then
        AddEventListener(Line, function() Line.BackgroundColor3 = Menu.Accent end)
    end
    return Line
end


function CreateLabel(Parent:Instance, Name:string, Text:string, Size:UDim2, Position:UDim2)
    local Label = Instance.new("TextLabel")
    Label.Name = Name
    Label.BackgroundTransparency = 1
    Label.Size = Size or UDim2.new(1, 0, 0, 15)
    Label.Position = Position or UDim2.new()
    Label.Font = Enum.Font.SourceSans
    Label.Text = Text or ""
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Parent
    return Label
end


function SetDraggable(self)
    table.insert(Draggables, self)
    local DragOrigin
    local GuiOrigin

    self.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            for _, v in ipairs(Draggables) do
                v.ZIndex = 1
            end
            self.ZIndex = 2

            Dragging = {Gui = self, True = true}
            DragOrigin = Vector2.new(Input.Position.X, Input.Position.Y)
            GuiOrigin = self.Position
        end
    end)

    UserInput.InputChanged:Connect(function(Input, Process)
        if Dragging.Gui ~= self then return end
        if not (UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
            Dragging = {Gui = nil, True = false}
            return
        end
        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - DragOrigin
            local ScreenSize = Menu.ScreenSize

            local ScaleX = (ScreenSize.X * GuiOrigin.X.Scale)
            local ScaleY = (ScreenSize.Y * GuiOrigin.Y.Scale)
            local OffsetX = math.clamp(GuiOrigin.X.Offset + Delta.X + ScaleX,   0, ScreenSize.X - self.AbsoluteSize.X)
            local OffsetY = math.clamp(GuiOrigin.Y.Offset + Delta.Y + ScaleY, -36, ScreenSize.Y - self.AbsoluteSize.Y)
            
            local Position = UDim2.fromOffset(OffsetX, OffsetY) -- Yeah we don't keep Scale but if some math god hits me up I will fix it
			self.Position = Position
        end
    end)
end


Menu.Screen = Instance.new("ScreenGui")
Menu.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protect_gui(Menu.Screen, CoreGui)
Menu.ScreenSize = Menu.Screen.AbsoluteSize


local Menu_Frame = Instance.new("Frame")
local MenuScaler_Button = Instance.new("TextButton")
local Title_Label = Instance.new("TextLabel")
local TabHandler_Frame = Instance.new("Frame")
local TabIndex_Frame = Instance.new("Frame")
local Tabs_Frame = Instance.new("Frame")

local Notifications_Frame = Instance.new("Frame")
local MenuDim_Frame = Instance.new("Frame")
local ToolTip = Instance.new("TextLabel")
local Modal = Instance.new("TextButton")

Menu_Frame.Name = "Menu"
Menu_Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Menu_Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
Menu_Frame.BorderMode = Enum.BorderMode.Inset
Menu_Frame.Position = UDim2.new(0.5, -250, 0.5, -275)
Menu_Frame.Size = UDim2.new(0, 500, 0, 550)
Menu_Frame.Visible = false
Menu_Frame.Parent = Menu.Screen
CreateStroke(Menu_Frame, Color3.new(), 2)
CreateLine(Menu_Frame, UDim2.new(1, -8, 0, 1), UDim2.new(0, 4, 0, 15))
SetDraggable(Menu_Frame)

MenuScaler_Button.Name = "MenuScaler"
MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MenuScaler_Button.BorderColor3 = Color3.fromRGB(40, 40, 40)
MenuScaler_Button.BorderSizePixel = 0
MenuScaler_Button.Position = UDim2.new(1, -15, 1, -15)
MenuScaler_Button.Size = UDim2.fromOffset(15, 15)
MenuScaler_Button.Font = Enum.Font.SourceSans
MenuScaler_Button.Text = ""
MenuScaler_Button.TextColor3 = Color3.new(1, 1, 1)
MenuScaler_Button.TextSize = 14
MenuScaler_Button.AutoButtonColor = false
MenuScaler_Button.Parent = Menu_Frame
MenuScaler_Button.InputBegan:Connect(function(Input, Process)
    if Process then return end
    if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
        UpdateSelected()
        Scaling = {
            True = true,
            Origin = Vector2.new(Input.Position.X, Input.Position.Y),
            Size = Menu_Frame.AbsoluteSize - Vector2.new(0, 36)
        }
    end
end)
MenuScaler_Button.InputEnded:Connect(function(Input, Process)
    if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
        UpdateSelected()
        Scaling = {
            True = false,
            Origin = nil,
            Size = nil
        }
    end
end)


Title_Label.Name = "Title"
Title_Label.BackgroundTransparency = 1
Title_Label.Position = UDim2.new(0, 5, 0, 0)
Title_Label.Size = UDim2.new(1, -10, 0, 15)
Title_Label.Font = Enum.Font.SourceSans
Title_Label.Text = ""
Title_Label.TextColor3 = Color3.new(1, 1, 1)
Title_Label.TextSize = 14
Title_Label.TextXAlignment = Enum.TextXAlignment.Left
Title_Label.RichText = true
Title_Label.Parent = Menu_Frame

TabHandler_Frame.Name = "TabHandler"
TabHandler_Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabHandler_Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
TabHandler_Frame.BorderMode = Enum.BorderMode.Inset
TabHandler_Frame.Position = UDim2.new(0, 4, 0, 19)
TabHandler_Frame.Size = UDim2.new(1, -8, 1, -25)
TabHandler_Frame.Parent = Menu_Frame
CreateStroke(TabHandler_Frame, Color3.new(), 2)

TabIndex_Frame.Name = "TabIndex"
TabIndex_Frame.BackgroundTransparency = 1
TabIndex_Frame.Position = UDim2.new(0, 1, 0, 1)
TabIndex_Frame.Size = UDim2.new(1, -2, 0, 20)
TabIndex_Frame.Parent = TabHandler_Frame

Tabs_Frame.Name = "Tabs"
Tabs_Frame.BackgroundTransparency = 1
Tabs_Frame.Position = UDim2.new(0, 1, 0, 26)
Tabs_Frame.Size = UDim2.new(1, -2, 1, -25)
Tabs_Frame.Parent = TabHandler_Frame

Notifications_Frame.Name = "Notifications"
Notifications_Frame.BackgroundTransparency = 1
Notifications_Frame.Size = UDim2.new(1, 0, 1, 36)
Notifications_Frame.Position = UDim2.fromOffset(0, -36)
Notifications_Frame.ZIndex = 5
Notifications_Frame.Parent = Menu.Screen

ToolTip.Name = "ToolTip"
ToolTip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToolTip.BorderColor3 = Menu.BorderColor
ToolTip.BorderMode = Enum.BorderMode.Inset
ToolTip.Text = ""
ToolTip.TextSize = 14
ToolTip.Font = Enum.Font.SourceSans
ToolTip.TextColor3 = Color3.new(1, 1, 1)
ToolTip.ZIndex = 5
ToolTip.Visible = false
ToolTip.Parent = Menu.Screen
CreateStroke(ToolTip, Color3.new(), 1)
AddEventListener(ToolTip, function()
    ToolTip.BorderColor3 = Menu.BorderColor
end)

Modal.Name = "Modal"
Modal.BackgroundTransparency = 1
Modal.Modal = true
Modal.Text = ""
Modal.Parent = Menu_Frame


--SelectedTabLines.Top = CreateLine(nil, UDim2.new(1, 0, 0, 1), UDim2.new())
SelectedTabLines.Left = CreateLine(nil, UDim2.new(0, 1, 1, 0), UDim2.new(), Color3.new())
SelectedTabLines.Right = CreateLine(nil, UDim2.new(0, 1, 1, 0), UDim2.new(1, -1, 0, 0), Color3.new())
SelectedTabLines.Bottom = CreateLine(TabIndex_Frame, UDim2.new(), UDim2.new(0, 0, 1, 0), Color3.new())
SelectedTabLines.Bottom2 = CreateLine(TabIndex_Frame, UDim2.new(), UDim2.new(), Color3.new())



function ChangeTab(Tab_Name)
    assert(Tabs[Tab_Name], "Tab \"" .. tostring(Tab_Name) .. "\" does not exist!")
    for _, Tab in pairs(Tabs) do
        Tab.self.Visible = false
        Tab.Button.BackgroundColor3 = Menu.ItemColor
        Tab.Button.TextColor3 = Color3.fromRGB(205, 205, 205)
    end
    local Tab = GetTab(Tab_Name)
    Tab.self.Visible = true
    Tab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Tab.Button.TextColor3 = Color3.new(1, 1, 1)

    if (Tab.Button.AbsolutePosition.X > Tab.self.AbsolutePosition.X) then
        SelectedTabLines.Left.Visible = true
    else
        SelectedTabLines.Left.Visible = false
    end

    if (Tab.Button.AbsolutePosition.X + Tab.Button.AbsoluteSize.X < Tab.self.AbsolutePosition.X + Tab.self.AbsoluteSize.X) then
        SelectedTabLines.Right.Visible = true
    else
        SelectedTabLines.Right.Visible = false
    end

    --SelectedTabLines.Top.Parent = Tab.Button
    SelectedTabLines.Left.Parent = Tab.Button
    SelectedTabLines.Right.Parent = Tab.Button

    local FRAME_POSITION = Tab.self.AbsolutePosition
    local BUTTON_POSITION = Tab.Button.AbsolutePosition
    local BUTTON_SIZE = Tab.Button.AbsoluteSize
    local LENGTH = BUTTON_POSITION.X - FRAME_POSITION.X
    local OFFSET = (BUTTON_POSITION.X + BUTTON_SIZE.X) - FRAME_POSITION.X

    SelectedTabLines.Bottom.Size = UDim2.new(0, LENGTH, 0, 1)
    SelectedTabLines.Bottom2.Size = UDim2.new(1, -OFFSET, 0, 1)
    SelectedTabLines.Bottom2.Position = UDim2.new(0, OFFSET, 1, 0)

    UpdateSelected()
end


function UpdateTabs()
    for _, Tab in pairs(Tabs) do
        Tab.Button.Size = UDim2.new(1 / GetDictionaryLength(Tabs), 0, 1, 0)
        Tab.Button.Position = UDim2.new((1 / GetDictionaryLength(Tabs)) * (Tab.Index - 1), 0, 0, 0)
    end
end


function UpdateSelected(Frame, Item, Offset)
    local Selected_Frame = Selected.Frame
    if Selected_Frame then
        Selected_Frame.Visible = false
        Selected_Frame.Parent = nil
    end

    Selected = {}

    if Frame then
        if Selected_Frame == Frame then return end
        Selected = {
            Frame = Frame,
            Item = Item,
            Offset = Offset
        }
        Frame.ZIndex = 3
        Frame.Visible = true
        Frame.Parent = Menu.Screen
    end
end


function GetTab(Tab_Name)
    assert(Tab_Name, "NO TAB_NAME GIVEN")
    return Tabs[Tab_Name]
end


function GetContainer(Tab_Name, Container_Name)
    assert(Tab_Name, "NO TAB_NAME GIVEN")
    assert(Container_Name, "NO CONTAINER NAME GIVEN")
    return GetTab(Tab_Name)[Container_Name]
end


function GetDictionaryLength(Dictionary)
    local Length = 0
    for _ in pairs(Dictionary) do
        Length += 1
    end
    return Length
end


function CheckItemIndex(Item_Index, Method)
    assert(Item_Index, "missing argument #1 to ")
    assert(typeof(Item_Index) == "number", "invalid argument #1 to '" .. Method .. "' (number expected, got " .. typeof(Item_Index) .. ")")
    assert(Item_Index <= #Items and Item_Index > 0, "invalid argument #1 to '" .. Method .. "' (index out of range")
end


function Menu:GetItem(Index)
    CheckItemIndex(Index, "GetItem")
    return Items[Index]
end


function Menu:FindItem(Tab_Name, Container_Name, Class_Name, Name)
    local Result
    for Index, Item in ipairs(Items) do
        if Item.Tab == Tab_Name and Item.Container == Container_Name then
            if Item.Name == Name and (Item.Class == Class_Name) then
                Result = Index
                break
            end
        end
    end

    if Result then
        return Menu:GetItem(Result)
    else
        return error("Item " .. tostring(Name) .. " was not found")
    end
end


function Menu:SetTitle(Name)
    Title_Label.Text = tostring(Name)
end


function Menu:SetSize(Size)
    local Size = typeof(Size) == "Vector2" and Size or typeof(Size) == "UDim2" and Vector2.new(Size.X, Size.Y) or Menu.MinSize
    local X = Size.X
    local Y = Size.Y

    if (X > Menu.MinSize.X and X < Menu.MaxSize.X) then
        X = math.clamp(X, Menu.MinSize.X, Menu.MaxSize.X)
    end
    if (Y > Menu.MinSize.Y and Y < Menu.MaxSize.Y) then
        Y = math.clamp(Y, Menu.MinSize.Y, Menu.MaxSize.Y)
    end

    Menu_Frame.Size = UDim2.fromOffset(X, Y)
    UpdateTabs()
end


function Menu:SetVisible(Visible)
    local Visible = typeof(Visible) == "boolean" and Visible or false
    Menu_Frame.Visible = Visible
    Menu.IsVisible = Visible
    if Visible == false then
        UpdateSelected()
    end
end


function Menu:SetTab(Tab_Name)
    ChangeTab(Tab_Name)
end


function Menu.Line(Parent, Size, Position)
    local Line = {self = CreateLine(Parent, Size, Position)}
    Line.Class = "Line"
    return Line
end


function Menu.Tab(Tab_Name)
    assert(Tab_Name and typeof(Tab_Name) == "string", "TAB_NAME REQUIRED")
    if Tabs[Tab_Name] then return error("TAB_NAME '" .. tostring(Tab_Name) .. "' ALREADY EXISTS") end
    local Frame = Instance.new("Frame")
    local Button = Instance.new("TextButton")

    local Tab = {self = Frame, Button = Button}
    Tab.Class = "Tab"
    Tab.Index = GetDictionaryLength(Tabs) + 1


    local function CreateSide(Side)
        local Frame = Instance.new("ScrollingFrame")
        local ListLayout = Instance.new("UIListLayout")

        Frame.Name = Side
        Frame.Active = true
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Size = Side == "Middle" and UDim2.new(1, -10, 1, -10) or UDim2.new(0.5, -10, 1, -10)
        Frame.Position = (Side == "Left" and UDim2.fromOffset(5, 5)) or (Side == "Right" and UDim2.new(0.5, 5, 0, 5) or Side == "Middle" and UDim2.fromOffset(5, 5))
        Frame.CanvasSize = UDim2.new(0, 0, 0, -10)
        Frame.ScrollBarThickness = 2
        Frame.ScrollBarImageColor3 = Menu.Accent
        Frame.Parent = Tab.self
        AddEventListener(Frame, function()
            Frame.ScrollBarImageColor3 = Menu.Accent
        end)

        ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 10)
        ListLayout.Parent = Frame
    end


    Button.Name = "Button"
    Button.BackgroundColor3 = Menu.ItemColor
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.SourceSans
    Button.Text = Tab_Name
    Button.TextColor3 = Color3.fromRGB(205, 205, 205)
    Button.TextSize = 14
    Button.Parent = TabIndex_Frame
    AddEventListener(Button, function()
        if Button.TextColor3 == Color3.fromRGB(205, 205, 205) then
            Button.BackgroundColor3 = Menu.ItemColor
        end
        Button.BackgroundColor3 = Menu.ItemColor
        Button.BorderColor3 = Menu.BorderColor
    end)
    Button.MouseButton1Click:Connect(function()
        ChangeTab(Tab_Name)
    end)
    
    Frame.Name = Tab_Name .. "Tab"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Visible = false
    Frame.Parent = Tabs_Frame

    CreateSide("Middle")
    CreateSide("Left")
    CreateSide("Right")

    Tabs[Tab_Name] = Tab

    ChangeTab(Tab_Name)
    UpdateTabs()
    return Tab
end


function Menu.Container(Tab_Name, Container_Name, Side)
    local Tab = GetTab(Tab_Name)
    assert(typeof(Tab_Name) == "string", "TAB_NAME REQUIRED")
    if Tab[Container_Name] then return error("CONTAINER_NAME '" .. tostring(Container_Name) .. "' ALREADY EXISTS") end
    local Side = Side or "Left"

    local Frame = Instance.new("Frame")
    local Label = CreateLabel(Frame, "Title", Container_Name, UDim2.fromOffset(206, 15),  UDim2.fromOffset(5, 0))
    local Line = CreateLine(Frame, UDim2.new(1, -10, 0, 1), UDim2.fromOffset(5, 15))

    local Container = {self = Frame, Height = 0}
    Container.Class = "Container"

    function Container:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function Container:SetVisible(Visible)
        if Visible then
            if not Frame.Visible then
                Frame.Visible = true
                Container:UpdateSize(25, Frame)
            end
        else
            if Frame.Visible then
                Frame.Visible = false
                Container:UpdateSize(-25, Frame)
            end
        end
    end

    function Container:UpdateSize(Height:float, Item:gui_object)
        Container.Height += Height
        Frame.Size += UDim2.fromOffset(0, Height)
        Tab.self[Side].CanvasSize += UDim2.fromOffset(0, Height)

        if Item then
            local ItemY = Item.AbsolutePosition.Y
            if math.sign(Height) == 1 then
                ItemY -= 1
            end

            for _, item in ipairs(Frame:GetChildren()) do
                if (item == Label or item == Line or item == Stroke or Item == item) then continue end -- exlude these
                local item_y = item.AbsolutePosition.Y
                if item_y > ItemY then
                    item.Position += UDim2.fromOffset(0, Height)
                end
            end
        end
    end

    function Container:GetHeight()
        return Container.Height
    end


    Frame.Name = "Container"
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderColor3 = Color3.new()
    Frame.BorderMode = Enum.BorderMode.Inset
    Frame.Size = UDim2.new(1, -6, 0, 0)
    Frame.Parent = Tab.self[Side]

    Container:UpdateSize(25)
    Tab.self[Side].CanvasSize += UDim2.fromOffset(0, 10)
    Tab[Container_Name] = Container
    return Container
end


function Menu.Label(Tab_Name, Container_Name, Name)
    local Container = GetContainer(Tab_Name, Container_Name)
    local GuiLabel = CreateLabel(Container.self, "Label", Name, nil, UDim2.fromOffset(20, Container.GetHeight()))

    local Label = {self = Label}
    Label.Name = Name
    Label.Class = "Label"
    Label.Index = #Items + 1
    Label.Tab = Tab_Name
    Label.Container = Container_Name

    function Label:SetLabel(Name)
        GuiLabel.Text = tostring(Name)
    end

    function Label:SetVisible(Visible)
        if Visible then
            if not GuiLabel.Visible then
                GuiLabel.Visible = true
                Container:UpdateSize(20, GuiLabel)
            end
        else
            if GuiLabel.Visible then
                GuiLabel.Visible = false
                Container:UpdateSize(-20, GuiLabel)
            end
        end
    end

    Container:UpdateSize(20)
    table.insert(Items, Label)
    return #Items
end


function Menu.Button(Tab_Name, Container_Name, Name, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local GuiButton = Instance.new("TextButton")

    local Button = {self = GuiButton}
    Button.Name = Name
    Button.Class = "Button"
    Button.Tab = Tab_Name
    Button.Container = Container_Name
    Button.Index = #Items + 1
    Button.Callback = typeof(Callback) == "function" and Callback or function() end

    function Button:SetVisible(Visible)
        if Visible then
            if not GuiButton.Visible then
                GuiButton.Visible = true
                Container:UpdateSize(25, GuiButton)
            end
        else
            if GuiButton.Visible then
                GuiButton.Visible = false
                Container:UpdateSize(-25, GuiButton)
            end
        end
    end

    function Button:SetLabel(Name)
        GuiButton.Text = tostring(Name)
    end


    GuiButton.Name = "Button"
    GuiButton.BackgroundColor3 = Menu.ItemColor
    GuiButton.BorderColor3 = Menu.BorderColor
    GuiButton.BorderMode = Enum.BorderMode.Inset
    GuiButton.Position = UDim2.fromOffset(20, Container.GetHeight())
    GuiButton.Size = UDim2.new(1, -50, 0, 20)
    GuiButton.Font = Enum.Font.SourceSansSemibold
    GuiButton.Text = Name
    GuiButton.TextColor3 = Color3.new(1, 1, 1)
    GuiButton.TextSize = 14
    GuiButton.TextTruncate = Enum.TextTruncate.AtEnd
    GuiButton.Parent = Container.self
    CreateStroke(GuiButton, Color3.new(), 1)
    AddEventListener(GuiButton, function()
        GuiButton.BackgroundColor3 = Menu.ItemColor
        GuiButton.BorderColor3 = Menu.BorderColor
    end)
    GuiButton.MouseButton1Click:Connect(function()
        Button.Callback()
    end)

    Container:UpdateSize(25)
    table.insert(Items, Button)
    return #Items
end


function Menu.TextBox(Tab_Name, Container_Name, Name, Value, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "TextBox", Name, nil, UDim2.fromOffset(20, Container.GetHeight()))
    local GuiTextBox = Instance.new("TextBox")

    local TextBox = {self = GuiTextBox}
    TextBox.Name = Name
    TextBox.Class = "TextBox"
    TextBox.Tab = Tab_Name
    TextBox.Container = Container_Name
    TextBox.Index = #Items + 1
    TextBox.Value = typeof(Value) == "string" and Value or ""
    TextBox.Callback = typeof(Callback) == "function" and Callback or function() end

    function TextBox:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(45, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-45, Label)
            end
        end
    end

    function TextBox:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function TextBox:GetValue()
        return TextBox.Value
    end

    function TextBox:SetValue(Value)
        TextBox.Value = tostring(Value)
        GuiTextBox.Text = TextBox.Value
    end


    GuiTextBox.Name = "TextBox"
    GuiTextBox.BackgroundColor3 = Menu.ItemColor
    GuiTextBox.BorderColor3 = Menu.BorderColor
    GuiTextBox.BorderMode = Enum.BorderMode.Inset
    GuiTextBox.Position = UDim2.fromOffset(0, 20)
    GuiTextBox.Size = UDim2.new(1, -50, 0, 20)
    GuiTextBox.Font = Enum.Font.SourceSansSemibold
    GuiTextBox.Text = TextBox.Value
    GuiTextBox.TextColor3 = Color3.new(1, 1, 1)
    GuiTextBox.TextSize = 14
    GuiTextBox.ClearTextOnFocus = false
    GuiTextBox.ClipsDescendants = true
    GuiTextBox.Parent = Label
    CreateStroke(GuiTextBox, Color3.new(), 1)
    AddEventListener(GuiTextBox, function()
        GuiTextBox.BackgroundColor3 = Menu.ItemColor
        GuiTextBox.BorderColor3 = Menu.BorderColor
    end)
    GuiTextBox.FocusLost:Connect(function()
        TextBox.Value = GuiTextBox.Text
        TextBox.Callback(GuiTextBox.Text)
    end)

    Container:UpdateSize(45)
    table.insert(Items, TextBox)
    return #Items
end


function Menu.CheckBox(Tab_Name, Container_Name, Name, Boolean, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "CheckBox", Name, nil, UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    
    local CheckBox = {self = Label}
    CheckBox.Name = Name
    CheckBox.Class = "CheckBox"
    CheckBox.Tab = Tab_Name
    CheckBox.Container = Container_Name
    CheckBox.Index = #Items + 1
    CheckBox.Value = typeof(Boolean) == "boolean" and Boolean or false
    CheckBox.Callback = typeof(Callback) == "function" and Callback or function() end

    function CheckBox:Update(Value)
        CheckBox.Value = typeof(Value) == "boolean" and Value
        Button.BackgroundColor3 = CheckBox.Value and Menu.Accent or Menu.ItemColor
    end

    function CheckBox:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(20, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-20, Label)
            end
        end
    end

    function CheckBox:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function CheckBox:GetValue()
        return CheckBox.Value
    end

    function CheckBox:SetValue(Value)
        CheckBox:Update(Value)
    end


    Button.BackgroundColor3 = Menu.ItemColor
    Button.BorderColor3 = Color3.new()
    Button.Position = UDim2.fromOffset(-14, 4)
    Button.Size = UDim2.fromOffset(8, 8)
    Button.Text = ""
    Button.Parent = Label
    AddEventListener(Button, function()
        Button.BackgroundColor3 = CheckBox.Value and Menu.Accent or Menu.ItemColor
    end)
    Button.MouseButton1Click:Connect(function()
        CheckBox:Update(not CheckBox.Value)
        CheckBox.Callback(CheckBox.Value)
    end)

    CheckBox:Update(CheckBox.Value)
    Container:UpdateSize(20)
    table.insert(Items, CheckBox)
    return #Items
end


function Menu.Hotkey(Tab_Name, Container_Name, Name, Key, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "Hotkey", Name, nil, UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    local Selected_Hotkey = Instance.new("Frame")
    local HotkeyToggle = Instance.new("TextButton")
    local HotkeyHold = Instance.new("TextButton")

    local Hotkey = {self = Label}
    Hotkey.Name = Name
    Hotkey.Class = "Hotkey"
    Hotkey.Tab = Tab_Name
    Hotkey.Container = Container_Name
    Hotkey.Index = #Items + 1
    Hotkey.Key = typeof(Key) == "EnumItem" and Key or nil
    Hotkey.Callback = typeof(Callback) == "function" and Callback or function() end
    Hotkey.Editing = false
    Hotkey.Mode = "Toggle"

    function Hotkey:Update(Input, Mode)
        if Input then
            Button.Text = string.format("[%s]", Input.Name)
        else
            Button.Text = "[None]"
        end
        Hotkey.Mode = Mode or "Toggle"
        Hotkey.Key = Input
        Hotkey.Editing = false
    end

    function Hotkey:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(20, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-20, Label)
            end
        end
    end

    function Hotkey:SetLabel(Name)
        Label.Text = tostring(Name)
    end
    
    function Hotkey:GetValue()
        return Hotkey.Key, Hotkey.Mode
    end

    function Hotkey:SetValue(Key, Mode)
        Hotkey:Update(Key, Mode)
    end


    Button.Name = "Hotkey"
    Button.BackgroundTransparency = 1
    Button.Position = UDim2.new(1, -100, 0, 4)
    Button.Size = UDim2.fromOffset(75, 8)
    Button.Font = Enum.Font.SourceSans
    Button.Text = Key and "[" .. Key.Name .. "]" or "[None]"
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Right
    Button.Parent = Label

    Selected_Hotkey.Name = "Selected_Hotkey"
    Selected_Hotkey.Visible = false
    Selected_Hotkey.BackgroundColor3 = Menu.ItemColor
    Selected_Hotkey.BorderColor3 = Menu.BorderColor
    Selected_Hotkey.Position = UDim2.fromOffset(200, 100)
    Selected_Hotkey.Size = UDim2.fromOffset(100, 30)
    Selected_Hotkey.Parent = nil
    CreateStroke(Selected_Hotkey, Color3.new(), 1)
    AddEventListener(Selected_Hotkey, function()
        Selected_Hotkey.BackgroundColor3 = Menu.ItemColor
        Selected_Hotkey.BorderColor3 = Menu.BorderColor
    end)

    HotkeyToggle.Parent = Selected_Hotkey
    HotkeyToggle.BackgroundColor3 = Menu.ItemColor
    HotkeyToggle.BorderColor3 = Color3.new()
    HotkeyToggle.BorderSizePixel = 0
    HotkeyToggle.Position = UDim2.new()
    HotkeyToggle.Size = UDim2.new(1, 0, 0, 13)
    HotkeyToggle.Font = Enum.Font.SourceSans
    HotkeyToggle.Text = "Toggle"
    HotkeyToggle.TextColor3 = Menu.Accent
    HotkeyToggle.TextSize = 14
    AddEventListener(HotkeyToggle, function()
        HotkeyToggle.BackgroundColor3 = Menu.ItemColor
        if Hotkey.Mode == "Toggle" then
            HotkeyToggle.TextColor3 = Menu.Accent
        end
    end)
    HotkeyToggle.MouseButton1Click:Connect(function()
        Hotkey:Update(Hotkey.Key, "Toggle")
        HotkeyToggle.TextColor3 = Menu.Accent
        HotkeyHold.TextColor3 = Color3.new(1, 1, 1)
        UpdateSelected()
        Hotkey.Callback(Hotkey.Key, Hotkey.Mode)
    end)

    HotkeyHold.Parent = Selected_Hotkey
    HotkeyHold.BackgroundColor3 = Menu.ItemColor
    HotkeyHold.BorderColor3 = Color3.new()
    HotkeyHold.BorderSizePixel = 0
    HotkeyHold.Position = UDim2.new(0, 0, 0, 15)
    HotkeyHold.Size = UDim2.new(1, 0, 0, 13)
    HotkeyHold.Font = Enum.Font.SourceSans
    HotkeyHold.Text = "Hold"
    HotkeyHold.TextColor3 = Color3.new(1, 1, 1)
    HotkeyHold.TextSize = 14
    AddEventListener(HotkeyHold, function()
        HotkeyHold.BackgroundColor3 = Menu.ItemColor
        if Hotkey.Mode == "Hold" then
            HotkeyHold.TextColor3 = Menu.Accent
        end
    end)
    HotkeyHold.MouseButton1Click:Connect(function()
        Hotkey:Update(Hotkey.Key, "Hold")
        HotkeyHold.TextColor3 = Menu.Accent
        HotkeyToggle.TextColor3 = Color3.new(1, 1, 1)
        UpdateSelected()
        Hotkey.Callback(Hotkey.Key, Hotkey.Mode)
    end)

    Button.MouseButton1Click:Connect(function()
        Button.Text = "..."
        Hotkey.Editing = true
        if UserInput:IsKeyDown(HotkeyRemoveKey) and Key ~= HotkeyRemoveKey then
            Hotkey:Update()
        end
    end)
    Button.MouseButton2Click:Connect(function()
        UpdateSelected(Selected_Hotkey, Button, UDim2.fromOffset(100, 0))
    end)

    UserInput.InputBegan:Connect(function(Input)
        if Hotkey.Editing then
            local Key = Input.KeyCode
            if Key == Enum.KeyCode.Unknown then
                local InputType = Input.UserInputType
                Hotkey:Update(InputType)
                Hotkey.Callback(InputType, Hotkey.Mode)
            else
                Hotkey:Update(Key)
                Hotkey.Callback(Key, Hotkey.Mode)
            end
        end
    end)

    Container:UpdateSize(20)
    table.insert(Items, Hotkey)
    return #Items
end


function Menu.Slider(Tab_Name, Container_Name, Name, Min, Max, Value, Unit, Scale, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "Slider", Name, UDim2.new(1, -10, 0, 15), UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    local ValueBar = Instance.new("TextLabel")
    local ValueBox = Instance.new("TextBox")
    local ValueLabel = Instance.new("TextLabel")

    local Slider = {}
    Slider.Name = Name
    Slider.Class = "Slider"
    Slider.Tab = Tab_Name
    Slider.Container = Container_Name
    Slider.Index = #Items + 1
    Slider.Min = typeof(Min) == "number" and math.clamp(Min, Min, Max) or 0
    Slider.Max = typeof(Max) == "number" and Max or 100
    Slider.Value = typeof(Value) == "number" and Value or 100
    Slider.Unit = typeof(Unit) == "string" and Unit or ""
    Slider.Scale = typeof(Scale) == "number" and Scale or 0
    Slider.Callback = typeof(Callback) == "function" and Callback or function() end

    local function UpdateSlider(Percentage:float)
        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
        local Value = Slider.Min + ((Slider.Max - Slider.Min) * Percentage)
        local Scale = (10 ^ Slider.Scale)
        Slider.Value = math.round(Value * Scale) / Scale

        ValueBar.Size = UDim2.new(Percentage, 0, 0, 5)
        ValueBox.Text = "[" .. Slider.Value .. "]"
        ValueLabel.Text = Slider.Value .. Slider.Unit
    end

    function Slider:Update(Percentage:float)
        UpdateSlider(Percentage)
    end

    function Slider:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(30, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-30, Label)
            end
        end
    end

    function Slider:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function Slider:GetValue()
        return Slider.Value
    end

    function Slider:SetValue(Value)
        Slider.Value = typeof(Value) == "number" and math.clamp(Value, Slider.Min, Slider.Max) or Slider.Min
        local Percentage = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
        Slider:Update(Percentage)
    end

    Slider.self = Label

    Button.Name = "Slider"
    Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Button.BorderColor3 = Color3.new()
    Button.Position = UDim2.fromOffset(0, 20)
    Button.Size = UDim2.new(1, -40, 0, 5)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Label

    ValueBar.Name = "ValueBar"
    ValueBar.BackgroundColor3 = Menu.Accent
    ValueBar.BorderSizePixel = 0
    ValueBar.Size = UDim2.fromScale(1, 1)
    ValueBar.Text = ""
    ValueBar.Parent = Button
    AddEventListener(ValueBar, function()
        ValueBar.BackgroundColor3 = Menu.Accent
    end)
    
    ValueBox.Name = "ValueBox"
    ValueBox.BackgroundTransparency = 1
    ValueBox.Position = UDim2.new(1, -65, 0, 5)
    ValueBox.Size = UDim2.fromOffset(50, 10)
    ValueBox.Font = Enum.Font.SourceSans
    ValueBox.Text = ""
    ValueBox.TextColor3 = Color3.new(1, 1, 1)
    ValueBox.TextSize = 12
    ValueBox.TextXAlignment = Enum.TextXAlignment.Right
    ValueBox.ClipsDescendants = true
    ValueBox.Parent = Label
    ValueBox.FocusLost:Connect(function()
        Slider.Value = tonumber(ValueBox.Text) or 0
        local Percentage = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
        Slider:Update(Percentage)
        Slider.Callback(Slider.Value)
    end)

    ValueLabel.Name = "ValueLabel"
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, 0, 0, 2)
    ValueLabel.Size = UDim2.new(0, 0, 1, 0)
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.Text = ""
    ValueLabel.TextColor3 = Color3.new(1, 1, 1)
    ValueLabel.TextSize = 14
    ValueLabel.Parent = ValueBar

    Button.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            Dragging = {Gui = Button, True = true}
            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
            local Percentage = (InputPosition - Button.AbsolutePosition) / Button.AbsoluteSize
            Slider:Update(Percentage.X)
            Slider.Callback(Slider.Value)
        end
    end)

    UserInput.InputChanged:Connect(function(Input, Process)
        if Dragging.Gui ~= Button then return end
        if not (UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
            Dragging = {Gui = nil, True = false}
            return
        end
        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
            local Percentage = (InputPosition - Button.AbsolutePosition) / Button.AbsoluteSize
            Slider:Update(Percentage.X)
            Slider.Callback(Slider.Value)
        end
    end)


    Slider:SetValue(Slider.Value)
    Container:UpdateSize(30)
    table.insert(Items, Slider)
    return #Items
end


function Menu.ColorPicker(Tab_Name, Container_Name, Name, Color, Alpha, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "ColorPicker", Name, UDim2.new(1, -10, 0, 15), UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    local Selected_ColorPicker = Instance.new("Frame")
    local HexBox = Instance.new("TextBox")
    local Saturation = Instance.new("ImageButton")
    local Alpha = Instance.new("ImageButton")
    local Hue = Instance.new("ImageButton")
    local SaturationCursor = Instance.new("Frame")
    local AlphaCursor = Instance.new("Frame")
    local HueCursor = Instance.new("Frame")
    local CopyButton = Instance.new("TextButton") -- rbxassetid://9090721920
    local PasteButton = Instance.new("TextButton") -- rbxassetid://9090721063
    local AlphaColorGradient = Instance.new("UIGradient")

    local ColorPicker = {self = Label}
    ColorPicker.Name = Name
    ColorPicker.Tab = Tab_Name
    ColorPicker.Class = "ColorPicker"
    ColorPicker.Container = Container_Name
    ColorPicker.Index = #Items + 1
    ColorPicker.Color = typeof(Color) == "Color3" and Color or Color3.new(1, 1, 1)
    ColorPicker.Saturation = {0, 0} -- no i'm not going to use ColorPicker.Value that would confuse people with ColorPicker.Color
    ColorPicker.Alpha = typeof(Alpha) == "number" and Alpha or 0
    ColorPicker.Hue = 0
    ColorPicker.Callback = typeof(Callback) == "function" and Callback or function() end

    local function UpdateColor()
        ColorPicker.Color = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2])

        HexBox.Text = "#" .. string.upper(ColorPicker.Color:ToHex()) .. string.upper(string.format("%X", ColorPicker.Alpha * 255))
        Button.BackgroundColor3 = ColorPicker.Color
        Saturation.BackgroundColor3 = ColorPicker.Color
        AlphaColorGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, ColorPicker.Color)}

        SaturationCursor.Position = UDim2.fromScale(math.clamp(ColorPicker.Saturation[1], 0, 0.95), math.clamp(1 - ColorPicker.Saturation[2], 0, 0.95))
        AlphaCursor.Position = UDim2.fromScale(0, math.clamp(ColorPicker.Alpha, 0, 0.98))
        HueCursor.Position = UDim2.fromScale(0, math.clamp(ColorPicker.Hue, 0, 0.98))

        ColorPicker.Callback(ColorPicker.Color, ColorPicker.Alpha)
    end

    function ColorPicker:Update()
        UpdateColor()
    end

    function ColorPicker:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(20, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-20, Label)
            end
        end
    end

    function ColorPicker:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function ColorPicker:SetValue(Color, Alpha)
        ColorPicker.Color, ColorPicker.Alpha = typeof(Color) == "Color3" and Color or Color3.new(), typeof(Alpha) == "number" and Alpha or 0
        ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2] = ColorPicker.Color:ToHSV()
        ColorPicker:Update()
    end

    function ColorPicker:GetValue()
        return ColorPicker.Color, ColorPicker.Alpha
    end


    Button.Name = "ColorPicker"
    Button.BackgroundColor3 = ColorPicker.Color
    Button.BorderColor3 = Color3.new()
    Button.Position = UDim2.new(1, -35, 0, 4)
    Button.Size = UDim2.fromOffset(20, 8)
    Button.Font = Enum.Font.SourceSans
    Button.Text = ""
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 12
    Button.Parent = Label
    Button.MouseButton1Click:Connect(function()
        UpdateSelected(Selected_ColorPicker, Button, UDim2.fromOffset(20, 20))
    end)

    Selected_ColorPicker.Name = "Selected_ColorPicker"
    Selected_ColorPicker.Visible = false
    Selected_ColorPicker.BackgroundColor3 = Menu.ItemColor
    Selected_ColorPicker.BorderColor3 = Menu.BorderColor
    Selected_ColorPicker.BorderMode = Enum.BorderMode.Inset
    Selected_ColorPicker.Position = UDim2.new(0, 200, 0, 170)
    Selected_ColorPicker.Size = UDim2.new(0, 190, 0, 180)
    Selected_ColorPicker.Parent = nil
    CreateStroke(Selected_ColorPicker, Color3.new(), 1)
    AddEventListener(Selected_ColorPicker, function()
        Selected_ColorPicker.BackgroundColor3 = Menu.ItemColor
        Selected_ColorPicker.BorderColor3 = Menu.BorderColor
    end)

    HexBox.Name = "Hex"
    HexBox.BackgroundColor3 = Menu.ItemColor
    HexBox.BorderColor3 = Menu.BorderColor
    HexBox.BorderMode = Enum.BorderMode.Inset
    HexBox.Size = UDim2.new(1, -10, 0, 20)
    HexBox.Position = UDim2.fromOffset(5, 150)
    HexBox.Text = "#" .. string.upper(ColorPicker.Color:ToHex())
    HexBox.Font = Enum.Font.SourceSansSemibold
    HexBox.TextSize = 14
    HexBox.TextColor3 = Color3.new(1, 1, 1)
    HexBox.ClearTextOnFocus = false
    HexBox.ClipsDescendants = true
    HexBox.Parent = Selected_ColorPicker
    CreateStroke(HexBox, Color3.new(), 1)
    HexBox.FocusLost:Connect(function()
        pcall(function()
            local Color, Alpha = string.sub(HexBox.Text, 1, 7), string.sub(HexBox.Text, 8, #HexBox.Text)
            ColorPicker.Color = Color3.fromHex(Color)
            ColorPicker.Alpha = tonumber(Alpha, 16) / 255
            ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2] = ColorPicker.Color:ToHSV()
            ColorPicker:Update()
        end)
    end)
    AddEventListener(HexBox, function()
        HexBox.BackgroundColor3 = Menu.ItemColor
        HexBox.BorderColor3 = Menu.BorderColor
    end)

    Saturation.Name = "Saturation"
    Saturation.BackgroundColor3 = ColorPicker.Color
    Saturation.BorderColor3 = Menu.BorderColor
    Saturation.Position = UDim2.new(0, 4, 0, 4)
    Saturation.Size = UDim2.new(0, 150, 0, 140)
    Saturation.Image = "rbxassetid://8180999986"
    Saturation.ImageColor3 = Color3.new()
    Saturation.AutoButtonColor = false
    Saturation.Parent = Selected_ColorPicker
    CreateStroke(Saturation, Color3.new(), 1)
    AddEventListener(Saturation, function()
        Saturation.BorderColor3 = Menu.BorderColor
    end)
    
    Alpha.Name = "Alpha"
    Alpha.BorderColor3 = Menu.BorderColor
    Alpha.Position = UDim2.new(0, 175, 0, 4)
    Alpha.Size = UDim2.new(0, 10, 0, 140)
    Alpha.Image = "rbxassetid://9090739505"--"rbxassetid://8181003956"
    Alpha.ScaleType = Enum.ScaleType.Crop
    Alpha.AutoButtonColor = false
    Alpha.Parent = Selected_ColorPicker
    CreateStroke(Alpha, Color3.new(), 1)
    AddEventListener(Alpha, function()
        Alpha.BorderColor3 = Menu.BorderColor
    end)

    Hue.Name = "Hue"
    Hue.BackgroundColor3 = Color3.new(1, 1, 1)
    Hue.BorderColor3 = Menu.BorderColor
    Hue.Position = UDim2.new(0, 160, 0, 4)
    Hue.Size = UDim2.new(0, 10, 0, 140)
    Hue.Image = "rbxassetid://8180989234"
    Hue.ScaleType = Enum.ScaleType.Crop
    Hue.AutoButtonColor = false
    Hue.Parent = Selected_ColorPicker
    CreateStroke(Hue, Color3.new(), 1)
    AddEventListener(Hue, function()
        Hue.BorderColor3 = Menu.BorderColor
    end)

    SaturationCursor.Name = "Cursor"
    SaturationCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    SaturationCursor.BorderColor3 = Color3.new()
    SaturationCursor.Size = UDim2.fromOffset(5, 5)
    SaturationCursor.Parent = Saturation

    AlphaCursor.Name = "Cursor"
    AlphaCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    AlphaCursor.BorderColor3 = Color3.new()
    AlphaCursor.Size = UDim2.new(1, 0, 0, 2)
    AlphaCursor.Parent = Alpha

    HueCursor.Name = "Cursor"
    HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    HueCursor.BorderColor3 = Color3.new()
    HueCursor.Size = UDim2.new(1, 0, 0, 2)
    HueCursor.Parent = Hue

    AlphaColorGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, ColorPicker.Color)}
    AlphaColorGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.20), NumberSequenceKeypoint.new(1, 0.2)}
    AlphaColorGradient.Offset = Vector2.new(0, -0.1)
    AlphaColorGradient.Rotation = -90
    AlphaColorGradient.Parent = Alpha

    local function UpdateSaturation(PercentageX, PercentageY)
        local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
        local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
        ColorPicker.Saturation[1] = PercentageX
        ColorPicker.Saturation[2] = 1 - PercentageY
        ColorPicker:Update()
    end

    local function UpdateAlpha(Percentage)
        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
        ColorPicker.Alpha = Percentage
        ColorPicker:Update()
    end

    local function UpdateHue(Percentage)
        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
        ColorPicker.Hue = Percentage
        ColorPicker:Update()
    end

    Saturation.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            Dragging = {Gui = Saturation, True = true}
            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
            local Percentage = (InputPosition - Saturation.AbsolutePosition) / Saturation.AbsoluteSize
            UpdateSaturation(Percentage.X, Percentage.Y)
        end
    end)

    Alpha.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            Dragging = {Gui = Alpha, True = true}
            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
            local Percentage = (InputPosition - Alpha.AbsolutePosition) / Alpha.AbsoluteSize
            UpdateAlpha(Percentage.Y)
        end
    end)

    Hue.InputBegan:Connect(function(Input, Process)
        if (not Dragging.Gui and not Dragging.True) and (Input.UserInputType == Enum.UserInputType.MouseButton1) then
            Dragging = {Gui = Hue, True = true}
            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
            local Percentage = (InputPosition - Hue.AbsolutePosition) / Hue.AbsoluteSize
            UpdateHue(Percentage.Y)
        end
    end)

    UserInput.InputChanged:Connect(function(Input, Process)
        if (Dragging.Gui ~= Saturation and Dragging.Gui ~= Alpha and Dragging.Gui ~= Hue) then return end
        if not (UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
            Dragging = {Gui = nil, True = false}
            return
        end

        local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
            if Dragging.Gui == Saturation then
                local Percentage = (InputPosition - Saturation.AbsolutePosition) / Saturation.AbsoluteSize
                UpdateSaturation(Percentage.X, Percentage.Y)
            end
            if Dragging.Gui == Alpha then
                local Percentage = (InputPosition - Alpha.AbsolutePosition) / Alpha.AbsoluteSize
                UpdateAlpha(Percentage.Y)
            end
            if Dragging.Gui == Hue then
                local Percentage = (InputPosition - Hue.AbsolutePosition) / Hue.AbsoluteSize
                UpdateHue(Percentage.Y)
            end
        end
    end)
    
    
    ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2] = ColorPicker.Color:ToHSV()
    ColorPicker:Update()
    Container:UpdateSize(20)
    table.insert(Items, ColorPicker)
    return #Items
end


function Menu.ComboBox(Tab_Name, Container_Name, Name, Value, Value_Items, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "ComboBox", Name, UDim2.new(1, -10, 0, 15), UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    local Symbol = Instance.new("TextLabel")
    local List = Instance.new("ScrollingFrame")
    local ListLayout = Instance.new("UIListLayout")

    local ComboBox = {}
    ComboBox.Name = Name
    ComboBox.Class = "ComboBox"
    ComboBox.Tab = Tab_Name
    ComboBox.Container = Container_Name
    ComboBox.Index = #Items + 1
    ComboBox.Callback = typeof(Callback) == "function" and Callback or function() end
    ComboBox.Value = typeof(Value) == "string" and Value or ""
    ComboBox.Items = typeof(Value_Items) == "table" and Value_Items or {}

    local function UpdateValue(Value)
        ComboBox.Value = tostring(Value)
        Button.Text = ComboBox.Value or "[...]"
    end

    local ItemObjects = {}
    local function AddItem(Name)
        local Button = Instance.new("TextButton")
        Button.BackgroundColor3 = Menu.ItemColor
        Button.BorderColor3 = Color3.new()
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 15)
        Button.Font = Enum.Font.SourceSans
        Button.Text = tostring(Name)
        Button.TextColor3 = ComboBox.Value == Button.Text and Menu.Accent or Color3.new(1, 1, 1)
        Button.TextSize = 14
        Button.TextTruncate = Enum.TextTruncate.AtEnd
        Button.Parent = List
        Button.MouseButton1Click:Connect(function()
            for _, v in ipairs(List:GetChildren()) do
                if v:IsA("GuiButton") then
                    if v == Button then continue end
                    v.TextColor3 = Color3.new(1, 1, 1)
                end
            end
            Button.TextColor3 = Menu.Accent
            UpdateValue(Button.Text)
            UpdateSelected()
            ComboBox.Callback(ComboBox.Value)
        end)
        AddEventListener(Button, function()
            Button.BackgroundColor3 = Menu.ItemColor
            if ComboBox.Value == Button.Text then
                Button.TextColor3 = Menu.Accent
            else
                Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end)
        
        if #ComboBox.Items >= 6 then
            List.CanvasSize += UDim2.fromOffset(0, 15)
        end
        table.insert(ItemObjects, Button)
    end

    function ComboBox:Update(Value, Items)
        UpdateValue(Value)
        if typeof(Items) == "table" then
            for _, Button in ipairs(ItemObjects) do
                Button:Destroy()
            end
            table.clear(ItemObjects)

            List.CanvasSize = UDim2.new()
            List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(#ComboBox.Items * 15, 15, 90))
            for _, Item in ipairs(ComboBox.Items) do
                AddItem(tostring(Item))
            end
        else
            for _, Button in ipairs(ItemObjects) do
                Button.TextColor3 = ComboBox.Value == Button.Text and Menu.Accent or Color3.new(1, 1, 1)
            end
        end
    end

    function ComboBox:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(40, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-40, Label)
            end
        end
    end

    function ComboBox:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function ComboBox:GetValue()
        return ComboBox.Value
    end

    function ComboBox:SetValue(Value, Items)
        if typeof(Items) == "table" then
            ComboBox.Items = Items
        end
        ComboBox:Update(Value, ComboBox.Items)
    end


    Button.Name = "Button"
    Button.BackgroundColor3 = Menu.ItemColor
    Button.BorderColor3 = Color3.new()
    Button.Position = UDim2.new(0, 0, 0, 20)
    Button.Size = UDim2.new(1, -40, 0, 15)
    Button.Font = Enum.Font.SourceSans
    Button.Text = ComboBox.Value
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.TextTruncate = Enum.TextTruncate.AtEnd
    Button.Parent = Label
    Button.MouseButton1Click:Connect(function()
        UpdateSelected(List, Button, UDim2.fromOffset(0, 15))
        List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(#ComboBox.Items * 15, 15, 90))
    end)
    AddEventListener(Button, function()
        Button.BackgroundColor3 = Menu.ItemColor
    end)

    Symbol.Name = "Symbol"
    Symbol.Parent = Button
    Symbol.BackgroundColor3 = Color3.new(1, 1, 1)
    Symbol.BackgroundTransparency = 1
    Symbol.Position = UDim2.new(1, -10, 0, 0)
    Symbol.Size = UDim2.new(0, 5, 1, 0)
    Symbol.Font = Enum.Font.SourceSans
    Symbol.Text = "-"
    Symbol.TextColor3 = Color3.new(1, 1, 1)
    Symbol.TextSize = 14

    List.Visible = false
    List.BackgroundColor3 = Menu.ItemColor
    List.BorderColor3 = Menu.BorderColor
    List.BorderMode = Enum.BorderMode.Inset
    List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(#ComboBox.Items * 15, 15, 90))
    List.Position = UDim2.fromOffset(20, 30)
    List.CanvasSize = UDim2.new()
    List.ScrollBarThickness = 4
    List.ScrollBarImageColor3 = Menu.Accent
    List.Parent = Label
    CreateStroke(List, Color3.new(), 1)
    AddEventListener(List, function()
        List.BackgroundColor3 = Menu.ItemColor
        List.BorderColor3 = Menu.BorderColor
        List.ScrollBarImageColor3 = Menu.Accent
    end)

    ListLayout.Parent = List

    ComboBox:Update(ComboBox.Value, ComboBox.Items)
    Container:UpdateSize(40)
    table.insert(Items, ComboBox)
    return #Items
end


function Menu.MultiSelect(Tab_Name, Container_Name, Name, Value_Items, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local Label = CreateLabel(Container.self, "MultiSelect", Name, UDim2.new(1, -10, 0, 15), UDim2.fromOffset(20, Container.GetHeight()))
    local Button = Instance.new("TextButton")
    local Symbol = Instance.new("TextLabel")
    local List = Instance.new("ScrollingFrame")
    local ListLayout = Instance.new("UIListLayout")

    local MultiSelect = {self = Label}
    MultiSelect.Name = Name
    MultiSelect.Class = "MultiSelect"
    MultiSelect.Tab = Tab_Name
    MultiSelect.Container = Container_Name
    MultiSelect.Index = #Items + 1
    MultiSelect.Callback = typeof(Callback) == "function" and Callback or function() end
    MultiSelect.Items = typeof(Value_Items) == "table" and Value_Items or {}
    MultiSelect.Value = {}


    local function GetSelectedItems()
        local Selected = {}
        for k, v in pairs(MultiSelect.Items) do
            if v == true then table.insert(Selected, k) end
        end
        return Selected
    end

    local function UpdateValue()
        MultiSelect.Value = GetSelectedItems()
        Button.Text = #MultiSelect.Value > 0 and table.concat(MultiSelect.Value, ", ") or "[...]"
    end

    local ItemObjects = {}
    local function AddItem(Name, Checked)
        local Button = Instance.new("TextButton")
        Button.BackgroundColor3 = Menu.ItemColor
        Button.BorderColor3 = Color3.new()
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 15)
        Button.Font = Enum.Font.SourceSans
        Button.Text = Name
        Button.TextColor3 = Checked and Menu.Accent or Color3.new(1, 1, 1)
        Button.TextSize = 14
        Button.Parent = List
        Button.TextTruncate = Enum.TextTruncate.AtEnd
        Button.MouseButton1Click:Connect(function()
            MultiSelect.Items[Name] = not MultiSelect.Items[Name]
            Button.TextColor3 = MultiSelect.Items[Name] and Menu.Accent or Color3.new(1, 1, 1)
            UpdateValue()
            MultiSelect.Callback(MultiSelect.Items) -- don't send value
        end)
        AddEventListener(Button, function()
            Button.BackgroundColor3 = Menu.ItemColor
            Button.TextColor3 = table.find(GetSelectedItems(), Button.Text) and Menu.Accent or Color3.new(1, 1, 1)
        end)

        if GetDictionaryLength(MultiSelect.Items) >= 6 then
            List.CanvasSize += UDim2.fromOffset(0, 15)
        end
        table.insert(ItemObjects, Button)
    end

    function MultiSelect:Update(Value)
        if typeof(Value) == "table" then
            MultiSelect.Items = Value
            UpdateValue()

            for _, Button in ipairs(ItemObjects) do
                Button:Destroy()
            end
            table.clear(ItemObjects)

            List.CanvasSize = UDim2.new()
            List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(GetDictionaryLength(MultiSelect.Items) * 15, 15, 90))
            for Name, Checked in pairs(MultiSelect.Items) do
                AddItem(tostring(Name), Checked)
            end
        else
            local Selected = GetSelectedItems()
            for _, Button in ipairs(ItemObjects) do
                local Checked = table.find(Selected, Button.Text)
                Button.TextColor3 = Checked and Menu.Accent or Color3.new(1, 1, 1)
            end
        end
    end

    function MultiSelect:SetVisible(Visible)
        if Visible then
            if not Label.Visible then
                Label.Visible = true
                Container:UpdateSize(40, Label)
            end
        else
            if Label.Visible then
                Label.Visible = false
                Container:UpdateSize(-40, Label)
            end
        end
    end

    function MultiSelect:SetValue(Value)
        MultiSelect:Update(Value)
    end

    function MultiSelect:SetLabel(Name)
        Label.Text = tostring(Name)
    end

    function MultiSelect:GetValue()
        return MultiSelect.Items
    end


    Button.BackgroundColor3 = Menu.ItemColor
    Button.BorderColor3 = Color3.new()
    Button.Position = UDim2.new(0, 0, 0, 20)
    Button.Size = UDim2.new(1, -40, 0, 15)
    Button.Font = Enum.Font.SourceSans
    Button.Text = "[...]"
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.TextTruncate = Enum.TextTruncate.AtEnd
    Button.Parent = Label
    Button.MouseButton1Click:Connect(function()
        UpdateSelected(List, Button, UDim2.fromOffset(0, 15))
        List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(GetDictionaryLength(MultiSelect.Items) * 15, 15, 90))
    end)
    AddEventListener(Button, function()
        Button.BackgroundColor3 = Menu.ItemColor
    end)

    Symbol.Name = "Symbol"
    Symbol.BackgroundTransparency = 1
    Symbol.Position = UDim2.new(1, -10, 0, 0)
    Symbol.Size = UDim2.new(0, 5, 1, 0)
    Symbol.Font = Enum.Font.SourceSans
    Symbol.Text = "-"
    Symbol.TextColor3 = Color3.new(1, 1, 1)
    Symbol.TextSize = 14
    Symbol.Parent = Button

    List.Visible = false
    List.BackgroundColor3 = Menu.ItemColor
    List.BorderColor3 = Menu.BorderColor
    List.BorderMode = Enum.BorderMode.Inset
    List.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.clamp(GetDictionaryLength(MultiSelect.Items) * 15, 15, 90))
    List.Position = UDim2.fromOffset(20, 30)
    List.CanvasSize = UDim2.new()
    List.ScrollBarThickness = 4
    List.ScrollBarImageColor3 = Menu.Accent
    List.Parent = Label
    CreateStroke(List, Color3.new(), 1)
    AddEventListener(List, function()
        List.BackgroundColor3 = Menu.ItemColor
        List.BorderColor3 = Menu.BorderColor
        List.ScrollBarImageColor3 = Menu.Accent
    end)

    ListLayout.Parent = List

    MultiSelect:Update(MultiSelect.Items)
    Container:UpdateSize(40)
    table.insert(Items, MultiSelect)
    return #Items
end


function Menu.ListBox(Tab_Name, Container_Name, Name, Multi, Value_Items, Callback)
    local Container = GetContainer(Tab_Name, Container_Name)
    local List = Instance.new("ScrollingFrame")
    local ListLayout = Instance.new("UIListLayout")

    local ListBox = {self = Label}
    ListBox.Name = Name
    ListBox.Class = "ListBox"
    ListBox.Tab = Tab_Name
    ListBox.Container = Container_Name
    ListBox.Index = #Items + 1
    ListBox.Method = Multi and "Multi" or "Default"
    ListBox.Items = typeof(Value_Items) == "table" and Value_Items or {}
    ListBox.Value = {}
    ListBox.Callback = typeof(Callback) == "function" and Callback or function() end

    local ItemObjects = {}

    local function GetSelectedItems()
        local Selected = {}
        for k, v in pairs(ListBox.Items) do
            if v == true then table.insert(Selected, k) end
        end
        return Selected
    end

    local function UpdateValue(Value)
        if ListBox.Method == "Default" then
            ListBox.Value = tostring(Value)
        else
            ListBox.Value = GetSelectedItems()
        end
    end

    local function AddItem(Name, Checked)
        local Button = Instance.new("TextButton")
        Button.BackgroundColor3 = Menu.ItemColor
        Button.BorderColor3 = Color3.new()
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 15)
        Button.Font = Enum.Font.SourceSans
        Button.Text = Name
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.TextTruncate = Enum.TextTruncate.AtEnd
        Button.Parent = List
        if ListBox.Method == "Default" then
            Button.TextColor3 = ListBox.Value == Button.Text and Menu.Accent or Color3.new(1, 1, 1)
            Button.MouseButton1Click:Connect(function()
                for _, v in ipairs(List:GetChildren()) do
                    if v:IsA("GuiButton") then
                        if v == Button then continue end
                        v.TextColor3 = Color3.new(1, 1, 1)
                    end
                end
                Button.TextColor3 = Menu.Accent
                UpdateValue(Button.Text)
                UpdateSelected()
                ListBox.Callback(ListBox.Value)
            end)
            AddEventListener(Button, function()
                Button.BackgroundColor3 = Menu.ItemColor
                if ListBox.Value == Button.Text then
                    Button.TextColor3 = Menu.Accent
                else
                    Button.TextColor3 = Color3.new(1, 1, 1)
                end
            end)
            
            if #ListBox.Items >= 6 then
                List.CanvasSize += UDim2.fromOffset(0, 15)
            end
        else
            Button.TextColor3 = Checked and Menu.Accent or Color3.new(1, 1, 1)
            Button.MouseButton1Click:Connect(function()
                ListBox.Items[Name] = not ListBox.Items[Name]
                Button.TextColor3 = ListBox.Items[Name] and Menu.Accent or Color3.new(1, 1, 1)
                UpdateValue()
                UpdateSelected()
                ListBox.Callback(ListBox.Value)
            end)
            AddEventListener(Button, function()
                Button.BackgroundColor3 = Menu.ItemColor
                if table.find(ListBox.Value, Name) then
                    Button.TextColor3 = Menu.Accent
                else
                    Button.TextColor3 = Color3.new(1, 1, 1)
                end
            end)
            
            if GetDictionaryLength(ListBox.Items) >= 10 then
                List.CanvasSize += UDim2.fromOffset(0, 15)
            end
        end
        table.insert(ItemObjects, Button)
    end

    function ListBox:Update(Value, Items)
        if ListBox.Method == "Default" then
            UpdateValue(Value)
        end
        if typeof(Items) == "table" then
            if ListBox.Method == "Multi" then
                ListBox.Items = Value
                UpdateValue()
            end
            for _, Button in ipairs(ItemObjects) do
                Button:Destroy()
            end
            table.clear(ItemObjects)

            List.CanvasSize = UDim2.new()
            List.Size = UDim2.new(1, -50, 0, 150)
            if ListBox.Method == "Default" then
                for _, Item in ipairs(ListBox.Items) do
                    AddItem(tostring(Item))
                end
            else
                for Name, Checked in pairs(ListBox.Items) do
                    AddItem(tostring(Name), Checked)
                end
            end
        else
            if ListBox.Method == "Default" then
                for _, Button in ipairs(ItemObjects) do
                    Button.TextColor3 = ListBox.Value == Button.Text and Menu.Accent or Color3.new(1, 1, 1)
                end
            else
                local Selected = GetSelectedItems()
                for _, Button in ipairs(ItemObjects) do
                    local Checked = table.find(Selected, Button.Text)
                    Button.TextColor3 = Checked and Menu.Accent or Color3.new(1, 1, 1)
                end
            end
        end
    end

    function ListBox:SetVisible(Visible)
        if Visible then
            if not List.Visible then
                List.Visible = true
                Container:UpdateSize(155, List)
            end
        else
            if List.Visible then
                List.Visible = false
                Container:UpdateSize(-155, List)
            end
        end
    end

    function ListBox:SetValue(Value, Items)
        if ListBox.Method == "Default" then
            if typeof(Items) == "table" then
                ListBox.Items = Items
            end
            ListBox:Update(Value, ListBox.Items)
        else
            ListBox:Update(Value)
        end
    end

    function ListBox:GetValue()
        return ListBox.Value
    end


    List.Name = "List"
    List.Active = true
    List.BackgroundColor3 = Menu.ItemColor
    List.BorderColor3 = Color3.new()
    List.Position = UDim2.fromOffset(20, Container.GetHeight())
    List.Size = UDim2.new(1, -50, 0, 150)
    List.CanvasSize = UDim2.new()
    List.ScrollBarThickness = 4
    List.ScrollBarImageColor3 = Menu.Accent
    List.Parent = Container.self
    CreateStroke(List, Color3.new(), 1)
    AddEventListener(List, function()
        List.BackgroundColor3 = Menu.ItemColor
        List.ScrollBarImageColor3 = Menu.Accent
    end)

    ListLayout.Parent = List

    if ListBox.Method == "Default" then
        ListBox:Update(ListBox.Value, ListBox.Items)
    else
        ListBox:Update(ListBox.Items)
    end
    Container:UpdateSize(155)
    table.insert(Items, ListBox)
    return #Items
end


function Menu.Notify(Content, Delay)
    assert(typeof(Content) == "string", "missing argument #1, (string expected got " .. typeof(Content) .. ")")
    local Delay = typeof(Delay) == "number" and Delay or 3

    local Text = Instance.new("TextLabel")
    local Notification = {
        self = Text,
        Class = "Notification",
        Index = #Notifications + 1,
        Status = 0
    }

    Text.Name = "Notification"
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.new(0.5, -100, 1, -150 - (Notification.Index * 15))
    Text.Size = UDim2.new(0, 0, 0, 15)
    Text.Text = Content
    Text.Font = Enum.Font.SourceSans
    Text.TextSize = 14
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.TextStrokeTransparency = 0.2
    Text.TextTransparency = 1
    Text.RichText = true
    Text.ZIndex = 4
    Text.Parent = Notifications_Frame

    function Notification:Update()
        --Text.Font = Menu.Font
    end

    local function CustomTweenOffset(Offset)
        spawn(function()
            local Steps = 33
            for i = 1, Steps do
                Text.Position += UDim2.fromOffset(Offset / Steps, 0)
                RunService.RenderStepped:Wait()
            end
        end)
    end

    function Notification:Destroy()
        table.remove(Notifications, 1)
        Text:Destroy()

        local Index = 1
        for _, v in ipairs(Notifications) do
            local self = v.self
            local Parent = self.Parent
            if not Parent then return end
            self.Position += UDim2.fromOffset(0, 15)
            Index += 1
        end
    end

    table.insert(Notifications, Notification)
    
    local TweenIn  = TweenService:Create(Text, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 0})
    local TweenOut = TweenService:Create(Text, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 1})
    
    TweenIn:Play()
    CustomTweenOffset(100)
    
    TweenIn.Completed:Connect(function()
        delay(Delay, function()
            TweenOut:Play()
            CustomTweenOffset(100)

            TweenOut.Completed:Connect(function()
                Notification:Destroy()
            end)
        end)
    end)
end


function Menu.Prompt(Message, Callback, ...)
    do
        local Prompt = Menu.Screen:FindFirstChild("Prompt")
        if Prompt then Prompt:Destroy() end
    end

    local Prompt = Instance.new("Frame")
    local Title = Instance.new("TextLabel")

    local Height = -20
    local function CreateButton(Text, Callback, ...)
        local Arguments = {...}

        local Callback = typeof(Callback) == "function" and Callback or function() end
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.BorderSizePixel = 0
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Size = UDim2.fromOffset(100, 20)
        Button.Position = UDim2.new(0.5, -50, 0.5, Height)
        Button.Text = Text
        Button.TextStrokeTransparency = 0.8
        Button.TextSize = 14
        Button.Font = Enum.Font.SourceSans
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Parent = Prompt
        Button.MouseButton1Click:Connect(function() Prompt:Destroy() Callback(unpack(Arguments)) end)
        CreateStroke(Button, Color3.new(), 1)
        Height += 25
    end

    CreateButton("OK", Callback, ...)
    CreateButton("Cancel", function() Prompt:Destroy() end)


    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 15)
    Title.Position = UDim2.new(0, 0, 0.5, -100)
    Title.Text = Message
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSans
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Parent = Prompt

    Prompt.Name = "Prompt"
    Prompt.BackgroundTransparency = 0.5
    Prompt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Prompt.BorderSizePixel = 0
    Prompt.Size = UDim2.new(1, 0, 1, 36)
    Prompt.Position = UDim2.fromOffset(0, -36)
    Prompt.Parent = Menu.Screen
end


function Menu.Spectators()
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local List = Instance.new("Frame")
    local ListLayout = Instance.new("UIListLayout")
    local Spectators = {self = Frame}
    Spectators.List = {}
    Menu.Spectators = Spectators


    Frame.Name = "Spectators"
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderMode = Enum.BorderMode.Inset
    Frame.Size = UDim2.fromOffset(250, 50)
    Frame.Position = UDim2.fromOffset(Menu.ScreenSize.X - Frame.Size.X.Offset, -36)
    Frame.Visible = false
    Frame.Parent = Menu.Screen
    CreateStroke(Frame, Color3.new(), 1)
    CreateLine(Frame, UDim2.new(0, 240, 0, 1), UDim2.new(0, 5, 0, 20))
    SetDraggable(Frame)
    
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.Size = UDim2.new(0, 240, 0, 15)
    Title.Font = Enum.Font.SourceSansSemibold
    Title.Text = "Spectators"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 14
    Title.Parent = Frame

    List.Name = "List"
    List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    List.BorderColor3 = Color3.fromRGB(40, 40, 40)
    List.BorderMode = Enum.BorderMode.Inset
    List.Position = UDim2.new(0, 4, 0, 30)
    List.Size = UDim2.new(0, 240, 0, 10)
    List.Parent = Frame

    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = List


    local function UpdateFrameSize()
        local Height = ListLayout.AbsoluteContentSize.Y + 5
        Spectators.self:TweenSize(UDim2.fromOffset(250, math.clamp(Height + 50, 50, 5000)), nil, nil, 0.3, true)
        Spectators.self.List:TweenSize(UDim2.fromOffset(240, math.clamp(Height, 10, 5000)), nil, nil, 0.3, true)
    end


    function Spectators.Add(Name, Icon)
        Spectators.Remove(Name)
        local Object = Instance.new("Frame")
        local NameLabel = Instance.new("TextLabel")
        local IconImage = Instance.new("ImageLabel")
        local Spectator = {self = Object}

        Object.Name = "Object"
        Object.BackgroundTransparency = 1
        Object.Position = UDim2.new(0, 5, 0, 30)
        Object.Size = UDim2.new(0, 240, 0, 15)
        Object.Parent = List

        NameLabel.Name = "Name"
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 20, 0, 0)
        NameLabel.Size = UDim2.new(0, 230, 1, 0)
        NameLabel.Font = Enum.Font.SourceSans
        NameLabel.Text = tostring(Name)
        NameLabel.TextColor3 = Color3.new(1, 1, 1)
        NameLabel.TextSize = 14
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Object

        IconImage.Name = "Icon"
        IconImage.BackgroundTransparency = 1
        IconImage.Image = Icon or ""
        IconImage.Size = UDim2.new(0, 15, 0, 15)
        IconImage.Position = UDim2.new(0, 2, 0, 0)
        IconImage.Parent = Object

        Spectators.List[Name] = Spectator
        UpdateFrameSize()
    end


    function Spectators.Remove(Name)
        if Spectators.List[Name] then
            Spectators.List[Name].self:Destroy()
            Spectators.List[Name] = nil
        end
        UpdateFrameSize()
    end


    function Spectators:SetVisible(Visible)
        Spectators.self.Visible = Visible
    end


    return Spectators
end


function Menu.Keybinds()
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local List = Instance.new("Frame")
    local ListLayout = Instance.new("UIListLayout")
    local Keybinds = {self = Frame}
    Keybinds.List = {}
    Menu.Keybinds = Keybinds


    Frame.Name = "Keybinds"
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderMode = Enum.BorderMode.Inset
    Frame.Size = UDim2.fromOffset(250, 45)
    Frame.Position = UDim2.fromOffset(Menu.ScreenSize.X - Frame.Size.X.Offset, -36)
    Frame.Visible = false
    Frame.Parent = Menu.Screen
    CreateStroke(Frame, Color3.new(), 1)
    CreateLine(Frame, UDim2.new(0, 240, 0, 1), UDim2.new(0, 5, 0, 20))
    SetDraggable(Frame)

    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.Size = UDim2.new(0, 240, 0, 15)
    Title.Font = Enum.Font.SourceSansSemibold
    Title.Text = "Key binds"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 14
    Title.Parent = Frame

    List.Name = "List"
    List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    List.BorderColor3 = Color3.fromRGB(40, 40, 40)
    List.BorderMode = Enum.BorderMode.Inset
    List.Position = UDim2.new(0, 4, 0, 30)
    List.Size = UDim2.new(0, 240, 0, 10)
    List.Parent = Frame

    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.Parent = List

    local function UpdateFrameSize()
        local Height = ListLayout.AbsoluteContentSize.Y + 5
        Keybinds.self:TweenSize(UDim2.fromOffset(250, math.clamp(Height + 45, 45, 5000)), nil, nil, 0.3, true)
        Keybinds.self.List:TweenSize(UDim2.fromOffset(240, math.clamp(Height, 10, 5000)), nil, nil, 0.3, true)
    end

    function Keybinds.Add(Name, State)
        Keybinds.Remove(Name)
        local Object = Instance.new("Frame")
        local NameLabel = Instance.new("TextLabel")
        local StateLabel = Instance.new("TextLabel")
        local Keybind = {self = Object}

        Object.Name = "Object"
        Object.BackgroundTransparency = 1
        Object.Position = UDim2.new(0, 5, 0, 30)
        Object.Size = UDim2.new(0, 230, 0, 15)
        Object.Parent = List

        NameLabel.Name = "Indicator"
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 5, 0, 0)
        NameLabel.Size = UDim2.new(0, 180, 1, 0)
        NameLabel.Font = Enum.Font.SourceSans
        NameLabel.Text = Name
        NameLabel.TextColor3 = Color3.new(1, 1, 1)
        NameLabel.TextSize = 14
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Object

        StateLabel.Name = "State"
        StateLabel.BackgroundTransparency = 1
        StateLabel.Position = UDim2.new(0, 190, 0, 0)
        StateLabel.Size = UDim2.new(0, 40, 1, 0)
        StateLabel.Font = Enum.Font.SourceSans
        StateLabel.Text = "[" .. tostring(State) .. "]"
        StateLabel.TextColor3 = Color3.new(1, 1, 1)
        StateLabel.TextSize = 14
        StateLabel.TextXAlignment = Enum.TextXAlignment.Right
        StateLabel.Parent = Object

        
        function Keybind:Update(State)
            StateLabel.Text = "[" .. tostring(State) .. "]"
        end

        function Keybind:SetVisible(Visible)
            if Visible then
                if not Object.Visible then
                    Object.Visible = true
                end
            else
                if Object.Visible then
                    Object.Visible = false
                end
            end
            UpdateFrameSize()
        end

        
        Keybinds.List[Name] = Keybind
        UpdateFrameSize()

        return Keybind
    end

    function Keybinds.Remove(Name)
        if Keybinds.List[Name] then
            Keybinds.List[Name].self:Destroy()
            Keybinds.List[Name] = nil
        end
        UpdateFrameSize()
    end

    function Keybinds:SetVisible(Visible)
        Keybinds.self.Visible = Visible
    end

    return Keybinds
end


function Menu.Indicators()
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local List = Instance.new("Frame")
    local ListLayout = Instance.new("UIListLayout")

    local Indicators = {self = Frame}
    Indicators.List = {}
    Menu.Indicators = Indicators

    Frame.Name = "Indicators"
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderMode = Enum.BorderMode.Inset
    Frame.Size = UDim2.fromOffset(250, 45)
    Frame.Position = UDim2.fromOffset(Menu.ScreenSize.X - Frame.Size.X.Offset, -36)
    Frame.Visible = false
    Frame.Parent = Menu.Screen
    CreateStroke(Frame, Color3.new(), 1)
    CreateLine(Frame, UDim2.new(0, 240, 0, 1), UDim2.new(0, 5, 0, 20))
    SetDraggable(Frame)

    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.Size = UDim2.new(0, 240, 0, 15)
    Title.Font = Enum.Font.SourceSansSemibold
    Title.Text = "Indicators"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 14
    Title.Parent = Frame

    List.Name = "List"
    List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    List.BorderColor3 = Color3.fromRGB(40, 40, 40)
    List.BorderMode = Enum.BorderMode.Inset
    List.Position = UDim2.new(0, 4, 0, 30)
    List.Size = UDim2.new(0, 240, 0, 10)
    List.Parent = Frame

    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)
    ListLayout.Parent = List

    local function UpdateFrameSize()
        local Height = ListLayout.AbsoluteContentSize.Y + 5
        Indicators.self:TweenSize(UDim2.fromOffset(250, math.clamp(Height + 45, 45, 5000)), nil, nil, 0.3, true)
        Indicators.self.List:TweenSize(UDim2.fromOffset(240, math.clamp(Height, 10, 5000)), nil, nil, 0.3, true)
    end

    function Indicators.Add(Name, Type, Value, ...)
        Indicators.Remove(Name)
        local Object = Instance.new("Frame")
        local NameLabel = Instance.new("TextLabel")
        local StateLabel = Instance.new("TextLabel")

        local Indicator = {self = Object}
        Indicator.Type = Type
        Indicator.Value = Value

        Object.Name = "Object"
        Object.BackgroundTransparency = 1
        Object.Size = UDim2.new(0, 230, 0, 30)
        Object.Parent = Indicators.self.List
        
        NameLabel.Name = "Indicator"
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 5, 0, 0)
        NameLabel.Size = UDim2.new(0, 130, 0, 15)
        NameLabel.Font = Enum.Font.SourceSans
        NameLabel.Text = Name
        NameLabel.TextColor3 = Color3.new(1, 1, 1)
        NameLabel.TextSize = 14
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Indicator.self
    
        StateLabel.Name = "State"
        StateLabel.BackgroundTransparency = 1
        StateLabel.Position = UDim2.new(0, 180, 0, 0)
        StateLabel.Size = UDim2.new(0, 40, 0, 15)
        StateLabel.Font = Enum.Font.SourceSans
        StateLabel.Text = "[" .. tostring(Value) .. "]"
        StateLabel.TextColor3 = Color3.new(1, 1, 1)
        StateLabel.TextSize = 14
        StateLabel.TextXAlignment = Enum.TextXAlignment.Right
        StateLabel.Parent = Indicator.self


        if Type == "Bar" then
            local ObjectBase = Instance.new("Frame")
            local ValueLabel = Instance.new("TextLabel")

            ObjectBase.Name = "Bar"
            ObjectBase.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            ObjectBase.BorderColor3 = Color3.new()
            ObjectBase.Position = UDim2.new(0, 0, 0, 20)
            ObjectBase.Size = UDim2.new(0, 220, 0, 5)
            ObjectBase.Parent = Indicator.self
    
            ValueLabel.Name = "Value"
            ValueLabel.BorderSizePixel = 0
            ValueLabel.BackgroundColor3 = Menu.Accent
            ValueLabel.Text = ""
            ValueLabel.Parent = ObjectBase
            AddEventListener(ValueLabel, function()
                ValueLabel.BackgroundColor3 = Menu.Accent
            end)
        else
            Object.Size = UDim2.new(0, 230, 0, 15)
        end


        function Indicator:Update(Value, ...)
            if Indicators.List[Name] then
                if Type == "Text" then
                    Indicator.Value = Value
                    Object.State.Text = Value
                elseif Type == "Bar" then
                    local Min, Max = select(1, ...)
                    Indicator.Min = typeof(Min) == "number" and Min or Indicator.Min
                    Indicator.Max = typeof(Max) == "number" and Max or Indicator.Max

                    local Scale = (Indicator.Value - Indicator.Min) / (Indicator.Max - Indicator.Min)
                    Object.State.Text = "[" .. tostring(Indicator.Value) .. "]"
                    Object.Bar.Value.Size = UDim2.new(math.clamp(Scale, 0, 1), 0, 0, 5)
                end
                Indicator.Value = Value
            end
        end


        function Indicator:SetVisible(Visible)
            if Visible then
                if not Object.Visible then
                    Object.Visible = true
                end
            else
                if Object.Visible then
                    Object.Visible = false
                end
            end
            UpdateFrameSize()
        end

        
        Indicator:Update(Indicator.Value, ...)
        Indicators.List[Name] = Indicator
        UpdateFrameSize()
        return Indicator
    end


    function Indicators.Remove(Name)
        if Indicators.List[Name] then
            Indicators.List[Name].self:Destroy()
            Indicators.List[Name] = nil
        end
        UpdateFrameSize()
    end


    function Indicators:SetVisible(Visible)
        Indicators.self.Visible = Visible
    end


    return Indicators
end


function Menu.Watermark()
    local Watermark = {}
    Watermark.Frame = Instance.new("Frame")
    Watermark.Title = Instance.new("TextLabel")
    Menu.Watermark = Watermark

    Watermark.Frame.Name = "Watermark"
    Watermark.Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Watermark.Frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Watermark.Frame.BorderMode = Enum.BorderMode.Inset
    Watermark.Frame.Size = UDim2.fromOffset(250, 20)
    Watermark.Frame.Position = UDim2.fromOffset((Menu.ScreenSize.X - Watermark.Frame.Size.X.Offset) - 50, -25)
    Watermark.Frame.Visible = false
    Watermark.Frame.Parent = Menu.Screen
    CreateStroke(Watermark.Frame, Color3.new(), 1)
    CreateLine(Watermark.Frame, UDim2.new(0, 245, 0, 1), UDim2.new(0, 2, 0, 15))
    SetDraggable(Watermark.Frame)

    Watermark.Title.Name = "Title"
    Watermark.Title.BackgroundTransparency = 1
    Watermark.Title.Position = UDim2.new(0, 5, 0, -1)
    Watermark.Title.Size = UDim2.new(0, 240, 0, 15)
    Watermark.Title.Font = Enum.Font.SourceSansSemibold
    Watermark.Title.Text = ""
    Watermark.Title.TextColor3 = Color3.new(1, 1, 1)
    Watermark.Title.TextSize = 14
    Watermark.Title.RichText = true
    Watermark.Title.Parent = Watermark.Frame

    function Watermark:Update(Text)
        Watermark.Title.Text = tostring(Text)
    end

    function Watermark:SetVisible(Visible)
        Watermark.Frame.Visible = Visible
    end

    return Watermark
end


UserInput.InputBegan:Connect(function(Input, Process) end)
UserInput.InputEnded:Connect(function(Input)
    if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
        Dragging = {Gui = nil, True = false}
    end
end)
RunService.RenderStepped:Connect(function(Step)
    local Menu_Frame = Menu.Screen.Menu
    Menu_Frame.Position = UDim2.fromOffset(
        math.clamp(Menu_Frame.AbsolutePosition.X,   0, math.clamp(Menu.ScreenSize.X - Menu_Frame.AbsoluteSize.X, 0, Menu.ScreenSize.X    )),
        math.clamp(Menu_Frame.AbsolutePosition.Y, -36, math.clamp(Menu.ScreenSize.Y - Menu_Frame.AbsoluteSize.Y, 0, Menu.ScreenSize.Y - 36))
    )
    local Selected_Frame = Selected.Frame
    local Selected_Item = Selected.Item
    if (Selected_Frame and Selected_Item) then
        local Offset = Selected.Offset or UDim2.fromOffset()
        local Position = UDim2.fromOffset(Selected_Item.AbsolutePosition.X, Selected_Item.AbsolutePosition.Y)
        Selected_Frame.Position = Position + Offset
    end

    if Scaling.True then
        MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        local Origin = Scaling.Origin
        local Size = Scaling.Size

        if Origin and Size then
            local Location = UserInput:GetMouseLocation()
            local NewSize = Location + (Size - Origin)

            Menu:SetSize(Vector2.new(
                math.clamp(NewSize.X, Menu.MinSize.X, Menu.MaxSize.X),
                math.clamp(NewSize.Y, Menu.MinSize.Y, Menu.MaxSize.Y)
            ))
        end
    else
        MenuScaler_Button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    end

    -- Uuh do this IN ur own script for the other windows I guess
    Menu.Hue += math.clamp(Step, 0, 1)
    if Menu.Hue >= 1 then Menu.Hue = 0 end
end)
Menu.Screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    Menu.ScreenSize = Menu.Screen.AbsoluteSize
end)

return Menu
