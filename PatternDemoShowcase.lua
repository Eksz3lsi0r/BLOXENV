-- 🎬 PATTERN DEMO SHOWCASE - Die spektakulärsten Kombinationen! 🎨

-- Kopiere diesen Code für eine automatische Demo der besten Pattern!

local function startPatternShowcase(guardian)
    print("🎬 STARTING ULTIMATE PATTERN SHOWCASE!")
    print("🎯 Showcasing the most spectacular floor patterns...")
    
    local showcasePatterns = {
        {
            name = "🌌 COSMIC JOURNEY",
            description = "Eine Reise durch die Galaxie",
            patterns = {4, 17, 36}, -- Aurora Borealis, Galaxy Spiral, Mystic Constellation
            duration = 8,
            specialEffects = function()
                guardian:ActivateShukakuMode()
            end
        },
        {
            name = "🔥 ELEMENTAL FURY", 
            description = "Alle Elemente entfesselt",
            patterns = {2, 8, 6, 35}, -- Forest Fire, Volcanic Eruption, Lightning Storm, Elemental Fusion
            duration = 6,
            specialEffects = function()
                guardian:ActivateUltimateDefense(guardian.protectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(20, 0, 0))
            end
        },
        {
            name = "🎵 MUSIC FESTIVAL",
            description = "Ultimate Audio-Visual Experience", 
            patterns = {41, 44, 46, 60}, -- Bass Drop, Disco Floor, Spectrum Analyzer, Audio Reactive
            duration = 10,
            specialEffects = function()
                guardian:ActivateRainbowPath(15)
            end
        },
        {
            name = "🎮 DIGITAL MATRIX",
            description = "Cyberpunk Digital World",
            patterns = {62, 64, 66, 63}, -- Matrix Code, Neon Grid, Hologram, Glitch Effect
            duration = 7,
            specialEffects = function()
                guardian:SetPathSettings({pathColors = {
                    fresh = Color3.fromRGB(0, 255, 255),
                    blessed = Color3.fromRGB(255, 20, 147)
                }})
            end
        },
        {
            name = "🎨 ARTIST'S DREAM",
            description = "Kunst in Bewegung",
            patterns = {85, 86, 83, 100}, -- Kaleidoscope, Fractal Mandelbrot, Van Gogh Swirls, Infinity Loop
            duration = 12,
            specialEffects = function()
                -- Spezielle Kunst-Farben
            end
        },
        {
            name = "👹 DEMON LORD AWAKENING",
            description = "Gaara's ultimative Macht",
            patterns = {38, 33, 25, 40}, -- Demon Summoning, Shadow Realm, Dragon Fire, Arcane Explosion
            duration = 8,
            specialEffects = function()
                guardian:ActivateShukakuMode()
                task.wait(2)
                guardian:ActivateUltimateDefense(guardian.protectedPlayer.Character.HumanoidRootPart.Position)
            end
        },
        {
            name = "🌈 RAINBOW PARADISE",
            description = "Regenbogen-Extravaganza",
            patterns = {19, 7, 96, 88}, -- Rainbow Rain, Cherry Blossom Rain, Tie Dye, Color Gradient
            duration = 15,
            specialEffects = function()
                guardian:ActivateRainbowPath(30)
                guardian:SetPathSettings({pathBlessings = true})
            end
        },
        {
            name = "⚡ STORM OF POWER",
            description = "Naturgewalten entfesselt",
            patterns = {6, 9, 14, 13}, -- Lightning Storm, Tornado Spiral, Meteor Shower, Solar Flare
            duration = 6,
            specialEffects = function()
                guardian:SetProtectionLevel("aggressive")
            end
        }
    }
    
    -- Showcase Loop
    for i, showcase in ipairs(showcasePatterns) do
        print("\n" .. "="..string.rep("=", 50))
        print("🎬 SHOWCASE " .. i .. "/8: " .. showcase.name)
        print("   " .. showcase.description)
        print("="..string.rep("=", 50))
        
        -- Special Effects aktivieren
        if showcase.specialEffects then
            task.spawn(showcase.specialEffects)
        end
        
        -- Pattern-Sequenz abspielen
        for j, patternId in ipairs(showcase.patterns) do
            task.spawn(function()
                task.wait((j-1) * (showcase.duration / #showcase.patterns))
                
                if guardian.patternSelector then
                    guardian.patternSelector:ActivatePattern(patternId)
                    print("🎨 Pattern " .. patternId .. " activated!")
                end
            end)
        end
        
        -- Warten bis Showcase fertig
        task.wait(showcase.duration + 3)
        
        -- Reset für nächsten Showcase
        if guardian.patternSelector then
            guardian.patternSelector:ResetToSandColor()
        end
        
        task.wait(2) -- Pause zwischen Showcases
    end
    
    print("\n" .. "🎉 PATTERN SHOWCASE COMPLETE!")
    print("🏜️ Gaara's Sand returns to normal state")
    print("💬 Use /pattern commands to try patterns yourself!")
end

-- 🎯 Quick Demo für spezifische Kategorien
local function categoryDemo(guardian, category)
    print("🎯 Starting " .. category:upper() .. " category demo...")
    
    local categoryPatterns = {
        nature = {1, 4, 7, 17, 20}, -- Ocean Waves, Aurora Borealis, Cherry Blossom, Galaxy Spiral, Crystal Cave
        magic = {21, 25, 29, 35, 40}, -- Magic Circle, Dragon Fire, Time Distortion, Elemental Fusion, Arcane Explosion  
        music = {41, 44, 46, 55, 60}, -- Bass Drop, Disco Floor, Spectrum Analyzer, Club Atmosphere, Audio Reactive
        gaming = {62, 64, 69, 74, 77}, -- Matrix Code, Neon Grid, Power Up, Boss Battle, Achievement Unlock
        art = {85, 86, 88, 98, 100} -- Kaleidoscope, Fractal Mandelbrot, Color Gradient, Plasma Flow, Infinity Loop
    }
    
    local patterns = categoryPatterns[category]
    if not patterns then
        print("❌ Unknown category: " .. category)
        return
    end
    
    for i, patternId in ipairs(patterns) do
        print("🎨 Demo Pattern " .. i .. "/5: ID " .. patternId)
        
        if guardian.patternSelector then
            guardian.patternSelector:ActivatePattern(patternId)
        end
        
        task.wait(5) -- 5 Sekunden pro Pattern
        
        if guardian.patternSelector then
            guardian.patternSelector:ResetToSandColor()
        end
        
        task.wait(1) -- Kurze Pause
    end
    
    print("✅ " .. category:upper() .. " demo complete!")
end

-- 🎲 Chaos Mode - Zufällige Pattern-Explosionen
local function chaosMode(guardian, duration)
    duration = duration or 60
    print("🎲 CHAOS MODE ACTIVATED for " .. duration .. " seconds!")
    print("🌪️ Random patterns will activate rapidly!")
    
    local startTime = tick()
    local patternCount = 0
    
    while tick() - startTime < duration do
        local randomPatternId = math.random(1, 100)
        
        if guardian.patternSelector then
            guardian.patternSelector:ActivatePattern(randomPatternId, {
                duration = math.random(2, 8),
                speed = "fast"
            })
            patternCount = patternCount + 1
        end
        
        task.wait(math.random(1, 4)) -- 1-4 Sekunden zwischen Pattern
    end
    
    print("🎉 CHAOS MODE COMPLETE! " .. patternCount .. " patterns activated!")
    
    if guardian.patternSelector then
        guardian.patternSelector:ResetToSandColor()
    end
end

-- 🎪 Boss Battle Simulation
local function bossBattleSimulation(guardian)
    print("👹 BOSS BATTLE SIMULATION STARTING!")
    print("🔥 Epic battle sequence with multiple phases...")
    
    local phases = {
        {
            name = "Boss Appears",
            patterns = {74, 38}, -- Boss Battle, Demon Summoning
            duration = 8,
            message = "👹 A powerful boss appears!"
        },
        {
            name = "Elemental Attacks", 
            patterns = {25, 8, 6}, -- Dragon Fire, Volcanic Eruption, Lightning Storm
            duration = 10,
            message = "🔥 Boss unleashes elemental fury!"
        },
        {
            name = "Reality Distortion",
            patterns = {29, 87, 63}, -- Time Distortion, Optical Illusion, Glitch Effect
            duration = 6,
            message = "🌀 Reality begins to warp!"
        },
        {
            name = "Final Phase",
            patterns = {40, 35, 100}, -- Arcane Explosion, Elemental Fusion, Infinity Loop
            duration = 12,
            message = "⚡ FINAL BOSS PHASE!"
        },
        {
            name = "Victory",
            patterns = {77, 71, 19}, -- Achievement Unlock, Level Complete, Rainbow Rain
            duration = 8,
            message = "🎉 BOSS DEFEATED! Victory achieved!"
        }
    }
    
    for i, phase in ipairs(phases) do
        print("\n📢 " .. phase.message)
        
        -- Phase spezielle Effekte
        if i == 1 then
            guardian:SetProtectionLevel("aggressive")
        elseif i == 4 then
            guardian:ActivateShukakuMode()
        elseif i == 5 then
            guardian:ActivateRainbowPath(10)
        end
        
        -- Pattern für diese Phase
        for j, patternId in ipairs(phase.patterns) do
            task.spawn(function()
                task.wait((j-1) * (phase.duration / #phase.patterns))
                
                if guardian.patternSelector then
                    guardian.patternSelector:ActivatePattern(patternId)
                end
            end)
        end
        
        task.wait(phase.duration + 2)
    end
    
    print("🏆 BOSS BATTLE SIMULATION COMPLETE!")
    print("🏜️ The sand settles... victory is yours!")
end

-- 🚀 Export functions for use
return {
    startPatternShowcase = startPatternShowcase,
    categoryDemo = categoryDemo, 
    chaosMode = chaosMode,
    bossBattleSimulation = bossBattleSimulation
}
