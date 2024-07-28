-------------------------------------------------------------------------------------------------------------
-- ff_thunderstruck_r.lua
-- descended from ff_lastteamstanding.lua by Pon.id
-- thunderstruck redux by Soap Breaker (Gumbuk 9)
-- credits to mv for upgrading the CheckTeamAliveState function
-- cheers
-------------------------------------------------------------------------------------------------------------

IncludeScript("base_arena")


TEAM_POINTS_PER_WIN = 10
BLUE_TEAM_NAME = "Blue"
RED_TEAM_NAME = "Red"
YELLOW_TEAM_NAME = "Yellow"
GREEN_TEAM_NAME = "Green"

SPEED_MODIFIER = 1.3
FRICTION_MODIFIER = 0.6
BLASTJUMP_MODIFIER = Vector( 1.2, 1.2, 1.4 )

ENABLE_VAMPIRE = false -- players gain health back on kill
VAMPIRE_HEALTH = 30 -- points of health to give when vampirism is enabled

TEAM_LIMITS = { bl = 0, rd = 0, yl = -1, gr = -1 }


sjet_001 = upjet_simple:new({ force = Vector( 00, 50, 800 ), exponent = 0 })