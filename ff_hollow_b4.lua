-- =======.lua
-- Map by GambiT **robbheb82@cox.net**
-- Fortress Forever FTW!!!

-----------------------------------------------------------------------------
-- Gameplay info
-----------------------------------------------------------------------------
-- Capture the enemy flag!!
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- startup 
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

-----------------------------------------------------------------------------
-- resupply (bagless)
-----------------------------------------------------------------------------
resup = trigger_ff_script:new({ team = Team.kUnassigned })

function resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_resup = resup:new({ team = Team.kBlue })
red_resup = resup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- gren resupply (bagless)
-----------------------------------------------------------------------------
resupgren = trigger_ff_script:new({ team = Team.kUnassigned })

function resupgren:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddAmmo( Ammo.kGren1, 4 )
			player:AddAmmo( Ammo.kGren2, 4 )
		end
	end
end

blue_resupgren = resupgren:new({ team = Team.kBlue })
red_resupgren = resupgren:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- unique locations
-----------------------------------------------------------------------------
location_blue_basement = location_info:new({ text = "#BASEMENT", team = Team.kBlue })
location_red_basement = location_info:new({ text = "#BASEMENT", team = Team.kRed })
location_blue_basementhall = location_info:new({ text = "#BASEMENT_HALLWAY", team = Team.kBlue })
location_red_basementhall = location_info:new({ text = "#BASEMENT_HALLWAY", team = Team.kRed })

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
red_laser_hurt1 = hurt:new({ team = Team.kBlue })
blue_laser_hurt1 = hurt:new({ team = Team.kRed })