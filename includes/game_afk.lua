--game_afk.lua 1.0 (5-30-2015) R00Kie

-- Default Settings --
local CHECK_AFK = 30 -- How often in seconds it checks to see if a player is AFK
local CHECK_TIMES = 120 -- How long in seconds it takes to go AFK
local MESSAGE_TIMER = 10 -- Starts counting down when the timer reaches this number

-- Useful Stuff --
local player_table = {}
local function_table = { startup = startup, player_connected = player_connected }

-- Functions --
function startup()
	if type(function_table.startup) == "function" then
		function_table.startup()
	end

	AddScheduleRepeating( "checkafk", CHECK_AFK, check_afk )
end
function player_connected( player )
	if type(function_table.player_connected) == "function" then
		function_table.player_connected( player )
	end
	
	local player = CastToPlayer(player)
	
	player_table[player:GetSteamID()] = {["AFK"] = CHECK_TIMES}
end

-- Check to see if the player is AFK
function check_afk()
	local c = Collection()
	
	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	c:GetByFilter({CF.kPlayers, CF.kTeamYellow})
	c:GetByFilter({CF.kPlayers, CF.kTeamGreen})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		
		-- Check to see if the player is moving and isnt cloaked or zooming
		if player:GetSpeed() == 0 then
			if player:IsCloaked() == true or player:IsInZoom() == true then return end
				RemoveSchedule( "check_afk_"..player:GetSteamID() )
				AddSchedule("check_afk_"..player:GetSteamID(), 1, check_afk)
				player_table[player:GetSteamID()].AFK = player_table[player:GetSteamID()].AFK - 1
				ConsoleToAll(player:GetName().." is AFK! ".."["..player_table[player:GetSteamID()].AFK.."]")
			
			-- Notify the player they are going AFK soon
			if player_table[player:GetSteamID()].AFK <= MESSAGE_TIMER then
				ChatToPlayer(player, "Going AFK in: "..player_table[player:GetSteamID()].AFK)
			end
			
			-- if countdown reaches 0 send the player to Spectator
			if player_table[player:GetSteamID()].AFK <= 0 then
				ApplyToPlayer(player, {AT.kRespawnPlayers, AT.kChangeTeamSpectator, AT.kRemoveBuildables})
				player_table[player:GetSteamID()].AFK = CHECK_TIMES				
			end
		-- JK, player isn't AFK !	
		else
			player_table[player:GetSteamID()].AFK = CHECK_TIMES
			ConsoleToAll(player:GetName().."is not AFK")
		end	
	end
end