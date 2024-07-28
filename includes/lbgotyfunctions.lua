--functions for various playmodes NONE OF THIS IS LICENSED (otherwise noted) WHAT SO EVER! ALL CODE HERE IS USED FAIR USE

-- Detpack Mania by Average
dpm_spawn = function ( player_entity ) 
	local player = CastToPlayer( player_entity ) 

	player:AddHealth( 400 ) 
	--player:AddArmor( 400 ) 
	player:RemoveArmor( 400 )
	--removes armor to make pelletgun fighting bearable, if you want armor, comment this and uncomment the positive AddArmor function
	
	
	player:RemoveAllWeapons()
	player:GiveWeapon("ff_weapon_crowbar", true) -- LB:GOTY edit
	player:GiveWeapon("ff_weapon_deploydetpack", true)
	player:GiveWeapon("ff_weapon_shotgun", true)
	-- strips player off all weapons and gives detpack and pellet gun
	
	--player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	-- removes all grenades upon spawning 
	--player spawns with primary nades at the moment, uncomment both player functions if you dont want to have nades 
	
end

dpm_ondamage = function ( input_player, damageinfo )
  local player = CastToPlayer( input_player )
  local weapon = damageinfo:GetInflictor():GetClassName()

  if weapon == "ff_grenade_normal" then damageinfo:SetDamage( 40 ) end
  if weapon == "ff_weapon_shotgun" then damageinfo:ScaleDamage( 0.5 ) end
end

------------------------------------------------------
-- Clan Arena (copied from ff_thunderstruck.lua)
------------------------------------------------------

ca_killed = function ( killed_entity )
	local player = CastToPlayer( killed_entity )
	player:Spectate ( SpecMode.kRoaming )
	player:SetRespawnable( false )
	ca_CheckTeamAliveState( killed_entity)
end

ca_ondamage = function ( player, damageinfo )
	-- Entity that is attacking
  	local attacker = damageinfo:GetAttacker()
	
	-- shock is the damage type used for the trigger_hurts in this map. Must be allowed to kill players :)
	if damageinfo:GetDamageType() == Damage.kShock then
		return EVENT_ALLOWED
	end

  	-- If no attacker do nothing
  	if not attacker then 
		damageinfo:SetDamage(0)
		return
  	end

  	-- If attacker not a player do nothing
  	if not IsPlayer(attacker) then 
	 	damageinfo:SetDamage(0)
		return
  	end
  
  	local playerAttacker = CastToPlayer(attacker)

 	-- If player is damaging self do nothing
  	if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
		damageinfo:SetDamage(0)
		return 
  	end
end

ca_RespawnEveryone = function()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

ca_respawnall = function() ca_RespawnEveryone() end

ca_CheckTeamAliveState = function (killed_player)
	ConsoleToAll( "CheckTeamAliveState" )
	teamz = {}

	for i = Team.kBlue, Team.kGreen do
		col = Collection()
		col:GetByFilter({CF.kPlayers, i+14})
		
		teamz[i] = {alive = 0, index = i}

		for player in col.items do
			local player = CastToPlayer(player)
			if player:IsAlive() then 
				teamz[i].alive = teamz[i].alive + 1 
			end
		end
	end
	
	-- checks to see if rest of the teams are all dead. If so, declare the suriving team the winner, and start new round. If not, set the killed player to spectate
	
	local aliveTeams = {}

	for _, team in pairs(teamz) do
	    if team.alive > 0 then
	        table.insert(aliveTeams, team)
	    end
	end

	if #aliveTeams == 1 then
	    local winner = aliveTeams[1]

	    local winningTeam = GetTeam(winner.index)
	    BroadCastMessage(winningTeam:GetName() .. " win!")
	    BroadCastSound("misc.bloop")
	    winningTeam:AddScore(10)

	    AddSchedule("respawnall", 3, ca_respawnall)
		elseif #aliveTeams == 0 then -- If either team has no players, then exit. Just one person running about shouldn't get boxed up.
			AddSchedule("respawnall", 1 , ca_respawnall)
		else
	    return
	end
end
