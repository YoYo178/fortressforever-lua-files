-- game_readyup.lua Ver. 1.1.2 (6-06-15 2:00 ) Sean Tucker "R00Kie"

-- Default Settings --
local PrematchTime = 999
local ChatStrings =  -- Strings to use for a player to accept being ready
	{
		"r",
		"ready",
		"start",
		"go"
	}

-- Useful Stuff -- 0 = left | 1 = right | 2 = left of center | 3 = right of center
local player_table = {}
local ready_table = { "nil", [Team.kBlue] = false, [Team.kRed] = false, [Team.kYellow] = false, [Team.kGreen] = false } -- String Required to find the table?
local team_table = { [Team.kBlue] = {}, [Team.kRed] = {}, [Team.kYellow] = {}, [Team.kGreen] = {} }
local function_table = { player_disconnected = player_disconnected, player_onchat = player_onchat, startup = startup, player_connected = player_connected, player_switchteam = player_switchteam }

-- Functions --

function startup() 
	if type(function_table.startup) == "function" then function_table.startup()	end
	if HasGameStarted() then return true end

	ChangeTip()
	AddScheduleRepeating("tip_message", 10, ChangeTip)
	SetConvar("mp_prematch", PrematchTime )
	SetConvar("sv_alltalk", 1)
end

function player_connected( player )
	if type(function_table.player_connected) == "function" then function_table.player_connected(player)	end
	
	local player = CastToPlayer( player )
	
	-- Save the postion where the player's name is at on the hud.
	player_table[player:GetSteamID()] = { HudHeight = 0, Check = false }
end

-- Remove disconnected players from the hud
function player_disconnected( player ) 
	if type(function_table.player_disconnected) == "function" then function_table.player_disconnected(player) end
	
	local player = CastToPlayer( player )
	local team_id = player:GetTeamId()
	
	RemoveFromHud( player, team_id )
end

function player_switchteam( player, old, new )
	if type(function_table.player_switchteam) == "function" then function_table.player_switchteam( player, old, new ) end
	if HasGameStarted() then return true end 
	
	RemoveFromHud( player, old )	-- Remove their old team from the HUD
	AddNameToHud( player, new )	-- Add their new team to the HUD
	
	return true
end

function player_onchat( player, chatstring )
	if type(function_table.player_onchat) == "function" then function_table.player_onchat(player, chatstring) end
	if HasGameStarted() then return true end
	
	local player = CastToPlayer( player )
	
	-- string.gsub call removes all control characters (newlines, return carriages, etc)
	-- string.sub call removes the playername: part of the string, leaving just the message
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
	
	-- Check the the ChatStrings table for the correct ready message
	for _,v in ipairs(ChatStrings) do
		if string.lower(message) == v then
			AddCheckToName( player ) -- Adds a check to the players name
			return false
		end
	end
	return true
end

function AddNameToHud( player, team ) 
	local text_height = 50
	local height_increase = 10
	local text_width = 30
	
	-- Make sure the player isnt Spectator or Unassigned
	if team == Team.kSpectator or team == Team.kUnassigned then return end
	
	table.insert(team_table[team], player)
	
	for i, v in ipairs(team_table[team]) do
		local table_player = v
		local player_name = v:GetName()
		local player_steam = v:GetSteamID()
		local alignment = 0

		-- Set alignment | 2 = Left of center , 3 = Right of center
		if team == Team.kBlue or team == Team.kYellow then alignment = 2 elseif team == Team.kRed or team == Team.kGreen then alignment = 3 end 
		
		-- Draw Hud and save data
		AddHudTextToAll( "Name_"..player_steam, player_name, text_width, text_height + (height_increase * i ), alignment, 0)
		player_table[player_steam].HudHeight = text_height + (height_increase * i)
		TeamReady(team, false) -- Reset team ready to false
		
		-- If the player had a check next to their name, Re-add it.
		if player_table[player_steam].Check == true then 
			AddCheckToName( table_player )
		end
	end
end

function AddCheckToName( player )
	local player_steam = player:GetSteamID()
	local team_id = player:GetTeamId()
	local player_hud_height = player_table[player_steam].HudHeight - 3
	local icon_width = 17
	local icon_size = 12
	local alignment = 0
	-- Do nothing if team is Spectator or Unassigned
	if team_id == Team.kSpectator or team_id == Team.kUnassigned then return end
	
	-- Set alignment | 2 = Left of center , 3 = Right of center
	if team_id == Team.kBlue or team_id == Team.kYellow then alignment = 2 elseif team_id == Team.kRed or team_id == Team.kGreen then alignment = 3	end

	AddHudIconToAll("hud_checkmark.vtf", "check_icon_"..player_steam, icon_width , player_hud_height , icon_size, icon_size, alignment, 0 )
	player_table[player_steam].Check = true
	CheckPlayers( player, team_id )	
end

function RemoveFromHud(player, team)
	local player_steam = player:GetSteamID()
	
	if team == Team.kSpectator or team == Team.kUnassigned then return end
	
	for i, v in ipairs(team_table[team]) do
		local table_steam = v:GetSteamID()
	
		if table_steam == player_steam then
			RemoveHudItemFromAll("check_icon_"..table_steam)
			RemoveHudItemFromAll("Name_"..table_steam)
			player_table[table_steam].HudHeight = 0
			player_table[table_steam].Check = false
			ready_table[team] = false
			TeamReady(team, false)
			table.remove(team_table[team], i)
		end
	end
end

function CheckPlayers( player, team )
	local all_players =	GetPlayers()
	local count = 0 
	local team_count = #team_table[team]
	
	for _, v in ipairs(team_table[team]) do
		local table_steam = v:GetSteamID()
		
		if player_table[table_steam].Check then
			count = count + 1 
			
			-- If the Check count equals the amount of players on the team then start the game
			if count == team_count then
				TeamReady(team, true)
				return
			else
				TeamReady(team, false)
			end
		end
	end
end

function TeamReady(team, ready) -- int, Bool
	local icon_width = 17
	local icon_size = 12
	local alignment = 0
	local icon = "hud_door_closed.vtf"
	local color = "nil"
	
	-- Set Team Alignment
	if team == Team.kBlue or team == Team.kYellow then alignment = 2 color = "^1Blue" elseif team == Team.kRed or team == Team.kGreen then alignment = 3 color = "^2Red" end 
	-- Set Ready Icon
	if ready then icon = "hud_door_open.vtf"   else icon = "hud_door_closed.vtf" end
	AddHudIconToAll(icon, "ready_icon_"..team, icon_width , 45 , icon_size * 2, icon_size , alignment, 0 )
	-- If not ready return
	if not ready then return end
	
	-- Do Stuff if ready
	ChatToAll(color.." Team^5 is ready!")
	ready_table[team] = true
	StartGame()
end

function StartGame()
	local count = 0
	
	for _, v in ipairs(ready_table) do
		if v == true then
			count = count + 1
			-- if 2 Teams are ready, Start the game
			if count == 2 then 
				AddSchedule( "prematch_message_1", 0, ChatToAll, "^5Game is ^2LIVE ^5in 15 seconds!")
				AddSchedule( "prematch_message_2", 5, ChatToAll, "^3Game is ^8LIVE ^3in 10 seconds!")
				AddSchedule( "prematch_message_3", 10, ChatToAll, "^6Game is ^5LIVE ^6in 5 seconds!")
				AddSchedule( "prematch_message_4", 15.5, ChatToAll, "^^5GO GO GO")
				AddSchedule( "prematch_message_5", 15, set_cvar, "mp_prematch", 0 )
				AddSchedule( "prematch_message_6", 15, set_cvar, "sv_alltalk", 0 )
				for i = 1, 5 do -- Count down from 5
					local num =  5 - i
					AddSchedule( "prematch_countdown_"..i, 10+i, ChatToAll, "Game Starts in "..num)
				end
			end
		end
	end
end

function ChangeTip()
	local num = math.random(#ChatStrings)
	UsefulTip = "Type '"..ChatStrings[num].."' when you are ready to start the match."
	AddHudTextToAll( "Ready_text1", UsefulTip, 85, 35, 3, 0)
	AddHudTextToAll( "Ready_text2", UsefulTip, 85, 35, 2, 0)
end