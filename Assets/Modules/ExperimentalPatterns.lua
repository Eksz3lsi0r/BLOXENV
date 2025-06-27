local ExperimentalPatterns = {}

-- VERRÜCKTE FARBKOMBINATIONEN
ExperimentalPatterns.ColorPalettes = {
    
    -- Neon-Cyberpunk Theme
    Cyberpunk = {
        Color3.fromRGB(255, 0, 255),    -- Pink/Magenta
        Color3.fromRGB(0, 255, 255),    -- Cyan
        Color3.fromRGB(57, 255, 20),    -- Neon Grün
        Color3.fromRGB(255, 20, 147),   -- Deep Pink
        Color3.fromRGB(138, 43, 226)    -- Lila
    },
    
    -- Regenbogen-Explosion
    Rainbow = {
        Color3.fromRGB(255, 0, 0),      -- Rot
        Color3.fromRGB(255, 127, 0),    -- Orange
        Color3.fromRGB(255, 255, 0),    -- Gelb
        Color3.fromRGB(0, 255, 0),      -- Grün
        Color3.fromRGB(0, 0, 255),      -- Blau
        Color3.fromRGB(75, 0, 130),     -- Indigo
        Color3.fromRGB(148, 0, 211)     -- Violett
    },
    
    -- Feuer und Eis
    FireAndIce = {
        Color3.fromRGB(255, 69, 0),     -- Feuer Rot
        Color3.fromRGB(255, 140, 0),    -- Feuer Orange
        Color3.fromRGB(135, 206, 250),  -- Eis Blau
        Color3.fromRGB(173, 216, 230),  -- Hell Blau
        Color3.fromRGB(0, 191, 255)     -- Tiefes Cyan
    },
    
    -- Galaxy Theme
    Galaxy = {
        Color3.fromRGB(25, 25, 112),    -- Mitternachts Blau
        Color3.fromRGB(138, 43, 226),   -- Lila
        Color3.fromRGB(255, 20, 147),   -- Pink
        Color3.fromRGB(255, 215, 0),    -- Gold
        Color3.fromRGB(255, 255, 255)   -- Weiß (Sterne)
    },
    
    -- Toxic/Nuclear
    Toxic = {
        Color3.fromRGB(57, 255, 20),    -- Giftgrün
        Color3.fromRGB(255, 255, 0),    -- Gelb
        Color3.fromRGB(154, 205, 50),   -- Gelbgrün
        Color3.fromRGB(0, 100, 0),      -- Dunkelgrün
        Color3.fromRGB(255, 69, 0)      -- Warnung Rot
    }
}

-- VERRÜCKTE MUSTER-FUNKTIONEN
ExperimentalPatterns.CrazyPatterns = {
    
    -- DNA-Spirale (doppelte Helix)
    DNAHelix = function(floorAnimator, centerX, centerZ, height, duration)
        local colors = ExperimentalPatterns.ColorPalettes.Cyberpunk
        
        for t = 0, duration * 10 do
            local time = t / 10
            local progress = time / duration
            
            -- Erste Spirale
            local angle1 = progress * math.pi * 8
            local radius1 = 8 + math.sin(progress * math.pi * 4) * 3
            local x1 = centerX + math.cos(angle1) * radius1
            local z1 = centerZ + math.sin(angle1) * radius1
            
            -- Zweite Spirale (90° versetzt)
            local angle2 = angle1 + math.pi
            local radius2 = 8 + math.cos(progress * math.pi * 4) * 3
            local x2 = centerX + math.cos(angle2) * radius2
            local z2 = centerZ + math.sin(angle2) * radius2
            
            -- Verbindungslinien zwischen den Spiralen
            local steps = 8
            for i = 0, steps do
                local t_connect = i / steps
                local connectX = x1 + (x2 - x1) * t_connect
                local connectZ = z1 + (z2 - z1) * t_connect
                
                if connectX >= 1 and connectX <= 48 and connectZ >= 1 and connectZ <= 48 then
                    local colorIndex = (math.floor(time * 3) % #colors) + 1
                    floorAnimator:QueueUpdate(
                        math.floor(connectX), math.floor(connectZ),
                        colors[colorIndex], 0.3, nil, 0.2, true, 0.8
                    )
                end
            end
            
            task.wait(0.1)
        end
    end,
    
    -- Mandelbrot-Fraktal (vereinfacht)
    MandelbrotFractal = function(floorAnimator, centerX, centerZ, zoom, maxIterations)
        local colors = ExperimentalPatterns.ColorPalettes.Galaxy
        zoom = zoom or 0.1
        maxIterations = maxIterations or 20
        
        for x = 1, 48 do
            for z = 1, 48 do
                -- Konvertiere Grid-Koordinaten zu komplexen Zahlen
                local real = (x - centerX) * zoom
                local imag = (z - centerZ) * zoom
                
                -- Mandelbrot-Iteration
                local zReal, zImag = 0, 0
                local iterations = 0
                
                while iterations < maxIterations and (zReal^2 + zImag^2) < 4 do
                    local newReal = zReal^2 - zImag^2 + real
                    local newImag = 2 * zReal * zImag + imag
                    zReal, zImag = newReal, newImag
                    iterations = iterations + 1
                end
                
                -- Farbe basierend auf Iterations-Anzahl
                if iterations < maxIterations then
                    local colorIndex = (iterations % #colors) + 1
                    local alpha = iterations / maxIterations
                    floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.5 * alpha, nil, 0.3)
                end
            end
            
            task.wait() -- Frame break für Performance
        end
    end,
    
    -- Zellulärer Automat (Game of Life Style)
    CellularLife = function(floorAnimator, iterations, initialPattern)
        local colors = ExperimentalPatterns.ColorPalettes.Toxic
        local grid = {}
        
        -- Initialisiere Grid
        for x = 1, 48 do
            grid[x] = {}
            for z = 1, 48 do
                if initialPattern == "random" then
                    grid[x][z] = math.random() > 0.7
                elseif initialPattern == "center" then
                    local distance = math.sqrt((x - 24)^2 + (z - 24)^2)
                    grid[x][z] = distance < 10 and math.random() > 0.5
                else
                    grid[x][z] = false
                end
            end
        end
        
        -- Evolutionsschritte
        for iteration = 1, iterations do
            local newGrid = {}
            
            for x = 1, 48 do
                newGrid[x] = {}
                for z = 1, 48 do
                    local neighbors = 0
                    
                    -- Zähle lebende Nachbarn
                    for dx = -1, 1 do
                        for dz = -1, 1 do
                            if dx ~= 0 or dz ~= 0 then
                                local nx, nz = x + dx, z + dz
                                if nx >= 1 and nx <= 48 and nz >= 1 and nz <= 48 then
                                    if grid[nx][nz] then neighbors = neighbors + 1 end
                                end
                            end
                        end
                    end
                    
                    -- Game of Life Regeln
                    if grid[x][z] then
                        newGrid[x][z] = neighbors == 2 or neighbors == 3
                    else
                        newGrid[x][z] = neighbors == 3
                    end
                    
                    -- Visualisiere aktuellen Zustand
                    if newGrid[x][z] then
                        local colorIndex = (iteration % #colors) + 1
                        local alpha = 0.8
                        floorAnimator:QueueUpdate(x, z, colors[colorIndex], alpha, nil, 1.0)
                    else
                        floorAnimator:QueueUpdate(x, z, Color3.fromRGB(20, 20, 20), 0.9, nil, 1.0)
                    end
                end
            end
            
            grid = newGrid
            task.wait(0.5) -- Pause zwischen Generationen
        end
    end,
    
    -- Sinus-Wellen Interferenz
    SinusInterference = function(floorAnimator, duration, waveCount)
        local colors = ExperimentalPatterns.ColorPalettes.FireAndIce
        waveCount = waveCount or 4
        
        for t = 0, duration * 10 do
            local time = t / 10
            
            for x = 1, 48 do
                for z = 1, 48 do
                    local intensity = 0
                    
                    -- Mehrere Sinus-Wellen überlagern
                    for wave = 1, waveCount do
                        local frequency = wave * 0.2
                        local phase = wave * math.pi / 2
                        local amplitude = 1 / wave
                        
                        local distance = math.sqrt((x - 24)^2 + (z - 24)^2)
                        intensity = intensity + amplitude * math.sin(frequency * distance - time * 3 + phase)
                    end
                    
                    -- Normalisiere Intensität
                    intensity = (intensity + waveCount) / (2 * waveCount)
                    
                    if intensity > 0.3 then
                        local colorIndex = math.floor(intensity * #colors) + 1
                        colorIndex = math.min(colorIndex, #colors)
                        
                        floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.4 * intensity, nil, 0.1)
                    end
                end
            end
            
            task.wait(0.1)
        end
    end,
    
    -- Matrix-Regen Effekt
    MatrixRain = function(floorAnimator, duration, columnCount)
        local colors = ExperimentalPatterns.ColorPalettes.Cyberpunk
        columnCount = columnCount or 15
        local columns = {}
        
        -- Initialisiere Spalten
        for i = 1, columnCount do
            table.insert(columns, {
                x = math.random(1, 48),
                z = 1,
                speed = math.random(1, 3),
                length = math.random(8, 20),
                color = colors[math.random(1, #colors)]
            })
        end
        
        for t = 0, duration * 10 do
            -- Update alle Spalten
            for i, column in ipairs(columns) do
                -- Lösche alte Position
                for dz = 0, column.length do
                    local z = column.z - dz
                    if z >= 1 and z <= 48 then
                        floorAnimator:QueueUpdate(column.x, z, Color3.fromRGB(0, 0, 0), 0.9, nil, 0.1)
                    end
                end
                
                -- Bewege Spalte
                column.z = column.z + column.speed
                
                -- Zeichne neue Position
                for dz = 0, column.length do
                    local z = column.z - dz
                    if z >= 1 and z <= 48 then
                        local alpha = 1 - (dz / column.length)
                        floorAnimator:QueueUpdate(column.x, z, column.color, 0.3 * alpha, nil, 0.2)
                    end
                end
                
                -- Reset Spalte wenn sie unten ankommt
                if column.z > 48 + column.length then
                    column.z = 1
                    column.x = math.random(1, 48)
                    column.color = colors[math.random(1, #colors)]
                    column.length = math.random(8, 20)
                end
            end
            
            task.wait(0.15)
        end
    end,
    
    -- Kaleidoskop Muster
    Kaleidoscope = function(floorAnimator, centerX, centerZ, duration, sides)
        local colors = ExperimentalPatterns.ColorPalettes.Rainbow
        sides = sides or 6
        local radius = 20
        
        for t = 0, duration * 10 do
            local time = t / 10
            local rotation = time * 2
            
            for side = 0, sides - 1 do
                local baseAngle = (side * 2 * math.pi / sides) + rotation
                
                -- Erstelle Muster für diesen Sektor
                for r = 1, radius do
                    for angle_offset = -0.5, 0.5, 0.1 do
                        local angle = baseAngle + angle_offset
                        local x = centerX + math.cos(angle) * r
                        local z = centerZ + math.sin(angle) * r
                        
                        if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                            -- Spiegle das Muster für Kaleidoskop-Effekt
                            local mirrorAngle = baseAngle - angle_offset
                            local mirrorX = centerX + math.cos(mirrorAngle) * r
                            local mirrorZ = centerZ + math.sin(mirrorAngle) * r
                            
                            local pattern = math.sin(r * 0.5 + time * 3) * math.cos(angle * 3)
                            if pattern > 0.3 then
                                local colorIndex = (math.floor(r + time * 5) % #colors) + 1
                                local alpha = pattern
                                
                                floorAnimator:QueueUpdate(
                                    math.floor(x), math.floor(z),
                                    colors[colorIndex], 0.4 * alpha, nil, 0.1
                                )
                                
                                if mirrorX >= 1 and mirrorX <= 48 and mirrorZ >= 1 and mirrorZ <= 48 then
                                    floorAnimator:QueueUpdate(
                                        math.floor(mirrorX), math.floor(mirrorZ),
                                        colors[colorIndex], 0.4 * alpha, nil, 0.1
                                    )
                                end
                            end
                        end
                    end
                end
            end
            
            task.wait(0.1)
        end
    end
}

-- INTERACTIVE PATTERNS (reagieren auf Spieler-Input)
ExperimentalPatterns.InteractivePatterns = {
    
    -- Folge dem Spieler mit Regenbogen-Spur
    PlayerRainbowTrail = function(floorAnimator, playerPosition, lastPositions)
        local colors = ExperimentalPatterns.ColorPalettes.Rainbow
        
        for i, pos in ipairs(lastPositions) do
            local x, z = math.floor(pos.X / 4) + 24, math.floor(pos.Z / 4) + 24
            if x >= 1 and x <= 48 and z >= 1 and z <= 48 then
                local age = #lastPositions - i + 1
                local alpha = 1 - (age / #lastPositions)
                local colorIndex = (i % #colors) + 1
                
                floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.5 * alpha, nil, 0.5, true, 2)
            end
        end
    end,
    
    -- Reaktiver Boden (Tiles leuchten bei Nähe auf)
    ProximityGlow = function(floorAnimator, playerPosition, glowRadius, glowIntensity)
        local colors = ExperimentalPatterns.ColorPalettes.Galaxy
        local playerX = math.floor(playerPosition.X / 4) + 24
        local playerZ = math.floor(playerPosition.Z / 4) + 24
        
        for x = math.max(1, playerX - glowRadius), math.min(48, playerX + glowRadius) do
            for z = math.max(1, playerZ - glowRadius), math.min(48, playerZ + glowRadius) do
                local distance = math.sqrt((x - playerX)^2 + (z - playerZ)^2)
                
                if distance <= glowRadius then
                    local intensity = glowIntensity * (1 - distance / glowRadius)
                    local colorIndex = (math.floor(distance) % #colors) + 1
                    
                    floorAnimator:QueueUpdate(x, z, colors[colorIndex], 0.6 * intensity, nil, 0.3)
                end
            end
        end
    end
}

-- UTILITY FUNCTIONS für experimentelle Muster
ExperimentalPatterns.Utils = {
    
    -- Teste alle verrückten Muster nacheinander
    TestAllPatterns = function(floorAnimator)
        local patterns = {
            function() ExperimentalPatterns.CrazyPatterns.DNAHelix(floorAnimator, 24, 24, 10, 5) end,
            function() ExperimentalPatterns.CrazyPatterns.SinusInterference(floorAnimator, 8, 3) end,
            function() ExperimentalPatterns.CrazyPatterns.MatrixRain(floorAnimator, 10, 12) end,
            function() ExperimentalPatterns.CrazyPatterns.Kaleidoscope(floorAnimator, 24, 24, 8, 8) end,
            function() ExperimentalPatterns.CrazyPatterns.MandelbrotFractal(floorAnimator, 24, 24, 0.15, 15) end,
            function() ExperimentalPatterns.CrazyPatterns.CellularLife(floorAnimator, 20, "random") end
        }
        
        for i, pattern in ipairs(patterns) do
            print("Testing pattern " .. i .. "...")
            pattern()
            task.wait(3) -- Pause zwischen Mustern
            
            -- Clear floor
            for x = 1, 48 do
                for z = 1, 48 do
                    floorAnimator:QueueUpdate(x, z, Color3.fromRGB(50, 50, 50), 0.8, nil, 0.5)
                end
            end
            task.wait(2)
        end
    end,
    
    -- Zufälliges Farbschema auswählen
    GetRandomColorPalette = function()
        local paletteNames = {"Cyberpunk", "Rainbow", "FireAndIce", "Galaxy", "Toxic"}
        local randomName = paletteNames[math.random(1, #paletteNames)]
        return ExperimentalPatterns.ColorPalettes[randomName]
    end,
    
    -- Mischt zwei Farbpaletten
    BlendColorPalettes = function(palette1, palette2, blendFactor)
        local blended = {}
        local maxLength = math.max(#palette1, #palette2)
        
        for i = 1, maxLength do
            local color1 = palette1[((i - 1) % #palette1) + 1]
            local color2 = palette2[((i - 1) % #palette2) + 1]
            
            local r = color1.R * (1 - blendFactor) + color2.R * blendFactor
            local g = color1.G * (1 - blendFactor) + color2.G * blendFactor
            local b = color1.B * (1 - blendFactor) + color2.B * blendFactor
            
            table.insert(blended, Color3.fromRGB(
                math.floor(r * 255),
                math.floor(g * 255),
                math.floor(b * 255)
            ))
        end
        
        return blended
    end
}

return ExperimentalPatterns
