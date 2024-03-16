
-- twistedfort_small.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_respawnturret")
IncludeScript("base_location");



-----------------------------------------------------------------------------
-- Respawns and Doors
-----------------------------------------------------------------------------

spawn_door_trigger = trigger_ff_script:new({ team = Team.kUnassigned, doorname = "" })

function spawn_door_trigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then

			if self.doorname == "blue_path" or self.doorname == "red_path" then
				BroadCastMessageToPlayer( player, "Crouch at the top - enjoy your ride" )
			end
			if self.doorname then
				OpenDoor( self.doorname )
			end
		else
			BroadCastMessageToPlayer( player, "Your team cannot use this door" )
		end
	end
end

blue_path_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_path" })
blue_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door1" })
blue_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door2" })
blue_spawn_door3_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door3" })
blue_spawn_door4_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door4" })
blue_spawn_door5_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door5" })
blue_spawn_door6_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door6" })

red_path_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_path" })
red_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door1" })
red_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door2" })
red_spawn_door3_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door3" })
red_spawn_door4_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door4" })
red_spawn_door5_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door5" })
red_spawn_door6_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door6" })

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------

base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			BroadCastMessage( self.team_name .. " grate has been destroyed" )
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_bluespawn = location_info:new({ text = "Respawn Room", team = Team.kBlue })
location_bluebox = location_info:new({ text = "Lower Box Room", team = Team.kBlue })
location_blueupperbox = location_info:new({ text = "Upper Box Room", team = Team.kBlue })
location_blueflag = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluewaterroute = location_info:new({ text = "Water Route", team = Team.kBlue })
location_bluelowent = location_info:new({ text = "Lower Entrance", team = Team.kBlue })
location_blueupperent = location_info:new({ text = "Upper Entrance", team = Team.kBlue })
location_bluezoom = location_info:new({ text = "Zoom Tube", team = Team.kBlue })
location_bluewater = location_info:new({ text = "Water Access Path", team = Team.kBlue })
location_bluesnakepath = location_info:new({ text = "Snake Path", team = Team.kBlue })

location_yard = location_info:new({ text = "Yard", team = NO_TEAM })
location_water = location_info:new({ text = "Water", team = NO_TEAM })



location_redspawn = location_info:new({ text = "Respawn Room", team = Team.kRed })
location_redbox = location_info:new({ text = "Lower Box Room", team = Team.kRed })
location_redupperbox = location_info:new({ text = "Upper Box Room", team = Team.kRed })
location_redflag = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redwaterroute = location_info:new({ text = "Water Route", team = Team.kRed })
location_redlowent = location_info:new({ text = "Lower Entrance", team = Team.kRed })
location_redupperent = location_info:new({ text = "Upper Entrance", team = Team.kRed })
location_redzoom = location_info:new({ text = "Zoom Tube", team = Team.kRed })
location_redwater = location_info:new({ text = "Water Access Path", team = Team.kRed })
location_redsnakepath = location_info:new({ text = "Snake Path", team = Team.kRed })