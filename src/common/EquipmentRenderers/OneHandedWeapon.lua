local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage.common
local util = common.util

local getItemModel = require(util.getItemModel)

local renderer = {
    id = "oneHandedWeapon"
}

function renderer:create()
    local character = self.player.character or self.player.CharacterAdded:wait()
    local weaponModel = getItemModel(self.itemId)
    local rightHand = character:WaitForChild("RightHand")
    local gripAttachment = weaponModel:FindFirstChild("grip")
    assert(gripAttachment, "no grip for model: "..self.itemId)

    local transparencyLock = Instance.new("BoolValue")
    transparencyLock.Name = "TransparencyLock"
    transparencyLock.Value = true
    transparencyLock.Parent = weaponModel

    local weld = Instance.new("ManualWeld")
    weld.Part0 = weaponModel
    weld.Part1 = rightHand

    weld.C0 = gripAttachment.CFrame
    weld.C1 = rightHand:WaitForChild("RightGripAttachment").CFrame

    weaponModel.Parent = character
    weaponModel.Anchored = false
    weaponModel.CanCollide = false
    weld.Parent = weaponModel

    self.model = weaponModel
end

function renderer:destroy()
    if self.model then
        self.model:destroy()
    end
end

return renderer