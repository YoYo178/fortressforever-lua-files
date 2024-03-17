-- FF_EMULATION.LUA

IncludeScript("base_ctf");
IncludeScript("base_teamplay");

red_cap = basecap:new({team = Team.kRed, item = {"red_flag"}})				   
blue_cap = basecap:new({team = Team.kBlue, item = {"blue_flag"}})					
yellow_cap = basecap:new({team = Team.kYellow, item = {"yellow_flag"}})				
green_cap = basecap:new({team = Team.kGreen, item = {"green_flag"}})

function basecap:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
		
		-- check if the player has the flag
		for i,v in ipairs(self.item) do
			local flag = GetInfoScriptByName(v)
			
			-- Make sure flag isn't nil
			if flag then
				if player:HasItem(flag:GetName()) then
					if flag.team then
						ConsoleToAll("flag team = "..flag.team)
					else
						ConsoleToAll("flag team = NIL")
					end
					
					if self.team then
						ConsoleToAll("cap team = "..self.team)
					else
						ConsoleToAll("cap team = NIL")
					end
					
					ConsoleToAll("has "..flag.team.." needs "..self.team)
					if flag.team == self.team then
						return true
					end
				end
			end
		end
	end
	
	return false
end
						
function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		RandomFlagTouchSpeak( player )
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		
		-- show on the deathnotice board
		--ObjectiveNotice( player, "grabbed the flag" )
		-- log action in stats
		LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	
		
		local teamname = nil
		
		-- get team as a lowercase string
		if self.team == Team.kBlue then teamname = "blue" end
		if self.team == Team.kRed then teamname = "red" end
		if self.team == Team.kGreen then teamname = "green" end  
		if self.team == Team.kYellow then teamname = "yellow" end
		
		-- objective icon pointing to the cap
		UpdateObjectiveIcon( player, GetEntityByName( teamname.."_cap" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
		self.carriedby = player:GetName()
		self:refreshStatusIcons(flag:GetName())

	end
end

pyramid_script = trigger_ff_script:new({ })

function pyramid_script:onendtouch( entity )
  if IsPlayer( entity ) then
    local player = CastToPlayer( entity )
	ChatToPlayer(player, "ancient astronaut theoriest believe egypt got all their technologies form space")
  end
end 

function basecap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				-- check if the player is carrying the flag
				if player:HasItem(flag:GetName()) then
					flag.status = 0

					-- reward player for capture
					local fortpoints = (type(self.fortpoints) == "function" and self.fortpoints(self, player) or self.fortpoints)
					player:AddFortPoints(fortpoints, "#FF_FORTPOINTS_CAPTUREFLAG")
					
					-- reward player's team for capture
					local team = player:GetTeam()
					local teampoints = (type(self.teampoints) == "function" and self.teampoints(self, team) or self.teampoints)
					team:AddScore(teampoints)

          			LogLuaEvent(player:GetId(), 0, "flag_capture","flag_name",flag:GetName())
					-- show on the deathnotice board
					ObjectiveNotice( player, "captured the flag" )

					-- clear the objective icon
					UpdateObjectiveIcon( player, nil )

					-- Remove any hud icons
					RemoveHudItem( player, flag:GetName() )

					-- return the flag
					flag:Return()
					
					--Cappin cures what ails ya
					player:RemoveEffect(EF.kOnfire)
					player:RemoveEffect(EF.kConc)
					player:RemoveEffect(EF.kGas)
					player:RemoveEffect(EF.kInfect)
					player:RemoveEffect(EF.kRadiotag)
					player:RemoveEffect(EF.kTranq)
					player:RemoveEffect(EF.kLegshot)
					player:RemoveEffect(EF.kRadiotag)

					-- give player some health and armor
					if self.health ~= nil and self.health ~= 0 then player:AddHealth(self.health) end
					if self.armor ~= nil and self.armor ~= 0 then player:AddArmor(self.armor) end
	
					-- give the player some ammo
					if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
					if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
					if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
					if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
					if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
					if self.mancannons ~= nil and self.mancannons ~= 0 then player:AddAmmo(Ammo.kManCannon, self.mancannons) end
					if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
					if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end
	
					self:oncapture( player, v )
				end
			end
		end
	end
end

function startup()

	SetGameDescription( MakeRandomName(16) )
	
	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	
	AddSchedule("hacks_inbound", 5.0, HacksComing)
	AddSchedule("random_vox", 5.0, RandomVox)
	AddScheduleRepeating("team_names", 1.0, TeamRename)
	AddScheduleRepeating("moveflag", 1.0, MoveFlags)
end

function MoveFlags()

	local bflag = GetInfoScriptByName("blue_flag")
	
	if not bflag:IsCarried() and not bflag:IsDropped() then
		local train = GetEntityByName("trainpos")
		bflag:SetOrigin(train:GetOrigin())
		bflag:SetAngles(train:GetAngles())
	end
	
	local yflag = GetInfoScriptByName("yellow_flag")
	
	if RandomInt(1,10) < 2 then
		local pos0 = GetEntityByName("yellow_flag_pos0")
		if not yflag:IsCarried() and not yflag:IsDropped() then
			yflag:SetOrigin(pos0:GetOrigin())
			yflag:SetAngles(pos0:GetAngles())
		end
	elseif RandomInt(1,10) > 8 then
		local pos1 = GetEntityByName("yellow_flag_pos1")
		if not yflag:IsCarried() and not yflag:IsDropped() then
			yflag:SetOrigin(pos1:GetOrigin())
			yflag:SetAngles(pos1:GetAngles())
		end
	end
end

function HacksComing()
	RemoveSchedule("hacks_inbound")
	BroadCastMessage(ff_messages[RandomInt(1,#ff_messages)],RandomFloat(0.1, 0.9), RandomInt(0,10))
	AddSchedule("hacks_inbound", RandomFloat(0.5, 10.0), HacksComing)
end

function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	
	if (player:GetClass() == Player.kScout) then
	
		player:RemoveAllWeapons()
		player:AddAmmo( Ammo.kNails, 400 )
		player:AddAmmo( Ammo.kShells, 400 )
		player:AddAmmo( Ammo.kRockets, 400 )
		player:AddAmmo( Ammo.kCells, 400 )
		player:AddAmmo( Ammo.kDetpack, 1 )
		player:AddAmmo( Ammo.kManCannon, 1 )
		
		local meleeWeapons = {"ff_weapon_medkit", "ff_weapon_knife", "ff_weapon_spanner", "ff_weapon_crowbar"}
		local weapons = { "ff_weapon_assaultcannon", "ff_weapon_autorifle", "ff_weapon_deploydetpack", "ff_weapon_deploysentrygun", "ff_weapon_flamethrower", "ff_weapon_grenadelauncher", "ff_weapon_ic", "ff_weapon_nailgun", "ff_weapon_pipelauncher", "ff_weapon_railgun", "ff_weapon_rpg", "ff_weapon_shotgun", "ff_weapon_sniperrifle", "ff_weapon_supernailgun", "ff_weapon_supershotgun", "ff_weapon_tranq"}

		local meleeWeaponNames = {"Medkit", "Knife", "Spanner", "Crowbar"}
		local weaponNames = { "Assault Cannon", "Autorifle", "DETPACK", "Sentrygun", "Flamethrower", "Grenade Launcher", "Incendiary Cannon", "Nailgun", "Pipe Launcher", "Railgun", "RPG", "Shotgun", "Sniper Rifle", "Supernailgun", "Supershotgun", "Tranq"}

		weapon0 = RandomInt(1,#meleeWeapons)
		weapon1 = RandomInt(1,#weapons)
		weapon2 = 0
		weapon3 = 0
		
		repeat
			weapon2 = RandomInt(1,#weapons)
		until weapon2 ~= weapon1
		
		repeat
			weapon3 = RandomInt(1,#weapons)
		until weapon3 ~= weapon1 and weapon3 ~= weapon2
		
		player:GiveWeapon(meleeWeapons[weapon0], true)
		player:GiveWeapon(weapons[weapon1], true)
		player:GiveWeapon(weapons[weapon2], true)
		player:GiveWeapon(weapons[weapon3], true)
		
		ChatToPlayer(player, "GOT " .. meleeWeaponNames[weapon0] .. ", " .. weaponNames[weapon1] .. ", " .. weaponNames[weapon2] .. ", " .. weaponNames[weapon3])
	end
end

ff_messages = {"#FF_HELLO", "#FF_Attack1", "#FF_Attack2", "#FF_Gren1", "#FF_Gren2", "#FF_ToggleGren1", "#FF_ToggleGren2", "#FF_TeamOptions", "#FF_ChangeTeam", "#FF_ChangeClass", "#FF_CHANGECLASS_LATER", "#FF_DiscardAmmo", "#FF_DropItems", "#FF_FlagInfo", "#FF_Reset_View", "#FF_Mouse_Look", "#FF_Keyboard_Look", "#FF_HintCenter", "#FF_MapShot", "#FF_MedEngyMenu", "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", "#FF_YOUDROP", "#FF_TEAMDROP", "#FF_OTHERTEAMDROP", "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", "#FF_ROUND_60SECWARN", "#FF_ROUND_45SECWARN", "#FF_ROUND_30SECWARN", "#FF_ROUND_15SECWARN", "#FF_ROUND_10SECWARN", "#FF_ROUND_5SECWARN", "#FF_ROUND_STARTED", "#FF_MAP_600SECWARN", "#FF_MAP_300SECWARN", "#FF_MAP_120SECWARN", "#FF_MAP_60SECWARN", "#FF_MAP_30SECWARN", "#FF_MAP_10SECWARN", "#FF_MAP_9SECWARN", "#FF_MAP_8SECWARN", "#FF_MAP_7SECWARN", "#FF_MAP_6SECWARN", "#FF_MAP_5SECWARN", "#FF_MAP_4SECWARN", "#FF_MAP_3SECWARN", "#FF_MAP_2SECWARN", "#FF_MAP_1SECWARN", "#FF_AD_TAKE1", "#FF_AD_TAKE2", "#FF_AD_TAKE3", "#FF_AD_CAP1", "#FF_AD_CAP2", "#FF_AD_BLUEWIN", "#FF_AD_REDWIN", "#FF_AD_GATESOPEN", "#FF_YOUSCORE", "#FF_TEAMSCORE", "#FF_ENEMYSCORE", "#FF_YOUHAVEBALL", "#FF_TEAMHASBALL", "#FF_ENEMYHASBALL", "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP", "#FF_BALLRETURN", "#FF_SPY_ALREADYFEIGNED", "#FF_SPY_NOTFEIGNED", "#FF_SPY_DISCOVERED", "#FF_SPY_CANTFEIGNSPEED", "#FF_DISPENSER_ENEMIESUSING", "#FF_DISPENSER_DESTROYED", "#FF_SENTRYGUN_DESTROYED", "#FF_DETPACK_DEFUSED", "#FF_MANCANNON_DESTROYED", "#FF_MANCANNON_TIMEOUT", "#FF_BUILDERROR_MANCANNON_NOTENOUGHAMMO", "#FF_BUILDERROR_DETPACK_ALREADYSET", "#FF_BUILDERROR_DISPENSER_ALREADYBUILT", "#FF_BUILDERROR_SENTRYGUN_ALREADYBUILT", "#FF_BUILDERROR_DISPENSER_NOTENOUGHAMMO", "#FF_BUILDERROR_SENTRYGUN_NOTENOUGHAMMO", "#FF_BUILDERROR_DETPACK_NOTENOUGHAMMO", "#FF_BUILDERROR_NOBUILD", "#FF_BUILDERROR_MUSTBEONGROUND", "#FF_BUILDERROR_MULTIPLEBUILDS", "#FF_BUILDERROR_NOPLAYER", "#FF_BUILDERROR_WORLDBLOCK", "#FF_BUILDERROR_GROUNDSTEEP", "#FF_BUILDERROR_GROUNDDISTANCE", "#FF_BUILDERROR_GENERIC", "#FF_CANTCLOAK_MUSTBEONGROUND", "#FF_CANTCLOAK_TIMELIMIT", "#FF_CANTCLOAK", "#FF_SILENTCLOAK_MUSTBESTILL", "#FF_CLOAK", "#FF_UNCLOAK", "#FF_SPY_NODISGUISENOW", "#FF_SPY_DISGUISING", "#FF_SPY_LOSTDISGUISE", "#FF_SPY_FORCEDLOSTDISGUISE", "#FF_SPY_DISGUISED", "#FF_SPY_BEENREVEALED", "#FF_SPY_REVEALEDSPY", "#FF_SPY_BEENREVEALEDCLOAKED", "#FF_SPY_REVEALEDCLOAKEDSPY", "#FF_SABOTAGEREADY", "#FF_SABOTAGERESET", "#FF_SABOTAGERESETTING", "#FF_SABOTAGEDETONATING", "#FF_SENTRYSABOTAGEREADY", "#FF_SENTRYSABOTAGERESET", "#FF_SENTRYSABOTAGERESETTING", "#FF_SENTRYSABOTAGEDETONATING", "#FF_DISPENSERSABOTAGEREADY", "#FF_DISPENSERSABOTAGERESET", "#FF_DISPENSERSABOTAGERESETTING", "#FF_DISPENSERSABOTAGEDETONATING", "#FF_MUSTBEONGROUND", "#FF_TOOFARAWAY", "#FF_RADARTOOSOON", "#FF_RADARCELLS", "#FF_ERROR_ALREADYONTHISTEAM", "#FF_ERROR_TEAMFULL", "#FF_DISPENSER_MALFUNCTIONED", "#FF_SENTRYGUN_MALFUNCTIONED", "#FF_ERROR_SWITCHTOOSOON", "#FF_ERROR_CANTSWITCHCLASS", "#FF_ENGY_NODISPENSER", "#FF_ENGY_NOSENTRY", "#FF_ENGY_NODISPENSERTODET", "#FF_ENGY_NOSENTRYTODET", "#FF_ENGY_NODISPENSERTODISMANTLE", "#FF_ENGY_NOSENTRYTODISMANTLE", "#FF_ENGY_CANTDETWHENDEAD", "#FF_ENGY_CANTDISMANTLEWHENDEAD", "#FF_ENGY_CANTDISMANTLEORDETWHENDEAD", "#FF_ENGY_CANTUSEENGYMENUWHENDEAD", "#FF_ENGY_CANTDETMIDBUILD", "#FF_ENGY_CANTDISMANTLEMIDBUILD", "#FF_ENGY_CANTAIMSENTRYWHENBUILDINGIT", "#FF_ENGY_CANTAIMSENTRYWHENDEAD", "#FF_NOTALLOWEDDOOR", "#FF_NOTALLOWEDBUTTON", "#FF_NOTALLOWEDELEVATOR", "#FF_NOTALLOWEDPACK", "#FF_NOTALLOWEDGENERIC", "#FF_BUILDING_DETPACK", "#FF_BUILDING_DISPENSER", "#FF_BUILDING_SENTRY", "#FF_BUILDERROR_MOVEABLE", "#FF_RED_SECURITY_ACTIVATED", "#FF_BLUE_SECURITY_ACTIVATED", "#FF_YELLOW_SECURITY_ACTIVATED", "#FF_GREEN_SECURITY_ACTIVATED", "#FF_RED_SECURITY_DEACTIVATED", "#FF_BLUE_SECURITY_DEACTIVATED", "#FF_YELLOW_SECURITY_DEACTIVATED", "#FF_GREEN_SECURITY_DEACTIVATED", "#FF_CZ2_YOU_CP1", "#FF_CZ2_YOU_CP2", "#FF_CZ2_YOU_CP3", "#FF_CZ2_YOU_CP4", "#FF_CZ2_YOU_CP5", "#FF_CZ2_YOURTEAM_CP1", "#FF_CZ2_YOURTEAM_CP2", "#FF_CZ2_YOURTEAM_CP3", "#FF_CZ2_YOURTEAM_CP4", "#FF_CZ2_YOURTEAM_CP5", "#FF_CZ2_YOURTEAM_COMPLETE", "#FF_CZ2_OTHERTEAM_CP1", "#FF_CZ2_OTHERTEAM_CP2", "#FF_CZ2_OTHERTEAM_CP3", "#FF_CZ2_OTHERTEAM_CP4", "#FF_CZ2_OTHERTEAM_CP5", "#FF_CZ2_OTHERTEAM_COMPLETE", "#FF_CZ2_YOU_CC", "#FF_CZ2_YOURTEAM_CC", "#FF_CZ2_OTHERTEAM_CC", "#FF_CZ2_USE_RESPAWN", "#FF_CZ2_USE_TELEPORT", "#FF_CZ2_USE_DOORS", "#FF_WATERPOLO_YOU_RETURN", "#FF_WATERPOLO_TEAM_GOALIE_RETURN", "#FF_WATERPOLO_ENEMY_GOALIE_RETURN", "#FF_WATERPOLO_YOU_PICKUP", "#FF_WATERPOLO_TEAM_PICKUP", "#FF_WATERPOLO_ENEMY_PICKUP", "#FF_WATERPOLO_BALL_RETURN", "#FF_WATERPOLO_YOU_GOAL", "#FF_WATERPOLO_TEAM_GOAL", "#FF_WATERPOLO_ENEMY_GOAL", "#FF_WATERPOLO_YOU_OWN_GOAL", "#FF_WATERPOLO_TEAM_OWN_GOAL", "#FF_WATERPOLO_ENEMY_OWN_GOAL", "#FF_WATERPOLO_YOU_BOUNDS", "#FF_WATERPOLO_TEAM_BOUNDS", "#FF_WATERPOLO_ENEMY_BOUNDS", "#FF_WATERPOLO_GRENADES", "#FF_WATERPOLO_NO_GRENADES_FOR_YOU", "#FF_WATERPOLO_GOALIE_BOUNDS", "#FF_WATERPOLO_USE_RETURN", "#FF_FORTPOINTS_FRAG", "#FF_FORTPOINTS_UNCLOAKSPY", "#FF_FORTPOINTS_TEAMMATERADIOTAGKILL", "#FF_FORTPOINTS_CUREINFECTION", "#FF_FORTPOINTS_RADIOTAG", "#FF_FORTPOINTS_GIVEHEALTH", "#FF_FORTPOINTS_GIVEARMOR", "#FF_FORTPOINTS_DEFUSEDETPACK", "#FF_FORTPOINTS_UNDISGUISESPY", "#FF_FORTPOINTS_SABOTAGEDISPENSER", "#FF_FORTPOINTS_SABOTAGESG", "#FF_FORTPOINTS_KILLDISPENSER", "#FF_FORTPOINTS_KILLSG1", "#FF_FORTPOINTS_KILLSG2", "#FF_FORTPOINTS_KILLSG3", "#FF_FORTPOINTS_REPAIRTEAMDISPENSER", "#FF_FORTPOINTS_UPGRADETEAMMATESG", "#FF_FORTPOINTS_REPAIRTEAMMATESG", "#FF_FORTPOINTS_CAPTUREFLAG", "#FF_FORTPOINTS_CAPTUREPOINT", "#FF_FORTPOINTS_CAPTUREPOINT_ASSIST", "#FF_FORTPOINTS_DEFENDPOINT", "#FF_FORTPOINTS_DEFENDPOINT_ASSIST", "#FF_FORTPOINTS_DESTROY_CC", "#FF_FORTPOINTS_TEAMKILL", "#FF_FORTPOINTS_INITIALTOUCH", "#FF_FORTPOINTS_SUICIDE", "#FF_FORTPOINTS_GOAL", "#FF_FORTPOINTS_OWN_GOAL", "#FF_FORTPOINTS_GOALIE_RETURN", "#FF_FORTPOINTS_GOALIE_ATTACK", "#FF_CM_DISGUISEFRIENDLY", "#FF_CM_DISGUISEENEMY", "#FF_CM_DISGUISEBLUE", "#FF_CM_DISGUISERED", "#FF_CM_DISGUISEYELLOW", "#FF_CM_DISGUISEGREEN", "#FF_CM_CLOAK", "#FF_CM_SCLOAK", "#FF_CM_SMARTCLOAK", "#FF_CM_SABOTAGESENTRY", "#FF_CM_SABOTAGEDISPENSER", "#FF_CM_CALLMEDIC", "#FF_CM_CALLAMMO", "#FF_CM_CALLARMOR", "#FF_CM_AIMSENTRY", "#FF_CM_BUILDDISPENSER", "#FF_CM_BUILDSENTRY", "#FF_CM_DISMANTLEDISPENSER", "#FF_CM_DISMANTLESENTRY", "#FF_CM_DETDISPENSER", "#FF_CM_DETSENTRY", "#FF_CM_DETPACK5", "#FF_CM_DETPACK10", "#FF_CM_DETPACK20", "#FF_CM_DETPACK50", "#AD_FlagCarriedBy", "#AD_FlagReturn", "#AD_FlagReturnBase", "#AD_FlagIsAt", "#AD_ASpawn", "#AD_Cap", "#AD_Defend", "#AD_FlagAtBase", "#AD_30SecReturn", "#AD_10SecReturn", "#ADZ_30SecWarning", "#ADZ_10SecWarning", "#ADZ_Defend", "#ADZ_NoScore", "#ADZ_Switch5Min", "#ADZ_Switch2Min", "#ADZ_Switch1Min", "#ADZ_Switch30Sec", "#ADZ_Switch10Sec", "#ADZ_Switch", "#ADZ_Round", "#ADZ_End5Min", "#ADZ_End2Min", "#ADZ_End1Min", "#ADZ_End30Sec", "#ADZ_End10Sec", "#FF_RED_SEC_60", "#FF_RED_SEC_40", "#FF_RED_SEC_30", "#FF_RED_SEC_10", "#FF_RED_SEC_ON", "#FF_BLUE_SEC_60", "#FF_BLUE_SEC_40", "#FF_BLUE_SEC_30", "#FF_BLUE_SEC_10", "#FF_BLUE_SEC_ON", "#FF_BLUE_GRATEBLOWN", "#FF_RED_GRATEBLOWN", "#FF_BLUE_GENBLOWN", "#FF_RED_GENBLOWN", "#FF_BLUE_GEN_OK", "#FF_RED_GEN_OK", "#FF_BLUE_GENWALL", "#FF_RED_GENWALL", "#HINT_NOJUMPPAD", "#FF_UPDATE_STATUS_FOUND", "#FF_UPDATE_STATUS_NOTFOUND", "#FF_UPDATE_STATUS_ERROR", "#FF_UPDATE_STATUS_CONFLICT", "#FF_UPDATE_STATUS_CHECKING", "#FF_UPDATE_TITLE_OUTOFDATE", "#FF_UPDATE_TITLE_CONFLICT", "#FF_UPDATE_DOWNLOAD"}

function RandomVox()
	RemoveSchedule("random_vox")
	
	local speakStrings = {"AD_600SEC", "AD_300SEC", "AD_120SEC", "AD_60SEC", "AD_30SEC", "AD_10SEC", "AD_9SEC", "AD_8SEC", "AD_7SEC", "AD_6SEC", "AD_5SEC", "AD_4SEC", "AD_3SEC", "AD_2SEC", "AD_1SEC", "AD_CP1", "AD_CP2", "AD_HOLD", "AD_CAP", "AD_GATESOPEN", "AD_ATTACK", "AD_DEFEND", "SD_REDDOWN", "SD_REDUP", "SD_BLUEDOWN", "SD_BLUEUP", "CTF_YOUSCORE", "CTF_TEAMSCORE", "CTF_THEYSCORE", "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL", "CTF_BALLRETURN"}
	SpeakAll(speakStrings[RandomInt(1,#speakStrings)])
	
	AddSchedule("random_vox", RandomFloat(1.0, 4.0), RandomVox)
end

function TeamRename()
	SetTeamName( Team.kRed, MakeRandomName(18) )
	SetTeamName( Team.kBlue, MakeRandomName(18) )
	SetTeamName( Team.kGreen, MakeRandomName(18) )
	SetTeamName( Team.kYellow, MakeRandomName(18) )
end

function MakeRandomName(length)
	characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~!@#$%^&*()_+=-{[]}|\\/?<>,.;:'\""
	name = ""
	for i = 1, length do
		r = RandomInt(1,#characters)
		name = name.. string.sub(characters, r, r)
	end
	return name
end

freeconcs = trigger_ff_script:new({ })

function freeconcs:ontrigger( entity )
  if IsPlayer( entity ) then
    local player = CastToPlayer( entity )
	if player:HasItem("yellow_flag") then
		player:AddAmmo( Ammo.kGren2, 4 )
	end
  end
end
