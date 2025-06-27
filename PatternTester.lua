-- PATTERN TESTER - Zum Ausprobieren aller verrückten Muster
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local FloorAnimator = require(script.Parent.Assets.Modules.FloorAnimator)
local ExperimentalPatterns = require(script.Parent.Assets.Modules.ExperimentalPatterns)
local PatternLibrary = require(script.Parent.Assets.Modules.PatternLibrary)

local PatternTester = {}

function PatternTester.new(floorSegments)
    local self = {}
    self.floorAnimator = FloorAnimator.new(floorSegments, 48)
    self.currentPattern = 1
    self.isPlaying = false
    
    -- Pattern Liste für einfaches Durchschalten
    self.patterns = {
        {name = "DNA Helix", func = function() 
            ExperimentalPatterns.CrazyPatterns.DNAHelix(self.floorAnimator, 24, 24, 10, 8) 
        end},
        
        {name = "Mandelbrot Fraktal", func = function() 
            ExperimentalPatterns.CrazyPatterns.MandelbrotFractal(self.floorAnimator, 24, 24, 0.12, 25) 
        end},
        
        {name = "Matrix Regen", func = function() 
            ExperimentalPatterns.CrazyPatterns.MatrixRain(self.floorAnimator, 15, 20) 
        end},
        
        {name = "Sinus Interferenz", func = function() 
            ExperimentalPatterns.CrazyPatterns.SinusInterference(self.floorAnimator, 10, 5) 
        end},
        
        {name = "Kaleidoskop", func = function() 
            ExperimentalPatterns.CrazyPatterns.Kaleidoscope(self.floorAnimator, 24, 24, 12, 8) 
        end},
        
        {name = "Zelluläres Leben", func = function() 
            ExperimentalPatterns.CrazyPatterns.CellularLife(self.floorAnimator, 30, "random") 
        end},
        
        {name = "Zelluläres Leben (Center)", func = function() 
            ExperimentalPatterns.CrazyPatterns.CellularLife(self.floorAnimator, 25, "center") 
        end},
        
        {name = "Feuer Spirale + Eis Welle", func = function()
            -- Kombiniere verschiedene Effekte
            PatternLibrary.WizardHeroPatterns.DefensiveCircle(self.floorAnimator, 15, 15, 12)
            task.wait(2)
            PatternLibrary.WizardHeroPatterns.IceExplosion(self.floorAnimator, 35, 35)
            task.wait(1)
            ExperimentalPatterns.CrazyPatterns.DNAHelix(self.floorAnimator, 24, 24, 8, 6)
        end},
        
        {name = "Regenbogen Explosion", func = function()
            local colors = ExperimentalPatterns.ColorPalettes.Rainbow
            self.floorAnimator:CreateShockwave(24, 24, 25, 4, colors)
            task.wait(2)
            ExperimentalPatterns.CrazyPatterns.SinusInterference(self.floorAnimator, 8, 4)
        end},
        
        {name = "Cyberpunk Matrix", func = function()
            ExperimentalPatterns.CrazyPatterns.MatrixRain(self.floorAnimator, 8, 15)
            task.wait(3)
            local colors = ExperimentalPatterns.ColorPalettes.Cyberpunk
            self.floorAnimator:CreateShockwave(24, 24, 20, 3, colors)
        end},
        
        {name = "Galaxy Kaleidoskop", func = function()
            ExperimentalPatterns.CrazyPatterns.Kaleidoscope(self.floorAnimator, 24, 24, 15, 12)
        end},
        
        {name = "Fraktaler Wahnsinn", func = function()
            -- Mehrere Mandelbrot-Sets gleichzeitig
            spawn(function() ExperimentalPatterns.CrazyPatterns.MandelbrotFractal(self.floorAnimator, 12, 12, 0.08, 20) end)
            task.wait(2)
            spawn(function() ExperimentalPatterns.CrazyPatterns.MandelbrotFractal(self.floorAnimator, 36, 36, 0.08, 20) end)
            task.wait(2)
            ExperimentalPatterns.CrazyPatterns.SinusInterference(self.floorAnimator, 8, 6)
        end},
        
        {name = "Alle Farbpaletten Showcase", func = function()
            local palettes = {"Cyberpunk", "Rainbow", "FireAndIce", "Galaxy", "Toxic"}
            for i, paletteName in ipairs(palettes) do
                local colors = ExperimentalPatterns.ColorPalettes[paletteName]
                local x = (i - 1) * 10 + 8
                self.floorAnimator:CreateShockwave(x, 24, 8, 2, colors)
                task.wait(0.5)
            end
        end},
        
        {name = "Gemischte Farbpaletten", func = function()
            local blend1 = ExperimentalPatterns.Utils.BlendColorPalettes(
                ExperimentalPatterns.ColorPalettes.Cyberpunk,
                ExperimentalPatterns.ColorPalettes.Galaxy,
                0.5
            )
            self.floorAnimator:CreateShockwave(18, 18, 15, 3, blend1)
            
            task.wait(2)
            
            local blend2 = ExperimentalPatterns.Utils.BlendColorPalettes(
                ExperimentalPatterns.ColorPalettes.FireAndIce,
                ExperimentalPatterns.ColorPalettes.Toxic,
                0.3
            )
            self.floorAnimator:CreateShockwave(30, 30, 15, 3, blend2)
        end},
        
        {name = "Interaktiver Test", func = function()
            local player = Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local position = player.Character.HumanoidRootPart.Position
                ExperimentalPatterns.InteractivePatterns.ProximityGlow(
                    self.floorAnimator, position, 15, 1.0
                )
            end
        end}
    }
    
    self:SetupControls()
    return self
end

function PatternTester:SetupControls()
    local player = Players.LocalPlayer
    if not player then return end
    
    -- Erstelle GUI für Steuerung
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PatternTesterGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Haupt-Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Titel
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "🎨 Pattern Tester"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Aktuelles Pattern Label
    local currentLabel = Instance.new("TextLabel")
    currentLabel.Size = UDim2.new(1, -20, 0, 30)
    currentLabel.Position = UDim2.new(0, 10, 0, 50)
    currentLabel.BackgroundTransparency = 1
    currentLabel.Text = "Pattern: " .. self.patterns[self.currentPattern].name
    currentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentLabel.TextScaled = true
    currentLabel.Font = Enum.Font.Gotham
    currentLabel.Parent = mainFrame
    
    -- Vorheriges Pattern Button
    local prevButton = Instance.new("TextButton")
    prevButton.Size = UDim2.new(0, 80, 0, 40)
    prevButton.Position = UDim2.new(0, 20, 0, 90)
    prevButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    prevButton.BorderSizePixel = 0
    prevButton.Text = "◀ Zurück"
    prevButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    prevButton.TextScaled = true
    prevButton.Font = Enum.Font.GothamBold
    prevButton.Parent = mainFrame
    
    -- Play/Stop Button
    local playButton = Instance.new("TextButton")
    playButton.Size = UDim2.new(0, 80, 0, 40)
    playButton.Position = UDim2.new(0, 110, 0, 90)
    playButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    playButton.BorderSizePixel = 0
    playButton.Text = "▶ Play"
    playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    playButton.TextScaled = true
    playButton.Font = Enum.Font.GothamBold
    playButton.Parent = mainFrame
    
    -- Nächstes Pattern Button
    local nextButton = Instance.new("TextButton")
    nextButton.Size = UDim2.new(0, 80, 0, 40)
    nextButton.Position = UDim2.new(0, 200, 0, 90)
    nextButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    nextButton.BorderSizePixel = 0
    nextButton.Text = "Weiter ▶"
    nextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    nextButton.TextScaled = true
    nextButton.Font = Enum.Font.GothamBold
    nextButton.Parent = mainFrame
    
    -- Clear Button
    local clearButton = Instance.new("TextButton")
    clearButton.Size = UDim2.new(0, 120, 0, 30)
    clearButton.Position = UDim2.new(0, 90, 0, 140)
    clearButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    clearButton.BorderSizePixel = 0
    clearButton.Text = "🗑 Clear Floor"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.TextScaled = true
    clearButton.Font = Enum.Font.Gotham
    clearButton.Parent = mainFrame
    
    -- Auto-Test Button
    local autoTestButton = Instance.new("TextButton")
    autoTestButton.Size = UDim2.new(0, 120, 0, 20)
    autoTestButton.Position = UDim2.new(0, 90, 0, 175)
    autoTestButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    autoTestButton.BorderSizePixel = 0
    autoTestButton.Text = "🚀 Alle Testen"
    autoTestButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    autoTestButton.TextScaled = true
    autoTestButton.Font = Enum.Font.GothamBold
    autoTestButton.Parent = mainFrame
    
    -- Event Connections
    prevButton.Activated:Connect(function()
        self:PreviousPattern()
        currentLabel.Text = "Pattern: " .. self.patterns[self.currentPattern].name
    end)
    
    nextButton.Activated:Connect(function()
        self:NextPattern()
        currentLabel.Text = "Pattern: " .. self.patterns[self.currentPattern].name
    end)
    
    playButton.Activated:Connect(function()
        if self.isPlaying then
            self:StopPattern()
            playButton.Text = "▶ Play"
            playButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            self:PlayCurrentPattern()
            playButton.Text = "⏹ Stop"
            playButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    clearButton.Activated:Connect(function()
        self:ClearFloor()
    end)
    
    autoTestButton.Activated:Connect(function()
        self:AutoTestAllPatterns()
    end)
    
    -- Tastatur-Steuerung
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Q then
            self:PreviousPattern()
            currentLabel.Text = "Pattern: " .. self.patterns[self.currentPattern].name
        elseif input.KeyCode == Enum.KeyCode.E then
            self:NextPattern()
            currentLabel.Text = "Pattern: " .. self.patterns[self.currentPattern].name
        elseif input.KeyCode == Enum.KeyCode.Space then
            if self.isPlaying then
                self:StopPattern()
                playButton.Text = "▶ Play"
                playButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            else
                self:PlayCurrentPattern()
                playButton.Text = "⏹ Stop"
                playButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            end
        elseif input.KeyCode == Enum.KeyCode.C then
            self:ClearFloor()
        end
    end)
end

function PatternTester:NextPattern()
    self.currentPattern = self.currentPattern + 1
    if self.currentPattern > #self.patterns then
        self.currentPattern = 1
    end
end

function PatternTester:PreviousPattern()
    self.currentPattern = self.currentPattern - 1
    if self.currentPattern < 1 then
        self.currentPattern = #self.patterns
    end
end

function PatternTester:PlayCurrentPattern()
    if self.isPlaying then return end
    
    self.isPlaying = true
    print("🎨 Spiele Pattern: " .. self.patterns[self.currentPattern].name)
    
    spawn(function()
        self.patterns[self.currentPattern].func()
        
        -- Auto-stop nach Pattern Ende
        task.wait(2)
        if self.isPlaying then
            self.isPlaying = false
        end
    end)
end

function PatternTester:StopPattern()
    self.isPlaying = false
    print("⏹ Pattern gestoppt")
end

function PatternTester:ClearFloor()
    print("🗑 Lösche Floor...")
    for x = 1, 48 do
        for z = 1, 48 do
            self.floorAnimator:QueueUpdate(x, z, Color3.fromRGB(60, 60, 60), 0.8, nil, 0.3)
        end
    end
end

function PatternTester:AutoTestAllPatterns()
    print("🚀 Starte Auto-Test aller Pattern...")
    
    spawn(function()
        for i, pattern in ipairs(self.patterns) do
            self.currentPattern = i
            print("Testing: " .. pattern.name)
            
            pattern.func()
            task.wait(8) -- Lasse jedes Pattern 8 Sekunden laufen
            
            self:ClearFloor()
            task.wait(2) -- Pause zwischen Pattern
        end
        
        print("✅ Auto-Test abgeschlossen!")
    end)
end

-- Instructions für den Benutzer
function PatternTester:ShowInstructions()
    print("🎮 PATTERN TESTER STEUERUNG:")
    print("Q = Vorheriges Pattern")
    print("E = Nächstes Pattern") 
    print("SPACE = Pattern abspielen/stoppen")
    print("C = Floor löschen")
    print("")
    print("💡 VERFÜGBARE PATTERN:")
    for i, pattern in ipairs(self.patterns) do
        print(i .. ". " .. pattern.name)
    end
    print("")
    print("Viel Spaß beim Experimentieren! 🌈")
end

return PatternTester
