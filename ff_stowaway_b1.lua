-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

----
--ammo
----

stowpack = genericbackpack:new({
	health = 15,
	armor = 20,
	
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 90,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function stowpack:dropatspawn() return false end

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
	respawntime = 20,
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

lift_red = base_jump:new({ pushz = 850 })
lift_blue = base_jump:new({ pushz = 850 })




-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_midmap = location_info:new({ text = "Midmap", team = Team.kUnassigned })

location_blue_upperent = location_info:new({ text = "Upper Entrance", team = Team.kBlue })
location_red_upperent = location_info:new({ text = "Upper Entrance", team = Team.kRed })

location_blue_lowerent = location_info:new({ text = "Lower Entrance", team = Team.kBlue })
location_red_lowerent = location_info:new({ text = "Lower Entrance", team = Team.kRed })

location_blue_flagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })

location_blue_ramproom = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_red_ramproom = location_info:new({ text = "Ramp Room", team = Team.kRed })

location_blue_ramproom2 = location_info:new({ text = "Outside Ramp Room", team = Team.kBlue })
location_red_ramproom2 = location_info:new({ text = "Outside Ramp Room", team = Team.kRed })

location_blue_3bags = location_info:new({ text = "Three Bags", team = Team.kBlue })
location_red_3bags = location_info:new({ text = "Three Bags", team = Team.kRed })

location_blue_spawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_red_spawn = location_info:new({ text = "Respawn", team = Team.kRed })

location_blue_lift = location_info:new({ text = "Lift", team = Team.kBlue })
location_red_lift = location_info:new({ text = "Lift", team = Team.kRed })

location_blue_caves = location_info:new({ text = "Caves", team = Team.kBlue })
location_red_caves = location_info:new({ text = "Caves", team = Team.kRed })

location_blue_frpassage = location_info:new({ text = "Flag Room Passage", team = Team.kBlue })
location_red_frpassage = location_info:new({ text = "Flag Room Passage", team = Team.kRed })



-----------------------------------------------------------------------------
-- breakables
-----------------------------------------------------------------------------


base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate1", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
			if self.team_name == "red" then BroadCastMessage("RED GATE DESTROYED") end
			if self.team_name == "blue" then BroadCastMessage("BLUE GATE DESTROYED") end
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })

