-- ff_aardvark_BATTLESHIPS.lua
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_teamplay");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	
	SetTeamName( Team.kBlue, "BRITISH" )
	SetTeamName( Team.kRed, "DUTCH" )
	
	bluefleet = 0
	redfleet = 0
	AddScheduleRepeating("fleetscores",1,fleetscores)
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:RemoveAmmo(Ammo.kDetpack, 1)
end

-----------------------------------------------------------------------------
-- unique aardvark locations
-----------------------------------------------------------------------------
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redsec = location_info:new({ text = "Laser Control", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redgen = location_info:new({ text = "Generator Room", team = Team.kRed })
location_redbasement = location_info:new({ text = "Basement", team = Team.kRed })
location_redwater = location_info:new({ text = "Perilous Passage", team = Team.kRed })
location_redcor = location_info:new({ text = "Utility Corridors", team = Team.kRed })
location_redlift = location_info:new({ text = "Lift", team = Team.kRed })
location_redfd = location_info:new({ text = "Front Door", team = Team.kRed })
location_redramp = location_info:new({ text = "Top Main Ramp", team = Team.kRed })
location_redrampon = location_info:new({ text = "Main Ramp", team = Team.kRed })
location_redhallspawn = location_info:new({ text = "Respawn-Side Hallway", team = Team.kRed })
location_redhallwater = location_info:new({ text = "Lift-Side Hallway", team = Team.kRed })
location_redtoilet = location_info:new({ text = "Toilet", team = Team.kRed })
location_redshame = location_info:new({ text = "Tunnel of Shame", team = Team.kRed })
location_redoven = location_info:new({ text = "OVEN", team = Team.kRed })

location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Laser Control", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluegen = location_info:new({ text = "Generator Room", team = Team.kBlue })
location_bluebasement = location_info:new({ text = "Basement", team = Team.kBlue })
location_bluewater = location_info:new({ text = "Perilous Passage", team = Team.kBlue })
location_bluecor = location_info:new({ text = "Utility Corridors", team = Team.kBlue })
location_bluelift = location_info:new({ text = "Lift", team = Team.kBlue })
location_bluefd = location_info:new({ text = "Front Door", team = Team.kBlue })
location_blueramp = location_info:new({ text = "Top Main Ramp", team = Team.kBlue })
location_bluerampon = location_info:new({ text = "Main Ramp", team = Team.kBlue })
location_bluehallspawn = location_info:new({ text = "Respawn-Side Hallway", team = Team.kBlue })
location_bluehallwater = location_info:new({ text = "Lift-Side Hallway", team = Team.kBlue })
location_bluetoilet = location_info:new({ text = "Toilet", team = Team.kBlue })
location_blueshame = location_info:new({ text = "Tunnel of Shame", team = Team.kBlue })
location_blueoven = location_info:new({ text = "OVEN", team = Team.kBlue })

location_midmap = location_info:new({ text = "Traflagar", team = NO_TEAM })

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
	cells = 400,
	respawntime = 6,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end

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
		end
	end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",50,aardvarksecup10red)
				AddSchedule("aardvarksecupred",60,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("Red Security Deactivated for 60 Seconds")
				BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
			end
		end
	end
end

function blue_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("aardvarksecup10blue",50,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",60,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("Blue Security Deactivated for 60 Seconds")
				BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("Red Security Online")
	SpeakAll( "SD_REDUP" )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("Blue Security Online")
	SpeakAll( "SD_BLUEUP" )
end

function aardvarksecup10red()
	BroadCastMessage("Red Security Online in 10 Seconds")
end

function aardvarksecup10blue()
	BroadCastMessage("Blue Security Online in 10 Seconds")
end

-----------------------------------------------------------------------------
-- aardvark lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
lasers_KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function lasers_KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			if self.team == Team.kBlue then
				if redsecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
			if self.team == Team.kRed then
				if bluesecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
sec_blue_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kBlue })
sec_red_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- BATTLESHIPS
-----------------------------------------------------------------------------
pond_blue = trigger_ff_script:new()
pond_red = trigger_ff_script:new()

function pond_blue:ontouch()
	bluefleet = bluefleet + 1
	showfleets()
end

function pond_blue:onendtouch()
	bluefleet = bluefleet - 1
	showfleets()
end

function pond_red:ontouch()
	redfleet = redfleet + 1
	showfleets()
end

function pond_red:onendtouch()
	redfleet = redfleet - 1
	showfleets()
end

function showfleets()
	if bluefleet == 0 then
		if redfleet == 0 then
			BroadCastMessage("British Fleet : 0 - 0 : Dutch Fleet")
		end
		if redfleet == 1 then
			BroadCastMessage("British Fleet : 0 - 1 : Dutch Fleet")
		end
	end
	if bluefleet == 1 then
		if redfleet == 0 then
			BroadCastMessage("British Fleet : 1 - 0 : Dutch Fleet")
		end
		if redfleet == 1 then
			BroadCastMessage("British Fleet : 1 - 1 : Dutch Fleet")
		end
	end
	if bluefleet == 2 then
		BroadCastMessage("British Fleet : 2 - 0 : Dutch Fleet")
	end
	if redfleet == 2 then
		BroadCastMessage("British Fleet : 0 - 2 : Dutch Fleet")
	end
end

function fleetscores()
	GetTeam(Team.kBlue):AddScore(bluefleet)
	GetTeam(Team.kRed):AddScore(redfleet)
end
