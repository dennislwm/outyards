local targetDPS = 70
local fireRate = 2

return {
    id = "bowBluesteel",
    name = "Bluesteel Bow",
    tier = 4,

    equipmentType = "weapon",
    behaviorType = "gun",
    rendererType = "oneHandedWeapon",

    spriteSheet = "weapon",
    spriteCoords = Vector2.new(5,4),

    onlyOne = true,
    recipe = {
        ingotBluesteel = 8,
    },

    stats = {
        baseDamage = math.floor(targetDPS/fireRate),
    },

    metadata = {
        fireRate = fireRate,
        projectileType = "arrow",
        projectileCount = 1,
        projectileDeviation = 3,
    },

    tags = {
        "weapon",
        "ranged",
    },
}