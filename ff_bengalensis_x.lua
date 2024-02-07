-- ff_aardvark.lua

 function precache()
PrecacheSound( "*headz/ammopak.wav" )
end


-----------------------------------------------------------------------------
-- number of snipers allowed per team
-----------------------------------------------------------------------------
SNIPER_LIMIT = -1;

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
-- unique aardvark locations
-----------------------------------------------------------------------------
location_upperexit = location_info:new({ text = "Upper Exit", team = Team.kRed })
location_securityarea = location_info:new({ text = "Security Area", team = Team.kRed })
location_midmap = location_info:new({ text = "Mid Map Area", team = Team.kRed })
location_ramps = location_info:new({ text = "Lift Area", team = Team.kRed })
location_bridgearea = location_info:new({ text = "Bridge Area", team = Team.kRed })
location_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })
location_lowerexit = location_info:new({ text = "Lower Exit", team = Team.kRed })
location_redspawn = location_info:new({ text = "Upper Red Spawn", team = Team.kRed })


-----------------------------------------------------------------------------
-- set class limits
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("Capture the Flag")
SetGameDescription( "Offense vs Defense" )

	SetTeamName(Team.kBlue, "Offense")
	SetTeamName(Team.kRed, "Defense")
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kEngineer, 3)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)
end

-----------------------------------------------------------------------------
-- custom aardvark packs
-----------------------------------------------------------------------------
aardvarkpack = genericbackpack:new({
	health = 20,
	armor = 30,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 1,
	gren2 = 1,
	respawntime = 15,
	model = "models/props/penn//bengal/bengal.mdl",
	materializesound = "headz.bagspawn",
	touchsound = "headz.bag",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_metal = genericbackpack:new({
	health = 20,
	armor = 30,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	respawntime = 15,
	model = "models/props/penn/bengal/bengal.mdl",
	materializesound = "headz.bagspawn",
	touchsound = "headz.bag",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end
function aardvarkpack_metal:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpack)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack:new({touchflags = tf}),
		   aardvarkpack_metal:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack, blue_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_aardvarkpack, red_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack, yellow_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack, green_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

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

--------------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

redspawn_top = { validspawn = red_o_only }
redspawn_fr = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

bluespawn_top = { validspawn = blue_o_only }
bluespawn_fr = { validspawn = blue_d_only }

-------------------------------------------------------------------------
-- custom death sound
-------------------------------------------------------------------------



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
