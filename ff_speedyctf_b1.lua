IncludeScript("base_ctf");

POINTS_PER_CAPTURE = 5;
FLAG_RETURN_TIME = 5

function startup()

	-- CTF maps are generally crap with snipers,
	-- especially with maps so small as this
	
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kSniper, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kSniper, -1)

	-- Because its so small scouts have a 
	-- field day, so are not included either

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kScout, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kScout, -1)

	-- CTF maps generally don't have civilians

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	
	
	-- set up team limits on each team

	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

end

-----------------------------------------------------------------------------
-- Players Spawn with Full Health/Armor/Ammo
-----------------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	--player:AddAmmo( Ammo.kDetpack, 1 )

	--player:RemoveAmmo( Ammo.kGren2, 4 )
end
