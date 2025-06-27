local PatternLibrary = {}

-- WIZARD HERO PATTERNS - Inspiriert vom Original
PatternLibrary.WizardHeroPatterns = {
    
    -- Feuerball-Spur (nach Projektil-Impact) - WIZARD HERO STIL
    FireballTrail = function(floorAnimator, impactPosition, direction)
        local x, z = math.floor(impactPosition.X), math.floor(impactPosition.Z)
        
        -- Sofortiger Impact-Effekt
        floorAnimator:CreateWizardHeroEffect("fireballImpact", x, z)
        
        -- Spur vor dem Impact (woher der Ball kam)
        local path = {}
        local startPos = impactPosition - direction * 15
        
        for i = 0, 30 do
            local pos = startPos + direction * i * 0.5
            table.insert(path, pos)
        end
        
        floorAnimator:CreateFireTrail(path, 0.1)
    end,
    
    -- Eis-Explosion (für IceSpike) - WIZARD HERO STIL
    IceExplosion = function(floorAnimator, centerX, centerZ)
        -- Verwende das neue Wizard Hero Pattern
        floorAnimator:CreateWizardHeroEffect("iceSpikePattern", centerX, centerZ)
    end,
    
    -- Lightning Storm (für Lightning Spell) - WIZARD HERO STIL
    LightningStorm = function(floorAnimator, targetPositions)
        for _, pos in ipairs(targetPositions) do
            local x, z = math.floor(pos.X), math.floor(pos.Z)
            floorAnimator:CreateWizardHeroEffect("lightningStorm", x, z, {strikeCount = 3})
        end
    end,
    
    -- Defensive Magic Circle
    DefensiveCircle = function(floorAnimator, centerX, centerZ, radius)
        -- Äußerer Ring
        floorAnimator:CreateWaveEffect(centerX, centerZ, radius, 2, Color3.fromRGB(100, 255, 100))
        
        task.wait(0.5)
        
        -- Innere Spirale
        floorAnimator:CreateSpiral(centerX, centerZ, radius * 0.7, 3, 1, Color3.fromRGB(50, 255, 50))
        
        task.wait(1)
        
        -- Gegenläufige Spirale
        floorAnimator:CreateSpiral(centerX, centerZ, radius * 0.5, 2, -1, Color3.fromRGB(200, 255, 200))
    end,
    
    -- Meteor Impact (für große AOE Spells)
    MeteorImpact = function(floorAnimator, centerX, centerZ)
        -- Warnung vor Impact
        floorAnimator:CreateWaveEffect(centerX, centerZ, 15, 2, Color3.fromRGB(255, 200, 0))
        
        task.wait(2) -- Verzögerung für Warnung
        
        -- Hauptexplosion
        floorAnimator:CreateShockwave(centerX, centerZ, 20, 2, {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 100, 0),
            Color3.fromRGB(255, 200, 0)
        })
        
        -- Nachbeben-Wellen
        for i = 1, 3 do
            task.wait(0.8)
            floorAnimator:CreateWaveEffect(centerX, centerZ, 25 + i * 5, 1.5, Color3.fromRGB(139, 69, 19))
        end
    end,
    
    -- Heal Wave (für Heilzauber)
    HealWave = function(floorAnimator, centerX, centerZ)
        -- Sanfte Heilungs-Spirale
        floorAnimator:CreateSpiral(centerX, centerZ, 12, 3, 1, Color3.fromRGB(144, 238, 144))
        
        task.wait(0.5)
        
        -- Äußere Heilungs-Welle
        floorAnimator:CreateWaveEffect(centerX, centerZ, 18, 2, Color3.fromRGB(50, 205, 50))
    end,
    
    -- Teleport Effect
    TeleportEffect = function(floorAnimator, fromX, fromZ, toX, toZ)
        -- Ausgangs-Portal
        floorAnimator:CreateSpiral(fromX, fromZ, 8, 1.5, -1, Color3.fromRGB(138, 43, 226))
        
        -- Ziel-Portal (leicht verzögert)
        task.wait(0.3)
        floorAnimator:CreateSpiral(toX, toZ, 8, 1.5, 1, Color3.fromRGB(186, 85, 211))
        
        -- Verbindungslinie
        local path = {}
        local steps = math.floor(math.sqrt((toX - fromX)^2 + (toZ - fromZ)^2))
        
        for i = 0, steps do
            local t = i / steps
            local x = fromX + (toX - fromX) * t
            local z = fromZ + (toZ - fromZ) * t
            table.insert(path, Vector3.new(x, 0, z))
        end
        
        floorAnimator:CreateFireTrail(path, 0)
    end,
    
    -- NEUE WIZARD HERO PATTERNS
    
    -- Combo-Angriff Pattern
    ComboAttack = function(floorAnimator, positions, spellTypes)
        for i, pos in ipairs(positions) do
            local x, z = math.floor(pos.X), math.floor(pos.Z)
            local spellType = spellTypes[i] or "fireballImpact"
            
            floorAnimator:CreateWizardHeroEffect(spellType, x, z)
            task.wait(0.3) -- Zeitlicher Abstand zwischen Combos
        end
    end,
    
    -- Boss-Kampf Muster
    BossDefeatPattern = function(floorAnimator, centerX, centerZ)
        -- Große Explosion
        floorAnimator:CreateShockwave(centerX, centerZ, 25, 3, {
            Color3.fromRGB(255, 215, 0), -- Gold
            Color3.fromRGB(255, 255, 0), -- Gelb
            Color3.fromRGB(255, 165, 0)  -- Orange
        })
        
        task.wait(1)
        
        -- Heilungs-Wellen für alle Spieler
        for i = 1, 5 do
            floorAnimator:CreateWizardHeroEffect("healingCircle", centerX, centerZ)
            task.wait(0.5)
        end
    end,
    
    -- Wellen-Angriff (wie bei größeren Gegnern)
    WaveAttack = function(floorAnimator, startX, startZ, endX, endZ, waveCount)
        waveCount = waveCount or 3
        
        for wave = 1, waveCount do
            local progress = wave / waveCount
            local currentX = startX + (endX - startX) * progress
            local currentZ = startZ + (endZ - startZ) * progress
            
            floorAnimator:CreateShockwave(currentX, currentZ, 8, 1, {
                Color3.fromRGB(138, 43, 226),
                Color3.fromRGB(75, 0, 130)
            })
            
            task.wait(0.4)
        end
    end
}

-- PERFORMANCE PATTERNS - Optimiert für große Schlachten
PatternLibrary.PerformancePatterns = {
    
    -- LOD (Level of Detail) Explosion
    LODExplosion = function(floorAnimator, centerX, centerZ, playerDistance)
        local detail = 1
        if playerDistance > 50 then detail = 0.5 end
        if playerDistance > 100 then detail = 0.25 end
        
        local radius = 15 * detail
        local duration = 2 / detail
        
        floorAnimator:CreateShockwave(centerX, centerZ, radius, duration, {
            Color3.fromRGB(255, 100, 0)
        })
    end,
    
    -- Batched Area Effect (für viele kleine Effekte)
    BatchedAreaEffect = function(floorAnimator, positions, color, batchSize)
        batchSize = batchSize or 10
        
        for i = 1, #positions, batchSize do
            for j = i, math.min(i + batchSize - 1, #positions) do
                local pos = positions[j]
                local x, z = math.floor(pos.X), math.floor(pos.Z)
                floorAnimator:QueueUpdate(x, z, color, 0.3, nil, 0.5, true, 1)
            end
            task.wait() -- Frame break nach jedem Batch
        end
    end,
    
    -- Simplified Trail (für schnelle Projektile)
    SimplifiedTrail = function(floorAnimator, startPos, endPos, color)
        local distance = (endPos - startPos).Magnitude
        local steps = math.max(5, math.floor(distance / 4)) -- Weniger Steps für Performance
        
        local path = {}
        for i = 0, steps do
            local t = i / steps
            local pos = startPos:lerp(endPos, t)
            table.insert(path, pos)
        end
        
        floorAnimator:CreateFireTrail(path, 0)
    end
}

-- UTILITY FUNCTIONS
PatternLibrary.Utils = {
    
    -- Berechne optimale Batch-Größe basierend auf FPS
    CalculateOptimalBatchSize = function(currentFPS)
        if currentFPS > 55 then return 75 end
        if currentFPS > 45 then return 50 end
        if currentFPS > 30 then return 35 end
        return 20 -- Minimum für playability
    end,
    
    -- Überprüfe ob Position im sichtbaren Bereich ist
    IsPositionVisible = function(x, z, playerPosition, maxDistance)
        maxDistance = maxDistance or 100
        local distance = math.sqrt((x - playerPosition.X)^2 + (z - playerPosition.Z)^2)
        return distance <= maxDistance
    end,
    
    -- Erstelle Path zwischen zwei Punkten mit Hindernissen
    CreatePathWithObstacles = function(startPos, endPos, obstacles)
        local path = {}
        local steps = math.floor((endPos - startPos).Magnitude)
        
        for i = 0, steps do
            local t = i / steps
            local pos = startPos:lerp(endPos, t)
            
            -- Einfache Hindernis-Vermeidung
            local hasObstacle = false
            for _, obstacle in ipairs(obstacles) do
                if (pos - obstacle).Magnitude < 5 then
                    hasObstacle = true
                    break
                end
            end
            
            if not hasObstacle then
                table.insert(path, pos)
            end
        end
        
        return path
    end
}

return PatternLibrary
