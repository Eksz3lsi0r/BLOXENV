-- 🏜️ GAARA'S SAND GUARDIAN SYSTEM - Ultimate Protection Floor! ⚡
-- Dein FloorSegment wird zu Gaara's legendärem Sand-Schutz!

local SandGuardian = {}
SandGuardian.__index = SandGuardian

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

function SandGuardian.new(floorSegmentModel, protectedPlayer)
    local self = setmetatable({}, SandGuardian)
    
    self.floorModel = floorSegmentModel
    self.protectedPlayer = protectedPlayer
    self.allParts = {}
    self.sandWalls = {}
    self.activeDefenses = {}
    self.enemyWeakening = {}
    self.autoProtection = true
    
    -- Gaara's Sand Farben
    self.sandColors = {
        normal = Color3.fromRGB(194, 178, 128),     -- Normal Sand
        defensive = Color3.fromRGB(255, 215, 0),    -- Gold Sand (Schutz)
        offensive = Color3.fromRGB(139, 69, 19),    -- Dunkel Sand (Angriff)
        ultimate = Color3.fromRGB(255, 140, 0),     -- Ultimate Defense
        blood = Color3.fromRGB(128, 0, 0)           -- Shukaku Modus
    }
    
    self:InitializeSandSystem()
    self:StartGuardianProtocol()
    
    -- 🏃‍♂️ DYNAMIC PATH SYSTEM für frischen Boden
    self.pathSystem = {
        activePathParts = {},
        pathColors = {
            fresh = Color3.fromRGB(255, 215, 0),        -- Gold für frischen Boden
            stepped = Color3.fromRGB(139, 69, 19),      -- Braun nach Schritt
            blessed = Color3.fromRGB(255, 255, 255),    -- Weiß für gesegneten Pfad
            power = Color3.fromRGB(255, 140, 0)         -- Orange für Kraft-Boost
        },
        pathRadius = 8,  -- Radius um Spieler für frischen Boden
        lastPlayerPos = nil,
        footstepTrail = {},
        pathBlessings = true  -- Pfad gibt Boni
    }
    
    self:StartDynamicPathSystem()
    
    -- 🎨 PATTERN SELECTOR SYSTEM
    local PatternSelector = require(script.Parent.PatternSelector)
    self.patternSelector = PatternSelector.new(self)
    
    print("🎨 100 Floor Patterns loaded and ready!")
    
    return self
end

-- 🏜️ Sand-System initialisieren
function SandGuardian:InitializeSandSystem()
    print("🏜️ Initializing Gaara's Sand Guardian System...")
    
    -- Alle Floor-Teile sammeln
    for _, descendant in ipairs(self.floorModel:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = Enum.Material.Sand
            descendant.Color = self.sandColors.normal
            table.insert(self.allParts, descendant)
        end
    end
    
    print("⚡ " .. #self.allParts .. " Sand-Partikel unter Kontrolle!")
    
    -- Basis-Schutzkreis um Spieler
    self:CreateBaseProtection()
end

-- 🛡️ Basis-Schutz um den Spieler
function SandGuardian:CreateBaseProtection()
    if not self.protectedPlayer.Character then return end
    
    local character = self.protectedPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local playerPos = humanoidRootPart.Position
    
    -- Schutzkreis aus Sand um Spieler
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - playerPos).Magnitude
        
        if distance <= 20 then -- Innerer Schutzkreis
            part.Color = self.sandColors.defensive
            part.Material = Enum.Material.Neon
            part.Size = part.Size + Vector3.new(0, 0.5, 0) -- Höher für Schutz
            
        elseif distance <= 40 then -- Äußerer Überwachungskreis
            part.Color = Color3.fromRGB(255, 215, 0):lerp(self.sandColors.normal, 0.7)
            part.Material = Enum.Material.Sand
        end
    end
    
    print("🛡️ Basis-Schutzkreis aktiviert!")
end

-- ⚡ Guardian Protocol starten (Hauptlogik)
function SandGuardian:StartGuardianProtocol()
    print("⚡ Gaara's Guardian Protocol ACTIVE!")
    
    -- Kontinuierliche Überwachung
    self.guardianConnection = RunService.Heartbeat:Connect(function()
        if self.autoProtection then
            self:MonitorThreats()
            self:UpdateSandMovement()
            self:WeakenEnemies()
            self:ProtectPlayer()
        end
    end)
    
    -- Schaden-Detection
    if self.protectedPlayer.Character then
        local humanoid = self.protectedPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            self.damageConnection = humanoid.HealthChanged:Connect(function(health)
                if health < humanoid.MaxHealth then
                    self:TriggerEmergencyDefense()
                end
            end)
        end
    end
end

-- 👁️ Bedrohungen überwachen
function SandGuardian:MonitorThreats()
    if not self.protectedPlayer.Character then return end
    
    local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
    
    -- Alle anderen Spieler als potentielle Bedrohungen checken
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= self.protectedPlayer and otherPlayer.Character then
            local otherPos = otherPlayer.Character.HumanoidRootPart.Position
            local distance = (otherPos - playerPos).Magnitude
            
            -- FEIND ERKANNT!
            if distance <= 60 then -- Überwachungsradius
                self:CreateSandDefense(otherPos, distance, otherPlayer)
            end
        end
    end
end

-- 🏜️ Sand-Verteidigung gegen Feinde
function SandGuardian:CreateSandDefense(enemyPos, distance, enemy)
    local intensity = math.max(0, (60 - distance) / 60) -- Je näher, desto stärker
    
    if distance <= 15 then
        -- NOTFALL: Feind zu nah! -> Ultimate Defense
        self:ActivateUltimateDefense(enemyPos)
        
    elseif distance <= 30 then
        -- Aggressive Verteidigung
        self:CreateSandWall(enemyPos, "aggressive")
        self:AttackEnemy(enemyPos, enemy)
        
    elseif distance <= 45 then
        -- Präventive Maßnahmen
        self:CreateSandWall(enemyPos, "defensive")
        self:SlowEnemy(enemy, intensity)
    end
end

-- 🌪️ Sand-Mauer erschaffen
function SandGuardian:CreateSandWall(targetPos, wallType)
    local wallColor = (wallType == "aggressive") and self.sandColors.offensive or self.sandColors.defensive
    local wallHeight = (wallType == "aggressive") and 3 or 1.5
    
    -- Nähe Teile für Mauer finden
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - targetPos).Magnitude
        
        if distance <= 10 then -- Mauer-Radius
            task.spawn(function()
                -- Sand erhebt sich
                local originalSize = part.Size
                
                local tween = TweenService:Create(part, 
                    TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                        Color = wallColor,
                        Size = Vector3.new(originalSize.X, wallHeight, originalSize.Z),
                        Material = Enum.Material.Rock
                    })
                tween:Play()
                
                -- Nach 5 Sekunden zurück
                task.wait(5)
                local resetTween = TweenService:Create(part,
                    TweenInfo.new(1, Enum.EasingStyle.Quart), {
                        Color = self.sandColors.normal,
                        Size = originalSize,
                        Material = Enum.Material.Sand
                    })
                resetTween:Play()
            end)
        end
    end
    
    print("🌪️ Sand-Mauer (" .. wallType .. ") erschaffen!")
end

-- ⚡ Ultimate Defense (Absolute Verteidigung)
function SandGuardian:ActivateUltimateDefense(threatPos)
    print("⚡ ULTIMATE DEFENSE ACTIVATED! (Shukaku's Power)")
    
    if not self.protectedPlayer.Character then return end
    local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
    
    -- Massive Sand-Kuppel um Spieler
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - playerPos).Magnitude
        
        if distance <= 25 then -- Kuppel-Radius
            task.spawn(function()
                local tween = TweenService:Create(part,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Color = self.sandColors.ultimate,
                        Size = part.Size * 2,
                        Material = Enum.Material.ForceField,
                        Transparency = 0.3
                    })
                tween:Play()
                
                -- Kuppel hält 8 Sekunden
                task.wait(8)
                
                local resetTween = TweenService:Create(part,
                    TweenInfo.new(1), {
                        Color = self.sandColors.defensive,
                        Size = part.Size / 2,
                        Material = Enum.Material.Sand,
                        Transparency = 0
                    })
                resetTween:Play()
            end)
        end
    end
    
    -- Sand-Stacheln gegen Bedrohung
    self:CreateSandSpikes(threatPos)
end

-- 🔱 Sand-Stacheln (Offensive)
function SandGuardian:CreateSandSpikes(targetPos)
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - targetPos).Magnitude
        
        if distance <= 15 then
            task.spawn(function()
                -- Stachel erhebt sich
                local tween = TweenService:Create(part,
                    TweenInfo.new(0.2), {
                        Color = self.sandColors.blood,
                        Size = Vector3.new(1, 6, 1), -- Hohe dünne Stacheln
                        Material = Enum.Material.Metal
                    })
                tween:Play()
                
                task.wait(3)
                
                -- Stachel verschwindet
                local resetTween = TweenService:Create(part,
                    TweenInfo.new(0.5), {
                        Color = self.sandColors.normal,
                        Size = Vector3.new(4, 0.2, 4),
                        Material = Enum.Material.Sand
                    })
                resetTween:Play()
            end)
        end
    end
    
    print("🔱 Sand-Stacheln erschaffen!")
end

-- 🐌 Feinde verlangsamen (Sand klebt an Füßen)
function SandGuardian:SlowEnemy(enemy, intensity)
    if not enemy.Character then return end
    
    local humanoid = enemy.Character:FindFirstChild("Humanoid")
    if humanoid then
        -- WalkSpeed reduzieren
        local originalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = originalSpeed * (1 - intensity * 0.7) -- Bis zu 70% langsamer
        
        print("🐌 " .. enemy.Name .. " durch Sand verlangsamt! (" .. math.floor(intensity * 100) .. "%)")
        
        -- Nach 3 Sekunden normalisieren
        task.wait(3)
        if humanoid then
            humanoid.WalkSpeed = originalSpeed
        end
    end
end

-- ⚔️ Feind angreifen (Sand-Projektile)
function SandGuardian:AttackEnemy(enemyPos, enemy)
    print("⚔️ Sand-Angriff auf " .. enemy.Name .. "!")
    
    -- Sand-Projektile Richtung Feind
    for i = 1, 5 do -- 5 Projektile
        task.spawn(function()
            task.wait(i * 0.1) -- Zeitversetzt
            
            local projectileParts = {}
            
            -- Sand sammelt sich für Projektil
            for _, part in ipairs(self.allParts) do
                local distance = (part.Position - enemyPos).Magnitude
                if distance <= 8 and math.random() < 0.3 then
                    table.insert(projectileParts, part)
                end
            end
            
            -- Projektil-Animation
            for _, part in ipairs(projectileParts) do
                local tween = TweenService:Create(part,
                    TweenInfo.new(0.5), {
                        Color = self.sandColors.offensive,
                        Size = part.Size * 0.5,
                        Material = Enum.Material.Rock
                    })
                tween:Play()
                
                task.wait(0.8)
                
                -- Reset
                local resetTween = TweenService:Create(part,
                    TweenInfo.new(0.3), {
                        Color = self.sandColors.normal,
                        Size = Vector3.new(4, 0.2, 4),
                        Material = Enum.Material.Sand
                    })
                resetTween:Play()
            end
        end)
    end
end

-- 💪 Spieler stärken (Sand-Verstärkung)
function SandGuardian:ProtectPlayer()
    if not self.protectedPlayer.Character then return end
    
    local humanoid = self.protectedPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        -- Gesundheit regenerieren
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 0.5)
        end
        
        -- Speed boost wenn in Gefahr
        local nearbyEnemies = 0
        local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
        
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= self.protectedPlayer and otherPlayer.Character then
                local distance = (otherPlayer.Character.HumanoidRootPart.Position - playerPos).Magnitude
                if distance <= 40 then
                    nearbyEnemies = nearbyEnemies + 1
                end
            end
        end
        
        if nearbyEnemies > 0 then
            humanoid.WalkSpeed = 20 + (nearbyEnemies * 5) -- Schneller bei mehr Feinden
            humanoid.JumpPower = 60 + (nearbyEnemies * 10) -- Höher springen
        end
    end
end

-- 🚨 Notfall-Verteidigung bei Schaden
function SandGuardian:TriggerEmergencyDefense()
    print("🚨 EMERGENCY! Gaara's sand responds to danger!")
    
    -- Alle Sand-Teile werden temporär zu Schutzschild
    for _, part in ipairs(self.allParts) do
        task.spawn(function()
            local tween = TweenService:Create(part,
                TweenInfo.new(0.1), {
                    Color = self.sandColors.blood,
                    Material = Enum.Material.Neon,
                    Size = part.Size * 1.5
                })
            tween:Play()
            
            task.wait(2)
            
            local resetTween = TweenService:Create(part,
                TweenInfo.new(0.5), {
                    Color = self.sandColors.defensive,
                    Material = Enum.Material.Sand,
                    Size = Vector3.new(4, 0.2, 4)
                })
            resetTween:Play()
        end)
    end
end

-- 🌪️ Sand-Bewegung simulieren
function SandGuardian:UpdateSandMovement()
    -- Subtile Sand-Bewegung für lebendigen Effekt
    if math.random() < 0.02 then -- 2% Chance pro Frame
        local randomPart = self.allParts[math.random(1, #self.allParts)]
        
        local tween = TweenService:Create(randomPart,
            TweenInfo.new(2, Enum.EasingStyle.Sine), {
                Color = randomPart.Color:lerp(self.sandColors.defensive, 0.3)
            })
        tween:Play()
        
        task.wait(2)
        tween = TweenService:Create(randomPart,
            TweenInfo.new(2), {
                Color = self.sandColors.normal
            })
        tween:Play()
    end
end

-- 🎮 Spezial-Modi aktivieren
function SandGuardian:ActivateShukakuMode()
    print("👹 SHUKAKU MODE ACTIVATED! Ultimate Sand Control!")
    
    -- Alle Teile werden zu Shukaku's Sand
    for _, part in ipairs(self.allParts) do
        part.Color = self.sandColors.blood
        part.Material = Enum.Material.Neon
        part.Size = part.Size * 1.2
    end
    
    -- 30 Sekunden Shukaku-Power
    task.wait(30)
    
    -- Zurück zu normal
    for _, part in ipairs(self.allParts) do
        part.Color = self.sandColors.normal
        part.Material = Enum.Material.Sand
        part.Size = Vector3.new(4, 0.2, 4)
    end
    
    print("🏜️ Shukaku mode deactivated. Sand returns to normal.")
end

-- 🔧 Kontroll-Funktionen
function SandGuardian:SetProtectionLevel(level)
    -- level: "passive", "active", "aggressive", "shukaku"
    if level == "shukaku" then
        self:ActivateShukakuMode()
    end
    print("🛡️ Protection level set to: " .. level)
end

function SandGuardian:Destroy()
    if self.guardianConnection then
        self.guardianConnection:Disconnect()
    end
    if self.damageConnection then
        self.damageConnection:Disconnect()
    end
    print("🏜️ Sand Guardian System deactivated.")
end

-- 🏃‍♂️ DYNAMIC PATH SYSTEM - Frischer Boden vor den Füßen!
function SandGuardian:StartDynamicPathSystem()
    print("🏃‍♂️ Dynamic Path System activated - Fresh ground for every step!")
    
    -- Kontinuierliche Pfad-Aktualisierung
    self.pathConnection = RunService.Heartbeat:Connect(function()
        if self.protectedPlayer.Character then
            self:UpdateDynamicPath()
            self:CheckFootsteps()
            self:ManagePathEffects()
        end
    end)
end

-- 🌟 Dynamischen Pfad vor Spieler aktualisieren
function SandGuardian:UpdateDynamicPath()
    local character = self.protectedPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end
    
    local currentPos = humanoidRootPart.Position
    local moveVector = humanoidRootPart.AssemblyLinearVelocity
    local isMoving = moveVector.Magnitude > 2
    
    if isMoving then
        -- Bewegungsrichtung berechnen
        local moveDirection = moveVector.Unit
        
        -- Pfad vor dem Spieler vorbereiten (3-5 Schritte voraus)
        for step = 1, 5 do
            local futurePos = currentPos + (moveDirection * step * 4)
            self:PrepareFreshGround(futurePos, step)
        end
        
        -- Seitlichen Pfad auch vorbereiten (für Wendungen)
        local rightVector = moveDirection:Cross(Vector3.new(0, 1, 0))
        for side = -2, 2 do
            local sidePos = currentPos + (moveDirection * 8) + (rightVector * side * 4)
            self:PrepareFreshGround(sidePos, 3)
        end
    end
    
    -- Aktueller Standort wird zu "gesegnetem" Boden
    self:BlessCurrentGround(currentPos)
    
    self.pathSystem.lastPlayerPos = currentPos
end

-- ✨ Frischen Boden vor Spieler vorbereiten
function SandGuardian:PrepareFreshGround(worldPos, priority)
    -- Finde nächstes Floor-Teil
    local closestPart = nil
    local closestDistance = math.huge
    
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - worldPos).Magnitude
        if distance < closestDistance and distance <= 8 then
            closestDistance = distance
            closestPart = part
        end
    end
    
    if closestPart and not self.pathSystem.activePathParts[closestPart] then
        -- Frischen Boden erstellen
        self.pathSystem.activePathParts[closestPart] = {
            type = "fresh",
            priority = priority,
            createTime = tick(),
            originalColor = closestPart.Color,
            originalMaterial = closestPart.Material,
            originalSize = closestPart.Size
        }
        
        -- Visueller Effekt für frischen Boden
        local intensity = math.max(0.3, 1 - (priority - 1) * 0.2) -- Je näher, desto heller
        
        local tween = TweenService:Create(closestPart,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Color = self.pathSystem.pathColors.fresh,
                Material = Enum.Material.Neon,
                Size = closestPart.Size + Vector3.new(0, 0.1 * intensity, 0),
                Transparency = 0.1
            })
        tween:Play()
        
        -- Glitzer-Effekt für frischen Boden
        task.spawn(function()
            for sparkle = 1, 3 do
                task.wait(0.2)
                if closestPart.Parent then
                    local sparkTween = TweenService:Create(closestPart,
                        TweenInfo.new(0.1), {
                            Color = self.pathSystem.pathColors.blessed
                        })
                    sparkTween:Play()
                    
                    task.wait(0.1)
                    sparkTween = TweenService:Create(closestPart,
                        TweenInfo.new(0.1), {
                            Color = self.pathSystem.pathColors.fresh
                        })
                    sparkTween:Play()
                end
            end
        end)
    end
end

-- 👑 Aktuellen Boden segnen (wo Spieler steht)
function SandGuardian:BlessCurrentGround(playerPos)
    for _, part in ipairs(self.allParts) do
        local distance = (part.Position - playerPos).Magnitude
        
        if distance <= 6 then -- Direkt um Spieler
            local blessData = self.pathSystem.activePathParts[part]
            
            if not blessData or blessData.type ~= "blessed" then
                self.pathSystem.activePathParts[part] = {
                    type = "blessed",
                    createTime = tick(),
                    originalColor = part.Color,
                    originalMaterial = part.Material,
                    originalSize = part.Size
                }
                
                -- Gesegneter Boden Effekt
                local tween = TweenService:Create(part,
                    TweenInfo.new(0.5), {
                        Color = self.pathSystem.pathColors.blessed,
                        Material = Enum.Material.ForceField,
                        Size = part.Size + Vector3.new(0, 0.3, 0),
                        Transparency = 0.2
                    })
                tween:Play()
                
                -- Heilungs-Effekt wenn auf gesegnetem Boden
                if self.pathSystem.pathBlessings then
                    self:ApplyPathBlessing()
                end
            end
        end
    end
end

-- 👟 Fußstapfen erkennen und Farbwechsel
function SandGuardian:CheckFootsteps()
    local character = self.protectedPlayer.Character
    if not character then return end
    
    local leftFoot = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg")
    local rightFoot = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoid then return end
    
    -- Animation-basierte Fußstapfen-Erkennung
    local animationTracks = humanoid:GetPlayingAnimationTracks()
    local isWalking = false
    local isRunning = false
    
    for _, track in ipairs(animationTracks) do
        local animName = track.Animation.Name:lower()
        if animName:find("walk") or animName:find("run") then
            isWalking = true
            if animName:find("run") or track.Speed > 1.2 then
                isRunning = true
            end
        end
    end
    
    -- Fußstapfen-Effekte basierend auf Animation
    if isWalking or isRunning then
        self:CreateFootstepEffects(isRunning)
    end
end

-- 👣 Fußstapfen-Effekte erstellen
function SandGuardian:CreateFootstepEffects(isRunning)
    local character = self.protectedPlayer.Character
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Zufällige Fußstapfen um Spieler
    if math.random() < (isRunning and 0.3 or 0.15) then -- Häufiger beim Rennen
        
        local footstepPos = humanoidRootPart.Position + Vector3.new(
            math.random(-3, 3),
            -2.5,
            math.random(-3, 3)
        )
        
        -- Finde Boden-Teil für Fußstapfen
        for _, part in ipairs(self.allParts) do
            local distance = (part.Position - footstepPos).Magnitude
            
            if distance <= 4 then
                -- Fußstapfen-Effekt
                task.spawn(function()
                    local stepColor = isRunning and self.pathSystem.pathColors.power or self.pathSystem.pathColors.stepped
                    
                    -- Schritt-Animation
                    local tween = TweenService:Create(part,
                        TweenInfo.new(0.1), {
                            Color = stepColor,
                            Size = part.Size * 0.9, -- Etwas eindrücken
                            Material = Enum.Material.Sand
                        })
                    tween:Play()
                    
                    -- Staub-Effekt simulieren
                    task.wait(0.1)
                    local dustTween = TweenService:Create(part,
                        TweenInfo.new(0.2), {
                            Color = stepColor:lerp(Color3.fromRGB(200, 200, 200), 0.5),
                            Transparency = 0.3
                        })
                    dustTween:Play()
                    
                    -- Fußstapfen bleibt 3 Sekunden sichtbar
                    task.wait(3)
                    
                    -- Zurück zu normal (falls nicht anderweitig verändert)
                    if not self.pathSystem.activePathParts[part] then
                        local resetTween = TweenService:Create(part,
                            TweenInfo.new(1), {
                                Color = self.sandColors.normal,
                                Size = Vector3.new(4, 0.2, 4),
                                Material = Enum.Material.Sand,
                                Transparency = 0
                            })
                        resetTween:Play()
                    end
                end)
                
                break -- Nur ein Teil pro Fußstapfen
            end
        end
    end
end

-- 💎 Pfad-Segnungen anwenden
function SandGuardian:ApplyPathBlessing()
    local character = self.protectedPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Gesundheits-Regeneration auf gesegnetem Boden
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 2)
    end
    
    -- Speed-Boost auf frischem Boden
    local baseSpeed = 16
    local currentSpeed = humanoid.WalkSpeed
    
    if currentSpeed <= baseSpeed then
        humanoid.WalkSpeed = baseSpeed + 4 -- +25% Speed auf Sand-Pfad
    end
    
    -- Sprung-Boost
    if humanoid.JumpPower <= 50 then
        humanoid.JumpPower = 60 -- Höher springen auf Sand
    end
end

-- 🔄 Pfad-Effekte verwalten (Cleanup)
function SandGuardian:ManagePathEffects()
    local currentTime = tick()
    local cleanupList = {}
    
    for part, data in pairs(self.pathSystem.activePathParts) do
        local age = currentTime - data.createTime
        
        -- Verschiedene Cleanup-Zeiten je nach Typ
        local maxAge = 5 -- Standard
        if data.type == "blessed" then maxAge = 8
        elseif data.type == "fresh" then maxAge = 10
        
        if age > maxAge then
            table.insert(cleanupList, part)
        end
    end
    
    -- Cleanup alte Pfad-Effekte
    for _, part in ipairs(cleanupList) do
        local data = self.pathSystem.activePathParts[part]
        
        if part.Parent and data then
            -- Sanft zurück zu normalem Sand
            local resetTween = TweenService:Create(part,
                TweenInfo.new(2, Enum.EasingStyle.Quad), {
                    Color = self.sandColors.normal,
                    Material = Enum.Material.Sand,
                    Size = Vector3.new(4, 0.2, 4),
                    Transparency = 0
                })
            resetTween:Play()
        end
        
        self.pathSystem.activePathParts[part] = nil
    end
end

-- 🎮 Pfad-System Einstellungen
function SandGuardian:SetPathSettings(settings)
    if settings.pathRadius then
        self.pathSystem.pathRadius = settings.pathRadius
    end
    
    if settings.pathBlessings ~= nil then
        self.pathSystem.pathBlessings = settings.pathBlessings
    end
    
    if settings.pathColors then
        for colorType, color in pairs(settings.pathColors) do
            self.pathSystem.pathColors[colorType] = color
        end
    end
    
    print("🎨 Path system settings updated!")
end

-- 🌈 Spezial-Pfad Modi
function SandGuardian:ActivateRainbowPath(duration)
    duration = duration or 30
    print("🌈 Rainbow Path activated for " .. duration .. " seconds!")
    
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),    -- Rot
        Color3.fromRGB(255, 127, 0),  -- Orange
        Color3.fromRGB(255, 255, 0),  -- Gelb
        Color3.fromRGB(0, 255, 0),    -- Grün
        Color3.fromRGB(0, 0, 255),    -- Blau
        Color3.fromRGB(138, 43, 226)  -- Violett
    }
    
    -- Temporär Regenbogen-Farben setzen
    local originalColors = {}
    for key, color in pairs(self.pathSystem.pathColors) do
        originalColors[key] = color
    end
    
    task.spawn(function()
        local startTime = tick()
        local colorIndex = 1
        
        while tick() - startTime < duration do
            self.pathSystem.pathColors.fresh = rainbowColors[colorIndex]
            self.pathSystem.pathColors.blessed = rainbowColors[((colorIndex + 1) % #rainbowColors) + 1]
            
            colorIndex = (colorIndex % #rainbowColors) + 1
            task.wait(0.5)
        end
        
        -- Zurück zu normalen Farben
        self.pathSystem.pathColors = originalColors
        print("🌈 Rainbow Path ended!")
    end)
end

return SandGuardian
