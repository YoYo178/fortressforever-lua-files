IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_respawnturret");

---------------------------------

--Global-Overides For the Backpacks!!!
-----------------------------------
ammobackpack = genericbackpack:new({
        health = 50,
        armor = 60,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammobackpack:dropatspawn() return false end

-----------------------
grenadebackpack = genericbackpack:new({
	mancannons = 1,
	gren1 = 1,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function grenadebackpack:dropatspawn() return false end

-----------------------
red_ammobackpack = genericbackpack:new({
        health = 30,
        armor = 40,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 40,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function red_ammobackpack:dropatspawn() return false end

-----------------------

blue_ammobackpack = genericbackpack:new({
        health = 30,
        armor = 40,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 40,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function blue_ammobackpack:dropatspawn() return false end
---------------------------
--Your welcome Kube, <3 Partial--
---------------------------



