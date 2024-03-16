IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

red_pack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
      cells = 200,
	armor = 100,
	health = 50,
      respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function red_pack:dropatspawn() return false end

blue_pack = genericbackpack:new({
	grenades = 100,
	bullets = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	gren1 = 0,
	gren2 = 0,
      cells = 130,
	armor = 100,
	health = 50,
      respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function blue_pack:dropatspawn() return false end

-------------------
--Spawns
---------------
redspawn_offense = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end

redspawn_defense = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSniper ) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kSoldier))) end

bluespawn_offense = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end

bluespawn_defense = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSniper ) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kSoldier))) end

redspawn_offense = { validspawn = redspawn_offense }
redspawn_defense  = { validspawn = redspawn_defense }
bluespawn_offense = { validspawn = bluespawn_offense }
bluespawn_defense  = { validspawn = bluespawn_defense }


