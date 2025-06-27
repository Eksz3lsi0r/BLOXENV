-- 🏜️ GAARA'S SAND GUARDIAN - SOFORT AKTIVIEREN! ⚡
-- Kopiere diesen Code in ServerScriptService für sofortigen Schutz!

local Players = game:GetService("Players")
local SandGuardian = require(script.Parent.SandGuardian) -- Pfad anpassen!

-- 🎯 FloorSegment automatisch finden
local function findFloorSegment()
    local possibleNames = {"FloorSegment", "Floor", "FloorGrid"}
    
    for _, name in ipairs(possibleNames) do
        local found = workspace:FindFirstChild(name)
        if found then return found end
    end
    
    -- Auto-detect großes Model
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            local partCount = #child:GetDescendants()
            if partCount > 1000 then
                return child
            end
        end
    end
    
    error("❌ FloorSegment nicht gefunden!")
end

local floorSegment = findFloorSegment()
print("✅ FloorSegment gefunden: " .. floorSegment.Name)

-- 🏜️ Sand Guardian für jeden Spieler aktivieren
local activeGuardians = {}

local function activateGuardianForPlayer(player)
    print("🏜️ Aktiviere Gaara's Sand Guardian für " .. player.Name)
    
    -- Warten bis Character geladen
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Kurz warten bis alles geladen
        
        -- Sand Guardian erstellen
        local guardian = SandGuardian.new(floorSegment, player)
        activeGuardians[player] = guardian
        
        print("⚡ " .. player.Name .. " ist jetzt durch Gaara's Sand geschützt!")
        
        -- Chat-Commands für den Spieler
        player.Chatted:Connect(function(message)
            local cmd = message:lower()
            
            if cmd == "/shukaku" then
                guardian:ActivateShukakuMode()
                print("👹 " .. player.Name .. " aktivierte Shukaku-Modus!")
                
            elseif cmd == "/defense" then
                guardian:ActivateUltimateDefense(character.HumanoidRootPart.Position + Vector3.new(10, 0, 0))
                print("🛡️ " .. player.Name .. " aktivierte Ultimate Defense!")
                
            elseif cmd:match("/protect (.+)") then
                local level = cmd:match("/protect (.+)")
                guardian:SetProtectionLevel(level)
                
            elseif cmd == "/sandhelp" then
                print("🏜️ GAARA'S SAND COMMANDS für " .. player.Name .. ":")
                print("  /shukaku     - Aktiviere Shukaku-Modus (30s)")
                print("  /defense     - Ultimate Defense")
                print("  /protect passive/active/aggressive")
                print("  /sandstats   - Sand-System Status")
                
            elseif cmd == "/sandstats" then
                print("📊 SAND GUARDIAN STATUS für " .. player.Name .. ":")
                print("  🏜️ Sand-Partikel: " .. #guardian.allParts)
                print("  🛡️ Auto-Protection: " .. tostring(guardian.autoProtection))
                print("  ⚡ Active Defenses: " .. #guardian.activeDefenses)
            end
        end)
    end)
end

-- 🎮 Für alle Spieler aktivieren
Players.PlayerAdded:Connect(activateGuardianForPlayer)

-- Bereits im Spiel befindliche Spieler
for _, player in ipairs(Players:GetPlayers()) do
    activateGuardianForPlayer(player)
end

-- 🧹 Cleanup bei Player Leave
Players.PlayerRemoving:Connect(function(player)
    if activeGuardians[player] then
        activeGuardians[player]:Destroy()
        activeGuardians[player] = nil
        print("🏜️ Sand Guardian für " .. player.Name .. " deaktiviert")
    end
end)

-- 🎬 DEMO: Automatische Sand-Show alle 60 Sekunden
task.spawn(function()
    while true do
        task.wait(60)
        
        print("🎬 SAND GUARDIAN DEMO - Alle aktiven Systeme zeigen Kraft!")
        
        for player, guardian in pairs(activeGuardians) do
            if player.Character then
                task.spawn(function()
                    -- Kurze Demo-Show für jeden Spieler
                    local playerPos = player.Character.HumanoidRootPart.Position
                    
                    -- Sand-Welle um Spieler
                    for i = 1, 5 do
                        guardian:CreateSandWall(playerPos + Vector3.new(i * 8, 0, 0), "defensive")
                        task.wait(0.5)
                    end
                    
                    task.wait(3)
                    
                    -- Kurze Ultimate Defense
                    guardian:ActivateUltimateDefense(playerPos + Vector3.new(20, 0, 0))
                end)
            end
        end
    end
end)

-- 🎯 Admin-Commands (für Testing)
local function setupAdminCommands()
    Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            local args = string.split(message:lower(), " ")
            local cmd = args[1]
            
            -- Admin-Commands (nur für Entwickler)
            if player.Name == "YourUsernameHere" then -- Ersetze mit deinem Username
                
                if cmd == "/testthreat" then
                    -- Simuliere Bedrohung für alle Spieler
                    for testPlayer, guardian in pairs(activeGuardians) do
                        if testPlayer.Character then
                            local pos = testPlayer.Character.HumanoidRootPart.Position
                            guardian:CreateSandDefense(pos + Vector3.new(15, 0, 0), 15, player)
                        end
                    end
                    print("🧪 Threat test activated!")
                    
                elseif cmd == "/massshukaku" then
                    -- Alle Spieler in Shukaku-Modus
                    for _, guardian in pairs(activeGuardians) do
                        task.spawn(function()
                            guardian:ActivateShukakuMode()
                        end)
                    end
                    print("👹 MASS SHUKAKU MODE ACTIVATED!")
                    
                elseif cmd == "/sandstorm" then
                    -- Epic Sandsturm-Effekt
                    for _, guardian in pairs(activeGuardians) do
                        task.spawn(function()
                            for _, part in ipairs(guardian.allParts) do
                                if math.random() < 0.8 then
                                    local tween = game:GetService("TweenService"):Create(part,
                                        TweenInfo.new(2), {
                                            Color = guardian.sandColors.offensive,
                                            Size = part.Size * 1.3,
                                            Material = Enum.Material.Sand
                                        })
                                    tween:Play()
                                end
                            end
                            
                            task.wait(10)
                            
                            -- Reset
                            for _, part in ipairs(guardian.allParts) do
                                local resetTween = game:GetService("TweenService"):Create(part,
                                    TweenInfo.new(3), {
                                        Color = guardian.sandColors.normal,
                                        Size = Vector3.new(4, 0.2, 4),
                                        Material = Enum.Material.Sand
                                    })
                                resetTween:Play()
                            end
                        end)
                    end
                    print("🌪️ EPIC SANDSTORM UNLEASHED!")
                end
            end
        end)
    end)
end

setupAdminCommands()

print("🏜️ GAARA'S SAND GUARDIAN SYSTEM FULLY ACTIVATED!")
print("⚡ All players are now protected by the sand!")
print("💬 Chat '/sandhelp' for commands")
print("🎬 Automatic demos every 60 seconds")

-- 🎵 Startup-Effekt: Sand erwacht zum Leben
task.spawn(function()
    task.wait(2)
    
    print("🌪️ The sand awakens... Gaara's power flows through the floor!")
    
    -- Alle Sand-Teile kurz aufleuchten lassen
    for _, guardian in pairs(activeGuardians) do
        if guardian then
            for i, part in ipairs(guardian.allParts) do
                task.spawn(function()
                    task.wait(i * 0.001) -- Sehr schnell nacheinander
                    
                    local tween = game:GetService("TweenService"):Create(part,
                        TweenInfo.new(0.5), {
                            Color = guardian.sandColors.defensive,
                            Material = Enum.Material.Neon
                        })
                    tween:Play()
                    
                    task.wait(1)
                    
                    local resetTween = game:GetService("TweenService"):Create(part,
                        TweenInfo.new(1), {
                            Color = guardian.sandColors.normal,
                            Material = Enum.Material.Sand
                        })
                    resetTween:Play()
                end)
            end
        end
    end
end)
