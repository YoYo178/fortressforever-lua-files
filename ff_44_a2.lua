-----------------------------------------------------------------------------
-- ff_44_a2.lua
-- WELCOME TO SPIDER CROSSINGS
-- GET THE FUCK OUT OF MY LUA
-- THANK YOU
-- NEON
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Global Overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME   = 60;

-----------------------------------------------------------------------------
-- Location Spawns
-----------------------------------------------------------------------------

resup_validspawn   = function(self, player)
	return player:GetTeamId() == self.team and
		(player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic or player:GetClass() == Player.kSniper or player:GetClass() == Player.kSpy)
end
shoop_validspawn   = function(self, player) return player:GetTeamId() == self.team and not resup_validspawn(self, player) end

blue_shoopspawn    = info_ff_teamspawn:new({ validspawn = shoop_validspawn, team = Team.kBlue })
blue_resupspawn    = info_ff_teamspawn:new({ validspawn = resup_validspawn, team = Team.kBlue })

red_shoopspawn     = info_ff_teamspawn:new({ validspawn = shoop_validspawn, team = Team.kRed })
red_resupspawn     = info_ff_teamspawn:new({ validspawn = resup_validspawn, team = Team.kRed })

-----------------------------------------------------------------------------
-- Small Lift
-----------------------------------------------------------------------------
base_jump          = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player    = CastToPlayer(trigger_entity)
		local playerVel = player:GetVelocity()
		playerVel.z     = self.pushz
		player:SetVelocity(playerVel)
	end
end

lift_red        = base_jump:new({ pushz = 600 })
lift_blue       = base_jump:new({ pushz = 600 })
midlift_red     = base_jump:new({ pushz = 760 })
midlift_blue    = base_jump:new({ pushz = 760 })
fr_vent_red1    = base_jump:new({ pushz = 700, pushx = 700 })
fr_vent_blue1   = base_jump:new({ pushz = 700, pushx = 700 })

-----------------------------------------------------------------------------
-- Yard Lift
-----------------------------------------------------------------------------
base_angle_jump = trigger_ff_script:new({ pushz = 0, pushx = 0, pushy = 0 })

function base_angle_jump:ontouch(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player    = CastToPlayer(trigger_entity)
		local playerVel = player:GetVelocity()
		if self.pushz ~= 0 then playerVel.z = self.pushz end
		if self.pushx ~= 0 then playerVel.x = self.pushx end
		if self.pushy ~= 0 then playerVel.y = self.pushy end
		player:SetVelocity(playerVel)
	end
end

angle_jump1   = base_angle_jump:new({ pushz = 700, pushx = 700 })
angle_jump2   = base_angle_jump:new({ pushz = 700, pushx = -700 })
yardvent_red  = base_angle_jump:new({ pushz = 750, pushx = -0, pushy = 1800 })
yardvent_blue = base_angle_jump:new({ pushz = 750, pushx = -0, pushy = -1800 })
fr_vent_red2  = base_angle_jump:new({ pushy = -1600 })
fr_vent_blue2 = base_angle_jump:new({ pushy = 1600 })
-----------------------------------------------------------------------------
-- Nade Bag
-----------------------------------------------------------------------------

spidernades   = genericbackpack:new({
	gren1            = 4,
	gren2            = 2,
	respawntime      = 60,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	touchflags       = {},
	botgoaltype      = Bot.kBackPack_Ammo
})

function spidernades:dropatspawn() return false end

redspidernades  = spidernades:new({ touchflags = { AllowFlags.kRed } })
bluespidernades = spidernades:new({ touchflags = { AllowFlags.kBlue }
})

-----------------------------------------------------------------------------
-- Clips on Spawns
-----------------------------------------------------------------------------

clip_brush      = trigger_ff_clip:new({ clipflags = 0 })

red_clip        = clip_brush:new({ clipflags = { ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue } })
blue_clip       = clip_brush:new({ clipflags = { ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed } })
