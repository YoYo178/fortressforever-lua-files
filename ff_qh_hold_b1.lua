-----------------------------------------------------------------------------
-- ff_qh_hold.lua
-- version: 1.1
-- Author: A1win
-- Editor: -_YoYo178_-
-- (Full credit to the main author A1win for creating this epic map!)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_quadhog")

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------

-- holdbasekit - contains 100 health, respawn time 5s.

-- holdarmorkit - contains 200 armor, respawn time 10s.

-- holdbasepack - contains 200 grenades ammo, 200 bullets, 200 nails, 200 shells,
-- 				  200 rockets, 200 cells, respawn time 5s.

-- holdhealthkit - contains 50 health, respawn time 20s.

-- holdammopack - contains 50 armor, 20 grenades ammo, 100 bullets, 100 nails,
--				  100 shells, 20 rockets, 100 cells, respawn time 20s.

-- holdgrenpack - contains 10 grenades ammo, 50 bullets, 50 shells, 50 nails,
--			  	  5 rockets, 50 cells, 1 primary grenade, 1 secondary grenade.
--				  respawn time 30s.

-----------------------------------------------------------------------------

holdbasekit = qhgenerickit:new({
	health = 100,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function holdbasekit:dropatspawn() return false end

holdarmorkit = qhgenerickit:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "ArmorKit.Touch",
	botgoaltype = Bot.kBackPack_Armor
})

function holdarmorkit:dropatspawn() return false end

blue_holdarmorkit = holdarmorkit:new({ modelskin = 0 })
red_holdarmorkit = holdarmorkit:new({ modelskin = 1 })
yellow_holdarmorkit = holdarmorkit:new({ modelskin = 3 })
green_holdarmorkit = holdarmorkit:new({ modelskin = 2 })

holdbasepack = qhgenerickit:new({
	grenades = 200,
	bullets = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdbasepack:dropatspawn() return false end

-- Outdoors:

-- Healthkits are located at the basements of the four small buildings at the corners of the Hold Area
holdhealthkit = qhgenerickit:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

function holdhealthkit:dropatspawn() return false end

-- Ammo packs are located inside the four small buildings at the corners of the Hold Area
holdammopack = qhgenerickit:new({
	armor = 50,
	grenades = 20,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 20,
	cells = 100,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdammopack:dropatspawn() return false end

-- Grenade packs are located under the water at the middle of the map.
holdgrenpack = qhgenerickit:new({
	grenades = 10,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 5,
	cells = 50,
	gren1 = 1,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function holdgrenpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_water = location_info:new({ text = "Water", team = Team.kUnassigned })

location_tower_blue = location_info:new({ text = "Blue Tower", team = QUADHUNTERS_TEAM })
location_trench_blue = location_info:new({ text = "Trench", team = QUADHUNTERS_TEAM })
location_ramp_blue = location_info:new({ text = "Ramp", team = QUADHUNTERS_TEAM })
location_pipe_blue = location_info:new({ text = "Water Access", team = QUADHUNTERS_TEAM })
location_base_blue = location_info:new({ text = "Blue Base", team = QUADHUNTERS_TEAM })
location_balcony_blue = location_info:new({ text = "Balcony", team = QUADHUNTERS_TEAM })
location_respawn_blue = location_info:new({ text = "Respawn Room", team = QUADHUNTERS_TEAM })

location_qharena = location_info:new({ text = "Quad Hog's Arena", team = QUADHOG_TEAM })
