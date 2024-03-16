--djump_ez_b1 by zE
---------------------------------
IncludeScript("base_ctf4");
IncludeScript("base_location");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

----------------------------
-- Toggle Concussion Effect.
----------------------------
CONC_EFFECT = 0



function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

---------------------------------
function startup()

AddScheduleRepeating( "restock", 1, restock_all )

	SetTeamName( Team.kBlue, "Medium :0" )
        SetTeamName( Team.kRed, "Hard :x" )
        SetTeamName( Team.kYellow, "Easy :)" )
        SetTeamName( Team.kGreen, "Newbies :(" )
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )

        local team = GetTeam( Team.kYellow )
        team:SetAllies( Team.kGreen )
        team:SetAllies( Team.kBlue )
        team:SetAllies( Team.kRed )
	

        team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )    
   

	local team = GetTeam( Team.kGreen )
        team:SetAllies( Team.kYellow )
        team:SetAllies( Team.kBlue )
        team:SetAllies( Team.kRed )
	

        team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

        local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kGreen )
        team:SetAllies( Team.kYellow )
        team:SetAllies( Team.kRed )
       

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

        local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kGreen )
        team:SetAllies( Team.kBlue )
        team:SetAllies( Team.kYellow )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )
end

-----------------------------------------------------------------------------
-- Ammo Check
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

        class = player:GetClass()
	if class == Player.kSniper then
		player:RemoveWeapon( "ff_weapon_sniperrifle" )
		
               
                
	else
		player:AddAmmo( Ammo.kShells, 100 )

                
                
	end

        class = player:GetClass()
	if class == Player.kSoldier then
		player:RemoveWeapon( "ff_weapon_rpg" )
		
               
                
	else
		player:AddAmmo( Ammo.kShells, 100 )

                
                
	end

        class = player:GetClass()
	if class == Player.kPyro then
		player:RemoveWeapon( "ff_weapon_incendiarycannon" )
		player:RemoveWeapon( "ff_weapon_flamethrower" )
		
               
                
	else
		player:AddAmmo( Ammo.kShells, 100 )

                
                
	end

        class = player:GetClass()
	if class == Player.kEngineer then
		player:RemoveWeapon( "ff_weapon_railgun" )
		player:RemoveWeapon( "ff_weapon_deploydispenser" )
		player:RemoveWeapon( "ff_weapon_deploysentrygun" )
		
               
                
	else
		player:AddAmmo( Ammo.kShells, 100 )

                
                
	end

        class = player:GetClass()
	if class == Player.kDemoman then
		player:RemoveAmmo( Ammo.kDetpack, 1 )
		player:RemoveWeapon( "ff_weapon_pipelauncher" )
		player:RemoveWeapon( "ff_weapon_grenadelauncher" )
		player:RemoveWeapon( "ff_weapon_deploydetpack" )
		
               
                
	else
		player:AddAmmo( Ammo.kShells, 100 )

                
                
	end


	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kNails, 200 )
        player:RemoveAmmo( Ammo.kRockets, 50 )
        player:RemoveAmmo( Ammo.kCells, 200 )
        player:RemoveAmmo( Ammo.kManCannon, 1 )
        player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )

end

--------------------
--Locations
--------------------

location_stage1 = location_info:new({ text = "Stage 1", team = NO_TEAM })
location_stage2 = location_info:new({ text = "Stage 2", team = NO_TEAM })
location_stage3 = location_info:new({ text = "Stage 3", team = NO_TEAM })
location_stage4 = location_info:new({ text = "Stage 4", team = NO_TEAM })
location_stage5 = location_info:new({ text = "Stage 5", team = NO_TEAM })
location_stage6 = location_info:new({ text = "Stage 6", team = NO_TEAM })
location_stage7 = location_info:new({ text = "Stage 7", team = NO_TEAM })
location_stage8 = location_info:new({ text = "Stage 8", team = NO_TEAM })
location_stage9 = location_info:new({ text = "Stage 9", team = NO_TEAM })
location_stage10 = location_info:new({ text = "Stage 10", team = NO_TEAM })
location_stage11 = location_info:new({ text = "Stage 11", team = NO_TEAM })
location_stage12 = location_info:new({ text = "Stage 12", team = NO_TEAM })
location_stage13 = location_info:new({ text = "Stage 13", team = NO_TEAM })
location_stage14 = location_info:new({ text = "Stage 14", team = NO_TEAM })
location_stage15 = location_info:new({ text = "Stage 15", team = NO_TEAM })
location_stage16 = location_info:new({ text = "Stage 16", team = NO_TEAM })
location_stage17 = location_info:new({ text = "Stage 17", team = NO_TEAM })
location_stage18 = location_info:new({ text = "Stage 18", team = NO_TEAM })
location_stage19 = location_info:new({ text = "Stage 19", team = NO_TEAM })
location_stage20 = location_info:new({ text = "Stage 20", team = NO_TEAM })
location_stage100 = location_info:new({ text = "Stage 21", team = NO_TEAM })
location_stage21 = location_info:new({ text = "Stage 22", team = NO_TEAM })
location_stage22 = location_info:new({ text = "Stage 23", team = NO_TEAM })
location_stage23 = location_info:new({ text = "Stage 24", team = NO_TEAM })
location_stage24 = location_info:new({ text = "Stage 25", team = NO_TEAM })
location_stage25 = location_info:new({ text = "Stage 26", team = NO_TEAM })
location_stage26 = location_info:new({ text = "Stage 27", team = NO_TEAM })
location_stage27 = location_info:new({ text = "Stage 28", team = NO_TEAM })
location_stage28 = location_info:new({ text = "Stage 29", team = NO_TEAM })
location_stage29 = location_info:new({ text = "Stage 30", team = NO_TEAM })
location_stage30 = location_info:new({ text = "Stage 31", team = NO_TEAM })
location_stage31 = location_info:new({ text = "Stage 32", team = NO_TEAM })
location_stage32 = location_info:new({ text = "Stage 33", team = NO_TEAM })
location_stage33 = location_info:new({ text = "Stage 34", team = NO_TEAM })
location_stage34 = location_info:new({ text = "Stage 35", team = NO_TEAM })
location_stage35 = location_info:new({ text = "Stage 36", team = NO_TEAM })
location_stage36 = location_info:new({ text = "Stage 37", team = NO_TEAM })
location_stage37 = location_info:new({ text = "Stage 38", team = NO_TEAM })
location_stage38 = location_info:new({ text = "Stage 39", team = NO_TEAM })
location_stage39 = location_info:new({ text = "Stage 40", team = NO_TEAM })
location_stage40 = location_info:new({ text = "Stage 41", team = NO_TEAM })
location_stage41 = location_info:new({ text = "Stage 42", team = NO_TEAM })
location_stage42 = location_info:new({ text = "Stage 43", team = NO_TEAM })
location_stage43 = location_info:new({ text = "Stage 44", team = NO_TEAM })
location_stage44 = location_info:new({ text = "Stage 45", team = NO_TEAM })
location_stage45 = location_info:new({ text = "Stage 46", team = NO_TEAM })
location_stage46 = location_info:new({ text = "Stage 46", team = NO_TEAM })
location_stage47 = location_info:new({ text = "Stage 47", team = NO_TEAM })
location_stage48 = location_info:new({ text = "Stage 48", team = NO_TEAM })
location_stage49 = location_info:new({ text = "Stage 49", team = NO_TEAM })
location_stage50 = location_info:new({ text = "Stage 50", team = NO_TEAM })
location_stage51 = location_info:new({ text = "Stage 51", team = NO_TEAM })
location_stage52 = location_info:new({ text = "Stage 52", team = NO_TEAM })
location_stage53 = location_info:new({ text = "Stage 53", team = NO_TEAM })
location_stage54 = location_info:new({ text = "Stage 54", team = NO_TEAM })
location_stage55 = location_info:new({ text = "Stage 55", team = NO_TEAM })
location_stage56 = location_info:new({ text = "Stage 56", team = NO_TEAM })
location_stage57 = location_info:new({ text = "Stage 57", team = NO_TEAM })
location_stage58 = location_info:new({ text = "Stage 58", team = NO_TEAM })
location_stage59 = location_info:new({ text = "Stage 59", team = NO_TEAM })
location_stage60 = location_info:new({ text = "Stage 60", team = NO_TEAM })
location_stage61 = location_info:new({ text = "Stage 61", team = NO_TEAM })
location_stage62 = location_info:new({ text = "Stage 62", team = NO_TEAM })
location_stage63 = location_info:new({ text = "Stage 63", team = NO_TEAM })
location_stage64 = location_info:new({ text = "Stage 64", team = NO_TEAM })
location_stage65 = location_info:new({ text = "Stage 65", team = NO_TEAM })
location_stage66 = location_info:new({ text = "Stage 66", team = NO_TEAM })
location_stage67 = location_info:new({ text = "Stage 67", team = NO_TEAM })
location_stage68 = location_info:new({ text = "Stage 68", team = NO_TEAM })
location_stage69 = location_info:new({ text = "Stage 69", team = NO_TEAM })
location_stage70 = location_info:new({ text = "Stage 70", team = NO_TEAM })
location_stage71 = location_info:new({ text = "Stage 71", team = NO_TEAM })
location_stage72 = location_info:new({ text = "Stage 72", team = NO_TEAM })
location_stage73 = location_info:new({ text = "Stage 73", team = NO_TEAM })
location_stage74 = location_info:new({ text = "Stage 74", team = NO_TEAM })
location_stage75 = location_info:new({ text = "Stage 75", team = NO_TEAM })
location_stage76 = location_info:new({ text = "Stage 76", team = NO_TEAM })
location_stage77 = location_info:new({ text = "Stage 77", team = NO_TEAM })
location_stage78 = location_info:new({ text = "Stage 78", team = NO_TEAM })
location_stage79 = location_info:new({ text = "Stage 79", team = NO_TEAM })
location_stage80 = location_info:new({ text = "Stage 80", team = NO_TEAM })
location_stage81 = location_info:new({ text = "Stagwe 81", team = NO_TEAM })
location_stage82 = location_info:new({ text = "Stage 82", team = NO_TEAM })
location_stage83 = location_info:new({ text = "Stage 83", team = NO_TEAM })
location_stage84 = location_info:new({ text = "Stage 84", team = NO_TEAM })
location_stage85 = location_info:new({ text = "Stage 85", team = NO_TEAM })
location_stage86 = location_info:new({ text = "Final Stage", team = NO_TEAM })
--------------------
--Finish Zones
--------------------


finish = trigger_ff_script:new({})

function finish:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 100, "Map Completed")
            
            BroadCastMessage( player:GetName() .. " has Completed the Map!" )
         end
end

finish2 = trigger_ff_script:new({})

function finish2:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 100, "Completed the Map")

            BroadCastMessage( player:GetName() .. " has Completed the Map!" )
         end
end

------------------------------------------------------
--FLAGS -- taken from Concmap.lua by Public_Slots_Free
------------------------------------------------------

local flags = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}


-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
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


function baseflag:dropitemcmd( owner_entity )

end

------------------
--No Damage-------
------------------

--function player_ondamage( player, damageinfo )
--	class = player:GetClass()
--	if class == Player.kScout then
--          damageinfo:SetDamage( 0 )
--
--        else
--          
--            damageinfo:SetDamage( 0 )
--
--        end
--end

------------------
--No Fall Damage--
------------------

function player_ondamage( player, damageinfo )
  local attacker = damageinfo:GetAttacker()
  if damageinfo:GetDamageType() == 32 then
     damageinfo:SetDamage( 0 )
 
  end
end

------------------

function restock_all()
	local c = Collection()
	-- get all players
	c:GetByFilter({CF.kPlayers})
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			-- add ammo/health/armor/etc
			class = player:GetClass()
			if player:GetTeamId() == Team.kGreen then
				if player:GetClass() == Player.kScout then
					player:AddAmmo(Ammo.kGren2, 3)
					player:AddAmmo( Ammo.kShells, 50 )
					player:AddAmmo( Ammo.kNails, 50 )
	
				end
			end
		end
	end
end

