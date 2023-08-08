-----------------------------------------------------------------------------
--conc_adam2_r.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_location");
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
	health = 200,
	armor = 150,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 4,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function grenadebackpack:dropatspawn() return false end

function startup()
	SetTeamName(Team.kBlue, "Conc Jumpers")

	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam(Team.kBlue)
	team:SetAllies(Team.kRed)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kSniper, 0)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kDemoman, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kPyro, 0)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kEngineer, 0)
	team:SetClassLimit(Player.kCivilian, 0)
end