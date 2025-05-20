--!strict
-- filepath: /Users/alanalo/Downloads/RobloxWorkspace/roblox-luau-workspace/src/main.server.lua
-- main.server.lua
-- This file serves as the main entry point for server-side scripts in the Roblox environment.
-- It initializes server functionalities and handles server events.

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Modules
local ExampleModule = require(ReplicatedStorage.modules["example.module"])
local Profiler = require(ReplicatedStorage.modules.Profiler)
local Types = require(ReplicatedStorage.modules.Types)

-- Alternativ zu den Typdefinitionen über den Import können wir sie direkt deklarieren
type Player = {
    Name: string,
    UserId: number,
    Character: Model?,
    Team: Team?,
    GetRankInGroup: (self: Player, groupId: number) -> number
}

type Configuration = {
    gameName: string,
    maxPlayers: number,
    debugMode: boolean,
    version: string,
    settings: {[string]: any}
}

-- Konstanten
local DEBUG_MODE = true
local MAX_PLAYERS = 10

-- Game Configuration
local GameConfig: Configuration = {
    gameName = "Roblox Luau Test",
    maxPlayers = MAX_PLAYERS,
    debugMode = DEBUG_MODE,
    version = "1.0.0",
    settings = {
        spawnLocation = "Lobby",
        startingMoney = 100
    }
}

-- Starte Profiler im Debug-Modus
if DEBUG_MODE then
    Profiler.start()
end

-- Event-Handler für neue Spieler
local function onPlayerAdded(player: Player)
    print(ExampleModule.greet(player.Name))
    
    -- Erstelle einen Spieler mit unserem ExampleModule
    local gamePlayer = ExampleModule.createPlayer(player.Name)
    
    -- Beispiel für Profiler-Nutzung
    if DEBUG_MODE then
        Profiler.begin("onPlayerAdded_" .. player.Name)
        
        -- Simuliere eine Verzögerung
        task.wait(0.1)
        
        Profiler.finish("onPlayerAdded_" .. player.Name)
    end
end

-- Event-Handler für das Verlassen von Spielern
local function onPlayerRemoving(player: Player)
    print(player.Name .. " hat das Spiel verlassen")
    
    -- Profiler-Ergebnisse anzeigen, wenn der letzte Spieler geht
    if DEBUG_MODE and #Players:GetPlayers() <= 1 then
        Profiler.print()
    end
end

-- Verbinde die Event-Handler
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Startup-Nachricht
print("Server gestartet: " .. GameConfig.gameName .. " v" .. GameConfig.version)
print("Max. Spieler: " .. GameConfig.maxPlayers)
print("Debug-Modus: " .. (GameConfig.debugMode and "EIN" or "AUS"))

-- Additional server-side initialization code can go here