-----------------------------------------------------------------------------------------------------------------------------
-- INCLUDES
-----------------------------------------------------------------------------------------------------------------------------

IncludeScript("base_shutdown");
IncludeScript("base_location");

SECURITY_LENGTH = 40

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_blue_flag	= location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blue_uhall	= location_info:new({ text = "Flag Room Upper Hallway", team = Team.kBlue })
location_blue_fronthall	= location_info:new({ text = "Front Hallway", team = Team.kBlue })
location_blue_security	= location_info:new({ text = "Security Area", team = Team.kBlue })
location_blue_capbridge	= location_info:new({ text = "Capture Point Bridge", team = Team.kBlue })
location_blue_cappoint	= location_info:new({ text = "Capture Point", team = Team.kBlue })
location_blue_liftroom	= location_info:new({ text = "Lift Room", team = Team.kBlue })
location_blue_tower	= location_info:new({ text = "Tower", team = Team.kBlue })
location_blue_flagwater	= location_info:new({ text = "Flag Room Water Area", team = Team.kBlue })
location_blue_wacess	= location_info:new({ text = "Water Access", team = Team.kBlue })
location_blue_fspawn	= location_info:new({ text = "Front Spawn", team = Team.kBlue })
location_blue_mspawn	= location_info:new({ text = "Main Spawn", team = Team.kBlue })
location_blue_lflaghall	= location_info:new({ text = "Flag Room Hallway", team = Team.kBlue })

location_red_flag	= location_info:new({ text = "Flag Room", team = Team.kRed })
location_red_uhall	= location_info:new({ text = "Flag Room Upper Hallway", team = Team.kRed })
location_red_fronthall	= location_info:new({ text = "Front Hallway", team = Team.kRed })
location_red_security	= location_info:new({ text = "Security Area", team = Team.kRed })
location_red_capbridge	= location_info:new({ text = "Capture Point Bridge", team = Team.kRed })
location_red_cappoint	= location_info:new({ text = "Capture Point", team = Team.kRed })
location_red_liftroom	= location_info:new({ text = "Lift Room", team = Team.kRed })
location_red_tower	= location_info:new({ text = "Tower", team = Team.kRed })
location_red_flagwater	= location_info:new({ text = "Flag Room Water Area", team = Team.kRed })
location_red_wacess	= location_info:new({ text = "Water Access", team = Team.kRed })
location_red_mspawn	= location_info:new({ text = "Main Spawn", team = Team.kRed })
location_red_fspawn	= location_info:new({ text = "Front Spawn", team = Team.kRed })
location_red_lflaghall	= location_info:new({ text = "Flag Room Hallway", team = Team.kRed })

location_yard		= location_info:new({ text = "Yard", team = Team.kUnassigned })

-----------------------------------------------------------------------------
-- Spy doors
-----------------------------------------------------------------------------

specdoor = trigger_ff_script:new({ team = Team.kUnassigned, allowdisguised=true, alarm })

function specdoor:allowed(allowed_entity)
    if IsPlayer(allowed_entity) then
        local player = CastToPlayer(allowed_entity)
	if (player:GetTeamId() == self.team) or (self.allowdisguised and player:IsDisguised() and player:GetDisguisedTeam() == self.team) then
            return EVENT_ALLOWED
        end
    end
    return EVENT_DISALLOWED
end

function specdoor:ontouch(touch_entity)
    if IsPlayer(touch_entity) then
        local player = CastToPlayer(touch_entity)
        if player:IsDisguised() and player:GetTeamId() ~= self.team and player:GetDisguisedTeam() == self.team then
        OutputEvent(self.alarm, "PlaySound")

        end
    end
end

blue_gendoor = specdoor:new({ team = Team.kBlue, alarm = "blue_spy_alert" })
red_gendoor = specdoor:new({ team = Team.kRed, alarm = "red_spy_alert" })
blue_tele_door = specdoor:new({ team = Team.kBlue })
red_tele_door = specdoor:new({ team = Team.kRed })

-----------------------------------------------------------------------------
--  PACKS
-----------------------------------------------------------------------------
	hall_genpack = genericbackpack:new({
	health = 25,
	armor = 10,
	
	grenades = 0,
	nails = 100,
	shells = 25,
	rockets = 15,
	cells = 25,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
	genpack = genericbackpack:new({
	health = 50,
	armor = 25,
	
	grenades = 0,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function genpack:dropatspawn() return false end
blue_genpack = genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_genpack = genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

function genpack:dropatspawn() return false end
blue_hall_genpack = hall_genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_hall_genpack = hall_genpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })


-- grenade backpack
grenpack = grenadebackpack:new({ gren1 = 4, gren2 = 4 })
SNIPER_LIMIT = 1;

-----------------------------------------------------------------------------
-- No Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})
 
function noannoyances:onbuild( build_entity )
        return EVENT_DISALLOWED
end
 
function noannoyances:onexplode( explode_entity )
        if IsGrenade( explode_entity ) then
                return EVENT_DISALLOWED
        end
        return EVENT_DISALLOWED
end
 
function noannoyances:oninfect( infect_entity )
        return EVENT_DISALLOWED
end
 
no_annoyances = noannoyances

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

SNIPER_LIMIT = 1;

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------

base_grate_trigger = trigger_ff_script:new({ })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
			if self.team_name == "red" then BroadCastMessage("#FF_RED_GRATEBLOWN") end
			if self.team_name == "blue" then BroadCastMessage("#FF_BLUE_GRATEBLOWN") end
		end
	end

	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })

-----------------------------------------------------------------------------
-- Generators Destroy
-----------------------------------------------------------------------------

red_gen_trigger = trigger_ff_script:new({ })

function red_gen_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then
	if CastToDetpack( trigger_entity ):GetTeamId() == Team.kBlue then
		if redgenup == 1 then
			redsecstatus = 0
			redgenup = 0
			RemoveSchedule("secup10red")
			RemoveSchedule("beginclosered")
			RemoveSchedule("secupred")
			OutputEvent( "red_logicdown", "Trigger" )
			OpenDoor("red_gen_doorhack")
			BroadCastMessage("#FF_RED_GENBLOWN")
			SpeakAll( "SD_REDDOWN" )
			RemoveHudItemFromAll( "red-sec-up" )
			AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
		end
	end
	end
	return EVENT_ALLOWED
end
function red_gen_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end



blue_gen_trigger = trigger_ff_script:new({ })

function blue_gen_trigger:onexplode( trigger_entity  ) 
	if IsDetpack( trigger_entity ) then
	if CastToDetpack( trigger_entity ):GetTeamId() == Team.kRed then
		if bluegenup == 1 then
			bluesecstatus = 0
			bluegenup = 0
			RemoveSchedule("secup10blue")
			RemoveSchedule("begincloseblue")
			RemoveSchedule("secupblue")
			OutputEvent( "blue_logicdown", "Trigger" )
			OpenDoor("blue_gen_doorhack")
			BroadCastMessage("#FF_BLUE_GENBLOWN")
			SpeakAll( "SD_BLUEDOWN" )
			RemoveHudItemFromAll( "blue-sec-up" )
			AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 2 )
		end
	end
	end
	return EVENT_ALLOWED
end
function blue_gen_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

-----------------------------------------------------------------------------
-- Generators Repair
-----------------------------------------------------------------------------

red_gen_repair_trigger = func_button:new({})
red_gen_repair_trigger_script = trigger_ff_script:new()
redspannerclang = 0
redgenup = 1
redclangcntr = 0

function red_gen_repair_trigger_script:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetActiveWeaponName() == "ff_weapon_spanner" and player:GetTeamId() == Team.kRed then
			redspannerclang = 1
		end
	end
end

function red_gen_repair_trigger_script:onendtouch()
	redspannerclang = 0
end

function red_gen_repair_trigger:ondamage()
	if redspannerclang == 1 then
		if redgenup == 0 then
			OutputEvent( "redspannerhit", "PlaySound" )
			redclangcntr = redclangcntr + 1
            if redclangcntr > 4 then
                redclangcntr = 0             
                BroadCastMessage("#FF_RED_GEN_OK")
                OutputEvent( "red_logicup", "Trigger" )
				redsecstatus = 1
				CloseDoor("red_gen_doorhack")
				redspannerclang = 0
				redgenup = 1
				secupred()
				end
			end
		end
	return EVENT_DISALLOWED
end



blue_gen_repair_trigger = func_button:new({})
blue_gen_repair_trigger_script = trigger_ff_script:new()
bluespannerclang = 0
bluegenup = 1
blueclangcntr = 0


function blue_gen_repair_trigger_script:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			if player:GetActiveWeaponName() == "ff_weapon_spanner" and player:GetTeamId() == Team.kBlue then
				bluespannerclang = 1
			end
	end
end

function blue_gen_repair_trigger_script:onendtouch()
	bluespannerclang = 0
end

function blue_gen_repair_trigger:ondamage()
	if bluespannerclang == 1 then
		 if bluegenup == 0 then
			OutputEvent( "bluespannerhit", "PlaySound" )
			blueclangcntr = blueclangcntr + 1
			if blueclangcntr > 4 then
				blueclangcntr = 0             
				BroadCastMessage("#FF_BLUE_GEN_OK")
				OutputEvent( "blue_logicup", "Trigger" )
				bluesecstatus=1
				CloseDoor("blue_gen_doorhack")
				bluespannerclang = 0
				bluegenup = 1
				secupblue()
			end
		end
	end
	return EVENT_DISALLOWED
end


-----------------------------------------------------------------------------
--  SECURITY
-----------------------------------------------------------------------------

red_sec = trigger_ff_script:new()
blue_sec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

sec_iconx = 60
sec_icony = 30
sec_iconw = 16
sec_iconh = 16

function red_sec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("secup10red", SECURITY_LENGTH - 10, secup10red)
				AddSchedule("beginclosered", SECURITY_LENGTH - 6, beginclosered)
				AddSchedule("secupred",SECURITY_LENGTH,secupred)
				OutputEvent( "red_logicdown", "Trigger" )
				BroadCastMessage("#FF_RED_SEC_40")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
			end
		end
	end
end

function blue_sec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("secup10blue", SECURITY_LENGTH - 10, secup10blue)
				AddSchedule("begincloseblue", SECURITY_LENGTH - 6, begincloseblue)
				AddSchedule("secupblue",SECURITY_LENGTH,secupblue)
				OutputEvent( "blue_logicdown", "Trigger" )
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
	BroadCastMessage("#FF_RED_SEC_ON")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", sec_iconx, sec_icony, sec_iconw, sec_iconh, 3 )
end

function begincloseblue()
	OutputEvent( "blue_logicup", "Trigger" )
end

function beginclosered()
	OutputEvent( "red_logicup", "Trigger" )
end

function secupblue()
	bluesecstatus = 1
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

function flaginfo( player_entity )
	flaginfo_base(player_entity) --see base_teamplay.lua

	local player = CastToPlayer( player_entity )
	
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