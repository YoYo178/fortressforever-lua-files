
-- ff_hideandseek_hunted_b1.lua
------------------------------------------------------
-- Game: Fortress Forever
-- Gamemode: Hide and Seek
-- Map: Hunted
-- Version: Beta 1
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
TIME_PER_ROUND = 300

-- If you use different teams, change these accordingly.
HIDERS = Team.kBlue
SEEKERS = Team.kRed

-- Doesn't matter a shit what you do with these really.
HIDERS_TEAMNAME = "Hiders"
SEEKERS_TEAMNAME = "Seekers"

-- Maximum Seekers allowed. This setting will really depend on the size of the map - less seekers for smaller maps, and so on.
MAX_SEEKERS = 8

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

	-- Hiders limited to Civilians only.
	-- Seekers have no Civilians, Scouts, Snipers or Spies, everything else is allowed.
	
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
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0)
	team:SetClassLimit( Player.kSpy, -1 )
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
	if TIME_TO_RELEASE_SEEKERS > 30 then AddSchedule( "seeker_warning_30sec" , TIME_TO_RELEASE_SEEKERS - 30 , schedulesound, "misc.bloop", scheduled_message, "Seekers will be released in 30 seconds!" ) end
	if TIME_TO_RELEASE_SEEKERS > 10 then AddSchedule( "seeker_warning_10sec" , TIME_TO_RELEASE_SEEKERS - 10 , schedulesound, "misc.bloop", scheduled_message, "Seekers will be released in 10 seconds!" ) end
	if TIME_TO_RELEASE_SEEKERS > 5 then AddSchedule( "seeker_warning_5sec" , TIME_TO_RELEASE_SEEKERS -5 , schedulecountdown, 5 ) end
	if TIME_TO_RELEASE_SEEKERS > 4 then AddSchedule( "seeker_warning_4sec" , TIME_TO_RELEASE_SEEKERS -4 , schedulecountdown, 4 ) end
	if TIME_TO_RELEASE_SEEKERS > 3 then AddSchedule( "seeker_warning_3sec" , TIME_TO_RELEASE_SEEKERS -3 , schedulecountdown, 3 ) end
	if TIME_TO_RELEASE_SEEKERS > 2 then AddSchedule( "seeker_warning_2sec" , TIME_TO_RELEASE_SEEKERS -2 , schedulecountdown, 2 ) end
	if TIME_TO_RELEASE_SEEKERS > 1 then AddSchedule( "seeker_warning_1sec" , TIME_TO_RELEASE_SEEKERS -1 , schedulecountdown, 1 ) end
	AddSchedule( "seeker_warning_released", TIME_TO_RELEASE_SEEKERS, scheduled_message_with_sound, "Seekers released!", "otherteam.flagstolen")

	AddSchedule( "hider_win_message", TIME_PER_ROUND, scheduled_message, "Hiders win!")
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

function schedulecountdown( time )
	BroadCastMessage( ""..time.."" )
	SpeakAll( "AD_" .. time .. "SEC" )
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


function player_ondamage( player, damageinfo )

  	if player:GetTeamId() == SEEKERS then
		if ( weapon == "ff_weapon_umbrella" ) then
			damageinfo:SetDamage(1);
			
			else
			
			damageinfo:ScaleDamage(0)

			end
		
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

	if phase == 2 and old ~= Team.kUnassigned and new ~= Team.kRed or Team.kBlue then
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
	AddSchedule( "seeker_warning_5sec", TIME_TO_RELEASE_SEEKERS -5, scheduled_message, "Seekers released in: 5")
	AddSchedule( "seeker_warning_4sec", TIME_TO_RELEASE_SEEKERS -4, scheduled_message, "Seekers released in: 4")
	AddSchedule( "seeker_warning_3sec", TIME_TO_RELEASE_SEEKERS -3, scheduled_message, "Seekers released in: 3")
	AddSchedule( "seeker_warning_2sec", TIME_TO_RELEASE_SEEKERS -2, scheduled_message, "Seekers released in: 2")
	AddSchedule( "seeker_warning_1sec", TIME_TO_RELEASE_SEEKERS -1, scheduled_message, "Seekers released in: 1")
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

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_green_hallway = location_info:new({ text = "Green Hallway", team = Team.kGreen })
location_main_tunnel_elevator = location_info:new({ text = "Main Tunnel Elevator", team = Team.kBlue })
location_main_tunnel_section1 = location_info:new({ text = "Main Tunnel Section 1", team = Team.kRed })
location_main_tunnel_section2 = location_info:new({ text = "Main Tunnel Section 2", team = Team.kRed })
location_main_tunnel_section3 = location_info:new({ text = "Main Tunnel Section 3", team = Team.kRed })
location_main_tunnel_sewer_ladder = location_info:new({ text = "Main Tunnel Sewer Ladder", team = Team.kRed })
location_main_tunnel_t = location_info:new({ text = "Main Tunnel T", team = Team.kRed })
location_main_tunnel_turn1 = location_info:new({ text = "Main Tunnel Turn 1", team = Team.kRed })
location_main_tunnel_turn2 = location_info:new({ text = "Main Tunnel Turn 2", team = Team.kRed })

location_beside_robotery = location_info:new({ text = "Beside Robotery", team = NO_TEAM })
location_behind_robotery = location_info:new({ text = "Behind Robotery", team = NO_TEAM })
location_main_ramp = location_info:new({ text = "Main Ramp", team = NO_TEAM })
location_main_ramp_opening = location_info:new({ text = "Main Ramp Opening", team = NO_TEAM })
location_main_ramp_overhang = location_info:new({ text = "Main Ramp Overhang", team = NO_TEAM })
location_main_road = location_info:new({ text = "Main Road", team = NO_TEAM })
location_main_road_hill = location_info:new({ text = "Main Road Hill", team = NO_TEAM })
location_main_road_lookout = location_info:new({ text = "Main Road Lookout", team = NO_TEAM })
location_main_road_stairs = location_info:new({ text = "Main Road Stairs", team = NO_TEAM })
location_mountain_tunnel = location_info:new({ text = "Mountain Tunnel", team = NO_TEAM })
location_robotery = location_info:new({ text = "Robotery", team = NO_TEAM })
location_robotery_crevice = location_info:new({ text = "Robotery Crevice", team = NO_TEAM })
location_robotery_front_roof = location_info:new({ text = "Robotery Front Roof", team = NO_TEAM })
location_robotery_loading_bay = location_info:new({ text = "Robotery Loading Bay", team = NO_TEAM })
location_robotery_side_doors = location_info:new({ text = "Robotery Side Doors", team = NO_TEAM })

location_lower_vent_room = location_info:new({ text = "Lower Vent Room", team = NO_TEAM })
location_upper_vent_room = location_info:new({ text = "Upper Vent Room", team = NO_TEAM })
location_vent = location_info:new({ text = "Vent", team = NO_TEAM })
location_vent_stairwell_room = location_info:new({ text = "Vent-Stairwell Room", team = NO_TEAM })

location_break_room = location_info:new({ text = "Break Room", team = Team.kYellow })
location_break_room_nook = location_info:new({ text = "Break Room Nook", team = Team.kYellow })
location_building_1_alley_lookout = location_info:new({ text = "Building 1 Alley Lookout", team = Team.kYellow })
location_building_1_entrance = location_info:new({ text = "Building 1 Entrance", team = NO_TEAM })
location_building_1_exit = location_info:new({ text = "Building 1 Exit", team = NO_TEAM })
location_building_1_lockers = location_info:new({ text = "Building 1 Lockers", team = NO_TEAM })
location_building_1_lockers_nook = location_info:new({ text = "Building 1 Lockers Nook", team = NO_TEAM })
location_building_1_lookout = location_info:new({ text = "Building 1 Lookout", team = Team.kYellow })
location_building_1_lookout_room = location_info:new({ text = "Building 1 Lookout Room", team = Team.kYellow })
location_building_1_lookout_room_exit = location_info:new({ text = "Building 1 Lookout Room Exit", team = Team.kYellow })
location_building_1_rooftop = location_info:new({ text = "Building 1 Rooftop", team = NO_TEAM })
location_utility_room = location_info:new({ text = "Utility Room", team = Team.kYellow })
location_utility_room_boxes = location_info:new({ text = "Utility Room Boxes", team = NO_TEAM })
location_utility_room_lower_stairs = location_info:new({ text = "Utility Room Lower Stairs", team = Team.kYellow })
location_utility_room_other_boxes = location_info:new({ text = "Utility Room Other Boxes", team = NO_TEAM })
location_utility_room_upper_nook = location_info:new({ text = "Utility Room Upper Nook", team = NO_TEAM })
location_utility_room_upper_stairs = location_info:new({ text = "Utility Room Upper Stairs", team = Team.kYellow })

location_sewers_alley = location_info:new({ text = "Sewer Alley Ladder", team = NO_TEAM })
location_sewers_dead_end = location_info:new({ text = "Sewer Dead End", team = NO_TEAM })
location_sewers_main_road = location_info:new({ text = "Sewer Main Road Ladder", team = NO_TEAM })
location_sewers_main_tunnel = location_info:new({ text = "Sewer Main Tunnel Ladder", team = NO_TEAM })
location_sewers_mountain_tunnel = location_info:new({ text = "Sewer Mountain Tunnel Ladder", team = NO_TEAM })
location_sewers_section1 = location_info:new({ text = "Sewer Section 1", team = NO_TEAM })
location_sewers_section2 = location_info:new({ text = "Sewer Section 2", team = NO_TEAM })
location_sewers_section3 = location_info:new({ text = "Sewer Section 3", team = NO_TEAM })
location_sewers_section4 = location_info:new({ text = "Sewer Section 4", team = NO_TEAM })
location_sewers_turn1 = location_info:new({ text = "Sewer Turn 1", team = NO_TEAM })
location_sewers_turn2 = location_info:new({ text = "Sewer Turn 2", team = NO_TEAM })
location_sewers_turn3 = location_info:new({ text = "Sewer Turn 3", team = NO_TEAM })
location_sewers_turn4 = location_info:new({ text = "Sewer Turn 4", team = NO_TEAM })
location_sewers_turn5 = location_info:new({ text = "Sewer Turn 5", team = NO_TEAM })

location_alley = location_info:new({ text = "Alley", team = NO_TEAM })
location_alley_entrance = location_info:new({ text = "Alley Entrance", team = NO_TEAM })
location_alley_lookouts = location_info:new({ text = "Alley Lookouts", team = Team.kYellow })

location_above_t_hallway = location_info:new({ text = "Above T Hallway", team = NO_TEAM })
location_t_hallway = location_info:new({ text = "T Hallway", team = NO_TEAM })
location_t_hallway_exit = location_info:new({ text = "T Hallway Exit", team = NO_TEAM })

location_stairwell_building_floor2 = location_info:new({ text = "Stairwell Building Floor 2", team = NO_TEAM })
location_stairwell_building_floor3 = location_info:new({ text = "Stairwell Building Floor 3", team = NO_TEAM })
location_stairwell_building_floor4 = location_info:new({ text = "Stairwell Building Floor 4", team = Team.kYellow })
location_stairwell_floor1 = location_info:new({ text = "Stairwell Floor 1", team = NO_TEAM })
location_stairwell_floor2 = location_info:new({ text = "Stairwell Floor 2", team = NO_TEAM })
location_stairwell_floor3 = location_info:new({ text = "Stairwell Floor 3", team = Team.kYellow })
location_stairwell_floor4 = location_info:new({ text = "Stairwell Floor 4", team = Team.kYellow })

location_ruins = location_info:new({ text = "Ruins", team = Team.kYellow })
location_ruins_attic = location_info:new({ text = "Ruins Attic", team = Team.kYellow })
location_ruins_attic_door = location_info:new({ text = "Ruins Attic Door", team = Team.kYellow })
location_ruins_bathroom = location_info:new({ text = "Ruins Bathroom", team = Team.kYellow })
location_ruins_crate_room = location_info:new({ text = "Ruins Crate Room", team = NO_TEAM })
location_ruins_crate_room_exit = location_info:new({ text = "Ruins Crate Room Exit", team = NO_TEAM })
location_ruins_dark_side = location_info:new({ text = "Ruins Dark Side", team = NO_TEAM })
location_ruins_exit = location_info:new({ text = "Ruins Exit", team = NO_TEAM })
location_ruins_field_holes = location_info:new({ text = "Ruins Field Holes", team = Team.kYellow })
location_ruins_lower_ladder_room = location_info:new({ text = "Ruins Lower Ladder Room", team = Team.kYellow })
location_ruins_middle_floor = location_info:new({ text = "Ruins Middle Floor", team = Team.kYellow })
location_ruins_storage = location_info:new({ text = "Ruins Storage", team = NO_TEAM })
location_ruins_tower_base = location_info:new({ text = "Ruins Tower Base", team = NO_TEAM })
location_ruins_tower_rooftop = location_info:new({ text = "Ruins Tower Rooftop", team = NO_TEAM })
location_ruins_tower_window = location_info:new({ text = "Ruins Tower Window", team = NO_TEAM })
location_ruins_upper_ladder_room = location_info:new({ text = "Ruins Upper Ladder Room", team = Team.kYellow })

location_warehouse = location_info:new({ text = "Warehouse", team = Team.kYellow })
location_warehouse_alley = location_info:new({ text = "Warehouse Alley", team = NO_TEAM })
location_warehouse_entrance = location_info:new({ text = "Warehouse Entrance", team = NO_TEAM })
location_warehouse_ramp = location_info:new({ text = "Warehouse Ramp", team = NO_TEAM })
location_warehouse_ramp_nook = location_info:new({ text = "Warehouse Ramp Nook", team = NO_TEAM })

location_between_towers = location_info:new({ text = "Between Towers", team = NO_TEAM })
location_billy_dons_property = location_info:new({ text = "Billy Don's Property", team = Team.kYellow })
location_escape_tunnel = location_info:new({ text = "Escape Tunnel", team = Team.kBlue })
location_field = location_info:new({ text = "Field", team = NO_TEAM })
location_field_bridge = location_info:new({ text = "Field Bridge", team = NO_TEAM })
location_fuel_room = location_info:new({ text = "Fuel Room", team = NO_TEAM })
location_fuel_room_rooftop = location_info:new({ text = "Fuel Room Rooftop", team = NO_TEAM })
location_tower1 = location_info:new({ text = "Tower 1", team = Team.kRed })
location_tower2 = location_info:new({ text = "Tower 2", team = Team.kRed })
location_under_the_bridge = location_info:new({ text = "Under Field Bridge", team = NO_TEAM })