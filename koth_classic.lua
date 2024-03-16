------------------------------------------------
-- ff_agora.lua v0.99b
-- Pon.id
-- Commissioned by =AS=zE for ff_agora
-- Give to DudeWheresMyMedic for ff_DMMedic...
-- Description:
-- ------------
-- 
-- Last man standing. Team Deathmatch, with dead people being respawned elsewhere until round over
-- 
--
-- ToDo list:
-- ----------
--
-- Sounds and message on win
------------------------------------------------


---------------------------------
-- Includes
---------------------------------

IncludeScript("base_teamplay");


---------------------------------
-- Global Variables
---------------------------------

TEAM_POINTS_PER_WIN = 10
BLUE_TEAM_NAME = "Blue Solly"
RED_TEAM_NAME = "Red Solly"


---------------------------------
-- Functions
---------------------------------

-- Startup. Pretty basic stuff.
function startup()
-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kRed, RED_TEAM_NAME )
	SetTeamName( Team.kBlue, BLUE_TEAM_NAME )

	-- Blue Team Class limits (only soldier)
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	-- Red Team class limits (same)
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	AddSchedule("turnoffnormalspawn", 1 , turnoffnormalspawn)
end


-- Everyone to spawn with everything.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren1, 2 )
end


-- Calls a function to check if a team has won every time someone dies
function player_killed( killed_entity )
	local player = CastToPlayer( killed_entity )
	player:Spectate ( SpecMode.kRoaming )
	player:SetRespawnable( false )
	CheckTeamAliveState( killed_entity)
end


function Spectate( player )
	player:Spectate( SpecMode.kRoaming )
end 


-- Checks to see if people are still alive. If one team is all dead, declare the other team the winners.
function CheckTeamAliveState(killed_player)
	ConsoleToAll( "CheckTeamAliveState" )
	
	local blue = Collection()
	local red = Collection()

	-- Filter players online into seperate teams. Ignore spectators.
	blue:GetByFilter({ CF.kPlayers, CF.kTeamBlue })
	red:GetByFilter({ CF.kPlayers, CF.kTeamRed })

	-- If either team has no players, then exit. Just one person running about shouldn't get boxed up.
	if (blue:Count() == 0) or (red:Count() == 0) then
		AddSchedule("respawnall", 1 , respawnall)
	end


	local bAlive = 0
	local rAlive = 0

	-- Check all blue team players to see who is still alive
	for temp in blue.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			bAlive = bAlive + 1
		end
	end
	
	-- Same for red
	for temp in red.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
			rAlive = rAlive + 1
		end
	end
	
	-- checks to see if either team is all dead. If so, declare other team the winner, and start new round. If not, set the killed player to spectate
	if (bAlive >= 1) and (rAlive == 0) then
		BroadCastMessage(BLUE_TEAM_NAME .. " win!")
		local team = GetTeam (Team.kBlue)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	elseif (rAlive >= 1) and (bAlive == 0) then
		BroadCastMessage(RED_TEAM_NAME .. " win!")
		local team = GetTeam (Team.kRed)
		team:AddScore(TEAM_POINTS_PER_WIN)
		AddSchedule("respawnall", 3 , respawnall)
	else
		return
	end
end

-- Respawns all players.
function RespawnEveryone()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end


---------------------------------
-- Scheduled functions
---------------------------------


function respawnall()
	RespawnEveryone()
end

-----------------------------------------------------------------------------
-- spawn validty checking
-----------------------------------------------------------------------------

-- makes sure the VIP can only spawn in their teams base
normal_spawn = info_ff_teamspawn:new({ validspawn = function(self, player)
		return EVENT_ALLOWED
end})

-- Ties the map's spawn entities to the above functions
normalspawn = normal_spawn:new()
	
-----------------------------------------------------------------------------
DAMAGE_BONUS = 4 -- Multiplies the player's damage by DAMAGE_BONUS when in the zone. 1 = Normal damage, 4 = Quad damage
RESUPPLY_IN_ZONE = true -- turns resupplying on/off
RESUPPLY_DELAY = 10 -- time between resupplies (if resupplying is on)
RELOAD_CLIPS = true -- periodically reloads all weapons when in the zone if set to true

quad_collection = Collection(); -- stores all players that have quad

-----------------------------------------------------------------------------
-- Damage event - Add Quad Damage
-----------------------------------------------------------------------------
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
	
	-- If the attacker is in the quad area, give quad damage
	if quad_collection:HasItem( playerAttacker ) then 
		damageinfo:SetDamage(damageinfo:GetDamage() * DAMAGE_BONUS)
	end
	
end

-- Fully reload all weapons of a player
function fullreload( player )
	
		ApplyToPlayer( player, { AT.kReloadClips } )
	
end

-----------------------------------------------------------------------------
-- Quad area
-- The area where the player is supposed to be holding
-----------------------------------------------------------------------------

quadarea = trigger_ff_script:new({ })

-- on touch, give quad
function quadarea:ontouch( trigger_entity )
	if ( IsPlayer( trigger_entity ) ) then
		local player = CastToPlayer( trigger_entity )
		
		-- add to the quad collection
		quad_collection:AddItem( player )
		-- if resupplying is on, add schedule
		if RESUPPLY_IN_ZONE then
			AddSchedule("resupply_zone-"..player:GetId(), RESUPPLY_DELAY, fullresupply, player)
		end
		if RELOAD_CLIPS then
			AddSchedule("reload_zone-"..player:GetId(), 5, fullreload, player)
		end
	end
end

-- on endtouch, remove quad
function quadarea:onendtouch( trigger_entity )
	if ( IsPlayer( trigger_entity ) ) then
		local player = CastToPlayer( trigger_entity )
		
		-- remove from the quad collection
		quad_collection:RemoveItem( player )
		-- if resupplying is on, add schedule
		if RESUPPLY_IN_ZONE then
			RemoveSchedule("resupply_zone-"..player:GetId())
		end
		if RELOAD_CLIPS then
			RemoveSchedule("reload_zone-"..player:GetId())
		end
	end
end

-- when no one is in the zone, clear the collection
function quadarea:oninactive( )
	-- remove everyone from the quad collection
	quad_collection:RemoveAllItems()
end