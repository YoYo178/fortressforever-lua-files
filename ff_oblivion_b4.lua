-----------------------------------------------------------------------------------------------------------------------------
-- INCLUDES
-----------------------------------------------------------------------------------------------------------------------------

IncludeScript("base_shutdown");
IncludeScript("base_location");

-----------------------------------------------------------------------------------------------------------------------------
-- CONSTANT!
-- I don't recommend changing this, as the in-game timer (above the FR door) will not change along with it.
-- Behaviour is undefined for values <= 10
-----------------------------------------------------------------------------------------------------------------------------

SECURITY_LENGTH = 40


-----------------------------------------------------------------------------
-- TOUCH RESUP
-- Brush volume which gives players health, ammo, etc...
-- Pretty much taken from ff_.lua
-----------------------------------------------------------------------------

touch_resup = trigger_ff_script:new({ team = Team.kUnassigned })

function touch_resup:ontouch( touch_entity )
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

blue_touch_resup = touch_resup:new({ team = Team.kBlue })
red_touch_resup = touch_resup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------


location_redfd = location_info:new({ text = "Foyer", team = Team.kRed })
location_redramp = location_info:new({ text = "Main Ramps", team = Team.kRed })
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redsec = location_info:new({ text = "Security Control", team = Team.kRed })
location_redsechall = location_info:new({ text = "Security Hall", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })

location_bluefd = location_info:new({ text = "Foyer", team = Team.kBlue })
location_blueramp = location_info:new({ text = "Main Ramps", team = Team.kBlue })
location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Security Control", team = Team.kBlue })
location_bluesechall = location_info:new({ text = "Security Hall", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })


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
	cells = 130,
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
	gren1 = 2,
	gren2 = 0,
	respawntime = 40,
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
-- SPAWN PROTECTION
-- kills those who wander into the enemy spawn
-----------------------------------------------------------------------------

red_spawn_protection = not_red_trigger:new()
blue_spawn_protection = not_blue_trigger:new()

-----------------------------------------------------------------------------
-- OFFENSIVE AND DEFENSIVE SPAWNS
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Copied from ff_session.lua
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
--  AND THEN, SOME MORE STUFF...
-----------------------------------------------------------------------------

red_window_clip = trigger_ff_clip:new({ clipflags = {
ClipFlags.kClipAllPlayers, ClipFlags.kClipAllProjectiles,
ClipFlags.kClipAllBullets,ClipFlags.kClipAllGrenades } })

blue_window_clip = trigger_ff_clip:new({ clipflags = {
ClipFlags.kClipAllPlayers, ClipFlags.kClipAllProjectiles,
ClipFlags.kClipAllBullets,ClipFlags.kClipAllGrenades } })

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
	AddSchedule("beginclose"..team, SECURITY_LENGTH - 6, function()
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

grp = bigpack:new({
materializesound="Item.Materialize",
gren1=4,gren2=4,model=
"models/items/backpack/backpack.mdl",
respawntime=1,touchsound="Backpack.Touch"})
function grp:dropatspawn() return false end

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

red_security_hurt2 = not_red_trigger:new({})
blue_security_hurt2 = not_blue_trigger:new({})