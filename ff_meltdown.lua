IncludeScript("base_ctf");
IncludeScript("base_respawnturret");
IncludeScript("base_location");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
	location_redspawn3 = location_info:new({ text = "Red Spawn 3", team = Team.kRed })
	location_redsideroom = location_info:new({ text = "Red Side Room", team = Team.kRed })
	location_redflagroom = location_info:new({ text = "Red Flag Room", team = Team.kRed })
	location_redsouthcorridor = location_info:new({ text = "Red South Corridor", team = Team.kRed })
	location_rednorthcorridor = location_info:new({ text = "Red North Corridor", team = Team.kRed })
	location_reduppercorridor = location_info:new({ text = "Red Upper Corridor", team = Team.kRed })
	location_redflagcap = location_info:new({ text = "Red Flag Capture", team = Team.kRed })
	location_redspawn2 = location_info:new({ text = "Red Spawn 2", team = Team.kRed })
	location_redramproom = location_info:new({ text = "Red Ramp Room", team = Team.kRed })
	location_redspawn1 = location_info:new({ text = "Red Spawn 1", team = Team.kRed })
	location_redsouthentrance = location_info:new({ text = "Red South Entrance", team = Team.kRed })
	location_rednorthentrance = location_info:new({ text = "Red North Entrance", team = Team.kRed })
	location_redsniperdeck = location_info:new({ text = "Red Sniper Deck", team = Team.kRed })
	location_nomansland = location_info:new({ text = "No Man's Land", team = NO_TEAM })
	location_secretroom = location_info:new({ text = "Secret Room!", team = NO_TEAM })

	location_bluespawn3 = location_info:new({ text = "Blue Spawn 3", team = Team.kBlue })
	location_bluesideroom = location_info:new({ text = "Blue Side Room", team = Team.kBlue })
	location_blueflagroom = location_info:new({ text = "Blue Flag Room", team = Team.kBlue })
	location_bluesouthcorridor = location_info:new({ text = "Blue North Corridor", team = Team.kBlue })
	location_bluenorthcorridor = location_info:new({ text = "Blue South Corridor", team = Team.kBlue })
	location_blueuppercorridor = location_info:new({ text = "Blue Upper Corridor", team = Team.kBlue })
	location_blueflagcap = location_info:new({ text = "Blue Flag Capture", team = Team.kBlue })
	location_bluespawn2 = location_info:new({ text = "Blue Spawn 2", team = Team.kBlue })
	location_blueramproom = location_info:new({ text = "Blue Ramp Room", team = Team.kBlue })
	location_bluespawn1 = location_info:new({ text = "Blue Spawn 1", team = Team.kBlue })
	location_bluesouthentrance = location_info:new({ text = "Blue North Entrance", team = Team.kBlue })
	location_bluenorthentrance = location_info:new({ text = "Blue South Entrance", team = Team.kBlue })
	location_bluesniperdeck = location_info:new({ text = "Blue Sniper Deck", team = Team.kBlue })

-----------------------------------------------------------------------------
-- Flag Cap
-----------------------------------------------------------------------------
--customflagcap = trigger_ff_script:new({ team = Team.kUnassigned })

--function customflagcap:allowed( allowed_entity )
--	local triggerresult = EVENT_DISALLOWED
--	if IsPlayer( allowed_entity ) then
--		local player = CastToPlayer( allowed_entity )
--		if player:GetTeamId() == self.team then
--			if  player:HasItem(rmpflag) then
--				triggerresult = EVENT_ALLOWED
--			end
--		end
--	end
--	return triggerresult
--end

--blue_customflagcap = customflagcap:new({ team = Team.kBlue, rmpflag = red_flag })
--red_customflagcap = customflagcap:new({ team = Team.kRed, rmpflag = blue_flag })

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })