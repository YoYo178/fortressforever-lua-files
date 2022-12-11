-- Title: Ghosts V. 1.0
-- Function: Turns the spectator team into ghosts. Adding a trail to the spectator team.
--			 They can be seen by all players.
-- Author: Sean 'R00Kie' Tucker
-- Last Edit: 10/18/2015

-- Save any previous functions into this array to be called later
local function_table = 
	{ 
		player_switchteam = player_switchteam,	
	}

-- Cast a trail to player on team switch to spectator
function player_switchteam( player_entity, old_team , new_team )
	
	-- Call the previous player_switchteam function to allow for map compatibility 
	if type(function_table.player_switchteam) == "function" then
		function_table.player_switchteam( player_entity, old_team, new_team )
	end
	
	local player = CastToPlayer(player_entity)
	
	-- Get the spectator team and apply a trail to them on spawn.
	if new_team == Team.kSpectator then
		player:StartTrail(Team.kSpectator) -- White trail
	
	else 
		player:StopTrail() -- Any other team, turn off the trail.
	end
	
	return true	-- Always return true to allow team switching
end
