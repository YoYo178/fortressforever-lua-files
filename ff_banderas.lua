
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");

FLAG_RETURN_TIME = 30
POINT_INTERVAL = 10
POINT_AMOUNT = 1
ALLCAP_POINTS_AMOUNT = 50
FORTPOINTS_PER_CAPTURE = 250

function startup()

	-- set up team limits
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )


	local team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	AddScheduleRepeating("addpoints", POINT_INTERVAL, addpoints)
end

hud_flags = {
	["mflag1"] = {x=60, y=86},
	["mflag2"] = {x=42, y=86},
	["mflag3"] = {x=42, y=102},
	["mflag4"] = {x=60, y=102},

	["bflag1"] = {x=56, y=40},
	["bflag2"] = {x=79, y=43},
	["bflag3"] = {x=77, y=66},
	["bflag4"] = {x=107, y=85},

	["rflag1"] = {x=36, y=135},
	["rflag2"] = {x=16, y=132},
	["rflag3"] = {x=17, y=108},
	["rflag4"] = {x=0, y=90}
}
allflags = {"flag1","flag2","flag3","flag4"}
blue_cappoints = {"blue_cp_1", "blue_cp_2", "blue_cp_3", "blue_cp_4"}
red_cappoints = {"red_cp_1", "red_cp_2", "red_cp_3", "red_cp_4"}


function addpoints()
	local flagsheld = 0
	local team = GetTeam(Team.kBlue)
	if blue_cp_1:hasFlag() then
		flagsheld=flagsheld+1
	end
	if blue_cp_2:hasFlag() then
		flagsheld=flagsheld+1
	end
	if blue_cp_3:hasFlag() then
		flagsheld=flagsheld+1
	end
	if blue_cp_4:hasFlag() then
		flagsheld=flagsheld+1
	end
	team:AddScore(flagsheld)

	flagsheld=0
	local team = GetTeam(Team.kRed)
	if red_cp_1:hasFlag() then
		flagsheld=flagsheld+1
	end
	if red_cp_2:hasFlag() then
		flagsheld=flagsheld+1
	end
	if red_cp_3:hasFlag() then
		flagsheld=flagsheld+1
	end
	if red_cp_4:hasFlag() then
		flagsheld=flagsheld+1
	end
	team:AddScore(flagsheld)
end

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
	mflag4 = 0,
}

--flag shit
function move_flag_respawn_to(flagname, entname, respawnnow, updateteam, cpname)
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

		AddHudIconToAll("hud_flag_home_neutral", "hud_"..flagname, hud_flags[entname].x, hud_flags[entname].y, 16, 16, 1 )

		if updateteam ~= nil then
			local newteam = TeamAllowed[entname]
			
			if flagname == "flag1" then
				flag1.team = newteam
				flag1.home = cpname
			end
			if flagname == "flag2" then
				flag2.team = newteam
				flag2.home = cpname

			end
			if flagname == "flag3" then
				flag3.team = newteam
				flag3.home = cpname

			end
			if flagname == "flag4" then
				flag4.team = newteam
				flag4.home = cpname
			end

		end
	else
--		ConsoleToAll("cant move "..flagname.." to "..entname)
	end
end

-----------------------------------------------------------------------------
-- cappoints (from flagrun b6)
-----------------------------------------------------------------------------

banderas_basecap = basecap:new({ vacant=true, myname=""})
function banderas_basecap:hasFlag ( )
	if self.vacant then return false
	else return true
	end
end

function banderas_basecap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				--Carl: don't cap if we already have a flag
				if self.vacant then
				-- check if the player is carrying the flag
				if player:HasItem(v) then
				
					-- reward player for capture
					player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_CAPTUREFLAG")

					-- give player some health and armor
					if self.health ~= nil and self.health ~= 0 then player:AddHealth( self.health ) end
					if self.armor ~= nil and self.armor ~= 0 then player:AddArmor( self.armor ) end
	
					-- give player ammo
					if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
					if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
					if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
					if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
					if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
					if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
					if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end

					-- return the flag
					--flag:Return()

					RemoveHudItem( player, flag:GetName() )

					move_flag_respawn_to(v, self.capspot, true, true, self.myname)

					if self.team == Team.kRed then
					flag:SetSkin(1)
					else
					if self.team == Team.kBlue then flag:SetSkin(0) end
					end

					--Carl: occupado. 
					self.vacant = false
					
					self:oncapture( player, v )
				end
				end --Carl
			end
		end
	end
end

function banderas_basecap:oncapture(player, item)
	-- let the teams know that a capture occured
  	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
  	SmartSound(player, "vox.yourcap", "vox.yourcap", "vox.enemycap")
  	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
end

red_cp_1 = banderas_basecap:new({ team = Team.kRed, item = allflags, capspot="rflag1", myname="red_cp_1" })
red_cp_2 = banderas_basecap:new({ team = Team.kRed, item = allflags, capspot="rflag2", myname="red_cp_2" })
red_cp_3 = banderas_basecap:new({ team = Team.kRed, item = allflags, capspot="rflag3", myname="red_cp_3" })
red_cp_4 = banderas_basecap:new({ team = Team.kRed, item = allflags, capspot="rflag4", myname="red_cp_4" })

blue_cp_1 = banderas_basecap:new({ team = Team.kBlue, item = allflags, capspot="bflag1", myname="blue_cp_1" })
blue_cp_2 = banderas_basecap:new({ team = Team.kBlue, item = allflags, capspot="bflag2", myname="blue_cp_2"  })
blue_cp_3 = banderas_basecap:new({ team = Team.kBlue, item = allflags, capspot="bflag3", myname="blue_cp_3"  })
blue_cp_4 = banderas_basecap:new({ team = Team.kBlue, item = allflags, capspot="bflag4", myname="blue_cp_4"  })


-----------------------------------------------------------------------------
-- flags (from flagrun b6)
-----------------------------------------------------------------------------
banderas_baseflag = baseflag:new({
	home=nil,
	hudicon = "hud_flag_neutral",
	model = "models/flag/flag.mdl",
	modelskin = 4,
	hudx = 5,
	hudy = 250,
	hudwidth = 48,
	hudheight = 48,
	hudalign = 1, 
	dropnotouchtime = .5,
	status = 0
})

function banderas_baseflag:onreturn( )
	BroadCastMessage("A flag has returned to the center of the map. Get it quickly!")

	AddHudIconToAll("hud_flag_home_neutral", "hud_flag"..self.flagnum, hud_flags[self.returnspot].x, hud_flags[self.returnspot].y, 16, 16, 1 )
	self.status = 0

	if self.home ~= nil then
		local flag = CastToInfoScript(entity)
		local homecap = GetInfoScriptByName( self.home )
		if homecap.team == Team.kRed then
		flag:SetSkin(1)
		else
		if homecap.team == Team.kBlue then flag:SetSkin(0) end
		end
	end
end

function banderas_baseflag:forceReturn( )
	AddHudIconToAll("hud_flag_home_neutral", "hud_flag"..self.flagnum, hud_flags[self.returnspot].x, hud_flags[self.returnspot].y, 16, 16, 1 )
	self.status = 0
end

function banderas_baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then
--		ConsoleToAll("won't pick up because of drop notouch")
		return
	end
	
	--if player has flag already dont let him pick another up
	for i,v in ipairs( allflags ) do
		if player:HasItem(v) then
			return
		end
	end
	
	if player:GetTeamId() ~= self.team then
		
		--SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		--SmartSound(player, "vox.yourstole", "vox.yourstole", "vox.enemystole")
		
		-- if the player is a spy, then force him to lose his disguise
--Carl		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		--Carl: tell the cap point to clear, if applicable

		if self.home then
			flag:SetSkin(4)
			local cp_number =""
			if self.home == "blue_cp_1" then
				blue_cp_1.vacant=true
				cp_number = "one"
			end
			if self.home == "blue_cp_2" then
				blue_cp_2.vacant=true
				cp_number = "two"
			end
			if self.home == "blue_cp_3" then
				blue_cp_3.vacant=true
				cp_number = "three"
			end
			if self.home == "blue_cp_4" then
				blue_cp_4.vacant=true
				cp_number = "four"
			end
			if self.home == "red_cp_1" then
				red_cp_1.vacant=true
				cp_number = "one"
			end
			if self.home == "red_cp_2" then
				red_cp_2.vacant=true
				cp_number = "two"
			end
			if self.home == "red_cp_3" then
				red_cp_3.vacant=true
				cp_number = "three"
			end
			if self.home == "red_cp_4" then
				red_cp_4.vacant=true
				cp_number = "four"
			end
			SmartMessage(player, "You have a flag. Capture it at your base.", "Your team has stolen the enemy's flag at cap point "..cp_number.."!", "The enemy has stolen your flag at cap point "..cp_number.."!")
		else
			--just give the player the message
			BroadCastMessageToPlayer(player, "You have a flag. Capture it at your base.")
			if self.status == 0 then RemoveHudItemFromAll( "hud_flag" .. self.flagnum ) end 
		end
		self.home=nil
		self.team=0
		self.status = 1

	
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

function banderas_baseflag:dropitemcmd( owner_entity )

	if allowdrop == false then return end

	-- throw the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
	local player = CastToPlayer( owner_entity )
	self:addnotouch(player:GetId(), self.dropnotouchtime)

	-- remove flag icon from hud
	RemoveHudItem( player, flag:GetName() )
	self.status = 2
end	

function banderas_baseflag:ondrop( owner_entity )
	local player = CastToPlayer( owner_entity )
	-- let the teams know that the flag was dropped
	--SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
	--SmartMessage(player, "#FF_YOUDROP", "#FF_TEAMDROP", "#FF_OTHERTEAMDROP")
	
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
end

function banderas_baseflag:onloseitem( owner_entity )
	local player = CastToPlayer( owner_entity )
	--player:SetDisguisable(true)
	player:SetCloakable( true )
end

flag1 = banderas_baseflag:new({ flagnum=1, returnspot="mflag1" })
flag2 = banderas_baseflag:new({ flagnum=2, returnspot="mflag2" })
flag3 = banderas_baseflag:new({ flagnum=3, returnspot="mflag3" })
flag4 = banderas_baseflag:new({ flagnum=4, returnspot="mflag4" })

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )
	AddHudIcon(player, "banderasmap.vtf", "mapoverlay", 0, 40, 128, 128, 1 ) --x,y,h,w, align
	if flag1.status == 0 then
		if flag1.home then
			local cp = GetInfoScriptByName(flag1.home)
			AddHudIcon(player, "hud_flag_home_neutral", "hud_flag1", hud_flags[cp.capspot].x, hud_flags[cp.capspot].y, 16, 16, 1 )
		else AddHudIcon(player, "hud_flag_home_neutral", "hud_flag1", hud_flags[flag1.returnspot].x, hud_flags[flag1.returnspot].y, 16, 16, 1 )
		end
	end
	if flag2.status == 0 then
		if flag2.home then
			local cp = GetInfoScriptByName(flag2.home)
			AddHudIcon(player, "hud_flag_home_neutral", "hud_flag2", hud_flags[cp.capspot].x, hud_flags[cp.capspot].y, 16, 16, 1 )
		else AddHudIcon(player, "hud_flag_home_neutral", "hud_flag2", hud_flags[flag2.returnspot].x, hud_flags[flag2.returnspot].y, 16, 16, 1 )
		end
	end
	if flag3.status == 0 then
		if flag3.home then
			local cp = GetInfoScriptByName(flag3.home)
			AddHudIcon(player, "hud_flag_home_neutral", "hud_flag3", hud_flags[cp.capspot].x, hud_flags[cp.capspot].y, 16, 16, 1 )
		else AddHudIcon(player, "hud_flag_home_neutral", "hud_flag3", hud_flags[flag3.returnspot].x, hud_flags[flag3.returnspot].y, 16, 16, 1 )
		end
	end
	if flag4.status == 0 then
		if flag4.home then
			local cp = GetInfoScriptByName(flag4.home)
			AddHudIcon(player, "hud_flag_home_neutral", "hud_flag4", hud_flags[cp.capspot].x, hud_flags[cp.capspot].y, 16, 16, 1 )
		else AddHudIcon(player, "hud_flag_home_neutral", "hud_flag4", hud_flags[flag4.returnspot].x, hud_flags[flag4.returnspot].y, 16, 16, 1 )
		end
	end
end

--------------
--backpacks
--------------
blue_smallpack = ammobackpack:new({
	health = 30,
	armor = 30,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_smallpack = ammobackpack:new({
	health = 30,
	armor = 30,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})


--------------------------------------------
--Grates
--------------------------------------------

base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		if detpack:GetTeamId() ~= self.team then
			OutputEvent( "grate_" ..self.team_name .."_" ..self.number.. "a", "Kill" )
			OutputEvent( "grate_" ..self.team_name .."_" ..self.number.. "b", "Enable" ) --broken prop
		end
	end

	return EVENT_ALLOWED
end

grate_trigger_blue_1 = base_grate_trigger:new({ team = Team.kBlue, number = "1", team_name="blue" })
grate_trigger_blue_2 = base_grate_trigger:new({ team = Team.kBlue, number = "2", team_name="blue" })
grate_trigger_blue_3 = base_grate_trigger:new({ team = Team.kBlue, number = "3", team_name="blue" })
grate_trigger_red_1 = base_grate_trigger:new({ team = Team.kRed, number = "1", team_name="red" })
grate_trigger_red_2 = base_grate_trigger:new({ team = Team.kRed, number = "2", team_name="red" })
grate_trigger_red_3 = base_grate_trigger:new({ team = Team.kRed, number = "3", team_name="red" })

--------------
--locations
--------------
location_nml = location_info:new({ text = "Neutral Zone", team = NO_TEAM })

location_red_cp1 = location_info:new({ text = "Capture point 1", team = Team.kRed })
location_red_cp2 = location_info:new({ text = "Capture point 2", team = Team.kRed })
location_red_cp3 = location_info:new({ text = "Capture point 3", team = Team.kRed })
location_red_cp4 = location_info:new({ text = "Capture point 4", team = Team.kRed })

location_blue_cp1 = location_info:new({ text = "Capture point 1", team = Team.kBlue })
location_blue_cp2 = location_info:new({ text = "Capture point 2", team = Team.kBlue })
location_blue_cp3 = location_info:new({ text = "Capture point 3", team = Team.kBlue })
location_blue_cp4 = location_info:new({ text = "Capture point 4", team = Team.kBlue })

--------------
--respawn flag removal
--------------
function noannoyances:ontrigger(trigger_entity)
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		for i,v in ipairs( allflags ) do
			if player:HasItem(v) then
				local flag = GetInfoScriptByName(v)
				flag:Return()
				SmartMessage(player, "Flags are not allowed in the spawn area. Flag returned.", "A flag has returned to the center of the map. Get it quickly!", "A flag has returned to the center of the map. Get it quickly!")
				RemoveHudItem( player, v )
				if v == "flag1" then
					flag1:forceReturn()
				end
				if v == "flag2" then
					flag2:forceReturn()
				end
				if v == "flag3" then
					flag3:forceReturn()
				end
				if v == "flag4" then
					flag4:forceReturn()
				end
			end
		end
	end
end 