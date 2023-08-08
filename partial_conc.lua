--partial_conc by [HBA]PartialSchism
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

	SetTeamName( Team.kBlue, "Blue Jumpers" )
        SetTeamName( Team.kRed, "Red Jumpers" )
	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	
        team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

        local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	
        team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
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

location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })
location_jump8 = location_info:new({ text = "Jump 8", team = NO_TEAM })
location_end = location_info:new({ text = "The End", team = NO_TEAM })
location_end2 = location_info:new({ text = "Advanced End", team = NO_TEAM })

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
            player:AddFortPoints( 8000, "Advanced Jump Complete")
            player:AddFrags( 400 )

            BroadCastMessage( player:GetName() .. " has Completed the Advanced Jump!" )
         end
end
--------------------

         