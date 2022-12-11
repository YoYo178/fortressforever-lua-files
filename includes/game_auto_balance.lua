--game_auto_balance.lua 1.0 (5-30-2015) R00Kie

-- Useful Stuff --
local function_table = { player_switchteam = player_switchteam }

function player_switchteam( player, old, new )
	if type(function_table.player_switchteam) == "function" then
		function_table.player_switchteam( player, old, new )
	end
	
	local old = old
	local new = new
	
	ConsoleToAll(player:GetName().." Tried to Switch Teams!")
	if old == Team.kSpectator or old == Team.kUnassigned then
		if GetTeam(Team.kRed):GetNumPlayers() == GetTeam(Team.kBlue):GetNumPlayers() then return true
		else
			if new == Team.kRed then
				old = Team.kBlue
			elseif new == Team.kBlue then
				old = Team.kRed
			end
		end
	end

	if GetTeam(new):GetNumPlayers() >= GetTeam(old):GetNumPlayers() and GetTeam(new):GetNumPlayers() ~= 0 then 
		if new == Team.kRed then
			ConsoleToAll("Switch to Red Team Denied")
			BroadcastMessageToPlayer(player, "Red Team has too many players!")
			ChatToPlayer(player, "Teams were uneven, you were forced to Blue Team!")
			ApplyToPlayer(player, {AT.kChangeTeamBlue})
			return false
		elseif new == Team.kBlue then
			ConsoleToAll("Switch to Blue Team Denied")
			BroadcastMessageToPlayer(player, "Blue Team has too many players!")
			ChatToPlayer(player, "Teams were uneven, you were forced to Red Team!")
			ApplyToPlayer(player, {AT.kChangeTeamRed})
			return false
		else
			return true
		end
	else
		return true
	end	
end