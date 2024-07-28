-- ff_basedon.lua
-- edit of ff_bases rehashed for SlaughterBall
-- thank you FF devs for the immaculately detailed original
-- edited by [MAIL]}} soap breaker a.k.a. gumbuk 9


IncludeScript("base_slaughterball")

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------

BALL_RETURN_TIME = 5 -- the time it takes the ball to return after dropped
SCORE_TIME = 10 -- the interval in seconds to hand out score while ball is held
ADD_POINTS = 5 -- how many team points to hand out
POINT_MULTIPLIER = 10 -- how many fortpoints (player score) to hand out
HUD_BALLNAME = "slaughterball"

-----------------------------------------------------------------------------
-- Entities
-----------------------------------------------------------------------------

----==== Return Positions
rpos_flagroom = base_returnpos:new({ ico_dir = "maps/ff_basedon/rpos_flagroom.vtf", loc_str = "1. Flagroom", area_ref = "location_salvaged_flagroom" })
rpos_midroom = base_returnpos:new({ ico_dir = "maps/ff_basedon/rpos_middle.vtf", loc_str = "2. Middle Room", area_ref = "location_salvaged_midramps" })
rpos_salvbalc = base_returnpos:new({ ico_dir = "maps/ff_basedon/rpos_salvbalc.vtf", loc_str = "3. Salvage Balcony", area_ref = "location_salvaged_balcony" })
rpos_abanbalc = base_returnpos:new({ ico_dir = "maps/ff_basedon/rpos_abanbalc.vtf", loc_str = "4. Abandon Balcony", area_ref = "location_abandoned_balcony" })

----==== Areas
-- areas are all red but with the unassigned team because renaming the triggers is long :[
-- i'll do it later, if you see this it means i'm either dead and my hardrive got archived
-- or i forgot and didn't do it somehow 
-- either way i relesaed the files too early
location_midmap = base_area:new({ text = "Yard", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_yard.vtf" })
location_water = base_area:new({ text = "Water", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_yard.vtf" })

location_salvaged_bments = base_area:new({ text = "Salvage Battlements", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_balcony.vtf" })
location_salvaged_balcony = base_area:new({ text = "Salvage Balcony", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_balcony.vtf" })
location_salvaged_frontdoor = base_area:new({ text = "Salvage Front Door", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_yard.vtf" })
location_salvaged_frontdoor_ramp = base_area:new({ text = "Salvage Front Door Ramp", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_groundfloor.vtf" })
location_salvaged_midramps = base_area:new({ text = "Salvage Mid Ramps", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_middleroom.vtf" })
location_salvaged_midramps_top = base_area:new({ text = "Salvage Mid Ramps Top", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_middleroom.vtf" })
location_salvaged_midramps_left = base_area:new({ text = "Salvage Right Ramp", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_middleroom.vtf" })
location_salvaged_midramps_right = base_area:new({ text = "Salvage Left Ramp", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_middleroom.vtf" })
location_salvaged_flagroom = base_area:new({ text = "Salvage Flag Room", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_flagroom.vtf" })
location_salvaged_sniperdeck = base_area:new({ text = "Salvage Sniper Deck", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_balcony.vtf" })
location_salvaged_ramproom = base_area:new({ text = "Salvage Main Room", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_ramproom.vtf" })
location_salvaged_lower = base_area:new({ text = "Salvage Lower Level", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_groundfloor.vtf" })
location_salvaged_upper = base_area:new({ text = "Salvage Upper Level", team = Team.kUnassigned, ico_dir = "slaughterball/location_default.vtf" })
location_salvaged_airlift = base_area:new({ text = "Salvage Air Lift", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_elevator.vtf" })
location_salvaged_lowerladder = base_area:new({ text = "Salvage Lower Ladder to Ramp Room", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_groundfloor.vtf" })
location_salvaged_rightcorridoor = base_area:new({ text = "Salvage Left Corridor", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_righthall.vtf" })
location_salvaged_leftcorridoor = base_area:new({ text = "Salvage Right Corridor", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_lefthall.vtf" })
location_salvaged_rightresupply = base_area:new({ text = "Salvage Left Respawn", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_righthall.vtf" })
location_salvaged_leftresupply = base_area:new({ text = "Salvage Right Respawn", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_lefthall.vtf" })
location_salvaged_leftspawn = base_area:new({ text = "Salvage Left Respawn", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_lefthall.vtf" })
location_salvaged_secret = base_area:new({ text = "Salvage Secret Passage", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_elevator.vtf" })
location_salvaged_flagroom_passage = base_area:new({ text = "Salvage Flagroom Hole Access Passage", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_elevator.vtf" })
location_salvaged_flagroom_ramp = base_area:new({ text = "Salvage Flag Room Ramp", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_flagroom.vtf" })
location_salvaged_water_entry = base_area:new({ text = "Salvage Water Entrance", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_watertunnels.vtf" })
location_salvaged_water_exit = base_area:new({ text = "Salvage Water Exit", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_watertunnels.vtf" })
location_salvaged_water_access = base_area:new({ text = "Salvage Water Access", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_waterroom.vtf" })

location_abandoned_sniperdeck = base_area:new({ text = "Abandon Sniper Deck", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_abandon.vtf" })
location_abandoned_frontdoor = base_area:new({ text = "Abandon Front Door", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_abandon.vtf" })
location_abandoned_balcony = base_area:new({ text = "Abandon Balcony", team = Team.kUnassigned, ico_dir = "maps/ff_basedon/area_abandon.vtf" })

slaughterball = base_ball:new({ lastreturn = rpos_flagroom, lastarea = location_salvaged_flagroom })

----==== Pickups
pack_general = everyonepack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	
	health = 75,
	armor = 25,
	shells = 35,
	nails = 75,
	rockets = 8,
	gren1 = 1,
	cells = 100,
	
	respawntime = 15
})

pack_small = everyonepack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	
	health = 25,
	armor = 25,
	shells = 35,
	nails = 75,
	rockets = 2,
	cells = 45,
	
	respawntime = 10
})

armor_general = noballpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	modelskin = 0,
	
	health = 90,
	armor = 90,
	gren1 = 1,
	
	respawntime = 20
})

armor_grenade = noballpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	modelskin = 1,
	
	health = 0,
	armor = 0,
	gren1 = 3,
	gren2 = 2,
	
	respawntime = 25
})

armor_technical = noballpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	modelskin = 3,
	
	health = 0,
	armor = 100,
	shells = 80,
	nails = 100,
	rockets = 16,
	cells = 200,
	gren2 = 1,
	
	respawntime = 25
})

healthkit = noballpack:new({
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	
	health = 100,
	armor = 0,
	gren1 = 0,

	respawntime = 20,
})

function healthkit:dropatspawn() return true end