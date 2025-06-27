local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local EnemyAI = require(ReplicatedStorage.Modules.EnemyAI)

-- Configuration
local SPAWN_INTERVAL = 5 -- seconds
local ENEMIES_PER_WAVE = 3
local WAVE_MULTIPLIER = 1.2

-- Enemy types
local enemyTypes = {
    {
        name = "Zombie",
        health = 50,
        damage = 10,
        speed = 12,
        model = "ZombieModel" -- Name in ReplicatedStorage.Assets.Enemies
    },
    {
        name = "Orc",
        health = 100,
        damage = 20,
        speed = 16,
        model = "OrcModel"
    },
    {
        name = "Dragon",
        health = 200,
        damage = 40,
        speed = 20,
        model = "DragonModel"
    }
}

local currentWave = 1
local spawnPoints = {}

-- Setup spawn points
local function setupSpawnPoints()
    local spawnFolder = workspace:FindFirstChild("SpawnPoints")
    if spawnFolder then
        for _, part in ipairs(spawnFolder:GetChildren()) do
            if part:IsA("BasePart") then
                table.insert(spawnPoints, part)
            end
        end
    else
        -- Create default spawn points
        for i = 1, 4 do
            local spawnPart = Instance.new("Part")
            spawnPart.Name = "SpawnPoint" .. i
            spawnPart.Size = Vector3.new(4, 1, 4)
            spawnPart.Transparency = 1
            spawnPart.CanCollide = false
            spawnPart.Anchored = true
            spawnPart.Position = Vector3.new(i * 20 - 40, 5, i * 20 - 40)
            spawnPart.Parent = workspace
            table.insert(spawnPoints, spawnPart)
        end
    end
end

-- Create basic enemy model if not exists
local function createBasicEnemy(enemyType)
    local enemy = Instance.new("Model")
    enemy.Name = enemyType.name
    
    -- Body
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2, 2, 1)
    torso.BrickColor = BrickColor.new("Really red")
    torso.Parent = enemy
    
    -- Head
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(2, 1, 1)
    head.BrickColor = BrickColor.new("Light orange")
    head.Parent = enemy
    
    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = enemyType.health
    humanoid.Health = enemyType.health
    humanoid.Parent = enemy
    
    -- RootPart
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 1)
    rootPart.Transparency = 1
    rootPart.CanCollide = false
    rootPart.Parent = enemy
    
    -- Welds
    local torsoWeld = Instance.new("WeldConstraint")
    torsoWeld.Part0 = rootPart
    torsoWeld.Part1 = torso
    torsoWeld.Parent = rootPart
    
    local headWeld = Instance.new("WeldConstraint")
    headWeld.Part0 = torso
    headWeld.Part1 = head
    head.CFrame = torso.CFrame * CFrame.new(0, 1.5, 0)
    headWeld.Parent = head
    
    -- Set attributes
    enemy:SetAttribute("Damage", enemyType.damage)
    enemy:SetAttribute("Speed", enemyType.speed)
    enemy:SetAttribute("AttackRange", 5)
    enemy:SetAttribute("AttackCooldown", 1)
    
    enemy.PrimaryPart = rootPart
    
    return enemy
end

-- Spawn enemy
local function spawnEnemy()
    if #spawnPoints == 0 then return end
    
    -- Select random enemy type (harder enemies in later waves)
    local maxEnemyIndex = math.min(math.ceil(currentWave / 5), #enemyTypes)
    local enemyType = enemyTypes[math.random(1, maxEnemyIndex)]
    
    -- Try to load from storage or create basic
    local enemyModel = nil
    local enemiesFolder = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Enemies")
    
    if enemiesFolder and enemiesFolder:FindFirstChild(enemyType.model) then
        enemyModel = enemiesFolder[enemyType.model]:Clone()
    else
        enemyModel = createBasicEnemy(enemyType)
    end
    
    -- Position at random spawn point
    local spawnPoint = spawnPoints[math.random(1, #spawnPoints)]
    enemyModel:SetPrimaryPartCFrame(spawnPoint.CFrame + Vector3.new(0, 5, 0))
    enemyModel.Parent = workspace
    
    -- Initialize AI
    local ai = EnemyAI.new(enemyModel)
    ai:Start()
end

-- Wave spawning
local function spawnWave()
    local enemyCount = math.floor(ENEMIES_PER_WAVE * (WAVE_MULTIPLIER ^ (currentWave - 1)))
    
    for i = 1, enemyCount do
        spawnEnemy()
        wait(0.5) -- Slight delay between spawns
    end
    
    currentWave = currentWave + 1
end

-- Initialize
setupSpawnPoints()

-- Main spawn loop
while true do
    spawnWave()
    wait(SPAWN_INTERVAL)
end