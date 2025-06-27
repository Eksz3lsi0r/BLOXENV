local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local FloorAnimator = {}
FloorAnimator.__index = FloorAnimator

function FloorAnimator.new(floorSegments, gridSize)
    local self = setmetatable({}, FloorAnimator)
    self.segments = floorSegments or {}
    self.gridSize = gridSize or 48
    self.activeEffects = {}
    self.updateQueue = {}
    self.batchSize = 50 -- Nur 50 Segmente pro Frame updaten
    self.lastUpdate = 0
    
    -- Performance tracking
    self.frameCount = 0
    self.lastPerformanceCheck = tick()
    
    -- Start update loop
    self:StartUpdateLoop()
    
    return self
end

function FloorAnimator:StartUpdateLoop()
    self.heartbeatConnection = RunService.Heartbeat:Connect(function()
        self:ProcessBatch()
        self:UpdateActiveEffects()
        self:CheckPerformance()
    end)
end

-- Performance-optimierte Batch-Verarbeitung
function FloorAnimator:ProcessBatch()
    local processed = 0
    
    while #self.updateQueue > 0 and processed < self.batchSize do
        local update = table.remove(self.updateQueue, 1)
        local segment = self:GetSegment(update.x, update.z)
        
        if segment then
            -- Tween für smooth animation
            local tween = TweenService:Create(segment, 
                TweenInfo.new(update.duration or 0.3, Enum.EasingStyle.Quad), 
                {
                    Color = update.color,
                    Transparency = update.transparency or 0,
                    Size = update.size or segment.Size
                }
            )
            tween:Play()
            
            -- Auto-reset nach Effekt
            if update.autoReset then
                task.wait(update.resetDelay or 1)
                self:QueueUpdate(update.x, update.z, 
                    Color3.fromRGB(100, 100, 100), 0, nil, 0.5)
            end
        end
        
        processed = processed + 1
    end
end

function FloorAnimator:GetSegment(x, z)
    if self.segments[x] and self.segments[x][z] then
        return self.segments[x][z]
    end
    return nil
end

function FloorAnimator:QueueUpdate(x, z, color, transparency, size, duration, autoReset, resetDelay)
    -- Bounds checking
    if x < 1 or x > self.gridSize or z < 1 or z > self.gridSize then
        return
    end
    
    table.insert(self.updateQueue, {
        x = x,
        z = z,
        color = color,
        transparency = transparency,
        size = size,
        duration = duration,
        autoReset = autoReset,
        resetDelay = resetDelay
    })
end

-- FEUER-SPUR nach Projektil (für Fireball)
function FloorAnimator:CreateFireTrail(path, delay)
    local effect = {
        type = "fireTrail",
        path = path,
        delay = delay,
        startTime = tick() + delay,
        currentIndex = 1
    }
    
    table.insert(self.activeEffects, effect)
end

-- WELLEN-EFFEKT für Magie-Angriffe
function FloorAnimator:CreateWaveEffect(centerX, centerZ, radius, duration, color)
    local effect = {
        type = "wave",
        centerX = centerX,
        centerZ = centerZ,
        maxRadius = radius,
        duration = duration,
        startTime = tick(),
        color = color or Color3.fromRGB(100, 200, 255)
    }
    
    table.insert(self.activeEffects, effect)
end

-- EXPLOSION/SHOCKWAVE für große Zauber
function FloorAnimator:CreateShockwave(centerX, centerZ, maxRadius, duration, colors)
    local effect = {
        type = "shockwave",
        centerX = centerX,
        centerZ = centerZ,
        maxRadius = maxRadius,
        duration = duration,
        startTime = tick(),
        colors = colors or {Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 200, 0)}
    }
    
    table.insert(self.activeEffects, effect)
end

-- SPIRALE für defensive/offensive Zauber
function FloorAnimator:CreateSpiral(centerX, centerZ, maxRadius, duration, direction, color)
    local effect = {
        type = "spiral",
        centerX = centerX,
        centerZ = centerZ,
        maxRadius = maxRadius,
        duration = duration,
        startTime = tick(),
        direction = direction or 1, -- 1 = clockwise, -1 = counter-clockwise
        color = color or Color3.fromRGB(138, 43, 226)
    }
    
    table.insert(self.activeEffects, effect)
end

-- LIGHTNING CHAIN zwischen Feinden
function FloorAnimator:CreateLightningChain(positions, duration)
    local effect = {
        type = "lightningChain",
        positions = positions,
        duration = duration,
        startTime = tick(),
        color = Color3.fromRGB(255, 255, 100)
    }
    
    table.insert(self.activeEffects, effect)
end

-- WIZARD HERO SPECIFIC PATTERNS (wie im Original)
function FloorAnimator:CreateWizardHeroEffect(effectType, centerX, centerZ, data)
    if effectType == "fireballImpact" then
        -- Feuerball-Impact mit nachfolgender Spur
        self:CreateShockwave(centerX, centerZ, 8, 1.2, {
            Color3.fromRGB(255, 100, 0),
            Color3.fromRGB(255, 150, 0),
            Color3.fromRGB(255, 200, 100)
        })
        
        -- Brennende Fläche für 3 Sekunden
        task.wait(0.2)
        self:CreateBurningArea(centerX, centerZ, 6, 3)
        
    elseif effectType == "iceSpikePattern" then
        -- Zentrale Explosion
        self:CreateShockwave(centerX, centerZ, 5, 0.8, {
            Color3.fromRGB(173, 216, 230),
            Color3.fromRGB(135, 206, 250)
        })
        
        -- 6 Eis-Kristalle in alle Richtungen
        for i = 1, 6 do
            local angle = (i - 1) * math.pi / 3
            local x = centerX + math.cos(angle) * 10
            local z = centerZ + math.sin(angle) * 10
            
            task.wait(0.1)
            self:CreateWaveEffect(x, z, 4, 1, Color3.fromRGB(173, 216, 230))
        end
        
    elseif effectType == "lightningStorm" then
        -- Mehrere Lightning-Strikes
        for i = 1, data.strikeCount or 5 do
            local x = centerX + math.random(-15, 15)
            local z = centerZ + math.random(-15, 15)
            
            self:CreateLightningStrike(x, z)
            task.wait(0.15)
        end
        
    elseif effectType == "healingCircle" then
        -- Sanfte Heilungskreise
        for radius = 2, 12, 2 do
            self:CreateHealingRing(centerX, centerZ, radius, 1.5)
            task.wait(0.3)
        end
    end
end

-- Brennende Fläche (persistent effect)
function FloorAnimator:CreateBurningArea(centerX, centerZ, radius, duration)
    local effect = {
        type = "burningArea",
        centerX = centerX,
        centerZ = centerZ,
        radius = radius,
        duration = duration,
        startTime = tick(),
        intensity = 1
    }
    
    table.insert(self.activeEffects, effect)
end

-- Lightning Strike (instant effect)
function FloorAnimator:CreateLightningStrike(x, z)
    -- Warnung vor Strike
    self:QueueUpdate(x, z, Color3.fromRGB(255, 255, 200), 0.3, nil, 0.1)
    
    task.wait(0.2)
    
    -- Lightning Impact
    for dx = -2, 2 do
        for dz = -2, 2 do
            local distance = math.sqrt(dx^2 + dz^2)
            if distance <= 2 then
                local alpha = 1 - (distance / 2)
                self:QueueUpdate(x + dx, z + dz, 
                    Color3.fromRGB(255, 255, 100), 0.2 * alpha, nil, 0.05, true, 0.3)
            end
        end
    end
end

-- Heilungsring
function FloorAnimator:CreateHealingRing(centerX, centerZ, radius, duration)
    local effect = {
        type = "healingRing",
        centerX = centerX,
        centerZ = centerZ,
        radius = radius,
        duration = duration,
        startTime = tick(),
        color = Color3.fromRGB(144, 238, 144)
    }
    
    table.insert(self.activeEffects, effect)
end

function FloorAnimator:UpdateActiveEffects()
    for i = #self.activeEffects, 1, -1 do
        local effect = self.activeEffects[i]
        local elapsed = tick() - effect.startTime
        
        if elapsed >= 0 then -- Effect started
            if effect.type == "fireTrail" then
                self:UpdateFireTrail(effect, elapsed)
            elseif effect.type == "wave" then
                self:UpdateWave(effect, elapsed)
            elseif effect.type == "shockwave" then
                self:UpdateShockwave(effect, elapsed)
            elseif effect.type == "spiral" then
                self:UpdateSpiral(effect, elapsed)
            elseif effect.type == "lightningChain" then
                self:UpdateLightningChain(effect, elapsed)
            elseif effect.type == "burningArea" then
                self:UpdateBurningArea(effect, elapsed)
            elseif effect.type == "healingRing" then
                self:UpdateHealingRing(effect, elapsed)
            end
            
            -- Remove finished effects
            if elapsed > effect.duration then
                table.remove(self.activeEffects, i)
            end
        end
    end
end

function FloorAnimator:UpdateFireTrail(effect, elapsed)
    local progress = math.min(elapsed / effect.duration, 1)
    local targetIndex = math.floor(progress * #effect.path) + 1
    
    -- Add new fire segments
    while effect.currentIndex <= targetIndex and effect.currentIndex <= #effect.path do
        local pos = effect.path[effect.currentIndex]
        local x, z = math.floor(pos.X), math.floor(pos.Z)
        
        self:QueueUpdate(x, z, 
            Color3.fromRGB(255, 100 + math.random(-20, 20), 0), 
            0.3, nil, 0.2, true, 2)
        
        effect.currentIndex = effect.currentIndex + 1
        
        -- Throttle for performance
        if effect.currentIndex % 3 == 0 then
            task.wait()
        end
    end
end

function FloorAnimator:UpdateWave(effect, elapsed)
    local progress = elapsed / effect.duration
    local currentRadius = progress * effect.maxRadius
    
    -- OPTIMIERT: Nur relevanten Bereich durchsuchen statt gesamtes Grid
    local minX = math.max(1, math.floor(effect.centerX - currentRadius - 2))
    local maxX = math.min(self.gridSize, math.ceil(effect.centerX + currentRadius + 2))
    local minZ = math.max(1, math.floor(effect.centerZ - currentRadius - 2))
    local maxZ = math.min(self.gridSize, math.ceil(effect.centerZ + currentRadius + 2))
    
    -- Ring effect nur im relevanten Bereich
    for x = minX, maxX do
        for z = minZ, maxZ do
            local distance = math.sqrt((x - effect.centerX)^2 + (z - effect.centerZ)^2)
            
            if math.abs(distance - currentRadius) < 1.5 then
                local alpha = 1 - progress
                self:QueueUpdate(x, z, effect.color, 0.5 * alpha, nil, 0.1)
            end
        end
    end
end

function FloorAnimator:UpdateShockwave(effect, elapsed)
    local progress = elapsed / effect.duration
    local currentRadius = progress * effect.maxRadius
    
    -- OPTIMIERT: Nur relevanten Bereich durchsuchen
    local minX = math.max(1, math.floor(effect.centerX - currentRadius - 3))
    local maxX = math.min(self.gridSize, math.ceil(effect.centerX + currentRadius + 3))
    local minZ = math.max(1, math.floor(effect.centerZ - currentRadius - 3))
    local maxZ = math.min(self.gridSize, math.ceil(effect.centerZ + currentRadius + 3))
    
    for x = minX, maxX do
        for z = minZ, maxZ do
            local distance = math.sqrt((x - effect.centerX)^2 + (z - effect.centerZ)^2)
            
            if distance <= currentRadius and distance >= currentRadius - 3 then
                local colorIndex = math.min(math.floor(progress * #effect.colors) + 1, #effect.colors)
                local alpha = 1 - (distance / effect.maxRadius)
                
                self:QueueUpdate(x, z, effect.colors[colorIndex], 0.3 * alpha, nil, 0.15)
            end
        end
    end
end

function FloorAnimator:UpdateSpiral(effect, elapsed)
    local progress = elapsed / effect.duration
    local maxAngle = progress * math.pi * 6 * effect.direction -- 3 full rotations
    local step = 0.3
    
    local angle = 0
    local radius = 0
    
    while angle <= maxAngle and radius <= effect.maxRadius do
        local x = math.floor(effect.centerX + math.cos(angle) * radius)
        local z = math.floor(effect.centerZ + math.sin(angle) * radius)
        
        if x >= 1 and x <= self.gridSize and z >= 1 and z <= self.gridSize then
            local alpha = 1 - (radius / effect.maxRadius)
            self:QueueUpdate(x, z, effect.color, 0.4 * alpha, nil, 0.2)
        end
        
        angle = angle + step
        radius = radius + 0.2
    end
end

function FloorAnimator:UpdateLightningChain(effect, elapsed)
    -- Connect positions with lightning lines
    for i = 1, #effect.positions - 1 do
        local start = effect.positions[i]
        local target = effect.positions[i + 1]
        
        local steps = math.floor((target - start).Magnitude)
        for step = 0, steps do
            local pos = start:lerp(target, step / steps)
            local x, z = math.floor(pos.X), math.floor(pos.Z)
            
            -- Add random jitter for lightning effect
            x = x + math.random(-1, 1)
            z = z + math.random(-1, 1)
            
            if x >= 1 and x <= self.gridSize and z >= 1 and z <= self.gridSize then
                self:QueueUpdate(x, z, effect.color, 0.2, nil, 0.1)
            end
        end
    end
end

function FloorAnimator:UpdateBurningArea(effect, elapsed)
    local progress = elapsed / effect.duration
    local intensity = effect.intensity * (1 - progress) -- Schwächer werdend
    
    -- Flackerndes Feuer-Pattern
    local flicker = math.sin(elapsed * 10) * 0.3 + 0.7
    
    for x = effect.centerX - effect.radius, effect.centerX + effect.radius do
        for z = effect.centerZ - effect.radius, effect.centerZ + effect.radius do
            local distance = math.sqrt((x - effect.centerX)^2 + (z - effect.centerZ)^2)
            
            if distance <= effect.radius and math.random() < 0.3 then -- Nur 30% der Tiles pro Update
                local alpha = intensity * flicker * (1 - distance / effect.radius)
                local red = 255
                local green = math.floor(100 * alpha + math.random(-20, 20))
                local blue = 0
                
                self:QueueUpdate(x, z, 
                    Color3.fromRGB(red, green, blue), 0.4 * alpha, nil, 0.1)
            end
        end
    end
end

function FloorAnimator:UpdateHealingRing(effect, elapsed)
    local progress = elapsed / effect.duration
    local currentRadius = progress * effect.radius
    
    -- Sanft pulsierender Ring
    local pulse = math.sin(elapsed * 5) * 0.2 + 0.8
    
    for x = effect.centerX - effect.radius - 2, effect.centerX + effect.radius + 2 do
        for z = effect.centerZ - effect.radius - 2, effect.centerZ + effect.radius + 2 do
            local distance = math.sqrt((x - effect.centerX)^2 + (z - effect.centerZ)^2)
            
            if math.abs(distance - currentRadius) < 1 then
                local alpha = pulse * (1 - progress)
                self:QueueUpdate(x, z, effect.color, 0.6 * alpha, nil, 0.2)
            end
        end
    end
end

function FloorAnimator:CheckPerformance()
    self.frameCount = self.frameCount + 1
    
    if tick() - self.lastPerformanceCheck > 5 then -- Check every 5 seconds
        local fps = self.frameCount / 5
        
        if fps < 30 then
            -- Reduce quality for performance
            self.batchSize = math.max(self.batchSize - 10, 20)
            warn("FloorAnimator: Reducing batch size to " .. self.batchSize .. " due to low FPS: " .. fps)
        elseif fps > 55 and self.batchSize < 100 then
            -- Increase quality if performance is good
            self.batchSize = self.batchSize + 5
        end
        
        self.frameCount = 0
        self.lastPerformanceCheck = tick()
    end
end

function FloorAnimator:Cleanup()
    if self.heartbeatConnection then
        self.heartbeatConnection:Disconnect()
    end
    
    self.activeEffects = {}
    self.updateQueue = {}
end

function FloorAnimator:GetVisibleRegion(playerPosition, maxDistance)
    maxDistance = maxDistance or 100
    
    local playerX = math.floor(playerPosition.X / 4) + 24 -- Convert to grid coords
    local playerZ = math.floor(playerPosition.Z / 4) + 24
    local gridRadius = math.floor(maxDistance / 4)
    
    return {
        minX = math.max(1, playerX - gridRadius),
        maxX = math.min(self.gridSize, playerX + gridRadius),
        minZ = math.max(1, playerZ - gridRadius),
        maxZ = math.min(self.gridSize, playerZ + gridRadius)
    }
end

return FloorAnimator
