-- high_Flag
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript( "base_ctf" );

-----------------------------------------------------------------------------
--lzr killer 
-- must be trigger_hurt
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- blue_slayer KILLS red

red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })


-----------------------------------------------------------------------------
-- touch resupply
-----------------------------------------------------------------------------
supply = trigger_ff_script:new({ team = Team.kUnassigned })

function supply:ontouch( touch_entity )
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

blue_supply = supply:new({ team = Team.kBlue })
red_supply = supply:new({ team = Team.kRed })
-----------------------------------------------------------------------------
-- Ammo bag
-----------------------------------------------------------------------------
ammo = genericbackpack:new({
    respawntime = 30,
	health = 25,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function ammo :dropatspawn() return false end

red_ammo = ammo:new({ touchflags = {AllowFlags.kRed} })
blue_ammo = ammo:new({ touchflags = {AllowFlags.kBlue} })
---------------------------------
-- Packsnormal
---------------------------------

pack = genericbackpack:new({
	health = 45,
	armor = 20,
	grenades = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 120,
	mancannons = 1,
	gren1 = 1,
	gren2 = 0,
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

redngbag = pack:new({ touchflags = {AllowFlags.kRed} })
bluengbag = pack:new({ touchflags = {AllowFlags.kBlue} })