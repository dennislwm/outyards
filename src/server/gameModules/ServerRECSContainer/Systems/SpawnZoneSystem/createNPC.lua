local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage:WaitForChild("common")

local ParticleCreator = require(common:WaitForChild("ParticleCreator"))
local NPCS = require(common:WaitForChild("NPCS"))
local RecsComponents = require(common:WaitForChild("RecsComponents"))

local errors = {
    invalidMob = "Invalid NPC type [%s]!"
}

return function(recsCore, npcType, cframe)
    local mobDesc = NPCS.byType[npcType]
    assert(mobDesc, errors.invalidMob:format(npcType))

    local newNPCPart = Instance.new("Part")
    newNPCPart.CastShadow = false
    newNPCPart.TopSurface = Enum.SurfaceType.Smooth
    newNPCPart.BottomSurface = Enum.SurfaceType.Smooth
    newNPCPart.Size = mobDesc.boundingBoxProps.Size
    newNPCPart.Color= mobDesc.boundingBoxProps.Color
    newNPCPart.Transparency = 0.5
    newNPCPart.CFrame = cframe * CFrame.new(0,(newNPCPart.Size.Y/2), 0)
    newNPCPart.CFrame = newNPCPart.CFrame * CFrame.Angles(0,math.random()*2*math.pi,0)

    local physProps = PhysicalProperties.new(1,0,0.5,100,100)
    newNPCPart.CustomPhysicalProperties = physProps

    newNPCPart.Parent = workspace
    newNPCPart:SetNetworkOwner()

    recsCore:addComponent(newNPCPart,RecsComponents.NPC, {npcType = npcType})

    ParticleCreator.spawnParticle("smoke",{
        amount = 6,
        scale = 1,
        cFrame = newNPCPart.CFrame,
    })

    return newNPCPart
end