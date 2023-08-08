-----------------------------------------------------------------------------
-- conc_adam.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

function player_onconc()
	if CONC_EFFECT == 0 then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

grenadebackpack = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 4,
	gren2 = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function grenadebackpack:dropatspawn() return false end
