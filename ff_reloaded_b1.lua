IncludeScript("base_ctf");
IncludeScript("base_shutdown");
-----------------------------------------------------------------------------
-- plasma resupply (bagless)
-----------------------------------------------------------------------------
plasmaresup = trigger_ff_script:new({ team = Team.kUnassigned })

function plasmaresup:ontouch( touch_entity )
if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	end
end

blue_plasmaresup = plasmaresup:new({ team = Team.kBlue })
red_plasmaresup = plasmaresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

phantompack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function phantompack:dropatspawn() return false end

red_phantompack = phantompack:new({ touchflags = {AllowFlags.kRed} })
blue_phantompack = phantompack:new({ touchflags = {AllowFlags.kBlue} })



-----------------------------------------------------------------------------
-- phantom lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red hurts blueteam and vice-versa

blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })

-----------------------------------------------------------------------------------------------------------------------------
-- Spawn stuff
-----------------------------------------------------------------------------------------------------------------------------

first_spawn_enabled = true

function disable_first_spawn()
	first_spawn_enabled = false
end

base_first_spawn = info_ff_teamspawn:new({ team = Team.kUnassigned, class = Player.kCivilian, enabled = true, validspawn = function(self,player)
	if first_spawn_enabled and self.enabled and player:GetClass() == self.class and player:GetTeamId() == self.team then
		self.enabled = false
		AddSchedule( "disablefirst"..self.team.."-"..self.class, 1, disable_first_spawn)
		return true
	end
	return false
end })

red_demo_first_spawn = base_first_spawn:new({ team = Team.kRed, class = Player.kDemoman })
blue_demo_first_spawn = base_first_spawn:new({ team = Team.kBlue, class = Player.kDemoman })

base_bottom_spawn = info_ff_teamspawn:new({ team = Team.kUnassigned, validspawn = function(self,player)
	if first_spawn_enabled and player:GetClass() == Player.kDemoman then
		return false
	end
	return (player:GetTeamId() == self.team and player:GetClass() ~= Player.kCivilian and player:GetClass() ~= Player.kSpy)
end })

base_top_spawn = info_ff_teamspawn:new({ team = Team.kUnassigned, validspawn = function(self,player)
	if first_spawn_enabled and player:GetClass() == Player.kDemoman then
		return false
	end
	return (player:GetTeamId() == self.team and player:GetClass() ~= Player.kSoldier and player:GetClass() ~= Player.kDemoman and player:GetClass() ~= Player.kHwguy)
end })

redspawnbtm = base_bottom_spawn:new({ team = Team.kRed })
redspawntop = base_top_spawn:new({ team = Team.kRed })

bluespawnbtm = base_bottom_spawn:new({ team = Team.kBlue })
bluespawntop = base_top_spawn:new({ team = Team.kBlue })





