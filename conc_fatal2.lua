-----------------------------------------------------------------
-- Conc_fatal.lua modified for zE Palace Servers
-----------------------------------------------------------------

IncludeScript("base_teamplay");
IncludeScript("base_ctf4");
IncludeScript("base_location");
IncludeScript("power_quad");

-----------------------------------------------------------------
-- Cvars specific for zE Palace servers, if you dont have those --plugins remove this part or might crash your server!
-----------------------------------------------------------------

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

-----------------------------------------------------------------
-- Teams
-----------------------------------------------------------------

function startup()
SetTeamName( Team.kBlue, "Conc" )
SetTeamName( Team.kRed, "Quad" )
SetTeamName( Team.kYellow, "Double" )
SetTeamName( Team.kGreen, "Easy Quad" )

SetPlayerLimit( Team.kBlue, 0 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, -1 )
SetPlayerLimit( Team.kGreen, 0 )

-- BLUE TEAM
local team = GetTeam( Team.kBlue )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- RED TEAM
local team = GetTeam( Team.kRed )
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, -1 )

-- Yellow TEAM
local team = GetTeam( Team.kYellow )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- Green TEAM
local team = GetTeam( Team.kGreen )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

end

-----------------------------------------------------------------
-- Disable conc effect
-----------------------------------------------------------------

CONC_EFFECT = 0

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

-----------------------------------------------------------------
-- BAGS
----------------------------------------------------------------

backpack = genericbackpack:new({
	rockets = 50,
	gren = 4,
	shells = 60, 	cells = 60,
	nails = 60,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function backpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kPyro then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kSniper then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kEngineer then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
		end
		
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

----------------------------------------------------------------
-- Make sound on bag respawn
----------------------------------------------------------------

function grenadebackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function grenadebackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

----------
--Locs----
----------


location_1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_7 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_8 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_9 = location_info:new({ text = "Jump 9", team = NO_TEAM })
location_10 = location_info:new({ text = "Jump 10", team = NO_TEAM })
location_11 = location_info:new({ text = "Jump 11", team = NO_TEAM })
location_12 = location_info:new({ text = "Jump 12", team = NO_TEAM })
location_13 = location_info:new({ text = "Jump 13", team = NO_TEAM })
location_14 = location_info:new({ text = "Jump 14", team = NO_TEAM })
location_15 = location_info:new({ text = "Jump 15", team = NO_TEAM })
location_16 = location_info:new({ text = "Jump 16", team = NO_TEAM })
location_17 = location_info:new({ text = "Jump 17", team = NO_TEAM })
location_18 = location_info:new({ text = "Jump 18", team = NO_TEAM })
location_19 = location_info:new({ text = "Jump 19", team = NO_TEAM })
location_20 = location_info:new({ text = "Jump 20", team = NO_TEAM })
location_21 = location_info:new({ text = "Jump 21", team = NO_TEAM })
location_22 = location_info:new({ text = "Jump 22", team = NO_TEAM })
location_23 = location_info:new({ text = "Jump 23", team = NO_TEAM })
location_24 = location_info:new({ text = "Jump 24", team = NO_TEAM })
location_25 = location_info:new({ text = "Jump 25", team = NO_TEAM })
location_26 = location_info:new({ text = "Jump 26", team = NO_TEAM })
location_27 = location_info:new({ text = "Jump 27", team = NO_TEAM })
location_28 = location_info:new({ text = "Jump 28", team = NO_TEAM })
location_29 = location_info:new({ text = "Jump 29", team = NO_TEAM })
location_finish = location_info:new({ text = "Finish", team = NO_TEAM })

-----
------------------------------------------------------
--FLAGS -- taken from Concmap.lua by Public_Slots_Free
------------------------------------------------------
-----


local flags = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}


-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock


secret_1 = baseflag:new({team = Team.kRed,
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
						  
secret_2 = baseflag:new({team = Team.kYellow,
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

secret_3 = baseflag:new({team = Team.kGreen,
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
					   item = {"secret_1"}})


-- yellow cap point						
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"secret_2"}})

-- green cap point						
green_cap = basecap:new({team = Team.kGreen,
						item = {"secret_3"}})


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
	gren1 = 0,
	gren2 = 0,
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

   					-- Unlock Secret Jump
					OutputEvent("secret_manager", "Disable")
					OutputEvent("secret_kill", "Disable")
					OutputEvent("secret_jump", "Enable")
					
					
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

----------------
--FINISH--------
----------------

finish = trigger_ff_script:new({})

function finish:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 15000, "Map Completed")
            player:AddFrags( 100 )
            
            BroadCastMessage( player:GetName() .. " has Completed conc fatal 2!" )
         end
end

