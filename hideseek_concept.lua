------------------------------------------------------
-- hideseek_concept.lua v0.5 by Pon.AvD
--
-- Basic functional hide and seek gameplay Lua
------------------------------------------------------


-- Entity names used in map:

-- Spawns  (Spawns, possibly.)
--	  | seeker_spawn | hider_spawn | captured_spawn |
--
-- Doors	  (make sure the door entities flags are set to not open on use/touch - only the Lua should be able to control them)
--	  | seeker_door | hider_door | captured_door |
--
-- Button  (The button that the hiders can press to release those already captured)
--	  | captured_door_button |


-----------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------


-- all in seconds. The TIME_PER_ROUND value is a total count for each round, 
-- not added on to the setup time of the first two values.
TIME_TO_RELEASE_HIDERS = 10
TIME_TO_RELEASE_SEEKERS = 60
TIME_PER_ROUND = 240

-- If you use different teams, change these accordingly.
HIDERS = Team.kBlue
SEEKERS = Team.kRed

-- Doesn't matter a shit what you do with these really.
HIDERS_TEAMNAME = "Hiders"
SEEKERS_TEAMNAME = "Seekers"

-- Maximum Seekers allowed. This setting will really depend on the size of the map - less seekers for smaller maps, and so on.
MAX_SEEKERS = 5


-----------------------------------------------------------------------------
-- Constants - DO NOT CHANGE!
-----------------------------------------------------------------------------

-- Any hiders captured will be added to this collection.
-- It will mostly be used to determine the valid spawn points for hiders.
-- It will be emptied upon pressing the release button, and round resets.
captured = Collection()

-- used mostly so that the seekers don't win if someone switches team in the setup phase.
-- 1: setup | 2: game on
phase = 1


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_location");
IncludeScript("base_teamplay");
SetConvar( "mp_prematch", 0 )
SetConvar( "sm_jetpack", 0 )
-----------------------------------------------------------------------------
-- startup
-----------------------------------------------------------------------------

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, MAX_SEEKERS )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	-- Hiders limited to Civilians. Seekers have no Civilians, but anything else is fine.
	
	local team = GetTeam( HIDERS )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

	team = GetTeam( SEEKERS )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	SetTeamName( HIDERS, HIDERS_TEAMNAME )
	SetTeamName( SEEKERS, SEEKERS_TEAMNAME )


	--Schedule Time!
	AddSchedule( "hider_door_open", TIME_TO_RELEASE_HIDERS, open_scheduled_door, "hider_door")
	AddSchedule( "seeker_door_open", TIME_TO_RELEASE_SEEKERS, open_scheduled_door, "seeker_door")
	AddSchedule( "change_phase", TIME_TO_RELEASE_HIDERS, change_phase, 2)

	AddSchedule( "hider_warning_10sec", TIME_TO_RELEASE_HIDERS -10, scheduled_message, "Hiders will be released in 10 seconds!")
	AddSchedule( "hider_warning_released", TIME_TO_RELEASE_HIDERS, scheduled_message_with_sound, "Hiders have been released! Seekers released in 60 seconds!", "otherteam.flagstolen")

	AddSchedule( "seeker_warning_60sec", TIME_TO_RELEASE_SEEKERS -60, scheduled_message, "Seekers will be released in 1 minute!")
	AddSchedule( "seeker_warning_30sec", TIME_TO_RELEASE_SEEKERS -30, scheduled_message, "Seekers will be released in 30 seconds!")
	AddSchedule( "seeker_warning_10sec", TIME_TO_RELEASE_SEEKERS -10, scheduled_message, "Seekers will be released in 10 seconds!")
	AddSchedule( "seeker_warning_5sec", TIME_TO_RELEASE_SEEKERS -5, scheduled_message, "5")
	AddSchedule( "seeker_warning_4sec", TIME_TO_RELEASE_SEEKERS -4, scheduled_message, "4")
	AddSchedule( "seeker_warning_3sec", TIME_TO_RELEASE_SEEKERS -3, scheduled_message, "3")
	AddSchedule( "seeker_warning_2sec", TIME_TO_RELEASE_SEEKERS -2, scheduled_message, "2")
	AddSchedule( "seeker_warning_1sec", TIME_TO_RELEASE_SEEKERS -1, scheduled_message, "1")
	AddSchedule( "seeker_warning_released", TIME_TO_RELEASE_SEEKERS, scheduled_message_with_sound, "Seekers released!", "otherteam.flagstolen")

	AddSchedule( "hider_win_message", TIME_PER_ROUND, scheduled_message, "Hiders evade capture!")
	AddSchedule( "round_timeout", TIME_PER_ROUND, end_round)
	AddSchedule( "hider_fanfare", TIME_PER_ROUND, scheduled_smartteamsound, GetTeam(HIDERS))
end

function precache()
	-- precache sounds
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.bizwarn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("otherteam.flagstolen")

end

-----------------------------------------------------------------------------
-- handlers
-----------------------------------------------------------------------------


-- Everyone to spawns with everything
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

	-- All of the following probably wouldn't work well in this game mode.
	-- May be wrong, will test later.
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )


	update_count()

end


-- seekers are invincible
function player_ondamage( player, damageinfo )

  	if player:GetTeamId() == SEEKERS then
		damageinfo:SetDamage(0)
		return 
  	end
end


function player_killed( player_entity, damageinfo )

	local player = CastToPlayer( player_entity )

	if phase == 2 then
		if player:GetTeamId() == HIDERS then
			captured:AddItem(player)

			if GetTeam(HIDERS):GetNumPlayers() == captured:Count() then
				BroadCastMessage("Seekers catch all Hiders!")
				RemoveSchedule( "hider_win_message")
				RemoveSchedule( "round_timeout" )
				RemoveSchedule( "hider_fanfare" )
				SmartTeamSound(GetTeam(SEEKERS), "yourteam.flagcap", "otherteam.flagcap")
				end_round()
			end
		end
	end
end

-- Don't let hiders suicide.
function player_onkill( player )

	if player:GetTeamId() == HIDERS then
		return false
	end
	return true
end

-- No switching teams during playtime.
function player_switchteam( player, old, new )

	if phase == 2 and old ~= Team.kUnassigned then
		BroadcastMessageToPlayer(player, "Changing teams is only allowed during the waiting phase.")
		return false
	end

	return true
end



-- Updates the HUD/Objective icon on player connect. Else wouldn't update until next Hill change.
function flaginfo (player_entity)

	local player = CastToPlayer( player_entity )

	AddHudTextToAll("captured_text", "Captured", 8, 32, 2)
	AddHudTextToAll("free_text", "Free", 18, 32, 3)

end


-----------------------------------------------------------------------------
-- spawns
-----------------------------------------------------------------------------

seeker_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == SEEKERS
end })


hider_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	if player:GetTeamId() == HIDERS and captured:HasItem(player) == false then
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end })

captured_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	if player:GetTeamId() == HIDERS and captured:HasItem(player) == true then
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end })



-----------------------------------------------------------------------------
-- captured door
-----------------------------------------------------------------------------

captured_door_button = func_button:new({ team = HIDERS }) 

function captured_door_button:allowed( allowed_entity ) 
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )

		if player:GetTeamId() == self.team then
			if captured:Count() == 0 then
				BroadCastMessageToPlayer(player, "Nobody has been captured yet!")
				BroadCastSoundToPlayer(player, "misc.bizwarn")
			else
				OpenDoor("captured_door")
				BroadCastMessage("Captured Hiders have been released!")
				BroadCastSound("misc.buzwarn")
				AddSchedule( "close_captured_door", 10, close_captured_door)
				captured:RemoveAllItems()
				update_count()
			end
		end
	end

	return EVENT_DISALLOWED
end



function update_count()

	RemoveHudItemFromAll("captured_count")
	RemoveHudItemFromAll("free_count")


	AddHudTextToAll("captured_count", tostring( captured:Count() ), 24, 42, 2)
	AddHudTextToAll("free_count", tostring( GetTeam(HIDERS):GetNumPlayers() - captured:Count() ), 24, 42, 3)
end


-----------------------------------------------------------------------------
-- scedules
-----------------------------------------------------------------------------

function close_captured_door()
	CloseDoor("captured_door")
end

function open_scheduled_door(door)
	OpenDoor(door)
end

function scheduled_message(message)
	BroadCastMessage(message)
end

function scheduled_message_with_sound(message, sound)
	BroadCastMessage(message)
	BroadCastSound(sound)
end

function end_round()
	change_phase(1)
	captured:RemoveAllItems()
	CloseDoor("hider_door")
	CloseDoor("seeker_door")
	ApplyToAll( { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips } )

	--Schedule Time AGAIN!
	AddSchedule( "hider_door_open", TIME_TO_RELEASE_HIDERS, open_scheduled_door, "hider_door")
	AddSchedule( "seeker_door_open", TIME_TO_RELEASE_SEEKERS, open_scheduled_door, "seeker_door")
	AddSchedule( "change_phase", TIME_TO_RELEASE_HIDERS, change_phase, 2)

	AddSchedule( "hider_warning_10sec", TIME_TO_RELEASE_HIDERS -10, scheduled_message, "Hiders will be released in 10 seconds!")
	AddSchedule( "hider_warning_released", TIME_TO_RELEASE_HIDERS, scheduled_message_with_sound, "Hiders have been released! Seekers released in 60 seconds!", "otherteam.flagstolen")

	AddSchedule( "seeker_warning_60sec", TIME_TO_RELEASE_SEEKERS -60, scheduled_message, "Seekers will be released in 1 minute!")
	AddSchedule( "seeker_warning_30sec", TIME_TO_RELEASE_SEEKERS -30, scheduled_message, "Seekers will be released in 30 seconds!")
	AddSchedule( "seeker_warning_10sec", TIME_TO_RELEASE_SEEKERS -10, scheduled_message, "Seekers will be released in 10 seconds!")
	AddSchedule( "seeker_warning_5sec", TIME_TO_RELEASE_SEEKERS -5, scheduled_message, "5")
	AddSchedule( "seeker_warning_4sec", TIME_TO_RELEASE_SEEKERS -4, scheduled_message, "4")
	AddSchedule( "seeker_warning_3sec", TIME_TO_RELEASE_SEEKERS -3, scheduled_message, "3")
	AddSchedule( "seeker_warning_2sec", TIME_TO_RELEASE_SEEKERS -2, scheduled_message, "2")
	AddSchedule( "seeker_warning_1sec", TIME_TO_RELEASE_SEEKERS -1, scheduled_message, "1")
	AddSchedule( "seeker_warning_released", TIME_TO_RELEASE_SEEKERS, scheduled_message_with_sound, "Seekers released!", "otherteam.flagstolen")

	AddSchedule( "hider_win_message", TIME_PER_ROUND, scheduled_message, "Hiders evade capture!")
	AddSchedule( "round_timeout", TIME_PER_ROUND, end_round)
	AddSchedule( "hider_fanfare", TIME_PER_ROUND, scheduled_smartteamsound, GetTeam(HIDERS))
end

function change_phase(phase_number)
	phase = phase_number
end

function scheduled_smartteamsound(winners)
	SmartTeamSound(winners, "yourteam.flagcap", "otherteam.flagcap")
end