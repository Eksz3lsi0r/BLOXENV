local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Create RemoteEvents
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local castSpellRemote = Instance.new("RemoteEvent")
castSpellRemote.Name = "CastSpell"
castSpellRemote.Parent = remoteEvents

local damageDealtRemote = Instance.new("RemoteEvent")
damageDealtRemote.Name = "DamageDealt"
damageDealtRemote.Parent = remoteEvents

-- Load modules
local SpellSystem = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("SpellSystem"))
local spellSystem = SpellSystem.new()

-- Game state
local gameState = {
    currentWave = 1,
    score = 0,
    activePlayers = {}
}

-- Handle spell casting
castSpellRemote.OnServerEvent:Connect(function(player, spellName, targetPosition)
    if not player.Character then return end
    
    local success = spellSystem:CastSpell(player, spellName, targetPosition)
    if success then
        -- Add score for casting spell
        gameState.score = gameState.score + 10
    end
end)

-- Player management
Players.PlayerAdded:Connect(function(player)
    gameState.activePlayers[player] = {
        score = 0,
        kills = 0
    }

-- Create folder structure
local folders = {
    "Assets",
    "Assets/Enemies",
    "Assets/Spells",
    "Assets/Sounds",
    "Modules"
}

for _, folderPath in ipairs(folders) do
    local parts = string.split(folderPath, "/")
    local parent = ReplicatedStorage
    
    for _, part in ipairs(parts) do
        local folder = parent:FindFirstChild(part)
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = part
            folder.Parent = parent
        end
        parent = folder
    end
end

print("Asset folders created!")
    player.CharacterAdded:Connect(function(character)
        -- Setup character with wizard properties
        wait(1) -- Wait for character to load
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    gameState.activePlayers[player] = nil
end)

-- Create basic level
local function createBasicLevel()
    -- Ground
    local ground = Instance.new("Part")
    ground.Name = "Ground"
    ground.Size = Vector3.new(200, 1, 200)
    ground.Position = Vector3.new(0, 0, 0)
    ground.Material = Enum.Material.Grass
    ground.BrickColor = BrickColor.new("Earth green")
    ground.Anchored = true
    ground.Parent = workspace
    
    -- Spawn points folder
    local spawnFolder = Instance.new("Folder")
    spawnFolder.Name = "SpawnPoints"
    spawnFolder.Parent = workspace
    
    -- Create spawn points at corners
    for i = 1, 4 do
        local angle = (i - 1) * math.pi / 2
        local spawnPoint = Instance.new("Part")
        spawnPoint.Name = "SpawnPoint" .. i
        spawnPoint.Size = Vector3.new(4, 1, 4)
        spawnPoint.Position = Vector3.new(math.cos(angle) * 80, 1, math.sin(angle) * 80)
        spawnPoint.Transparency = 1
        spawnPoint.CanCollide = false
        spawnPoint.Anchored = true
        spawnPoint.Parent = spawnFolder
    end
    
    -- Some obstacles
    for i = 1, 10 do
        local obstacle = Instance.new("Part")
        obstacle.Name = "Obstacle" .. i
        obstacle.Size = Vector3.new(
            math.random(5, 15),
            math.random(5, 20),
            math.random(5, 15)
        )
        obstacle.Position = Vector3.new(
            math.random(-70, 70),
            obstacle.Size.Y / 2,
            math.random(-70, 70)
        )
        obstacle.Material = Enum.Material.Rock
        obstacle.BrickColor = BrickColor.new("Dark grey")
        obstacle.Anchored = true
        obstacle.Parent = workspace
    end
end

-- Initialize
createBasicLevel()

print("Wizard Survival Game initialized!")