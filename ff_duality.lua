-- ff_duality.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_ctf")
IncludeScript("base_location");

POINTS_PER_CAPTURE = 1

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------
blue_spawnammobackpack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 25,
	bullets = 40,
	nails = 100,
	shells = 40,
	rockets = 25,
	cells = 100,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

red_spawnammobackpack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 25,
	bullets = 40,
	nails = 100,
	shells = 40,
	rockets = 25,
	cells = 100,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

blue_grenbackpack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 25,
	bullets = 40,
	nails = 100,
	shells = 40,
	rockets = 25,
	cells = 100,
	gren1 = 4,
	gren2 = 4,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Grenades
})

red_grenbackpack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 25,
	bullets = 40,
	nails = 100,
	shells = 40,
	rockets = 25,
	cells = 100,
	gren1 = 4,
	gren2 = 4,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Grenades
})

waterammobackpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 25,
	bullets = 25,
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 100,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

blue_flagammobackpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 25,
	bullets = 25,
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 100,
	respawntime = 12,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

red_flagammobackpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 25,
	bullets = 25,
	nails = 50,
	shells = 20,
	rockets = 10,
	cells = 100,
	respawntime = 12,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

-----------------------------------------------------------------------------
-- Lifts
-----------------------------------------------------------------------------
func_door = trigger_ff_script:new({ team = Team.kUnassigned })

function func_door:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function func_door:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDELEVATOR" )
	end
end

blue_lift = func_door:new({ team = Team.kBlue })
red_lift = func_door:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Respawn lasers
-----------------------------------------------------------------------------
respawn_lasers = trigger_ff_script:new({ team = Team.kUnassigned })

function respawn_lasers:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = respawn_lasers:new({ team = Team.kBlue })
red_slayer = respawn_lasers:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_blueramproom1 = location_info:new({ text = "1st ramp room", team = Team.kBlue })
location_blueramproom2 = location_info:new({ text = "2nd ramp room", team = Team.kBlue })
location_blueentrancecorridor = location_info:new({ text = "Entrance corridor", team = Team.kBlue })
location_bluespawn = location_info:new({ text = "Spawn room", team = Team.kBlue })
location_bluespiral = location_info:new({ text = "Spiral", team = Team.kBlue })
location_blueliftaccess = location_info:new({ text = "Lift access", team = Team.kBlue })
location_bluebasement = location_info:new({ text = "Basement", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Flag room", team = Team.kBlue })
location_bluebasementcorridor = location_info:new({ text = "Basement corridor", team = Team.kBlue })
location_bluewaterrouteexit = location_info:new({ text = "Water route exit", team = Team.kBlue })
location_bluewaterroute = location_info:new({ text = "Water route", team = Team.kBlue })

location_redramproom1 = location_info:new({ text = "1st ramp room", team = Team.kRed })
location_redramproom2 = location_info:new({ text = "2nd ramp room", team = Team.kRed })
location_redentrancecorridor = location_info:new({ text = "Entrance corridor", team = Team.kRed })
location_redspawn = location_info:new({ text = "Spawn room", team = Team.kRed })
location_redspiral = location_info:new({ text = "Spiral", team = Team.kRed })
location_redliftaccess = location_info:new({ text = "Lift access", team = Team.kRed })
location_redbasement = location_info:new({ text = "Basement", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Flag room", team = Team.kRed })
location_redbasementcorridor = location_info:new({ text = "Basement corridor", team = Team.kRed })
location_redwaterrouteexit = location_info:new({ text = "Water route exit", team = Team.kRed })
location_redwaterroute = location_info:new({ text = "Water route", team = Team.kRed })

location_yard = location_info:new({ text = "Yard", team = NO_TEAM })