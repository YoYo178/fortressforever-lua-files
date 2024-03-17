-- ff_wellfortress.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})
						  
				  

-- red cap point
red_cap = basecap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------

function startup()
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )	

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
end

function precache()
	-- precache sounds
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("vox.yourcap")
	PrecacheSound("vox.enemycap")
	PrecacheSound("vox.yourstole")
	PrecacheSound("vox.enemystole")
	PrecacheSound("vox.yourflagret")
	PrecacheSound("vox.enemyflagret")
end



-----------------------------------------------------------------------------
-- team restrictions
-----------------------------------------------------------------------------
--SetPlayerLimit( Team.kBlue, 0 )
--SetPlayerLimit( Team.kRed, 0)
--SetPlayerLimit( Team.kYellow, -1)
--SetPlayerLimit( Team.kGreen, -1 )

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 50

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_yard = location_info:new({ text = "Yard", team = NO_TEAM })
location_yardwater = location_info:new({ text = "Yard Water", team = NO_TEAM })

location_bluecap = location_info:new({ text = "Blue Capture Point", team = Team.kBlue })
location_bluetopfloor = location_info:new({ text = "Blue Top Level", team = Team.kBlue })
location_bluehighbattlements = location_info:new({ text = "Blue Higher Battlements", team = Team.kBlue })
location_bluelowbattlements = location_info:new({ text = "Blue Lower Battlements", team = Team.kBlue })
location_blueentrance = location_info:new({ text = "Blue Entrancew", team = Team.kBlue })
location_bluecentralroom = location_info:new({ text = "Blue Central Room", team = Team.kBlue })
location_blueflagroomyard = location_info:new({ text = "Blue Flagroom Yard", team = Team.kBlue })
location_bluerighttunnel = location_info:new({ text = "Blue Right Tunnel", team = Team.kBlue })
location_bluelefttunnel = location_info:new({ text = "Blue Left Tunnel", team = Team.kBlue })
location_bluerightrespawn = location_info:new({ text = "Blue Right Spawnroomw", team = Team.kBlue })
location_blueleftrespawn = location_info:new({ text = "Blue Left Spawnroom", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Blue Flagroom", team = Team.kBlue })

location_outdors = location_info:new({ text = "Outside", team = Team.kBlue , team = Team.kRedss})

location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_redgreatroom = location_info:new({ text = "Red Great Room", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Red Flag Room", team = Team.kRed })
location_redcatwalks = location_info:new({ text = "Red Catwalks", team = Team.kRed })
location_redstairs = location_info:new({ text = "Red Stairs", team = Team.kRed })
location_redsniperdeck = location_info:new({ text = "Red Sniper Deck", team = Team.kRed })
location_redbattlements = location_info:new({ text = "Red Battlements", team = Team.kRed })
location_redtunneloflove = location_info:new({ text = "Red Tunnel of Love", team = Team.kRed })
location_redelevator = location_info:new({ text = "Red Elevator", team = Team.kRed })
location_redwatertunnels = location_info:new({ text = "Red Water Tunnels", team = Team.kRed })
location_redbasement = location_info:new({ text = "Red Basement", team = Team.kRed })
