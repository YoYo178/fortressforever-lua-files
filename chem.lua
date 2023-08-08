-----------------------------------------------------------------------------
-- chem.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------

ff_cannon_genericpack = genericbackpack:new({
	health           = 400,
	armor            = 400,

	grenades         = 400,
	nails            = 400,
	shells           = 400,
	rockets          = 400,
	cells            = 400,

	respawntime      = 10,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	botgoaltype      = Bot.kBackPack_Ammo
})

function ff_cannon_genericpack:dropatspawn() return false end

blue_cannon_genericpack = ff_cannon_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_cannon_genericpack  = ff_cannon_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

ff_cannon_grenpack      = genericbackpack:new({
	health           = 400,
	armor            = 400,

	grenades         = 400,
	nails            = 400,
	shells           = 400,
	rockets          = 400,
	cells            = 400,

	gren1            = 2,
	gren2            = 2,

	respawntime      = 20,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	botgoaltype      = Bot.kBackPack_Ammo
})

function ff_cannon_grenpack:dropatspawn() return false end

blue_cannon_grenpack = ff_cannon_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_cannon_grenpack  = ff_cannon_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

ff_cannon_fr_bag     = genericbackpack:new({
	health           = 35,
	armor            = 35,

	grenades         = 0,
	nails            = 75,
	shells           = 50,
	rockets          = 15,
	cells            = 100,

	respawntime      = 10,
	model            = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound       = "Backpack.Touch",
	botgoaltype      = Bot.kBackPack_Ammo
})

function ff_cannon_fr_bag:dropatspawn() return false end

blue_fr_bag   = ff_cannon_fr_bag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_fr_bag    = ff_cannon_fr_bag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- aardvark resupply (bagless)
-----------------------------------------------------------------------------
aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if player:GetTeamId() == self.team then
			player:AddHealth(400)
			player:AddArmor(400)
			player:AddAmmo(Ammo.kNails, 400)
			player:AddAmmo(Ammo.kShells, 400)
			player:AddAmmo(Ammo.kRockets, 400)
			player:AddAmmo(Ammo.kCells, 400)
		end
	end
end

blue_aardvarkresup         = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup          = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_blue_upper_bments = location_info:new({ text = "Upper Battlements", team = Team.kBlue })
location_blue_lower_bments = location_info:new({ text = "Lower Front Door", team = Team.kBlue })
location_blue_ramp_room    = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_blue_spawn        = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_blue_mid_route    = location_info:new({ text = "Middle Connector", team = Team.kBlue })
location_blue_side_route   = location_info:new({ text = "Side Connector", team = Team.kBlue })
location_blue_upper_route  = location_info:new({ text = "Upper Connector", team = Team.kBlue })
location_blue_flag_room    = location_info:new({ text = "Flag Room", team = Team.kBlue })

location_red_upper_bments  = location_info:new({ text = "Upper Battlements", team = Team.kRed })
location_red_lower_bments  = location_info:new({ text = "Lower Front Door", team = Team.kRed })
location_red_ramp_room     = location_info:new({ text = "Ramp Room", team = Team.kRed })
location_red_spawn         = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_red_mid_route     = location_info:new({ text = "Middle Connector", team = Team.kRed })
location_red_side_route    = location_info:new({ text = "Side Connector", team = Team.kRed })
location_red_upper_route   = location_info:new({ text = "Upper Connector", team = Team.kRed })
location_red_flag_room     = location_info:new({ text = "Flag Room", team = Team.kRed })

location_midmap            = location_info:new({ text = "Midmap", team = Team.kUnassigned })
-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------

KILL_KILL_KILL             = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed(activator)
	local player = CastToPlayer(activator)
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer      = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer       = KILL_KILL_KILL:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec  = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus    = 1
redsecstatus     = 1

sec_iconx        = 60
sec_icony        = 30
sec_iconw        = 16
sec_iconh        = 16

function red_aardvarksec:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red", 20, aardvarksecup10red)
				AddSchedule("aardvarksecupred", 30, aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("#FF_RED_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll("SD_REDDOWN")
				RemoveHudItemFromAll("red-sec-up")
				AddHudIconToAll("hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3)
			end
		end
	end
end

function blue_aardvarksec:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("aardvarksecup10blue", 20, aardvarksecup10blue)
				AddSchedule("aardvarksecupblue", 30, aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("#FF_BLUE_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll("SD_BLUEDOWN")
				RemoveHudItemFromAll("blue-sec-up")
				AddHudIconToAll("hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2)
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("#FF_RED_SEC_ON")
	SpeakAll("SD_REDUP")
	RemoveHudItemFromAll("red-sec-down")
	AddHudIconToAll("hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3)
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("#FF_BLUE_SEC_ON")
	SpeakAll("SD_BLUEUP")
	RemoveHudItemFromAll("blue-sec-down")
	AddHudIconToAll("hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2)
end

function aardvarksecup10red()
	BroadCastMessage("#FF_RED_SEC_10")
end

function aardvarksecup10blue()
	BroadCastMessage("#FF_BLUE_SEC_10")
end

-----------------------------------------------------------------------------
-- aardvark lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL        = trigger_ff_script:new({ team = Team.kUnassigned })
lasers_KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed(activator)
	local player = CastToPlayer(activator)
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function lasers_KILL_KILL_KILL:allowed(activator)
	local player = CastToPlayer(activator)
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

blue_slayer     = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer      = KILL_KILL_KILL:new({ team = Team.kRed })
red_laser_hurt  = lasers_KILL_KILL_KILL:new({ team = Team.kBlue })
blue_laser_hurt = lasers_KILL_KILL_KILL:new({ team = Team.kRed })
