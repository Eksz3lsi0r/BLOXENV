-- 🎨 PATTERN SELECTOR für Gaara's Sand Guardian System! 🏜️
-- Integriert 100 verschiedene Boden-Muster in das Sand-System

local PatternSelector = {}
PatternSelector.__index = PatternSelector

local FloorPatterns = require(script.Parent.FloorPatterns100)
local TweenService = game:GetService("TweenService")

function PatternSelector.new(sandGuardian)
    local self = setmetatable({}, PatternSelector)
    
    self.sandGuardian = sandGuardian
    self.currentPattern = nil
    self.isPatternActive = false
    self.patternHistory = {}
    
    return self
end

-- 🎯 Pattern nach ID aktivieren
function PatternSelector:ActivatePattern(patternId, customSettings)
    local pattern = FloorPatterns:GetPattern(patternId)
    if not pattern then
        warn("❌ Pattern ID " .. patternId .. " nicht gefunden!")
        return false
    end
    
    print("🎨 Aktiviere Pattern: " .. pattern.name)
    
    self.currentPattern = pattern
    self.isPatternActive = true
    
    -- Pattern zu History hinzufügen
    table.insert(self.patternHistory, {
        pattern = pattern,
        timestamp = tick(),
        settings = customSettings
    })
    
    -- Pattern ausführen basierend auf Typ
    self:ExecutePattern(pattern, customSettings)
    
    return true
end

-- ⚡ Pattern ausführen
function PatternSelector:ExecutePattern(pattern, settings)
    local floorParts = self.sandGuardian.allParts
    local colors = pattern.colors
    local duration = settings and settings.duration or pattern.duration
    local speed = settings and settings.speed or pattern.speed
    
    -- Speed zu Sekunden konvertieren
    local speedMultiplier = self:GetSpeedMultiplier(speed)
    
    -- Pattern-spezifische Ausführung
    if pattern.pattern == "wave" then
        self:ExecuteWavePattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "spiral" then
        self:ExecuteSpiralPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "explosion" then
        self:ExecuteExplosionPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "flowing" then
        self:ExecuteFlowingPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "pulsing" then
        self:ExecutePulsingPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "grid" then
        self:ExecuteGridPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "random" then
        self:ExecuteRandomPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "falling" then
        self:ExecuteFallingPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "growing" then
        self:ExecuteGrowingPattern(floorParts, colors, duration, speedMultiplier)
        
    elseif pattern.pattern == "disco" then
        self:ExecuteDiscoPattern(floorParts, colors, duration, speedMultiplier)
        
    else
        -- Standard Pattern
        self:ExecuteStandardPattern(floorParts, colors, duration, speedMultiplier)
    end
    
    -- Auto-Reset nach Pattern-Dauer
    task.spawn(function()
        task.wait(duration + 2)
        if self.isPatternActive then
            self:ResetToSandColor()
        end
    end)
end

-- 🌊 Wellen-Pattern
function PatternSelector:ExecuteWavePattern(parts, colors, duration, speed)
    local waves = 5
    local center = #parts / 2
    
    for wave = 1, waves do
        task.spawn(function()
            task.wait((wave - 1) * speed)
            
            for i, part in ipairs(parts) do
                local distance = math.abs(i - center)
                local waveDelay = (distance / center) * speed * 2
                
                task.spawn(function()
                    task.wait(waveDelay)
                    
                    local colorIndex = ((wave + math.floor(i / 10)) % #colors) + 1
                    local tween = TweenService:Create(part,
                        TweenInfo.new(speed, Enum.EasingStyle.Sine), {
                            Color = colors[colorIndex],
                            Material = Enum.Material.Neon,
                            Size = part.Size + Vector3.new(0, 0.2, 0)
                        })
                    tween:Play()
                end)
            end
        end)
    end
end

-- 🌀 Spiral-Pattern
function PatternSelector:ExecuteSpiralPattern(parts, colors, duration, speed)
    local spiralTurns = 3
    local center = Vector3.new(0, 0, 0)
    
    -- Berechne Zentrum aller Teile
    for _, part in ipairs(parts) do
        center = center + part.Position
    end
    center = center / #parts
    
    -- Teile nach Winkel vom Zentrum sortieren
    local sortedParts = {}
    for _, part in ipairs(parts) do
        local relativePos = part.Position - center
        local angle = math.atan2(relativePos.Z, relativePos.X)
        local distance = relativePos.Magnitude
        
        table.insert(sortedParts, {
            part = part,
            angle = angle,
            distance = distance
        })
    end
    
    table.sort(sortedParts, function(a, b) return a.angle < b.angle end)
    
    -- Spiral-Animation
    for turn = 1, spiralTurns do
        task.spawn(function()
            for i, data in ipairs(sortedParts) do
                task.spawn(function()
                    local delay = (i / #sortedParts) * speed + (turn - 1) * speed * 2
                    task.wait(delay)
                    
                    local colorIndex = ((turn + math.floor(i / 5)) % #colors) + 1
                    local tween = TweenService:Create(data.part,
                        TweenInfo.new(speed * 0.5), {
                            Color = colors[colorIndex],
                            Material = Enum.Material.ForceField,
                            Transparency = 0.2
                        })
                    tween:Play()
                end)
            end
        end)
    end
end

-- 💥 Explosion-Pattern
function PatternSelector:ExecuteExplosionPattern(parts, colors, duration, speed)
    local explosions = math.random(3, 8)
    
    for explosion = 1, explosions do
        task.spawn(function()
            task.wait(explosion * speed)
            
            -- Zufälliges Explosions-Zentrum
            local centerPart = parts[math.random(1, #parts)]
            local centerPos = centerPart.Position
            local explosionRadius = math.random(15, 30)
            
            -- Explosion ausbreiten
            for _, part in ipairs(parts) do
                local distance = (part.Position - centerPos).Magnitude
                
                if distance <= explosionRadius then
                    task.spawn(function()
                        local delay = (distance / explosionRadius) * speed * 0.5
                        task.wait(delay)
                        
                        local intensity = 1 - (distance / explosionRadius)
                        local colorIndex = math.random(1, #colors)
                        
                        local tween = TweenService:Create(part,
                            TweenInfo.new(speed * 0.3), {
                                Color = colors[colorIndex],
                                Material = Enum.Material.Neon,
                                Size = part.Size * (1 + intensity * 0.5),
                                Transparency = 0.1
                            })
                        tween:Play()
                        
                        task.wait(speed)
                        
                        local resetTween = TweenService:Create(part,
                            TweenInfo.new(speed), {
                                Size = Vector3.new(4, 0.2, 4),
                                Transparency = 0
                            })
                        resetTween:Play()
                    end)
                end
            end
        end)
    end
end

-- 🌊 Fließendes Pattern
function PatternSelector:ExecuteFlowingPattern(parts, colors, duration, speed)
    local flowDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
    
    for wave = 1, 6 do
        task.spawn(function()
            task.wait(wave * speed * 0.7)
            
            for _, part in ipairs(parts) do
                local dotProduct = part.Position:Dot(flowDirection)
                local delay = (dotProduct + 100) / 200 * speed * 2 -- Normalisieren
                
                task.spawn(function()
                    task.wait(delay)
                    
                    local colorIndex = ((wave + math.floor(delay * 10)) % #colors) + 1
                    local tween = TweenService:Create(part,
                        TweenInfo.new(speed), {
                            Color = colors[colorIndex],
                            Material = Enum.Material.Glass,
                            Transparency = 0.3
                        })
                    tween:Play()
                end)
            end
        end)
    end
end

-- 💓 Pulsierendes Pattern
function PatternSelector:ExecutePulsingPattern(parts, colors, duration, speed)
    local pulses = math.floor(duration / speed)
    
    for pulse = 1, pulses do
        task.spawn(function()
            task.wait((pulse - 1) * speed)
            
            local colorIndex = (pulse % #colors) + 1
            
            -- Alle Teile gleichzeitig
            for _, part in ipairs(parts) do
                task.spawn(function()
                    local tween = TweenService:Create(part,
                        TweenInfo.new(speed * 0.3), {
                            Color = colors[colorIndex],
                            Material = Enum.Material.Neon,
                            Size = part.Size * 1.1
                        })
                    tween:Play()
                    
                    task.wait(speed * 0.3)
                    
                    local resetTween = TweenService:Create(part,
                        TweenInfo.new(speed * 0.4), {
                            Size = Vector3.new(4, 0.2, 4)
                        })
                    resetTween:Play()
                end)
            end
        end)
    end
end

-- 🎆 Disco Pattern
function PatternSelector:ExecuteDiscoPattern(parts, colors, duration, speed)
    local discoBeats = math.floor(duration / (speed * 0.5))
    
    for beat = 1, discoBeats do
        task.spawn(function()
            task.wait((beat - 1) * speed * 0.5)
            
            -- Zufällige Teile für jeden Beat
            local activeParts = {}
            for i = 1, math.random(50, 200) do
                table.insert(activeParts, parts[math.random(1, #parts)])
            end
            
            for _, part in ipairs(activeParts) do
                task.spawn(function()
                    local colorIndex = math.random(1, #colors)
                    local tween = TweenService:Create(part,
                        TweenInfo.new(speed * 0.2), {
                            Color = colors[colorIndex],
                            Material = Enum.Material.Neon
                        })
                    tween:Play()
                end)
            end
        end)
    end
end

-- 📉 Speed Multiplier berechnen
function PatternSelector:GetSpeedMultiplier(speed)
    if speed == "ultra_fast" then return 0.1
    elseif speed == "fast" then return 0.3
    elseif speed == "medium" then return 0.6
    elseif speed == "slow" then return 1.2
    elseif speed == "sync_bpm" then return 0.5 -- BPM-sync für Musik
    else return 0.6 end -- Default medium
end

-- 🧹 Zurück zu Sand-Farbe
function PatternSelector:ResetToSandColor()
    print("🏜️ Pattern beendet - Zurück zu Sand-Farbe")
    
    for _, part in ipairs(self.sandGuardian.allParts) do
        task.spawn(function()
            local tween = TweenService:Create(part,
                TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
                    Color = self.sandGuardian.sandColors.normal,
                    Material = Enum.Material.Sand,
                    Size = Vector3.new(4, 0.2, 4),
                    Transparency = 0
                })
            tween:Play()
        end)
    end
    
    self.isPatternActive = false
    self.currentPattern = nil
end

-- 🎲 Zufälliges Pattern
function PatternSelector:ActivateRandomPattern(category)
    local pattern = FloorPatterns:GetRandomPattern(category)
    return self:ActivatePattern(pattern.id)
end

-- 📋 Pattern-History anzeigen
function PatternSelector:ShowHistory()
    print("📋 PATTERN HISTORY:")
    for i, entry in ipairs(self.patternHistory) do
        print(string.format("  %d. %s (vor %ds)", i, entry.pattern.name, tick() - entry.timestamp))
    end
end

-- 🔍 Pattern suchen und aktivieren
function PatternSelector:SearchAndActivate(searchTerm)
    local results = FloorPatterns:SearchPattern(searchTerm)
    
    if #results == 0 then
        print("❌ Keine Patterns gefunden für: " .. searchTerm)
        return false
    elseif #results == 1 then
        return self:ActivatePattern(results[1].id)
    else
        print("🔍 Mehrere Patterns gefunden:")
        for i, pattern in ipairs(results) do
            print("  " .. pattern.id .. ". " .. pattern.name)
        end
        return false
    end
end

return PatternSelector
