-- base_shutdown.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_shutdown");
IncludeScript("base_location");
--IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_TIME = 30;

-----------------------------------------------------------------------------
-- bagless resupply
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

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- class limits
-----------------------------------------------------------------------------
function startup()

	SetGameDescription( "Capture the Flag" )
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)
	
	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)

end

-----------------------------------------------------------------------------
-- lasers
-----------------------------------------------------------------------------
blue_slayer = not_red_trigger:new()
red_slayer = not_blue_trigger:new()

-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------

--Red Team
redspawn_offense = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kPyro))) end
redspawn_defense_soldier 	= function(self,player) return ((player:GetTeamId() == Team.kRed ) and (player:GetClass() == Player.kSoldier)) end
redspawn_defense_engineer 	= function(self,player) return ((player:GetTeamId() == Team.kRed ) and (player:GetClass() == Player.kEngineer)) end
redspawn_defense_heavy 		= function(self,player) return ((player:GetTeamId() == Team.kRed ) and (player:GetClass() == Player.kHwguy)) end
redspawn_defense_demoman 	= function(self,player) return ((player:GetTeamId() == Team.kRed ) and (player:GetClass() == Player.kDemoman)) end

redspawn_offense 			= { validspawn = redspawn_offense }
redspawn_defense_soldier 	= { validspawn = redspawn_defense_soldier }
redspawn_defense_engineer 	= { validspawn = redspawn_defense_engineer }
redspawn_defense_heavy 		= { validspawn = redspawn_defense_heavy }
redspawn_defense_demoman 	= { validspawn = redspawn_defense_demoman }

--Blue Team
bluespawn_offense = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kPyro))) end
bluespawn_defense_soldier 	= function(self,player) return ((player:GetTeamId() == Team.kBlue ) and (player:GetClass() == Player.kSoldier)) end
bluespawn_defense_engineer 	= function(self,player) return ((player:GetTeamId() == Team.kBlue ) and (player:GetClass() == Player.kEngineer)) end
bluespawn_defense_heavy 	= function(self,player) return ((player:GetTeamId() == Team.kBlue ) and (player:GetClass() == Player.kHwguy)) end
bluespawn_defense_demoman 	= function(self,player) return ((player:GetTeamId() == Team.kBlue ) and (player:GetClass() == Player.kDemoman)) end

bluespawn_offense 			= { validspawn = bluespawn_offense }
bluespawn_defense_soldier 	= { validspawn = bluespawn_defense_soldier }
bluespawn_defense_engineer 	= { validspawn = bluespawn_defense_engineer }
bluespawn_defense_heavy 	= { validspawn = bluespawn_defense_heavy }
bluespawn_defense_demoman 	= { validspawn = bluespawn_defense_demoman }

-----------------------------------------------------------------------------
-- custom packs
-----------------------------------------------------------------------------
aardvarkpack_fr = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_ramp = genericbackpack:new({
	health = 80,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_sec = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack_fr:dropatspawn() return false end
function aardvarkpack_ramp:dropatspawn() return false end
function aardvarkpack_sec:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpacks)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack_fr:new({touchflags = tf}),
		   aardvarkpack_ramp:new({touchflags = tf}),
		   aardvarkpack_sec:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack_fr, blue_aardvarkpack_ramp, blue_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_aardvarkpack_fr, red_aardvarkpack_ramp, red_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack_fr, yellow_aardvarkpack_ramp, yellow_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack_fr, green_aardvarkpack_ramp, green_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- bouncepads for lifts
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 800 })
lift_blue = base_jump:new({ pushz = 800 })
lift_red_base = base_jump:new({ pushz = 600 })
lift_blue_base = base_jump:new({ pushz = 600 })