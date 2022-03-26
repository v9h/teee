local ToolData = {
    Punch = {
        Damage = 5,
        Range = 3,
        TextureId = "rbxassetid://4529734951",
        Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Knife = {
        Damage = 20,
        Range = 3,
        TextureId = "rbxassetid://4529719103",
        Grip = CFrame.new(0.8, 0, 0, 0, -1, 0, 0, 0, 1, -1, 0, 0)
    },
    Pipe = {
        Damage = 17,
        Range = 3.5,
        TextureId = "rbxassetid://4529716968",
        Grip = CFrame.new(0.8, 0, 0, 0, -1, 0, 0, 0, 1, -1, 0, 0)
    },
    Sign = {
        Damage = 14,
        Range = 2.5,
        TextureId = "rbxassetid://4529732793",
        Grip = CFrame.new(1, 0, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)
    },
    Bat = {
        Damage = 8,
        Range = 4,
        TextureId = "rbxassetid://4529687772",
        EspId = "rbxassetid://175024455",
        Grip = CFrame.new(0, -1.8, 0, -2.94, -0.011, 0.1, -0, 0.1, 0.01, -0.1, -0, -3.075)
    },
    Bottle = {
        Damage = 8,
        Range = 3,
        TextureId = "rbxassetid://4529687739",
        EspId = "rbxassetid://156444949",
        Grip = CFrame.new(0, 1, 0, 0.1, 0, -0.089, 0, -1, -0, -0.089, 0, -0.1)
    },
    Brick = {
        Damage = 25,
        TextureId = "",
        EspId = "rbxassetid://376949878",
        Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    ["Stop Sign"] = {
        Damage = 20,
        Range = 4,
        TextureId = "rbxassetid://4529706656",
        EspId = "rbxassetid://861978247",
        Grip = CFrame.new(0, -1.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    ["Golf Club"] = {
        Damage = 10,
        Range = 4,
        TextureId = "rbxassetid://4529687587",
        EspId = "rbxassetid://344936269",
        Grip = CFrame.new(0, -1.8, 0.3, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Machete = {
        Damage = 21,
        Range = 3.5,
        TextureId = "rbxassetid://4529693756",
        EspId = "rbxassetid://154965929",
        Grip = CFrame.new(0, -1.65, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    },
    Katana = {
        Damage = 33,
        Range = 4,
        TextureId = "rbxassetid://4529693789",
        EspId = "rbxassetid://12177147",
        Grip = CFrame.new(0, -0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Crowbar = {
        Damage = 5,
        Range = 3,
        TextureId = "rbxassetid://4529687668",
        EspId = "rbxassetid://546410481",
        Grip = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    },
    Cash = {
        TextureId = "rbxassetid://4529687710",
        EspId = "rbxassetid://511726060",
        Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    ["Fat Cash"] = {
        TextureId = "rbxassetid://4529687632",
        Grip = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    },
    Glock = {
        Damage = 24,
        Range = 150,
        TextureId = "rbxassetid://4529721915",
        Grip = CFrame.new(0.4, -0.1, 0, 0.008, 0, 0.1, 0, 1, 0, -0.1, 0, 0.008),
        IsAGun = true
    },
    Uzi = {
        Damage = 20,
        Range = 150,
        TextureId = "rbxassetid://4529712484",
        EspId = "328964620",
        Grip = CFrame.new(0.4, -0.1, -0.2, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        IsAGun = true
    },
    Shotty = {
        Damage = 48,
        Range = 150,
        TextureId = "rbxassetid://4529701363",
        EspId = "142383762",
        Grip = CFrame.new(0.5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        IsAGun = true
    },
    ["Sawed Off"] = {
        Damage = 48,
        Range = 150,
        TextureId = "rbxassetid://4529698047",
        EspId = "rbxassetid://219397110",
        Grip = CFrame.new(0.5, 0, -0.15, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        IsAGun = true
    },
    ["Green Bull"] = {
        TextureId = "rbxassetid://4529731465",
        Grip = CFrame.new(-0, -0.121673584, -0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Drink = {
        KnockOut = 24,
        TextureId = "rbxassetid://4529730041",
        Grip = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Burger = {
        Health = 24,
        TextureId = "rbxassetid://4529727002",
        Grip = CFrame.new(0.5, -0.5, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Chicken = {
        Health = 12,
        KnockOut = 12,
        TextureId = "rbxassetid://4529727002",
        Grip = CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Lockpick = {
        TextureId = "rbxassetid://4529725135",
        Grip = CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    Jutsu = {
        TextureId = "",
        Grip = CFrame.new(0.3, -0.6, -0.2, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    },
    BoomBox = {
        TextureId = "rbxassetid://212303004",
        Grip = CFrame.new(0.5, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    },
    Spray = {
        TextureId = "rbxassetid://79155357",
        Grip = CFrame.new(0.2, -0.25, -0.2, 0.2675, 0, 0.9635, 0, 1, 0, -0.9635, 0, 0.2675)
    }
}

return ToolData
