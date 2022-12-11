
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_id");

NUM_PHASES = 3
INITIAL_ROUND_DELAY = 60

--red attacks first.
--because I say so.
attackers = Team.kRed
defenders = Team.kBlue
--------------
--backpacks
--------------
smallpack = ammobackpack:new({
	health = 30,
	armor = 30,
})
blue_smallpack = ammobackpack:new({
	health = 30,
	armor = 30,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_smallpack = ammobackpack:new({
	health = 30,
	armor = 30,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

------------------------------------------------------------
--Turrets
------------------------------------------------------------

respawnturret_attackers = base_respawnturret:new({ team = attackers })
respawnturret_defenders = base_respawnturret:new({ team = defenders })

---------------------------------------
--Resetting round
------------------------------------
detpack_wall_open = nil

function onroundreset()
	-- close the door
	if detpack_wall_open then
		-- there's no "close".. wtf
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = nil
	end
	-- Reset The Turrets
	respawnturret_attackers = base_respawnturret:new({ team = attackers })
	respawnturret_defenders = base_respawnturret:new({ team = defenders })
	-- Reset The doors (light my fire)
	blue_respawndoor = respawndoor:new({ team = defenders })
	ApplyToAll({ AT.kRemoveDecals })
	
end

-------------------------
--D spawns ignore phases. 
-------------------------
defender_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == defenders
end })

--------------------------------------------
--Grates
--------------------------------------------
--From Avanti_classic
detpack_trigger = trigger_ff_script:new({})
function detpack_trigger:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		BroadCastMessage("The detpack wall has been blown open!")
		BroadCastSound( "otherteam.flagstolen" )
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = true			
	end
	return EVENT_ALLOWED
end

-- Don't want any body touching/triggering it except the detpack
function trigger_detpackable_door:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

--------------
--locations
--------------
location_nml = location_info:new({ text = "Map Center", team = NO_TEAM })

location_red_cp1 = location_info:new({ text = "Capture point 1", team = Team.kRed })
location_red_cp2 = location_info:new({ text = "Capture point 2", team = Team.kRed })
location_red_cp3 = location_info:new({ text = "Capture point 3", team = Team.kRed })
location_red_cp4 = location_info:new({ text = "Capture point 4", team = Team.kRed })

location_blue_cp1 = location_info:new({ text = "Capture point 1", team = Team.kBlue })
location_blue_cp2 = location_info:new({ text = "Capture point 2", team = Team.kBlue })
location_blue_cp3 = location_info:new({ text = "Capture point 3", team = Team.kBlue })
location_blue_cp4 = location_info:new({ text = "Capture point 4", team = Team.kBlue })
