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

return SandGuardian
