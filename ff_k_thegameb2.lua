-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret")
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

function startup()

--62 seconds in the interrogation room!
AddSchedule("breakout", 62, setBreakoutSpawn)

-- set up team names
SetTeamName( Team.kBlue, "NONE" )
SetTeamName( Team.kRed, "NONE" )
SetTeamName( Team.kYellow, "NONE" )
SetTeamName( Team.kGreen, "SPYS" )

-- set up team limits
SetPlayerLimit( Team.kBlue, -1 ) -- NONE.
SetPlayerLimit( Team.kRed, -1 ) -- NONE.
SetPlayerLimit( Team.kYellow, -1 ) -- NONE.
SetPlayerLimit( Team.kGreen, 0 ) -- THE SPYS HAVE TO ESCAPE.

team = GetTeam( Team.kGreen )
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

end

-- first we need a global variable
spawnnumber = 0

--then you create a type of spawn point.
--The entity must have the same name in Hammer.
initialspawn = info_ff_teamspawn:new({ num = 0 })
spawn1 = initialspawn:new({ num = 1 })
spawn2 = initialspawn:new({ num = 2 })
spawn3 = initialspawn:new({ num = 3 })
spawn4 = initialspawn:new({ num = 4 })
-- keep going sequencially
--spawn# = initialspawn:new({ num = # })

--then create the logic to decide who can spawn there
function initialspawn:validspawn(spawn, player)
local num = self.num
if spawnnumber == num then
return true
else return false
end
end

-- finally we need a trigger to change the global
--Make SURE players can't touch any waypoint they've passed before.
waypoint = trigger_ff_script:new ({})
function waypointntouch( touch_entity )
if IsPlayer( touch_entity ) then
-- change the global spawnnumber
local num = spawnnumber
local nextnum = num + 1
spawnnumber = nextnum
ApplyToAll({AT.kRespawnPlayers})
end
end

-- finally we need a trigger to change the global
--Make SURE players can't touch any waypoint they've passed before.
waypoint2 = trigger_ff_script:new ({})
function waypoint2ntouch( touch_entity )
if IsPlayer( touch_entity ) then
-- change the global spawnnumber
local num = spawnnumber
local nextnum = num + 1
spawnnumber = nextnum
end
end

-- finally we need a trigger to change the global
--Make SURE players can't touch any waypoint they've passed before.
waypoint3 = trigger_ff_script:new ({})
function waypoint3ntouch( touch_entity )
if IsPlayer( touch_entity ) then
-- change the global spawnnumber
local num = spawnnumber
local nextnum = num + 1
spawnnumber = nextnum
end
end

-- finally we need a trigger to change the global
--Make SURE players can't touch any waypoint they've passed before.
waypoint4 = trigger_ff_script:new ({})
function waypoint4ntouch( touch_entity )
if IsPlayer( touch_entity ) then
-- change the global spawnnumber
local num = spawnnumber
local nextnum = num + 1
spawnnumber = nextnum
ApplyToAll({AT.kRespawnPlayers})
end
end