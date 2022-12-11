-- dm_mitair.lua

IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kRed, "Red Team" )
	SetTeamName( Team.kBlue, "Blue Team" )
end

-- Everyone to spawns with everything
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	--local player = GetPlayer(player_id)
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	-- player:AddAmmo( Ammo.kGren1, 4 )
	-- player:AddAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
end





