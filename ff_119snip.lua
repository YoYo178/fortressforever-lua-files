-----------------------------------------------------------------------------
-- ff_119snip.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ff_119snip");

-- Get team points for killing a player
function player_killed(player_entity, damageinfo)
	local killer = CastToPlayer(damageinfo:GetAttacker())

	local player = CastToPlayer(player_entity)
	if IsPlayer(killer) then
		killer = CastToPlayer(killer)

		if not (player:GetTeamId() == killer:GetTeamId()) then
			local killersTeam = killer:GetTeam()
			killersTeam:AddScore(1)
		else
			local killersTeam = killer:GetTeam()
			killersTeam:AddScore(-1)
		end
	end
end
