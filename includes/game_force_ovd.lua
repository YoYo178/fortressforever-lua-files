
-- For use with CTF Style maps.
-- Intended for use with Red and Blue Teams only. Blue = Offense / Red = Defense.

-- Default Settings --
local PLAYERS_NEEDED = 10

-- Useful Stuff --
local FULL_GAME = false
local function_table = { player_disconnected = player_disconnected, player_switchteam = player_switchteam, startup = startup }
function_table.baseflag = { touch = baseflag.touch }

-- Functions --
function startup()
	if type(function_table.startup) == "function" then
		function_table.startup()
	end
	
	local RED_TEAM = GetTeam(Team.kRed)
	local BLUE_TEAM = GetTeam(Team.kBlue)
	
	BLUE_TEAM:SetName("Offense")
	RED_TEAM:SetName("Defense")

	RED_TEAM:SetClassLimit(Player.kScout, -1)
	BLUE_TEAM:SetClassLimit(Player.kHwguy, -1)
end

function player_disconnected( player )
	if type(function_table.player_disconnected) == "function" then
		function_table.player_disconnected( player )
	end
	check_players()
end

function player_switchteam( player, old, new )
	if type(function_table.player_switchteam) == "function" then
		function_table.player_switchteam( player, old, new )
	end
	
	AddSchedule( "check_teams", 1, check_players)
end

-- Check to see how many players are playing and if to change the game mode
function check_players()
	ConsoleToAll("Checking Players..")
	local RED_TEAM = GetTeam(Team.kRed)
	local BLUE_TEAM = GetTeam(Team.kBlue)
	
	-- The game has the required amount of players change to full
	if RED_TEAM:GetNumPlayers() + BLUE_TEAM:GetNumPlayers() >= PLAYERS_NEEDED and FULL_GAME == false then
		FULL_GAME = true
		
		BLUE_TEAM:SetName("Blue Team")
		RED_TEAM:SetName("Red Team")
		
		RED_TEAM:SetClassLimit(Player.kScout, 0)
		BLUE_TEAM:SetClassLimit(Player.kHwguy, 0)
		
		ChatToAll("^4"..PLAYERS_NEEDED.."^5 Players are now in game, ^1Offense ^5Vs ^2Defense ^5is now ( ^2DISABLED ^5)")
	
	-- The game lost the required amount of players and goes back to OVD mode
	elseif RED_TEAM:GetNumPlayers() + BLUE_TEAM:GetNumPlayers() < PLAYERS_NEEDED and FULL_GAME == true then
		FULL_GAME = false
		
		BLUE_TEAM:SetName("Offense")
		RED_TEAM:SetName("Defense")
		
		RED_TEAM:SetClassLimit(Player.kScout, -1)
		BLUE_TEAM:SetClassLimit(Player.kHwguy, -1)
		
		ChatToAll("^5Not Enough Players, ^1Offense ^5Vs ^2Defense ^5is now ^5( ^2ENFORCED ^5)")
	end
end

-- Deny touch to the flag until players needed is met
function baseflag:touch ( touch_entity )
	local player = CastToPlayer ( touch_entity )
	
	if FULL_GAME == false then
		if player:GetTeamId() == 2 then
			if type(function_table.baseflag.touch) == "function" then
				function_table.baseflag.touch (self, touch_entity)
			end
			
		-- Send message to players trying to take a protected flag
		else	
			ChatToPlayer(player,"^5( ^2PROTECTED^5 ) ^4"..PLAYERS_NEEDED.."^5 Players are required for a Full game to start." )
		end
	else
		if type(function_table.baseflag.touch) == "function" then
				function_table.baseflag.touch (self, touch_entity)
		end
	end
end