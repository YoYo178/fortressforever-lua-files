
-- ff_avanti_payload.lua

-- Payload gametype 

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_payload_thomas");

---------------------------------------
-- globals 
---------------------------------------

max_train_progress = 512 -- approx. player*seconds it takes to reach the end of the line
cart_trigger = alpha_PushVolume
ROUND_TIME_LIMIT = 120  -- 3:00?
points_per_hold = 40

-- set teams
ATTACKERS = Team.kBlue
DEFENDERS = Team.kRed

---------------------
--Backpacks
---------------------
genpack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 120,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack:dropatspawn() return false 
end

genpack_grenpack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 120,
	mancannons = 0,
	gren1 = 2,
	gren2 = 1,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack_grenpack:dropatspawn() return false 
end

