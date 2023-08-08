-- base_shutdown.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;

-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------
function startup()

	SetGameDescription( "Capture the Flag" )
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	
end

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------

KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })


------------------------------------------------------My lua below
--IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- Resupply and Bags
-----------------------------------------------------------------------------

aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })
function aardvarkresup:ontouch( touch_entity )
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

grenadebag = genericbackpack:new({
	grenades = 0,
	bullets = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	gren1 = 2,
	gren2 = 2,
	cells = 0,
	armor = 0,
	health = 0,
      respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
})

topbag = genericbackpack:new({
	grenades = 0,
	bullets = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	gren1 = 1,
	gren2 = 1,
	cells = 0,
	armor = 20,
	health = 20,
      respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
})

flagroombag_blue = genericbackpack:new({
	grenades = 0,
	bullets = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	gren1 = 0,
	gren2 = 0,
	cells = 100,
	armor = 30,
	health = 50,
      respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
})

flagroombag_red = genericbackpack:new({
	grenades = 0,
	bullets = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	gren1 = 0,
	gren2 = 0,
	cells = 100,
	armor = 30,
	health = 50,
      respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
})

blue_supply = aardvarkresup:new({ team = Team.kBlue })
red_supply = aardvarkresup:new({ team = Team.kRed })

blue_grenadebackpack = grenadebag:new({ team = Team.kBlue })
red_grenadebackpack = grenadebag:new({ team = Team.kRed })

blue_topbag = topbag:new({ team = Team.kBlue })
red_topbag = topbag:new({ team = Team.kRed })

blue_flagroombag_1 = flagroombag_blue:new({ team = Team.kBlue })
blue_flagroombag_2 = flagroombag_blue:new({ team = Team.kBlue })
red_flagroombag_1 = flagroombag_red:new({ team = Team.kRed })
red_flagroombag_2 = flagroombag_red:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------

blue_only = function(self,player) return ((player:GetTeamId() == Team.kBlue)) end
blue_spawn = { validspawn = blue_only }

red_only = function(self,player) return ((player:GetTeamId() == Team.kRed)) end

red_spawn = { validspawn = red_only }