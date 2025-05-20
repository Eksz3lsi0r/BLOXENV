--!strict
-- ExampleModule.spec.lua
-- Test-Suite für das ExampleModule

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ExampleModule = require(ReplicatedStorage.modules["example.module"])
    
    describe("ExampleModule", function()
        it("should greet with the given name", function()
            local result = ExampleModule.greet("Tester")
            expect(result).to.equal("Hello, Tester!")
        end)
        
        it("should add two numbers", function()
            local result = ExampleModule.add(5, 3)
            expect(result).to.equal(8)
        end)
        
        it("should create a 2D vector", function()
            local vector = ExampleModule.createVector(10, 20)
            expect(vector.x).to.equal(10)
            expect(vector.y).to.equal(20)
        end)
        
        it("should calculate distance between vectors", function()
            local v1 = ExampleModule.createVector(0, 0)
            local v2 = ExampleModule.createVector(3, 4)
            local distance = ExampleModule.vectorDistance(v1, v2)
            expect(distance).to.equal(5)
        end)
        
        describe("Player functions", function()
            it("should create a player with default values", function()
                local player = ExampleModule.createPlayer("TestPlayer")
                expect(player.name).to.equal("TestPlayer")
                expect(player.health).to.equal(100)
                expect(player.position.x).to.equal(0)
                expect(player.position.y).to.equal(0)
                expect(next(player.inventory)).to.equal(nil) -- Leeres Inventar
            end)
            
            it("should handle player damage", function()
                local player = ExampleModule.createPlayer("TestPlayer")
                local damagedPlayer = ExampleModule.playerTakeDamage(player, 30)
                
                expect(player.health).to.equal(100) -- Original unverändert
                expect(damagedPlayer.health).to.equal(70) -- Neue Instanz hat weniger Leben
            end)
            
            it("should not allow health below zero", function()
                local player = ExampleModule.createPlayer("TestPlayer")
                local damagedPlayer = ExampleModule.playerTakeDamage(player, 120)
                
                expect(damagedPlayer.health).to.equal(0)
            end)
            
            it("should add items to inventory", function()
                local player = ExampleModule.createPlayer("TestPlayer")
                local updatedPlayer = ExampleModule.addToInventory(player, "Sword", 1)
                
                expect(updatedPlayer.inventory.Sword).to.equal(1)
                
                -- Stapeln von Gegenständen testen
                local finalPlayer = ExampleModule.addToInventory(updatedPlayer, "Sword", 2)
                expect(finalPlayer.inventory.Sword).to.equal(3)
            end)
        end)
    end)
end
