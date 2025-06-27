local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Wait for RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local castSpellRemote = remoteEvents:WaitForChild("CastSpell")

-- Spell Types
local spells = {
    {name = "Fireball", key = Enum.KeyCode.Q, manaCost = 10, cooldown = 0.5},
    {name = "IceSpike", key = Enum.KeyCode.E, manaCost = 15, cooldown = 1},
    {name = "Lightning", key = Enum.KeyCode.R, manaCost = 20, cooldown = 2}
}

local cooldowns = {}

-- PC Controls
local function castSpell(spellName)
    local character = player.Character
    if not character then return end
    
    local mana = character:FindFirstChild("Mana")
    if not mana then return end
    
    -- Find spell data
    local spellData = nil
    for _, spell in ipairs(spells) do
        if spell.name == spellName then
            spellData = spell
            break
        end
    end
    
    if not spellData then return end
    
    -- Check cooldown
    if cooldowns[spellName] and tick() - cooldowns[spellName] < spellData.cooldown then
        return
    end
    
    -- Check mana
    if mana.Value < spellData.manaCost then
        return -- Not enough mana
    end
    
    -- Cast spell
    cooldowns[spellName] = tick()
    local targetPosition = mouse.Hit.Position
    castSpellRemote:FireServer(spellName, targetPosition)
end

-- Bind keys
for _, spell in ipairs(spells) do
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == spell.key then
            castSpell(spell.name)
        end
    end)
end

-- Mobile Controls
local function createMobileButton(spell, position)
    local screenGui = player:WaitForChild("PlayerGui"):WaitForChild("GameUI")
    
    local button = Instance.new("TextButton")
    button.Name = spell.name .. "Button"
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = position
    button.Text = spell.name
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    button.BorderSizePixel = 0
    button.Parent = screenGui
    
    button.MouseButton1Click:Connect(function()
        castSpell(spell.name)
    end)
    
    -- Visual cooldown indicator
    local cooldownFrame = Instance.new("Frame")
    cooldownFrame.Name = "Cooldown"
    cooldownFrame.Size = UDim2.new(1, 0, 1, 0)
    cooldownFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    cooldownFrame.BackgroundTransparency = 0.5
    cooldownFrame.Visible = false
    cooldownFrame.Parent = button
    
    RunService.RenderStepped:Connect(function()
        if cooldowns[spell.name] then
            local elapsed = tick() - cooldowns[spell.name]
            if elapsed < spell.cooldown then
                cooldownFrame.Visible = true
                cooldownFrame.Size = UDim2.new(1, 0, 1 - (elapsed / spell.cooldown), 0)
            else
                cooldownFrame.Visible = false
            end
        end
    end)
end

-- Create mobile UI if on touch device
if UserInputService.TouchEnabled then
    wait(1) -- Wait for UI to load
    createMobileButton(spells[1], UDim2.new(1, -200, 1, -100))
    createMobileButton(spells[2], UDim2.new(1, -110, 1, -100))
    createMobileButton(spells[3], UDim2.new(1, -200, 1, -190))
end