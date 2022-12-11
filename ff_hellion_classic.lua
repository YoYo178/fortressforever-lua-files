IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
SECURITY_LENGTH = 40;

-- custom startup
local startup_base = startup

function startup()
    startup_base()

    -- specific stuff
	-- set them team names
	SetTeamName( Team.kBlue, "Blue Orcas" )
	SetTeamName( Team.kRed, "Red Gazelles" )
end

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

helliongrenadepack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function helliongrenadepack:dropatspawn() return false end

red_helliongrenadepack = helliongrenadepack:new({ touchflags = {AllowFlags.kRed} })
blue_helliongrenadepack = helliongrenadepack:new({ touchflags = {AllowFlags.kBlue} })

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
				AddSchedule("aardvarksecup10red", SECURITY_LENGTH - 10,aardvarksecup10red)
				AddSchedule("aardvarksecupred", SECURITY_LENGTH ,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage( "#FF_RED_SEC_"..SECURITY_LENGTH )
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
				AddHudTimerToAll( "red_sec_timer", SECURITY_LENGTH, -1, button_red.iconx, button_red.icony + 15, button_red.iconalign )
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
				AddSchedule("aardvarksecup10blue", SECURITY_LENGTH - 10,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue", SECURITY_LENGTH ,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage( "#FF_BLUE_SEC_"..SECURITY_LENGTH )
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
				AddHudTimerToAll( "blue_sec_timer", SECURITY_LENGTH, -1, button_blue.iconx, button_blue.icony + 15, button_blue.iconalign )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("#FF_RED_SEC_ON")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	RemoveHudItemFromAll( "red_sec_timer" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("#FF_BLUE_SEC_ON")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	RemoveHudItemFromAll( "blue_sec_timer" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
end

function aardvarksecup10red()
	BroadCastMessage("#FF_RED_SEC_10")
end

function aardvarksecup10blue()
	BroadCastMessage("#FF_BLUE_SEC_10")
end

-------------------------
-- flaginfo
-------------------------
function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	flaginfo_base(player_entity) --basic CTF HUD items

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if bluesecstatus == 1 then
		AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	end

	if redsecstatus == 1 then
		AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	end
end

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

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

-- notes: can't do locations based off of info_ff_script ents
-- commenting out text if-ever the option is made available
location_red_topresup = location_info:new({ text = "Top Respawn", team = Team.kRed })
location_red_bottomresup = location_info:new({ text = "Bottom Respawn", team = Team.kRed })
location_red_mainupperlvl = location_info:new({ text = "Main - Upper Level", team = Team.kRed })
location_red_main = location_info:new({ text = "Main", team = Team.kRed })
location_red_conveyor = location_info:new({ text = "Conveyor Belt", team = Team.kRed })
location_red_buttonramp = location_info:new({ text = "Ramps - Button Side", team = Team.kRed })
location_red_button = location_info:new({ text = "Security Control", team = Team.kRed })
location_red_tunnel = location_info:new({ text = "Tunnel", team = Team.kRed })
location_red_frwater = location_info:new({ text = "Flagroom - Water", team = Team.kRed })
-- text Flagroom - Lower Lever 
location_red_frlower = location_info:new({ text = "Flagroom", team = Team.kRed })
-- text Flagroom - Upper Lever 
location_red_frupper = location_info:new({ text = "Flagroom", team = Team.kRed })
-- text Flagroom - In 
location_red_frin = location_info:new({ text = "Flagroom", team = Team.kRed })
location_red_frramp = location_info:new({ text = "Ramp - Flagroom Side", team = Team.kRed })
location_red_topramp = location_info:new({ text = "Top Ramp", team = Team.kRed })
location_red_fdright = location_info:new({ text = "Front Door - Right", team = Team.kRed })
location_red_fdcenter = location_info:new({ text = "Front Door - Middle", team = Team.kRed })
location_red_fdleft = location_info:new({ text = "Front Door - Left", team = Team.kRed })
location_red_bats = location_info:new({ text = "Battlements", team = Team.kRed })

location_blue_topresup = location_info:new({ text = "Top Respawn", team = Team.kBlue })
location_blue_bottomresup = location_info:new({ text = "Bottom Respawn", team = Team.kBlue })
location_blue_mainupperlvl = location_info:new({ text = "Main - Upper Level", team = Team.kBlue })
location_blue_main = location_info:new({ text = "Main", team = Team.kBlue })
location_blue_conveyor = location_info:new({ text = "Conveyor Belt", team = Team.kBlue })
location_blue_buttonramp = location_info:new({ text = "Ramps - Button Side", team = Team.kBlue })
location_blue_button = location_info:new({ text = "Security Control", team = Team.kBlue })
location_blue_tunnel = location_info:new({ text = "Tunnel", team = Team.kBlue })
location_blue_frwater = location_info:new({ text = "Flagroom - Water", team = Team.kBlue })
-- text Flagroom - Lower Lever 
location_blue_frlower = location_info:new({ text = "Flagroom", team = Team.kBlue })
-- text Flagroom - Upper Lever 
location_blue_frupper = location_info:new({ text = "Flagroom", team = Team.kBlue })
-- text Flagroom - In 
location_blue_frin = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_blue_frramp = location_info:new({ text = "Ramp - Flagroom Side", team = Team.kBlue })
location_blue_topramp = location_info:new({ text = "Top Ramp", team = Team.kBlue })
location_blue_fdright = location_info:new({ text = "Front Door - Right", team = Team.kBlue })
location_blue_fdcenter = location_info:new({ text = "Front Door - Middle", team = Team.kBlue })
location_blue_fdleft = location_info:new({ text = "Front Door - Left", team = Team.kBlue })
location_blue_bats = location_info:new({ text = "Battlements", team = Team.kBlue })

location_midmap = location_info:new({ text = "Yard", team = NO_TEAM })