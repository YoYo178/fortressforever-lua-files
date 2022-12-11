IncludeScript("base_ff_deadfall");

-- Get team points for killing a player
function player_killed( player_entity, damageinfo )
	local killer = CastToPlayer( damageinfo:GetAttacker() )
	
	local player = CastToPlayer( player_entity )
	if IsPlayer(killer) then
		killer = CastToPlayer(killer)
		--local victim = GetPlayer(player_id)
		
		if not (player:GetTeamId() == killer:GetTeamId()) then
			local killersTeam = killer:GetTeam()	
			killersTeam:AddScore(1)
		else
			local killersTeam = killer:GetTeam()	
			killersTeam:AddScore(-1)
		end 
	end
end