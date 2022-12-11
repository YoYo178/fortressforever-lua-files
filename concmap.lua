local flags = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}

IncludeScript("base_location");
IncludeScript("base_ctf4");


FORTPOINTS_PER_INITIALTOUCH = 0
FORTPOINTS_PER_CAPTURE = 2500

function startup()

	SetTeamName( Team.kBlue, "Concers" )
	SetTeamName( Team.kRed, "Quad" )
	SetTeamName( Team.kGreen, "Concers" )
	SetTeamName( Team.kYellow, "Concers" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	
	
	-- RED TEAM
	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kBlue )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )

	-- GREEN TEAM
	team = GetTeam( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	
	-- YELLOW TEAM
	team = GetTeam( Team.kYellow )
	team:SetAllies( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )


	-- Disables if LUA is present
	OutputEvent("luaCheck", "Disable")
	
end

function precache()
	PrecacheSound("misc.doop")
end

-- Disable conc effect.
function player_onconc( player_entity, concer_entity )
	return false
end


-- Fully resupplies the player.
function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )
	
     if player:GetTeamId() ~= Team.kRed then
	player:AddAmmo( Ammo.kGren1, -4 )
	player:AddAmmo( Ammo.kGren2, 4 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, -400 )
	player:AddAmmo( Ammo.kCells, -400 )
     else
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kRockets, 100 )
	player:AddAmmo( Ammo.kCells, 100 )
	player:AddAmmo( Ammo.kGren2, -4 )
end
end


-- Fully resupplies the player on spawn.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	fullresupply( player )
end

resuppz = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resuppz:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow.vtf",
						 hudx = 5,
						 hudy = 210,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

blue_flag2 = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag2 = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag2 = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow.vtf",
						 hudx = 5,
						 hudy = 210,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag2 = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

-- red cap point
red_cap = basecap:new({team = Team.kRed,
					   item = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}})

-- blue cap point					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}})

-- yellow cap point						
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}})

-- green cap point						
green_cap = basecap:new({team = Team.kGreen,
						item = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}})


-----------------------------------------------------------------------------
-- Flag (allows own team to get their flag)
-----------------------------------------------------------------------------

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	-- make sure they don't have any flags already
	for i,v in ipairs(flags) do
		if player:HasItem(v) then return end
	end
	
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

-----------------------------------------------------------------------------
-- Capture Points (allow for flag specific cap points)
-----------------------------------------------------------------------------

basecap = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	bullets = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

bluerspawn = info_ff_script:new()

function basecap:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
		local team = player:GetTeam()
	
		-- check if the player has the flag
		for i,v in ipairs(self.item) do
			local flag = GetInfoScriptByName(v)
			
			-- Make sure flag isn't nil
			if flag then
				if player:HasItem(flag:GetName()) then
					return true
				end
			end
		end
	end
	
	return false
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
					
					-- reward player for capture
					player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_CAPTUREFLAG")
					
					-- log action in stats
					player:AddAction(nil, "ctf_flag_cap", flag:GetName())
							
					-- Remove any hud icons
					-- local flag2 = CastToInfoScript(flag)
					RemoveHudItem( player, flag:GetName() )
					RemoveHudItemFromAll( flag:GetName() .. "_c" )
					RemoveHudItemFromAll( flag:GetName() .. "_d" )

					-- return the flag
					flag:Return()
	
					self:oncapture( player, v )
				end
			end
		end
	end
end

function basecap:oncapture(player, item)
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
end

------------------------------------------------------------------
-- REMOVE NADES
------------------------------------------------------------------

grenade_remove1 = trigger_ff_script:new({})

function grenade_remove1:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:AddAmmo( Ammo.kGren1, -4 )
		player:AddAmmo( Ammo.kGren2, -4 )
		BroadCastMessageToPlayer(player, "You dropped your concs!")
	end
end


------------------------------------------------------------------
-- Quad Damage
------------------------------------------------------------------
function player_ondamage( player, damageinfo )
	class = player:GetClass()
	if class == Player.kSoldier or class == Player.kDemoman or class == Player.kPyro then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	    damageinfo:SetDamage( 0 )
	end
end

----------------------------------------------------------------------
-- Quad icon
----------------------------------------------------------------------

hudicon = "hud_quad"
hudx = 365
hudy = 438
hudw = 40
hudh = 40
huda = 1
hudstatusicon = "hud_quad.vtf"

----------------------------------------------------------------------
-- Set hud icon at spawn
----------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	fullresupply( player )
	local class = player:GetClass()
    	if class == Player.kSoldier or class == Player.kDemoman or class == Player.kPyro then
	    if player:GetTeamId() ~= Team.kRed then
		RemoveHudItem( player, hudstatusicon )
	    else
		AddHudIcon(player, hudicon, hudstatusicon, hudx, hudy, hudw, hudh, huda)
	    end
	else
	    RemoveHudItem( player, hudstatusicon )
	end
end

----------------------------------------------------------------------
-- Remove hud icon if player changes to spectator
----------------------------------------------------------------------

function player_switchteam( player, currentteam, desiredteam )
    if desiredteam == Team.kSpectator then
    	RemoveHudItem( player, hudstatusicon )
    end
    return true
end

------------------------------------------------------------------
-- LOCATIONS
------------------------------------------------------------------

location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 10", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_jump8 = location_info:new({ text = "Jump 9", team = NO_TEAM })
location_jump9 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump10 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_end = location_info:new({ text = "END", team = NO_TEAM })
location_nolua = location_info:new({ text = "ROOM OF DEATH", team = NO_TEAM })
