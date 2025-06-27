local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local player = Players:GetPlayerFromCharacter(character)

-- Wizard Stats
local stats = {
    maxHealth = 100,
    maxMana = 100,
    manaRegen = 5,
    currentMana = 100
}

-- Create Mana Value
local manaValue = Instance.new("IntValue")
manaValue.Name = "Mana"
manaValue.Value = stats.currentMana
manaValue.Parent = character

-- Health Setup
humanoid.MaxHealth = stats.maxHealth
humanoid.Health = stats.maxHealth

-- Mana Regeneration
local lastRegen = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastRegen > 1 then
        lastRegen = tick()
        if manaValue.Value < stats.maxMana then
            manaValue.Value = math.min(manaValue.Value + stats.manaRegen, stats.maxMana)
        end
    end
end)

-- Camera Setup
local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Custom
camera.CameraSubject = humanoid

-- Add wizard hat/staff visuals
local wizardHat = Instance.new("Part")
wizardHat.Name = "WizardHat"
wizardHat.Size = Vector3.new(2, 2, 2)
wizardHat.BrickColor = BrickColor.new("Royal purple")
wizardHat.Material = Enum.Material.Neon
wizardHat.CanCollide = false

local hatMesh = Instance.new("SpecialMesh")
hatMesh.MeshType = Enum.MeshType.FileMesh
hatMesh.MeshId = "rbxassetid://1073659"
hatMesh.Scale = Vector3.new(1.2, 1.2, 1.2)
hatMesh.Parent = wizardHat

local weld = Instance.new("WeldConstraint")
weld.Part0 = character:WaitForChild("Head")
weld.Part1 = wizardHat
wizardHat.CFrame = character.Head.CFrame * CFrame.new(0, 1, 0)
weld.Parent = wizardHat
wizardHat.Parent = character