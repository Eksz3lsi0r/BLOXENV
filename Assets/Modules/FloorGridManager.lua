local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FloorGridManager = {}
FloorGridManager.__index = FloorGridManager

function FloorGridManager.new(size, segmentSize)
    local self = setmetatable({}, FloorGridManager)
    
    self.gridSize = size or 48
    self.segmentSize = segmentSize or 4 -- Größe jedes Floor-Segments
    self.segments = {}
    self.floorModel = nil
    
    -- Performance settings
    self.poolSize = 100 -- Object pooling für bessere Performance
    self.segmentPool = {}
    self.activeSegments = {}
    
    self:InitializeGrid()
    
    return self
end

function FloorGridManager:InitializeGrid()
    -- Erstelle Haupt-Floor Model
    self.floorModel = Instance.new("Model")
    self.floorModel.Name = "AnimatedFloor"
    self.floorModel.Parent = workspace
    
    -- Erstelle Grid-Structure
    for x = 1, self.gridSize do
        self.segments[x] = {}
        for z = 1, self.gridSize do
            self.segments[x][z] = self:CreateFloorSegment(x, z)
        end
        
        -- Frame break alle 10 Reihen für bessere Performance
        if x % 10 == 0 then
            task.wait()
        end
    end
    
    print("FloorGridManager: Initialized " .. self.gridSize .. "x" .. self.gridSize .. " grid")
end

function FloorGridManager:CreateFloorSegment(x, z)
    local segment = self:GetPooledSegment()
    
    if not segment then
        segment = Instance.new("Part")
        segment.Material = Enum.Material.Neon
        segment.Shape = Enum.PartType.Block
        segment.TopSurface = Enum.SurfaceType.Smooth
        segment.BottomSurface = Enum.SurfaceType.Smooth
    end
    
    -- Konfiguration
    segment.Name = "FloorSegment_" .. x .. "_" .. z
    segment.Size = Vector3.new(self.segmentSize, 0.2, self.segmentSize)
    segment.Position = Vector3.new(
        (x - self.gridSize/2) * self.segmentSize,
        0,
        (z - self.gridSize/2) * self.segmentSize
    )
    segment.Color = Color3.fromRGB(100, 100, 100) -- Standard-Farbe
    segment.Transparency = 0
    segment.CanCollide = true
    segment.Anchored = true
    segment.Parent = self.floorModel
    
    -- Eigenschaften für Animation
    segment:SetAttribute("GridX", x)
    segment:SetAttribute("GridZ", z)
    segment:SetAttribute("OriginalColor", segment.Color)
    segment:SetAttribute("IsAnimating", false)
    
    -- Optional: Texture für mehr Detail
    local texture = Instance.new("Texture")
    texture.Texture = "rbxasset://textures/terrain/grass.png"
    texture.Face = Enum.NormalId.Top
    texture.StudsPerTileU = self.segmentSize
    texture.StudsPerTileV = self.segmentSize
    texture.Parent = segment
    
    return segment
end

function FloorGridManager:GetPooledSegment()
    if #self.segmentPool > 0 then
        return table.remove(self.segmentPool)
    end
    return nil
end

function FloorGridManager:ReturnToPool(segment)
    -- Reset segment
    segment.Color = Color3.fromRGB(100, 100, 100)
    segment.Transparency = 0
    segment.Size = Vector3.new(self.segmentSize, 0.2, self.segmentSize)
    segment:SetAttribute("IsAnimating", false)
    segment.Parent = nil
    
    -- Add to pool if not full
    if #self.segmentPool < self.poolSize then
        table.insert(self.segmentPool, segment)
    else
        segment:Destroy()
    end
end

function FloorGridManager:GetSegment(x, z)
    if x >= 1 and x <= self.gridSize and z >= 1 and z <= self.gridSize then
        return self.segments[x][z]
    end
    return nil
end

function FloorGridManager:GetSegmentByWorldPosition(worldPos)
    local x = math.floor((worldPos.X + self.gridSize * self.segmentSize / 2) / self.segmentSize) + 1
    local z = math.floor((worldPos.Z + self.gridSize * self.segmentSize / 2) / self.segmentSize) + 1
    
    return self:GetSegment(x, z), x, z
end

-- LOD System - Reduziert Details bei Entfernung
function FloorGridManager:UpdateLOD(playerPosition)
    for x = 1, self.gridSize do
        for z = 1, self.gridSize do
            local segment = self.segments[x][z]
            if segment then
                local distance = (segment.Position - playerPosition).Magnitude
                
                -- Verschiedene LOD Stufen
                if distance > 150 then
                    -- Sehr weit - unsichtbar machen
                    segment.Transparency = 1
                elseif distance > 100 then
                    -- Weit - reduzierte Qualität
                    segment.Transparency = 0.7
                    segment.Material = Enum.Material.Plastic
                elseif distance > 50 then
                    -- Mittel - normale Qualität
                    segment.Transparency = 0.3
                    segment.Material = Enum.Material.SmoothPlastic
                else
                    -- Nah - volle Qualität
                    segment.Transparency = 0
                    segment.Material = Enum.Material.Neon
                end
            end
        end
        
        -- Frame break für Performance
        if x % 5 == 0 then
            task.wait()
        end
    end
end

-- Optimierte Bereichs-Updates
function FloorGridManager:UpdateRegion(centerX, centerZ, radius, updateFunction)
    local minX = math.max(1, centerX - radius)
    local maxX = math.min(self.gridSize, centerX + radius)
    local minZ = math.max(1, centerZ - radius)
    local maxZ = math.min(self.gridSize, centerZ + radius)
    
    for x = minX, maxX do
        for z = minZ, maxZ do
            local distance = math.sqrt((x - centerX)^2 + (z - centerZ)^2)
            if distance <= radius then
                local segment = self.segments[x][z]
                if segment then
                    updateFunction(segment, x, z, distance)
                end
            end
        end
    end
end

-- Spell-Integration Funktionen
function FloorGridManager:OnSpellCast(spellName, casterPosition, targetPosition)
    local _, casterX, casterZ = self:GetSegmentByWorldPosition(casterPosition)
    local _, targetX, targetZ = self:GetSegmentByWorldPosition(targetPosition)
    
    -- Load pattern library
    local PatternLibrary = require(ReplicatedStorage.Assets.Modules.PatternLibrary)
    local FloorAnimator = require(ReplicatedStorage.Assets.Modules.FloorAnimator)
    
    local animator = FloorAnimator.new(self.segments, self.gridSize)
    
    -- Verschiedene Spell-Effekte
    if spellName == "Fireball" then
        local direction = (targetPosition - casterPosition).Unit
        PatternLibrary.WizardHeroPatterns.FireballTrail(animator, targetPosition, direction)
        
    elseif spellName == "IceSpike" then
        PatternLibrary.WizardHeroPatterns.IceExplosion(animator, targetX, targetZ)
        
    elseif spellName == "Lightning" then
        local positions = {casterPosition, targetPosition}
        PatternLibrary.WizardHeroPatterns.LightningStorm(animator, positions)
    end
end

function FloorGridManager:OnEnemyDeath(enemyPosition)
    local _, x, z = self:GetSegmentByWorldPosition(enemyPosition)
    
    -- Tod-Effekt
    self:UpdateRegion(x, z, 3, function(segment, segX, segZ, distance)
        local intensity = 1 - (distance / 3)
        segment.Color = Color3.fromRGB(
            100 + intensity * 100,
            100 - intensity * 50,
            100 - intensity * 50
        )
        
        -- Auto-reset nach 2 Sekunden
        task.wait(2)
        segment.Color = segment:GetAttribute("OriginalColor")
    end)
end

function FloorGridManager:OnPlayerTakeDamage(playerPosition, damageAmount)
    local _, x, z = self:GetSegmentByWorldPosition(playerPosition)
    
    -- Schaden-Indikator
    local radius = math.min(5, damageAmount / 10)
    self:UpdateRegion(x, z, radius, function(segment, segX, segZ, distance)
        segment.Color = Color3.fromRGB(255, 0, 0)
        segment.Transparency = 0.5
        
        -- Quick fade
        task.wait(0.5)
        segment.Color = segment:GetAttribute("OriginalColor")
        segment.Transparency = 0
    end)
end

-- Performance monitoring
function FloorGridManager:StartPerformanceMonitoring()
    local lastCheck = tick()
    local frameCount = 0
    
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        
        if tick() - lastCheck > 5 then
            local fps = frameCount / 5
            
            if fps < 30 then
                warn("FloorGridManager: Low FPS detected: " .. fps .. ". Consider reducing grid size or effects.")
                
                -- Auto-optimize
                self:OptimizeForPerformance()
            end
            
            frameCount = 0
            lastCheck = tick()
        end
    end)
end

function FloorGridManager:OptimizeForPerformance()
    -- Reduziere Qualität für bessere Performance
    for x = 1, self.gridSize do
        for z = 1, self.gridSize do
            local segment = self.segments[x][z]
            if segment then
                segment.Material = Enum.Material.Plastic
                
                -- Entferne Texture bei Performance-Problemen
                local texture = segment:FindFirstChild("Texture")
                if texture then
                    texture:Destroy()
                end
            end
        end
        
        if x % 10 == 0 then
            task.wait()
        end
    end
end

function FloorGridManager:Cleanup()
    if self.floorModel then
        self.floorModel:Destroy()
    end
    
    -- Clear pools
    for _, segment in ipairs(self.segmentPool) do
        segment:Destroy()
    end
    
    self.segments = {}
    self.segmentPool = {}
    self.activeSegments = {}
end

return FloorGridManager
