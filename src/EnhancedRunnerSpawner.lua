-- EnhancedRunnerSpawner.lua
-- Ort: StarterPlayer > StarterPlayerScripts
-- Erzeugt eine kontinuierliche Strecke aus den SegmentTemplates

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SEGMENT_FOLDER = "SegmentTemplates"
local SEGMENT_LENGTH = 50
local INITIAL_SEGMENTS = 6
local MAX_SEGMENTS = 8

local segmentTypes = {
	{ name = "Segment_Straight", weight = 50 },
	{ name = "Segment_RampUp",    weight = 10 },
	{ name = "Segment_RampDown",  weight = 10 },
	{ name = "Segment_CurveLeft", weight = 15 },
	{ name = "Segment_CurveRight",weight = 15 },
}

local folder = ReplicatedStorage:WaitForChild(SEGMENT_FOLDER)
local activeSegments = {}
local currentCFrame = CFrame.new(0, 0, 0)
local player = Players.LocalPlayer

local function chooseSegmentType()
	local total = 0
	for _, t in ipairs(segmentTypes) do total += t.weight end
	local r = math.random() * total
	local sum = 0
	for _, t in ipairs(segmentTypes) do
		sum += t.weight
		if r <= sum then return t.name end
	end
	return segmentTypes[1].name
end

local function cleanupOld()
	while #activeSegments > MAX_SEGMENTS do
		local old = table.remove(activeSegments, 1)
		if old then old:Destroy() end
	end
end

local function spawnSegment()
	local typeName = chooseSegmentType()
	local template = folder:FindFirstChild(typeName)
	if not template then warn("Template fehlt:", typeName); return end

	local segment = template:Clone()
	segment.Parent = Workspace
	segment:PivotTo(currentCFrame)
	table.insert(activeSegments, segment)

	local trigger = segment:FindFirstChild("EndTrigger", true)
	if trigger then
		trigger.Touched:Connect(function(hit)
			local char = player.Character
			if char and hit:IsDescendantOf(char) and not segment:GetAttribute("Triggered") then
				segment:SetAttribute("Triggered", true)
				spawnSegment()
				cleanupOld()
			end
		end)
	end

	local main = segment:FindFirstChild("Main")
	if main then
		local endOffset = main.CFrame:ToWorldSpace(CFrame.new(0, 0, SEGMENT_LENGTH)).Position
		currentCFrame = CFrame.new(endOffset, endOffset + main.CFrame.LookVector)
	else
		warn("Main fehlt im Segment:", typeName)
	end
end

-- Anfangssegmente (immer gerade)
for i = 1, INITIAL_SEGMENTS do
	local template = folder:FindFirstChild("Segment_Straight")
	if not template then warn("Segment_Straight fehlt"); return end
	local segment = template:Clone()
	segment.Parent = Workspace
	segment:PivotTo(currentCFrame)
	table.insert(activeSegments, segment)

	local main = segment:FindFirstChild("Main")
	if main then
		local endOffset = main.CFrame:ToWorldSpace(CFrame.new(0, 0, SEGMENT_LENGTH)).Position
		currentCFrame = CFrame.new(endOffset, endOffset + main.CFrame.LookVector)
	else
		warn("Main fehlt im Startsegment")
	end
end
