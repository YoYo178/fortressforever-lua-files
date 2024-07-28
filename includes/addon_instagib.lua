-----------------------------------------------------------------------------
-- addon_instagib.lua
-- addon file to base_arena.lua that turns it into tranquilizer instagib
-- add this alongside base_arena as an IncludeScript
-----------------------------------------------------------------------------
--== File last modified:
-- 16 / 01 / 2024 ( dd / mm / yyyy ) by gumbuk
--== Contributors:
-- gumbuk 9
--== Mode is hosted & developed at:
-- https://github.com/Fortress-Forever-Mapper-Union/ffmu-modes
-----------------------------------------------------------------------------

BLASTJUMP_MODIFIER = Vector( 1.4, 1.4, 2 )
-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------

function startup()
	-- team limits are R&B by default, but other arrangements are supported
	-- 4 way deathmatch is supported but often doesn't play well
	-- nothing is stopping you though

	SetPlayerLimit( Team.kBlue, TEAM_LIMITS.bl )
	SetPlayerLimit( Team.kRed, TEAM_LIMITS.rd )
	SetPlayerLimit( Team.kYellow, TEAM_LIMITS.yl )
	SetPlayerLimit( Team.kGreen, TEAM_LIMITS.gr )

	SetTeamName( Team.kRed, RED_TEAM_NAME )
	SetTeamName( Team.kBlue, BLUE_TEAM_NAME )
	SetTeamName( Team.kYellow, YELLOW_TEAM_NAME )
	SetTeamName( Team.kGreen, GREEN_TEAM_NAME )

	for i = Team.kBlue, Team.kGreen do
	local team = GetTeam(i)
		team:SetClassLimit( Player.kScout, -1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, 0 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, -1 )
		team:SetClassLimit( Player.kHwguy, -1 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, -1 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit( Player.kCivilian, -1 )
	end
	
	SetGameDescription("Instagib")
end

function player_ondamage( player, damageinfo )
	local attacker = damageinfo:GetAttacker()

	if not IsPlayer(attacker) then
		local scale = 0
		for key, value in ipairs(DAMAGE_TABLE) do
			if (damageinfo:GetDamageType() ~= value) then scale = scale
			elseif damageinfo:GetDamageType() == value and ( damageinfo:GetInflictor():GetClassName() ~= "worldspawn" ) then scale = 1
			-- worldspawn check needs to be done for the sake of regular falldamage not going through
			-- and if the mapper wants a Damake.kFall type trigger_hurt on the map
			end
		end
		damageinfo:ScaleDamage(scale)
		damageinfo:SetDamageForce( Vector( 0, 0, 0 ) )
		return
	end

	local playerAttacker = CastToPlayer(attacker)

	-- If player is damaging self scale damage and modify knockback
	if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
		damageinfo:ScaleDamage( BLASTJUMP_DAMAGE )
		damageinfo:SetDamageForce( damageinfo:GetDamageForce() * BLASTJUMP_MODIFIER )
		return
	elseif (player:GetId() ~= playerAttacker:GetId()) then
		if damageinfo:GetInflictor():GetClassName() == "ff_projectile_dart" then
			damageinfo:SetDamage(140)
		elseif damageinfo:GetInflictor():GetClassName() == "ff_weapon_crowbar" then
			damageinfo:SetDamage(1)
		else
			damageinfo:ScaleDamage(0)
		end
	end
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:RemoveArmor( 400 )

	player:RemoveAllWeapons()
	player:GiveWeapon( "ff_weapon_crowbar", false )
	player:GiveWeapon( "ff_weapon_ic", false )
	player:GiveWeapon( "ff_weapon_tranq", true )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )

	player:SetFriction( FRICTION_MODIFIER )
	player:SetGravity( GRAVITY_MODIFIER )
	player:AddEffect( EF.kSpeedlua1, -1, 0, SPEED_MODIFIER )
end