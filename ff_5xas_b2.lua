
-- 5xas.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end


-----------------------------------------------------------------------------
-- Pickups
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------

blue_spawnopen = trigger_ff_script:new({ team = Team.kBlue })
function blue_spawnopen:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function blue_spawnopen:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("blue_spawnopen", "Open")
     
   end
end

red_spawnopen = trigger_ff_script:new({ team = Team.kRed })
function red_spawnopen:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function red_spawnopen:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_spawnopen", "Open")
   end
end

red_spawnopen2 = trigger_ff_script:new({ team = Team.kRed })
function red_spawnopen2:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function red_spawnopen2:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_spawnopen2", "Open")
   end
end


-----------------------------------------------------------------------------
-- Offensive and Defensive Spawns
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Feel free to reuse this if needed.
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }