IncludeScript("base_ctf");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");
IncludeScript("base_location");

------------------------------------------------------------------------------
--Teams
------------------------------------------------------------------------------
function startup()
    enabled_teams = { Team.kBlue, Team.kRed, Team.kYellow}
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, -1)
	
	-- disable civilians
	for index, iteam in ipairs( enabled_teams ) do
	   local team = GetTeam(iteam)
	   team:SetClassLimit(Player.kCivilian, -1)
	end
-----------------------------------------------------------------------------
-- Locations (19)-red/blue (18)-yellow (3)-neutral
-----------------------------------------------------------------------------
red_location_mainspawn		= location_info:new({ text = "Main Spawn", team = Team.kRed })
red_location_sniper		= location_info:new({ text = "Sniper Nest", team = Team.kRed })
red_location_bunker		= location_info:new({ text = "Bunker", team = Team.kRed })
red_location_observation	= location_info:new({ text = "Observation Room", team = Team.kRed })
red_location_dropdown		= location_info:new({ text = "Drop Down Spawn", team = Team.kRed })
red_location_mroom		= location_info:new({ text = "Main Room", team = Team.kRed })
red_location_lhallway		= location_info:new({ text = "Long Hallway", team = Team.kRed })
red_location_baccess		= location_info:new({ text = "Bunker Access", team = Team.kRed })
red_location_basement		= location_info:new({ text = "Basement", team = Team.kRed })
red_location_shall		= location_info:new({ text = "Side Hallway", team = Team.kRed })
red_location_battlements	= location_info:new({ text = "Battlements", team = Team.kRed })
red_location_lift		= location_info:new({ text = "Lift", team = Team.kRed })
red_location_gallery		= location_info:new({ text = "Gallery", team = Team.kRed })
red_location_key		= location_info:new({ text = "Key Room", team = Team.kRed })
red_location_display		= location_info:new({ text = "Display Area", team = Team.kRed })
red_location_moat		= location_info:new({ text = "Moat", team = Team.kRed })
red_location_syard		= location_info:new({ text = "Side Yard", team = Team.kRed })
red_location_fyard		= location_info:new({ text = "Yard", team = Team.kRed })
red_location_fdoor		= location_info:new({ text = "Front Door", team = Team.kRed })

blue_location_sniper		= location_info:new({ text = "Sniper Nest", team = Team.kBlue })
blue_location_bunker		= location_info:new({ text = "Bunker", team = Team.kBlue })
blue_location_battlements	= location_info:new({ text = "Battlements", team = Team.kBlue })
blue_location_observation	= location_info:new({ text = "Observation Room", team = Team.kBlue })
blue_location_mainspawn		= location_info:new({ text = "Main Spawn", team = Team.kBlue })
blue_location_dropdown		= location_info:new({ text = "Drop Down Spawn", team = Team.kBlue })
blue_location_basement		= location_info:new({ text = "Basement", team = Team.kBlue })
blue_location_lhallway		= location_info:new({ text = "Long Hallway", team = Team.kBlue })
blue_location_baccess		= location_info:new({ text = "Bunker Access", team = Team.kBlue })
blue_location_shall		= location_info:new({ text = "Side Hallway", team = Team.kBlue })
blue_location_lift		= location_info:new({ text = "Lift", team = Team.kBlue })
blue_location_gallery		= location_info:new({ text = "Gallery", team = Team.kBlue })
blue_location_key		= location_info:new({ text = "Key Room", team = Team.kBlue })
blue_location_display		= location_info:new({ text = "Gallery", team = Team.kBlue })
blue_location_mroom		= location_info:new({ text = "Main Room", team = Team.kBlue })
blue_location_fdoor		= location_info:new({ text = "Front Door", team = Team.kBlue })
blue_location_moat		= location_info:new({ text = "Moat", team = Team.kBlue })
blue_location_syard		= location_info:new({ text = "Side Yard", team = Team.kBlue })
blue_location_fyard		= location_info:new({ text = "Front Yard", team = Team.kBlue })



yellow_location_main_control	= location_info:new({ text = "Main Control Room", team = Team.kYellow })
yellow_location_spawn		= location_info:new({ text = "Spawn", team = Team.kYellow })
yellow_location_bathroom	= location_info:new({ text = "Bathroom", team = Team.kYellow })
yellow_location_shaft		= location_info:new({ text = "Elevator Shaft", team = Team.kYellow })
yellow_location_lift		= location_info:new({ text = "Lift", team = Team.kYellow })
yellow_location_silo		= location_info:new({ text = "Missile Silo", team = Team.kYellow })
yellow_location_elevator	= location_info:new({ text = "Elevator", team = Team.kYellow })
yellow_location_mail		= location_info:new({ text = "Mail Room", team = Team.kYellow })
yellow_location_cafeteria	= location_info:new({ text = "Cafeteria", team = Team.kYellow })
yellow_location_chall		= location_info:new({ text = "Complex Hallway", team = Team.kYellow })
yellow_location_kitchen		= location_info:new({ text = "Kitchen", team = Team.kYellow })
yellow_location_freight		= location_info:new({ text = "Freight Storage", team = Team.kYellow })
yellow_location_centry		= location_info:new({ text = "Complex Entry", team = Team.kYellow })
yellow_location_caccess		= location_info:new({ text = "Comms Access", team = Team.kYellow })
yellow_location_comms		= location_info:new({ text = "Communications", team = Team.kYellow })
yellow_location_mentry		= location_info:new({ text = "Main Entry", team = Team.kYellow })
yellow_location_yard		= location_info:new({ text = "Yard", team = Team.kYellow })
yellow_location_ldock		= location_info:new({ text = "Loading Dock", team = Team.kYellow })

neutral_location_sewers		= location_info:new({ text = "Sewers", team = Team.kUnassigned })
neutral_location_launch		= location_info:new({ text = "Launch Yard", team = Team.kUnassigned })
neutral_location_midmap		= location_info:new({ text = "Mid Map", team = Team.kUnassigned })

-----------------------------------------------------------------------------
-- Key
-----------------------------------------------------------------------------

red_flag = baseflag:new({			 team = Team.kRed,
						 model = "models/keycard/keycard.mdl",
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 150,
						 hudwidth = 70,
						 hudheight = 70,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}
						 })

blue_flag = baseflag:new({			 team = Team.kBlue,
						 model = "models/keycard/keycard.mdl",
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 80,
						 hudwidth = 70,
						 hudheight = 70,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}
						 })
-- The button (control room door, launch room)					   
control_door = basecap:new({			team = Team.kBlue, 
						item = {"red_flag"},
						opendoor = "launch_room_access_door"
						})

control_door = basecap:new({			team = Team.kRed, 
						item = {"blue_key"},
						opendoor = "launch_room_access_door"
						})



-----------------------------------------------------------------------------
-- No builds
-----------------------------------------------------------------------------
nobuild = trigger_ff_script:new({})

function nobuild:onbuild( build_entity )	
	return EVENT_DISALLOWED 
end

no_build = nobuild

-----------------------------------------------------------------------------
-- No Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})

function noannoyances:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function noannoyances:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_DISALLOWED
end

function noannoyances:oninfect( infect_entity )
	return EVENT_DISALLOWED 
end

no_annoyances = noannoyances
spawn_protection = noannoyances

-----------------------------------------------------------------------------
-- No grens: area where grens won't explode
-----------------------------------------------------------------------------
nogrens = trigger_ff_script:new({})

function nogrens:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

no_grens = nogrens


-----------------------------------------------------------------------------
-- spawn doors
-----------------------------------------------------------------------------

blue_side_door_outer = bluerespawndoor
blue_dropdown = bluerespawndoor
blue_mainspawn = bluerespawndoor
yellow_spawn = yellowrespawndoor
red_mainspawn = redrespawndoor
red_dropdown = redrespawndoor
red_side_door_outer = redrespawndoor
end