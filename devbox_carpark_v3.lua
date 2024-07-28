IncludeScript( "base_arena" )


SPEED_MODIFIER = 1.5 -- multiplier for player running speed
FRICTION_MODIFIER = 0.8 -- multiplier for player ground friction
GRAVITY_MODIFIER = 1 -- multiplier for player gravity
BLASTJUMP_MODIFIER = Vector( 1.2, 1.2, 1.6 ) -- multiplier for self knockback
BLASTJUMP_DAMAGE = 0 -- multiplier for self damage

ENABLE_PICKUPS = true -- enable spawning items mid match
DELAY_PICKUPS = 70 -- in seconds, time to withhold pickups from spawning

ENABLE_VAMPIRE = false -- players gain health back on kill
VAMPIRE_HEALTH = 30 -- points of health to give when vampirism is enabled

DAMAGE_TABLE = {
	Damage.kCrush,
	Damage.kDrown,
	Damage.kShock
}

TEAM_LIMITS = { bl = -1, rd = -1, yl = 0, gr = 0 }

smallpack_return = 50
bigpack_return = 90

sjet_shaft = upjet_simple:new({ force = Vector( 0, 0, 900 ), exponent = 0.6 })
sjet_left = upjet_simple:new({ force = Vector( -800, 0, 800 ), exponent = 0.6 })
sjet_right = upjet_simple:new({ force = Vector( 800, 0, 800 ), exponent = 0.6 })

smallpack = optionalbackpack:new({
	health = 15,
	armor = 40,
	respawntime = smallpack_return,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

bigpack = optionalbackpack:new({
	health = 50,
	armor = 80,
	gren1 = 2,
	respawntime = bigpack_return,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch"
})


----====---- extra spawnpoints
-- porting this from base_arena for safety cause servers may not have mode updated
agnosticallowedmethod = function(self,player) return player:GetTeamId() ~= Team.kSpectator end
spectatorallowedmethod = function(self,player) return player:GetTeamId() == Team.kSpectator end

agnosticspawn = { validspawn = agnosticallowedmethod }
spectatorspawn = { validspawn = spectatorallowedmethod }

agnostic_spawn = agnosticspawn; spectator_spawn = spectatorspawn