
-- ff_dm.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
-- IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )
end

function precache()
	PrecacheSound( "Backpack.Touch" )
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
	player:AddAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 1 )
end

-- Get team points for killing a player
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

-- Just here because
function player_ondamage( player_entity, damageinfo )
end

-- Infinite bag
infini_bag = trigger_ff_script:new({ touchsound = "Backpack.Touch" })

-- Infinite bag :: ontouch
function infini_bag:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- 400 for overkill. of course the values
		-- get clamped in game code
		player:AddHealth( 400 )
		player:AddArmor( 400 )

		player:AddAmmo( Ammo.kNails, 400 )
		player:AddAmmo( Ammo.kShells, 400 )
		player:AddAmmo( Ammo.kRockets, 400 )
		player:AddAmmo( Ammo.kCells, 400 )
		player:AddAmmo( Ammo.kDetpack, 1 )
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, 0 )

		-- Play the touch sound
		player:EmitSound( self.touchsound )
	end
end

function infini_bag:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return true
		end
	end

	return false
end

-- Red infinite bag
red_infini_bag = infini_bag:new({ team = Team.kRed })

-- Blue infinite bag
blue_infini_bag = infini_bag:new({ team = Team.kBlue })
