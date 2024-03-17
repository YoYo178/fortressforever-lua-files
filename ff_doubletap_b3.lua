--Made for F a T a L for ff_omgz.
--.LUA made by [TALOS]DudeWheresMyMedic.
--www.talos.tv {TALOS home page.}
--http://talos.tv/forum {TALOS Forum.}
--http://talos.tv/forum/32 {Mapping Forum.}
---------------------------------
-- Includes
---------------------------------
IncludeScript("base_shutdown");
IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base");
---------------------------------
-- Global Variables
---------------------------------
BLUE_TEAM_NAME = "Blue"
RED_TEAM_NAME = "Red"
---------------------------------
-- Functions
---------------------------------

-- Startup. Pretty basic stuff.
function startup()
-- set up team limits (only red & blue)(May allow Yellow and Green as spec.)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )
--Team names.
	SetTeamName( Team.kRed, RED_TEAM_NAME )
	SetTeamName( Team.kBlue, BLUE_TEAM_NAME )

	-- Blue Team Class limits (No Civ or Flamer)
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSniper, 1 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 2 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red Team class limits (same)
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSniper, 1 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 2 )
	team:SetClassLimit( Player.kCivilian, -1 )

	AddSchedule("turnoffnormalspawn", 1 , turnoffnormalspawn)
end
-----------------------------------------------------------------------------
--No Annoyances
-- No Fucking Annoyances (Homos from building in front of the spawn, Kill other team if they try to fuck around)
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})

function noannoyances:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function noannoyances:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

function noannoyances:oninfect( infect_entity )
	return EVENT_DISALLOWED 
end

no_annoyances = noannoyances
spawn_protection = noannoyances
-----------------------------------------------------------------------------
-- Grenade Backpack. full both nade and mirv.
-----------------------------------------------------------------------------
grenadebackpack = genericbackpack:new({
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function grenadebackpack:dropatspawn() return false end
-----------------------------------------------------------------------------
-- bagless resupply
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
