local Menu = {}


local Configs = import "Configs"
local MenuClass = import "Libraries/Menu"


Menu.Accent = Config.Menu.Accent
Menu.Screen = MenuClass.Screen
Menu.Line = MenuClass.Line
Menu.Notify = MenuClass.Notify
Menu.FindItem = MenuClass.FindItem
Menu.SetVisible = MenuClass.SetVisible
Menu.SetTitle = MenuClass.SetTitle
Menu.SetTab = MenuClass.SetTab
Menu.IsVisible = false


function Menu.AddAudioButton(Id)
    local Asset = GetAssetInfo(Id)
    local Name = Asset and Asset.Name

    if typeof(Name) == "string" then
        local AudioButton = Instance.new("TextButton")
        AudioButton.BackgroundColor3 = Color3.new(1, 1, 1)
        AudioButton.Size = UDim2.new(1, 0, 0, 22)
        AudioButton.Text = Name
        AudioButton.TextColor3 = Color3.new()
        AudioButton.Font = Enum.Font.SourceSans
        AudioButton.TextSize = 22
        AudioButton.Parent = Menu.BoomboxFrame.List
        AudioButton.MouseButton1Click:Connect(function()
            pcall(function()
                PlayerGui.BoomBoxu.Entry.TextBox.Text = Id
                LastAudio = Id
                for _, Object in ipairs(Character:GetChildren()) do
                    if Object.Name == "BoomBox" then Object.RemoteEvent:FireServer("play", Id) end
                end
            end)
        end)

        Menu.BoomboxFrame.List.CanvasSize += UDim2.fromOffset(0, 22)
        return AudioButton
    end
end


function Menu:SetVisible(Visible: boolean)
    Menu.IsVisible = typeof(Visible) == "boolean" and Visible or false
    return MenuClass:SetVisible(Visible)
end


function Menu:Init()
    Menu.Watermark = MenuClass.Watermark()
    Menu.Indicators = MenuClass.Indicators()
    Menu.Keybinds = MenuClass.Keybinds()
    Menu.BoomboxFrame = Instance.new("Frame")
    Menu.CommandBar = Instance.new("TextBox")
end


function Menu:Refresh()
    local Config = Configs.Config
    -- There ARE LIKE 200 MENU ITEMS TO UPDATE???

    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Enabled"):SetValue(Config.Aimbot.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Hotkey", "Aimbot key"):SetValue(Config.Aimbot.Key)
    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Auto fire"):SetValue(Config.AutoFire.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Slider", "Auto fire range"):SetValue(Config.AutoFire.Range)
    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Auto fire velocity check"):SetValue(Config.AutoFire.VelocityCheck.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Slider", "Auto fire max velocity"):SetValue(Config.AutoFire.VelocityCheck.MaxVelocity)
    Menu:FindItem("Combat", "Aimbot", "CheckBox", "Camera lock"):SetValue(Config.CameraLock.Enabled)
    Menu:FindItem("Combat", "Aimbot", "Hotkey", "Camera lock key"):SetValue(Config.CameraLock.Key)
    Menu:FindItem("Combat", "Aimbot", "Slider", "Velocity multiplier"):SetValue(Config.Aimbot.VelocityMultiplier)
    Menu:FindItem("Combat", "Aimbot", "ComboBox", "Target hitbox"):SetValue(Config.Aimbot.HitBox)
    Menu:FindItem("Combat", "Aimbot", "ComboBox", "Target selection"):SetValue(Config.Aimbot.TargetSelection)

    Menu:FindItem("Combat", "Other", "CheckBox", "Always ground hit"):SetValue(Config.AlwaysGroundHit.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Stomp spam"):SetValue(Config.StompSpam.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Auto attack"):SetValue(false)
    Menu:FindItem("Combat", "Other", "CheckBox", "Auto stomp"):SetValue(Config.AutoStomp.Enabled)
    Menu:FindItem("Combat", "Other", "CheckBox", "Stomp spam"):SetValue(Config.StompSpam.Enabled)
    Menu:FindItem("Combat", "Other", "Slider", "Auto stomp range"):SetValue(Config.AutoStomp.Range)
    Menu:FindItem("Combat", "Other", "ComboBox", "Auto stomp target"):SetValue(Config.AutoStomp.Target)

    Menu:FindItem("Visuals", "ESP", "CheckBox", "Enabled"):SetValue(Config.ESP.Enabled)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Target lock"):SetValue(Config.ESP.ForceTarget)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Target override"):SetValue(Config.ESP.TargetOverride.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Target color"):SetValue(Config.ESP.TargetOverride.Color, 1 - Config.ESP.TargetOverride.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Whitelist override"):SetValue(Config.ESP.WhitelistOverride.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Whitelist color"):SetValue(Config.ESP.WhitelistOverride.Color, 1 - Config.ESP.WhitelistOverride.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Box"):SetValue(Config.ESP.Box.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Box color"):SetValue(Config.ESP.Box.Color, 1 - Config.ESP.Box.Transparency)
    Menu:FindItem("Visuals", "ESP", "ComboBox", "Box type"):SetValue(Config.ESP.Box.Type)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Skeleton"):SetValue(Config.ESP.Skeleton.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Skeleton color"):SetValue(Config.ESP.Skeleton.Color, 1 - Config.ESP.Skeleton.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Chams"):SetValue(Config.ESP.Chams.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams color"):SetValue(Config.ESP.Chams.Color, Config.ESP.Chams.Transparency)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams walls color"):SetValue(Config.ESP.Chams.WallsColor, 1 - Config.ESP.Chams.WallsTransparency)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Chams outline color"):SetValue(Config.ESP.Chams.OutlineColor, Config.ESP.Chams.OutlineTransparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Chams auto outline color"):SetValue(Config.ESP.Chams.AutoOutlineColor)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Knocked out chams"):SetValue(Config.ESP.Chams.KnockedOut.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked out chams color"):SetValue(Config.ESP.Chams.KnockedOut.Color, Config.ESP.Chams.KnockedOut.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Snapline"):SetValue(Config.ESP.Snaplines.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Snapline color"):SetValue(Config.ESP.Snaplines.Color, 1 - Config.ESP.Snaplines.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Snapline offscreen"):SetValue(Config.ESP.Snaplines.OffScreen)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Health bar"):SetValue(Config.ESP.Bars.Health.Enabled)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Health bar auto color"):SetValue(Config.ESP.Bars.Health.AutoColor)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Health bar color"):SetValue(Config.ESP.Bars.Health.Color, 1 - Config.ESP.Bars.Health.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Knocked out bar"):SetValue(Config.ESP.Bars.KnockedOut.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Knocked out bar color"):SetValue(Config.ESP.Bars.KnockedOut.Color, 1 - Config.ESP.Bars.KnockedOut.Transparency)
    Menu:FindItem("Visuals", "ESP", "CheckBox", "Ammo bar"):SetValue(Config.ESP.Bars.Ammo.Enabled)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Ammo bar color"):SetValue(Config.ESP.Bars.Ammo.Color, 1 - Config.ESP.Bars.Ammo.Transparency)
    Menu:FindItem("Visuals", "ESP", "MultiSelect", "Flags"):SetValue({
        Name = Config.ESP.Flags.Name.Enabled,
        Weapon = Config.ESP.Flags.Weapon.Text.Enabled,
        Ammo = Config.ESP.Flags.Ammo.Enabled,
        Vest = Config.ESP.Flags.Vest.Enabled,
        Health = Config.ESP.Flags.Health.Enabled,
        Stamina = Config.ESP.Flags.Stamina.Enabled,
        ["Knocked out"] = Config.ESP.Flags.KnockedOut.Enabled,
        Distance = Config.ESP.Flags.Distance.Enabled,
        Velocity = Config.ESP.Flags.Velocity.Enabled
    })
    Menu:FindItem("Visuals", "ESP", "ComboBox", "Font"):SetValue(Config.ESP.Font.Font)
    Menu:FindItem("Visuals", "ESP", "ColorPicker", "Font color"):SetValue(Config.ESP.Font.Color, 1 - Config.ESP.Font.Transparency)
    Menu:FindItem("Visuals", "ESP", "Slider", "Font size"):SetValue(Config.ESP.Font.Size)

    Menu:FindItem("Visuals", "Local esp", "CheckBox", "Chams"):SetValue(Config.ESP.Chams.Local.Enabled)
    Menu:FindItem("Visuals", "Local esp", "ColorPicker", "Chams color"):SetValue(Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Transparency)
    Menu:FindItem("Visuals", "Local esp", "Slider", "Chams reflectance"):SetValue(Config.ESP.Chams.Local.Reflectance)
    Menu:FindItem("Visuals", "Local esp", "ComboBox", "Chams material"):SetValue(Config.ESP.Chams.Local.Material)

    Menu:FindItem("Visuals", "Item esp", "CheckBox", "Enabled"):SetValue(Config.ESP.Item.Enabled)
    Menu:FindItem("Visuals", "Item esp", "CheckBox", "Name"):SetValue(Config.ESP.Item.Flags.Name.Enabled)
    Menu:FindItem("Visuals", "Item esp", "CheckBox", "Distance"):SetValue(Config.ESP.Item.Flags.Distance.Enabled)
    Menu:FindItem("Visuals", "Item esp", "CheckBox", "Snapline"):SetValue(Config.ESP.Item.Snaplines.Enabled)
    Menu:FindItem("Visuals", "Item esp", "ColorPicker", "Snapline color"):SetValue(Config.ESP.Item.Snaplines.Color, 1 - Config.ESP.Item.Snaplines.Transparency)
    Menu:FindItem("Visuals", "Item esp", "CheckBox", "Icons"):SetValue(Config.ESP.Item.Flags.Icon.Enabled)
    Menu:FindItem("Visuals", "Item esp", "ComboBox", "Font"):SetValue(Config.ESP.Item.Font.Font)
    Menu:FindItem("Visuals", "Item esp", "ColorPicker", "Font color"):SetValue(Config.ESP.Item.Font.Color, 1 - Config.ESP.Item.Font.Transparency)
    Menu:FindItem("Visuals", "Item esp", "Slider", "Font size"):SetValue(Config.ESP.Item.Font.Size)

    Menu:FindItem("Visuals", "Hit markers", "CheckBox", "Hit markers"):SetValue(Config.HitMarkers.Enabled)
    Menu:FindItem("Visuals", "Hit markers", "ComboBox", "Hit markers type"):SetValue(Config.HitMarkers.Type)
    Menu:FindItem("Visuals", "Hit markers", "ColorPicker", "Hit markers color"):SetValue(Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency)
    Menu:FindItem("Visuals", "Hit markers", "Slider", "Hit markers size"):SetValue(Config.HitMarkers.Size)
    Menu:FindItem("Visuals", "Hit markers", "CheckBox", "Hit sound"):SetValue(Config.HitMarkers.Sound)

    Menu:FindItem("Visuals", "World", "CheckBox", "Ambient changer"):SetValue(Config.Enviorment.Ambient.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Ambient"):SetValue(Config.Enviorment.Ambient.Colors.Ambient, 0)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Outdoor ambient"):SetValue(Config.Enviorment.Ambient.Colors.OutdoorAmbient, 0)
    Menu:FindItem("Visuals", "World", "CheckBox", "World time changer"):SetValue(Config.Enviorment.Time.Enabled)
    Menu:FindItem("Visuals", "World", "Slider", "World time"):SetValue(Config.Enviorment.Time.Value)
    Menu:FindItem("Visuals", "World", "CheckBox", "Saturation changer"):SetValue(Config.Enviorment.Saturation.Enabled)
    Menu:FindItem("Visuals", "World", "Slider", "Saturation"):SetValue(Config.Enviorment.Saturation.Value)
    Menu:FindItem("Visuals", "World", "CheckBox", "Bullet impacts"):SetValue(Config.BulletImpact.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Bullet impacts color"):SetValue(Config.BulletImpact.Color, 1 - Config.BulletImpact.Transparency)
    Menu:FindItem("Visuals", "World", "CheckBox", "Bullet tracers"):SetValue(Config.BulletTracers.Enabled)
    Menu:FindItem("Visuals", "World", "ColorPicker", "Bullet tracers color"):SetValue(Config.BulletTracers.Color)
    Menu:FindItem("Visuals", "World", "Slider", "Bullet tracers lifetime"):SetValue(Config.BulletTracers.Lifetime)
    Menu:FindItem("Visuals", "World", "CheckBox", "Disable bullet trails"):SetValue(Config.BulletTracers.DisableTrails)
    Menu:FindItem("Visuals", "World", "ComboBox", "Skybox"):SetValue(Config.Enviorment.Skybox.Value)

    Menu:FindItem("Visuals", "Other", "CheckBox", "Max zoom changer"):SetValue(Config.Zoom.Enabled)
    Menu:FindItem("Visuals", "Other", "Slider", "Max zoom"):SetValue(Config.Zoom.Value)
    Menu:FindItem("Visuals", "Other", "CheckBox", "Field of view changer"):SetValue(Config.FieldOfView.Enabled)
    Menu:FindItem("Visuals", "Other", "Slider", "Field of view"):SetValue(Config.FieldOfView.Value)
    Menu:FindItem("Visuals", "Other", "CheckBox", "First person"):SetValue(Config.FirstPerson.Enabled)

    Menu:FindItem("Visuals", "Interface", "CheckBox", "Aimbot vector indicator"):SetValue(Config.Aimbot.Visualize)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Field of view circle"):SetValue(Config.Interface.FieldOfViewCircle.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Field of view circle filled"):SetValue(Config.Interface.FieldOfViewCircle.Filled)
    Menu:FindItem("Visuals", "Interface", "Slider", "Field of view circle sides"):SetValue(Config.Interface.FieldOfViewCircle.NumSides)
    Menu:FindItem("Visuals", "Interface", "ColorPicker", "Field of view circle color"):SetValue(Config.Interface.FieldOfViewCircle.Color, 1 - Config.Interface.FieldOfViewCircle.Transparency)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Watermark"):SetValue(Config.Interface.Watermark.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Chat"):SetValue(Config.Interface.Chat.Enabled)
    Menu:FindItem("Visuals", "Interface", "Slider", "Chat position"):SetValue(Config.Interface.Chat.Position)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Indicators"):SetValue(Config.Interface.Indicators.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Keybinds"):SetValue(Config.Interface.Keybinds.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Show ammo"):SetValue(Config.Interface.ShowAmmo.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Remove ui elements"):SetValue(Config.Interface.RemoveUIElements.Enabled)
    Menu:FindItem("Visuals", "Interface", "CheckBox", "Bar fade"):SetValue(Config.Interface.BarFade.Enabled)

    Menu:FindItem("Visuals", "Weapons", "CheckBox", "Gun chams"):SetValue(Config.GunChams.Enabled)
    Menu:FindItem("Visuals", "Weapons", "ColorPicker", "Chams color"):SetValue(Config.GunChams.Color, Config.GunChams.Transparency)
    Menu:FindItem("Visuals", "Weapons", "Slider", "Chams reflectance"):SetValue(Config.GunChams.Reflectance)
    Menu:FindItem("Visuals", "Weapons", "ComboBox", "Chams material"):SetValue(Config.GunChams.Material)

    Menu:FindItem("Visuals", "Hats", "CheckBox", "Hat color changer"):SetValue(Config.HatChanger.Enabled)
    Menu:FindItem("Visuals", "Hats", "CheckBox", "Hat color sequence"):SetValue(Config.HatChanger.Sequence)
    Menu:FindItem("Visuals", "Hats", "Slider", "Hat color rate"):SetValue(Config.HatChanger.Speed)
    Menu:FindItem("Visuals", "Hats", "ColorPicker", "Hat color"):SetValue(Config.HatChanger.Color)

    Menu:FindItem("Player", "Movement", "Slider", "Walk speed"):SetValue(Config.WalkSpeed.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Jump power"):SetValue(Config.JumpPower.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Run speed"):SetValue(Config.RunSpeed.Value)
    Menu:FindItem("Player", "Movement", "Slider", "Crouch speed"):SetValue(Config.CrouchSpeed.Value)
    Menu:FindItem("Player", "Movement", "CheckBox", "Blink"):SetValue(Config.Blink.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Blink key"):SetValue(Config.Blink.Key)
    Menu:FindItem("Player", "Movement", "Slider", "Blink speed"):SetValue(Config.Blink.Speed)
    Menu:FindItem("Player", "Movement", "CheckBox", "Flight"):SetValue(Config.Flight.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Flight key"):SetValue(Config.Flight.Key)
    Menu:FindItem("Player", "Movement", "Slider", "Flight speed"):SetValue(Config.Flight.Speed)
    Menu:FindItem("Player", "Movement", "CheckBox", "Float"):SetValue(Config.Float.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Float key"):SetValue(Config.Float.Key)
    Menu:FindItem("Player", "Movement", "CheckBox", "Infinite jump"):SetValue(Config.InfiniteJump.Enabled)
    Menu:FindItem("Player", "Movement", "CheckBox", "Noclip"):SetValue(Config.Noclip.Enabled)
    Menu:FindItem("Player", "Movement", "Hotkey", "Noclip key"):SetValue(Config.Noclip.Key)
    Menu:FindItem("Player", "Movement", "CheckBox", "Disable tool collision"):SetValue(Config.DisableToolCollision.Enabled)

    Menu:FindItem("Player", "Other", "CheckBox", "No knock out"):SetValue(Config.NoKnockOut.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "No slow"):SetValue(Config.NoSlow.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Anti ground hit"):SetValue(Config.AntiGroundHit.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Anti fling"):SetValue(Config.AntiFling.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Hide tools"):SetValue(false)
    Menu:FindItem("Player", "Other", "CheckBox", "Death teleport"):SetValue(Config.DeathTeleport.Enabled)
    Menu:FindItem("Player", "Other", "CheckBox", "Flipped"):SetValue(Config.Flipped.Enabled)

    Menu:FindItem("Player", "Anti-aim", "CheckBox", "Enabled"):SetValue(Config.AntiAim.Enabled)
    Menu:FindItem("Player", "Anti-aim", "Hotkey", "Anti aim key"):SetValue(Config.AntiAim.Key)
    Menu:FindItem("Player", "Anti-aim", "ComboBox", "Anti aim type"):SetValue(Config.AntiAim.Type)

    Menu:FindItem("Misc", "Main", "CheckBox", "Auto cash"):SetValue(Config.AutoCash.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto farm"):SetValue(Config.AutoFarm.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Auto farm table"):SetValue(Config.AutoFarm.Table)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto play"):SetValue(Config.AutoPlay.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto reconnect"):SetValue(Config.AutoReconnect.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Anti chat log"):SetValue(Config.AntiChatLog.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto sort"):SetValue(Config.AutoSort.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Auto sort order"):SetValue(Config.AutoSort.Order)
    Menu:FindItem("Misc", "Main", "CheckBox", "Auto heal"):SetValue(Config.AutoHeal.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Click open"):SetValue(Config.ClickOpen.Enabled)
    --Menu:FindItem("Misc", "Main", "CheckBox", "Chat spam"):SetValue(Spamming)
    Menu:FindItem("Misc", "Main", "CheckBox", "Event logs"):SetValue(Config.EventLogs.Enabled)
    Menu:FindItem("Misc", "Main", "MultiSelect", "Event log flags"):SetValue(Config.EventLogs.Flags)
    Menu:FindItem("Misc", "Main", "CheckBox", "Hide sprays"):SetValue(Config.HideSprays.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Close doors"):SetValue(Config.CloseDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Open doors"):SetValue(Config.OpenDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Knock doors"):SetValue(Config.KnockDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "No doors"):SetValue(Config.NoDoors.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "No seats"):SetValue(Config.NoSeats.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Door aura"):SetValue(Config.DoorAura.Enabled)
    Menu:FindItem("Misc", "Main", "CheckBox", "Door menu"):SetValue(Config.DoorMenu.Enabled)

    Menu:FindItem("Misc", "Animations", "CheckBox", "Run"):SetValue(Config.Animations.Run.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Run animation"):SetValue(Config.Animations.Run.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Glock"):SetValue(Config.Animations.Glock.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Glock animation"):SetValue(Config.Animations.Glock.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Uzi"):SetValue(Config.Animations.Uzi.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Uzi animation"):SetValue(Config.Animations.Uzi.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Shotty"):SetValue(Config.Animations.Shotty.Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Shotty animation"):SetValue(Config.Animations.Shotty.Style)
    Menu:FindItem("Misc", "Animations", "CheckBox", "Sawed off"):SetValue(Config.Animations["Sawed Off"].Enabled)
    Menu:FindItem("Misc", "Animations", "ComboBox", "Sawed off animation"):SetValue(Config.Animations["Sawed Off"].Style)
    
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Infinite stamina"):SetValue(Config.InfiniteStamina.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Infinite force field"):SetValue(Config.InfiniteForceField.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Teleport bypass"):SetValue(Config.TeleportBypass.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "God"):SetValue(Config.God.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Click spam"):SetValue(Config.ClickSpam.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Lag on dragged"):SetValue(Config.LagOnDragged.Enabled)
    Menu:FindItem("Misc", "Exploits", "CheckBox", "Fake lag"):SetValue(Config.FakeLag.Enabled)
    Menu:FindItem("Misc", "Exploits", "Slider", "Fake lag limit"):SetValue(Config.FakeLag.Limit)

    --Menu:FindItem("Misc", "Players", "ListBox", "Target"):SetValue(SelectedTarget, Players:GetPlayers())
    Menu:FindItem("Misc", "Players", "CheckBox", "Target lock"):SetValue(TargetLock)
    Menu:FindItem("Misc", "Players", "Slider", "Priority"):SetValue(0)
    Menu:FindItem("Misc", "Players", "CheckBox", "Attach"):SetValue(Config.Attach.Enabled)
    Menu:FindItem("Misc", "Players", "Slider", "Attach rate"):SetValue(Config.Attach.Rate)
    Menu:FindItem("Misc", "Players", "CheckBox", "View"):SetValue(Config.View.Enabled)
    Menu:FindItem("Misc", "Players", "CheckBox", "Follow"):SetValue(Config.Follow.Enabled)
    --Menu:FindItem("Misc", "Players", "CheckBox", "Whitelisted"):SetValue(false)
    --Menu:FindItem("Misc", "Players", "CheckBox", "Owner"):SetValue(false)

    Menu:FindItem("Misc", "Clan tag", "CheckBox", "Enabled"):SetValue(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan tag", "CheckBox", "Enabled"):SetValue(Config.ClanTag.Enabled)
    Menu:FindItem("Misc", "Clan tag", "CheckBox", "Visualize"):SetValue(Config.ClanTag.Visualize)
    Menu:FindItem("Misc", "Clan tag", "TextBox", "Tag"):SetValue(Config.ClanTag.Tag)
    Menu:FindItem("Misc", "Clan tag", "TextBox", "Prefix"):SetValue(Config.ClanTag.Prefix)
    Menu:FindItem("Misc", "Clan tag", "TextBox", "Suffix"):SetValue(Config.ClanTag.Suffix)
    Menu:FindItem("Misc", "Clan tag", "Slider", "Tag speed"):SetValue(Config.ClanTag.Speed)
    Menu:FindItem("Misc", "Clan tag", "ComboBox", "Tag type"):SetValue(Config.ClanTag.Type)
    Menu:FindItem("Misc", "Clan tag", "TextBox", "Spotify token"):SetValue(Config.ClanTag.SpotifyToken)

    Menu:FindItem("Settings", "Menu", "ColorPicker", "Menu accent"):SetValue(Config.Menu.Accent)
    Menu:FindItem("Settings", "Menu", "Hotkey", "Prefix"):SetValue(Config.Prefix)
    Menu:FindItem("Settings", "Menu", "Hotkey", "Menu key"):SetValue(Config.Menu.Key)
    Menu:FindItem("Settings", "Menu", "ComboBox", "Console font color"):SetValue(Config.Console.Accent, {"Cyan", "Blue", "Green", "Red", "Magenta", "Yellow", "White"})

    Menu.Keybinds.List.Aimbot:Update(Config.Aimbot.Enabled and "on" or "off")
    Menu.Keybinds.List["Camera Lock"]:Update(Config.CameraLock.Enabled and "on" or "off")
    Menu.Keybinds.List.Flight:Update(Config.Flight.Enabled and "on" or "off")
    Menu.Keybinds.List.Blink:Update(Config.Blink.Enabled and "on" or "off")
    Menu.Keybinds.List.Float:Update(Config.Float.Enabled and "on" or "off")
    Menu.Keybinds.List.Noclip:Update(Config.Noclip.Enabled and "on" or "off")
    Menu.Keybinds.List["Anti Aim"]:Update(Config.AntiAim.Enabled and "on" or "off")
	
    Menu.Keybinds.List.Aimbot:SetVisible(Config.Aimbot.Enabled)
    Menu.Keybinds.List["Camera Lock"]:SetVisible(Config.CameraLock.Enabled)
    Menu.Keybinds.List.Flight:SetVisible(Config.Flight.Enabled)
    Menu.Keybinds.List.Blink:SetVisible(Config.Blink.Enabled)
    Menu.Keybinds.List.Float:SetVisible(Config.Float.Enabled)
    Menu.Keybinds.List.Noclip:SetVisible(Config.Noclip.Enabled)
    Menu.Keybinds.List["Anti Aim"]:SetVisible(Config.AntiAim.Enabled)

    Menu.Watermark:SetVisible(Config.Interface.Watermark.Enabled)
    Menu.Indicators:SetVisible(Config.Interface.Indicators.Enabled)
    Menu.Keybinds:SetVisible(Config.Interface.Keybinds.Enabled)
end


function Menu:Draw()
    Menu.Screen.Name = "ponyhook"
    Menu.SetTitle(Menu, "ponyhook" .. Utils.GetRichTextColor(".cc", Config.Menu.Accent:ToHex())) -- Can't namecall since synapse is shit

    Menu.Tab("Combat")
    Menu.Tab("Visuals")
    Menu.Tab("Player")
    Menu.Tab("Misc")
    Menu.Tab("Settings")

    Menu.Container("Combat", "Aimbot", "Left")
    Menu.Container("Combat", "Other", "Right")
    Menu.Container("Player", "Movement", "Left")
    Menu.Container("Player", "Other", "Right")
    Menu.Container("Player", "Anti-aim", "Right")
    Menu.Container("Visuals", "ESP", "Left")
    Menu.Container("Visuals", "Local esp", "Left")
    Menu.Container("Visuals", "Item esp", "Left")
    Menu.Container("Visuals", "Hit markers", "Left")
    Menu.Container("Visuals", "Other", "Right")
    Menu.Container("Visuals", "Interface", "Right")
    Menu.Container("Visuals", "World", "Right")
    Menu.Container("Visuals", "Weapons", "Right")
    Menu.Container("Visuals", "Hats", "Right"):SetVisible(Utils.IsOriginal)
    Menu.Container("Misc", "Main", "Left")
    Menu.Container("Misc", "Animations", "Left")
    Menu.Container("Misc", "Exploits", "Left")
    Menu.Container("Misc", "Players", "Right")
    Menu.Container("Misc", "Clan tag", "Right"):SetVisible(Utils.IsOriginal)
    Menu.Container("Settings", "Demo recorder", "Left")
    Menu.Container("Settings", "Settings", "Left")
    Menu.Container("Settings", "Menu", "Left")
    Menu.Container("Settings", "Configs", "Right")

    Menu.CheckBox("Combat", "Aimbot", "Enabled", Config.Aimbot.Enabled, function(Bool)
        AimbotToggle()
    end)

    Menu.Hotkey("Combat", "Aimbot", "Aimbot key", Config.Aimbot.Key, function(KeyCode, State)
        Config.Aimbot.Key = KeyCode
        --[[
        Config.Keybinds.Client = {
            Key = KeyCode,
            State = State
        }]]
        ContextAction:BindAction("aimbotToggle", AimbotToggle, false, KeyCode)
    end)

    Menu.CheckBox("Combat", "Aimbot", "Auto fire", Config.AutoFire.Enabled, function(Bool)
        AutoFireToggle()
    end)
    Menu.Slider("Combat", "Aimbot", "Auto fire range", 5, 150, Config.AutoFire.Range, nil, 1, function(Value)
        Config.AutoFire.Range = Value
    end)
    Menu.CheckBox("Combat", "Aimbot", "Auto fire velocity check", Config.AutoFire.VelocityCheck.Enabled, function(Bool)
        Config.AutoFire.VelocityCheck.Enabled = Bool
    end)
    Menu.Slider("Combat", "Aimbot", "Auto fire max velocity", 0, 100, Config.AutoFire.VelocityCheck.MaxVelocity, nil, 1, function(Value)
    Config.AutoFire.VelocityCheck.MaxVelocity = Value
    end)

    Menu.CheckBox("Combat", "Aimbot", "Camera lock", Config.CameraLock.Enabled, function(Bool)
        Config.CameraLock.Enabled = Bool
    end)
    Menu.Hotkey("Combat", "Aimbot", "Camera lock key", Config.CameraLock.Key, function(KeyCode)
        Config.CameraLock.Key = KeyCode
        ContextAction:BindAction("cameraLockToggle", CameraLockToggle, false, Config.CameraLock.Key)
    end)
    Menu.Slider("Combat", "Aimbot", "Radius", 20, 300, Config.Aimbot.Radius, nil, 1, function(Value)
        Config.Aimbot.Radius = Value
    end)
    Menu.Slider("Combat", "Aimbot", "Velocity multiplier", 1, 3, Config.Aimbot.VelocityMultiplier, "x", 1, function(Value)
        Config.Aimbot.VelocityMultiplier = Value
    end)
    Menu.ComboBox("Combat", "Aimbot", "Target hitbox", Config.Aimbot.HitBox, {"Head", "Torso", "Root"}, function(String)
        Config.Aimbot.HitBox = String
    end)
    Menu.ComboBox("Combat", "Aimbot", "Target selection", Config.Aimbot.TargetSelection, {"Near player", "Near mouse"}, function(String)
        Config.Aimbot.TargetSelection = String
    end)
    Menu.CheckBox("Combat", "Other", "Always ground hit", Config.AlwaysGroundHit.Enabled, function(Bool)
        Config.AlwaysGroundHit.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Stomp spam", Config.StompSpam.Enabled, function(Bool)
        Config.StompSpam.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Auto attack", false, function(Bool)
        Config.AutoAttack.Enabled = Bool
    end)
    Menu.CheckBox("Combat", "Other", "Auto stomp", Config.AutoStomp.Enabled, function(Bool)
        Config.AutoStomp.Enabled = Bool
        --Menu.Indicators.List["Automatic Stomp"]:Update(Config.AutoStomp.Enabled)
    end)
    Menu.Slider("Combat", "Other", "Auto stomp range", 5, 50, Config.AutoStomp.Distance, nil, 1, function(Value)
        Config.AutoStomp.Distance = Value
    end)
    Menu.ComboBox("Combat", "Other", "Auto stomp target", Config.AutoStomp.Target, {"Target", "Whitelist", "All"}, function(String)
        Config.AutoStomp.Target = String
    end)
    Menu.Slider("Player", "Movement", "Walk speed", 0, 500, Config.WalkSpeed.Value, nil, 1, function(Value)
        Config.WalkSpeed.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Jump power", 0, 500, Config.JumpPower.Value, nil, 1, function(Value)
        Config.JumpPower.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Run speed", 0, 500, Config.RunSpeed.Value, nil, 1, function(Value)
        Config.RunSpeed.Value = Value
    end)
    Menu.Slider("Player", "Movement", "Crouch speed", 0, 500, Config.CrouchSpeed.Value, nil, 1, function(Value)
        Config.CrouchSpeed.Value = Value
    end)
    Menu.CheckBox("Player", "Movement", "Blink", Config.Blink.Enabled, function(Bool)
        BlinkToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Blink key", Config.Blink.Key, function(KeyCode)
        Config.Blink.Key = KeyCode
        ContextAction:BindAction("blinkToggle", BlinkToggle, false, Config.Blink.Key)
    end)
    Menu.Slider("Player", "Movement", "Blink speed", 0.1, 20, Config.Blink.Speed, nil, 1, function(Value)
        Config.Blink.Speed = Value
    end)
    Menu.CheckBox("Player", "Movement", "Flight", Config.Flight.Enabled, function(Bool)
        FlyToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Flight key", Config.Flight.Key, function(KeyCode)
        Config.Flight.Key = KeyCode
        ContextAction:BindAction("flyToggle", FlyToggle, false, KeyCode)
    end)
    Menu.Slider("Player", "Movement", "Flight speed", 0.1, 20, Config.Flight.Speed, nil, 1, function(Value)
        Config.Flight.Speed = Value
    end)
    Menu.CheckBox("Player", "Movement", "Float", Config.Float.Enabled, function(Bool)
        FloatToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Float key", Config.Float.Key, function(KeyCode)
        Config.Float.Key = KeyCode
        ContextAction:BindAction("floatToggle", FloatToggle, false, KeyCode)
    end)
    Menu.CheckBox("Player", "Movement", "Infinite jump", Config.InfiniteJump.Enabled, function(Bool)
        Config.InfiniteJump.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Movement", "Noclip", Config.Noclip.Enabled, function(Bool)
        NoclipToggle()
    end)
    Menu.Hotkey("Player", "Movement", "Noclip key", Config.Noclip.Key, function(KeyCode)
        Config.Noclip.Key = KeyCode
        ContextAction:BindAction("noclipToggle", NoclipToggle, false, KeyCode)
    end)
    Menu.CheckBox("Player", "Movement", "Disable tool collision", Config.DisableToolCollision.Enabled, function(Bool)
        Config.DisableToolCollision.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "No knock out", Config.NoKnockOut.Enabled, function(Bool)
        Config.NoKnockOut.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "No slow", Config.NoSlow.Enabled, function(Bool)
        Config.NoSlow.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Anti ground hit", Config.AntiGroundHit.Enabled, function(Bool)
        Config.AntiGroundHit.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Anti fling", Config.AntiFling.Enabled, function(Bool)
        Config.AntiFling.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Hide tools", HideTools, function(Bool) -- ??
        HideTools = Bool
    end)
    Menu.CheckBox("Player", "Other", "Death teleport", Config.DeathTeleport.Enabled, function(Bool)
        Config.DeathTeleport.Enabled = Bool
    end)
    Menu.CheckBox("Player", "Other", "Flipped", Config.Flipped.Enabled, function(Bool)
        Config.Flipped.Enabled = Bool
    end)

    Menu.CheckBox("Player", "Anti-aim", "Enabled", Config.AntiAim.Enabled, function(Bool)
        AntiAimToggle()
        UpdateAntiAim()
    end)
    Menu.Hotkey("Player", "Anti-aim", "Anti aim key", Config.AntiAim.Key, function(KeyCode)
        Config.AntiAim.Key = KeyCode
        ContextAction:BindAction("antiAimToggle", AntiAimToggle, false, Config.AntiAim.Key)
    end)
    Menu.ComboBox("Player", "Anti-aim", "Anti aim type", Config.AntiAim.Type, {"Velocity"}, function(String)
        Config.AntiAim.Type = String
        Menu.Keybinds.List["Anti Aim"]:Update("[" .. Config.AntiAim.Type .. "]")
        UpdateAntiAim()
    end)

    Menu.CheckBox("Visuals", "ESP", "Enabled", Config.ESP.Enabled, function(Bool)
        Config.ESP.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Target lock", Config.ESP.ForceTarget, function(Bool)
        Config.ESP.ForceTarget = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Target override", Config.ESP.TargetOverride.Enabled, function(Bool)
        Config.ESP.TargetOverride.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Target color", Config.ESP.TargetOverride.Color, Config.ESP.TargetOverride.Transparency, function(Color, Transparency)
        Config.ESP.TargetOverride.Color = Color
        Config.ESP.TargetOverride.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Whitelist override", Config.ESP.WhitelistOverride.Enabled, function(Bool)
        Config.ESP.WhitelistOverride.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Whitelist color", Config.ESP.WhitelistOverride.Color, Config.ESP.WhitelistOverride.Transparency, function(Color, Transparency)
        Config.ESP.WhitelistOverride.Color = Color
        Config.ESP.WhitelistOverride.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Box", Config.ESP.Box.Enabled, function(Bool)
        Config.ESP.Box.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Box color", Config.ESP.Box.Color, 1 - Config.ESP.Box.Transparency, function(Color, Transparency)
        Config.ESP.Box.Color = Color
        Config.ESP.Box.Transparency = 1 - Transparency
    end)
    Menu.ComboBox("Visuals", "ESP", "Box type", Config.ESP.Box.Type, {"Default", "Corners"}, function(String)
        Config.ESP.Box.Type = Value
    end)
    Menu.CheckBox("Visuals", "ESP", "Skeleton", Config.ESP.Skeleton.Enabled, function(Bool)
        Config.ESP.Skeleton.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Skeleton color", Config.ESP.Skeleton.Color, 1 - Config.ESP.Skeleton.Transparency, function(Color, Transparency)
        Config.ESP.Skeleton.Color = Color
        Config.ESP.Skeleton.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Chams", Config.ESP.Chams.Enabled, function(Bool)
        Config.ESP.Chams.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Chams auto outline color", Config.ESP.Chams.AutoOutlineColor, function(Bool)
        Config.ESP.Chams.AutoOutlineColor = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Chams color", Config.ESP.Chams.Color, Config.ESP.Chams.Transparency, function(Color, Transparency)
        Config.ESP.Chams.Color = Color
        Config.ESP.Chams.Transparency = Transparency
    end)
    Menu.ColorPicker("Visuals", "ESP", "Chams walls color", Config.ESP.Chams.WallsColor, Config.ESP.Chams.WallsTransparency, function(Color, Transparency)
        Config.ESP.Chams.WallsColor = Color
        Config.ESP.Chams.WallsTransparency = Transparency
    end)
    Menu.ColorPicker("Visuals", "ESP", "Chams outline color", Config.ESP.Chams.OutlineColor, Config.ESP.Chams.OutlineTransparency, function(Color, Transparency)
        Config.ESP.Chams.OutlineColor = Color
        Config.ESP.Chams.OutlineTransparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Knocked out chams", Config.ESP.Chams.KnockedOut.Enabled, function(Bool)
        Config.ESP.Chams.KnockedOut.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Knocked out chams color", Config.ESP.Chams.KnockedOut.Color, Config.ESP.Chams.KnockedOut.Transparency, function(Color, Transparency)
        Config.ESP.Chams.KnockedOut.Color = Color
        Config.ESP.Chams.KnockedOut.Transparency = Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Snapline", Config.ESP.Snaplines.Enabled, function(Bool)
        Config.ESP.Snaplines.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Snapline color", Config.ESP.Snaplines.Color, 1 - Config.ESP.Snaplines.Transparency, function(Color, Transparency)
        Config.ESP.Snaplines.Color = Color
        Config.ESP.Snaplines.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Snapline offscreen", Config.ESP.Snaplines.OffScreen, function(Bool)
        Config.ESP.Snaplines.OffScreen = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "OOF arrows", Config.ESP.Arrows.Enabled, function(Bool)
        Config.ESP.Arrows.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "OOF arrows color", Config.ESP.Arrows.Color, 1 - Config.ESP.Arrows.Transparency, function(Color, Transparency)
        Config.ESP.Arrows.Color = Color
        Config.ESP.Arrows.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "ESP", "OOF arrows offset", 5, 200, Config.ESP.Arrows.Offset, "px", 1, function(Int)
        Config.ESP.Arrows.Offset = Int
    end)
    Menu.CheckBox("Visuals", "ESP", "Health bar", Config.ESP.Bars.Health.Enabled, function(Bool)
        Config.ESP.Bars.Health.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "ESP", "Health bar auto color", Config.ESP.Bars.Health.AutoColor, function(Bool)
        Config.ESP.Bars.Health.AutoColor = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Health bar color", Config.ESP.Bars.Health.Color, 1 - Config.ESP.Bars.Health.Transparency, function(Color, Transparency)
        Config.ESP.Bars.Health.Color = Color
        Config.ESP.Bars.Health.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Knocked out bar", Config.ESP.Bars.KnockedOut.Enabled, function(Bool)
        Config.ESP.Bars.KnockedOut.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Knocked out bar color", Config.ESP.Bars.KnockedOut.Color, 1 - Config.ESP.Bars.KnockedOut.Transparency, function(Color, Transparency)
        Config.ESP.Bars.KnockedOut.Color = Color
        Config.ESP.Bars.KnockedOut.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "ESP", "Ammo bar", Config.ESP.Bars.Ammo.Enabled, function(Bool)
        Config.ESP.Bars.Ammo.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "ESP", "Ammo bar color", Config.ESP.Bars.Ammo.Color, 1 - Config.ESP.Bars.Ammo.Transparency, function(Color, Transparency)
        Config.ESP.Bars.Ammo.Color = Color
        Config.ESP.Bars.Ammo.Transparency = 1 - Transparency
    end)
    Menu.MultiSelect("Visuals", "ESP", "Flags", {
        Name = Config.ESP.Flags.Name.Enabled,
        Weapon = Config.ESP.Flags.Weapon.Text.Enabled,
        Ammo = Config.ESP.Flags.Ammo.Enabled,
        Vest = Config.ESP.Flags.Vest.Enabled,
        Health = Config.ESP.Flags.Health.Enabled,
        Stamina = Config.ESP.Flags.Stamina.Enabled,
        ["Knocked out"] = Config.ESP.Flags.KnockedOut.Enabled,
        Distance = Config.ESP.Flags.Distance.Enabled,
        Velocity = Config.ESP.Flags.Velocity.Enabled
    }, function(Value)
        Config.ESP.Flags.Name.Enabled = Value["Name"]
        Config.ESP.Flags.Weapon.Text.Enabled = Value["Weapon"]
        Config.ESP.Flags.Ammo.Enabled = Value["Ammo"]
        Config.ESP.Flags.Vest.Enabled = Value["Vest"]
        Config.ESP.Flags.Health.Enabled = Value["Health"]
        Config.ESP.Flags.Stamina.Enabled = Value["Stamina"]
        Config.ESP.Flags.KnockedOut.Enabled = Value["Knocked out"]
        Config.ESP.Flags.Distance.Enabled = Value["Distance"]
        Config.ESP.Flags.Velocity.Enabled = Value["Velocity"]
    end)
    Menu.ComboBox("Visuals", "ESP", "Font", Config.ESP.Font.Font, {"UI", "System", "Plex", "Monospace"}, function(String)
        Config.ESP.Font.Font = String
    end)
    Menu.ColorPicker("Visuals", "ESP", "Font color", Config.ESP.Font.Color, 1 - Config.ESP.Font.Transparency, function(Color, Transparency)
        Config.ESP.Font.Color = Color
        Config.ESP.Font.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "ESP", "Font size", 10, 32, Config.ESP.Font.Size, "px", 0, function(Value)
        Config.ESP.Font.Size = Value
    end)

    Menu.CheckBox("Visuals", "Local esp", "Chams", Config.ESP.Chams.Local.Enabled, function(Bool)
        Config.ESP.Chams.Local.Enabled = Bool
        if Bool then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.ColorPicker("Visuals", "Local esp", "Chams color", Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Transparency, function(Color, Transparency)
        Config.ESP.Chams.Local.Color = Color
        Config.ESP.Chams.Local.Transparency = Transparency
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Color, Config.ESP.Chams.Local.Material, Config.ESP.Chams.Local.Reflectance, Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.Slider("Visuals", "Local esp", "Chams reflectance", 0, 1, Config.ESP.Chams.Local.Reflectance, "", 2, function(Value)
        Config.ESP.Chams.Local.Reflectance = Value
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, Config.ESP.Chams.Local.Material, Value, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.ComboBox("Visuals", "Local esp", "Chams material", Config.ESP.Chams.Local.Material, {"Force field", "Glass", "Plastic"}, function(String)
        Config.ESP.Chams.Local.Material = String
        if Config.ESP.Chams.Local.Enabled then
            SetPlayerChams(Player, Config.ESP.Chams.Local.Color, String, Config.ESP.Chams.Local.Reflectance, Config.ESP.Chams.Local.Transparency, true)
        else
            SetPlayerChams(Player)
        end
    end)
    Menu.CheckBox("Visuals", "Local esp", "Visualize fake lag", Config.FakeLag.Visualize, function(Bool)
        Config.FakeLag.Visualize = Bool
    end)
    Menu.ColorPicker("Visuals", "Local esp", "Visualize color", Config.FakeLag.Color, 1 - Config.FakeLag.Transparency, function(Color, Transparency)
        Config.FakeLag.Color = Color
        Config.FakeLag.Transparency = 1 - Transparency
    end)

    Menu.CheckBox("Visuals", "Item esp", "Enabled", Config.ESP.Item.Enabled, function(Bool)
        Config.ESP.Item.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item esp", "Name", Config.ESP.Item.Flags.Name.Enabled, function(Bool)
        Config.ESP.Item.Flags.Name.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item esp", "Distance", Config.ESP.Item.Flags.Distance.Enabled, function(Bool)
        Config.ESP.Item.Flags.Distance.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Item esp", "Snapline", Config.ESP.Item.Snaplines.Enabled, function(Bool)
        Config.ESP.Item.Snaplines.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "Item esp", "Snapline color", Config.ESP.Item.Snaplines.Color, 1 - Config.ESP.Item.Snaplines.Transparency, function(Color, Transparency)
        Config.ESP.Item.Snaplines.Color = Color
        Config.ESP.Item.Snaplines.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "Item esp", "Icons", Config.ESP.Item.Flags.Icon.Enabled, function(Bool)
        Config.ESP.Item.Flags.Icon.Enabled = Bool
    end)
    Menu.ComboBox("Visuals", "Item esp", "Font", Config.ESP.Item.Font.Font, {"UI", "System", "Plex", "Monospace"}, function(String)
        Config.ESP.Item.Font.Font = String
    end)
    Menu.ColorPicker("Visuals", "Item esp", "Font color", Config.ESP.Item.Font.Color, 1 - Config.ESP.Item.Font.Transparency, function(Color, Transparency)
        Config.ESP.Item.Font.Color = Color
        Config.ESP.Item.Font.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "Item esp", "Font size", 10, 32, Config.ESP.Item.Font.Size, "px", 0, function(Value)
        Config.ESP.Item.Font.Size = Value
    end)
    Menu.CheckBox("Visuals", "Hit markers", "Hit markers", Config.HitMarkers.Enabled, function(Bool)
        Config.HitMarkers.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "Hit markers", "Hit markers color", Config.HitMarkers.Color, 1 - Config.HitMarkers.Transparency, function(Color, Transparency)
        Config.HitMarkers.Color = Color
        Config.HitMarkers.Transparency = 1 - Transparency
    end)
    Menu.Slider("Visuals", "Hit markers", "Hit markers size", 5, 20, Config.HitMarkers.Size, nil, 0, function(Value)
        Config.HitMarkers.Size = Value
    end)
    Menu.ComboBox("Visuals", "Hit markers", "Hit markers type", Config.HitMarkers.Type, {"Crosshair", "Model", "Crosshair + model"}, function(String)
        Config.HitMarkers.Type = String
    end)
    Menu.CheckBox("Visuals", "Hit markers", "Hit sound", Config.HitSound.Enabled, function(Bool)
        Config.HitSound.Enabled = Bool
    end)

    Menu.CheckBox("Visuals", "World", "Ambient changer", Config.Enviorment.Ambient.Enabled, function(Bool)
        Config.Enviorment.Ambient.Enabled = Bool
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient.Colors.Ambient
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient.Colors.OutdoorAmbient
        else
            Lighting.Ambient = Lighting.DefaultAmbient
            Lighting.OutdoorAmbient = Lighting.DefaultOutdoorAmbient
        end
    end)
    Menu.ColorPicker("Visuals", "World", "Ambient", Config.Enviorment.Ambient.Colors.Ambient, 0, function(Color)
        Config.Enviorment.Ambient.Colors.Ambient = Color
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient.Colors.Ambient
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient.Colors.OutdoorAmbient
        end
    end)
    Menu.ColorPicker("Visuals", "World", "Outdoor ambient", Config.Enviorment.Ambient.Colors.OutdoorAmbient, 0, function(Color)
        Config.Enviorment.Ambient.Colors.OutdoorAmbient = Color
        if Config.Enviorment.Ambient.Enabled then
            Lighting.Ambient = Config.Enviorment.Ambient.Colors.Ambient
            Lighting.OutdoorAmbient = Config.Enviorment.Ambient.Colors.OutdoorAmbient
        end
    end)
    Menu.CheckBox("Visuals", "World", "World time changer", Config.Enviorment.Time.Enabled, function(Bool)
        Config.Enviorment.Time.Enabled = Bool
    end)
    Menu.Slider("Visuals", "World", "World time", 0, 24, Config.Enviorment.Time.Value, "h", 1, function(Value)
        Config.Enviorment.Time.Value = math.round(Value)
    end)
    Menu.CheckBox("Visuals", "World", "Saturation changer", Config.Enviorment.Saturation.Enabled, function(Bool)
        Config.Enviorment.Saturation.Enabled = Bool
        Lighting.ColorEffect.Saturation = Config.Enviorment.Saturation.Enabled and Config.Enviorment.Saturation.Value or 0
    end)
    Menu.Slider("Visuals", "World", "Saturation", -1, 0, Config.Enviorment.Saturation.Value, nil, 2, function(Value)
        Config.Enviorment.Saturation.Value = Value
        Lighting.ColorEffect.Saturation = Config.Enviorment.Saturation.Enabled and Config.Enviorment.Saturation.Value or 0
    end)
    Menu.CheckBox("Visuals", "World", "Brick trajectory", Config.BrickTrajectory.Enabled, function(Bool)
        Config.BrickTrajectory.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "World", "Brick trajectory color", Config.BrickTrajectory.Color, Config.BrickTrajectory.Transparency, function(Color, Transparency)
        Config.BrickTrajectory.Color = Color
        Config.BrickTrajectory.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "World", "Bullet impacts", Config.BulletImpact.Enabled, function(Bool)
        Config.BulletImpact.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "World", "Bullet impacts color", Config.BulletImpact.Color, Config.BulletImpact.Transparency, function(Color, Transparency)
        Config.BulletImpact.Color = Color
        Config.BulletImpact.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "World", "Bullet tracers", Config.BulletTracers.Enabled, function(Bool)
        Config.BulletTracers.Enabled = Bool
    end)
    Menu.ColorPicker("Visuals", "World", "Bullet tracers color", Config.BulletTracers.Color, 0, function(Color)
        Config.BulletTracers.Color = Color
    end)
    Menu.Slider("Visuals", "World", "Bullet tracers lifetime", 0, 6000, Config.BulletTracers.Lifetime, "ms", 1, function(Value)
        Config.BulletTracers.Lifetime = Value
    end)
    Menu.CheckBox("Visuals", "World", "Disable bullet trails", Config.BulletTracers.DisableTrails, function(Bool)
        Config.BulletTracers.DisableTrails = Bool
    end)
    Menu.ComboBox("Visuals", "World", "Skybox", Config.Enviorment.Skybox.Value, GetFolders("ponyhook/Games/The Streets/bin/skyboxes/").Names, function(String)
        Config.Enviorment.Skybox.Value = String
        Lighting:UpdateSkybox(Config.Enviorment.Skybox.Value)
    end)

    Menu.CheckBox("Visuals", "Other", "Max zoom changer", Config.Zoom.Enabled, function(Bool)
        Config.Zoom.Enabled = Bool
        Player.CameraMaxZoomDistance = Config.Zoom.Enabled and Config.Zoom.Value or 20
    end)
    Menu.Slider("Visuals", "Other", "Max zoom", 0, 1000, Config.Zoom.Value, nil, 1, function(Value)
        Config.Zoom.Value = Value
        Player.CameraMaxZoomDistance = Config.Zoom.Enabled and Config.Zoom.Value or 20
    end)
    Menu.CheckBox("Visuals", "Other", "Field of view changer", Config.FieldOfView.Enabled, function(Bool)
        Config.FieldOfView.Enabled = Bool
        Camera.FieldOfView = Config.FieldOfView.Enabled and Config.FieldOfView.Value or 70
    end)
    Menu.Slider("Visuals", "Other", "Field of view", 0, 120, Config.FieldOfView.Value, "°", 1, function(Value)
        Config.FieldOfView.Value = Value
        Camera.FieldOfView = Config.FieldOfView.Enabled and Config.FieldOfView.Value or 70
    end)
    Menu.CheckBox("Visuals", "Other", "First person", Config.FirstPerson.Enabled, function(Bool)
        Config.FirstPerson.Enabled = Bool
        if Bool then
            AddFirstPersonEventListeners()
        else
            for _, v in ipairs(Events.FirstPerson) do v:Disconnect() end
            table.clear(Events.FirstPerson)
        end
    end)

    Menu.CheckBox("Visuals", "Interface", "Aimbot vector indicator", Config.Aimbot.Visualize, function(Bool)
        Config.Aimbot.Visualize = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Field of view circle", Config.Interface.FieldOfViewCircle.Enabled, function(Bool)
        Config.Interface.FieldOfViewCircle.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Field of view circle filled", Config.Interface.FieldOfViewCircle.Filled, function(Bool)
        Config.Interface.FieldOfViewCircle.Filled = Bool
    end)
    Menu.Slider("Visuals", "Interface", "Field of view circle sides", 0, 50, Config.Interface.FieldOfViewCircle.NumSides, nil, 0, function(Value)
        Config.Interface.FieldOfViewCircle.NumSides = Value
    end)
    Menu.ColorPicker("Visuals", "Interface", "Field of view circle color", Config.Interface.FieldOfViewCircle.Color, 1 - Config.Interface.FieldOfViewCircle.Transparency, function(Color, Transparency)
        Config.Interface.FieldOfViewCircle.Color = Color
        Config.Interface.FieldOfViewCircle.Transparency = 1 - Transparency
    end)
    Menu.CheckBox("Visuals", "Interface", "Watermark", Config.Interface.Watermark.Enabled, function(Bool)
        Config.Interface.Watermark.Enabled = Bool
        Menu.Watermark:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Chat", Config.Interface.Chat.Enabled, function(Bool)
        Config.Interface.Chat.Enabled = Bool
        ChatFrame.Visible = Config.Interface.Chat.Enabled
    end)
    Menu.GetItem(Menu, Menu.Slider("Visuals", "Interface", "Chat position", 0, 500, Config.Interface.Chat.Position, "", 0, function(Value)
        Config.Interface.Chat.Position = Value 
        ChatFrame.Position = UDim2.new(0, 0, 1, Config.Interface.Chat.Position)
    end)):SetVisible(false) -- "attempt to index number with SetVisible" thats if I dont do the Menu.GetItem thing ???
    Menu.CheckBox("Visuals", "Interface", "Indicators", Config.Interface.Indicators.Enabled, function(Bool)
        Config.Interface.Indicators.Enabled = Bool
        Menu.Indicators:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Keybinds", Config.Interface.Keybinds.Enabled, function(Bool)
        Config.Interface.Keybinds.Enabled = Bool
        Menu.Keybinds:SetVisible(Bool)
    end)
    Menu.CheckBox("Visuals", "Interface", "Show ammo", Config.Interface.ShowAmmo.Enabled, function(Bool)
        Config.Interface.ShowAmmo.Enabled = Bool
    end)
    Menu.CheckBox("Visuals", "Interface", "Remove ui elements", Config.Interface.RemoveUIElements.Enabled, function(Bool)
        Config.Interface.RemoveUIElements.Enabled = Bool
        UpdateInterface()
    end)
    Menu.CheckBox("Visuals", "Interface", "Bar fade", Config.Interface.BarFade.Enabled, function(Bool)
        Config.Interface.BarFade.Enabled = Bool
        UpdateInterface()
    end)

    Menu.CheckBox("Visuals", "Weapons", "Gun chams", Config.GunChams.Enabled, function(Bool)
        Config.GunChams.Enabled = Bool
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.ColorPicker("Visuals", "Weapons", "Chams color", Config.GunChams.Color, Config.GunChams.Transparency, function(Color, Transparency)
        Config.GunChams.Color = Color
        Config.GunChams.Transparency = Transparency
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.Slider("Visuals", "Weapons", "Chams reflectance", 0, 1, Config.GunChams.Reflectance, nil, 1, function(Value)
        Config.GunChams.Reflectance = Value
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)
    Menu.ComboBox("Visuals", "Weapons", "Chams material", Config.GunChams.Material, {"Force field", "Glass", "Neon", "Plastic"}, function(Material)
        Config.GunChams.Material = Material
        for _, Tool in ipairs(GetTools()) do
            if Tool:GetAttribute("Gun") then SetToolChams(Tool) end
        end
    end)

    Menu.CheckBox("Visuals", "Hats", "Hat color changer", Config.HatChanger.Enabled, function(Bool)
        Config.HatChanger.Enabled = Utils.IsOriginal and Bool
        if Utils.IsOriginal and Bool then
            Threads.HatChanger.Continue()
        end
    end)
    Menu.CheckBox("Visuals", "Hats", "Hat color sequence", Config.HatChanger.Sequence, function(Bool)
        Config.HatChanger.Sequence = Utils.IsOriginal and Bool
    end)
    Menu.Slider("Visuals", "Hats", "Hat color rate", 0, 5, Config.HatChanger.Speed, "s", 1, function(Value)
        Config.HatChanger.Speed = Value
    end)
    Menu.ComboBox("Visuals", "Hats", "Hat", "None", {"None", {}}, function(Hat)
        SetHat(Hat)
    end)
    Menu.ColorPicker("Visuals", "Hats", "Hat color", Config.HatChanger.Color, 0, function(Color)
        Config.HatChanger.Color = Color
    end)

    Menu.CheckBox("Misc", "Main", "Auto cash", Config.AutoCash.Enabled, function(Bool)
        Config.AutoCash.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto farm", Config.AutoFarm.Enabled, function(Bool)
        Config.AutoFarm.Enabled = Bool
    end)
    Menu.MultiSelect("Misc", "Main", "Auto farm table", Config.AutoFarm.Table, function(Items)
        Config.AutoFarm.Table = Items
    end)
    Menu.CheckBox("Misc", "Main", "Auto play", Config.AutoPlay.Enabled, function(Bool)
        Config.AutoPlay.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto reconnect", Config.AutoReconnect.Enabled, function(Bool)
        Config.AutoReconnect.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Anti chat log", Config.AntiChatLog.Enabled, function(Bool)
        Config.AntiChatLog.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Auto sort", Config.AutoSort.Enabled, function(Bool)
        Config.AutoSort.Enabled = Bool
    end)
    Menu.MultiSelect("Misc", "Main", "Auto sort order", Config.AutoSort.Order, function(Order)
        Config.AutoSort.Order = Order
    end)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Main", "Auto heal", Config.AutoHeal.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.AutoHeal.Enabled = Bool
    end)):SetVisible(Utils.IsOriginal)
    Menu.CheckBox("Misc", "Main", "Click open", Config.ClickOpen.Enabled, function(Bool)
        Config.ClickOpen.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Chat spam", Spamming, function(Bool)
        Spamming = Bool
        if Bool then
            Threads.ChatSpam.Continue()
        end

        if not isfile("ponyhook/Games/The Streets/Spam.dat") then
            writefile("ponyhook/Games/The Streets/Spam.dat", "")
        end
    end)
    Menu.CheckBox("Misc", "Main", "Event logs", Config.EventLogs.Enabled, function(Bool)
        Config.EventLogs.Enabled = Bool
    end)
    Menu.MultiSelect("Misc", "Main", "Event log flags", Config.EventLogs.Flags, function(Flags)
        Config.EventLogs.Flags = Flags
    end)
    Menu.CheckBox("Misc", "Main", "Hide sprays", Config.HideSprays.Enabled, function(Bool)
        Config.HideSprays.Enabled = Bool
        if Bool then
        end
    end)
    Menu.CheckBox("Misc", "Main", "Close doors", Config.CloseDoors.Enabled, function(Bool)
        Config.CloseDoors.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Open doors", Config.OpenDoors.Enabled, function(Bool)
        Config.OpenDoors.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Knock doors", Config.KnockDoors.Enabled, function(Bool)
        Config.KnockDoors.Enabled = Bool
        if Bool then
            Threads.KnockDoors.Continue()
        end
    end)
    Menu.CheckBox("Misc", "Main", "No doors", Config.NoDoors.Enabled, function(Bool)
        Config.NoDoors.Enabled = Bool
        for _, Door in ipairs(Doors) do
            for _, Object in ipairs(Door:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if Config.NoDoors.Enabled then
                        Object.Transparency = 1
                        Object.CanCollide = false
                    else
                        if not Object:GetAttribute("Ignore") then
                            Object.Transparency = 0
                        end
                        Object.CanCollide = true
                    end
                end
            end
        end
        for _, Window in ipairs(Windows) do
            for _, Object in ipairs(Window:GetDescendants()) do
                if Object:IsA("BasePart") then
                    if Config.NoDoors.Enabled then
                        Object.Transparency = 1
                        Object.CanCollide = false
                    else
                        if not Object:GetAttribute("Ignore") then
                            Object.Transparency = 0
                        end
                        Object.CanCollide = true
                    end
                end
            end
        end
    end)
    Menu.CheckBox("Misc", "Main", "No seats", Config.NoSeats.Enabled, function(Bool)
        Config.NoSeats.Enabled = Bool
        for _, Seat in pairs(Seats) do
            Seat.Disabled = Bool
        end
    end)
    Menu.CheckBox("Misc", "Main", "Door aura", Config.DoorAura.Enabled, function(Bool)
        Config.DoorAura.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Main", "Door menu", Config.DoorMenu.Enabled, function(Bool)
        Config.DoorMenu.Enabled = Bool
    end)

    Menu.CheckBox("Misc", "Animations", "Run", Config.Animations.Run.Enabled, function(Bool)
        Config.Animations.Run.Enabled = Bool
    end)
    Menu.ComboBox("Misc", "Animations", "Run animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Run.Style = String
        Animations.Run.self:Stop()
        Animations.Run2.self:Stop()
        Animations.Run3.self:Stop()
    end)
    Menu.CheckBox("Misc", "Animations", "Glock", Config.Animations.Glock.Enabled, function(Bool)
        Config.Animations.Glock.Enabled = Bool
    end)
    Menu.ComboBox("Misc", "Animations", "Glock animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Glock.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Uzi", Config.Animations.Uzi.Enabled, function(Bool)
        Config.Animations.Uzi.Enabled = Bool
    end)
    Menu.ComboBox("Misc", "Animations", "Uzi animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Uzi.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Shotty", Config.Animations.Shotty.Enabled, function(Bool)
        Config.Animations.Shotty.Enabled = Bool
    end)
    Menu.ComboBox("Misc", "Animations", "Shotty animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations.Shotty.Style = String
    end)
    Menu.CheckBox("Misc", "Animations", "Sawed off", Config.Animations["Sawed Off"].Enabled, function(Bool)
        Config.Animations["Sawed Off"].Enabled = Bool
    end)
    Menu.ComboBox("Misc", "Animations", "Sawed off animation", "Default", {"Default", "Style-2", "Style-3"}, function(String)
        Config.Animations["Sawed Off"].Style = String
    end)

    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "Infinite stamina", Config.InfiniteStamina.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.InfiniteStamina.Enabled = Bool
        EnableInfiniteStamina()
    end)):SetVisible(not Utils.IsOriginal)
    Menu.CheckBox("Misc", "Exploits", "Infinite force field", Config.InfiniteForceField.Enabled, function(Bool)
        Config.InfiniteForceField.Enabled = Bool
        if Bool then
            Threads.InfiniteForceField.Continue()
        end
    end)
    Menu.CheckBox("Misc", "Exploits", "Teleport bypass", Config.TeleportBypass.Enabled, function(Bool)
        Config.TeleportBypass.Enabled = Bool
        TeleportBypass()
    end)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "God", Config.God.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.God.Enabled = Bool
    end)):SetVisible(not Utils.IsOriginal)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "Click spam", Config.ClickSpam.Enabled, function(Bool) -- Can't namecall synapse compiler retarded
        Config.ClickSpam.Enabled = not Utils.IsOriginal and Bool
        if Bool then
            Threads.ClickSpam.Continue()
        end
    end)):SetVisible(not Utils.IsOriginal)
    Menu.GetItem(Menu, Menu.CheckBox("Misc", "Exploits", "No gun delay", Config.NoGunDelay.Enabled, function(Bool)
        Config.NoGunDelay.Enabled = Bool 
    end)):SetVisible(not Utils.IsOriginal)
    Menu.CheckBox("Misc", "Exploits", "Lag on dragged", Config.LagOnDragged.Enabled, function(Bool)
        Config.LagOnDragged.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Exploits", "Fake lag", Config.FakeLag.Enabled, function(Bool)
        Config.FakeLag.Enabled = Bool
        if Bool then
            Threads.FakeLag.Continue()
        end
    end)
    Menu.Slider("Misc", "Exploits", "Fake lag limit", 3, 15, Config.FakeLag.Limit, "", 1, function(Value)
        Config.FakeLag.Limit = Value / 10
    end)
    Menu.Button("Misc", "Exploits", "Crash server", function()
        Threads.CrashServer.Continue()
    end)
    Menu.ListBox("Misc", "Players", "Target", false, Players:GetPlayers(), function(Player_Name)
        local Player = PlayerManager:FindPlayersByName(Player_Name)[1]
        if not Player then return end
        SelectedTarget = Player.Name

        local Whitelist = table.find(UserTable.Whitelisted, tostring(Player.UserId)) and true or false
        local Owner = table.find(UserTable.Owners, tostring(Player.UserId)) and true or false
        Menu:FindItem("Misc", "Players", "CheckBox", "Whitelisted"):SetValue(Whitelist)
        Menu:FindItem("Misc", "Players", "CheckBox", "Owner"):SetValue(Owner)
    end)

    Menu.CheckBox("Misc", "Players", "Target lock", TargetLock, function(Bool) TargetLock = Bool end)
    Menu.Button("Misc", "Players", "Copy target uid", function()
        local Target = PlayerManager:FindPlayersByName(SelectedTarget)[1]
        if Target then
            setclipboard(tostring(Target.UserId))
        end
    end)
    Menu.Slider("Misc", "Players", "Priority", 0, 3, 1, "", 0, function(Value)
        -- 0 don't attack target; > 0 attack target higher priority target
    end)
    Menu.CheckBox("Misc", "Players", "Give Tools", false, function(Bool)
        GivingTools = Bool
        if GivingTools then
            GiveToolsPlayer(GetSelectedTarget())
        end
    end)
    Menu.CheckBox("Misc", "Players", "Attach", Config.Attach.Enabled, function(Bool)
        Config.Attach.Enabled = Bool
        if Bool then 
            Threads.Attach.Continue()
        else
            for _, Tool in ipairs(GetTools()) do
                local ToolInfo = GetToolInfo(Tool)
                if ToolInfo then
                    Tool.Grip = ToolInfo.Grip
                end
            end
        end
    end)
    Menu.Slider("Misc", "Players", "Attach rate", 0, 3000, Config.Attach.RefreshRate, "ms", 1, function(Value)
        Config.Attach.RefreshRate = Value
    end)
    Menu.CheckBox("Misc", "Players", "View", Config.View.Enabled, function(Bool)
        Config.View.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Players", "Follow", Config.Follow.Enabled, function(Bool)
        Config.Follow.Enabled = Bool
    end)
    Menu.CheckBox("Misc", "Players", "Whitelisted", false, function(Bool)
        local UserId = tostring(GetSelectedTarget().UserId)
        local Index = table.find(UserTable.Whitelisted, UserId)
        if Index then
            table.remove(UserTable.Whitelisted, Index)
        else
            table.insert(UserTable.Whitelisted, UserId)
        end
        writefile("ponyhook/Games/The Streets/Whitelist.dat", table.concat(UserTable.Whitelisted, "\n"))
    end)
    Menu.CheckBox("Misc", "Players", "Owner", false, function(Bool)
        local UserId = tostring(GetSelectedTarget().UserId)
        local Index = table.find(UserTable.Owners, UserId)
        if Index then
            table.remove(UserTable.Owners, Index)
        else
            table.insert(UserTable.Owners, UserId)
        end
        writefile("ponyhook/Games/The Streets/Owners.dat", table.concat(UserTable.Owners, "\n"))
    end)
    do
        local Player_Info_Items = {}
        Player_Info_Items["Display name"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Display name: ?"))
        Player_Info_Items["Age"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Age: 0"))
        Player_Info_Items["Vest"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Vest: false"))
        Player_Info_Items["Origin"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Origin: (0; 0; 0)"))
        Player_Info_Items["Health"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Health: 0"))
        Player_Info_Items["Stamina"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Stamina: 0"))
        Player_Info_Items["Knocked out"] = Menu.GetItem(Menu, Menu.Label("Misc", "Players", "Knocked out: 0"))

        local function UpdateItemValue(Index, Value)
            Player_Info_Items[Index]:SetLabel(Value)
        end

        function UpdatePlayerListInfo(Player)
            if typeof(Player) == "Instance" and Player:IsA("Player") then
                UpdateItemValue("Display name", "Display name: " .. Player.DisplayName)
                UpdateItemValue("Age", "Age: " .. Player.AccountAge)
                do
                    local Vest = Player:GetAttribute("Vest")
                    UpdateItemValue("Vest", "Vest: " .. tostring(Vest))
                end
                do
                    local Position = Player:GetAttribute("Position")
                    if typeof(Position) == "Vector3" then
                        UpdateItemValue("Origin", string.format("Origin: (%d;, %d; ,%d)", Utils.math_round(Position.X, 2), Utils.math_round(Position.Y, 2), Utils.math_round(Position.Z, 2)))
                    end
                end

                local Health = Utils.math_round(Player:GetAttribute("Health") or 0, 2)
                local Stamina = Utils.math_round(Player:GetAttribute("Stamina") or 0, 2)
                local KnockOut = Utils.math_round(Player:GetAttribute("KnockOut") or 0, 2)

                UpdateItemValue("Health", "Health: " .. tostring(Health))
                UpdateItemValue("Stamina", "Stamina: " .. tostring(Stamina))
                UpdateItemValue("Knocked out", "Knocked out: " .. tostring(KnockOut))
            end
        end
    end

    Menu.CheckBox("Misc", "Clan tag", "Enabled", Config.ClanTag.Enabled, function(Bool)
        Config.ClanTag.Enabled = Bool
        if Bool then
            Threads.ClanTag.Continue()
        end
    end)
    Menu.CheckBox("Misc", "Clan tag", "Visualize", Config.ClanTag.Visualize, function(Bool)
        Config.ClanTag.Visualize = Bool
    end)
    Menu.TextBox("Misc", "Clan tag", "Tag", Config.ClanTag.Tag, function(Tag)
        Config.ClanTag.Tag = Tag
    end)
    Menu.TextBox("Misc", "Clan tag", "Prefix", Config.ClanTag.Prefix, function(Prefix)
        Config.ClanTag.Prefix = Prefix
    end)
    Menu.TextBox("Misc", "Clan tag", "Suffix", Config.ClanTag.Suffix, function(Suffix)
        Config.ClanTag.Suffix = Suffix
    end)
    Menu.Slider("Misc", "Clan tag", "Tag speed", 0, 5, Config.ClanTag.Speed, "s", 2, function(Speed)
        Config.ClanTag.Speed = Speed
    end)
    Menu.ComboBox("Misc", "Clan tag", "Tag type", Config.ClanTag.Type, {"Static", "Blink", "Normal", "Forward", "Reverse", "Cheat", "Custom", "Info", "Boombox", "Spotify"}, function(Type)
        Config.ClanTag.Type = Type
    end)
    Menu.TextBox("Misc", "Clan tag", "Spotify token", Config.ClanTag.SpotifyToken, function(Token)
        Config.ClanTag.SpotifyToken = Token
    end)

    do
        local DemoPlayer
        local Recording = false
        local RecordingName = ""

        local StatusLabel = Menu.GetItem(Menu, Menu.Label("Settings", "Demo recorder", "Status: Not recording"))
        Menu.TextBox("Settings", "Demo recorder", "Demo Name", "", function(String)
            RecordingName = String
        end)
        Menu.Button("Settings", "Demo recorder", "Toggle recording", function()
            Recording = not Recording
            if Recording then
                DemoPlayer:start()
            else
                DemoPlayer:stop()
                DemoPlayer:create()
            end
            local Status = Recording and "Recording..." or "Not recording"
            StatusLabel:SetLabel("Status: " .. Status)
        end)
        Menu.Button("Settings", "Demo recorder", "Copy Replay Place", function()
            setclipboard("https://www.roblox.com/games/8869691226/Replay-House")
        end)
    end
    
    Menu.Button("Settings", "Settings", "Refresh", function()
        Menu:FindItem("Visuals", "World", "ComboBox", "Skybox"):SetValue(Config.Enviorment.Skybox.Value, GetFolders("ponyhook/Games/The Streets/bin/skyboxes/").Names)
        HitSound = get_custom_asset("ponyhook/Games/The Streets/bin/sounds/hitsound.mp3") -- huh seems to automatically when file changes?
        Crosshair = get_custom_asset("ponyhook/Games/The Streets/bin/crosshairs/crosshair.png")
        Mouse.Icon = Crosshair
    end)

    Menu.Hotkey("Settings", "Menu", "Menu key", Config.Menu.Key, function(KeyCode)
        Config.Menu.Key = KeyCode
        ContextAction:BindAction("menuToggle", MenuToggle, false, KeyCode)
    end)
    Menu.Hotkey("Settings", "Menu", "Prefix", Config.Prefix, function(KeyCode)
        Config.Prefix = KeyCode
        Menu.CommandBar.PlaceholderText = "Command bar [" .. string.char(Config.Prefix.Value) .. "]"
        ContextAction:BindAction("commandBarToggle", CommandBarToggle, false, KeyCode)
    end)
    Menu.ColorPicker("Settings", "Menu", "Menu accent", Config.Menu.Accent, 0, function(Color)
        Menu.Accent = Color
        Config.Menu.Accent = Color
        Menu:SetTitle("ponyhook" .. Utils.GetRichTextColor(".cc", Color:ToHex()))
    end)
    Menu.ComboBox("Settings", "Menu", "Console font color", Config.Console.Accent, {"Cyan"}, function(String)
        Config.Console.Accent = String
        Console.ForegroundColor = String
    end)

    Menu.TextBox("Settings", "Configs", "Config name", "")
    Menu.ListBox("Settings", "Configs", "Configs", false, GetFiles("ponyhook/Games/The Streets/Configs/").Names, function(cfg_name)
        Menu:FindItem("Settings", "Configs", "TextBox", "Config name"):SetValue(cfg_name)
    end)
    Menu.Button("Settings", "Configs", "Create", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "TextBox", "Config name"):GetValue()
        -- file already exists?
        Configs:Save(cfg_name)
        Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):SetValue(cfg_name .. ".cfg", GetFiles("ponyhook/Games/The Streets/Configs").Names)
    end)
    Menu.Button("Settings", "Configs", "Save", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        Menu.Prompt("Are you sure you want to overwrite save  of  '" .. cfg_name .. "' ?", function() -- 2 spaces since the font makes it look like no spaces
            cfg_name = string.gsub(cfg_name, ".cfg", "")
            Configs:Save(cfg_name)
            Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):SetValue(cfg_name .. ".cfg", GetFiles("ponyhook/Games/The Streets/Configs").Names)
        end)
    end)
    Menu.Button("Settings", "Configs", "Load", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        cfg_name = string.gsub(cfg_name, ".cfg", "")
        LoadConfig(cfg_name)
    end)
    Menu.Button("Settings", "Configs", "Delete", function()
        local cfg_name = Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):GetValue()
        Menu.Prompt("Are you sure you want to delete '" .. cfg_name .. "' ?", function()
            delfile("ponyhook/Games/The Streets/Configs/" .. cfg_name)
            Menu:FindItem("Settings", "Configs", "ListBox", "Configs"):SetValue("", GetFiles("ponyhook/Games/The Streets/Configs").Names)
        end)
    end)

    do
        local BoomboxText = Instance.new("TextLabel")
        local BoomboxList = Instance.new("ScrollingFrame")
        local BoomboxLayout = Instance.new("UIListLayout")

        Menu.BoomboxFrame.ClipsDescendants = true
        Menu.BoomboxFrame.Visible = false
        Menu.BoomboxFrame.Position = UDim2.new(0.375, 0, 0.65, 0)
        Menu.BoomboxFrame.Size = UDim2.new(0.25, 0, 0.25, 0)
        Menu.BoomboxFrame.Style = Enum.FrameStyle.RobloxRound
        Menu.BoomboxFrame.Parent = Menu.Screen

        BoomboxText.Name = "Text"
        BoomboxText.BackgroundTransparency = 1
        BoomboxText.Position = UDim2.new(0, 0, 0, -8)
        BoomboxText.Size = UDim2.new(1, 0, 0, 20)
        BoomboxText.Text = "Recently Played"
        BoomboxText.TextColor3 = Color3.new(1, 1, 1)
        BoomboxText.TextStrokeTransparency = 0
        BoomboxText.Font = Enum.Font.SourceSans
        BoomboxText.TextSize = 24
        BoomboxText.Parent = Menu.BoomboxFrame

        BoomboxList.Name = "List"
        BoomboxList.Active = true
        BoomboxList.BackgroundTransparency = 1
        BoomboxList.BorderSizePixel = 0
        BoomboxList.Position = UDim2.new(0, 0, 0, 20)
        BoomboxList.Size = UDim2.new(1, 0, 0, 150)
        BoomboxList.CanvasSize = UDim2.new()
        BoomboxList.ScrollBarThickness = 0
        BoomboxList.Parent = Menu.BoomboxFrame

        BoomboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
        BoomboxLayout.Padding = UDim.new(0, 5)
        BoomboxLayout.Parent = BoomboxList
    end

    Menu.CommandBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Menu.CommandBar.BackgroundTransparency = 0.2
    Menu.CommandBar.BorderSizePixel = 0
    Menu.CommandBar.Position = UDim2.new(0.5, -100, 1, 0)
    Menu.CommandBar.Size = UDim2.new(0, 200, 0, 20)
    Menu.CommandBar.Font = Enum.Font.Code
    Menu.CommandBar.PlaceholderColor3 = Color3.new(1, 1, 1)
    Menu.CommandBar.PlaceholderText = "Command bar [" .. string.char(Config.Prefix.Value) .. "]"
    Menu.CommandBar.Text = ""
    Menu.CommandBar.TextColor3 = Color3.new(1, 1, 1)
    Menu.CommandBar.TextSize = 14
    Menu.CommandBar.TextStrokeTransparency = 0.5
    Menu.CommandBar.Parent = Menu.Screen
    Menu.Line(Menu.CommandBar)

    Menu.Indicators.Add("Target", "Text", "nil")
    Menu.Indicators.Add("Knocked Out", "Bar", 0, 0, 15)
    Menu.Indicators.Add("Bullet Tick", "Text", 0)
    Menu.Indicators.Add("Stomp Target", "Text", 0)
    Menu.Indicators.Add("Fake Lag", "Bar", 0, 0, 15) -- 15 is 1.5 seconds
    Menu.Indicators.Add("Fake Velocity", "Text", "on")

    --[[
        Health = false
        Stamina = false
        GunCooldown = false --(Tool.Info.Cooldown) Lol
        FakeLag = false
        AntiGroudHit = false
    ]]

    Menu.Keybinds.Add("Aimbot", Config.Aimbot.Enabled and "on" or "off")
    Menu.Keybinds.Add("Camera Lock", Config.CameraLock.Enabled and "on" or "off")
    Menu.Keybinds.Add("Flight", Config.Flight.Enabled and "on" or "off")
    Menu.Keybinds.Add("Blink", Config.Blink.Enabled and "on" or "off")
    Menu.Keybinds.Add("Float", Config.Float.Enabled and "on" or "off")
    Menu.Keybinds.Add("Noclip", Config.Noclip.Enabled and "on" or "off")
    Menu.Keybinds.Add("Anti Aim", Config.AntiAim.Enabled and "on" or "off")


    Menu.Keybinds.List.Aimbot:SetVisible(Config.Aimbot.Enabled)
    Menu.Keybinds.List["Camera Lock"]:SetVisible(Config.CameraLock.Enabled)
    Menu.Keybinds.List.Flight:SetVisible(Config.Flight.Enabled)
    Menu.Keybinds.List.Blink:SetVisible(Config.Blink.Enabled)
    Menu.Keybinds.List.Float:SetVisible(Config.Float.Enabled)
    Menu.Keybinds.List.Noclip:SetVisible(Config.Noclip.Enabled)
    Menu.Keybinds.List["Anti Aim"]:SetVisible(Config.AntiAim.Enabled)
    Menu.Watermark:SetVisible(Config.Interface.Watermark.Enabled)
    Menu.Indicators:SetVisible(Config.Interface.Indicators.Enabled)
    Menu.Keybinds:SetVisible(Config.Interface.Keybinds.Enabled)
    Menu:SetTab("Combat")
end