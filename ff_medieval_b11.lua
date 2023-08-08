IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------------------------------------------------------
-- BAGS
-----------------------------------------------------------------------------------------------------------------------------

--SECURITY
blue_bag_security = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bag_security = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

--DOUBLE RAMP
blue_bag_dramp = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 2,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bag_dramp = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 2,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

--FLAG ROOM
blue_bag_fr = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 2,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bag_fr = genericbackpack:new({ 
	health = 50,
	armor = 60,
	grenades = 0,
	shells = 300,
	nails = 300,
	rockets = 300,
	cells = 50,
	detpacks = 0,
	gren1 = 2,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

--ENGINEER
blue_bag_engy = genericbackpack:new({ 
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 130,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bag_engy = genericbackpack:new({ 
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 130,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

--function blue_bag_def:dropatspawn() return false end
--function blue_bag_engy:dropatspawn() return false end
--function red_bag_def:dropatspawn() return false end
--function red_bag_engy:dropatspawn() return false end

-----------------------------------------------------------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------------------------------------------------------

spawn_red_offence = function(self,player)
	return ((player:GetTeamId() == Team.kRed)
	and ((player:GetClass() == Player.kScout)
	or (player:GetClass() == Player.kMedic)
	or (player:GetClass() == Player.kSpy)))
end

spawn_red_defence = function(self,player)
	return ((player:GetTeamId() == Team.kRed)
	and (((player:GetClass() == Player.kScout) == false)
	and ((player:GetClass() == Player.kMedic) == false)
	and ((player:GetClass() == Player.kSpy) == false)))
end

spawn_blue_offence = function(self,player)
	return ((player:GetTeamId() == Team.kBlue)
	and ((player:GetClass() == Player.kScout)
	or (player:GetClass() == Player.kMedic)
	or (player:GetClass() == Player.kSpy)))
end

spawn_blue_defence = function(self,player)
	return ((player:GetTeamId() == Team.kBlue)
	and (((player:GetClass() == Player.kScout) == false)
	and ((player:GetClass() == Player.kMedic) == false)
	and ((player:GetClass() == Player.kSpy) == false)))
end

blue_spawn_offence = { validspawn = spawn_blue_offence }
blue_spawn_defence = { validspawn = spawn_blue_defence }
red_spawn_offence = { validspawn = spawn_red_offence }
red_spawn_defence = { validspawn = spawn_red_defence }

-----------------------------------------------------------------------------------------------------------------------------
-- RESUPPLIES
-----------------------------------------------------------------------------------------------------------------------------

resupply = trigger_ff_script:new({ team = Team.kUnassigned })

function resupply:ontouch( touch_entity )
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

function resupply:onendtouch( touch_entity )
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

blue_resupply = resupply:new({ team = Team.kBlue })
red_resupply = resupply:new({ team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- RESUPPLY SLAYERS
-----------------------------------------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

blue_loc_resupply = location_info:new({ text = "Resupply", team = Team.kBlue })
blue_loc_outside = location_info:new({ text = "Outside Blue Base", team = Team.kBlue })
blue_loc_battlements = location_info:new({ text = "Battlements", team = Team.kBlue })
blue_loc_underpass = location_info:new({ text = "Underpass", team = Team.kBlue })
blue_loc_crossover = location_info:new({ text = "Crossover", team = Team.kBlue })
blue_loc_lower_vramp = location_info:new({ text = "V-Ramp Tunnel", team = Team.kBlue })
blue_loc_vramp = location_info:new({ text = "V-Ramp", team = Team.kBlue })

blue_loc_fr_shortramp = location_info:new({ text = "SHORT Flag Room Ramp", team = Team.kBlue })
blue_loc_fr_longramp = location_info:new({ text = "LONG Flag Room Ramp", team = Team.kBlue })
blue_loc_fr_longramp_top = location_info:new({ text = "Top LONG Flag Room Ramp", team = Team.kBlue })
blue_loc_fr = location_info:new({ text = "Flag Room", team = Team.kBlue })

blue_loc_doubleramps_bottom = location_info:new({ text = "Bottom Double Ramps", team = Team.kBlue })
blue_loc_doubleramps_center =  location_info:new({ text = "Center Double Ramps", team = Team.kBlue })
blue_loc_doubleramps_top =  location_info:new({ text = "Top Double Ramps", team = Team.kBlue })
blue_loc_doubleramps_narrow = location_info:new({ text = "Top Double Ramps", team = Team.kBlue })
blue_loc_doubleramps_fr_ramp = location_info:new({ text = "FR Ramp to Double Ramps", team = Team.kBlue })

red_loc_resupply = location_info:new({ text = "Resupply", team = Team.kRed })
red_loc_outside = location_info:new({ text = "Outside Red Base", team = Team.kRed })
red_loc_battlements = location_info:new({ text = "Battlements", team = Team.kRed })
red_loc_underpass = location_info:new({ text = "Underpass", team = Team.kRed })
red_loc_crossover = location_info:new({ text = "Crossover", team = Team.kRed })
red_loc_lower_vramp = location_info:new({ text = "V-Ramp Tunnel", team = Team.kRed })
red_loc_vramp = location_info:new({ text = "V-Ramp", team = Team.kRed })

red_loc_fr_shortramp = location_info:new({ text = "SHORT Flag Room Ramp", team = Team.kRed })
red_loc_fr_longramp = location_info:new({ text = "LONG Flag Room Ramp", team = Team.kRed })
red_loc_fr_longramp_top = location_info:new({ text = "Top LONG Flag Room Ramp", team = Team.kRed })
red_loc_fr = location_info:new({ text = "Flag Room", team = Team.kRed })

red_loc_doubleramps_bottom = location_info:new({ text = "Bottom Double Ramps", team = Team.kRed })
red_loc_doubleramps_center =  location_info:new({ text = "Center Double Ramps", team = Team.kRed })
red_loc_doubleramps_top =  location_info:new({ text = "Top Double Ramps", team = Team.kRed })
red_loc_doubleramps_narrow = location_info:new({ text = "Top Double Ramps", team = Team.kRed })
red_loc_doubleramps_fr_ramp = location_info:new({ text = "FR Ramp to Double Ramps", team = Team.kRed })

-------------------------
-- flaginfo
-------------------------

sec_iconx = 60
sec_icony = 30
sec_iconw = 16
sec_iconh = 16

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	flaginfo_base(player_entity) --basic CTF HUD items

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if bluesecstatus == 1 then
		AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
	end

	if redsecstatus == 1 then
		AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
	end
end

-----------------------------------------------------------------------------------------------------------------------------
-- SECURITY
-----------------------------------------------------------------------------------------------------------------------------

red_security_button = trigger_ff_script:new()
blue_security_button = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

function red_security_button:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("secup10red",30,secup10red)
				AddSchedule("secupred",40,secupred)
				OpenDoor("red_security_door")
				BroadCastMessage("#FF_RED_SEC_40")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
			end
		end
	end
end

function blue_security_button:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("secup10blue",30,secup10blue)
				AddSchedule("secupblue",40,secupblue)
				OpenDoor("blue_security_door")
				BroadCastMessage("#FF_BLUE_SEC_40")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
			end
		end
	end
end

function secupred()
	redsecstatus = 1
	CloseDoor("red_security_door")
	BroadCastMessage("#FF_RED_SEC_ON")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
end

function secupblue()
	bluesecstatus = 1
	CloseDoor("blue_security_door")
	BroadCastMessage("#FF_BLUE_SEC_ON")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
end

function secup10red()
	BroadCastMessage("#FF_RED_SEC_10")
end

function secup10blue()
	BroadCastMessage("#FF_BLUE_SEC_10")
end

-----------------------------------------------------------------------------------------------------------------------------
-- SECURITY DOOR
-----------------------------------------------------------------------------------------------------------------------------
red_security_door_trigger = trigger_ff_script:new()
blue_security_door_trigger = trigger_ff_script:new()

function blue_security_door_trigger:onstarttouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if bluesecstatus == 1 then
				OpenDoor("blue_security_door")
			end
		end
	end
end
function blue_security_door_trigger:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if bluesecstatus == 1 then
				CloseDoor("blue_security_door")
			end
		end
	end
end

function red_security_door_trigger:onstarttouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if redsecstatus == 1 then
				OpenDoor("red_security_door")
			end
		end
	end
end
function red_security_door_trigger:onendtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if redsecstatus == 1 then
				CloseDoor("red_security_door")
			end
		end
	end
end