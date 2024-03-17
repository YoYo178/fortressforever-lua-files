-- ff_derive.lua --
-- Includes --
IncludeScript("base_teamplay");
IncludeScript("base_ctf");
IncludeScript("base_respawnturret");
IncludeScript("base_location");

-- Basic Setup --
FLAG_RETURN_TIME = 30;
POINTS_PER_CAPTURE = 10;

-- hurts
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

-- Locations --
-- Red
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redrr = location_info:new({ text = "Ramp Room", team = Team.kRed })
location_redfd = location_info:new({ text = "Front Door", team = Team.kRed })
location_redramp = location_info:new({ text = "Main Ramp", team = Team.kRed })
location_redrespawn = location_info:new({ text = "Respawn Room", team = Team.kRed })
location_redbalc = location_info:new({ text = "Balcony", team = Team.kRed })
location_redtunnel = location_info:new ({ text = "Tunnel", team = Team.kRed })
-- Blue
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluerr = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_bluefd = location_info:new({ text = "Front Door", team = Team.kBlue })
location_blueramp = location_info:new({ text = "Main Ramp", team = Team.kBlue })
location_bluerespawn = location_info:new({ text = "Respawn Room", team = Team.kBlue })
location_bluebalc = location_info:new({ text = "Balcony", team = Team.kBlue })
location_bluetunnel = location_info:new ({ text = "Tunnel", team = Team.kBlue })
-- Neutral
location_outside = location_info:new({ text = "The not so great Outside", team = NO_TEAM })