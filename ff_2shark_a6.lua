-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------

blue_only = bluerespawndoor
red_only = redrespawndoor

-----------------------------------------------------------------------------
-- lasers and respawn shields
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

red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })