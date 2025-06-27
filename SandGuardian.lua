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
    self:InitializeAdvancedAnimations()
    self:InitializeExtremePatterns()
    self:SetupPlayerCommands()
    
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

-- 🌊 ADVANCED ANIMATION TECHNIQUES - Pushing the Limits! ⚡
function SandGuardian:InitializeAdvancedAnimations()
    self.advancedAnimations = {
        -- 🌪️ TORNADO SAND VORTEX - Multi-layered spinning animation
        tornadoVortex = function(centerPos, intensity)
            local layers = 5
            local maxRadius = 25
            
            for layer = 1, layers do
                task.spawn(function()
                    local layerRadius = (layer / layers) * maxRadius
                    local speed = (layers - layer + 1) * 0.1 -- Inner layers spin faster
                    local revolution = 0
                    
                    for i = 1, 200 do -- Long-running animation
                        revolution = revolution + speed
                        
                        -- Spiral pattern
                        for angle = 0, math.pi * 2, 0.2 do
                            local spiralAngle = angle + revolution
                            local spiralRadius = layerRadius + math.sin(revolution * 3) * 3
                            
                            local targetPos = centerPos + Vector3.new(
                                math.cos(spiralAngle) * spiralRadius,
                                0,
                                math.sin(spiralAngle) * spiralRadius
                            )
                            
                            local part = self:GetClosestPart(targetPos)
                            if part then
                                -- Color gradient based on layer and position
                                local colorIntensity = (layer / layers) * intensity
                                local heightVariation = math.sin(revolution * 5 + angle * 3) * 2
                                
                                local tween = TweenService:Create(part, 
                                    TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                                        Color = Color3.fromRGB(
                                            194 + colorIntensity * 60,
                                            178 + colorIntensity * 40,
                                            128 + colorIntensity * 80
                                        ),
                                        Size = Vector3.new(4, 0.2 + heightVariation, 4),
                                        Material = Enum.Material.Neon
                                    })
                                tween:Play()
                            end
                        end
                        
                        task.wait(0.05)
                    end
                end)
            end
        end,
        
        -- ⚡ LIGHTNING FRACTAL - Recursive branching lightning
        lightningFractal = function(startPos, endPos, depth, intensity)
            if depth <= 0 then return end
            
            local midPoint = startPos:lerp(endPos, 0.5) + 
                            Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            
            -- Main branch
            self:CreateLightningSegment(startPos, midPoint, intensity)
            self:CreateLightningSegment(midPoint, endPos, intensity)
            
            -- Recursive sub-branches
            if depth > 1 and math.random() < 0.7 then
                local branchDirection = (endPos - startPos):Cross(Vector3.new(0, 1, 0)).Unit
                local branchEnd = midPoint + branchDirection * math.random(5, 15)
                
                task.spawn(function()
                    task.wait(0.1)
                    self.advancedAnimations.lightningFractal(midPoint, branchEnd, depth - 1, intensity * 0.7)
                end)
            end
        end,
        
        -- 🌀 DIMENSIONAL RIFT - Reality-bending visual effect
        dimensionalRift = function(centerPos, size)
            local riftParts = {}
            
            -- Create swirling void effect
            for angle = 0, math.pi * 2, 0.1 do
                for radius = 1, size do
                    local pos = centerPos + Vector3.new(
                        math.cos(angle * 3 + radius * 0.5) * radius,
                        0,
                        math.sin(angle * 3 + radius * 0.5) * radius
                    )
                    
                    local part = self:GetClosestPart(pos)
                    if part then
                        table.insert(riftParts, part)
                        
                        -- Void color with swirling effect
                        local voidIntensity = 1 - (radius / size)
                        local tween = TweenService:Create(part,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                                Color = Color3.fromRGB(
                                    math.floor(50 * voidIntensity),
                                    math.floor(20 * voidIntensity),
                                    math.floor(100 * voidIntensity)
                                ),
                                Transparency = 0.3 + (1 - voidIntensity) * 0.4,
                                Material = Enum.Material.ForceField
                            })
                        tween:Play()
                    end
                end
            end
            
            -- Pulsing void effect
            task.spawn(function()
                for pulse = 1, 20 do
                    for i, part in ipairs(riftParts) do
                        local distanceFromCenter = (part.Position - centerPos).Magnitude
                        local pulseDelay = distanceFromCenter * 0.02
                        
                        task.spawn(function()
                            task.wait(pulseDelay)
                            
                            local pulseTween = TweenService:Create(part,
                                TweenInfo.new(0.2, Enum.EasingStyle.Elastic), {
                                    Size = Vector3.new(4.5, 0.1, 4.5)
                                })
                            pulseTween:Play()
                            
                            task.wait(0.2)
                            
                            local resetTween = TweenService:Create(part,
                                TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                                    Size = Vector3.new(4, 0.2, 4)
                                })
                            resetTween:Play()
                        end)
                    end
                    
                    task.wait(0.5)
                end
            end)
        end,
        
        -- 🔥 PHOENIX REBIRTH - Complex fire and ash cycle
        phoenixRebirth = function(centerPos)
            -- Phase 1: Ashes gathering
            local ashRadius = 20
            for angle = 0, math.pi * 2, 0.2 do
                for radius = 5, ashRadius do
                    task.spawn(function()
                        local pos = centerPos + Vector3.new(
                            math.cos(angle) * radius,
                            0,
                            math.sin(angle) * radius
                        )
                        
                        local part = self:GetClosestPart(pos)
                        if part then
                            local delay = radius * 0.05
                            task.wait(delay)
                            
                            -- Ashes swirling inward
                            local tween = TweenService:Create(part,
                                TweenInfo.new(2, Enum.EasingStyle.Quart), {
                                    Color = Color3.fromRGB(105, 105, 105),
                                    Material = Enum.Material.Concrete
                                })
                            tween:Play()
                        end
                    end)
                end
            end
            
            task.wait(3)
            
            -- Phase 2: Phoenix ignition
            local ignitionColors = {
                Color3.fromRGB(255, 140, 0),  -- Orange
                Color3.fromRGB(255, 69, 0),   -- Red-Orange
                Color3.fromRGB(255, 0, 0),    -- Red
                Color3.fromRGB(255, 215, 0)   -- Gold
            }
            
            for wave = 1, 4 do
                task.spawn(function()
                    for radius = 1, 15 do
                        for angle = 0, math.pi * 2, 0.3 do
                            local waveAngle = angle + wave * math.pi * 0.5
                            local pos = centerPos + Vector3.new(
                                math.cos(waveAngle) * radius,
                                0,
                                math.sin(waveAngle) * radius
                            )
                            
                            local part = self:GetClosestPart(pos)
                            if part then
                                local colorIndex = ((wave - 1) % #ignitionColors) + 1
                                local height = 0.2 + math.sin(radius * 0.5) * 2
                                
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.2, Enum.EasingStyle.Elastic), {
                                        Color = ignitionColors[colorIndex],
                                        Size = Vector3.new(4, height, 4),
                                        Material = Enum.Material.Neon
                                    })
                                tween:Play()
                            end
                        end
                        
                        task.wait(0.1)
                    end
                end)
                
                task.wait(0.3)
            end
        end,
        
        -- 🌊 TIDAL WAVE - Realistic wave physics simulation
        tidalWave = function(originPos, direction, strength)
            local waveLength = 30
            local amplitude = 5
            local frequency = 0.5
            
            for frame = 1, 100 do
                local time = frame * 0.1
                
                -- Calculate wave front position
                local waveCenter = originPos + direction * (time * 20)
                
                for x = -20, 20 do
                    for z = -20, 20 do
                        local pos = waveCenter + Vector3.new(x, 0, z)
                        local part = self:GetClosestPart(pos)
                        
                        if part then
                            -- Distance from wave center line
                            local distanceFromLine = math.abs((pos - waveCenter):Cross(direction).Magnitude)
                            
                            -- Wave equation
                            local waveHeight = amplitude * math.sin(frequency * time - distanceFromLine * 0.2) * 
                                             math.exp(-distanceFromLine * 0.1) * strength
                            
                            if waveHeight > 0.1 then
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                                        Color = Color3.fromRGB(
                                            64 + waveHeight * 20,
                                            164 + waveHeight * 30,
                                            223 + waveHeight * 20
                                        ),
                                        Size = Vector3.new(4, 0.2 + waveHeight, 4),
                                        Material = Enum.Material.Neon
                                    })
                                tween:Play()
                            end
                        end
                    end
                end
                
                task.wait(0.1)
            end
        end
    }
end

-- 🔥 EXTREME PERFORMANCE PATTERNS - CPU-Intensive! ⚠️
function SandGuardian:InitializeExtremePatterns()
    self.extremePatterns = {
        
        -- 🌌 PARTICLE SIMULATION - Physik-Engine auf Floor
        particleSimulation = function(centerPos, particleCount)
            local particles = {}
            
            -- Initialisiere Partikel mit zufälligen Positionen und Geschwindigkeiten
            for i = 1, particleCount do
                local angle = math.random() * math.pi * 2
                local distance = math.random(5, 20)
                
                table.insert(particles, {
                    position = centerPos + Vector3.new(
                        math.cos(angle) * distance,
                        0,
                        math.sin(angle) * distance
                    ),
                    velocity = Vector3.new(
                        math.random(-5, 5),
                        0,
                        math.random(-5, 5)
                    ),
                    life = math.random(50, 150),
                    color = Color3.fromHSV(math.random(), 0.8, 1)
                })
            end
            
            -- Physik-Simulation
            task.spawn(function()
                for frame = 1, 200 do
                    for i, particle in ipairs(particles) do
                        if particle.life > 0 then
                            -- Gravitation zu Zentrum
                            local gravityForce = (centerPos - particle.position).Unit * 0.2
                            particle.velocity = particle.velocity + gravityForce
                            
                            -- Inter-Partikel Kräfte
                            for j, otherParticle in ipairs(particles) do
                                if i ~= j and otherParticle.life > 0 then
                                    local distance = (otherParticle.position - particle.position).Magnitude
                                    if distance < 8 and distance > 0 then
                                        -- Abstoßung bei zu naher Distanz
                                        local repulsion = (particle.position - otherParticle.position).Unit * (8 - distance) * 0.1
                                        particle.velocity = particle.velocity + repulsion
                                    end
                                end
                            end
                            
                            -- Position update
                            particle.position = particle.position + particle.velocity * 0.1
                            particle.velocity = particle.velocity * 0.98 -- Dämpfung
                            particle.life = particle.life - 1
                            
                            -- Visual update
                            local part = self:GetClosestPart(particle.position)
                            if part then
                                local alpha = particle.life / 150
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                                        Color = particle.color:lerp(Color3.fromRGB(0, 0, 0), 1 - alpha),
                                        Size = Vector3.new(4, 0.2 + alpha * 2, 4),
                                        Transparency = 1 - alpha
                                    })
                                tween:Play()
                            end
                        end
                    end
                    
                    task.wait(0.05)
                end
            end)
        end,
        
        -- 🧬 DNA HELIX - Doppelhelix Animation
        dnaHelix = function(startPos, endPos, rotationSpeed)
            local helixLength = (endPos - startPos).Magnitude
            local steps = math.floor(helixLength * 2)
            
            task.spawn(function()
                for revolution = 1, 10 do
                    for step = 0, steps do
                        local progress = step / steps
                        local basePos = startPos:lerp(endPos, progress)
                        
                        -- Doppelte Helix
                        for helix = 1, 2 do
                            local angle = progress * math.pi * 8 + revolution * rotationSpeed + (helix - 1) * math.pi
                            local radius = 8
                            
                            local helixPos = basePos + Vector3.new(
                                math.cos(angle) * radius,
                                0,
                                math.sin(angle) * radius
                            )
                            
                            local part = self:GetClosestPart(helixPos)
                            if part then
                                local color = (helix == 1) and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 20, 147)
                                
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                                        Color = color,
                                        Size = Vector3.new(3, 1, 3),
                                        Material = Enum.Material.Neon
                                    })
                                tween:Play()
                                
                                -- Verbindungsstreben zwischen den Helices
                                if step % 4 == 0 then
                                    local otherAngle = angle + math.pi
                                    local otherHelixPos = basePos + Vector3.new(
                                        math.cos(otherAngle) * radius,
                                        0,
                                        math.sin(otherAngle) * radius
                                    )
                                    
                                    -- Interpolierte Punkte für Verbindung
                                    for connection = 1, 3 do
                                        local connectionProgress = connection / 4
                                        local connectionPos = helixPos:lerp(otherHelixPos, connectionProgress)
                                        local connectionPart = self:GetClosestPart(connectionPos)
                                        
                                        if connectionPart then
                                            local connectionTween = TweenService:Create(connectionPart,
                                                TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                                                    Color = Color3.fromRGB(255, 255, 255),
                                                    Size = Vector3.new(2, 0.5, 2),
                                                    Material = Enum.Material.Neon
                                                })
                                            connectionTween:Play()
                                        end
                                    end
                                end
                            end
                        end
                        
                        task.wait(0.02)
                    end
                end
            end)
        end,
        
        -- 🌋 MANDELBROT FRACTAL - Mathematisches Chaos
        mandelbrotFractal = function(centerPos, zoom, iterations)
            local size = 40
            
            task.spawn(function()
                for x = -size, size do
                    for z = -size, size do
                        task.spawn(function()
                            -- Mandelbrot Berechnung
                            local real = (x / size) * 2 / zoom
                            local imag = (z / size) * 2 / zoom
                            
                            local zReal, zImag = 0, 0
                            local iteration = 0
                            
                            while iteration < iterations and (zReal * zReal + zImag * zImag) < 4 do
                                local newReal = zReal * zReal - zImag * zImag + real
                                local newImag = 2 * zReal * zImag + imag
                                zReal, zImag = newReal, newImag
                                iteration = iteration + 1
                            end
                            
                            -- Farbberechnung basierend auf Iteration
                            local color
                            if iteration == iterations then
                                color = Color3.fromRGB(0, 0, 0) -- Schwarz für Menge
                            else
                                local hue = (iteration / iterations) * 360
                                color = Color3.fromHSV(hue / 360, 1, 1)
                            end
                            
                            local worldPos = centerPos + Vector3.new(x, 0, z)
                            local part = self:GetClosestPart(worldPos)
                            
                            if part then
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                                        Color = color,
                                        Size = Vector3.new(4, 0.2 + (iteration / iterations) * 3, 4),
                                        Material = Enum.Material.Neon
                                    })
                                tween:Play()
                            end
                        end)
                    end
                end
            end)
        end,
        
        -- 🌊 FLUID SIMULATION - Wasser-Physik
        fluidSimulation = function(centerPos, dropletCount)
            local droplets = {}
            
            -- Initialisiere Wassertropfen
            for i = 1, dropletCount do
                table.insert(droplets, {
                    position = centerPos + Vector3.new(
                        math.random(-10, 10),
                        0,
                        math.random(-10, 10)
                    ),
                    velocity = Vector3.new(0, 0, 0),
                    pressure = 0,
                    density = 1
                })
            end
            
            task.spawn(function()
                for frame = 1, 300 do
                    -- Berechne Dichte und Druck für jeden Tropfen
                    for i, droplet in ipairs(droplets) do
                        droplet.density = 0
                        
                        for j, otherDroplet in ipairs(droplets) do
                            local distance = (droplet.position - otherDroplet.position).Magnitude
                            if distance < 5 then
                                -- Smoothing Kernel für Dichte
                                local influence = math.max(0, (5 - distance) / 5)
                                droplet.density = droplet.density + influence * influence
                            end
                        end
                        
                        droplet.pressure = math.max(0, droplet.density - 1) * 0.5
                    end
                    
                    -- Berechne Kräfte und update Positionen
                    for i, droplet in ipairs(droplets) do
                        local force = Vector3.new(0, 0, 0)
                        
                        for j, otherDroplet in ipairs(droplets) do
                            if i ~= j then
                                local distance = (droplet.position - otherDroplet.position).Magnitude
                                if distance < 5 and distance > 0 then
                                    local direction = (droplet.position - otherDroplet.position).Unit
                                    
                                    -- Druckkraft
                                    local pressureForce = direction * (droplet.pressure + otherDroplet.pressure) * 0.1
                                    force = force + pressureForce
                                    
                                    -- Viskosität
                                    local velocityDiff = otherDroplet.velocity - droplet.velocity
                                    local viscosityForce = velocityDiff * 0.05
                                    force = force + viscosityForce
                                end
                            end
                        end
                        
                        -- Gravitation
                        force = force + Vector3.new(0, -0.1, 0)
                        
                        -- Update Geschwindigkeit und Position
                        droplet.velocity = droplet.velocity + force * 0.1
                        droplet.velocity = droplet.velocity * 0.95 -- Dämpfung
                        droplet.position = droplet.position + droplet.velocity * 0.1
                        
                        -- Visualisierung
                        local part = self:GetClosestPart(droplet.position)
                        if part then
                            local intensity = math.min(droplet.density, 2) / 2
                            local tween = TweenService:Create(part,
                                TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                                    Color = Color3.fromRGB(
                                        math.floor(64 * intensity),
                                        math.floor(164 * intensity),
                                        math.floor(223)
                                    ),
                                    Size = Vector3.new(4, 0.2 + intensity * 1.5, 4),
                                    Transparency = math.max(0, 1 - intensity)
                                })
                            tween:Play()
                        end
                    end
                    
                    task.wait(0.05)
                end
            end)
        end
    }
end

-- 🏰 ULTIMATE SAND WALL SYSTEM - Gaara's Finest Defense! ⚡
function SandGuardian:InitializeUltimateSandWalls()
    self.ultimateWalls = {
        
        -- 🏰 FORTRESS WALL - Massive defensive structure
        fortressWall = function(centerPos, direction, length, height)
            local wallParts = {}
            local baseWidth = 6
            
            -- Main wall structure
            for i = 0, length do
                for layer = 1, height do
                    for width = -baseWidth/2, baseWidth/2 do
                        local wallPos = centerPos + 
                                      direction * i + 
                                      direction:Cross(Vector3.new(0, 1, 0)).Unit * width +
                                      Vector3.new(0, layer * 2, 0)
                        
                        local part = self:GetClosestPart(wallPos)
                        if part then
                            table.insert(wallParts, {part = part, layer = layer, position = i})
                            
                            -- Staggered rising animation
                            task.spawn(function()
                                local delay = (i + math.abs(width)) * 0.05 + layer * 0.1
                                task.wait(delay)
                                
                                local fortressColor = Color3.fromRGB(139, 69, 19):lerp(
                                    Color3.fromRGB(160, 82, 45), layer / height)
                                
                                local tween = TweenService:Create(part,
                                    TweenInfo.new(0.3 + layer * 0.1, Enum.EasingStyle.Quart), {
                                        Color = fortressColor,
                                        Size = Vector3.new(4, 2 + layer * 0.5, 4),
                                        Material = Enum.Material.Rock
                                    })
                                tween:Play()
                            end)
                        end
                    end
                end
            end
            
            -- Defensive spikes on top
            task.wait(2)
            for i = 0, length, 3 do
                local spikePos = centerPos + direction * i + Vector3.new(0, height * 2 + 1, 0)
                local spikePart = self:GetClosestPart(spikePos)
                
                if spikePart then
                    local spikeTween = TweenService:Create(spikePart,
                        TweenInfo.new(0.2, Enum.EasingStyle.Elastic), {
                            Color = Color3.fromRGB(105, 105, 105),
                            Size = Vector3.new(2, 4, 2),
                            Material = Enum.Material.Metal
                        })
                    spikeTween:Play()
                end
            end
            
            return wallParts
        end,
        
        -- 🌀 SPIRAL TOWER WALL - Rotating defensive tower
        spiralTower = function(centerPos, height, radius)
            local towerParts = {}
            
            for level = 1, height do
                local levelRadius = radius * (1 - level / (height * 2))
                local angleOffset = level * 0.3 -- Spiral effect
                
                for angle = 0, math.pi * 2, 0.2 do
                    local spiralAngle = angle + angleOffset
                    local pos = centerPos + Vector3.new(
                        math.cos(spiralAngle) * levelRadius,
                        level * 2,
                        math.sin(spiralAngle) * levelRadius
                    )
                    
                    local part = self:GetClosestPart(pos)
                    if part then
                        table.insert(towerParts, {part = part, level = level, angle = spiralAngle})
                        
                        task.spawn(function()
                            local delay = level * 0.1 + angle * 0.05
                            task.wait(delay)
                            
                            local levelIntensity = 1 - (level / height) * 0.5
                            local towerColor = Color3.fromRGB(
                                math.floor(194 * levelIntensity),
                                math.floor(178 * levelIntensity),
                                math.floor(128 + level * 10)
                            )
                            
                            local tween = TweenService:Create(part,
                                TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                                    Color = towerColor,
                                    Size = Vector3.new(3, 1.5, 3),
                                    Material = Enum.Material.Neon
                                })
                            tween:Play()
                        end)
                    end
                end
            end
            
            -- Rotating energy field around tower
            task.spawn(function()
                for rotation = 1, 100 do
                    for _, partData in ipairs(towerParts) do
                        if partData.level % 3 == 0 then -- Every 3rd level glows
                            local glowIntensity = 0.5 + 0.5 * math.sin(rotation * 0.2 + partData.angle)
                            
                            local glowTween = TweenService:Create(partData.part,
                                TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                                    Transparency = 1 - glowIntensity,
                                    Size = Vector3.new(3 + glowIntensity, 1.5, 3 + glowIntensity)
                                })
                            glowTween:Play()
                        end
                    end
                    
                    task.wait(0.1)
                end
            end)
            
            return towerParts
        end,
        
        -- ⚔️ BLADE WALL - Sharp cutting sand blades
        bladeWall = function(startPos, endPos, bladeCount)
            local direction = (endPos - startPos).Unit
            local wallLength = (endPos - startPos).Magnitude
            local bladeSpacing = wallLength / bladeCount
            
            for blade = 1, bladeCount do
                task.spawn(function()
                    local bladeCenter = startPos + direction * (blade * bladeSpacing)
                    local bladeDelay = blade * 0.1
                    
                    task.wait(bladeDelay)
                    
                    -- Create blade shape
                    for height = 1, 8 do
                        for width = -2, 2 do
                            -- Blade gets thinner towards top
                            local bladeWidth = math.max(1, 3 - height * 0.3)
                            
                            if math.abs(width) <= bladeWidth then
                                local bladePos = bladeCenter + 
                                               Vector3.new(0, height, 0) +
                                               direction:Cross(Vector3.new(0, 1, 0)).Unit * width
                                
                                local part = self:GetClosestPart(bladePos)
                                if part then
                                    local sharpness = (8 - height) / 8 -- Sharper at bottom
                                    
                                    local bladeTween = TweenService:Create(part,
                                        TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                                            Color = Color3.fromRGB(
                                                200 + sharpness * 55,
                                                200 + sharpness * 55,
                                                255
                                            ),
                                            Size = Vector3.new(
                                                2 + sharpness,
                                                1,
                                                0.5 + sharpness * 0.5
                                            ),
                                            Material = Enum.Material.Ice
                                        })
                                    bladeTween:Play()
                                end
                            end
                        end
                    end
                    
                    -- Cutting effect animation
                    task.wait(1)
                    for swipe = 1, 3 do
                        for height = 1, 8 do
                            local swipePos = bladeCenter + Vector3.new(0, height, 0)
                            local part = self:GetClosestPart(swipePos)
                            
                            if part then
                                local swipeTween = TweenService:Create(part,
                                    TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                                        Color = Color3.fromRGB(255, 255, 255),
                                        Transparency = 0.3
                                    })
                                swipeTween:Play()
                                
                                task.wait(0.05)
                                
                                local resetTween = TweenService:Create(part,
                                    TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                        Color = Color3.fromRGB(200, 200, 255),
                                        Transparency = 0
                                    })
                                resetTween:Play()
                            end
                        end
                        
                        task.wait(0.3)
                    end
                end)
            end
        end,
        
        -- 🌊 WAVE WALL - Undulating defensive barrier
        waveWall = function(centerPos, direction, length, amplitude, frequency)
            local wallParts = {}
            
            for i = 0, length * 2 do
                local position = i / 2
                local waveHeight = amplitude * math.sin(position * frequency)
                
                for height = 0, math.max(3, 3 + waveHeight) do
                    local wallPos = centerPos + 
                                  direction * position + 
                                  Vector3.new(0, height, 0)
                    
                    local part = self:GetClosestPart(wallPos)
                    if part then
                        table.insert(wallParts, {part = part, position = position, waveHeight = waveHeight})
                        
                        task.spawn(function()
                            local delay = position * 0.05
                            task.wait(delay)
                            
                            local waveColor = Color3.fromRGB(
                                64 + waveHeight * 20,
                                164 + waveHeight * 30,
                                223 + waveHeight * 20
                            )
                            
                            local tween = TweenService:Create(part,
                                TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                                    Color = waveColor,
                                    Size = Vector3.new(4, 1 + math.abs(waveHeight) * 0.5, 4),
                                    Material = Enum.Material.Neon
                                })
                            tween:Play()
                        end)
                    end
                end
            end
            
            -- Animated wave motion
            task.spawn(function()
                for frame = 1, 100 do
                    local time = frame * 0.1
                    
                    for _, partData in ipairs(wallParts) do
                        local dynamicWave = amplitude * math.sin(partData.position * frequency + time * 2)
                        local waveIntensity = (dynamicWave + amplitude) / (amplitude * 2)
                        
                        local motionTween = TweenService:Create(partData.part,
                            TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                                Transparency = 1 - waveIntensity,
                                Size = Vector3.new(4, 1 + waveIntensity * 2, 4)
                            })
                        motionTween:Play()
                    end
                    
                    task.wait(0.1)
                end
            end)
            
            return wallParts
        end
    }
end

-- 🏯 ULTIMATE SAND FORTRESS - Maximum Defense!
function SandGuardian:CreateUltimateSandFortress(centerPos)
    print("🏯 ULTIMATE SAND FORTRESS - Gaara's Supreme Defense!")
    
    if not self.ultimateWalls then
        self:InitializeUltimateSandWalls()
    end
    
    -- Multiple wall types in formation
    local directions = {
        Vector3.new(1, 0, 0),   -- East
        Vector3.new(0, 0, 1),   -- North
        Vector3.new(-1, 0, 0),  -- West
        Vector3.new(0, 0, -1)   -- South
    }
    
    -- 1. Outer Fortress Walls
    for i, direction in ipairs(directions) do
        task.spawn(function()
            local wallStart = centerPos + direction * 20
            self.ultimateWalls.fortressWall(wallStart, direction:Cross(Vector3.new(0, 1, 0)).Unit, 15, 4)
        end)
        task.wait(0.5)
    end
    
    task.wait(2)
    
    -- 2. Corner Spiral Towers
    for i, direction in ipairs(directions) do
        task.spawn(function()
            local towerPos = centerPos + direction * 25 + directions[(i % 4) + 1] * 10
            self.ultimateWalls.spiralTower(towerPos, 8, 6)
        end)
        task.wait(0.3)
    end
    
    task.wait(3)
    
    -- 3. Inner Blade Wall Ring
    for angle = 0, math.pi * 2, math.pi / 8 do
        task.spawn(function()
            local bladeDirection = Vector3.new(math.cos(angle), 0, math.sin(angle))
            local innerStart = centerPos + bladeDirection * 12
            local innerEnd = centerPos + bladeDirection * 18
            
            self.ultimateWalls.bladeWall(innerStart, innerEnd, 3)
        end)
        task.wait(0.2)
    end
    
    task.wait(2)
    
    -- 4. Dynamic Wave Barriers
    for i, direction in ipairs(directions) do
        task.spawn(function()
            local waveCenter = centerPos + direction * 8
            self.ultimateWalls.waveWall(waveCenter, direction:Cross(Vector3.new(0, 1, 0)).Unit, 12, 2, 0.5)
        end)
        task.wait(0.4)
    end
    
    -- 5. Central Tower (Ultimate Defense Core)
    task.wait(3)
    task.spawn(function()
        self.ultimateWalls.spiralTower(centerPos, 12, 4)
    end)
    
    print("🌟 Ultimate Sand Fortress Complete! Absolute Protection Achieved!")
end

-- 🎯 Quick Ultimate Wall Commands
function SandGuardian:QuickFortressWall()
    local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
    local direction = self.protectedPlayer.Character.HumanoidRootPart.CFrame.LookVector
    
    if not self.ultimateWalls then
        self:InitializeUltimateSandWalls()
    end
    
    self.ultimateWalls.fortressWall(playerPos + direction * 5, direction:Cross(Vector3.new(0, 1, 0)).Unit, 20, 5)
end

function SandGuardian:QuickSpiralTower()
    local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
    
    if not self.ultimateWalls then
        self:InitializeUltimateSandWalls()
    end
    
    self.ultimateWalls.spiralTower(playerPos + Vector3.new(10, 0, 0), 10, 8)
end

function SandGuardian:QuickBladeWall()
    local playerPos = self.protectedPlayer.Character.HumanoidRootPart.Position
    local direction = self.protectedPlayer.Character.HumanoidRootPart.CFrame.LookVector
    
    if not self.ultimateWalls then
        self:InitializeUltimateSandWalls()
    end
    
    local startPos = playerPos + direction * 8
    local endPos = startPos + direction:Cross(Vector3.new(0, 1, 0)).Unit * 15
    
    self.ultimateWalls.bladeWall(startPos, endPos, 5)
end

-- 🎮 Aktivierungs-Commands für Player
function SandGuardian:SetupPlayerCommands()
    local player = self.protectedPlayer
    
    -- Chat-Commands für Effekte
    if player.Chatted then
        player.Chatted:Connect(function(message)
            local command = string.lower(message)
            
            if command == "/tornado" then
                if self.advancedAnimations then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    self.advancedAnimations.tornadoVortex(playerPos, 1)
                end
                
            elseif command == "/lightning" then
                if self.advancedAnimations then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    local endPos = playerPos + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20))
                    self.advancedAnimations.lightningFractal(playerPos, endPos, 5, 1)
                end
                
            elseif command == "/rift" then
                if self.advancedAnimations then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    self.advancedAnimations.dimensionalRift(playerPos, 15)
                end
                
            elseif command == "/phoenix" then
                if self.advancedAnimations then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    self.advancedAnimations.phoenixRebirth(playerPos)
                end
                
            elseif command == "/wave" then
                if self.advancedAnimations then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    local direction = player.Character.HumanoidRootPart.CFrame.LookVector
                    self.advancedAnimations.tidalWave(playerPos, direction, 1)
                end
                
            elseif command == "/ultimate" then
                self:ActivateUltimateShowcase()
                
            elseif command == "/reality" then
                local playerPos = player.Character.HumanoidRootPart.Position
                self:CreateRealityBendingFinale(playerPos)
                
            -- EXTREME PATTERNS - WARNING: Performance intensive!
            elseif command == "/particles" then
                if not self.extremePatterns then
                    self:InitializeExtremePatterns()
                end
                local playerPos = player.Character.HumanoidRootPart.Position
                self.extremePatterns.particleSimulation(playerPos, 50)
                
            elseif command == "/dna" then
                if not self.extremePatterns then
                    self:InitializeExtremePatterns()
                end
                local playerPos = player.Character.HumanoidRootPart.Position
                local direction = player.Character.HumanoidRootPart.CFrame.LookVector
                self.extremePatterns.dnaHelix(
                    playerPos,
                    playerPos + direction * 30,
                    0.3
                )
                
            elseif command == "/fractal" then
                if not self.extremePatterns then
                    self:InitializeExtremePatterns()
                end
                local playerPos = player.Character.HumanoidRootPart.Position
                self.extremePatterns.mandelbrotFractal(playerPos, 1.5, 80)
                
            elseif command == "/fluid" then
                if not self.extremePatterns then
                    self:InitializeExtremePatterns()
                end
                local playerPos = player.Character.HumanoidRootPart.Position
                self.extremePatterns.fluidSimulation(playerPos, 40)
                
            elseif command == "/stress" then
                self:ActivateSystemStressTest()
                
            -- ULTIMATE SAND WALLS
            elseif command == "/fortress" or command == "/sandmauer" then
                self:QuickFortressWall()
                
            elseif command == "/tower" or command == "/turm" then
                self:QuickSpiralTower()
                
            elseif command == "/blades" or command == "/klingen" then
                self:QuickBladeWall()
                
            elseif command == "/ultimatefortress" or command == "/sandburg" then
                local playerPos = player.Character.HumanoidRootPart.Position
                self:CreateUltimateSandFortress(playerPos)
                
            elseif command == "/help" then
                print("🎮 SAND GUARDIAN COMMANDS:")
                print("Basic: /tornado, /lightning, /rift, /phoenix, /wave")
                print("Advanced: /ultimate, /reality")
                print("🏰 Walls: /fortress (/sandmauer), /tower (/turm), /blades (/klingen)")
                print("🏯 Ultimate: /ultimatefortress (/sandburg)")
                print("Extreme: /particles, /dna, /fractal, /fluid")
                print("⚠️ WARNING: /stress - All effects at once!")
            end
        end)
    end
end

return SandGuardian
