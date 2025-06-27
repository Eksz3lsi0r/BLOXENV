-- 🌪️ TORNADO TEST SCRIPT - Quick Demo für SandGuardian Tornado
-- Verwende dieses Script um den Tornado-Effekt schnell zu testen

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- SandGuardian laden (anpassen je nach Structure)
local SandGuardian = require(script.Parent.SandGuardian)

-- Warte auf Character
if not player.Character then
    player.CharacterAdded:Wait()
end

-- Floor Model finden oder erstellen (für Demo)
local floorModel = workspace:FindFirstChild("FloorModel")
if not floorModel then
    print("⚠️ Kein FloorModel gefunden! Erstelle Demo-Floor...")
    
    floorModel = Instance.new("Model")
    floorModel.Name = "FloorModel"
    floorModel.Parent = workspace
    
    -- Demo Floor Grid erstellen (10x10)
    for x = 1, 10 do
        for z = 1, 10 do
            local part = Instance.new("Part")
            part.Name = "FloorSegment_" .. x .. "_" .. z
            part.Size = Vector3.new(4, 0.2, 4)
            part.Position = Vector3.new(x * 4, 0, z * 4)
            part.Anchored = true
            part.Material = Enum.Material.Sand
            part.Color = Color3.fromRGB(194, 178, 128)
            part.Parent = floorModel
        end
    end
    
    print("✅ Demo-Floor erstellt!")
end

-- SandGuardian initialisieren
local sandGuardian = SandGuardian.new(floorModel, player)

print("🎮 TORNADO TEST BEREIT!")
print("📋 Verfügbare Kommandos:")
print("   - Typ '/tornado' im Chat")
print("   - Oder verwende: sandGuardian:QuickTornado()")

-- Automatischer Test nach 3 Sekunden
task.spawn(function()
    task.wait(3)
    print("🚀 Auto-Test startet in 3 Sekunden...")
    task.wait(3)
    
    print("🌪️ TORNADO TEST!")
    sandGuardian:QuickTornado()
    
    task.wait(8)
    print("⚡ LIGHTNING TEST!")
    sandGuardian:QuickLightning()
    
    task.wait(5)
    print("🌀 RIFT TEST!")
    sandGuardian:QuickRift()
    
    print("✨ Auto-Test abgeschlossen!")
end)

-- Manual trigger function
_G.TornadoTest = function()
    sandGuardian:QuickTornado()
    print("🌪️ Tornado manuell ausgelöst!")
end

_G.TestAll = function()
    sandGuardian:TestAllEffects()
    print("🎆 Alle Effekte werden getestet!")
end

print("🔧 Manuelle Trigger verfügbar:")
print("   - _G.TornadoTest() für Tornado")
print("   - _G.TestAll() für alle Effekte")
