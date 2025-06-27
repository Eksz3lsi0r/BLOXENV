local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Health Bar
local healthFrame = Instance.new("Frame")
healthFrame.Name = "HealthBar"
healthFrame.Size = UDim2.new(0.3, 0, 0, 20)
healthFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
healthFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
healthFrame.BorderSizePixel = 2
healthFrame.Parent = screenGui

local healthBar = Instance.new("Frame")
healthBar.Name = "Bar"
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthFrame

local healthText = Instance.new("TextLabel")
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.BackgroundTransparency = 1
healthText.Text = "100/100"
healthText.TextScaled = true
healthText.TextColor3 = Color3.new(1, 1, 1)
healthText.Parent = healthFrame

-- Mana Bar
local manaFrame = Instance.new("Frame")
manaFrame.Name = "ManaBar"
manaFrame.Size = UDim2.new(0.3, 0, 0, 20)
manaFrame.Position = UDim2.new(0.05, 0, 0.08, 0)
manaFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
manaFrame.BorderSizePixel = 2
manaFrame.Parent = screenGui

local manaBar = Instance.new("Frame")
manaBar.Name = "Bar"
manaBar.Size = UDim2.new(1, 0, 1, 0)
manaBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
manaBar.BorderSizePixel = 0
manaBar.Parent = manaFrame

local manaText = Instance.new("TextLabel")
manaText.Size = UDim2.new(1, 0, 1, 0)
manaText.BackgroundTransparency = 1
manaText.Text = "100/100"
manaText.TextScaled = true
manaText.TextColor3 = Color3.new(1, 1, 1)
manaText.Parent = manaFrame

-- Wave Counter
local waveLabel = Instance.new("TextLabel")
waveLabel.Name = "WaveCounter"
waveLabel.Size = UDim2.new(0.2, 0, 0, 40)
waveLabel.Position = UDim2.new(0.4, 0, 0.02, 0)
waveLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
waveLabel.BorderSizePixel = 2
waveLabel.Text = "Wave 1"
waveLabel.TextScaled = true
waveLabel.TextColor3 = Color3.new(1, 1, 1)
waveLabel.Parent = screenGui

-- Score Display
local scoreLabel = Instance.new("TextLabel")
scoreLabel.Name = "Score"
scoreLabel.Size = UDim2.new(0.2, 0, 0, 30)
scoreLabel.Position = UDim2.new(0.8, 0, 0.05, 0)
scoreLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
scoreLabel.BorderSizePixel = 2
scoreLabel.Text = "Score: 0"
scoreLabel.TextScaled = true
scoreLabel.TextColor3 = Color3.new(1, 1, 0)
scoreLabel.Parent = screenGui

-- Update UI
local function updateUI()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local mana = character:FindFirstChild("Mana")
    
    if humanoid then
        healthBar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
        healthText.Text = math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
    end
    
    if mana then
        manaBar.Size = UDim2.new(mana.Value / 100, 0, 1, 0)
        manaText.Text = mana.Value .. "/100"
    end
end

-- Connect update loop
RunService.RenderStepped:Connect(updateUI)

-- Death screen
local function createDeathScreen()
    local deathGui = Instance.new("ScreenGui")
    deathGui.Name = "DeathScreen"
    deathGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Parent = deathGui
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.5, 0, 0.2, 0)
    text.Position = UDim2.new(0.25, 0, 0.4, 0)
    text.BackgroundTransparency = 1
    text.Text = "You Died!"
    text.TextScaled = true
    text.TextColor3 = Color3.new(1, 0, 0)
    text.Font = Enum.Font.Fantasy
    text.Parent = frame
    
    wait(3)
    deathGui:Destroy()
end

-- Listen for death
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(createDeathScreen)
end)