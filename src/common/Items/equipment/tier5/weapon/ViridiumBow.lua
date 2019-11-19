local targetDPS = 120
local fireRate = 2

return {
    id = "viridiumBow",
    name = "Viridium Bow",
    tier = 5,

    equipmentType = "weapon",
    behaviorType = "gun",
    rendererType = "oneHandedWeapon",

    spriteSheet = "weapon",
    spriteCoords = Vector2.new(6,4),

    onlyOne = true,
    recipe = {
        viridiumIngot = 8,
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