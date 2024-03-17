IncludeScript("base_ctf");
IncludeScript("base_teamplay")
IncludeScript("base_location");
IncludeScript("base_respawnturret");

------------------------------
-- Ammo pack setup
------------------------------

ff_casbah_grenades = genericbackpack:new({
	respawntime = 30,
	
	shells = 50,
	cells = 50,
	rockets = 20,
	nails = 50,
	
	gren1 = 4,
	gren2 = 4,
	
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_casbah_grenades:dropatspawn() return false end
ff_casbah_grenades_blue = ff_casbah_grenades:new({ team = Team.kBlue })
ff_casbah_grenades_red = ff_casbah_grenades:new({ team = Team.kRed })

ff_casbah_resupply = genericbackpack:new({
	respawntime = 5,
	
	health = 50,
	armor = 50,
	
	shells = 50,
	cells = 50,
	rockets = 20,
	nails = 50,
	
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_casbah_resupply:dropatspawn() return false end
ff_casbah_resupply_blue = ff_casbah_resupply:new({ team = Team.kBlue })
ff_casbah_resupply_red = ff_casbah_resupply:new({ team = Team.kRed })