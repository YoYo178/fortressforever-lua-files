-- WELCOME TO BACONBOWL
-- NEON

IncludeScript( "base_ctf" );

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- Bag One
-----------------------------------------------------------------------------

bagone = genericbackpack:new( {
	health = 50,
	armor = 100,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 150,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
} )

function bagone:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Bag Two
-----------------------------------------------------------------------------

bagtwo = genericbackpack:new({
	health = 100,
	armor = 300,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 150,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function bagtwo:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Small Bag
-----------------------------------------------------------------------------

smallbag = genericbackpack:new({
	health = 25,
	armor = 45,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 50,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function smallbag:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Grenade Bag
-----------------------------------------------------------------------------

grenadebag = genericbackpack:new({
	health = 100,
	armor = 300,
	nails = 400,
	shells = 400,
	rockets = 400,
	gren1 = 2,
	gren2 = 2,
	respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function grenadebag:dropatspawn() return false end