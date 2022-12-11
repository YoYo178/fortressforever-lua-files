local FIRST_ROUND = 5 -- Seconds
local TIME_OUT_TIME = 150 -- Seconds
local HLTV_NAME = "Moto's Lounge TV"

local player_table = {}
local base_player_onchat = player_onchat
local base_startup = startup
local player1 = "Somebody"
local player2 = "Somebody"

rank = LoadMapData( "speedy" )
detect = LoadMapData ( "speedy_detect")
-------------------------------------------------------------------------------
-- Fortress Functions ---------------------------------------------------------
-------------------------------------------------------------------------------
function startup()
	if base_startup ~= nil then base_startup() end
	
	local enabled_teams = { Team.kBlue, Team.kRed }
	
	rank = {
		["first"] = TIME_OUT_TIME,
		["second"] = TIME_OUT_TIME,
		["third"] = TIME_OUT_TIME,
		["first_name"] = "Open",
		["second_name"] = "Open",
		["third_name"] = "Open"
	}
	if detect  ~= true then 
		SaveMapData( rank, "speedy" )
		detect = true
		SaveMapData( detect, "speedy_detect" )
	end
	rank = LoadMapData( "speedy" )

	SetPlayerLimit(Team.kBlue, -1)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	
	for index, iteam in ipairs( enabled_teams ) do
		local team = GetTeam(iteam)
		
		team:SetClassLimit( Player.kScout, 1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, -1 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, -1 )
		team:SetClassLimit( Player.kHwguy, -1 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, -1 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit(Player.kCivilian, -1)
	end
	AddScheduleRepeating("repeating_info", 90, repeating_info)
	AddSchedule("Start_game", FIRST_ROUND, round_start)
end
function player_connected( player )
	local player = CastToPlayer(player)
	
	player_table[player:GetSteamID()] = {
		["rounds_played"] = 0,
		["prev_time"] = 0,
		["sit_out"] = false
	}
	ranked_hud(player)
end

-------------------------------------------------------------------------------
-- Hud & Broadcast Functions --------------------------------------------------------------
-------------------------------------------------------------------------------
-- Output text so players can see who is ranked
function ranked_hud(player)
	AddHudText(player, "Rounds_Time", player_table[player:GetSteamID()].rounds_played.." :"..(string.format(" (%.2f)", player_table[player:GetSteamID()].prev_time)), 20, 30, 1)
	AddHudTextToAll( "top_ranked","Top Ranked", 20, 40, 1 )
	AddHudTextToAll("number_1", rank.first_name..(string.format(" (%.2f)", rank.first)), 5, 50, 1)
	AddHudTextToAll("number_2", rank.second_name..(string.format(" (%.2f)", rank.second)), 5, 60, 1)
	AddHudTextToAll("number_3", rank.third_name..(string.format(" (%.2f)", rank.third)), 5, 70, 1)
end
-- Output the winner
function OutputTime( player, timername )
	local timerval = GetTimerTime( timername )
	local player = player:GetName()
	
	BroadCastMessage( player..(string.format(" Won with %.2f Seconds!", timerval)), 10, Color.kBlue )
	return timerval
end

function countdown()
	AddSchedule( "map_5sectimer", 1, map_timewarn, 5 )
	AddSchedule( "map_4sectimer", 2, map_timewarn, 4 )
	AddSchedule( "map_3sectimer", 3, map_timewarn, 3 )
	AddSchedule( "map_2sectimer", 4, map_timewarn, 2 )
	AddSchedule( "map_1sectimer", 5, map_timewarn, 1 )
	AddSchedule( "map_1sectimer2", 6, round_start_s)
end

function map_timewarn( time )
	BroadCastMessage( player1.." Vs. "..player2.." !", 2, Color.kGreen )
	BroadCastMessage(  time.." !"  )
	SpeakAll( "AD_" .. time .. "SEC" )
end

function round_start_s( )
	BroadCastMessage( player1.." Vs. "..player2.." !", 3, Color.kGreen  )
	BroadCastMessage( "GET THE FLAG!", 3, Color.kWhite  )
	SpeakAll( "AD_ATTACK" )
end
-------------------------------------------------------------------------------
-- Game Mode Functions ---------------------------------------------------------
-------------------------------------------------------------------------------
-- Put players with less rounds played in line first
function lowest_played()
	local c = Collection()
	local lowest_num = 0

	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	c:GetByFilter({CF.kPlayers, CF.kTeamSpec})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player_table[player:GetSteamID()].rounds_played > lowest_num then
			lowest_num = player_table[player:GetSteamID()].rounds_played
		end
	end
	
	return lowest_num
end

function round_start()
	local c = Collection()
	player1 = "Somebody"
	player2 = "Somebody"

	c:GetByFilter({CF.kHumanPlayers, CF.kTeamSpec})
	ChatToAll("Min# "..tostring(lowest_played()))
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player:GetTeamId() == Team.kSpectator and player_table[player:GetSteamID()].sit_out ~= true and player:GetName() ~= HLTV_NAME then
			if lowest_played() >= player_table[player:GetSteamID()].rounds_played then
				ChatToAll(player:GetName().." : "..tostring(player_table[player:GetSteamID()].rounds_played))
				if GetTeam(Team.kBlue):GetNumPlayers() < 1 then
					ChatToAll("Got Blue")

					player1 = player:GetName()
					ApplyToPlayer( player, { AT.kChangeTeamBlue } )
					ApplyToPlayer( player, { AT.kChangeClassScout, AT.kAllowRespawn, AT.kRespawnPlayers, AT.kStopPrimedGrens } )
					player:Freeze(true)
				elseif	GetTeam(Team.kRed):GetNumPlayers() < 1 then
					ChatToAll("Got Red")
					
					player2 = player:GetName()
					ApplyToPlayer( player, { AT.kChangeTeamRed } )
					ApplyToPlayer( player, { AT.kChangeClassScout, AT.kAllowRespawn, AT.kRespawnPlayers, AT.kStopPrimedGrens } )
					player:Freeze(true)
				end
			end	
		end
	end
	
	ApplyToAll({AT.kReturnDroppedItems, AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips })

	RemoveHudItemFromAll( "hud_timer" )
	AddSchedule("red_delay", 6, start_delay)
	countdown()
	RemoveTimer( "speedrun_timer" )
end

function start_delay(player)
	local c = Collection()
	
	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		player:Freeze(false)
	end

	RemoveTimer( "speedrun_timer" )
	AddTimer( "speedrun_timer", 0, 1 )
	AddHudTimerToAll("hud_timer" ,"speedrun_timer", 0, 70, 4)
	
	AddSchedule("Timeout", TIME_OUT_TIME, time_out)
end

function time_out()
	BroadCastMessage( "YOU SUCK! NOBODY WINS!" )
	SpeakAll( "WIN_YELLOW" )
	pre_ending()
end

function pre_ending()
	local c = Collection()
	
	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		player_table[player:GetSteamID()].rounds_played = player_table[player:GetSteamID()].rounds_played + 1
		player:Freeze(true)
		ranked_hud(player)
		AddSchedule("spec_"..player:GetName(), 3, round_end, player)
	end
	AddSchedule("round_end", 3, round_start)
	DeleteSchedule( "Timeout" )
end

function round_end(player)
		ApplyToPlayer(player, {AT.kRespawnPlayers, AT.kChangeTeamSpectator})
end
-- Do something when a player captures the flag
function basecap:ontouch( touch_entity )
	local player = CastToPlayer ( touch_entity )
	local current_time = GetTimerTime( "speedrun_timer" )
-- Is first rank higher than the current time? If yes make that player first.
	if rank.first > current_time  then
	
		rank.third = rank.second
		rank.second = rank.first
		rank.first = current_time
	
		rank.third_name = rank.second_name
		rank.second_name = rank.first_name
		rank.first_name = player:GetName()
	
		SaveMapData( rank, "speedy" )
	elseif rank.second > current_time then
	
		rank.third = rank.second
		rank.second = current_time
	
		rank.third_name = rank.second_name
		rank.second_name = player:GetName()
	
		SaveMapData( rank, "speedy" )
	elseif rank.third > current_time then
		rank.third = current_time
		
		rank.third_name = player:GetName()
	
		SaveMapData( rank, "speedy" )
	end
	player_table[player:GetSteamID()].prev_time = current_time
	
	pre_ending()
	OutputTime(player, "speedrun_timer")
end
-------------------------------------------------------------------------------
-- Chat Functions ----------------------------------------------------------
-------------------------------------------------------------------------------
function player_onchat( player, chatstring )
	if base_player_onchat ~= nil then base_player_onchat(player,chatstring) end

	local player = CastToPlayer( player )
	
	-- string.gsub call removes all control characters (newlines, return carriages, etc)
	-- string.sub call removes the playername: part of the string, leaving just the message
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
	
	if message == "!sitout" then
		sit_out(player)
	end
	return true
end

function sit_out(player)
	if player_table[player:GetSteamID()].sit_out == false then
		player_table[player:GetSteamID()].sit_out = true
		ChatToAll(player:GetName().." is sitting out.")
	elseif player_table[player:GetSteamID()].sit_out == true then
		ChatToAll(player:GetName().." has joined back in the race.")
		player_table[player:GetSteamID()].sit_out = false
	end
end

function repeating_info ()
	ChatToAll("Speedy Commands: ^5!sitout")
end