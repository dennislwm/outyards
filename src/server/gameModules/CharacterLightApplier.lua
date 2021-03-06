local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local common = ReplicatedStorage.common
local lib = ReplicatedStorage.lib
local event = ReplicatedStorage.event

local PizzaAlpaca = require(lib.PizzaAlpaca)

local CharacterLightApplier = PizzaAlpaca.GameModule:extend("CharacterLightApplier")

local function addLight(character)
    local newLight = Instance.new("PointLight")
    newLight.Parent = character:WaitForChild("HumanoidRootPart")
end

local function playerAdded(player)
    player.CharacterAdded:connect(addLight)
    if player.Character then
        addLight(player)
    end
end

function CharacterLightApplier:init()
    Players.PlayerAdded:Connect(function(player)
        playerAdded(player)
    end)

    for _, player in pairs(Players:GetPlayers()) do
        playerAdded(player)
    end
end

function CharacterLightApplier:postInit()
end

return CharacterLightApplier