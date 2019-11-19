local targetDPS = 24
local fireRate = 1.5

return {
    id = "ironBow",
    name = "Iron Bow",
    tier = 2,

    equipmentType = "weapon",
    behaviorType = "gun",
    rendererType = "oneHandedWeapon",

    spriteSheet = "weapon",
    spriteCoords = Vector2.new(3,4),

    onlyOne = true,
    recipe = {
        ironIngot = 8,
    },

    stats = {
        damageType = "ranged",
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