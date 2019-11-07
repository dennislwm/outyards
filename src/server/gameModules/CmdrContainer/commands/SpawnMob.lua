return {
	Name = "spawnMob";
	Aliases = {};
	Description = "Spawns a mob above you";
	Group = "Admin";
	Args = {
		{
			Type = "npcType";
			Name = "npcType";
			Description = "Mob type to spawn";
		},
		{
			Type = "integer";
			Name = "quantity";
			Description = "How many npcs to spawn";
			Default = 1;
		},
	};
}