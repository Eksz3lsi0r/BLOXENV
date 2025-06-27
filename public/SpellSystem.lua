local SpellSystem = {}
SpellSystem.__index = SpellSystem

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

-- Spell configurations
local spellConfigs = {
    Fireball = {
        damage = 25,
        speed = 50,
        color = Color3.fromRGB(255, 89, 0),
        size = Vector3.new(2, 2, 2),
        manaCost = 10
    },
    IceSpike = {
        damage = 35,
        speed = 40,
        color = Color3.fromRGB(173, 216, 230),
        size = Vector3.new(1, 4, 1),
        manaCost = 15
    },
    Lightning = {
        damage = 50,
        speed = 100,
        color = Color3.fromRGB(138, 43, 226),
        size = Vector3.new(0.5, 0.5, 20),
        manaCost = 20,
        isInstant = true
    }
}

function SpellSystem.new()
    local self = setmetatable({}, SpellSystem)
    return self
end

function SpellSystem:CastSpell(caster, spellName, targetPosition)
    local config = spellConfigs[spellName]
    if not config then return end
    
    local character = caster.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Deduct mana
    local mana = character:FindFirstChild("Mana")
    if mana and mana.Value >= config.manaCost then
        mana.Value = mana.Value - config.manaCost
    else
        return false -- Not enough mana
    end
    
    if config.isInstant then
        self:CastInstantSpell(humanoidRootPart.Position, targetPosition, config)
    else
        self:CastProjectileSpell(humanoidRootPart.Position, targetPosition, config)
    end
    
    return true
end

function SpellSystem:CastProjectileSpell(origin, target, config)
    -- Create projectile
    local projectile = Instance.new("Part")
    projectile.Name = "Projectile"
    projectile.Size = config.size
    projectile.Material = Enum.Material.Neon
    projectile.BrickColor = BrickColor.new(config.color)
    projectile.CanCollide = false
    projectile.CFrame = CFrame.new(origin, target)
    projectile.Parent = workspace
    
    -- Add light
    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Color = config.color
    light.Range = 10
    light.Parent = projectile
    
    -- Add particle effect
    local attachment = Instance.new("Attachment")
    attachment.Parent = projectile
    
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particle.Rate = 50
    particle.Lifetime = NumberRange.new(0.5)
    particle.Speed = NumberRange.new(2)
    particle.SpreadAngle = Vector2.new(10, 10)
    particle.Color = ColorSequence.new(config.color)
    particle.Parent = attachment
    
    -- Movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (target - origin).Unit * config.speed
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = projectile
    
    -- Damage on touch
    local hit = false
    projectile.Touched:Connect(function(hitPart)
        if hit then return end
        
        local humanoid = hitPart.Parent:FindFirstChild("Humanoid")
        if humanoid and hitPart.Parent.Name ~= "Wizard" then
            hit = true
            humanoid:TakeDamage(config.damage)
            
            -- Impact effect
            self:CreateImpactEffect(projectile.Position, config.color)
            projectile:Destroy()
        end
    end)
    
    -- Auto destroy after 5 seconds
    Debris:AddItem(projectile, 5)
end

function SpellSystem:CastInstantSpell(origin, target, config)
    -- Lightning bolt effect
    local beam = Instance.new("Part")
    beam.Name = "LightningBeam"
    beam.Size = Vector3.new(1, 1, (target - origin).Magnitude)
    beam.Material = Enum.Material.Neon
    beam.BrickColor = BrickColor.new(config.color)
    beam.CanCollide = false
    beam.Anchored = true
    beam.CFrame = CFrame.lookAt(origin, target) * CFrame.new(0, 0, -(target - origin).Magnitude/2)
    beam.Parent = workspace
    
    -- Damage all enemies in line
    local region = Region3.new(
        Vector3.new(math.min(origin.X, target.X), math.min(origin.Y, target.Y), math.min(origin.Z, target.Z)),
        Vector3.new(math.max(origin.X, target.X), math.max(origin.Y, target.Y), math.max(origin.Z, target.Z))
    )
    region = region:ExpandToGrid(4)
    
    local parts = workspace:FindPartsInRegion3(region, nil, 100)
    for _, part in ipairs(parts) do
        local humanoid = part.Parent:FindFirstChild("Humanoid")
        if humanoid and part.Parent:FindFirstChild("Enemy") then
            humanoid:TakeDamage(config.damage)
        end
    end
    
    -- Fade out effect
    local tween = TweenService:Create(
        beam,
        TweenInfo.new(0.3),
        {Transparency = 1}
    )
    tween:Play()
    
    Debris:AddItem(beam, 0.3)
end

function SpellSystem:CreateImpactEffect(position, color)
    -- Explosion effect
    local explosion = Instance.new("Part")
    explosion.Name = "Explosion"
    explosion.Shape = Enum.PartType.Ball
    explosion.Material = Enum.Material.Neon
    explosion.BrickColor = BrickColor.new(color)
    explosion.Size = Vector3.new(1, 1, 1)
    explosion.CanCollide = false
    explosion.Anchored = true
    explosion.Position = position
    explosion.Parent = workspace
    
    local tween = TweenService:Create(
        explosion,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = Vector3.new(10, 10, 10), Transparency = 1}
    )
    tween:Play()
    
    Debris:AddItem(explosion, 0.5)
end

return SpellSystem