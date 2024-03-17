-- ff_cz2.lua


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_cp_default")
IncludeScript("base_cp")

-- command points
CP_COUNT = 1

command_points = {
		[1] = { cp_number = 1, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 10, [TEAM2] = 10 }, score_timer_interval = { [TEAM1] = 20, [TEAM2] = 20 }, hudstatusicon = "hud_cp_1.vtf", hudposx =   0, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
}
-- complete control
ENABLE_COMPLETE_CONTROL_POINTS = true
ENABLE_COMPLETE_CONTROL_RESET = false
ENABLE_COMPLETE_CONTROL_RESPAWN = false

--Change anything below to customize the map, or you can just leave it out.

-- scoring
POINTS_FOR_COMPLETE_CONTROL = 100
CC_DESTROY_POINTS = 15


-- zones
CAP_ZONE_TIMER_INTERVAL = 0.2
CAP_ZONE_NOTOUCH_SPEED = 10


-- flags
ENABLE_FLAGS = false
FLAG_CARRIER_SPEED = 0.75
FLAG_RETURN_TIME = 0


-- teleporting
ENABLE_CC_TELEPORTERS = true
ENABLE_CP_TELEPORTERS = true


-- command center
ENABLE_CC = false

-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------
function healthkit:dropatspawn() return false end


-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------


