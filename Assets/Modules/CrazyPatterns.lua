local CrazyPatterns = {}

-- VERRÜCKTE NEUE MUSTER FÜR DEIN 48x48 FLOOR SYSTEM! 🎨

CrazyPatterns.WildPatterns = {
    
    -- 🌈 REGENBOGEN-SPIRAL MIT PULSIERENDEN FARBEN
    RainbowSpiral = function(floorAnimator, centerX, centerZ, intensity)
        intensity = intensity or 1
        local colors = {
            Color3.fromRGB(255, 0, 0),    -- Rot
            Color3.fromRGB(255, 127, 0),  -- Orange
            Color3.fromRGB(255, 255, 0),  -- Gelb
            Color3.fromRGB(0, 255, 0),    -- Grün
            Color3.fromRGB(0, 0, 255),    -- Blau
            Color3.fromRGB(75, 0, 130),   -- Indigo
            Color3.fromRGB(148, 0, 211)   -- Violett
        }
        
        local maxRadius = 20 * intensity
        local angle = 0
        local radius = 0
        local colorIndex = 1
        
        while radius <= maxRadius do
            local x = math.floor(centerX + math.cos(angle) * radius)
            local z = math.floor(centerZ + math.sin(angle) * radius)
            
            if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                -- Pulsierender Effekt mit verschiedenen Verzögerungen
                local delay = radius * 0.05
                local duration = 0.8 + math.sin(angle) * 0.3
                
                task.spawn(function()
                    task.wait(delay)
                    floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.2, nil, duration, true, 2)
                end)
            end
            
            angle = angle + 0.3
            radius = radius + 0.15
            colorIndex = (colorIndex % #colors) + 1
        end
    end,
    
    -- ⚡ ELEKTRISCHER KÄFIG MIT FUNKEN
    ElectricCage = function(floorAnimator, centerX, centerZ, size)
        size = size or 12
        local lightningColor = Color3.fromRGB(255, 255, 100)
        local sparkColor = Color3.fromRGB(200, 200, 255)
        
        -- Käfig-Wände erstellen
        for side = 1, 4 do
            local positions = {}
            
            if side == 1 or side == 3 then -- Horizontale Linien
                local z = (side == 1) and (centerZ - size/2) or (centerZ + size/2)
                for x = centerX - size/2, centerX + size/2 do
                    table.insert(positions, Vector3.new(x, 0, z))
                end
            else -- Vertikale Linien
                local x = (side == 2) and (centerX - size/2) or (centerX + size/2)
                for z = centerZ - size/2, centerZ + size/2 do
                    table.insert(positions, Vector3.new(x, 0, z))
                end
            end
            
            -- Linie animieren mit Verzögerung
            task.spawn(function()
                task.wait(side * 0.2)
                for i, pos in ipairs(positions) do
                    task.wait(0.05)
                    floorAnimator:QueueUpdate(pos.X, pos.Z, lightningColor, 0.1, nil, 0.3, false)
                    
                    -- Zufällige Funken
                    if math.random() < 0.3 then
                        local sparkX = pos.X + math.random(-2, 2)
                        local sparkZ = pos.Z + math.random(-2, 2)
                        task.wait(0.1)
                        floorAnimator:QueueUpdate(sparkX, sparkZ, sparkColor, 0.4, nil, 0.2, true, 0.5)
                    end
                end
            end)
        end
        
        -- Zentrale Energie-Kugel
        task.wait(1)
        floorAnimator:CreateShockwave(centerX, centerZ, 4, 2, {lightningColor, sparkColor})
    end,
    
    -- 🔥❄️ FEUER-EIS WIRBEL (Gegensätze!)
    FireIceVortex = function(floorAnimator, centerX, centerZ)
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
        
        -- Zwei gegenläufige Spiralen
        for direction = -1, 1, 2 do
            local colors = (direction == 1) and fireColors or iceColors
            
            task.spawn(function()
                local angle = 0
                local radius = 0
                local maxRadius = 18
                
                while radius <= maxRadius do
                    local x = math.floor(centerX + math.cos(angle * direction) * radius)
                    local z = math.floor(centerZ + math.sin(angle * direction) * radius)
                    
                    if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                        local colorIndex = math.floor((radius / maxRadius) * #colors) + 1
                        colorIndex = math.min(colorIndex, #colors)
                        
                        local intensity = 1 - (radius / maxRadius)
                        floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.3 * intensity, nil, 0.4, true, 1.5)
                        
                        -- Dampf-Effekt wo Feuer und Eis sich treffen
                        if math.random() < 0.2 then
                            task.wait(0.2)
                            floorAnimator:QueueUpdate(x, z, Color3.fromRGB(220, 220, 220), 0.5, nil, 0.3, true, 0.8)
                        end
                    end
                    
                    angle = angle + 0.4
                    radius = radius + 0.2
                    task.wait(0.02)
                end
            end)
        end
    end,
    
    -- 🌊 TSUNAMI WELLE (über das ganze Feld!)
    TsunamiWave = function(floorAnimator, direction)
        direction = direction or Vector3.new(1, 0, 0) -- Standard: Links nach Rechts
        
        local waveColors = {
            Color3.fromRGB(0, 100, 200),   -- Dunkles Blau
            Color3.fromRGB(0, 150, 255),   -- Mittel Blau
            Color3.fromRGB(100, 200, 255), -- Hell Blau
            Color3.fromRGB(200, 240, 255)  -- Schaum
        }
        
        local startX, startZ = 1, 1
        local endX, endZ = 48, 48
        
        -- Bestimme Start- und Endpunkt basierend auf Richtung
        if direction.X > 0 then startX, endX = 1, 48
        elseif direction.X < 0 then startX, endX = 48, 1 end
        
        if direction.Z > 0 then startZ, endZ = 1, 48
        elseif direction.Z < 0 then startZ, endZ = 48, 1 end
        
        -- Welle animieren
        local steps = 60 -- Anzahl der Wellen-Frames
        for step = 1, steps do
            local progress = step / steps
            
            task.spawn(function()
                for x = 1, 48 do
                    for z = 1, 48 do
                        -- Berechne Wellen-Position
                        local wavePos = progress * 48
                        local distanceFromWave = math.abs((x * direction.X + z * direction.Z) - wavePos)
                        
                        if distanceFromWave < 4 then
                            local waveHeight = math.sin((distanceFromWave / 4) * math.pi)
                            local colorIndex = math.floor(waveHeight * #waveColors) + 1
                            colorIndex = math.max(1, math.min(colorIndex, #waveColors))
                            
                            local transparency = 0.2 + (1 - waveHeight) * 0.6
                            floorAnimator:QueueUpdate(x, z, waveColors[colorIndex], transparency, nil, 0.2)
                        end
                    end
                end
            end)
            
            task.wait(0.05)
        end
    end,
    
    -- 🌸 KIRSCHBLÜTEN STURM
    CherryBlossomStorm = function(floorAnimator, centerX, centerZ, intensity)
        intensity = intensity or 1
        local blossomColors = {
            Color3.fromRGB(255, 182, 193), -- Hell Rosa
            Color3.fromRGB(255, 105, 180), -- Pink
            Color3.fromRGB(255, 20, 147),  -- Deep Pink
            Color3.fromRGB(255, 255, 255)  -- Weiß
        }
        
        local petalCount = math.floor(200 * intensity)
        
        for i = 1, petalCount do
            task.spawn(function()
                -- Zufällige Startposition um das Zentrum
                local angle = math.random() * math.pi * 2
                local distance = math.random(0, 15)
                local startX = centerX + math.cos(angle) * distance
                local startZ = centerZ + math.sin(angle) * distance
                
                -- Blütenblatt "fällt" spiral-förmig
                local spiral = 0
                local fallSpeed = math.random(20, 40)
                
                for fall = 1, fallSpeed do
                    spiral = spiral + 0.3
                    local currentX = math.floor(startX + math.cos(spiral) * 2)
                    local currentZ = math.floor(startZ + math.sin(spiral) * 2 + fall * 0.2)
                    
                    if currentX >= 1 and currentX <= 48 and currentZ >= 1 and currentZ <= 48 then
                        local colorIndex = math.random(1, #blossomColors)
                        local transparency = 0.4 + math.random() * 0.4
                        
                        floorAnimator:QueueUpdate(currentX, currentZ, blossomColors[colorIndex], transparency, nil, 0.3, true, 0.8)
                    end
                    
                    task.wait(0.05)
                end
            end)
            
            task.wait(0.02) -- Versetzte Starts für natürlichen Effekt
        end
    end,
    
    -- 🎆 FEUERWERK EXPLOSION
    FireworksExplosion = function(floorAnimator, centerX, centerZ, fireworkCount)
        fireworkCount = fireworkCount or 5
        
        local fireworkColors = {
            {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)},     -- Rot
            {Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100)},     -- Grün
            {Color3.fromRGB(0, 0, 255), Color3.fromRGB(100, 100, 255)},     -- Blau
            {Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 150)},   -- Gelb
            {Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 150, 255)},   -- Magenta
            {Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 200, 100)}    -- Orange
        }
        
        for firework = 1, fireworkCount do
            task.spawn(function()
                local fireworkX = centerX + math.random(-8, 8)
                local fireworkZ = centerZ + math.random(-8, 8)
                local colorSet = fireworkColors[math.random(1, #fireworkColors)]
                
                task.wait(firework * 0.3) -- Zeitversetzte Explosionen
                
                -- Zentrale Explosion
                floorAnimator:QueueUpdate(fireworkX, fireworkZ, colorSet[1], 0.1, nil, 0.2)
                
                task.wait(0.1)
                
                -- Funken in alle Richtungen
                local sparkCount = math.random(12, 20)
                for spark = 1, sparkCount do
                    local angle = (spark / sparkCount) * math.pi * 2
                    local length = math.random(3, 8)
                    
                    for distance = 1, length do
                        local sparkX = math.floor(fireworkX + math.cos(angle) * distance)
                        local sparkZ = math.floor(fireworkZ + math.sin(angle) * distance)
                        
                        if sparkX >= 1 and sparkX <= 48 and sparkZ >= 1 and sparkZ <= 48 then
                            local colorIndex = (distance > length/2) and 2 or 1
                            local fadeIntensity = 1 - (distance / length)
                            
                            task.wait(distance * 0.02)
                            floorAnimator:QueueUpdate(sparkX, sparkZ, colorSet[colorIndex], 
                                0.3 * fadeIntensity, nil, 0.4, true, 1)
                        end
                    end
                end
            end)
        end
    end,
    
    -- 🌌 GALAXY SPIRAL (Sterne und Nebel)
    GalaxySpiral = function(floorAnimator, centerX, centerZ)
        local starColor = Color3.fromRGB(255, 255, 255)
        local nebulaColors = {
            Color3.fromRGB(128, 0, 128),   -- Lila
            Color3.fromRGB(75, 0, 130),    -- Indigo  
            Color3.fromRGB(138, 43, 226),  -- Violett
            Color3.fromRGB(72, 61, 139)    -- Dunkel Slate Blau
        }
        
        -- Haupt-Galaxie Spiral
        for arm = 1, 3 do -- 3 Spiral-Arme
            task.spawn(function()
                local startAngle = (arm - 1) * (math.pi * 2 / 3)
                local angle = startAngle
                local radius = 0
                local maxRadius = 20
                
                while radius <= maxRadius do
                    local x = math.floor(centerX + math.cos(angle) * radius)
                    local z = math.floor(centerZ + math.sin(angle) * radius)
                    
                    if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                        -- Sterne (helle Punkte)
                        if math.random() < 0.3 then
                            floorAnimator:QueueUpdate(x, z, starColor, 0.1, nil, 0.2, false)
                        end
                        
                        -- Nebel (farbige Bereiche)
                        if math.random() < 0.6 then
                            local nebulaColor = nebulaColors[math.random(1, #nebulaColors)]
                            local intensity = 1 - (radius / maxRadius)
                            
                            task.wait(0.03)
                            floorAnimator:QueueUpdate(x, z, nebulaColor, 0.7 * intensity, nil, 0.8, true, 2)
                        end
                    end
                    
                    angle = angle + 0.15
                    radius = radius + 0.12
                    task.wait(0.01)
                end
            end)
        end
        
        -- Zentrale "Schwarzes Loch" Effect
        task.wait(1)
        for radius = 1, 4 do
            for angle = 0, math.pi * 2, 0.5 do
                local x = math.floor(centerX + math.cos(angle) * radius)
                local z = math.floor(centerZ + math.sin(angle) * radius)
                
                if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                    floorAnimator:QueueUpdate(x, z, Color3.fromRGB(20, 20, 20), 0.8, nil, 3, false)
                end
            end
            task.wait(0.2)
        end
    end,
    
    -- 🎵 MUSIK-VISUALIZER (Beats und Rhythmus)
    MusicVisualizer = function(floorAnimator, centerX, centerZ, bpm)
        bpm = bpm or 120 -- Beats per minute
        local beatInterval = 60 / bpm
        
        local bassColors = {
            Color3.fromRGB(255, 0, 100),   -- Bass (Pink)
            Color3.fromRGB(200, 0, 150),   -- Sub-Bass
        }
        local midColors = {
            Color3.fromRGB(0, 255, 200),   -- Mid (Cyan)
            Color3.fromRGB(100, 255, 150), -- Mid-High
        }
        local trebleColors = {
            Color3.fromRGB(255, 255, 0),   -- Treble (Gelb)
            Color3.fromRGB(255, 200, 100), -- High Treble
        }
        
        -- Musik spielt für 32 Beats
        for beat = 1, 32 do
            task.spawn(function()
                task.wait((beat - 1) * beatInterval)
                
                -- Bass-Frequenzen (Zentrum)
                if beat % 4 == 1 then
                    for radius = 1, 6 do
                        for angle = 0, math.pi * 2, 0.4 do
                            local x = math.floor(centerX + math.cos(angle) * radius)
                            local z = math.floor(centerZ + math.sin(angle) * radius)
                            
                            if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                                local intensity = 1 - (radius / 6)
                                floorAnimator:QueueUpdate(x, z, bassColors[1], 0.2 * intensity, nil, beatInterval * 0.8, true, beatInterval * 0.2)
                            end
                        end
                    end
                end
                
                -- Mid-Frequenzen
                if beat % 2 == 0 then
                    for radius = 7, 14 do
                        for angle = 0, math.pi * 2, 0.6 do
                            local x = math.floor(centerX + math.cos(angle + beat * 0.3) * radius)
                            local z = math.floor(centerZ + math.sin(angle + beat * 0.3) * radius)
                            
                            if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                                local intensity = 1 - ((radius - 7) / 7)
                                floorAnimator:QueueUpdate(x, z, midColors[1], 0.3 * intensity, nil, beatInterval * 0.6, true, beatInterval * 0.4)
                            end
                        end
                    end
                end
            end)
        end
    end,
    
    -- 🖼️ PIXEL ART ZEICHNER
    PixelArtDrawer = function(floorAnimator, artType)
        artType = artType or "heart"
        
        local artPatterns = {
            heart = {
                "  ████    ████  ",
                "██████  ██████",
                "████████████████",
                "██████████████",
                "  ████████████  ",
                "    ████████    ",
                "      ████      ",
                "        ██        "
            },
            star = {
                "        ██        ",
                "      ██████      ",
                "        ██        ",
                "██              ██",
                "  ████████████  ",
                "    ██████████    ",
                "  ████████████  ",
                "██              ██"
            },
            smiley = {
                "    ████████    ",
                "  ██        ██  ",
                "██  ████  ████  ██",
                "██  ████  ████  ██",
                "██              ██",
                "██  ██      ██  ██",
                "██    ████████    ██",
                "  ██        ██  ",
                "    ████████    "
            }
        }
        
        local pattern = artPatterns[artType]
        if not pattern then return end
        
        local startX = 24 - math.floor(#pattern[1] / 2)
        local startZ = 24 - math.floor(#pattern / 2)
        
        local colors = {
            Color3.fromRGB(255, 100, 150),
            Color3.fromRGB(100, 255, 150),
            Color3.fromRGB(150, 100, 255),
            Color3.fromRGB(255, 255, 100),
            Color3.fromRGB(100, 200, 255)
        }
        
        for row = 1, #pattern do
            task.spawn(function()
                task.wait(row * 0.2)
                
                local line = pattern[row]
                for col = 1, #line do
                    if line:sub(col, col) == "█" then
                        local x = startX + col - 1
                        local z = startZ + row - 1
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            local color = colors[math.random(1, #colors)]
                            task.wait(0.05)
                            floorAnimator:QueueUpdate(x, z, color, 0.1, nil, 0.8, false)
                        end
                    end
                end
            end)
        end
    end,
    
    -- 🌪️ WIRBELNDE FARBPALETTE
    ColorPaletteSwirl = function(floorAnimator, centerX, centerZ, paletteType)
        paletteType = paletteType or "sunset"
        
        local palettes = {
            sunset = {
                Color3.fromRGB(255, 94, 77),
                Color3.fromRGB(255, 154, 0),
                Color3.fromRGB(255, 206, 84),
                Color3.fromRGB(255, 138, 101),
                Color3.fromRGB(240, 98, 146)
            },
            ocean = {
                Color3.fromRGB(0, 119, 190),
                Color3.fromRGB(0, 180, 216),
                Color3.fromRGB(144, 224, 239),
                Color3.fromRGB(202, 240, 248),
                Color3.fromRGB(255, 255, 255)
            },
            neon = {
                Color3.fromRGB(255, 0, 255),
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(0, 255, 0)
            }
        }
        
        local colors = palettes[paletteType]
        if not colors then return end
        
        for ring = 1, 5 do
            task.spawn(function()
                local radius = ring * 4
                local colorIndex = ring
                
                for rotation = 1, 20 do
                    local angleOffset = rotation * 0.3
                    
                    for angle = 0, math.pi * 2, 0.2 do
                        local x = math.floor(centerX + math.cos(angle + angleOffset) * radius)
                        local z = math.floor(centerZ + math.sin(angle + angleOffset) * radius)
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            local currentColor = colors[((colorIndex - 1 + rotation) % #colors) + 1]
                            floorAnimator:QueueUpdate(x, z, currentColor, 0.3, nil, 0.2)
                        end
                    end
                    
                    task.wait(0.1)
                end
            end)
            
            task.wait(0.2)
        end
    end
}

return CrazyPatterns