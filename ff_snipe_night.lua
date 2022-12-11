

------------------
--Includes--------
------------------

IncludeScript("base_teamplay");

------------------
--Startup---------
------------------

function startup()

	SetTeamName( Team.kBlue, "BLUE TEAM" )
        SetTeamName( Team.kRed, "RED TEAM" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 

        local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

---------------------
--Ammo Check---------
---------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	
	player:AddAmmo( Ammo.kShells, 400 )
	player:RemoveAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
        player:RemoveWeapon( "ff_weapon_nailgun" )
	player:RemoveWeapon( "ff_weapon_autorifle" )
        
end


-------------------------
--Team points for kills--
-------------------------

function player_killed( player_entity, damageinfo )
	local killer = GetAttacker.GetAttacker()
	
	local player = CastToPlayer( player_entity )
	if IsPlayer(killer) then
		killer = CastToPlayer(killer)
		--local victim = GetPlayer(player_id)
		
		if not (player:GetTeamId() == killer:GetTeamId()) then
			local killersTeam = killer:GetTeam()	
			killersTeam:AddScore(1)
		end
	end
end

