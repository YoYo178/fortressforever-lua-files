IncludeScript("base_ctf4");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

CONC_EFFECT = 0
FLAG_RETURN_TIME = 200
FORTPOINTS_PER_CAPTURE = 1500
FORTPOINTS_PER_INITIALTOUCH = 150

function startup()

	SetTeamName( Team.kBlue, "Blue Team" )
	SetTeamName( Team.kRed, "Red Team" )
	SetTeamName( Team.kYellow, "Yellow Team" )
	SetTeamName( Team.kGreen, "Green Team" )

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
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )

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

	--Disables trigger_hurt only if player has LUA
	OutputEvent("luaCheck", "Disable")
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




-----------------------------------------------------------------------------
-- Flag (allows own team to get their flag)
-----------------------------------------------------------------------------

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
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

-- red cap points
red_cap = basecap:new({team = Team.kRed,
						item = {"red_flag"}})
red_cap1 = basecap:new({team = Team.kRed,
						item = {"blue_flag"}})
red_cap2 = basecap:new({team = Team.kRed,
						item = {"green_flag"}})
red_cap3 = basecap:new({team = Team.kRed,
						item = {"yellow_flag"}})

-- blue cap points					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag"}})
blue_cap1 = basecap:new({team = Team.kBlue,
						item = {"blue_flag"}})
blue_cap2 = basecap:new({team = Team.kBlue,
						item = {"green_flag"}})
blue_cap3 = basecap:new({team = Team.kBlue,
						item = {"yellow_flag"}})

-- yellow cap points					
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"red_flag"}})
yellow_cap1 = basecap:new({team = Team.kYellow,
						item = {"blue_flag"}})
yellow_cap2 = basecap:new({team = Team.kYellow,
						item = {"green_flag"}})
yellow_cap3 = basecap:new({team = Team.kYellow,
						item = {"yellow_flag"}})

-- green cap points					
green_cap = basecap:new({team = Team.kGreen,
						item = {"red_flag"}})
green_cap1 = basecap:new({team = Team.kGreen,
						item = {"blue_flag"}})
green_cap2 = basecap:new({team = Team.kGreen,
						item = {"green_flag"}})
green_cap3 = basecap:new({team = Team.kGreen,
						item = {"yellow_flag"}})
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


grenade_remove2 = trigger_ff_script:new({})

function grenade_remove2:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:AddAmmo( Ammo.kGren1, -4 )
		player:AddAmmo( Ammo.kGren2, -4 )
		OutputEvent("marioT", "PlaySound")

	end
end

------------------------------------------------------------------
-- SECRETS
------------------------------------------------------------------

secret_tele_ent = trigger_ff_script:new({})

function secret_tele_ent:ontouch(touch_entity)
    if IsPlayer(touch_entity) then
        local player = CastToPlayer(touch_entity)
	ConsoleToAll( player:GetName() .. " has found a secret!" )
	BroadCastMessage( player:GetName() .. " has found a secret!" )
	player:AddFortPoints(250, "Secret Found")
    end
end

secret_tele_fin = trigger_ff_script:new({})

function secret_tele_fin:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(1750, "Finished Secret")
	end
end

secret_tele_finX = trigger_ff_script:new({})

function secret_tele_finX:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(2250, "Finished Secret (HARD)")
	end
end

------------------------------------------------------------------
-- FF POINTS ADD
------------------------------------------------------------------

jumpComp = trigger_ff_script:new({})

function jumpComp:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(250, "Jump Completed")
	end
end

jumpCompX = trigger_ff_script:new({})

function jumpCompX:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(725, "Jumps Completed")
	end
end

mazeComp = trigger_ff_script:new({})

function mazeComp:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(600, "Maze Completed")
	end
end

------------------------------------------------------------------
-- FF POINTS MINUS
------------------------------------------------------------------

wrongTeleL = trigger_ff_script:new({})

function wrongTeleL:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(-175, "Wrong Way")
		BroadCastMessageToPlayer(player, "That wasn't right...")
	end
end

wrongTeleN = trigger_ff_script:new({})

function wrongTeleN:ontouch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		player:AddFortPoints(-250, "Wrong Way")
		BroadCastMessageToPlayer(player, "Ugh, what am I doing??")
	end
end

------------------------------------------------------------------
-- CONC SUPPLY ZONE
------------------------------------------------------------------

function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, -400 )
	player:AddAmmo( Ammo.kCells, -400 )
	
	player:AddAmmo( Ammo.kGren1, -4 )
	player:AddAmmo( Ammo.kGren2, 4 )
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

------------------------------------------------------------------
-- NO CONC EFFECT
------------------------------------------------------------------

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

grenadebackpack = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = -4,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function grenadebackpack:dropatspawn() return false end

------------------------------------------------------------------
-- LOCATIONS
------------------------------------------------------------------

location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_jump8 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_jump9 = location_info:new({ text = "Jump 9", team = NO_TEAM })
location_jump10 = location_info:new({ text = "Jump 10", team = NO_TEAM })
location_lost = location_info:new({ text = "Lost", team = NO_TEAM })
location_nolua = location_info:new({ text = "ROOM OF DEATH", team = NO_TEAM })
location_maze = location_info:new({ text = "Maze", team = NO_TEAM })
location_woods = location_info:new({ text = "Woods", team = NO_TEAM })
location_expert = location_info:new({ text = "Expert Jump", team = NO_TEAM })


------------------------------------------------------------------
-- Messages to Player
------------------------------------------------------------------

windy_txt = trigger_ff_script:new({})

function windy_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "You feel a breeze")
	end
end

fall_txt = trigger_ff_script:new({})

function fall_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "AHHHHHHHHHH")
	end
end

wtf_txt = trigger_ff_script:new({})

function wtf_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "WTF?!")
	end
end

breeze_txt = trigger_ff_script:new({})

function breeze_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "You feel a breeze at your back")
	end
end

mario_txt = trigger_ff_script:new({})

function mario_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		OutputEvent("marioT", "StopSound")
		OutputEvent("marioF", "PlaySound")
		BroadCastMessageToPlayer(player, "Sorry Mario but the princess is in another castle")
	end
end

Twoways_txt = trigger_ff_script:new({})

function Twoways_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "There appears to be two ways out of here")
	end
end

almost_txt = trigger_ff_script:new({})

function almost_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "It can't be too much further")
	end
end

familiar_txt = trigger_ff_script:new({})

function familiar_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "I've been here before in a past life")
	end
end

InWater_txt = trigger_ff_script:new({})

function InWater_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "What's that in the water?")
	end
end

flashlight_txt = trigger_ff_script:new({})

function flashlight_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Hmm, dark. I better use my flashlight")
	end
end

choice_txt = trigger_ff_script:new({})

function choice_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Blue to finish the map. Red to try an experts jump.")
	end
end

lucky_txt = trigger_ff_script:new({})

function lucky_txt:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer(player, "Feeling lucky punk?")
	end
end