
-- ff_siden_b2.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;

-----------------------------------------------------------------------------
-- siden resupply
-----------------------------------------------------------------------------
sidenresup = trigger_ff_script:new({ team = Team.kUnassigned })

function sidenresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_sidenresup = sidenresup:new({ team = Team.kBlue })
red_sidenresup = sidenresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- siden shield
-----------------------------------------------------------------------------
sidenshield = trigger_ff_script:new({ team = Team.kUnassigned })
function sidenshield:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

blue_sidenshield = sidenshield:new({ team = Team.kRed })
red_sidenshield = sidenshield:new({ team = Team.kBlue })
-----------------------------------------------------------------------------
-- sidenpack -- has a bit of everything (excluding grens) (backpack-based)
-----------------------------------------------------------------------------
sidenpack = genericbackpack:new({
	health = 100,
	armor = 100,
	grenades = 20,
	bullets = 150,
	nails = 150,
	shells = 100,
	rockets = 25,
	cells = 100,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function sidenpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- sidengrepack -- has a bit of everything (excluding grens) (backpack-based)
-----------------------------------------------------------------------------
sidengrepack = genericbackpack:new({
	gren1 = 1,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 60,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function sidengrepack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup
-----------------------------------------------------------------------------
function siden_build_backpacks(tf)
	return sidenpack:new({touchflags = tf}),
		   sidengrepack:new({touchflags = tf})
end

blue_sidenpack, blue_sidengrepack = siden_build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_sidenpack, red_sidengrepack = siden_build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})

-----------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------
