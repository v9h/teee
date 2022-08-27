local Lighting = {}


local get_custom_asset = getcustomasset or syn and getsynasset


local Utils = import "Utils"


local RunService = game:GetService("RunService")
local LightingService = game:GetService("Lighting")


Lighting.Time = LightingService.TimeOfDay
Lighting.Ambient = LightingService.Ambient
Lighting.OutdoorAmbient = LightingService.OutdoorAmbient

Lighting.DefaultAmbient = Lighting.Ambient
Lighting.DefaultOutdoorAmbient = Lighting.OutdoorAmbient

Lighting.Changed = LightingService.Changed


local function UpdateLighting()
    LightingService.TimeOfDay = Lighting.Time
    LightingService.Ambient = Lighting.Ambient
    LightingService.OutdoorAmbient = Lighting.OutdoorAmbient
end


function Lighting:Init()
    local Sky = LightingService:FindFirstChildOfClass("Sky")
    local Blur = Instance.new("BlurEffect")
    local Bloom = Instance.new("BloomEffect")
    local SunRays = Utils.IsOriginal and LightingService:WaitForChild("SunRays") or Instance.new("SunRaysEffect")
    local Atmosphere = Instance.new("Atmosphere")
    local DepthOfField = Instance.new("DepthOfFieldEffect")
    
    Blur.Enabled = false
    Blur.Size = 0
    Blur.Parent = LightingService
    
    Bloom.Enabled = false
    Bloom.Size = 0
    Bloom.Intensity = 0
    Bloom.Threshold = 0
    Bloom.Parent = LightingService
    
    SunRays.Enabled = Utils.IsOriginal
    SunRays.Spread = 0
    SunRays.Intensity = 0
    SunRays.Parent = LightingService
    
    Atmosphere.Color = Color3.new(1, 1, 1)
    Atmosphere.Decay = Color3.new(1, 1, 1)
    Atmosphere.Glare = 0
    Atmosphere.Haze = 0
    Atmosphere.Offset = 0
    Atmosphere.Density = 0
    Atmosphere.Parent = LightingService
    
    DepthOfField.Enabled = false
    DepthOfField.FarIntensity = 0
    DepthOfField.NearIntensity = 0
    DepthOfField.FocusDistance = 0
    DepthOfField.InFocusRadius = 0
    DepthOfField.Parent = LightingService
    
    SunRays:SetAttribute("DefaultSpread", SunRays.Spread)
    SunRays:SetAttribute("DefaultIntensity", SunRays.Intensity)

    Lighting.BlurEffect = Blur
    Lighting.BloomEffect = Bloom
    Lighting.SunRaysEffect = SunRays
    Lighting.Atmosphere = Atmosphere
    Lighting.DepthOfFieldEffect = DepthOfField
    Lighting.ColorEffect = LightingService:FindFirstChild("ColorCorrection")

    RunService.Heartbeat:Connect(UpdateLighting)
end


function Lighting:UpdateSkybox(Skybox: string): string--?
    local Skyboxes = Utils.GetFolders("ponyhook/Games/The Streets/bin/skyboxes/").Folders

    for k, v in pairs(Skyboxes) do
        if k == Skybox then
            local Success, Result = pcall(function()
                local Sky = LightingService.Sky

                Sky.SkyboxUp = get_custom_asset(readfile(Skybox .. "/Up.png"))
                Sky.SkyboxDn = get_custom_asset(readfile(Skybox .. "/Down.png"))
                Sky.SkyboxFt = get_custom_asset(readfile(Skybox .. "/Front.png"))
                Sky.SkyboxBk = get_custom_asset(readfile(Skybox .. "/Back.png"))
                Sky.SkyboxLf = get_custom_asset(readfile(Skybox .. "/Left.png"))
                Sky.SkyboxRt = get_custom_asset(readfile(Skybox .. "/Right.png"))
            end)

            if not Success then
                return Result
            end

            break
        end
    end
end


return Lighting