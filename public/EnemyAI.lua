local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local EnemyAI = {}
EnemyAI.__index = EnemyAI

function EnemyAI.new(enemyModel)
    local self = setmetatable({}, EnemyAI)
    
    self.model = enemyModel
    self.humanoid = enemyModel:WaitForChild("Humanoid")
    self.rootPart = enemyModel:WaitForChild("HumanoidRootPart")
    
    -- Enemy stats
    self.damage = enemyModel:GetAttribute("Damage") or 10
    self.attackRange = enemyModel:GetAttribute("AttackRange") or 5
    self.attackCooldown = enemyModel:GetAttribute("AttackCooldown") or 1
    self.speed = enemyModel:GetAttribute("Speed") or 16
    
    self.humanoid.WalkSpeed = self.speed
    self.lastAttack = 0
    self.target = nil
    self.path = nil
    
    -- Add Enemy tag
    local enemyTag = Instance.new("BoolValue")
    enemyTag.Name = "Enemy"
    enemyTag.Parent = enemyModel
    
    return self
end

function EnemyAI:Start()
    -- Main AI loop
    self.connection = RunService.Heartbeat:Connect(function()
        self:Update()
    end)
    
    -- Cleanup on death
    self.humanoid.Died:Connect(function()
        self:Destroy()
        wait(2)
        self.model:Destroy()
    end)
end

function EnemyAI:Update()
    -- Find nearest player
    local nearestPlayer = self:FindNearestPlayer()
    if not nearestPlayer then return end
    
    self.target = nearestPlayer.Character
    if not self.target then return end
    
    local targetRoot = self.target:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local distance = (self.rootPart.Position - targetRoot.Position).Magnitude
    
    -- Attack if in range
    if distance <= self.attackRange then
        self:Attack()
    else
        -- Move towards player
        self:MoveToTarget(targetRoot.Position)
    end
end

function EnemyAI:FindNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (self.rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    return nearestPlayer
end

function EnemyAI:MoveToTarget(targetPosition)
    -- Simple pathfinding
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(self.rootPart.Position, targetPosition)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        
        for _, waypoint in ipairs(waypoints) do
            self.humanoid:MoveTo(waypoint.Position)
            
            -- Jump if needed
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                self.humanoid.Jump = true
            end
            
            -- Wait until reached or timeout
            local reached = self.humanoid.MoveToFinished:Wait(1)
            if not reached then break end
        end
    else
        -- Fallback to direct movement
        self.humanoid:MoveTo(targetPosition)
    end
end

function EnemyAI:Attack()
    if tick() - self.lastAttack < self.attackCooldown then return end
    
    self.lastAttack = tick()
    
    if self.target and self.target:FindFirstChild("Humanoid") then
        self.target.Humanoid:TakeDamage(self.damage)
        
        -- Attack animation/effect
        local effect = Instance.new("Part")
        effect.Name = "AttackEffect"
        effect.Size = Vector3.new(1, 1, 1)
        effect.Material = Enum.Material.Neon
        effect.BrickColor = BrickColor.new("Really red")
        effect.CanCollide = false
        effect.Anchored = true
        effect.CFrame = self.rootPart.CFrame
        effect.Parent = workspace
        
        game:GetService("Debris"):AddItem(effect, 0.5)
    end
end

function EnemyAI:Destroy()
    if self.connection then
        self.connection:Disconnect()
    end
end

return EnemyAI