-- ff_destroyz_b1 
-- based on openfire + Pon.Id adjustment 15/09/07

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_shutdown");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
-----------------------------------------------------------------------------
	SetTeamName( Team.kBlue, "Blue :D" )
        SetTeamName( Team.kRed, "Red :O" )
-----------------------------------------------------------------------------
-- unique openfire locations
-----------------------------------------------------------------------------
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redsec = location_info:new({ text = "Laser Control", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redwater = location_info:new({ text = "Perilous Passage", team = Team.kRed })
location_redfrontdoor = location_info:new({ text = "Lower Corridor", team = Team.kRed })
location_redbalcony = location_info:new({ text = "Balcony", team = Team.kRed })

location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Laser Control", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluewater = location_info:new({ text = "Perilous Passage", team = Team.kBlue })
location_bluefrontdoor = location_info:new({ text = "Lower Corridor", team = Team.kBlue })
location_bluebalcony = location_info:new({ text = "Balcony", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })

-----------------------------------------------------------------------------
-- override the baseflag:touch function from base_teamplay
-- to stop players being able to pick flag up through the security door
-----------------------------------------------------------------------------
blue_flag.secstatus = "in"
red_flag.secstatus = "in"
-- functions to keep track of whether flags are in or out of the security zone
location_blueflagout = trigger_ff_script:new()
location_blueflagin = trigger_ff_script:new()
location_redflagout = trigger_ff_script:new()
location_redflagin = trigger_ff_script:new()

function location_blueflagout:ontouch( touch_entity )
	if  CastToInfoScript(touch_entity) == GetInfoScriptByName("blue_flag") then
		blue_flag.secstatus = "out"
	end
end
function location_blueflagin:ontouch( touch_entity )
	if  touch_entity == GetInfoScriptByName("blue_flag") then
		blue_flag.secstatus = "in"
	end
end
function location_redflagout:ontrigger( touch_entity )
	if  CastToInfoScript(touch_entity) == GetInfoScriptByName("red_flag") then
		red_flag.secstatus = "out"
		ConsoleToAll("RedFlag is OUT")
	else
		ConsoleToAll("Flag didn't touch me")
	end
end
function location_redflagin:ontrigger( touch_entity )
	if  CastToInfoScript(touch_entity) == GetInfoScriptByName("red_flag") then
		red_flag.secstatus = "in"
		ConsoleToAll("RedFlag is IN")
	end
end


-- overrided version of the base_teamplay function
function baseflag:touch( touch_entity )
	-----------------------------------------------------------------------------
	-- NEW CODE
	-----------------------------------------------------------------------------
	-- can't pick up if that teamsecurity is up and flag is in security
	if self.team == Team.kBlue and bluesecstatus == 1 and self.sectatus == "in" then return; end
	if self.team == Team.kRed and redsecstatus == 1 and self.sectatus == "in" then ConsoleToALL("FLAG touch DENIED") ; return; end
	-- END OF NEW CODE
	-----------------------------------------------------------------------------
	
	
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP")
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		RemoveHudItemFromAll( flag:GetName() .. "_h" )
		RemoveHudItemFromAll( flag:GetName() .. "_d" )
		AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flag:GetName() .. "_c" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )

		-- log action in stats
		player:AddAction(nil, "ctf_flag_touch", flag:GetName())

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
	end
end




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

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",20,aardvarksecup10red)
				AddSchedule("aardvarksecupred",30,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("Red Security Deactivated for 30 Seconds")
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
				AddSchedule("aardvarksecup10blue",20,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",30,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("Blue Security Deactivated for 30 Seconds")
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
-- Ammo Kit (customised from default ammobackpack)
-----------------------------------------------------------------------------
baseammopack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function baseammopack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Grenade Backpack (customised from default grenadebackpack)
-----------------------------------------------------------------------------
basegrenpack = genericbackpack:new({
	mancannons = 1,
	gren1 = 1,
	gren2 = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function basegrenpack:dropatspawn() return false end

blue_ammobackpack = baseammopack:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})
red_ammobackpack = baseammopack:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
blue_grenadebackpack = basegrenpack:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})
red_grenadebackpack = basegrenpack:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})