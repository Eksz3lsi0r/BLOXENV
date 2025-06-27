-- PATTERN TESTER - Teste alle verrückten Muster! 🎨✨
-- Verwende dieses Script um verschiedene Muster auszuprobieren

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Module laden
local FloorAnimator = require(game.ReplicatedStorage.Assets.Modules.FloorAnimator)
local PatternLibrary = require(game.ReplicatedStorage.Assets.Modules.PatternLibrary)
local CrazyPatterns = require(game.ReplicatedStorage.Assets.Modules.CrazyPatterns)

local PatternTester = {}
PatternTester.__index = PatternTester

function PatternTester.new(floorSegments)
    local self = setmetatable({}, PatternTester)
    
    -- FloorAnimator initialisieren
    self.floorAnimator = FloorAnimator.new(floorSegments, 48)
    
    -- Aktuelle Pattern-Kategorie
    self.currentCategory = "crazy" -- "wizard", "crazy", "performance"
    self.currentPatternIndex = 1
    
    -- Pattern Listen
    self.patterns = {
        crazy = {
            "RainbowSpiral",
            "ElectricCage", 
            "FireIceVortex",
            "TsunamiWave",
            "CherryBlossomStorm",
            "FireworksExplosion",
            "GalaxySpiral"
        },
        wizard = {
            "FireballTrail",
            "IceExplosion", 
            "LightningStorm",
            "DefensiveCircle",
            "MeteorImpact",
            "HealWave",
            "TeleportEffect",
            "ComboAttack",
            "BossDefeatPattern"
        },
        performance = {
            "LODExplosion",
            "BatchedAreaEffect",
            "SimplifiedTrail"
        }
    }
    
    -- UI Info
    self.currentPattern = self.patterns[self.currentCategory][self.currentPatternIndex]
    
    -- Input Handling
    self:SetupInputs()
    
    -- Info anzeigen
    self:ShowInfo()
    
    return self
end

function PatternTester:SetupInputs()
    -- TASTATUR CONTROLS:
    -- SPACE = Aktuelles Pattern ausführen
    -- Q/E = Pattern wechseln  
    -- 1/2/3 = Kategorie wechseln (1=Crazy, 2=Wizard, 3=Performance)
    -- R = Feld zurücksetzen
    -- T = Zufälliges Pattern
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local player = Players.LocalPlayer
        if not player.Character then return end
        
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Position des Spielers als Zentrum verwenden
        local position = humanoidRootPart.Position
        local centerX = math.floor(position.X / 4) + 24 -- Zu Grid-Koordinaten
        local centerZ = math.floor(position.Z / 4) + 24
        
        -- Grenzen prüfen
        centerX = math.max(5, math.min(43, centerX))
        centerZ = math.max(5, math.min(43, centerZ))
        
        if input.KeyCode == Enum.KeyCode.Space then
            -- Aktuelles Pattern ausführen
            self:ExecuteCurrentPattern(centerX, centerZ)
            
        elseif input.KeyCode == Enum.KeyCode.Q then
            -- Vorheriges Pattern
            self:PreviousPattern()
            
        elseif input.KeyCode == Enum.KeyCode.E then
            -- Nächstes Pattern
            self:NextPattern()
            
        elseif input.KeyCode == Enum.KeyCode.One then
            -- Crazy Patterns
            self:SwitchCategory("crazy")
            
        elseif input.KeyCode == Enum.KeyCode.Two then
            -- Wizard Patterns  
            self:SwitchCategory("wizard")
            
        elseif input.KeyCode == Enum.KeyCode.Three then
            -- Performance Patterns
            self:SwitchCategory("performance")
            
        elseif input.KeyCode == Enum.KeyCode.R then
            -- Feld zurücksetzen
            self:ResetFloor()
            
        elseif input.KeyCode == Enum.KeyCode.T then
            -- Zufälliges Pattern
            self:RandomPattern(centerX, centerZ)
            
        elseif input.KeyCode == Enum.KeyCode.G then
            -- Galaxy Demo (alle verrückten Patterns nacheinander)
            self:GalaxyDemo(centerX, centerZ)
            
        elseif input.KeyCode == Enum.KeyCode.F then
            -- Fireworks Show (mehrere Feuerwerke)
            self:FireworksShow()
        end
    end)
end

function PatternTester:ExecuteCurrentPattern(centerX, centerZ)
    print("🎨 Executing: " .. self.currentPattern .. " at (" .. centerX .. ", " .. centerZ .. ")")
    
    if self.currentCategory == "crazy" then
        local pattern = CrazyPatterns.WildPatterns[self.currentPattern]
        if pattern then
            if self.currentPattern == "RainbowSpiral" then
                pattern(self.floorAnimator, centerX, centerZ, 1)
            elseif self.currentPattern == "ElectricCage" then
                pattern(self.floorAnimator, centerX, centerZ, 12)
            elseif self.currentPattern == "TsunamiWave" then
                -- Zufällige Richtung
                local directions = {
                    Vector3.new(1, 0, 0),   -- Links nach Rechts
                    Vector3.new(0, 0, 1),   -- Oben nach Unten
                    Vector3.new(-1, 0, 0),  -- Rechts nach Links
                    Vector3.new(0, 0, -1)   -- Unten nach Oben
                }
                local direction = directions[math.random(1, #directions)]
                pattern(self.floorAnimator, direction)
            elseif self.currentPattern == "CherryBlossomStorm" then
                pattern(self.floorAnimator, centerX, centerZ, 1.5)
            elseif self.currentPattern == "FireworksExplosion" then
                pattern(self.floorAnimator, centerX, centerZ, 7)
            else
                pattern(self.floorAnimator, centerX, centerZ)
            end
        end
        
    elseif self.currentCategory == "wizard" then
        local pattern = PatternLibrary.WizardHeroPatterns[self.currentPattern]
        if pattern then
            if self.currentPattern == "FireballTrail" then
                local direction = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
                pattern(self.floorAnimator, Vector3.new(centerX, 0, centerZ), direction)
            elseif self.currentPattern == "LightningStorm" then
                local positions = {}
                for i = 1, 5 do
                    table.insert(positions, Vector3.new(
                        centerX + math.random(-10, 10),
                        0,
                        centerZ + math.random(-10, 10)
                    ))
                end
                pattern(self.floorAnimator, positions)
            elseif self.currentPattern == "DefensiveCircle" then
                pattern(self.floorAnimator, centerX, centerZ, 15)
            elseif self.currentPattern == "TeleportEffect" then
                local fromX, fromZ = centerX - 8, centerZ - 8
                local toX, toZ = centerX + 8, centerZ + 8
                pattern(self.floorAnimator, fromX, fromZ, toX, toZ)
            elseif self.currentPattern == "ComboAttack" then
                local positions = {
                    Vector3.new(centerX - 5, 0, centerZ - 5),
                    Vector3.new(centerX + 5, 0, centerZ - 5),
                    Vector3.new(centerX, 0, centerZ + 5)
                }
                local spellTypes = {"fireballImpact", "iceSpikePattern", "lightningStorm"}
                pattern(self.floorAnimator, positions, spellTypes)
            else
                pattern(self.floorAnimator, centerX, centerZ)
            end
        end
        
    elseif self.currentCategory == "performance" then
        local pattern = PatternLibrary.PerformancePatterns[self.currentPattern]
        if pattern then
            if self.currentPattern == "LODExplosion" then
                pattern(self.floorAnimator, centerX, centerZ, 25) -- Mittlere Distanz
            elseif self.currentPattern == "BatchedAreaEffect" then
                local positions = {}
                for i = 1, 50 do
                    table.insert(positions, Vector3.new(
                        centerX + math.random(-8, 8),
                        0,
                        centerZ + math.random(-8, 8)
                    ))
                end
                pattern(self.floorAnimator, positions, Color3.fromRGB(255, 100, 255), 10)
            elseif self.currentPattern == "SimplifiedTrail" then
                local startPos = Vector3.new(centerX - 15, 0, centerZ)
                local endPos = Vector3.new(centerX + 15, 0, centerZ)
                pattern(self.floorAnimator, startPos, endPos, Color3.fromRGB(100, 255, 100))
            end
        end
    end
end

function PatternTester:NextPattern()
    local patterns = self.patterns[self.currentCategory]
    self.currentPatternIndex = (self.currentPatternIndex % #patterns) + 1
    self.currentPattern = patterns[self.currentPatternIndex]
    self:ShowInfo()
end

function PatternTester:PreviousPattern()
    local patterns = self.patterns[self.currentCategory]
    self.currentPatternIndex = self.currentPatternIndex - 1
    if self.currentPatternIndex < 1 then
        self.currentPatternIndex = #patterns
    end
    self.currentPattern = patterns[self.currentPatternIndex]
    self:ShowInfo()
end

function PatternTester:SwitchCategory(category)
    if self.patterns[category] then
        self.currentCategory = category
        self.currentPatternIndex = 1
        self.currentPattern = self.patterns[category][1]
        self:ShowInfo()
    end
end

function PatternTester:RandomPattern(centerX, centerZ)
    -- Zufällige Kategorie und Pattern
    local categories = {"crazy", "wizard", "performance"}
    local randomCategory = categories[math.random(1, #categories)]
    local patterns = self.patterns[randomCategory]
    local randomPattern = patterns[math.random(1, #patterns)]
    
    print("🎲 Random Pattern: " .. randomPattern .. " from " .. randomCategory)
    
    -- Temporär wechseln und ausführen
    local oldCategory = self.currentCategory
    local oldPattern = self.currentPattern
    local oldIndex = self.currentPatternIndex
    
    self.currentCategory = randomCategory
    self.currentPattern = randomPattern
    self.currentPatternIndex = 1
    
    self:ExecuteCurrentPattern(centerX, centerZ)
    
    -- Zurück zum ursprünglichen Pattern
    self.currentCategory = oldCategory
    self.currentPattern = oldPattern
    self.currentPatternIndex = oldIndex
end

function PatternTester:GalaxyDemo(centerX, centerZ)
    print("🌌 Starting Galaxy Demo - All Crazy Patterns!")
    
    task.spawn(function()
        local patterns = self.patterns.crazy
        for i, patternName in ipairs(patterns) do
            print("🎨 Demo Step " .. i .. ": " .. patternName)
            
            local oldPattern = self.currentPattern
            self.currentPattern = patternName
            
            self:ExecuteCurrentPattern(centerX + math.random(-5, 5), centerZ + math.random(-5, 5))
            
            self.currentPattern = oldPattern
            task.wait(3) -- 3 Sekunden zwischen Patterns
        end
        
        print("✨ Galaxy Demo Complete!")
    end)
end

function PatternTester:FireworksShow()
    print("🎆 Starting Fireworks Show!")
    
    task.spawn(function()
        for i = 1, 10 do
            local x = math.random(10, 38)
            local z = math.random(10, 38)
            
            CrazyPatterns.WildPatterns.FireworksExplosion(self.floorAnimator, x, z, math.random(3, 8))
            task.wait(math.random(1, 3))
        end
        
        print("🎆 Fireworks Show Complete!")
    end)
end

function PatternTester:ResetFloor()
    print("🧹 Resetting Floor...")
    
    -- Alle aktiven Effekte stoppen
    self.floorAnimator.activeEffects = {}
    self.floorAnimator.updateQueue = {}
    
    -- Feld auf Standard-Farbe zurücksetzen
    for x = 1, 48 do
        for z = 1, 48 do
            self.floorAnimator:QueueUpdate(x, z, Color3.fromRGB(100, 100, 100), 0, nil, 0.5)
        end
        task.wait(0.01) -- Performance-freundlich
    end
end

function PatternTester:ShowInfo()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎨 PATTERN TESTER - 48x48 Floor System")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("📂 Category: " .. self.currentCategory:upper())
    print("🎯 Current: " .. self.currentPattern .. " (" .. self.currentPatternIndex .. "/" .. #self.patterns[self.currentCategory] .. ")")
    print("")
    print("🎮 CONTROLS:")
    print("  SPACE = Execute Current Pattern")
    print("  Q/E   = Previous/Next Pattern")
    print("  1/2/3 = Switch Category (Crazy/Wizard/Performance)")
    print("  R     = Reset Floor")
    print("  T     = Random Pattern")
    print("  G     = Galaxy Demo (All Crazy Patterns)")
    print("  F     = Fireworks Show")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

return PatternTester
