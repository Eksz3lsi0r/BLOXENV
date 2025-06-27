-- 🎬 DEMO SCRIPT - Alle Pattern-Systeme in Aktion! 🎨
-- Kopiere diesen Code in ServerScriptService für eine komplette Demo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 🎯 SCHRITT 1: 48x48 Floor Grid erstellen
print("🔧 Creating 48x48 Floor Grid...")

local floorSegments = {}
local floorModel = Instance.new("Model")
floorModel.Name = "FloorGrid48x48"
floorModel.Parent = workspace

for x = 1, 48 do
    floorSegments[x] = {}
    for z = 1, 48 do
        local part = Instance.new("Part")
        part.Name = "FloorSegment_" .. x .. "_" .. z
        part.Size = Vector3.new(4, 0.2, 4)
        part.Position = Vector3.new(x * 4 - 96, 0, z * 4 - 96) -- Zentriert um 0,0
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(100, 100, 100)
        part.Anchored = true
        part.CanCollide = false
        part.Parent = floorModel
        
        floorSegments[x][z] = part
    end
end

print("✅ Floor Grid created! " .. (#floorSegments * #floorSegments[1]) .. " segments")

-- 🎯 SCHRITT 2: Module laden (stelle sicher, dass sie in ReplicatedStorage sind!)
local function waitForModule(path)
    local module = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Modules"):WaitForChild(path)
    return require(module)
end

local FloorAnimator = waitForModule("FloorAnimator")
local PatternLibrary = waitForModule("PatternLibrary")
local CrazyPatterns = waitForModule("CrazyPatterns")
local ExperimentalPatterns = waitForModule("ExperimentalPatterns")

print("✅ All modules loaded!")

-- 🎯 SCHRITT 3: FloorAnimator initialisieren
local floorAnimator = FloorAnimator.new(floorSegments, 48)
print("✅ FloorAnimator initialized!")

-- 🎯 SCHRITT 4: Spawn Platform für Spieler
local spawnPart = Instance.new("Part")
spawnPart.Name = "SpawnPlatform"
spawnPart.Size = Vector3.new(20, 1, 20)
spawnPart.Position = Vector3.new(0, 5, 0)
spawnPart.Material = Enum.Material.Marble
spawnPart.Color = Color3.fromRGB(200, 200, 200)
spawnPart.Anchored = true
spawnPart.Parent = workspace

-- Spawn Location
local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Size = Vector3.new(10, 1, 10)
spawnLocation.Position = Vector3.new(0, 6, 0)
spawnLocation.Material = Enum.Material.Neon
spawnLocation.BrickColor = BrickColor.new("Bright green")
spawnLocation.Anchored = true
spawnLocation.CanCollide = false
spawnLocation.Parent = workspace

print("✅ Spawn platform created!")

-- 🎯 SCHRITT 5: Demo-Patterns automatisch abspielen
local function runPatternDemo()
    print("🎬 Starting Pattern Demo Show!")
    
    local demoPatterns = {
        {
            name = "🌈 Rainbow Spiral",
            func = function()
                CrazyPatterns.WildPatterns.RainbowSpiral(floorAnimator, 24, 24, 1.2)
            end
        },
        {
            name = "⚡ Electric Cage",
            func = function()
                CrazyPatterns.WildPatterns.ElectricCage(floorAnimator, 24, 24, 16)
            end
        },
        {
            name = "🔥❄️ Fire Ice Vortex",
            func = function()
                CrazyPatterns.WildPatterns.FireIceVortex(floorAnimator, 24, 24)
            end
        },
        {
            name = "🌊 Tsunami Wave",
            func = function()
                CrazyPatterns.WildPatterns.TsunamiWave(floorAnimator, Vector3.new(1, 0, 0))
            end
        },
        {
            name = "🌸 Cherry Blossom Storm",
            func = function()
                CrazyPatterns.WildPatterns.CherryBlossomStorm(floorAnimator, 24, 24, 1.5)
            end
        },
        {
            name = "🎆 Fireworks Explosion",
            func = function()
                CrazyPatterns.WildPatterns.FireworksExplosion(floorAnimator, 24, 24, 8)
            end
        },
        {
            name = "🌌 Galaxy Spiral",
            func = function()
                CrazyPatterns.WildPatterns.GalaxySpiral(floorAnimator, 24, 24)
            end
        },
        {
            name = "🌪️ Tornado",
            func = function()
                ExperimentalPatterns.ExtremePatterns.Tornado(floorAnimator, 24, 24, 1.2)
            end
        },
        {
            name = "🌋 Volcano Eruption",
            func = function()
                ExperimentalPatterns.ExtremePatterns.VolcanoEruption(floorAnimator, 24, 24)
            end
        },
        {
            name = "⚔️ Elemental War",
            func = function()
                ExperimentalPatterns.ExtremePatterns.ElementalWar(floorAnimator, 24, 24)
            end
        }
    }
    
    -- Demo Loop
    while true do
        for i, pattern in ipairs(demoPatterns) do
            print("🎨 Demo " .. i .. "/10: " .. pattern.name)
            
            -- Reset Floor
            task.spawn(function()
                for x = 1, 48 do
                    for z = 1, 48 do
                        floorAnimator:QueueUpdate(x, z, Color3.fromRGB(100, 100, 100), 0, nil, 0.3)
                    end
                    task.wait(0.01)
                end
            end)
            
            task.wait(2) -- Warten bis Reset fertig
            
            -- Pattern ausführen
            task.spawn(pattern.func)
            
            task.wait(8) -- 8 Sekunden pro Pattern
        end
        
        print("🔄 Demo Loop completed! Restarting...")
        task.wait(3)
    end
end

-- 🎯 SCHRITT 6: Spieler-Event Setup für interaktive Tests
local function setupPlayerEvents()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            task.wait(1) -- Warten bis Character geladen
            
            print("👋 Player " .. player.Name .. " joined! Starting Pattern Tester...")
            
            -- PatternTester für den Spieler erstellen
            task.spawn(function()
                local PatternTester = require(ReplicatedStorage:WaitForChild("PatternTester"))
                local tester = PatternTester.new(floorSegments)
                
                print("🎮 Pattern Tester ready for " .. player.Name)
                print("🎯 Use SPACE, Q/E, 1/2/3, R, T, G, F keys to control patterns!")
            end)
        end)
    end)
end

-- 🎯 SCHRITT 7: Performance Monitor
local function setupPerformanceMonitor()
    local lastUpdate = tick()
    local frameCount = 0
    
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        
        if tick() - lastUpdate >= 5 then -- Alle 5 Sekunden
            local fps = frameCount / 5
            local queueSize = #floorAnimator.updateQueue
            local activeEffects = #floorAnimator.activeEffects
            
            print("📊 Performance: " .. math.floor(fps) .. " FPS | Queue: " .. queueSize .. " | Effects: " .. activeEffects)
            
            -- Auto-Optimierung
            if fps < 30 then
                floorAnimator.batchSize = math.max(20, floorAnimator.batchSize - 5)
                print("⚡ Reduced batch size to " .. floorAnimator.batchSize .. " for better performance")
            elseif fps > 50 and queueSize < 100 then
                floorAnimator.batchSize = math.min(75, floorAnimator.batchSize + 5)
                print("🚀 Increased batch size to " .. floorAnimator.batchSize)
            end
            
            frameCount = 0
            lastUpdate = tick()
        end
    end)
end

-- 🎯 SCHRITT 8: Chat Commands für Admin-Tests
local function setupChatCommands()
    Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            local args = string.split(message:lower(), " ")
            local command = args[1]
            
            if command == "/pattern" and #args >= 2 then
                local patternName = args[2]
                local x, z = 24, 24 -- Default center
                
                if #args >= 4 then
                    x = tonumber(args[3]) or 24
                    z = tonumber(args[4]) or 24
                end
                
                -- Pattern Commands
                if patternName == "rainbow" then
                    CrazyPatterns.WildPatterns.RainbowSpiral(floorAnimator, x, z, 1)
                elseif patternName == "fire" then
                    PatternLibrary.WizardHeroPatterns.FireballTrail(floorAnimator, Vector3.new(x*4, 0, z*4), Vector3.new(1, 0, 0))
                elseif patternName == "galaxy" then
                    CrazyPatterns.WildPatterns.GalaxySpiral(floorAnimator, x, z)
                elseif patternName == "tornado" then
                    ExperimentalPatterns.ExtremePatterns.Tornado(floorAnimator, x, z, 1)
                elseif patternName == "reset" then
                    for resetX = 1, 48 do
                        for resetZ = 1, 48 do
                            floorAnimator:QueueUpdate(resetX, resetZ, Color3.fromRGB(100, 100, 100), 0, nil, 0.2)
                        end
                    end
                end
                
                print("🎨 " .. player.Name .. " executed pattern: " .. patternName .. " at (" .. x .. ", " .. z .. ")")
            end
        end)
    end)
end

-- 🎯 SCHRITT 9: GUI für mobile Spieler (optional)
local function createMobileGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PatternControls"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(1, -210, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🎨 Pattern Controls"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Pattern Buttons
    local patterns = {"Rainbow", "Fire", "Galaxy", "Tornado", "Reset"}
    for i, patternName in ipairs(patterns) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 40)
        button.Position = UDim2.new(0.05, 0, 0, 30 + i * 45)
        button.Text = patternName
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Parent = frame
        
        button.MouseButton1Click:Connect(function()
            -- Trigger pattern via RemoteEvent (would need to be set up)
            print("📱 Mobile user clicked: " .. patternName)
        end)
    end
end

-- 🚀 ALLES STARTEN!
print("🎬 Starting Roblox Floor Pattern Demo System...")

-- Setup everything
setupPlayerEvents()
setupPerformanceMonitor()
setupChatCommands()

-- Mobile GUI für neue Spieler
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createMobileGUI(player)
    end)
end)

-- Demo nach 5 Sekunden starten
task.wait(5)
task.spawn(runPatternDemo)

print("✅ Demo System fully initialized!")
print("🎮 Players can use keyboard controls or chat commands like '/pattern rainbow 24 24'")
print("📱 Mobile players have GUI buttons")
print("🎬 Automatic demo is running in background")
print("🎯 Have fun testing your 48x48 floor patterns! 🎨")
