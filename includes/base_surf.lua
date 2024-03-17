-- Allows for freestyle or racing.
-- No damage from anything and explosions won't move players.
-- Air accelerate always at 100.
-- All grenades, buildables, and spammable ammo removed at spawn.

-- base_surf.lua - Created By: Jester
-- Version 1.0b

---------------------------------
-- DEFAULTS (CHANGEABLE)
---------------------------------

-- Freestyle / Race modes.
SURF_MODE = SURF_FREESTYLE

-- Race Restart Delay
RESTART_DELAY = 10

-- Points and Frags you receive for touching EndZone.
SURF_POINTS = 110
SURF_FRAGS = 10

-- Disable/Enable classes allowed.
SCOUT = 0
SNIPER = 0
SOLDIER = 0
DEMOMAN = 0
MEDIC = 0
HWGUY = 0
PYRO = 0
SPY = 1
ENGINEER = 0
CIVILIAN = 0

-- Disable/Enable Invunerability
INVUL = 1


---------------------------------
-- DO NOT CHANGE THESE
---------------------------------
SetConvar( "sv_airaccelerate", 100 )
reached_end = 0
SURF_FREESTYLE = 0
SURF_RACE = 1
---------------------------------


function startup()

	SetTeamName( Team.kBlue, "Blue Surfers" )
	SetTeamName( Team.kRed, "Red Surfers" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, SNIPER, Player.kSniper )
	ShouldEnableClass( team, SOLDIER, Player.kSoldier )
	ShouldEnableClass( team, DEMOMAN, Player.kDemoman )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	ShouldEnableClass( team, HWGUY, Player.kHwguy )
	ShouldEnableClass( team, PYRO, Player.kPyro )
	ShouldEnableClass( team, SPY, Player.kSpy )
	ShouldEnableClass( team, ENGINEER, Player.kEngineer )
	ShouldEnableClass( team, CIVILIAN, Player.kCivilian )
	
	
	-- RED TEAM
	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, SNIPER, Player.kSniper )
	ShouldEnableClass( team, SOLDIER, Player.kSoldier )
	ShouldEnableClass( team, DEMOMAN, Player.kDemoman )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	ShouldEnableClass( team, HWGUY, Player.kHwguy )
	ShouldEnableClass( team, PYRO, Player.kPyro )
	ShouldEnableClass( team, SPY, Player.kSpy )
	ShouldEnableClass( team, ENGINEER, Player.kEngineer )
	ShouldEnableClass( team, CIVILIAN, Player.kCivilian )

end

function ShouldEnableClass( team, classtype, class )
	if classtype == 1 then
		team:SetClassLimit( class, 0 )
	else
		team:SetClassLimit( class, -1 )
	end
end


-----------------------------------------------------------------------------
-- Invul Check
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )
	
	if INVUL == 1 then
		local damageforce = damageinfo:GetDamageForce()
		damageinfo:SetDamageForce(Vector( 0, 0, 0 ))
		damageinfo:SetDamage( 0 )
	end
end


-----------------------------------------------------------------------------
-- Ammo Check
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	-- Remove items (similar to both teams)
	player:AddAmmo( Ammo.kGren1, -4 )
	player:AddAmmo( Ammo.kGren2, -4 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kRockets, -300 )
	player:AddAmmo( Ammo.kCells, -300 )

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kNails, 200 )

end


-----------------------------------------------------------------------------
-- Precache Sounds
-----------------------------------------------------------------------------

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end


-----------------------------------------------------------------------------
-- End Zone Entity
-----------------------------------------------------------------------------

endzone = trigger_ff_script:new()

function endzone:ontouch( touch_entity )

	if SURF_MODE == SURF_RACE then
		if reached_end == 0 and IsPlayer( touch_entity ) then
			local player = CastToPlayer( touch_entity )

			ConsoleToAll( player:GetName() .. " reached the endzone!" )
			BroadCastMessage( player:GetName() .. " reached the endzone!" )
		
			SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
			
			player:AddFrags( SURF_FRAGS )
			player:AddFortPoints( SURF_POINTS, "Reached Endzone" )
			reached_end = 1
			
			AddSchedule( "RestartRace", RESTART_DELAY, RestartRace )
		end
	else
		if IsPlayer( touch_entity ) then
			local player = CastToPlayer( touch_entity )
		
			SmartSound(player, "misc.doop", "", "")
			
			player:AddFrags( SURF_FRAGS )
			player:AddFortPoints( SURF_POINTS, "Reached Endzone" )
			
			RestartPlayer( player )
		end
	end
end

function RestartRace()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens })
	reached_end = 0
end

function RestartPlayer( player )
	ApplyToPlayer( player, { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens })
end