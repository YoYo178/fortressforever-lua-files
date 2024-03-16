--trimp_trainingz by zE
---------------------------------

IncludeScript("base_ctf4");
IncludeScript("base_location");


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

	SetTeamName( Team.kBlue, "Medium :0" )
        SetTeamName( Team.kRed, "Hard :x" )
        SetTeamName( Team.kYellow, "Easy :)" )
        SetTeamName( Team.kGreen, "Easy :]" )
	
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

-----------------------------------

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

-----------------------------------------------------------------------------

--------------------
--Locations
--------------------

location_stage1 = location_info:new({ text = "Trimp 1", team = NO_TEAM })
location_stage2 = location_info:new({ text = "Trimp 2", team = NO_TEAM })
location_stage3 = location_info:new({ text = "Trimp 3", team = NO_TEAM })
location_stage4 = location_info:new({ text = "Trimp 4", team = NO_TEAM })
location_stage5 = location_info:new({ text = "Trimp 5", team = NO_TEAM })
location_stage6 = location_info:new({ text = "Trimp 6", team = NO_TEAM })
location_stage7 = location_info:new({ text = "Trimp 7", team = NO_TEAM })
location_stage8 = location_info:new({ text = "Trimp 8", team = NO_TEAM })
location_stage9 = location_info:new({ text = "Trimp 9", team = NO_TEAM })
location_stage10 = location_info:new({ text = "Trimp 10", team = NO_TEAM })
location_stage11 = location_info:new({ text = "Trimp 11", team = NO_TEAM })
location_stage12 = location_info:new({ text = "Trimp 12", team = NO_TEAM })
location_stage13 = location_info:new({ text = "Trimp 13", team = NO_TEAM })
location_stage14 = location_info:new({ text = "Trimp 14", team = NO_TEAM })
location_stage15 = location_info:new({ text = "Trimp 15", team = NO_TEAM })
location_stage16 = location_info:new({ text = "Trimp 16", team = NO_TEAM })
location_stage17 = location_info:new({ text = "Trimp 17", team = NO_TEAM })
location_stage18 = location_info:new({ text = "Trimp 18", team = NO_TEAM })
location_stage19 = location_info:new({ text = "Trimp 19", team = NO_TEAM })
location_stage20 = location_info:new({ text = "Trimp 20", team = NO_TEAM })
location_stage21 = location_info:new({ text = "Trimp 21", team = NO_TEAM })
location_stage22 = location_info:new({ text = "Trimp 22", team = NO_TEAM })
location_stage23 = location_info:new({ text = "Trimp 23", team = NO_TEAM })
location_stage24 = location_info:new({ text = "Trimp 24", team = NO_TEAM })
location_stage25 = location_info:new({ text = "Trimp 25", team = NO_TEAM })
location_stage26 = location_info:new({ text = "Trimp 26", team = NO_TEAM })
location_stage27 = location_info:new({ text = "Trimp 27", team = NO_TEAM })
location_stage28 = location_info:new({ text = "Trimp 28", team = NO_TEAM })
location_stage29 = location_info:new({ text = "Trimp 29", team = NO_TEAM })
location_stage30 = location_info:new({ text = "Trimp 30", team = NO_TEAM })
location_stage31 = location_info:new({ text = "Trimp 31", team = NO_TEAM })
location_stage32 = location_info:new({ text = "Trimp 32", team = NO_TEAM })
location_stage33 = location_info:new({ text = "Trimp 33", team = NO_TEAM })
location_stage34 = location_info:new({ text = "Trimp 34", team = NO_TEAM })
location_stage35 = location_info:new({ text = "Trimp 35", team = NO_TEAM })
location_stage36 = location_info:new({ text = "Trimp 36", team = NO_TEAM })
location_stage37 = location_info:new({ text = "Trimp 37", team = NO_TEAM })
location_stage38 = location_info:new({ text = "Trimp 38", team = NO_TEAM })
location_stage39 = location_info:new({ text = "Trimp 39", team = NO_TEAM })
location_stage40 = location_info:new({ text = "Trimp 40", team = NO_TEAM })
location_stage41 = location_info:new({ text = "Trimp 41", team = NO_TEAM })
location_stage42 = location_info:new({ text = "Trimp 42", team = NO_TEAM })
location_stage43 = location_info:new({ text = "Trimp 43", team = NO_TEAM })
location_stage44 = location_info:new({ text = "Trimp 44", team = NO_TEAM })
location_stage45 = location_info:new({ text = "Trimp 45", team = NO_TEAM })
location_stage46 = location_info:new({ text = "Trimp 46", team = NO_TEAM })
location_stage47 = location_info:new({ text = "Trimp 47", team = NO_TEAM })
location_stage48 = location_info:new({ text = "Trimp 48", team = NO_TEAM })
location_stage49 = location_info:new({ text = "Trimp 49", team = NO_TEAM })
location_stage50 = location_info:new({ text = "Trimp 50", team = NO_TEAM })
location_stage51 = location_info:new({ text = "Trimp 51", team = NO_TEAM })
location_stage52 = location_info:new({ text = "Trimp 52", team = NO_TEAM })
location_stage53 = location_info:new({ text = "Trimp 53", team = NO_TEAM })
location_stage54 = location_info:new({ text = "Trimp 54", team = NO_TEAM })
location_stage55 = location_info:new({ text = "Trimp 55", team = NO_TEAM })
location_stage56 = location_info:new({ text = "Trimp 56", team = NO_TEAM })
location_stage57 = location_info:new({ text = "Trimp 57", team = NO_TEAM })
location_stage58 = location_info:new({ text = "Trimp 58", team = NO_TEAM })
location_stage59 = location_info:new({ text = "Trimp 59", team = NO_TEAM })
location_stage60 = location_info:new({ text = "Trimp 60", team = NO_TEAM })
location_stage61 = location_info:new({ text = "Trimp 61", team = NO_TEAM })
location_stage62 = location_info:new({ text = "Trimp 62", team = NO_TEAM })
location_stage63 = location_info:new({ text = "Trimp 63", team = NO_TEAM })
location_stage64 = location_info:new({ text = "Trimp 64", team = NO_TEAM })
location_stage65 = location_info:new({ text = "Trimp 65", team = NO_TEAM })
location_stage66 = location_info:new({ text = "Trimp 66", team = NO_TEAM })
location_stage67 = location_info:new({ text = "Trimp 67", team = NO_TEAM })
location_stage68 = location_info:new({ text = "Trimp 68", team = NO_TEAM })
location_stage69 = location_info:new({ text = "Trimp 69", team = NO_TEAM })
location_stage70 = location_info:new({ text = "Trimp 70", team = NO_TEAM })
location_stage72 = location_info:new({ text = "Trimp 71", team = NO_TEAM })
location_stage73 = location_info:new({ text = "Trimp 72", team = NO_TEAM })
location_stage74 = location_info:new({ text = "Trimp 73", team = NO_TEAM })
location_stage75 = location_info:new({ text = "Trimp 74", team = NO_TEAM })
location_stage76 = location_info:new({ text = "Trimp 75", team = NO_TEAM })
location_stage77 = location_info:new({ text = "Trimp 76", team = NO_TEAM })
location_stage78 = location_info:new({ text = "Trimp 77", team = NO_TEAM })
location_stage79 = location_info:new({ text = "Trimp 78", team = NO_TEAM })
location_stage80 = location_info:new({ text = "Trimp 79", team = NO_TEAM })
location_stage81 = location_info:new({ text = "Trimp 80", team = NO_TEAM })
location_stage82 = location_info:new({ text = "Trimp 81", team = NO_TEAM })
location_stage83 = location_info:new({ text = "Trimp 82", team = NO_TEAM })
location_stage84 = location_info:new({ text = "Trimp 83", team = NO_TEAM })
location_stage85 = location_info:new({ text = "Trimp 84", team = NO_TEAM })
location_stage86 = location_info:new({ text = "Trimp 85", team = NO_TEAM })
location_stage87 = location_info:new({ text = "Trimp 86", team = NO_TEAM })
location_stage88 = location_info:new({ text = "Trimp 87", team = NO_TEAM })
location_stage89 = location_info:new({ text = "Trimp 88", team = NO_TEAM })
location_stage90 = location_info:new({ text = "Trimp 89", team = NO_TEAM })
location_stage91 = location_info:new({ text = "Trimp 90", team = NO_TEAM })
location_stage92 = location_info:new({ text = "Trimp 91", team = NO_TEAM })
location_stage93 = location_info:new({ text = "Trimp 92", team = NO_TEAM })
location_stage94 = location_info:new({ text = "Trimp 93", team = NO_TEAM })
location_stage95 = location_info:new({ text = "Trimp 94", team = NO_TEAM })
location_stage96 = location_info:new({ text = "Trimp 95", team = NO_TEAM })
location_stage97 = location_info:new({ text = "Trimp 96", team = NO_TEAM })
location_stage98 = location_info:new({ text = "Trimp 97", team = NO_TEAM })
location_stage99 = location_info:new({ text = "Trimp 98", team = NO_TEAM })
location_stage100 = location_info:new({ text = "Trimp 99", team = NO_TEAM })
location_stage101 = location_info:new({ text = "Trimp 100", team = NO_TEAM })
location_stage102 = location_info:new({ text = "Trimp 101", team = NO_TEAM })
location_stage103 = location_info:new({ text = "Trimp 102", team = NO_TEAM })
location_stage104 = location_info:new({ text = "Trimp 103", team = NO_TEAM })
location_stage105 = location_info:new({ text = "Trimp 104", team = NO_TEAM })
location_stage106 = location_info:new({ text = "Trimp 105", team = NO_TEAM })
location_stage107 = location_info:new({ text = "Trimp 106", team = NO_TEAM })
location_stage108 = location_info:new({ text = "Trimp 107", team = NO_TEAM })
location_stage109 = location_info:new({ text = "Trimp 108", team = NO_TEAM })
location_stage110 = location_info:new({ text = "Trimp 109", team = NO_TEAM })
location_stage111 = location_info:new({ text = "Trimp 110", team = NO_TEAM })
location_stage112 = location_info:new({ text = "Trimp 111", team = NO_TEAM })
location_stage113 = location_info:new({ text = "Trimp 112", team = NO_TEAM })
location_stage114 = location_info:new({ text = "Trimp 113", team = NO_TEAM })
location_stage115 = location_info:new({ text = "Trimp 114", team = NO_TEAM })
location_stage116 = location_info:new({ text = "Trimp 115", team = NO_TEAM })
location_stage117 = location_info:new({ text = "Trimp 116", team = NO_TEAM })
location_stage118 = location_info:new({ text = "Trimp 117", team = NO_TEAM })
location_stage119 = location_info:new({ text = "Trimp 118", team = NO_TEAM })
location_stage120 = location_info:new({ text = "Trimp 119", team = NO_TEAM })
location_stage121 = location_info:new({ text = "Trimp 120", team = NO_TEAM })
location_stage122 = location_info:new({ text = "Trimp 121", team = NO_TEAM })
location_stage123 = location_info:new({ text = "Trimp 122", team = NO_TEAM })
location_stage124 = location_info:new({ text = "Trimp 123", team = NO_TEAM })
location_stage125 = location_info:new({ text = "Trimp 124", team = NO_TEAM })
location_stage126 = location_info:new({ text = "Trimp 125", team = NO_TEAM })
location_stage127 = location_info:new({ text = "Trimp 126", team = NO_TEAM })
location_stage128 = location_info:new({ text = "Trimp Final", team = NO_TEAM })
































--------------------
--Finish Zones
--------------------


finish = trigger_ff_script:new({})

function finish:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 2000, "Map Completed")
            player:AddFrags( 100 )
            
            BroadCastMessage( player:GetName() .. " has Completed the Map!" )
         end
end

finish2 = trigger_ff_script:new({})

function finish2:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:RemoveAmmo( Ammo.kGren1, 4 )
            player:RemoveAmmo( Ammo.kGren2, 4 )
            player:RemoveAmmo( Ammo.kCells, 200 )
            player:RemoveAmmo( Ammo.kRockets, 50 )
            player:AddFortPoints( 1000, "Owned the Map")
            player:AddFrags( 50 )

            BroadCastMessage( player:GetName() .. " has Completed the Map!" )
         end
end

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
-- DO NOTHING!
--	-- throw the flag
--	local flag = CastToInfoScript(entity)
--	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
--
--	if IsPlayer( owner_entity ) then
--		local player = CastToPlayer( owner_entity )
--		player:RemoveEffect( EF.kSpeedlua1 )
--
--		-- Remove any hud icons with identifier "base_ad_flag"
--		RemoveHudItem( player, "base_ad_flag" )
--	end
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