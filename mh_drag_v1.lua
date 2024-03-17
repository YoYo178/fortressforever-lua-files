-- ff_umcmulch  (originally ff_rookie_dm lua)
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");


-- checks that enemies are damaging, not self or fall damage
function player_ondamage( player, damageinfo )
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


-----------------------------------------------------------------------------
-- Teams
-----------------------------------------------------------------------------
function startup()
	-- Names
	SetTeamName( Team.kRed, "Driver" )
	SetTeamName( Team.kBlue, "Operator" )
	SetTeamName( Team.kYellow, "Spectator" )
	SetTeamName( Team.kGreen, "Spec/Track Team" )
 
	-- Team limits
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )
 
	local team = GetTeam( Team.kBlue )
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
 
	local team = GetTeam( Team.kRed )
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
 
	
 	local team = GetTeam( Team.kYellow )
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

 	local team = GetTeam( Team.kGreen )
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

 -----------------------------------------------------------------------------
-- Full supply on spawn
-----------------------------------------------------------------------------

 function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kGren1, 0 )
	player:AddAmmo ( Ammo.kGren2, -4 )
	player:AddHealth( 200 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
 end

--NODAMAGE
if (player:GetId() == playerAttacker:GetId()) or (player:GetTeamId() == playerAttacker:GetTeamId()) then
	damageinfo:SetDamage(0)
	return 
  end

--unlimited rockets



-----------------------------------------------------------------------------
--Team points for killing
-----------------------------------------------------------------------------
function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		
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
end

-- Just here because
function player_ondamage( player_entity, damageinfo )
end

---------------------------------
-- Racer Respawn
---------------------------------

startred = trigger_ff_script:new({ team = Team.kRed })

function startred:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Head to the Garage and get a ride!!!" )
		end
	end
end

startred = startred:new({ team = Team.kRed })

---------------------------------
-- Operator Respawn
---------------------------------
operator = trigger_ff_script:new({ team = Team.kBlue })

function operator:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "You are head man in control of starting races, opening track doors & releasing track team." )
		end
	end
end

operator = operator:new({ team = Team.kBlue })

---------------------------------
-- Green Team Respawn
---------------------------------
greenteaminfo = trigger_ff_script:new({ team = Team.kGreen })

function greenteaminfo:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Door only opens if operator needs assistance on the track." )
		end
	end
end

greenteaminfo = greenteaminfo:new({ team = Team.kGreen })

---------------------------------
-- Yellow Team Respawn
---------------------------------
yellowteam = trigger_ff_script:new({ team = Team.kYellow })

function yellowteam:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Head to the window and enjoy!!" )
		end
	end
end
yellowteam = yellowteam:new({ team = Team.kYellow })



