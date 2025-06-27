-- 🚀 FLOOR SEGMENT SETUP & CONTROL - Für dein 48x48 Grid! 🎨
-- Dieser Code zeigt dir, wie du jedes der 2300+ Teile perfekt ansprichst

local FloorController = {}
FloorController.__index = FloorController

-- 🎯 SCHRITT 1: Dein FloorSegment Model analysieren und aufbauen
function FloorController.new(floorSegmentModel)
    local self = setmetatable({}, FloorController)
    
    self.model = floorSegmentModel
    self.segments = {}
    self.gridSize = 48
    self.totalParts = 0
    
    -- FloorSegment Teile automatisch finden und organisieren
    self:AnalyzeFloorStructure()
    self:BuildSegmentGrid()
    
    return self
end

-- 🔍 Analysiere die Struktur deines FloorSegments
function FloorController:AnalyzeFloorStructure()
    print("🔍 Analyzing FloorSegment structure...")
    
    local allParts = {}
    
    -- Alle Parts im Model finden (rekursiv)
    local function findParts(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(allParts, child)
                self.totalParts = self.totalParts + 1
            elseif child:IsA("Model") or child:IsA("Folder") then
                findParts(child)
            end
        end
    end
    
    findParts(self.model)
    
    print("✅ Found " .. self.totalParts .. " floor parts!")
    
    -- Parts nach Position sortieren
    table.sort(allParts, function(a, b)
        if math.abs(a.Position.X - b.Position.X) < 0.1 then
            return a.Position.Z < b.Position.Z
        end
        return a.Position.X < b.Position.X
    end)
    
    self.allParts = allParts
    return allParts
end

-- 🗂️ Grid-System aufbauen (48x48 Array)
function FloorController:BuildSegmentGrid()
    print("🗂️ Building 48x48 grid system...")
    
    -- Grid initialisieren
    for x = 1, self.gridSize do
        self.segments[x] = {}
    end
    
    -- Bounding Box des gesamten Floors berechnen
    local minX, maxX = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    
    for _, part in ipairs(self.allParts) do
        minX = math.min(minX, part.Position.X)
        maxX = math.max(maxX, part.Position.X)
        minZ = math.min(minZ, part.Position.Z)
        maxZ = math.max(maxZ, part.Position.Z)
    end
    
    local sizeX = maxX - minX
    local sizeZ = maxZ - minZ
    local segmentSizeX = sizeX / self.gridSize
    local segmentSizeZ = sizeZ / self.gridSize
    
    print("📏 Floor bounds: X(" .. minX .. " to " .. maxX .. "), Z(" .. minZ .. " to " .. maxZ .. ")")
    print("📐 Segment size: " .. segmentSizeX .. " x " .. segmentSizeZ)
    
    -- Jeden Part der richtigen Grid-Position zuordnen
    for _, part in ipairs(self.allParts) do
        local gridX = math.floor((part.Position.X - minX) / segmentSizeX) + 1
        local gridZ = math.floor((part.Position.Z - minZ) / segmentSizeZ) + 1
        
        -- Bounds checking
        gridX = math.max(1, math.min(self.gridSize, gridX))
        gridZ = math.max(1, math.min(self.gridSize, gridZ))
        
        -- Part in Grid speichern
        if not self.segments[gridX][gridZ] then
            self.segments[gridX][gridZ] = {}
        end
        table.insert(self.segments[gridX][gridZ], part)
    end
    
    print("✅ Grid system built! Ready for pattern magic! 🎨")
end

-- ⚡ ULTRA-SCHNELLE Teil-Transformation
function FloorController:TransformSegment(x, z, properties, duration)
    duration = duration or 0.3
    
    if not self.segments[x] or not self.segments[x][z] then
        return false
    end
    
    local parts = self.segments[x][z]
    
    -- Alle Parts in diesem Grid-Segment transformieren
    for _, part in ipairs(parts) do
        if part and part.Parent then
            -- TweenService für smooth Animationen
            local tweenInfo = TweenInfo.new(
                duration,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
            
            local tween = game:GetService("TweenService"):Create(part, tweenInfo, properties)
            tween:Play()
            
            -- Cleanup nach Animation
            if properties.autoCleanup then
                task.spawn(function()
                    task.wait(duration + (properties.resetDelay or 1))
                    if part and part.Parent then
                        local resetTween = game:GetService("TweenService"):Create(part, 
                            TweenInfo.new(0.5), {
                                Color = Color3.fromRGB(100, 100, 100),
                                Transparency = 0,
                                Size = part.Size -- Original Größe
                            })
                        resetTween:Play()
                    end
                end)
            end
        end
    end
    
    return true
end

-- 🎨 BATCH-TRANSFORMATION (für Performance bei vielen Segmenten)
function FloorController:BatchTransform(transformList, batchSize)
    batchSize = batchSize or 50 -- Max 50 Segmente pro Frame
    
    local processed = 0
    local totalTransforms = #transformList
    
    local function processBatch()
        local batchCount = 0
        
        while processed < totalTransforms and batchCount < batchSize do
            processed = processed + 1
            local transform = transformList[processed]
            
            if transform then
                self:TransformSegment(transform.x, transform.z, transform.properties, transform.duration)
                batchCount = batchCount + 1
            end
        end
        
        -- Wenn noch mehr zu verarbeiten ist, nächsten Frame warten
        if processed < totalTransforms then
            task.wait()
            processBatch()
        else
            print("✅ Batch transformation complete! " .. totalTransforms .. " segments processed")
        end
    end
    
    processBatch()
end

-- 🎯 DIREKTE KOORDINATEN-TRANSFORMATION (für deine Pattern-Systeme)
function FloorController:UpdateSegment(x, z, color, transparency, size, duration, autoReset, resetDelay)
    local properties = {}
    
    if color then properties.Color = color end
    if transparency then properties.Transparency = transparency end
    if size then properties.Size = size end
    if autoReset ~= nil then properties.autoCleanup = autoReset end
    if resetDelay then properties.resetDelay = resetDelay end
    
    return self:TransformSegment(x, z, properties, duration)
end

-- 🌊 WELLEN-EFFEKT über das gesamte Floor
function FloorController:CreateWaveEffect(centerX, centerZ, maxRadius, duration, color)
    local waveTransforms = {}
    
    for x = 1, self.gridSize do
        for z = 1, self.gridSize do
            local distance = math.sqrt((x - centerX)^2 + (z - centerZ)^2)
            
            if distance <= maxRadius then
                local delay = (distance / maxRadius) * duration * 0.5
                local alpha = 1 - (distance / maxRadius)
                
                table.insert(waveTransforms, {
                    x = x,
                    z = z,
                    properties = {
                        Color = color,
                        Transparency = 0.5 * alpha,
                        autoCleanup = true,
                        resetDelay = 2
                    },
                    duration = duration,
                    delay = delay
                })
            end
        end
    end
    
    -- Zeitversetzte Ausführung für Wellen-Effekt
    task.spawn(function()
        table.sort(waveTransforms, function(a, b) return a.delay < b.delay end)
        
        for _, transform in ipairs(waveTransforms) do
            if transform.delay > 0 then
                task.wait(transform.delay)
            end
            
            self:TransformSegment(transform.x, transform.z, transform.properties, transform.duration)
        end
    end)
end

-- 🎆 SPEKTAKULÄRER REGENBOGEN-EFFEKT
function FloorController:CreateRainbowSpiral(centerX, centerZ, maxRadius)
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),    -- Rot
        Color3.fromRGB(255, 127, 0),  -- Orange
        Color3.fromRGB(255, 255, 0),  -- Gelb
        Color3.fromRGB(0, 255, 0),    -- Grün
        Color3.fromRGB(0, 0, 255),    -- Blau
        Color3.fromRGB(75, 0, 130),   -- Indigo
        Color3.fromRGB(148, 0, 211)   -- Violett
    }
    
    task.spawn(function()
        local angle = 0
        local radius = 0
        local colorIndex = 1
        
        while radius <= maxRadius do
            local x = math.floor(centerX + math.cos(angle) * radius)
            local z = math.floor(centerZ + math.sin(angle) * radius)
            
            if x >= 1 and x <= self.gridSize and z >= 1 and z <= self.gridSize then
                self:UpdateSegment(x, z, rainbowColors[colorIndex], 0.2, nil, 0.5, true, 2)
            end
            
            angle = angle + 0.3
            radius = radius + 0.15
            colorIndex = (colorIndex % #rainbowColors) + 1
            
            task.wait(0.02) -- Smooth animation
        end
    end)
end

-- 🔥 ULTRA-SCHNELLE PERFORMANCE PATTERNS
function FloorController:PerformanceTestPattern()
    print("🚀 Starting ULTRA-SPEED Performance Test!")
    
    local startTime = tick()
    local transforms = {}
    
    -- 1000 zufällige Transformationen vorbereiten
    for i = 1, 1000 do
        table.insert(transforms, {
            x = math.random(1, self.gridSize),
            z = math.random(1, self.gridSize),
            properties = {
                Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
                Transparency = math.random(10, 50) / 100,
                autoCleanup = true,
                resetDelay = 2
            },
            duration = 0.3
        })
    end
    
    -- Batch-Verarbeitung
    self:BatchTransform(transforms, 75)
    
    local endTime = tick()
    print("⚡ Performance test completed in " .. math.floor((endTime - startTime) * 1000) .. "ms")
end

-- 🎮 INTEGRATION MIT DEINEM BESTEHENDEN SYSTEM
function FloorController:IntegrateWithFloorAnimator()
    local FloorAnimator = require(game.ReplicatedStorage.Assets.Modules.FloorAnimator)
    
    -- FloorAnimator mit deinem Grid initialisieren
    local floorAnimator = FloorAnimator.new(self.segments, self.gridSize)
    
    -- Custom QueueUpdate Funktion für dein System
    function floorAnimator:QueueUpdate(x, z, color, transparency, size, duration, autoReset, resetDelay)
        return self.floorController:UpdateSegment(x, z, color, transparency, size, duration, autoReset, resetDelay)
    end
    
    floorAnimator.floorController = self
    
    print("🔗 FloorController integrated with FloorAnimator!")
    return floorAnimator
end

return FloorController
