--!strict
-- filepath: /Users/alanalo/Downloads/RobloxWorkspace/roblox-luau-workspace/src/modules/example.module.lua
-- Beispielmodul für Roblox-Spieleentwicklung mit Luau
-- Zeigt Grundfunktionen und Typisierung

local ExampleModule = {}

-- Typdefinitionen
export type Vector2D = {
    x: number,
    y: number
}

export type Player = {
    name: string,
    health: number,
    position: Vector2D,
    inventory: {[string]: number}
}

-- Grundlegende Funktionen
function ExampleModule.greet(name: string): string
    return "Hello, " .. name .. "!"
end

function ExampleModule.add(a: number, b: number): number
    return a + b
end

-- Vektor-Operationen
function ExampleModule.createVector(x: number, y: number): Vector2D
    return {
        x = x,
        y = y
    }
end

function ExampleModule.vectorDistance(v1: Vector2D, v2: Vector2D): number
    local dx = v2.x - v1.x
    local dy = v2.y - v1.y
    return math.sqrt(dx*dx + dy*dy)
end

-- Spieler-Funktionalitäten
function ExampleModule.createPlayer(name: string): Player
    return {
        name = name,
        health = 100,
        position = ExampleModule.createVector(0, 0),
        inventory = {}
    }
end

function ExampleModule.playerTakeDamage(player: Player, damage: number): Player
    local newHealth = math.max(0, player.health - damage)
    
    -- Erstelle eine Kopie des Spielers mit aktualisierter Gesundheit
    local updatedPlayer = table.clone(player)
    updatedPlayer.health = newHealth
    
    return updatedPlayer
end

function ExampleModule.addToInventory(player: Player, item: string, amount: number): Player
    local updatedPlayer = table.clone(player)
    local currentAmount = updatedPlayer.inventory[item] or 0
    updatedPlayer.inventory[item] = currentAmount + amount
    
    return updatedPlayer
end

return ExampleModule