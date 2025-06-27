-- EXPERIMENTELLE PATTERNS - Die verrücktesten Ideen! 🚀🎨
-- Diese Patterns pushen das 48x48 System an seine Grenzen!

local ExperimentalPatterns = {}

ExperimentalPatterns.ExtremePatterns = {
    
    -- 🌪️ TORNADO mit Debris und Partikeln
    Tornado = function(floorAnimator, centerX, centerZ, intensity)
        intensity = intensity or 1
        local tornadoColors = {
            Color3.fromRGB(169, 169, 169), -- Grau
            Color3.fromRGB(105, 105, 105), -- Dunkelgrau
            Color3.fromRGB(70, 70, 70),    -- Sehr dunkelgrau
            Color3.fromRGB(139, 69, 19)    -- Braun (Debris)
        }
        
        -- Tornado-Zentrum (Auge)
        for radius = 1, 3 do
            for angle = 0, math.pi * 2, 0.5 do
                local x = math.floor(centerX + math.cos(angle) * radius)
                local z = math.floor(centerZ + math.sin(angle) * radius)
                
                if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                    floorAnimator:QueueUpdate(x, z, Color3.fromRGB(50, 50, 50), 0.8, nil, 5)
                end
            end
        end
        
        -- Spiral-Winde
        task.spawn(function()
            for revolution = 1, 20 do
                local maxRadius = 15 * intensity
                local angle = 0
                local radius = 3
                
                while radius <= maxRadius do
                    local x = math.floor(centerX + math.cos(angle) * radius)
                    local z = math.floor(centerZ + math.sin(angle) * radius)
                    
                    if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                        local colorIndex = math.floor((radius / maxRadius) * #tornadoColors) + 1
                        colorIndex = math.min(colorIndex, #tornadoColors)
                        
                        local windIntensity = 1 - (radius / maxRadius)
                        floorAnimator:QueueUpdate(x, z, tornadoColors[colorIndex], 
                            0.3 + windIntensity * 0.4, nil, 0.2)
                        
                        -- Zufällige "Debris" 
                        if math.random() < 0.3 then
                            local debrisX = x + math.random(-2, 2)
                            local debrisZ = z + math.random(-2, 2)
                            if debrisX >= 1 and debrisX <= 48 and debrisZ >= 1 and debrisZ <= 48 then
                                task.wait(0.1)
                                floorAnimator:QueueUpdate(debrisX, debrisZ, 
                                    Color3.fromRGB(139, 69, 19), 0.5, nil, 0.3, true, 0.8)
                            end
                        end
                    end
                    
                    angle = angle + 0.2
                    radius = radius + 0.1
                end
                
                task.wait(0.1)
            end
        end)
    end,
    
    -- 🌋 VULKAN ERUPTION mit Lava und Asche
    VolcanoEruption = function(floorAnimator, centerX, centerZ)
        local lavaColors = {
            Color3.fromRGB(255, 0, 0),    -- Hellrot
            Color3.fromRGB(255, 69, 0),   -- Rot-Orange
            Color3.fromRGB(255, 140, 0),  -- Dunkelorange
            Color3.fromRGB(220, 20, 60)   -- Crimson
        }
        local ashColor = Color3.fromRGB(105, 105, 105)
        
        -- Vulkan-Krater
        for radius = 1, 4 do
            for angle = 0, math.pi * 2, 0.3 do
                local x = math.floor(centerX + math.cos(angle) * radius)
                local z = math.floor(centerZ + math.sin(angle) * radius)
                
                if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                    floorAnimator:QueueUpdate(x, z, Color3.fromRGB(50, 25, 25), 0.2, nil, 1)
                end
            end
        end
        
        task.wait(0.5)
        
        -- Lava-Explosionen
        for explosion = 1, 8 do
            task.spawn(function()
                local angle = (explosion - 1) * (math.pi * 2 / 8)
                local startRadius = 4
                local maxRadius = 15
                
                -- Lava-Strom
                for radius = startRadius, maxRadius do
                    local x = math.floor(centerX + math.cos(angle) * radius)
                    local z = math.floor(centerZ + math.sin(angle) * radius)
                    
                    if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                        local colorIndex = math.random(1, #lavaColors)
                        local heat = 1 - ((radius - startRadius) / (maxRadius - startRadius))
                        
                        floorAnimator:QueueUpdate(x, z, lavaColors[colorIndex], 
                            0.1 + heat * 0.2, nil, 0.3, true, 3)
                        
                        -- Lava "spritzt" zu den Seiten
                        for side = -1, 1, 2 do
                            local sideX = x + math.floor(math.sin(angle) * side * 2)
                            local sideZ = z + math.floor(-math.cos(angle) * side * 2)
                            
                            if sideX >= 1 and sideX <= 48 and sideZ >= 1 and sideZ <= 48 then
                                if math.random() < 0.4 then
                                    task.wait(0.05)
                                    floorAnimator:QueueUpdate(sideX, sideZ, lavaColors[colorIndex], 
                                        0.3, nil, 0.2, true, 2)
                                end
                            end
                        end
                    end
                    
                    task.wait(0.05)
                end
            end)
            
            task.wait(0.2)
        end
        
        -- Asche-Regen
        task.wait(1)
        task.spawn(function()
            for ashRound = 1, 30 do
                for i = 1, 10 do
                    local ashX = centerX + math.random(-20, 20)
                    local ashZ = centerZ + math.random(-20, 20)
                    
                    if ashX >= 1 and ashX <= 48 and ashZ >= 1 and ashZ <= 48 then
                        floorAnimator:QueueUpdate(ashX, ashZ, ashColor, 0.6, nil, 0.4, true, 2)
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
    
    -- ❄️🔥 FEUER-EIS KRIEG (Zwei kämpfende Elemente)
    ElementalWar = function(floorAnimator, centerX, centerZ)
        local fireColors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 100, 0),
            Color3.fromRGB(255, 200, 0)
        }
        local iceColors = {
            Color3.fromRGB(173, 216, 230),
            Color3.fromRGB(135, 206, 250),
            Color3.fromRGB(100, 149, 237)
        }
        local steamColor = Color3.fromRGB(245, 245, 245)
        
        -- Startpositionen
        local fireBase = {x = centerX - 15, z = centerZ}
        local iceBase = {x = centerX + 15, z = centerZ}
        
        -- Basen erstellen
        for _, base in ipairs({fireBase, iceBase}) do
            local colors = (base == fireBase) and fireColors or iceColors
            
            for radius = 1, 5 do
                for angle = 0, math.pi * 2, 0.4 do
                    local x = math.floor(base.x + math.cos(angle) * radius)
                    local z = math.floor(base.z + math.sin(angle) * radius)
                    
                    if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                        local colorIndex = math.random(1, #colors)
                        floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.2, nil, 2)
                    end
                end
            end
        end
        
        task.wait(1)
        
        -- Kämpfende Fronten
        task.spawn(function()
            for battle = 1, 30 do
                -- Feuer-Angriff
                local fireAttackX = fireBase.x + battle * 0.8
                local fireAttackZ = fireBase.z + math.sin(battle * 0.3) * 3
                
                if fireAttackX >= 1 and fireAttackX <= 48 and fireAttackZ >= 1 and fireAttackZ <= 48 then
                    for i = 1, 3 do
                        local x = math.floor(fireAttackX + math.random(-1, 1))
                        local z = math.floor(fireAttackZ + math.random(-1, 1))
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            floorAnimator:QueueUpdate(x, z, fireColors[math.random(1, #fireColors)], 
                                0.2, nil, 0.4, true, 1)
                        end
                    end
                end
                
                -- Eis-Gegenangriff
                local iceAttackX = iceBase.x - battle * 0.8
                local iceAttackZ = iceBase.z + math.sin(battle * 0.3 + math.pi) * 3
                
                if iceAttackX >= 1 and iceAttackX <= 48 and iceAttackZ >= 1 and iceAttackZ <= 48 then
                    for i = 1, 3 do
                        local x = math.floor(iceAttackX + math.random(-1, 1))
                        local z = math.floor(iceAttackZ + math.random(-1, 1))
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            floorAnimator:QueueUpdate(x, z, iceColors[math.random(1, #iceColors)], 
                                0.2, nil, 0.4, true, 1)
                        end
                    end
                end
                
                -- Dampf-Effekt in der Mitte
                if math.random() < 0.7 then
                    local steamX = math.floor(centerX + math.random(-5, 5))
                    local steamZ = math.floor(centerZ + math.random(-3, 3))
                    
                    if steamX >= 1 and steamX <= 48 and steamZ >= 1 and steamZ <= 48 then
                        floorAnimator:QueueUpdate(steamX, steamZ, steamColor, 0.7, nil, 0.3, true, 0.5)
                    end
                end
                
                task.wait(0.15)
            end
        end)
    end,
    
    -- 🌈⚡ REGENBOGEN-BLITZ (Alle Farben gleichzeitig)
    RainbowLightning = function(floorAnimator, startX, startZ, endX, endZ)
        local rainbowColors = {
            Color3.fromRGB(255, 0, 0),    -- Rot
            Color3.fromRGB(255, 127, 0),  -- Orange  
            Color3.fromRGB(255, 255, 0),  -- Gelb
            Color3.fromRGB(0, 255, 0),    -- Grün
            Color3.fromRGB(0, 0, 255),    -- Blau
            Color3.fromRGB(75, 0, 130),   -- Indigo
            Color3.fromRGB(148, 0, 211)   -- Violett
        }
        
        -- Haupt-Blitz-Linie
        local distance = math.sqrt((endX - startX)^2 + (endZ - startZ)^2)
        local steps = math.floor(distance)
        
        for step = 0, steps do
            local t = step / steps
            local x = math.floor(startX + (endX - startX) * t)
            local z = math.floor(startZ + (endZ - startZ) * t)
            
            -- Jittery Lightning effect
            x = x + math.random(-1, 1)
            z = z + math.random(-1, 1)
            
            if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                -- Alle Regenbogen-Farben gleichzeitig
                for i, color in ipairs(rainbowColors) do
                    local offsetX = x + math.random(-2, 2)
                    local offsetZ = z + math.random(-2, 2)
                    
                    if offsetX >= 1 and offsetX <= 48 and offsetZ >= 1 and offsetZ <= 48 then
                        task.spawn(function()
                            task.wait(i * 0.02) -- Leicht versetzt für Regenbogen-Effekt
                            floorAnimator:QueueUpdate(offsetX, offsetZ, color, 0.1, nil, 0.3, true, 0.8)
                        end)
                    end
                end
            end
            
            task.wait(0.02)
        end
        
        -- Regenbogen-Schockwelle am Ende
        task.wait(0.5)
        for i, color in ipairs(rainbowColors) do
            task.spawn(function()
                task.wait(i * 0.1)
                floorAnimator:CreateWaveEffect(endX, endZ, 8, 1, color)
            end)
        end
    end,
    
    -- 🎭 ILLUSIONS-MUSTER (Optische Täuschungen)
    OpticalIllusion = function(floorAnimator, centerX, centerZ, illusionType)
        illusionType = illusionType or "spiral"
        
        if illusionType == "spiral" then
            -- Spirale die sich zu bewegen scheint
            local blackColor = Color3.fromRGB(0, 0, 0)
            local whiteColor = Color3.fromRGB(255, 255, 255)
            
            for phase = 1, 20 do
                task.spawn(function()
                    task.wait(phase * 0.1)
                    
                    local angle = 0
                    local radius = 0
                    local maxRadius = 18
                    
                    while radius <= maxRadius do
                        local x = math.floor(centerX + math.cos(angle + phase * 0.2) * radius)
                        local z = math.floor(centerZ + math.sin(angle + phase * 0.2) * radius)
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            local color = ((math.floor(angle * 2) + math.floor(radius)) % 2 == 0) and blackColor or whiteColor
                            floorAnimator:QueueUpdate(x, z, color, 0.1, nil, 0.2)
                        end
                        
                        angle = angle + 0.15
                        radius = radius + 0.1
                    end
                end)
            end
            
        elseif illusionType == "waves" then
            -- Interferenz-Muster
            for frame = 1, 60 do
                task.spawn(function()
                    task.wait(frame * 0.05)
                    
                    for x = 1, 48 do
                        for z = 1, 48 do
                            local wave1 = math.sin((x + frame * 0.5) * 0.3) * math.sin((z + frame * 0.5) * 0.3)
                            local wave2 = math.sin((x - frame * 0.3) * 0.2) * math.sin((z - frame * 0.3) * 0.2)
                            local combined = (wave1 + wave2) * 0.5
                            
                            local intensity = (combined + 1) * 0.5 -- Normalisieren zu 0-1
                            local color = Color3.new(intensity, intensity * 0.5, 1 - intensity)
                            
                            if math.random() < 0.1 then -- Nur 10% der Tiles pro Frame updaten
                                floorAnimator:QueueUpdate(x, z, color, 0.3, nil, 0.1)
                            end
                        end
                    end
                end)
            end
        end
    end,
    
    -- 🌊🌀 WIRBELNDE GALAXIE (Massiver Effekt)
    SwirlingGalaxy = function(floorAnimator, centerX, centerZ)
        local galaxyColors = {
            Color3.fromRGB(25, 25, 112),   -- Midnight Blue
            Color3.fromRGB(72, 61, 139),   -- Dark Slate Blue
            Color3.fromRGB(123, 104, 238), -- Medium Slate Blue
            Color3.fromRGB(147, 112, 219), -- Medium Purple
            Color3.fromRGB(255, 255, 255)  -- Sterne
        }
        
        -- Mehrere Spiral-Arme gleichzeitig
        for arm = 1, 5 do
            task.spawn(function()
                local armOffset = (arm - 1) * (math.pi * 2 / 5)
                
                for revolution = 1, 15 do
                    local angle = armOffset
                    local radius = 0
                    local maxRadius = 22
                    
                    while radius <= maxRadius do
                        local x = math.floor(centerX + math.cos(angle + revolution * 0.1) * radius)
                        local z = math.floor(centerZ + math.sin(angle + revolution * 0.1) * radius)
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            local distance = math.sqrt((x - centerX)^2 + (z - centerZ)^2)
                            local colorIndex = math.floor((distance / maxRadius) * (#galaxyColors - 1)) + 1
                            colorIndex = math.min(colorIndex, #galaxyColors)
                            
                            -- Sterne-Effekt
                            if colorIndex == #galaxyColors and math.random() < 0.3 then
                                floorAnimator:QueueUpdate(x, z, galaxyColors[colorIndex], 0.05, nil, 0.1, false)
                            else
                                floorAnimator:QueueUpdate(x, z, galaxyColors[colorIndex], 0.4, nil, 0.3, true, 2)
                            end
                        end
                        
                        angle = angle + 0.08
                        radius = radius + 0.15
                    end
                    
                    task.wait(0.08)
                end
            end)
            
            task.wait(0.1)
        end
    end
}

-- UTILITY FUNCTIONS für experimentelle Patterns
ExperimentalPatterns.Utils = {
    
    -- Erstelle komplexe Farbverläufe
    CreateGradient = function(color1, color2, steps)
        local gradient = {}
        for i = 0, steps do
            local t = i / steps
            local r = color1.R + (color2.R - color1.R) * t
            local g = color1.G + (color2.G - color1.G) * t
            local b = color1.B + (color2.B - color1.B) * t
            table.insert(gradient, Color3.new(r, g, b))
        end
        return gradient
    end,
    
    -- Berechne Interferenz-Muster
    CalculateInterference = function(x, z, sources, time)
        local totalWave = 0
        for _, source in ipairs(sources) do
            local distance = math.sqrt((x - source.x)^2 + (z - source.z)^2)
            local wave = math.sin(distance * source.frequency + time * source.speed) * source.amplitude
            totalWave = totalWave + wave
        end
        return totalWave
    end,
    
    -- Performance Monitor für extreme Patterns
    MonitorPerformance = function(floorAnimator)
        local startTime = tick()
        return function()
            local elapsed = tick() - startTime
            local queueSize = #floorAnimator.updateQueue
            local activeEffects = #floorAnimator.activeEffects
            
            if queueSize > 500 then
                warn("High queue size: " .. queueSize .. " - Consider reducing pattern complexity")
            end
            
            if activeEffects > 20 then
                warn("Many active effects: " .. activeEffects .. " - Performance may be impacted")
            end
            
            return {
                elapsed = elapsed,
                queueSize = queueSize,
                activeEffects = activeEffects
            }
        end
    end
}

return ExperimentalPatterns
