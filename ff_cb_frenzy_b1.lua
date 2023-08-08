IncludeScript("base_teamplay");

function startup()

AddScheduleRepeating( "check_teams", 1, check_teams )

	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kMedic, -1)

local team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)
	team:SetClassLimit(Player.kMedic, -1)


	SetTeamName( Team.kBlue, "Feral Dachshunds" )
	SetTeamName( Team.kRed, "Warrior King" )

end


-- Everyone to spawns with nothing
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	--local player = GetPlayer(player_id)
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:RemoveAmmo( Ammo.kNails, 500 )
	player:RemoveAmmo( Ammo.kShells, 500 )
	player:RemoveAmmo( Ammo.kCells, 500 )
	player:RemoveAmmo( Ammo.kManCannon, 1)
	player:RemoveAmmo( Ammo.kGren1, 500 )
	player:RemoveAmmo( Ammo.kGren2, 500 )
	player:RemoveWeapon("ff_weapon_shotgun")
	player:RemoveWeapon("ff_weapon_nailgun")
		
end

function player_onkill( player )
	-- Test, Don't let blue team suicide.
 	if player:GetTeamId() == Team.Red then
 		return false
 	end
	return true
end
function player_killed( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end
	
	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

	-- If player killed self or teammate do nothing
	if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
		return 
	end
  
	-- If attacker is blue, switch teams accordingly
	if player_attacker:GetTeamId() == Team.kBlue then
		-- switch attacker to red
		ApplyToPlayer( player_attacker, { AT.kChangeTeamRed, AT.kRespawnPlayers } )
		-- switch victim to blue
		ApplyToPlayer( player, { AT.kChangeTeamBlue, AT.kRespawnPlayers } )
	end
  
end

function random_blue_to_red()
	local c = Collection()
	-- get all blue players
	c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	-- generate random number
	local i = math.random( 0, c:Count() - 1 )
	local randomplayer = CastToPlayer( c:Element( i ) )
	
	ApplyToPlayer( randomplayer, { AT.kChangeTeamRed, AT.kRespawnPlayers } )
end

function check_teams()
	if GetTeam( Team.kBlue ):GetNumPlayers() >= 2 and GetTeam( Team.kRed ):GetNumPlayers() < 1 then
			random_blue_to_red()

	end
end

falltrigger = trigger_ff_script:new({ team = Team.kRed })

function falltrigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- if is on right team
		if player:GetTeamId() == self.team then
			-- switch victim to blue
			ApplyToPlayer( player, { AT.kChangeTeamBlue, AT.kKillPlayers } )
			-- switch random blue player to red
			random_blue_to_red()
		end
	end
end

-- Just here because
function player_ondamage( player_entity, damageinfo )
end