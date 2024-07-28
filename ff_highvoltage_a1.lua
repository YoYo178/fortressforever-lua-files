-- ff_highvoltage_a1.lua
-- based on openfire 10/07/23 (mm/dd/yyyy)

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base")
IncludeScript("base_ctf")
IncludeScript("base_location");

function startup()
	-- set up team limits (only yellow & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kBlue, "Blue Orcas" )
	SetTeamName( Team.kYellow, "Yellow Llamas" )
end

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_LENGTH = 30;

-----------------------------------------------------------------------------
-- unique high voltage locations
-----------------------------------------------------------------------------
location_yellowspawn = location_info:new({ text = "Respawn", team = Team.kYellow })
location_yellowfr = location_info:new({ text = "Flag Room", team = Team.kYellow })

location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })

-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------
blue_only = bluerespawndoor
yellow_only = yellowrespawndoor

-----------------------------------------------------------------------------
-- voltage
-----------------------------------------------------------------------------

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
yellow_aardvarkresup = aardvarkresup:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- lasers, and respawn shields
-----------------------------------------------------------------------------
blue_slayer = not_yellow_trigger:new()
yellow_slayer = not_blue_trigger:new()

-----------------------------------------------------------------------------
-- custom openfire pack
-----------------------------------------------------------------------------
aardvarkpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpack)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
yellow_o_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
yellow_d_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

yellowspawn_o = { validspawn = yellow_o_only }
yellowspawn_d = { validspawn = yellow_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

bluespawn_o = { validspawn = blue_o_only }
bluespawn_d = { validspawn = blue_d_only }
