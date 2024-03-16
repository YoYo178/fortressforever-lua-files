
--ka_dirtcup - pub mode-- 

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
--Initial Stuff
-----------------------------------------------------------------------------


function startup()
	-- set up team limits	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )


	SetTeamName( Team.kBlue, "Blue Team" )
        SetTeamName( Team.kRed, "Red Team" )
        SetTeamName( Team.kYellow, "Spectators" )
        SetTeamName( Team.kGreen, "Spectators" )



	-- both teams limited to Spy
	for i = Team.kBlue, Team.kRed do
		local team = GetTeam( i )

		team:SetClassLimit( Player.kScout, -1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, -1 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, -1 )
		team:SetClassLimit( Player.kHwguy, -1 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, 0 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit( Player.kCivilian, -1 )
	end


	-- both teams limited to Civilian
	for u = Team.kYellow, Team.kGreen do
		local team = GetTeam( u )

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

	-- Spawns open and stay
	open_door()
end



-----------------------------------------------------------------------------
--Player Stuff
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	

        class = player:GetClass()
	if class == Player.kSpy then

		player:AddHealth( -55 )
                player:AddArmor( -300 )	
	
		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
		player:RemoveWeapon( "ff_weapon_tranq" )
		player:RemoveWeapon( "ff_weapon_supershotgun" )
		player:RemoveWeapon( "ff_weapon_nailgun" )

		player:SetDisguisable( false )
		player:SetCloakable( false )


		
        else

		player:AddHealth( 400 )
		player:AddArmor( 400 )

                
                
	end



        

end



--Disallow suicide
function player_onkill( player )
	
	return false
  	
end



-----------------------------------------------------------
--Spawn Blocker
-----------------------------------------------------------

function open_door()

	OutputEvent( "blocker", "Disable" )

end

-----------------------------------------------------------
--Spawn Protection
-----------------------------------------------------------

KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red hurts blueteam and vice-versa

red_spawn_protect = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_spawn_protect = KILL_KILL_KILL:new({ team = Team.kRed })