
-- ff_schrape_b4.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
--lzr
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

SECURITY_LENGTH = 60

red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })

-----------------------------------------------------------------------------
--locations
-----------------------------------------------------------------------------

red_flagroom = location_info:new({ text = "Flagroom", team = Team.kRed })
red_lowresuppy = location_info:new({ text = "Lower Resupply", team = Team.kRed })
red_upresuppy = location_info:new({ text = "Upper Resupply", team = Team.kRed })
red_leftenter = location_info:new({ text = "Left Entrance", team = Team.kRed })
red_rightenter = location_info:new({ text = "Right Entrance", team = Team.kRed })
red_bighall = location_info:new({ text = "Big Ramp", team = Team.kRed })
red_sec = location_info:new({ text = "Red Security", team = Team.kRed })
red_secroom = location_info:new({ text = "Security Room", team = Team.kRed })
red_pit = location_info:new({ text = "Bottomless Pit", team = Team.kRed })
red_uphall = location_info:new({ text = "The Secret Path", team = Team.kRed })
red_tombstone = location_info:new({ text = "The Tombstone Entrance", team = Team.kRed })

blue_flagroom = location_info:new({ text = "Flagroom", team = Team.kBlue })
blue_lowresuppy = location_info:new({ text = "Lower Resupply", team = Team.kBlue })
blue_upresuppy = location_info:new({ text = "Upper Resupply", team = Team.kBlue })
blue_leftenter = location_info:new({ text = "Left Entrance", team = Team.kBlue })
blue_rightenter = location_info:new({ text = "Right Entrance", team = Team.kBlue })
blue_bighall = location_info:new({ text = "Big Ramp", team = Team.kBlue })
blue_sec = location_info:new({ text = "Blue Security", team = Team.kBlue })
blue_secroom = location_info:new({ text = "Security Room", team = Team.kBlue })
blue_pit = location_info:new({ text = "Bottomless Pit", team = Team.kBlue })
blue_uphall = location_info:new({ text = "The Secret Path", team = Team.kBlue })
blue_tombstone = location_info:new({ text = "The Tombstone Entrance", team = Team.kBlue })

trainyard = location_info:new({ text = "Train Yard", team = NO_TEAM })
traincross = location_info:new({ text = "Train Crossing", team = NO_TEAM })
