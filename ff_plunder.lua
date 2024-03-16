-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------
location_reddspawn = location_info:new({ text = "Defense Respawn", team = Team.kRed })
location_redospawn = location_info:new({ text = "Offense Respawn", team = Team.kRed })
location_redbackhallway = location_info:new({ text = "Back Hallway", team = Team.kRed })
location_redbackhallwayramp = location_info:new({ text = "Back Hallway Ramp", team = Team.kRed })
location_redbattlements = location_info:new({ text = "Battlements", team = Team.kRed })
location_redupperbattlements = location_info:new({ text = "Upper Battlements", team = Team.kRed })
location_redtopfloor = location_info:new({ text = "Top Floor", team = Team.kRed })
location_redsecurity = location_info:new({ text = "Security", team = Team.kRed })
location_redsecurityramp = location_info:new({ text = "Security Ramp", team = Team.kRed })
location_redhole = location_info:new({ text = "Hole in the Wall", team = Team.kRed })
location_redelevator = location_info:new({ text = "Elevator", team = Team.kRed })
location_redelevatorhallway = location_info:new({ text = "Lower Elevator Hallway", team = Team.kRed })
location_redlowerentrance = location_info:new({ text = "Lower Entrance", team = Team.kRed })
location_redmainentrance = location_info:new({ text = "Main Entrance", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redmainramp = location_info:new({ text = "Main Ramp", team = Team.kRed })

location_bluedspawn = location_info:new({ text = "Defense Respawn", team = Team.kBlue })
location_blueospawn = location_info:new({ text = "Offense Respawn", team = Team.kBlue })
location_bluebackhallway = location_info:new({ text = "Back Hallway", team = Team.kBlue })
location_bluebackhallwayramp = location_info:new({ text = "Back Hallway Ramp", team = Team.kBlue })
location_bluebattlements = location_info:new({ text = "Battlements", team = Team.kBlue })
location_blueupperbattlements = location_info:new({ text = "Upper Battlements", team = Team.kBlue })
location_bluetopfloor = location_info:new({ text = "Top Floor", team = Team.kBlue })
location_bluesecurity = location_info:new({ text = "Security", team = Team.kBlue })
location_bluesecurityramp = location_info:new({ text = "Security Ramp", team = Team.kBlue })
location_bluehole = location_info:new({ text = "Hole in the Wall", team = Team.kBlue })
location_blueelevator = location_info:new({ text = "Elevator", team = Team.kBlue })
location_blueelevatorhallway = location_info:new({ text = "Lower Elevator Hallway", team = Team.kBlue })
location_bluelowerentrance = location_info:new({ text = "Lower Entrance", team = Team.kBlue })
location_bluemainentrance = location_info:new({ text = "Main Entrance", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluemainramp = location_info:new({ text = "Main Ramp", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })
location_temple = location_info:new({ text = "Temple", team = NO_TEAM })
location_templeroof = location_info:new({ text = "Temple Roof", team = NO_TEAM })
location_tomb = location_info:new({ text = "Tomb", team = NO_TEAM })

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

sec_iconx = 60
sec_icony = 30
sec_iconw = 16
sec_iconh = 16

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",20,aardvarksecup10red)
				AddSchedule("aardvarksecupred",30,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("#FF_RED_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
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
				AddSchedule("aardvarksecup10blue",20,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",30,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("#FF_BLUE_SEC_30")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
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
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("#FF_BLUE_SEC_ON")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
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
-- OFFENSIVE AND DEFENSIVE SPAWNS
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kDemoman))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kDemoman))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- plundered bags
-----------------------------------------------------------------------------
blueplunderedpack = genericbackpack:new({
	health = 60,
	armor = 120,
	grenades = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	cells = 130,
	gren1 = 1,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function blueplunderedpack:dropatspawn() return false end

redplunderedpack = genericbackpack:new({
	health = 60,
	armor = 120,
	grenades = 100,
	nails = 100,
	shells = 100,
	rockets = 100,
	cells = 130,
	gren1 = 1,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redplunderedpack:dropatspawn() return false end

redplunderedgrenades = genericbackpack:new({
	detpacks = 1,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	respawntime = 30,
	botgoaltype = Bot.kBackPack_Ammo
})

function redplunderedgrenades:dropatspawn() return false end

blueplunderedgrenades = genericbackpack:new({
	detpacks = 1,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	respawntime = 30,
	botgoaltype = Bot.kBackPack_Ammo
})

function blueplunderedgrenades:dropatspawn() return false end

genpack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 70,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack:dropatspawn() return false 
end

-----------------------------------------------------------------------------
-- Dettable Walls
-----------------------------------------------------------------------------

red_wall = true
blue_wall = true


red_wall_trigger = trigger_ff_script:new({ })

function red_wall_trigger:onexplode( trigger_entity  ) 
if red_wall then
if IsDetpack( trigger_entity ) then
if CastToDetpack( trigger_entity ):GetTeamId() == Team.kBlue then 
OutputEvent( "red_wall", "Break" )
red_wall = false
end
end
return EVENT_ALLOWED
end
end

function red_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end



blue_wall_trigger = trigger_ff_script:new({ })

function blue_wall_trigger:onexplode( trigger_entity  ) 
if blue_wall then
if IsDetpack( trigger_entity ) then
 if CastToDetpack( trigger_entity ):GetTeamId() == Team.kRed then
OutputEvent( "blue_wall", "Break" )
        blue_wall = false
end
end
return EVENT_ALLOWED
end
end

function blue_wall_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end