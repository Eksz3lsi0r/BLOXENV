-- 🎯 FLOOR SEGMENT QUICK TEST - Teste dein 48x48 Grid sofort! 🚀
-- Kopiere diesen Code in die Command Bar oder als Script

-- 🎯 TEIL 1: Dein FloorSegment finden
local function findFloorSegment()
    -- Suche nach dem FloorSegment Model
    local possibleNames = {"FloorSegment", "Floor", "FloorGrid", "Segments"}
    
    for _, name in ipairs(possibleNames) do
        local found = workspace:FindFirstChild(name)
        if found then
            print("✅ Found FloorSegment: " .. found.Name)
            return found
        end
    end
    
    -- Falls nicht gefunden, erstes Model mit vielen Parts nehmen
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            local partCount = 0
            for _, part in ipairs(child:GetDescendants()) do
                if part:IsA("BasePart") then
                    partCount = partCount + 1
                end
            end
            
            if partCount > 1000 then -- Wahrscheinlich dein Floor
                print("🎯 Auto-detected FloorSegment: " .. child.Name .. " (" .. partCount .. " parts)")
                return child
            end
        end
    end
    
    error("❌ FloorSegment not found! Make sure your 48x48 grid is in workspace.")
end

-- 🎯 TEIL 2: FloorController laden und initialisieren
local FloorController = require(script.Parent.FloorController) -- Pfad anpassen!

local floorSegment = findFloorSegment()
local controller = FloorController.new(floorSegment)

print("🚀 FloorController initialized with " .. controller.totalParts .. " parts!")

-- 🎯 TEIL 3: SOFORT-TESTS zum Ausprobieren!

-- ⚡ TEST 1: Einzelnes Segment färben
print("🎨 TEST 1: Single segment coloring...")
controller:UpdateSegment(24, 24, Color3.fromRGB(255, 0, 0), 0, nil, 1) -- Rotes Zentrum

task.wait(2)

-- ⚡ TEST 2: Wellen-Effekt
print("🌊 TEST 2: Wave effect...")
controller:CreateWaveEffect(24, 24, 15, 2, Color3.fromRGB(0, 255, 255))

task.wait(4)

-- ⚡ TEST 3: Regenbogen-Spirale
print("🌈 TEST 3: Rainbow spiral...")
controller:CreateRainbowSpiral(24, 24, 20)

task.wait(5)

-- ⚡ TEST 4: Performance-Test
print("🚀 TEST 4: Performance test...")
controller:PerformanceTestPattern()

task.wait(3)

-- 🎯 TEIL 4: INTERAKTIVE CHAT-COMMANDS
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        local args = string.split(message:lower(), " ")
        local command = args[1]
        
        if command == "/color" and #args >= 5 then
            -- /color x z r g b
            local x = tonumber(args[2])
            local z = tonumber(args[3])
            local r = tonumber(args[4])
            local g = tonumber(args[5])
            local b = tonumber(args[6]) or 0
            
            if x and z and r and g then
                controller:UpdateSegment(x, z, Color3.fromRGB(r, g, b), 0, nil, 0.5)
                print("🎨 " .. player.Name .. " colored segment (" .. x .. ", " .. z .. ")")
            end
            
        elseif command == "/wave" and #args >= 3 then
            -- /wave x z radius
            local x = tonumber(args[2]) or 24
            local z = tonumber(args[3]) or 24
            local radius = tonumber(args[4]) or 10
            
            controller:CreateWaveEffect(x, z, radius, 2, Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)))
            print("🌊 " .. player.Name .. " created wave at (" .. x .. ", " .. z .. ")")
            
        elseif command == "/rainbow" then
            controller:CreateRainbowSpiral(24, 24, 20)
            print("🌈 " .. player.Name .. " created rainbow spiral!")
            
        elseif command == "/reset" then
            -- Reset all segments
            local resetTransforms = {}
            for x = 1, 48 do
                for z = 1, 48 do
                    table.insert(resetTransforms, {
                        x = x,
                        z = z,
                        properties = {
                            Color = Color3.fromRGB(100, 100, 100),
                            Transparency = 0
                        },
                        duration = 0.5
                    })
                end
            end
            
            controller:BatchTransform(resetTransforms, 100)
            print("🧹 " .. player.Name .. " reset the floor!")
            
        elseif command == "/help" then
            print("🎮 FLOOR COMMANDS:")
            print("  /color x z r g b  - Color segment at x,z with RGB")
            print("  /wave x z radius  - Create wave at x,z")
            print("  /rainbow         - Rainbow spiral")
            print("  /reset          - Reset floor")
            print("  /performance    - Performance test")
        end
    end)
end)

-- 🎯 TEIL 5: GUI für einfache Bedienung (Optional)
local function createFloorControlGUI()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not player then return end
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloorControls"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 200)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🎨 Floor Control Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.TextScaled = true
    title.Parent = frame
    
    -- Quick Action Buttons
    local buttons = {
        {name = "🌈 Rainbow", func = function() controller:CreateRainbowSpiral(24, 24, 20) end},
        {name = "🌊 Wave", func = function() controller:CreateWaveEffect(24, 24, 15, 2, Color3.fromRGB(0, 255, 255)) end},
        {name = "🚀 Performance", func = function() controller:PerformanceTestPattern() end},
        {name = "🧹 Reset", func = function() 
            local resetTransforms = {}
            for x = 1, 48 do
                for z = 1, 48 do
                    table.insert(resetTransforms, {
                        x = x, z = z,
                        properties = {Color = Color3.fromRGB(100, 100, 100), Transparency = 0},
                        duration = 0.3
                    })
                end
            end
            controller:BatchTransform(resetTransforms, 100)
        end}
    }
    
    for i, buttonData in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.45, 0, 0, 35)
        button.Position = UDim2.new(0.05 + (i-1)%2 * 0.5, 0, 0, 40 + math.floor((i-1)/2) * 40)
        button.Text = buttonData.name
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Parent = frame
        
        button.MouseButton1Click:Connect(buttonData.func)
    end
end

-- GUI erstellen (falls LocalScript)
if game:GetService("RunService"):IsClient() then
    createFloorControlGUI()
end

print("✅ Floor Segment System ready!")
print("🎮 Try chat commands: /color 24 24 255 0 0, /wave, /rainbow, /reset")
print("📱 GUI controls available for quick testing!")

return controller
