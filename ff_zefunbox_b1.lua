--ff_zefunbox_b1 by zE
---------------------------------

IncludeScript("base_location")

----------------------------
-- Toggle Concussion Effect.
----------------------------
CONC_EFFECT = 0


function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end
-------------------
--Minimum Damage to Pyro
-------------------
 function player_ondamage (player, damageinfo )
     local class = player:GetClass()
     if class == Player.kPyro then
        damageinfo:SetDamage( 5 )
     end
end

---------------------------------
function startup()

	SetTeamName( Team.kBlue, "Blue :D" )
        SetTeamName( Team.kRed, "Red :O" )
        SetTeamName( Team.kYellow, "Yellow :]" )
        SetTeamName( Team.kGreen, "Yellow :o" )
	
	SetPlayerLimit( Team.kBlue, 5 )
	SetPlayerLimit( Team.kRed, 5 )
	SetPlayerLimit( Team.kYellow, 5 )
	SetPlayerLimit( Team.kGreen, 5 )

        local team = GetTeam( Team.kYellow )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )    
   

	local team = GetTeam( Team.kGreen )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

        local team = GetTeam( Team.kBlue )
       

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

        local team = GetTeam( Team.kRed )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
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
	if class == Player.kPyro then
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, -4 )
               
                
	else
		player:AddAmmo( Ammo.kGren1, -4 )
		player:AddAmmo( Ammo.kGren2, 4 )
                
                
	end

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kRockets, 30 )
	player:AddAmmo( Ammo.kNails, 200 )
        player:AddAmmo( Ammo.kCells, 200 )
        player:RemoveAmmo( Ammo.kManCannon, 1 )
        

end

-----------------------------------------------------------------------------

--------------------
--Locations
--------------------

location_stage1 = location_info:new({ text = "1.WTF is this", team = NO_TEAM })
location_stage2 = location_info:new({ text = "2.hmm I�m lost", team = NO_TEAM })
location_stage3 = location_info:new({ text = "3.reminds me egipt", team = NO_TEAM })
location_stage4 = location_info:new({ text = "4.wich one?", team = NO_TEAM })
location_stage5 = location_info:new({ text = "5.time to take a bath", team = NO_TEAM })
location_stage6 = location_info:new({ text = "6.how to i get out?", team = NO_TEAM })
location_stage7 = location_info:new({ text = "7. ah! an easy one", team = NO_TEAM })
location_stage8 = location_info:new({ text = "8.dont push me!", team = NO_TEAM })
location_stage9 = location_info:new({ text = "9.was suposed to get harder", team = NO_TEAM })
location_stage10 = location_info:new({ text = "10.hmmm", team = NO_TEAM })
location_stage11 = location_info:new({ text = "11.dont like this", team = NO_TEAM })
location_stage12 = location_info:new({ text = "12.the end?", team = NO_TEAM })
location_stage13 = location_info:new({ text = "13.lol.. .", team = NO_TEAM })
location_stage14 = location_info:new({ text = "14.la grand final!", team = NO_TEAM })

--------------------
--JuggleZone
--------------------

function fullresupply( player )
        local player = CastToPlayer( player )
        player:AddHealth( 200 )
        player:AddArmor( 200 )

        class = player:GetClass()
        if class == Player.kPyro then
                player:AddAmmo( Ammo.kCells, 200 )
                player:AddAmmo( Ammo.kRockets, 30 )
                player:AddAmmo( Ammo.kGren1, 4 )
        else

                player:AddAmmo( Ammo.kNails, 200 )
                player:AddAmmo( Ammo.kShells, 100 )
                player:AddAmmo( Ammo.kGren2, 4 )
        end
end

jugglezone = trigger_ff_script:new({ })

function jugglezone:allowed( allowed_entity )
        if IsPlayer( allowed_entity ) then
                local player = CastToPlayer( allowed_entity )
                fullresupply( player )
        end
        return true
end
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

            BroadCastMessage( player:GetName() .. " has Owned the Map!" )
         end
end
--------------------

         