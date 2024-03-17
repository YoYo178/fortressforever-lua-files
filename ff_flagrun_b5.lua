-- ff_flagrun_test.lua
-- Expands upon ff_flagrun_beta6.lua provided by Dr. Evil.

-- TO-DO
----------------------------------------------------------
-- Testing
-- Cleanup


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript( "base_teamplay" );
IncludeScript( "base_respawnturret" );
IncludeScript( "base_location" );


-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------

-- because frozen isn't totally frozen :/
flag_pickup_disabled = false


-- Need to make sure the env_fade fits in with whatever this value is.
NEW_ROUND_DELAY = 5

-- I forgot to check TFC's scoring, so I dunno if these are good. Can be altered easily enough if nessecary though.
FLAG_RETURN_TIME = 10
TEAM_POINTS_PER_CAPTURE = 0
TEAM_POINTS_PER_WIN = 30

-- These can use any team colour in the filename. Also, 'l' and 'r' can be used in place of teamcolour (e.g. "hud_flag_dropped_l").
HUD_DROPPED_ICON = "hud_flag_dropped_green.vtf"
HUD_CARRIED_ICON = "hud_flag_carried_green.vtf"
HUD_ICON = "hud_flag_green_new.vtf"

-- Flag skin selection
-- | 0 - blue | 1 - red | 2 - yellow | 3 - green | 4 - neutral/white/gaudy shit |
FLAG_SKIN = 3

MIDFLAG_OPEN_DELAY = 60


-- This table is for keeping track of the HUD, mostly.
flagdata = {
	[1] = { controlling_team = Team.kBlue, flag_number = 1, hudstatusicon = "hud_cp_1.vtf", hudposx = -45, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[2] = { controlling_team = Team.kUnassigned, flag_number = 2, hudstatusicon = "hud_cp_2.vtf", hudposx = -15, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[3] = { controlling_team = Team.kUnassigned, flag_number = 3, hudstatusicon = "hud_cp_3.vtf", hudposx = 15, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[4] = { controlling_team = Team.kRed, flag_number = 4, hudstatusicon = "hud_cp_4.vtf", hudposx = 45, hudposy = 36, hudalign = 4, hudwidth = 16, hudheight = 16 },
}


icons = {
	[Team.kBlue] = { teamicon = "hud_cp_blue.vtf", carriedicon = "hud_flag_carried_blue.vtf" },
	[Team.kRed] = { teamicon = "hud_cp_red.vtf", carriedicon = "hud_flag_carried_red.vtf" },
	[Team.kUnassigned] = { teamicon = "hud_cp_neutral.vtf", carriedicon = HUD_CARRIED_ICON}
}


TeamAllowed =
{
	rflag1 = Team.kRed,
	rflag2 = Team.kRed,
	rflag3 = Team.kRed,
	rflag4 = Team.kRed,
	bflag1 = Team.kBlue,
	bflag2 = Team.kBlue,
	bflag3 = Team.kBlue,
	bflag4 = Team.kBlue,
	mflag1 = 0,
	mflag2 = 0,
	mflag3 = 0,
	mflag4 = 0
}


-----------------------------------------------------------------------------
-- functions
-----------------------------------------------------------------------------

function startup()
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)

	reset_round()
end



-- This handles the meat of the system.
function move_flag_respawn_to(flagname, entname, respawnnow, updateteam)
	local f = GetInfoScriptByName(flagname)
	local e = GetEntityByName(entname)
	if f ~= nil and e ~= nil then
		local o = e:GetOrigin()
		local a = e:GetAngles()
		
		f:SetStartOrigin(o)
		f:SetStartAngles(a)
		
		if respawnnow ~= nil then
			f:Respawn(0)
		end
		
		if updateteam ~= nil then
			local newteam = TeamAllowed[entname]
			local flagnumber = 0
			
			if flagname == "flagrun_flag1" then
				flagrun_flag1.team = newteam
				flagnumber = 1
			end
			if flagname == "flagrun_flag2" then
				flagrun_flag2.team = newteam
				flagnumber = 2
			end
			if flagname == "flagrun_flag3" then
				flagrun_flag3.team = newteam
				flagnumber = 3
			end
			if flagname == "flagrun_flag4" then
				flagrun_flag4.team = newteam
				flagnumber = 4
			end
			
			-- needed for flaginfo function
			flagdata[flagnumber].controlling_team = newteam

			-- remove old flaginfo icons and add new ones
			RemoveHudItemFromAll( flagnumber .. "-background")
			RemoveHudItemFromAll( flagnumber .. "-foreground")

			AddHudIconToAll( icons[ newteam ].teamicon, flagnumber .. "-background", flagdata[flagnumber].hudposx, flagdata[flagnumber].hudposy, flagdata[flagnumber].hudwidth, flagdata[flagnumber].hudheight, flagdata[flagnumber].hudalign)

			AddHudIconToAll( flagdata[flagnumber].hudstatusicon, flagnumber .. "-foreground", flagdata[flagnumber].hudposx, flagdata[flagnumber].hudposy, flagdata[flagnumber].hudwidth, flagdata[flagnumber].hudheight, flagdata[flagnumber].hudalign)
		end
		
		check_gamestate()
	else
		ConsoleToAll("cant move "..flagname.." to "..entname)
	end
end

-- checks to see if any team controls all flags.
-- Typically called when a flag is captured.
function check_gamestate()

	if determine_total_control (Team.kBlue) == true then

		round_end (Team.kBlue, "WIN_BLUE")
		AddSchedule("new_round", NEW_ROUND_DELAY, new_round)
	end
	
	if determine_total_control (Team.kRed) == true then

		round_end (Team.kRed, "WIN_RED")
		AddSchedule("new_round", NEW_ROUND_DELAY, new_round)
	end
end

-- Determines ownership status of all flags.
function determine_total_control (team)

	if flagrun_flag1.team == team and flagrun_flag2.team == team and flagrun_flag3.team == team and flagrun_flag4.team == team then
		return true
	else
		return false
	end
end
	
-- Called on a team's win
function round_end( team, speak_phrase )

	-- freezes players, fades to black
	freezeall_toggle( true )
	OutputEvent( "fade_to_black", "Fade" )
	flag_pickup_disabled = true

	local winners = GetTeam(team)
	
	SmartTeamSpeak( winners, speak_phrase, speak_phrase)
	SmartTeamMessage( winners, "Your Team Wins!", "The Enemy Team Wins!", Color.kYellow, Color.kYellow)
	SmartTeamSound( winners, "yourteam.flagcap", "otherteam.flagcap")
	winners:AddScore(TEAM_POINTS_PER_WIN)



end

-- Resets the state of the flags, etc. at the start and after a win.
function reset_round()

	-- reset flag positions
	ConsoleToAll("Resetting Flags")
	
	CloseDoor("midgates")
	

	-- neutral flags reset first, as reseting a team flag first means the total control check is potentialy still valid
	-- and as such, can trigger 'two wins'.
	move_flag_respawn_to("flagrun_flag2", "mflag2", true, true)
	move_flag_respawn_to("flagrun_flag3", "mflag3", true, true)

	move_flag_respawn_to("flagrun_flag1", "bflag1", true, true)
	move_flag_respawn_to("flagrun_flag4", "rflag4", true, true)
	
	AddSchedule("midflag_open", MIDFLAG_OPEN_DELAY, midflag_open)
	AddSchedule("round_60secwarn", 0, round_60secwarn)
	AddSchedule("round_30secwarn", 30, round_30secwarn)
	AddSchedule("round_10secwarn", 50, round_10secwarn)
	flag_pickup_disabled = false
end

-- freezes all players if passed true, unfreezes if passed false
function freezeall_toggle( condition )
	local c = Collection()
	
	c:GetByFilter( {CF.kPlayers} )
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			player:Freeze( condition )
		end
	end
end


-----------------------------------------------------------------------------
-- Flaginfo function
-----------------------------------------------------------------------------

-- This sets up the HUD to the current state when people connect.
function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	for i,v in ipairs(flagdata) do

		AddHudIcon( player, icons[ v.controlling_team ].teamicon , v.flag_number .. "-background", flagdata[v.flag_number].hudposx, flagdata[v.flag_number].hudposy, flagdata[v.flag_number].hudwidth, flagdata[v.flag_number].hudheight, flagdata[v.flag_number].hudalign)
		AddHudIcon( player, flagdata[v.flag_number].hudstatusicon, v.flag_number .. "-foreground", flagdata[v.flag_number].hudposx, flagdata[v.flag_number].hudposy, flagdata[v.flag_number].hudwidth, flagdata[v.flag_number].hudheight, flagdata[v.flag_number].hudalign)

	end
end


-----------------------------------------------------------------------------
-- Scheduled Functions
-----------------------------------------------------------------------------

function new_round()
	reset_round()
	freezeall_toggle( false )
	ApplyToAll({ AT.kReturnCarriedItems, AT.kReturnDroppedItems, AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips })	
end


function midflag_open()
	OpenDoor("midgates")
	BroadCastMessage("Neutral flags now available!", 5)
	BroadCastSound("flagrun.midgates")
end


function round_60secwarn() BroadCastMessage("Neutral flags available in 60 seconds", 5) end
function round_30secwarn() BroadCastMessage("Neutral flags available in 30 seconds", 5) end
function round_10secwarn() BroadCastMessage("Neutral flags available in 10 seconds", 5) end

-----------------------------------------------------------------------------
-- Door Triggers (copied from base_teamplay, disallowflagcarrier functionality added)
-----------------------------------------------------------------------------

flagrun_respawndoor = trigger_ff_script:new({ team = Team.kUnassigned, allowdisguised=false, disallowflagcarrier=false })

function flagrun_respawndoor:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		
		local player = CastToPlayer( allowed_entity )

		if self.disallowflagcarrier then
			for i,v in ipairs( allflags ) do
				if player:HasItem(v) then 
					return EVENT_DISALLOWED
				end
			end
		end
		
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
		
		if self.allowdisguised then
			if player:IsDisguised() and player:GetDisguisedTeam() == self.team then
				return EVENT_ALLOWED
			end
		end

	end
	return EVENT_DISALLOWED
end

function flagrun_respawndoor:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDDOOR" )
	end
end

bluerespawndoor = flagrun_respawndoor:new({ team = Team.kBlue })
redrespawndoor = flagrun_respawndoor:new({ team = Team.kRed })
greenrespawndoor = flagrun_respawndoor:new({ team = Team.kGreen })
yellowrespawndoor = flagrun_respawndoor:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- doors
-----------------------------------------------------------------------------

r1 = redrespawndoor:new({ disallowflagcarrier=true })
r2 = redrespawndoor:new({ allowdisguised=true })

b1 = bluerespawndoor:new({ disallowflagcarrier=true })
b2 = bluerespawndoor:new({ allowdisguised=true })


-----------------------------------------------------------------------------
-- Flag returners (to stop players holding flags in spawns)
-----------------------------------------------------------------------------

flagrun_flagreturner = trigger_ff_script:new({})

function flagrun_flagreturner:ontrigger( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
	
		for i,v in ipairs( allflags ) do
			if player:HasItem(v) then 
				-- return the flag
				local flag = GetInfoScriptByName(v)

				-- remove HUD Icon
				RemoveHudItem( player, flag:GetName() )

				-- return the flag to the center
				flag:Return()

				
				local team = GetTeam( player:GetTeamId() )
			
				SmartTeamMessage(team, "A flag has returned to the center!", "A flag has returned to the center!", Color.kYellow, Color.kYellow)
				SmartTeamSound(team, "otherteam.flagreturn", "otherteam.flagreturn")
				BroadCastMessageToPlayer( player, "No flags allowed in resupply! Flag Returned!", 5, Color.kRed)


				return
			end
		end
	end

end


-----------------------------------------------------------------------------
-- cappoints
-----------------------------------------------------------------------------

flagrun_basecap = basecap:new({ flagnum=1, returnspot="mflag1" })

-- Requires some differences from the defaul due to the flag system, origin/angles alterations and so on.
function flagrun_basecap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				-- check if the player is carrying the flag
				if player:HasItem(v) then
				
					-- reward player for capture
					player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_CAPTUREFLAG")
					
					-- reward player's team for capture
					local team = player:GetTeam()
					team:AddScore(TEAM_POINTS_PER_CAPTURE)
					
					-- remove HUD Icon
					RemoveHudItem( player, flag:GetName() )

					-- return the flag
					flag:Return()
					
					local capspot = self.prefix.."flag"..i
					move_flag_respawn_to(v, capspot, true, true)
					
					self:oncapture( player, v )
				end
			end
		end
	end
end

-- Used mostly to deafen people when flags are captured.
function flagrun_basecap:oncapture(player, item)
	-- let the teams know that a capture occured
	
	local capping_team = player:GetTeam()

	-- Other sounds will be played elsewhere if this is true
	if determine_total_control (capping_team:GetTeamId()) ~= true then
		SmartSound(player, "misc.doop", "misc.doop", "otherteam.flagstolen")
		SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", Color.kGreen, Color.kGreen, Color.kRed)
	end
end


allflags = {"flagrun_flag1","flagrun_flag2","flagrun_flag3","flagrun_flag4"}

redcap = flagrun_basecap:new({ team = Team.kRed, item = allflags, prefix="r" })
bluecap = flagrun_basecap:new({ team = Team.kBlue, item = allflags, prefix="b" })

-----------------------------------------------------------------------------
-- flags
-----------------------------------------------------------------------------

-- Yer basic crappy flag.
flagrun_baseflag = baseflag:new({ 
	name = "flagrun_baseflag",
	team = Team.kUnassigned,
	model = "models/flag/flag.mdl",
	modelskin = FLAG_SKIN,
	dropnotouchtime = 2,
	capnotouchtime = 2,
	botgoaltype = Bot.kFlag,
	status = 0,
	hudicon = HUD_ICON,
	hudstatusicondropped = HUD_DROPPED_ICON,
	hudstatusiconcarried = HUD_CARRIED_ICON,
	hudx = 5,
	hudy = 80,
	hudwidth = 70,
	hudheight = 70,
	hudalign = 1, 
	allowdrop = false,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

-- Contains a number of alterations from the base_teamplay default. 
-- Most notably the origin/angles alterations
function flagrun_baseflag:touch( touch_entity )

	-- When players are frozen, they still 'slide'. This stops that being a problem, hopefully.
	if flag_pickup_disabled then return end

	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	--if player has flag already dont let him pick another up
	for i,v in ipairs( allflags ) do
		if player:HasItem(v) then 
		return end
	end
	
	if player:GetTeamId() ~= self.team then
		
		-- let the teams know that the flag was picked up
		SmartSound(player, "misc.buzwarn", "misc.buzwarn", "misc.dadeda")
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )

		move_flag_respawn_to(self.name, self.returnspot, nil, true)

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
		self:refreshStatusIcons(flag:GetName(), player:GetTeamId())
		
		-- set it up for respawn somewhere else when dropped and returned
		if self.returnspot ~= nil then
			local e = GetEntityByName(self.returnspot)
			local o = e:GetOrigin()
			local a = e:GetAngles()
			
			flag:SetStartOrigin(o)
			flag:SetStartAngles(a)
		end
		
	end
end


-- required as the base_teamplay equivalent is fucked when the condition is false...!
function flagrun_baseflag:dropitemcmd( owner_entity )
	if self.allowdrop == false then return end
end	

-- This makes people cry.
function flagrun_baseflag:precache()
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("misc.doop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.dadeda")
	PrecacheSound("flagrun.midgates")
	info_ff_script.precache(self)
end


--All your flag HUD status needs in a convenient package (sort of)
function flagrun_baseflag:refreshStatusIcons(flagname, team)

	RemoveHudItemFromAll( flagname .. "_status" )
	RemoveHudItemFromAll( flagname .. "timer" )

	if team then
		if self.status == 1 then
			AddHudIconToAll( icons[team].carriedicon, ( flagname .. "_status" ), flagdata[self.flagnum].hudposx, flagdata[self.flagnum].hudposy, flagdata[self.flagnum].hudwidth, flagdata[self.flagnum].hudheight, flagdata[self.flagnum].hudalign )
		elseif self.status == 2 then
			AddHudIconToAll( self.hudstatusicondropped, ( flagname .. "_status" ), flagdata[self.flagnum].hudposx, flagdata[self.flagnum].hudposy, flagdata[self.flagnum].hudwidth, flagdata[self.flagnum].hudheight, flagdata[self.flagnum].hudalign )
		end
	else
		if self.status == 1 then
			AddHudIconToAll( self.hudstatusiconcarried, ( flagname .. "_status" ), flagdata[self.flagnum].hudposx, flagdata[self.flagnum].hudposy, flagdata[self.flagnum].hudwidth, flagdata[self.flagnum].hudheight, flagdata[self.flagnum].hudalign )
		elseif self.status == 2 then
			AddHudIconToAll( self.hudstatusicondropped, ( flagname .. "_status" ), flagdata[self.flagnum].hudposx, flagdata[self.flagnum].hudposy, flagdata[self.flagnum].hudwidth, flagdata[self.flagnum].hudheight, flagdata[self.flagnum].hudalign )
		end
	end

end

function flagrun_baseflag:onreturn( )

	-- since the team property of a flag is always changing, this needed to be done slightly differently.
	BroadCastMessage("A flag has returned to the center!", 3, Color.kYellow)
	BroadCastSound("otherteam.flagreturn")

	local flag = CastToInfoScript( entity )

	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());

	RemoveHudItemFromAll( flag:GetName() .. "location" )
	self.status = 0
	self.droppedlocation = ""
	self:refreshStatusIcons(flag:GetName())
end

-- flag entity definitions
flagrun_flag1 = flagrun_baseflag:new({ name="flagrun_flag1", flagnum=1, returnspot="mflag1" })
flagrun_flag2 = flagrun_baseflag:new({ name="flagrun_flag2", flagnum=2, returnspot="mflag2" })
flagrun_flag3 = flagrun_baseflag:new({ name="flagrun_flag3", flagnum=3, returnspot="mflag3" })
flagrun_flag4 = flagrun_baseflag:new({ name="flagrun_flag4", flagnum=4, returnspot="mflag4" })

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

--blue--
location_blueflagroomhall = location_info:new({ text = "Flagroom Hallway", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_blueyard = location_info:new({ text = "Blue Yard", team = Team.kBlue })
location_bluetunnel = location_info:new({ text = "Main Tunnel", team = Team.kBlue })
location_bluebattlements = location_info:new({ text = "Battlements", team = Team.kBlue })
location_bluerespawnhallway = location_info:new({ text = "Blue Respawn Hallway", team = Team.kBlue })
location_bluebalcony = location_info:new({ text = "Balcony", team = Team.kBlue })
location_bluedarktunnel = location_info:new({ text = "Rear Tunnel", team = Team.kBlue })
location_bluerespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_blueramps = location_info:new({ text = "Ramp Building", team = Team.kBlue })
location_bluerearresupply = location_info:new({ text = "Rear Resupply", team = Team.kBlue })

--mainyard--
location_mainyard = location_info:new({ text = "Main Yard", team = NO_TEAM })
location_tower = location_info:new({ text = "The Tower", team = NO_TEAM })

--red--
location_redflagroomhall = location_info:new({ text = "Upper Flagroom Hallway", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Flagroom", team = Team.kRed })
location_redyard = location_info:new({ text = "Red Yard", team = Team.kRed })
location_redtunnel = location_info:new({ text = "Main Tunnel", team = Team.kRed })
location_redbattlements = location_info:new({ text = "Battlements", team = Team.kRed })
location_redrespawnhallway = location_info:new({ text = "Respawn Hallway", team = Team.kRed })
location_redbalcony = location_info:new({ text = "Balcony", team = Team.kRed })
location_reddarktunnel = location_info:new({ text = "Rear Tunnel", team = Team.kRed })
location_redrespawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redramps = location_info:new({ text = "Ramp Building", team = Team.kRed })
location_redrearresupply = location_info:new({ text = "Rear Resupply", team = Team.kRed })