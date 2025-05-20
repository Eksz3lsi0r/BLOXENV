--!strict
-- TestRunner.lua
-- Roblox TestEZ Runner Configuration
-- This script is used to run all tests in the game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Versuche, TestEZ zu laden (sollte in ReplicatedStorage vorliegen)
local TestEZ = ReplicatedStorage:FindFirstChild("TestEZ")
if not TestEZ then
    error("TestEZ nicht gefunden. Bitte stelle sicher, dass das TestEZ-Modul im ReplicatedStorage verfügbar ist.")
end

local TestService = game:GetService("TestService")
local TestRunner = require(TestEZ.TestRunner)
local TextReporter = require(TestEZ.Reporters.TextReporter)

-- Definiere die Ordner, die nach Tests durchsucht werden sollen
local testFolders = {
    ReplicatedStorage.tests, -- Unit Tests
    ServerStorage.ServerTests, -- Server-spezifische Tests
}

-- Sammle alle Test-Module
local testModules = {}
for _, folder in ipairs(testFolders) do
    if folder then
        for _, descendant in ipairs(folder:GetDescendants()) do
            if descendant:IsA("ModuleScript") and string.match(descendant.Name, "%.spec$") then
                table.insert(testModules, descendant)
            end
        end
    end
end

-- Führe Tests aus
local results = TestRunner:TestBootstrap(testModules)

-- Gebe die Ergebnisse aus
local reporter = TextReporter
reporter.report(results)

-- Melde Ergebnisse an TestService, damit sie in der Ausgabe erscheinen
if results.failureCount > 0 then
    TestService:Error("❌ " .. results.failureCount .. " Tests fehlgeschlagen")
else
    TestService:Message("✅ Alle " .. results.passedCount .. " Tests erfolgreich")
end

-- Ergebnis zurückgeben für die CI-Pipeline
return results.failureCount == 0
