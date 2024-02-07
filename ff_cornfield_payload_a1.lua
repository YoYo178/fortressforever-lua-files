
-- ff_cornfield_payload.lua

-- Payload gametype 

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_payload_2017");

---------------------------------------
-- globals 
---------------------------------------

max_train_progress = 512 -- approx. player*seconds it takes to reach the end of the line
cart_trigger = alpha_PushVolume
ROUND_TIME_LIMIT = 180  -- 3:00?
points_per_hold = 40

-- set teams
ATTACKERS = Team.kBlue
DEFENDERS = Team.kRed

---------------------
--Backpacks
---------------------

cornhealthkit = genericbackpack:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch"
})
cornarmorkit = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})
cornammopack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function cornammopack:dropatspawn() return false 
end

corngrenadepack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
