-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_shutdown");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_LENGTH = 30;


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
-- security
-----------------------------------------------------------------------------
red_sec = red_security_trigger:new()
blue_sec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_secdoor")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Disable")
	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
	AddSchedule("beginclose"..team, SECURITY_LENGTH - 0, function()
		CloseDoor(team.."_secdoor")
	end)
end

local security_on_base = security_on
function security_on( team )
	security_on_base( team )

	CloseDoor(team.."_secdoor")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Enable")
end
-----------------------------------------------------------------------------
-- lasers and respawn shields
-----------------------------------------------------------------------------
blue_slayer = not_red_trigger:new()
red_slayer = not_blue_trigger:new()
sec_blue_slayer = not_red_trigger:new()
sec_red_slayer = not_blue_trigger:new()



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

lift_red = base_jump:new({ pushz = 825 })
lift_blue = base_jump:new({ pushz = 825 })


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
	health = 50,
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
	cells = 60,
	gren1 = 1,
	gren2 = 1,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_ammo = genericbackpack:new({
	health = 15,
	armor = 25,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 100,
	gren1 = 0,
	gren2 = 0,
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack_fr:dropatspawn() return false end
function aardvarkpack_ramp:dropatspawn() return false end
function aardvarkpack_sec:dropatspawn() return false end
function aardvarkpack_ammo:dropatspawn() return false end

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
		   aardvarkpack_sec:new({touchflags = tf}),
		   aardvarkpack_ammo:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack_fr, blue_aardvarkpack_ramp, blue_aardvarkpack_sec, blue_aardvarkpack_ammo = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_aardvarkpack_fr, red_aardvarkpack_ramp, red_aardvarkpack_sec, red_aardvarkpack_ammo = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack_fr, yellow_aardvarkpack_ramp, yellow_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack_fr, green_aardvarkpack_ramp, green_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})


-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kPyro))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kPyro) == false))) end

redspawn_balc = { validspawn = red_o_only }
redspawn_fr = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kPyro))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kPyro) == false))) end

bluespawn_balc = { validspawn = blue_o_only }
bluespawn_fr = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_redfd = location_info:new({ text = "Front Door", team = Team.kRed })
location_redfoyer = location_info:new({ text = "Foyer", team = Team.kRed })
location_redspawn_d = location_info:new({ text = "Top Respawn", team = Team.kRed })
location_redspawn_o = location_info:new({ text = "Bottom Respawn", team = Team.kRed })
location_redmain = location_info:new({ text = "Main Connector", team = Team.kRed })
location_redfr = location_info:new({ text = "Flagroom", team = Team.kRed })
location_redlft = location_info:new({ text = "Lift Coridor", team = Team.kRed })
location_redtp = location_info:new({ text = "Top Floor", team = Team.kRed })
location_redwtr = location_info:new({ text = "Water Passage", team = Team.kRed })
location_redwtrrmp = location_info:new({ text = "Water Ramp", team = Team.kRed })

location_bluefd = location_info:new({ text = "Front Door", team = Team.kBlue })
location_bluefoyer = location_info:new({ text = "Foyer", team = Team.kBlue })
location_bluespawn_d = location_info:new({ text = "Top Respawn", team = Team.kBlue })
location_bluespawn_o = location_info:new({ text = "Bottom Respawn", team = Team.kBlue })
location_bluemain = location_info:new({ text = "Main Connector", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_bluelft = location_info:new({ text = "Lift Coridor", team = Team.kBlue })
location_bluetp = location_info:new({ text = "Top Floor", team = Team.kBlue })
location_bluewtr = location_info:new({ text = "Water Passage", team = Team.kBlue })
location_bluewtrrmp = location_info:new({ text = "Water Ramp", team = Team.kBlue })



location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })


