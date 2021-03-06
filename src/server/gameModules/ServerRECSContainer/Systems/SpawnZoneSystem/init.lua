-- local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Workspace = game:GetService("Workspace")
-- local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local lib = ReplicatedStorage.lib
local common = ReplicatedStorage.common
-- local util = common.util

local RECS = require(lib.RECS)
local RecsComponents = require(common.RecsComponents)

local SpawnZone = require(script.SpawnZone)

local SpawnZoneSystem = RECS.System:extend("SpawnZoneSystem")

function SpawnZoneSystem:spawnGroup(zoneInstance)
    local spawnZone = self.spawnZones[zoneInstance]
    if not spawnZone then return end

    spawnZone:spawnGroup()
end

function SpawnZoneSystem:onComponentAdded(instance, component)

    local spawnZoneParts = {}

    for _,child in pairs(instance:GetDescendants()) do
        if child:IsA("Part") then
            table.insert(spawnZoneParts,child)
        end
    end

    local newSpawnZone = SpawnZone.new(
        self.core,
        spawnZoneParts,
        component,
        instance.Name.."_spawnContainer"
    )
    wait(1)

    while #newSpawnZone:getNPCs() < component.spawnCap do
        newSpawnZone:spawnGroup()
        wait()
    end

    self.spawnZones[instance] = newSpawnZone
end

function SpawnZoneSystem:onComponentRemoving(instance,component)
end

function SpawnZoneSystem:init()
    local enemiesBin = Workspace:FindFirstChild("enemies")
    if not enemiesBin then
        enemiesBin = Instance.new("Folder")
        enemiesBin.Name = "enemies"
        enemiesBin.Parent = Workspace
    end

    self.spawnZones = {}

    wait(3)

    for instance,component in self.core:components(RecsComponents.SpawnZone) do
        coroutine.wrap(function()
            self:onComponentAdded(instance, component)
        end)()
    end

    self.core:getComponentAddedSignal(RecsComponents.SpawnZone):connect(function(instance,component)
        self:onComponentAdded(instance, component)
    end)
    self.core:getComponentRemovingSignal(RecsComponents.SpawnZone):connect(function(instance,component)
        self:onComponentRemoving(instance, component)
    end)
end

function SpawnZoneSystem:step()
    -- loop thru each spawn zone and spawn npcs if counter is at/over rate

    -- find zones in areas occupied by players
    -- only spawn in those zones

    for instance,zoneComponent in self.core:components(RecsComponents.SpawnZone) do
        zoneComponent.counter = zoneComponent.counter + 1
        if zoneComponent.counter >= zoneComponent.spawnRate then
            self:spawnGroup(instance)
            zoneComponent.counter = 0
        end
    end
end

return SpawnZoneSystem