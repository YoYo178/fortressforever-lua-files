-- ff_startec.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;

-----------------------------------------------------------------------------
-- custom aardvark pack
-----------------------------------------------------------------------------
aardvarkpack = genericbackpack:new({
	health = 20,
	armor = 20,
	grenades = 400,
	bullets = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end

blue_aardvarkpack = aardvarkpack:new({ team = Team.kBlue })
red_aardvarkpack = aardvarkpack:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpack)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- aardvark resupply (bagless)
-----------------------------------------------------------------------------
aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
                        touchsound = "Backpack.Touch"
		end
	end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- aardvark lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- unique Startec locations
-----------------------------------------------------------------------------
location_frontredbase = location_info:new({ text = "Front Base", team = Team.kRed })
location_redrighttunnel = location_info:new({ text = "Right Tunnel", team = Team.kRed })
location_redlefttunnel = location_info:new({ text = "left Tunnel", team = Team.kRed })
location_redresup = location_info:new({ text = "Resuply room", team = Team.kRed })
location_redflagroom = location_info:new({ text = "flag room", team = Team.kRed })
location_redpit = location_info:new({ text = "Pit of Death", team = Team.kRed })

location_frontbluebase = location_info:new({ text = "Front Base", team = Team.kBlue })
location_bluerighttunnel = location_info:new({ text = "Right Tunnel", team = Team.kBlue })
location_bluelefttunnel = location_info:new({ text = "left Tunnel", team = Team.kBlue })
location_blueresup = location_info:new({ text = "Resuply room", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "flag room", team = Team.kBlue })
location_bluepit = location_info:new({ text = "Pit of Death", team = Team.kBlue })

location_yard = location_info:new({ text = "Yard", team = NO_TEAM })