--[[

THIS CODING WAS DONE BY LOLERIS I PRESUME
I just modded it a little bit for it to work with my scripts
I do not recommend anyone to read this script

]]


local delay = task.delay


local Players = game:GetService("Players")


local Debris = Instance.new("Folder")
Debris.Name = "Debris"
Debris.Parent = workspace


local body_part_names = {"Head", "LeftArm", "LeftLeg", "RightArm", "RightLeg", "Torso"}
local real_body_part_names = {"Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"}


function PlaySound(part, snd)
	if part == nil then return end
	if type(snd) == "table" then
		snd = snd[math.random(1, #snd)]
	end

	local Sound = Instance.new("Sound")
	Sound.Volume = 1
	Sound.SoundId = snd
	Sound.Parent = part
	Sound:Play()
end


function GetAllParts(char, func)
	local function scan(ch)
		for _, obj in pairs(ch:GetChildren()) do
			scan(obj)
			if obj:IsA("BasePart") then
				func(obj)
			end
		end
	end
	scan(char)
end


function RemoveHats(char)
	local function scan(ch)
		for _, obj in pairs(ch:GetChildren()) do
			scan(obj)
			if obj:IsA("Hat") or obj.Name == "HAT" then
				obj:destroy()
			end
		end
	end
	scan(char)
end


function RemoveFace(char)
	local get_head = char:FindFirstChild("Head")
	if get_head then
		local get_face = get_head:FindFirstChild("face")
		if get_face then
			get_face:destroy()
		end
	end
end


function RemoveClothing(char)
	local function scan(ch)
		for _, obj in pairs(ch:GetChildren()) do
			scan(obj)
			if obj:IsA("Shirt") or obj:IsA("ShirtGraphic") or obj:IsA("Pants") or obj:IsA("CharacterMesh") or (obj:IsA("Decal") and obj.Name == "roblox")
				or (obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("ParticleEmitter")) then
				obj:destroy()
			end
		end
	end
	scan(char)
end


function ClearCharacter(self)
    local Humanoid = Instance.new("Humanoid")
    self:ClearAllChildren()
    Humanoid.Parent = self
end


function HideHead(char)
	local get_head = char:FindFirstChild("Head")
	if get_head then
		local f_head = get_head:clone()
		f_head.Name = "FakeHead"

		local nj = Instance.new("Weld")
		nj.Part0 = get_head
		nj.part1 = f_head
		nj.Parent = get_head

		f_head.Parent = char
		get_head.Transparency = 1
	end
end


function MaterializeCharacter(char, b_color, material)
	RemoveClothing(char)

	GetAllParts(char, function(obj)
		for _, v in pairs(obj:GetChildren()) do
			if v:IsA("SpecialMesh") then
				v.TextureId = ""
			end
		end

        obj.BrickColor = b_color
		obj.Material = material
	end)
end


function Freeze(char)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = true
        end
    end
end


local KillEffects = {}


KillEffects.Duck = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")

    local spill_sound = "rbxassetid://281261799"
    local bonus_sound = "rbxassetid://186440645"

    local function GenDuck()
        local DuckRoot = Instance.new("Part")
        DuckRoot.TopSurface = 0
        DuckRoot.BottomSurface = 0
        DuckRoot.Size = Vector3.new(1, 1, 1)
        
        local Duck = Instance.new("SpecialMesh")
        Duck.MeshType = "FileMesh"
        Duck.MeshId = "rbxassetid://9419831"
        Duck.TextureId = "rbxassetid://9419827"
        Duck.Scale = Vector3.new(1, 1, 1)
        Duck.Parent = DuckRoot	
        return DuckRoot
    end

    local Torso = Humanoid.Torso
    if Torso then
        local Position = Torso.Position
        ClearCharacter(Character)
        
        local Duck = GenDuck()
        Duck.CFrame = CFrame.new(Position) * CFrame.Angles(math.random() * math.pi * 4, math.random() * math.pi * 4, math.random() * math.pi * 4)
        Duck.Parent = Character
        PlaySound(Duck, spill_sound)
        if math.random(1, 20) == 1 then 
            for i = 1, 20 do
                local Duck = GenDuck()
                Duck.CFrame = CFrame.new(Position + Vector3.new((math.random() - 0.5) * 3, (math.random() - 0.5) * 3, (math.random() - 0.5) * 3)) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
                Duck.Parent = Character
            end
            PlaySound(DuckRoot, bonus_sound)
        end
        
        Character.Parent = Debris
        delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
    end
end


KillEffects.Explode = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")
    local explosion_sound = "rbxassetid://142070127"
    HideHead(Character)

    local Torso = Character:FindFirstChild("Torso")
    if Torso then
        PlaySound(Torso, explosion_sound)
        local Position = Torso.Position
        local Explosion = Instance.new("Explosion")
        Explosion.BlastRadius = 0
        Explosion.BlastPressure = 500000
        Explosion.Position = Position
        Explosion.Parent = Torso
    end
    
    Character:BreakJoints()
    
    GetAllParts(Character, function(obj)
        obj.Velocity = Vector3.new((math.random() - 0.5) * 120, (math.random() - 0.5) * 120, (math.random() - 0.5) * 120)
    end)
    
    Character.Parent = Debris
    Humanoid.Name = "RagdollHumanoid"
    delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
end


KillEffects.Ice = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")
    local freeze_sound = "rbxassetid://248572927"
    
    Freeze(Character, true)
    MaterializeCharacter(Character, BrickColor.new("Institutional white"), "Ice")
    local Torso = Character:FindFirstChild("Torso")
    if Torso then
        PlaySound(Torso, freeze_sound)
        local sm = Instance.new("Smoke")
        sm.Color = Color3.new(1, 1, 1)
        sm.Opacity = 0.2
        sm.RiseVelocity = 0
        sm.Size = 1
        sm.Parent = Torso
    end

    Character.Parent = Debris
    Character:BreakJoints()
    delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
end


KillEffects.Particles = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")

    local explosion_sound = "rbxassetid://138210320"

    local function GenParticle()
        local np = Instance.new("Part")
        np.CanCollide = false
        np.Anchored = true
        np.TopSurface = 0
        np.BottomSurface = 0
        np.Transparency = 0
        np.BrickColor = BrickColor.new("Magenta")
        np.Material = "Neon"
        np.Size = Vector3.new(0.2, 0.2, 0.2)
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Scale = Vector3.new(2.5, 2.5, 2.5)
        mesh.Parent = np
        
        return np
    end

    local function GenInvis()
        local np = Instance.new("Part")
        np.Anchored = true
        np.CanCollide = false
        np.Transparency = 1
        np.TopSurface = 0
        np.BottomSurface = 0
        np.Size = Vector3.new(0.2, 0.2, 0.2)
        
        return np
    end

    local Torso = Character:FindFirstChild("Torso")
    if Torso then
        local Position = Torso.Position
        ClearCharacter(Character)
        
        local main_s = GenInvis()
        main_s.CFrame = CFrame.new(Position)
        main_s.Parent = Character
        PlaySound(main_s, explosion_sound)
        local p_list = {}
        for i = 1, 20 do
            local new_s = GenParticle()
            new_s.CFrame = CFrame.new(Position + Vector3.new((math.random() - 0.5) * 2, (math.random() - 0.5) * 2, (math.random() - 0.5) * 2)) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
            new_s.Parent = Character
            table.insert(p_list, new_s)
        end
        
        coroutine.resume(coroutine.create(function()
            local start = os.clock()
            while true do
                local delta = wait()
                local eff = math.min(1, (os.clock() - start) / 5)
                for _, p in pairs(p_list) do
                    p.CFrame = p.CFrame * CFrame.new(0, 0, -delta * 1.5)
                    p.Transparency = eff
                end
                
                if eff == 1 then
                    for _, p in pairs(p_list) do
                        p:Destroy()
                    end
                    main_s:Destroy()
                    break
                end
            end
        end))

        Character.Parent = Debris
        delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
    end
end


KillEffects.Vaporize = function(Character, Color, Color2)
    assert(Color and Color2, "Missing Colors For Vaporize")
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")

    local vaporize_particle = Instance.new("ParticleEmitter")
    vaporize_particle.RotSpeed = NumberRange.new(-20, 20)
    vaporize_particle.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color), ColorSequenceKeypoint.new(1, Color2)})
    vaporize_particle.Rate = 50
    vaporize_particle.Rotation = NumberRange.new(-180, 180)
    vaporize_particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(0.13362500071526, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})
    vaporize_particle.Name = "Vaporize"
    vaporize_particle.Lifetime = NumberRange.new(0.5)
    vaporize_particle.Speed = NumberRange.new(0)
    vaporize_particle.Texture = "rbxassetid://277855096"
    vaporize_particle.LightEmission = 0.5
    vaporize_particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4375, 0),NumberSequenceKeypoint.new(1, 1, 0.1875)})

    local disintegrate_sound = "rbxassetid://4639730952"
    MaterializeCharacter(Character, BrickColor.new("Really black"), "Slate")
    
    local prts = {}
    local particles = {}
    local particles_disabled = false

    local function CreateJoint(j_type, p0, p1, c0, c1)
        local nj = Instance.new(j_type)
        nj.Part0 = p0 nj.part1 = p1
        if c0 ~= nil then nj.C0 = c0 end
        if c1 ~= nil then nj.C1 = c1 end
        nj.Parent = p0
    end


    local AttactmentData = {
        --["AttachmentTag"] = {part_name, part_attachment, torso_attachment, relative_position}
        ["H"] = {"Head", CFrame.new(0, 0.5, 0), CFrame.new(0, 2, 0), CFrame.new()},
        ["RA"] = {"Right Arm", CFrame.new(0, 0.5, 0), CFrame.new(1.5, 0.5, 0), CFrame.new(1.5, 0, 0)},
        ["LA"] = {"Left Arm", CFrame.new(0, 0.5, 0), CFrame.new(-1.5, 0.5, 0), CFrame.new(-1.5, 0, 0)},
        ["RL"] = {"Right Leg", CFrame.new(0, 0.5, 0), CFrame.new(0.5, -1.5, 0), CFrame.new(0.5, -2, 0)},
        ["LL"] = {"Left Leg", CFrame.new(0, 0.5, 0), CFrame.new(-0.5, -1.5, 0), CFrame.new(-0.5, -2, 0)}
    }


    local collision_part = Instance.new("Part")
    collision_part.Name = "CP"
    collision_part.TopSurface = Enum.SurfaceType.Smooth
    collision_part.BottomSurface = Enum.SurfaceType.Smooth
    collision_part.Size = Vector3.new(1, 1.5, 1)
    collision_part.Transparency = 1

    function Ragdoll(char, hide_name)
        local hdv = char:FindFirstChild("Head")
        
        --set up the ragdoll
        local function scan(ch)
            for i = 1, #ch do
                scan(ch[i]:GetChildren())
                if (ch[i]:IsA("ForceField") or ch[i].Name == "HumanoidRootPart") or ((ch[i]:IsA("Weld") or ch[i]:IsA("Motor6D")) and ch[i].Name ~= "HeadWeld" and ch[i].Name ~= "RadioWeld" and ch[i].Name ~= "AttachementWeld") then
                    ch[i]:destroy()
                end
            end
        end

        scan(char:GetChildren())
        
        local f_head
        
        local fhum = char:FindFirstChild("Humanoid")
        fhum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        fhum.PlatformStand = true
        if hide_name then
            fhum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
        
        local Torso = char:FindFirstChild("Torso")
        if Torso then
            for att_tag, att_data in pairs(AttactmentData) do
                local get_limb = char:FindFirstChild(att_data[1])
                if get_limb then
                    
                    local att1 = Instance.new("Attachment")
                    att1.Name = att_tag
                    att1.CFrame = att_data[2]
                    att1.Parent = get_limb
                    
                    local att2 = Instance.new("Attachment")
                    att2.Name = att_tag
                    att2.CFrame = att_data[3]
                    att2.Parent = Torso
                    
                    local socket = Instance.new("BallSocketConstraint")
                    socket.Name = att_tag .. "_SOCKET"
                    socket.Attachment0 = att2
                    socket.Attachment1 = att1
                    socket.Radius = 0
                    socket.Parent = Torso
                    
                    get_limb.CanCollide = false
                    
                    local cp = collision_part:Clone()
                    local cp_weld = Instance.new("Weld")
                    cp_weld.C0 = CFrame.new(0, -0.25, 0)
                    cp_weld.Part0 = get_limb
                    cp_weld.Part1 = cp
                    cp_weld.Parent = cp
                    cp.Parent = char
                    
                end
            end
        end
        
        fhum.MaxHealth = 100
        fhum.Health = fhum.MaxHealth
    end
    
    RemoveHats(Character)
    RemoveFace(Character)
    Ragdoll(Character, true)
    
    local Torso = Character:FindFirstChild("Torso")
    if Torso then
        PlaySound(Torso, disintegrate_sound)
        local body_vel = Instance.new("BodyVelocity")
        body_vel.maxForce = Vector3.new(0, 200000, 0)
        body_vel.velocity = Vector3.new(0, 1, 0)
        body_vel.Parent = Torso
    end
    
    GetAllParts(Character, function(obj)
        if obj.Transparency < 1 then
            table.insert(prts, obj)
            obj.Transparency = 0.4
            local particle = vaporize_particle:Clone()
            particle.Parent = obj
            table.insert(particles, particle)
        end
        
        obj.Material = Enum.Material.Slate
        local b_force = Instance.new("BodyForce")
        b_force.force = Vector3.new(0, obj.Size.x * obj.Size.y * obj.Size.z * 180, 0) --196.2 is gravity
        b_force.Parent = obj
    end)
    
    coroutine.resume(coroutine.create(function()
        wait(4)
        local start = os.clock()
        while os.clock() - start < 1.5 do
            if not particles_disabled then
                if os.clock() - start > 0.6 then
                    particles_disabled = true
                    for _, p in pairs(particles) do
                        p.Enabled = false
                    end
                end
            end
            local amm = (os.clock() - start) / 1.5
            for _, obj in pairs(prts) do
                obj.Transparency = 0.4 + amm * 0.6
            end
            wait()
        end
        Character:Destroy()
    end))
    
    Character.Parent = Debris
    Humanoid.Name = "RagdollHumanoid"
end


KillEffects.Rings = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")

    local spill_sound = "rbxassetid://286734104"
    local bonus_sound = "rbxassetid://135557803"

    local function GenRing()
        local np = Instance.new("Part")
        np.TopSurface = 0
        np.BottomSurface = 0
        np.Size = Vector3.new(1, 1, 0.2)
        np.Velocity = Vector3.new(math.random(-5,5),math.random(4,7), math.random(-5,5))
        
        local ring_mesh = Instance.new("SpecialMesh")
        ring_mesh.MeshType = "FileMesh"
        
        ring_mesh.MeshId = "rbxassetid://3270017"
        ring_mesh.TextureId = "rbxassetid://3270066"
        ring_mesh.Scale = Vector3.new(1, 1, 1)
        ring_mesh.Parent = np	
        return np
    end

    local Torso = Character:FindFirstChild("Torso")
    if Torso then
        local Position = Torso.Position
        ClearCharacter(Character)
        
        local main_s = GenRing()
        main_s.CFrame = CFrame.new(Position) * CFrame.Angles(math.random() * math.pi * 4, math.random() * math.pi * 4, math.random() * math.pi * 4)
        main_s.Parent = Character
        PlaySound(main_s, spill_sound) 
        for i = 1, 9 do
            local new_s = GenRing()
            new_s.CFrame = CFrame.new(Position + Vector3.new((math.random() - 0.5) * 3, (math.random() - 0.5) * 3, (math.random() - 0.5) * 3)) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
            new_s.Parent = Character
        end
        PlaySound(main_s, bonus_sound)
            
        Character.Parent = Debris
        delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
    end
end


KillEffects.Gold = function(Character)
    assert(Character, "Missing Character For Kill Effect")
    local Humanoid = Character.Humanoid
    assert(Humanoid, "Missing Humanoid For Kill Effect")

    local gold_sounds = {"rbxassetid://282222537", "rbxassetid://282222594", "rbxassetid://282222660"}

    PlaySound(Character:FindFirstChild("Torso"), gold_sounds)
    Freeze(Character, true)
    MaterializeCharacter(Character, BrickColor.new("New Yeller"), "Ice")
    
    Character.Parent = Debris
    Character:BreakJoints()
    delay(Players.RespawnTime + 0.1, Character.Destroy, Character)
end


return KillEffects
