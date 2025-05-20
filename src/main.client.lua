--!strict
-- filepath: /Users/alanalo/Downloads/RobloxWorkspace/roblox-luau-workspace/src/main.client.lua
-- This file serves as the main entry point for client-side scripts in the Roblox environment.
-- It initializes client functionalities and handles client events.

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Modules
local ExampleModule = require(ReplicatedStorage.modules["example.module"])
local UIBuilder = require(ReplicatedStorage.modules.UIBuilder)
local Profiler = require(ReplicatedStorage.modules.Profiler)

-- Konstanten
local DEBUG_MODE = true

-- Starte Profiler im Debug-Modus
if DEBUG_MODE then
    Profiler.start()
end

-- UI erstellen mit UIBuilder
local function createMainUI()
    -- Profiling starten
    Profiler.begin("createMainUI")
    
    -- Hauptrahmen
    local mainFrame = UIBuilder.Frame({
        name = "MainUI",
        size = UIBuilder.udim2(0, 300, 0, 200),
        position = UIBuilder.udim2(0.5, 0, 0.1, 0),
        backgroundColor = UIBuilder.color3(45, 45, 45),
        cornerRadius = 8,
        parent = player.PlayerGui:WaitForChild("ScreenGui") or
                 (function()
                     local gui = Instance.new("ScreenGui")
                     gui.Name = "ScreenGui"
                     gui.Parent = player.PlayerGui
                     return gui
                 end)()
    })
    
    -- Titel
    UIBuilder.Text({
        name = "Title",
        text = "Roblox Luau Beispiel",
        size = UIBuilder.udim2(1, -20, 0, 40),
        position = UIBuilder.udim2(0.5, 0, 0, 20),
        textSize = 22,
        parent = mainFrame
    })
    
    -- Button
    local button = UIBuilder.Button({
        name = "ActionButton",
        text = "Klick mich!",
        size = UIBuilder.udim2(0.8, 0, 0, 40),
        position = UIBuilder.udim2(0.5, 0, 0.5, 0),
        backgroundColor = UIBuilder.color3(0, 120, 215),
        cornerRadius = 8,
        parent = mainFrame,
        events = {
            MouseButton1Click = function()
                print("Button wurde geklickt!")
            end
        }
    })
    
    -- Status-Text
    local statusText = UIBuilder.Text({
        name = "StatusText",
        text = "Bereit",
        size = UIBuilder.udim2(1, -20, 0, 30),
        position = UIBuilder.udim2(0.5, 0, 1, -40),
        textSize = 16,
        parent = mainFrame
    })
    
    -- Button-Funktion erweitern
    local clickCount = 0
    button.MouseButton1Click:Connect(function()
        clickCount += 1
        statusText.Text = "Klicks: " .. clickCount
        
        -- Demo für Vektorberechnung aus ExampleModule
        local v1 = ExampleModule.createVector(0, 0)
        local v2 = ExampleModule.createVector(3, 4)
        local distance = ExampleModule.vectorDistance(v1, v2)
        print("Abstand zwischen Vektoren:", distance)
    end)
    
    -- Profiling beenden
    Profiler.finish("createMainUI")
    
    return mainFrame
end

-- Initialisierung nach dem Laden
local function init()
    -- Erstelle eine ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScreenGui"
    screenGui.Parent = player.PlayerGui
    
    -- Hauptbenutzeroberfläche erstellen
    local ui = createMainUI()
    
    -- Input-Handler für Debug-Infos
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- F3-Taste für Debug-Info
        if input.KeyCode == Enum.KeyCode.F3 and DEBUG_MODE then
            print("=== DEBUG INFO ===")
            Profiler.print()
        end
    end)
    
    print("Client initialisiert für Spieler:", player.Name)
end

-- Starte die Initialisierung
init()