IncludeScript("base_slaughterball")
-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------

BALL_RETURN_TIME = 5 -- the time it takes the ball to return after dropped
SCORE_TIME = 10 -- the interval in seconds to hand out score while ball is held
ADD_POINTS = 5 -- how many team points to hand out
POINT_MULTIPLIER = 10 -- how many fortpoints (player score) to hand out
HUD_BALLNAME = "slaughterball"

rpos_warehouse = base_returnpos:new({ ico_dir = "maps/test_slaughterball/location_warehouse.vtf", loc_str = "5. Warehouse", area_ref = "area_indoors" })
rpos_elevated = base_returnpos:new({ ico_dir = "maps/test_slaughterball/location_elevated.vtf", loc_str = "4. Elevated", area_ref = "area_outdoors" })
rpos_sewerlid = base_returnpos:new({ ico_dir = "maps/test_slaughterball/location_sewerlid.vtf", loc_str = "3. Sewer Lid", area_ref = "area_outdoors" })
rpos_twisted = base_returnpos:new({ ico_dir = "maps/test_slaughterball/location_twisted.vtf", loc_str = "2. Twisted", area_ref = "area_outdoors" })
rpos_square = base_returnpos:new({ ico_dir = "maps/test_slaughterball/location_square.vtf", loc_str = "1. Square", area_ref = "area_outdoors" })

area_indoors = base_area:new({ text = "Indoors", team = Team.kUnassigned, ico_dir = "maps/test_slaughterball/area_indoors" })
area_outdoors = base_area:new({ text = "Outdoors", team = Team.kUnassigned, ico_dir = "maps/test_slaughterball/area_outdoors" })

slaughterball = base_ball:new({ lastreturn = rpos_square, lastarea = area_outdoors })
