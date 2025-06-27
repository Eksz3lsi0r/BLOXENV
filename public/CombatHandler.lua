local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- Track damage dealt for scoring
local damageDealtRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("DamageDealt")

-- Handle enemy deaths and rewards
local function onEnemyDied(enemyModel, killer)
    -- Award points
    if killer and killer:IsA("Player") then
        local leaderstats = killer:FindFirstChild("leaderstats")
        if not leaderstats then
            leaderstats = Instance.new("Folder")
            leaderstats.Name = "leaderstats"
            leaderstats.Parent = killer
            
            local score = Instance.new("IntValue")
            score.Name = "Score"
            score.Value = 0
            score.Parent = leaderstats
            
            local kills = Instance.new("IntValue")
            kills.Name = "Kills"
            kills.Value = 0
            kills.Parent = leaderstats
        end
        
        leaderstats.Score.Value = leaderstats.Score.Value + 100
        leaderstats.Kills.Value = leaderstats.Kills.Value + 1
    end
    
    -- Drop loot chance
    if math.random() < 0.3 then -- 30% chance
        local manaOrb = Instance.new("Part")
        manaOrb.Name = "ManaOrb"
        manaOrb.Size = Vector3.new(2, 2, 2)
        manaOrb.Shape = Enum.PartType.Ball
        manaOrb.Material = Enum.Material.Neon
        manaOrb.BrickColor = BrickColor.new("Bright blue")
        manaOrb.CanCollide = false
        manaOrb.Position = enemyModel.PrimaryPart.Position + Vector3.new(0, 3, 0)
        manaOrb.Parent = workspace
        
        -- Float effect
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
        bodyPosition.Position = manaOrb.Position + Vector3.new(0, 1, 0)
        bodyPosition.Parent = manaOrb
        
        -- Collect on touch
        manaOrb.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid and Players:GetPlayerFromCharacter(hit.Parent) then
                local mana = hit.Parent:FindFirstChild("Mana")
                if mana then
                    mana.Value = math.min(mana.Value + 25, 100)
                end
                manaOrb:Destroy()
            end
        end)
        
        Debris:AddItem(manaOrb, 30) -- Despawn after 30 seconds
    end
end

-- Setup enemy death tracking
workspace.ChildAdded:Connect(function(child)
    if child:FindFirstChild("Humanoid") and child:FindFirstChild("Enemy") then
        local humanoid = child.Humanoid
        humanoid.Died:Connect(function()
            onEnemyDied(child, nil) -- TODO: Track who killed
        end)
    end
end)