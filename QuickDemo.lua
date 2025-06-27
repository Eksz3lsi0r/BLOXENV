-- 🎬 SOFORT RESULTATE SEHEN - Quick Demo für dein FloorSegment! 🚀
-- Kopiere diesen Code in die Command Bar oder als ServerScript

-- 🎯 SCHNELL-SETUP: Dein FloorSegment finden
local floorSegment = workspace:FindFirstChild("FloorSegment") 
    or workspace:FindFirstChild("Floor")
    or workspace:FindFirstChild("FloorGrid")

if not floorSegment then
    -- Auto-detect: Erstes Model mit vielen Parts
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") then
            local partCount = #model:GetDescendants()
            if partCount > 1000 then
                floorSegment = model
                break
            end
        end
    end
end

if not floorSegment then
    error("❌ FloorSegment nicht gefunden! Stelle sicher, dass dein 48x48 Grid im Workspace ist.")
end

print("✅ FloorSegment gefunden: " .. floorSegment.Name)

-- 🎯 ALLE FLOOR-TEILE SAMMELN
local allParts = {}
for _, descendant in ipairs(floorSegment:GetDescendants()) do
    if descendant:IsA("BasePart") then
        table.insert(allParts, descendant)
    end
end

print("🔥 " .. #allParts .. " Teile gefunden! Bereit für Action!")

-- 🎨 DEMO 1: REGENBOGEN-WELLE (5 Sekunden)
print("🌈 DEMO 1: Regenbogen-Welle startet!")
task.spawn(function()
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),    -- Rot
        Color3.fromRGB(255, 127, 0),  -- Orange
        Color3.fromRGB(255, 255, 0),  -- Gelb
        Color3.fromRGB(0, 255, 0),    -- Grün
        Color3.fromRGB(0, 0, 255),    -- Blau
        Color3.fromRGB(138, 43, 226)  -- Violett
    }
    
    for wave = 1, 3 do -- 3 Wellen
        for i, part in ipairs(allParts) do
            local colorIndex = ((i + wave * 100) % #rainbowColors) + 1
            local delay = (i / #allParts) * 2 -- 2 Sekunden für eine Welle
            
            task.spawn(function()
                task.wait(delay)
                if part and part.Parent then
                    part.Color = rainbowColors[colorIndex]
                    part.Material = Enum.Material.Neon
                    
                    -- Kurzes Aufleuchten
                    task.wait(0.5)
                    if part and part.Parent then
                        part.Color = Color3.fromRGB(100, 100, 100)
                        part.Material = Enum.Material.Plastic
                    end
                end
            end)
        end
        task.wait(2.5)
    end
end)

task.wait(8) -- Warten bis Regenbogen-Demo fertig

-- 🎨 DEMO 2: PULSIERENDER KREIS (5 Sekunden)
print("💙 DEMO 2: Pulsierender Kreis startet!")
task.spawn(function()
    -- Zentrum finden (mittleres Teil)
    local centerPart = allParts[math.floor(#allParts / 2)]
    local centerPos = centerPart.Position
    
    for pulse = 1, 10 do -- 10 Pulse
        local radius = pulse * 20 -- Größer werdende Kreise
        local pulseColor = Color3.fromHSV((pulse * 0.1) % 1, 1, 1) -- Farbwechsel
        
        for _, part in ipairs(allParts) do
            local distance = (part.Position - centerPos).Magnitude
            
            if math.abs(distance - radius) < 15 then -- Ring-Effekt
                task.spawn(function()
                    if part and part.Parent then
                        part.Color = pulseColor
                        part.Material = Enum.Material.ForceField
                        part.Transparency = 0.3
                        
                        task.wait(0.8)
                        if part and part.Parent then
                            part.Color = Color3.fromRGB(100, 100, 100)
                            part.Material = Enum.Material.Plastic
                            part.Transparency = 0
                        end
                    end
                end)
            end
        end
        
        task.wait(0.5) -- Pulse-Geschwindigkeit
    end
end)

task.wait(6)

-- 🎨 DEMO 3: ZUFÄLLIGES FEUERWERK (10 Sekunden)
print("🎆 DEMO 3: Zufälliges Feuerwerk startet!")
task.spawn(function()
    local fireworkColors = {
        Color3.fromRGB(255, 0, 0),    -- Rot
        Color3.fromRGB(0, 255, 0),    -- Grün
        Color3.fromRGB(0, 0, 255),    -- Blau
        Color3.fromRGB(255, 255, 0),  -- Gelb
        Color3.fromRGB(255, 0, 255),  -- Magenta
        Color3.fromRGB(0, 255, 255),  -- Cyan
        Color3.fromRGB(255, 255, 255) -- Weiß
    }
    
    for explosion = 1, 20 do -- 20 Explosionen
        -- Zufällige Explosions-Zentren
        local explosionParts = {}
        for i = 1, math.random(5, 15) do
            table.insert(explosionParts, allParts[math.random(1, #allParts)])
        end
        
        local explosionColor = fireworkColors[math.random(1, #fireworkColors)]
        
        -- Explosion animieren
        for _, part in ipairs(explosionParts) do
            task.spawn(function()
                if part and part.Parent then
                    part.Color = explosionColor
                    part.Material = Enum.Material.Neon
                    part.Size = part.Size * 1.5 -- Größer werden
                    
                    task.wait(0.3)
                    if part and part.Parent then
                        part.Color = Color3.fromRGB(100, 100, 100)
                        part.Material = Enum.Material.Plastic
                        part.Size = part.Size / 1.5 -- Zurück zur normalen Größe
                    end
                end
            end)
        end
        
        task.wait(0.5) -- Zwischen Explosionen
    end
end)

task.wait(11)

-- 🎨 DEMO 4: SPIRALE MIT TRAIL (8 Sekunden)
print("🌀 DEMO 4: Spirale mit Trail startet!")
task.spawn(function()
    local spiralColors = {
        Color3.fromRGB(138, 43, 226),  -- Violett
        Color3.fromRGB(75, 0, 130),    -- Indigo
        Color3.fromRGB(255, 20, 147)   -- Deep Pink
    }
    
    -- Sortiere Parts nach Position für Spiral-Effekt
    table.sort(allParts, function(a, b)
        local angleA = math.atan2(a.Position.Z, a.Position.X)
        local angleB = math.atan2(b.Position.Z, b.Position.X)
        return angleA < angleB
    end)
    
    for round = 1, 4 do -- 4 Spiral-Runden
        for i, part in ipairs(allParts) do
            local colorIndex = ((i + round * 200) % #spiralColors) + 1
            local delay = (i / #allParts) * 2 -- 2 Sekunden pro Runde
            
            task.spawn(function()
                task.wait(delay)
                if part and part.Parent then
                    part.Color = spiralColors[colorIndex]
                    part.Material = Enum.Material.Neon
                    part.Transparency = 0.2
                    
                    -- Trail-Effekt: bleibt länger sichtbar
                    task.wait(1.5)
                    if part and part.Parent then
                        part.Color = Color3.fromRGB(100, 100, 100)
                        part.Material = Enum.Material.Plastic
                        part.Transparency = 0
                    end
                end
            end)
        end
        task.wait(2.2)
    end
end)

task.wait(9)

-- 🎨 DEMO 5: MATRIX-EFFEKT (10 Sekunden)
print("💚 DEMO 5: Matrix-Effekt startet!")
task.spawn(function()
    local matrixGreen = Color3.fromRGB(0, 255, 65)
    local matrixDark = Color3.fromRGB(0, 100, 20)
    
    for wave = 1, 15 do -- 15 Matrix-Wellen
        -- Zufällige "Daten-Ströme"
        local streamCount = math.random(10, 30)
        
        for stream = 1, streamCount do
            local streamParts = {}
            
            -- Zufällige vertikale Linie von Parts
            local startIndex = math.random(1, #allParts - 50)
            for i = startIndex, math.min(startIndex + math.random(10, 30), #allParts) do
                table.insert(streamParts, allParts[i])
            end
            
            -- Stream animieren
            task.spawn(function()
                for i, part in ipairs(streamParts) do
                    task.spawn(function()
                        task.wait(i * 0.05) -- Staggered effect
                        if part and part.Parent then
                            part.Color = matrixGreen
                            part.Material = Enum.Material.Neon
                            
                            task.wait(0.3)
                            if part and part.Parent then
                                part.Color = matrixDark
                                task.wait(0.2)
                                if part and part.Parent then
                                    part.Color = Color3.fromRGB(100, 100, 100)
                                    part.Material = Enum.Material.Plastic
                                end
                            end
                        end
                    end)
                end
            end)
        end
        
        task.wait(0.7) -- Zwischen Matrix-Wellen
    end
end)

task.wait(11)

-- 🧹 RESET: Alle Teile zurücksetzen
print("🧹 RESET: Alle Teile werden zurückgesetzt...")
for _, part in ipairs(allParts) do
    if part and part.Parent then
        part.Color = Color3.fromRGB(100, 100, 100)
        part.Material = Enum.Material.Plastic
        part.Transparency = 0
        part.Size = Vector3.new(4, 0.2, 4) -- Standard-Größe
    end
end

print("✅ Demo-Show beendet! Alle " .. #allParts .. " Teile zurückgesetzt.")
print("🎉 Dein FloorSegment ist bereit für weitere Tests!")

-- 🎮 BONUS: Einfache Chat-Commands zum Weiter-Experimentieren
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/rainbow" then
            -- Sofortiger Regenbogen-Effekt
            for i, part in ipairs(allParts) do
                local hue = (i / #allParts) * 360
                part.Color = Color3.fromHSV(hue / 360, 1, 1)
                part.Material = Enum.Material.Neon
            end
            print("🌈 " .. player.Name .. " aktivierte Regenbogen-Modus!")
            
        elseif message:lower() == "/reset" then
            -- Alles zurücksetzen
            for _, part in ipairs(allParts) do
                part.Color = Color3.fromRGB(100, 100, 100)
                part.Material = Enum.Material.Plastic
                part.Transparency = 0
            end
            print("🧹 " .. player.Name .. " hat das Floor zurückgesetzt!")
            
        elseif message:lower() == "/party" then
            -- Party-Modus: Zufällige blinkende Farben
            for _, part in ipairs(allParts) do
                task.spawn(function()
                    for blink = 1, 10 do
                        part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                        part.Material = Enum.Material.Neon
                        task.wait(0.2)
                    end
                    part.Color = Color3.fromRGB(100, 100, 100)
                    part.Material = Enum.Material.Plastic
                end)
            end
            print("🎉 " .. player.Name .. " startete Party-Modus!")
        end
    end)
end)

print("💬 Chat-Commands verfügbar: /rainbow, /reset, /party")
