IncludeScript( "base_arena" )


SPEED_MODIFIER = 1.5 -- multiplier for player running speed
FRICTION_MODIFIER = 0.6 -- multiplier for player ground friction
GRAVITY_MODIFIER = 1 -- multiplier for player gravity
BLASTJUMP_MODIFIER = Vector( 1.2, 1.2, 1.6 ) -- multiplier for self knockback
BLASTJUMP_DAMAGE = 0 -- multiplier for self damage

ENABLE_PICKUPS = true -- enable spawning items mid match
ENABLE_VAMPIRE = false -- players gain health back on kill
VAMPIRE_HEALTH = 30 -- points of health to give when vampirism is enabled

DAMAGE_TABLE = {
	Damage.kCrush,
	Damage.kDrown,
	Damage.kShock
}

TEAM_LIMITS = { bl = 0, rd = -1, yl = -1, gr = 0 }


healthpack_return = 50
armorpack_return = 50
allpack_return = 90
ammo_return = 30


healthpack = optionalbackpack:new({
	health = 35,
	respawntime = healthpack_return,
	model = "models/items/armour/armour.mdl",
	modelskin = 1,
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch"
})

armorpack = optionalbackpack:new({
	armor = 60,
	respawntime = armorpack_return,
	model = "models/items/armour/armour.mdl",
	modelskin = 2,
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch"
})

allpack = optionalbackpack:new({
	health = 50,
	armor = 40,
	gren1 = 2,
	respawntime = allpack_return,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch"
})


ammopack = optionalbackpack:new({
	shells = 80,
	rockets = 30,
	respawntime = smallpack_return,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})