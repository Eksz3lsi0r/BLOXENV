-- Führe dies aus um sicherzustellen dass alle Module geladen sind

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modulesFolder = ReplicatedStorage:FindFirstChild("Modules")

if not modulesFolder then
    error("Modules folder not found! Create it in ReplicatedStorage")
end

-- Check for required modules
local requiredModules = {"SpellSystem", "EnemyAI"}
for _, moduleName in ipairs(requiredModules) do
    if not modulesFolder:FindFirstChild(moduleName) then
        warn("Missing module: " .. moduleName)
    end
end

-- Wenn etwas nicht funktioniert, führe dies aus

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fix 1: Stelle sicher dass RemoteEvents existieren
local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEvents then
    print("Creating RemoteEvents...")
    remoteEvents = Instance.new("Folder")
    remoteEvents.Name = "RemoteEvents"
    remoteEvents.Parent = ReplicatedStorage
    
    local castSpell = Instance.new("RemoteEvent")
    castSpell.Name = "CastSpell"
    castSpell.Parent = remoteEvents
end

-- Fix 2: Überprüfe Module
local modules = ReplicatedStorage:FindFirstChild("Modules")
if not modules then
    warn("Modules folder missing! Please create ReplicatedStorage/Modules and add SpellSystem.lua and EnemyAI.lua")
end

-- Fix 3: Spawn-Punkte
if not workspace:FindFirstChild("SpawnPoints") then
    print("Creating default spawn points...")
    local spawnFolder = Instance.new("Folder")
    spawnFolder.Name = "SpawnPoints"
    spawnFolder.Parent = workspace
    
    for i = 1, 4 do
        local spawn = Instance.new("Part")
        spawn.Name = "SpawnPoint" .. i
        spawn.Size = Vector3.new(4, 1, 4)
        spawn.Position = Vector3.new(i * 30 - 60, 5, i * 30 - 60)
        spawn.Transparency = 1
        spawn.CanCollide = false
        spawn.Anchored = true
        spawn.Parent = spawnFolder
    end
end

print("Quick fixes applied!")

local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Cleanup old effects
RunService.Heartbeat:Connect(function()
    -- Remove old spell effects
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "Projectile" or obj.Name == "Explosion" or obj.Name == "AttackEffect" then
            if obj:GetAttribute("CreatedTime") then
                if tick() - obj:GetAttribute("CreatedTime") > 10 then
                    obj:Destroy()
                end
            else
                obj:SetAttribute("CreatedTime", tick())
            end
        end
    end
end)

-- Limit enemy count
local MAX_ENEMIES = 20
RunService.Heartbeat:Connect(function()
    local enemyCount = 0
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Enemy") then
            enemyCount = enemyCount + 1
            if enemyCount > MAX_ENEMIES then
                obj:Destroy()
            end
        end
    end
end)