
-- ff_oppose_b1.lua
-- Created by exoskeletaL, polished by NeoNL

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------


POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
--Spawn Clips
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

red_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
blue_clip = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })

-----------------------------------------------------------------------------
--health
-----------------------------------------------------------------------------
resup = trigger_ff_script:new({ team = Team.kUnassigned })

function resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

bluehealth = resup:new({ team = Team.kBlue })
redhealth = resup:new({ team = Team.kRed })

---------------------------------
-- Packsnormal
---------------------------------

pack = genericbackpack:new({
	health = 30,
	armor = 20,
	grenades = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	mancannons = 1,
	gren1 = 1,
	gren2 = 0,
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

red_pack = pack:new({ touchflags = {AllowFlags.kRed} })
blue_pack = pack:new({ touchflags = {AllowFlags.kBlue} })

---------------------------------
-- Packs nade
---------------------------------

packnade = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 90,
	nails = 90,
	shells = 90,
	rockets = 90,
	cells = 200,
	gren1 = 2,
	gren2 = 2,
	respawntime = 60,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

fullnades_red = packnade:new({ touchflags = {AllowFlags.kRed} })
fullnades_blue = packnade:new({ touchflags = {AllowFlags.kBlue} })

-------------------
--Spawns
-------------------

redoffensespawn = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end

reddefensespawn = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSniper ) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kSoldier))) end

blueoffensespawn = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end

bluedefensespawn = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kEngineer) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kSniper ) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kSoldier))) end

redoffensespawn = { validspawn = redoffensespawn }
reddefensespawn = { validspawn = reddefensespawn }
blueoffensespawn = { validspawn = blueoffensespawn }
bluedefensespawn = { validspawn = bluedefensespawn }
