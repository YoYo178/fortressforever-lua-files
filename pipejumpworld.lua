-------------------------
--pipe world pipe jump by jobabob ported by Headzy
-------------------------

IncludeScript("base_ctf4");
IncludeScript("base_location");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

----------------------------
-- Toggle Concussion Effect
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

	SetTeamName( Team.kBlue, "Disabled" )
        SetTeamName( Team.kRed, "Core Workers" )
        SetTeamName( Team.kYellow, "Disabled" )
        SetTeamName( Team.kGreen, "Disabled" )
	
	SetPlayerLimit( Team.kBlue, -1 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

        local team = GetTeam( Team.kYellow )
        team:SetAllies( Team.kGreen )
        team:SetAllies( Team.kBlue )
        team:SetAllies( Team.kRed )
	

        team:SetClassLimit( Player.kScout, -1 )
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
	

        team:SetClassLimit( Player.kScout, -1 )
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
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

        local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kGreen )
        team:SetAllies( Team.kBlue )
        team:SetAllies( Team.kYellow )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end




----------
-- spawn
----------

function player_spawn( player_entity ) 
	local player = CastToPlayer( player_entity ) 

   -- end of default player_spawn
   player:RemoveAmmo( Ammo.kManCannon, 1 )
end





------------
--No Damage
------------

function player_ondamage( player, damageinfo )
	class = player:GetClass()
	if class == Player.kDemoman then
          damageinfo:SetDamage( 0 )

        else
          
            damageinfo:SetDamage( 0 )

        end
end

-----------------
--No Fall Damage
-----------------

function player_ondamage( player, damageinfo )
  local attacker = damageinfo:GetAttacker()
  if damageinfo:GetDamageType() == 32 then
     damageinfo:SetDamage( 0 )
 
  end
end

----------------
--Finish Zones
----------------


finish = trigger_ff_script:new({})

function finish:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 10000, "PipeJumpWorld Completed, Original map by JOBABOB - ported by Headzy")
            
            BroadCastMessage( player:GetName() .. " has Completed PipeJumpWorld - by JOBABOB - ported by Headzy" )
         end
end

------------------

-- Gives player ammo and health etc
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
			if player:GetTeamId() == Team.kRed then
				if player:GetClass() == Player.kDemoman then
	                                player:AddHealth( 100 )
	                                player:AddArmor( 300 )
					player:AddAmmo( Ammo.kGren2, -4)
					player:AddAmmo( Ammo.kShells, 50 )
					player:AddAmmo( Ammo.kNails, 50 )
					player:AddAmmo( Ammo.kRockets, 50 )
	                                player:AddAmmo( Ammo.kCells, 400 )
				end
			end
		end
	end
end
