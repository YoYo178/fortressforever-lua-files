IncludeScript("base_ctf");
IncludeScript("base_shutdown");
-----------------------------------------------------------------------------
-- plasma resupply (bagless)
-----------------------------------------------------------------------------
plasmaresup = trigger_ff_script:new({ team = Team.kUnassigned })

function plasmaresup:ontouch( touch_entity )
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

blue_plasmaresup = plasmaresup:new({ team = Team.kBlue })
red_plasmaresup = plasmaresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_blue_hallway_front= location_info:new({ text = "Front Hallway", team = Team.kBlue })
location_blue_flagroom	= location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blue_elevator		= location_info:new({ text = "Elevator", team = Team.kBlue })
location_blue_window		= location_info:new({ text = "Security Window", team = Team.kBlue })
location_blue_security	= location_info:new({ text = "Security Area", team = Team.kBlue })
location_blue_ramproom	= location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_blue_rampside	= location_info:new({ text = "Ramp Side", team = Team.kBlue })
location_blue_dropdown	= location_info:new({ text = "Drop Down", team = Team.kBlue })
location_blue_secside	= location_info:new({ text = "Security Side", team = Team.kBlue })
location_blue_frontdoor	= location_info:new({ text = "Front Door", team = Team.kBlue })
location_blue_waterway		= location_info:new({ text = "Water Way", team = Team.kBlue })
location_blue_spawn		= location_info:new({ text = "Team Respawn", team = Team.kBlue })
location_blue_topspawn		= location_info:new({ text = "Top Respawn", team = Team.kBlue })
location_blue_topexit		= location_info:new({ text = "Top exit", team = Team.kBlue })


location_red_hallway_front= location_info:new({ text = "Front Hallway", team = Team.kRed })
location_red_flagroom	= location_info:new({ text = "Flag Room", team = Team.kRed })
location_red_elevator		= location_info:new({ text = "Elevator", team = Team.kRed })
location_red_window		= location_info:new({ text = "Security Window", team = Team.kRed })
location_red_security	= location_info:new({ text = "Security Area", team = Team.kRed })
location_red_ramproom	= location_info:new({ text = "Ramp Room", team = Team.kRed })
location_red_rampside	= location_info:new({ text = "Ramp Side", team = Team.kRed })
location_red_dropdown	= location_info:new({ text = "Drop Down", team = Team.kRed })
location_red_secside	= location_info:new({ text = "Security Side", team = Team.kRed })
location_red_frontdoor	= location_info:new({ text = "Front Door", team = Team.kRed })
location_red_waterway		= location_info:new({ text = "Water Way", team = Team.kRed })
location_red_spawn		= location_info:new({ text = "Team Respawn", team = Team.kRed })
location_red_topspawn		= location_info:new({ text = "Top Respawn", team = Team.kRed })
location_red_topexit		= location_info:new({ text = "Top exit", team = Team.kRed })

location_yard			= location_info:new({ text = "Yard", team = Team.kUnassigned })


-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

phantompack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function phantompack:dropatspawn() return false end

red_phantompack = phantompack:new({ touchflags = {AllowFlags.kRed} })
blue_phantompack = phantompack:new({ touchflags = {AllowFlags.kBlue} })



-----------------------------------------------------------------------------
-- phantom lasers and respawn shields
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

-- red hurts blueteam and vice-versa

red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })






