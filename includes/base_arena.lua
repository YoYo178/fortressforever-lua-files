-----------------------------------------------------------------------------
-- base_arena.lua
-- quake clan arena like mode with customizable doodads
-----------------------------------------------------------------------------
--== File last modified:
-- 28 / 02 / 2024 ( dd / mm / yyyy ) by gumbuk
--== Contributors:
-- gumbuk 9
-- mv
-- Pon.Id (code descended from ff_lastteamstanding.lua, no other affiliation)
--== Mode is hosted & developed at:
-- https://github.com/Fortress-Forever-Mapper-Union/ffmu-modes
-----------------------------------------------------------------------------
IncludeScript( "base_teamplay" )

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------

TEAM_POINTS_PER_WIN = 10 -- points to give winning team per won round
DELAY_ROUND_RESPAWN = 5 -- in seconds, time to wait to respawn on new round

BLUE_TEAM_NAME = "Blue"
RED_TEAM_NAME = "Red"
YELLOW_TEAM_NAME = "Yellow"
GREEN_TEAM_NAME = "Green"

SPEED_MODIFIER = 1.3 -- multiplier for player running speed
FRICTION_MODIFIER = 0.6 -- multiplier for player ground friction
GRAVITY_MODIFIER = 1 -- multiplier for player gravity
BLASTJUMP_MODIFIER = Vector( 1.2, 1.2, 1.4 ) -- multiplier for self knockback
BLASTJUMP_DAMAGE = 0 -- multiplier for self damage

ENABLE_PICKUPS = false -- enable spawning items mid match
DELAY_PICKUPS = 70 -- in seconds, time to withhold pickups from spawning
ENABLE_VAMPIRE = false -- players gain health back on kill
VAMPIRE_HEALTH = 30 -- points of health to give when vampirism is enabled

-- table of damage types to allow
-- for use in map hazards for example
DAMAGE_TABLE = {
	Damage.kCrush,
	Damage.kDrown,
	Damage.kShock
}

-- helper table to override team limits in one line
-- instead of replacing the entire startup function
TEAM_LIMITS = { bl = 0, rd = 0, yl = -1, gr = -1 }

PICKUP_LIST = {} -- pickup list for delay purposes

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------

function precache()
	PrecacheSound("misc.bloop")
end

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
	
	SetGameDescription("Arena")
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
	end
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren1, 2 )

	player:SetFriction( FRICTION_MODIFIER )
	player:SetGravity( GRAVITY_MODIFIER )
	player:AddEffect( EF.kSpeedlua1, -1, 0, SPEED_MODIFIER )
end

function player_killed( killed_entity, damageinfo )
	local player = CastToPlayer( killed_entity )
	player:Spectate ( SpecMode.kRoaming ) -- forces player into spectator
	player:SetRespawnable( false ) -- forces player to stay dead

	-- check if the last team is standing
	CheckTeamAliveState()

	-- if vampirism is on, heal killer

	if ENABLE_VAMPIRE then
		local attacker = CastToPlayer(damageinfo:GetAttacker())
		attacker:AddHealth(VAMPIRE_HEALTH)
		return
	end
end

function player_disconnect()
	-- run a check here too, avert edge case that leaves the round stuck
	-- if a team has only 1 player left alive, who then disconnects
	-- without this the round doesn't end until an opponent suicides
	CheckTeamAliveState()
	return true
end

function CheckTeamAliveState()
	-- Checks to see if people are still alive
	-- If only one team is standing, declare them the winners.

	teamz = {}

	for i = Team.kBlue, Team.kGreen do
		col = Collection()
		col:GetByFilter({CF.kPlayers, i+14})

		teamz[i] = {}
		teamz[i].alive = 0
		teamz[i].index = i

		for player in col.items do
			local player = CastToPlayer(player)
			if player:IsAlive() then
				teamz[i].alive = teamz[i].alive + 1
			end
		end
	end

	-- checks to see if rest of the teams are all dead
	-- If so declare the surivors the winners & start new round

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
		winningTeam:AddScore( TEAM_POINTS_PER_WIN )

		AddSchedule("respawnall", DELAY_ROUND_RESPAWN, newround)
		elseif #aliveTeams == 0 then -- If either team has no players, then exit. Just one person running about shouldn't get boxed up.
			AddSchedule("respawnall", 1 , newround)
		else
		return
	end
end

function newround()
	-- helper function to respawn everyone
	ApplyToAll({
	AT.kRemovePacks, AT.kRemoveProjectiles,
	AT.kRespawnPlayers, AT.kAllowRespawn,
	AT.kRemoveBuildables, AT.kRemoveRagdolls,
	AT.kStopPrimedGrens, AT.kReloadClips,
	AT.kReturnDroppedItems
	})

	-- massively overengineered way to delay pickups on new round
	if ENABLE_PICKUPS then
		for key, value in pairs( PICKUP_LIST ) do
			value:Respawn(DELAY_PICKUPS)
		end
	end
end

-----------------------------------------------------------------------------
-- Entities
-----------------------------------------------------------------------------

----====---- extra spawnpoints
agnosticallowedmethod = function(self,player) return player:GetTeamId() ~= Team.kSpectator end
spectatorallowedmethod = function(self,player) return player:GetTeamId() == Team.kSpectator end

agnosticspawn = { validspawn = agnosticallowedmethod }
spectatorspawn = { validspawn = spectatorallowedmethod }

agnostic_spawn = agnosticspawn; spectator_spawn = spectatorspawn

-- use the base_teamplay.lua spawns if you for some reason want teamed spawns

----====---- optional pickups
optionalbackpack = genericbackpack:new({
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function optionalbackpack:spawn()
	if ENABLE_PICKUPS then
		genericbackpack.spawn(self)
		table.insert( PICKUP_LIST, CastToInfoScript(entity) )
	end
end

optionalpedestal = info_ff_script:new({ model = "models/props/ff_cz2/ff_pedestal_cz2.mdl" })

function optionalpedestal:precache()
	PrecacheModel(self.model)
end

function optionalpedestal:spawn()
	if ENABLE_PICKUPS then
		genericbackpack.spawn(self)
	end
end


----====---- advanced upjets
-- (a jumppad is a buildable scouts have, an upjet is a map feature :])
upjet_advanced = info_ff_script:new({ force = Vector( 0, 0, 800 ), exp1 = 0.9, exp2 = 0.3 })
-- define a strength and an exponent

function upjet_advanced:allowed(input_entity)
	if IsPlayer(input_entity) then return true; end
end

function upjet_advanced:onstarttouch(input_player)
	local player = CastToPlayer(input_player)
	local startvel = player:GetVelocity()
	local exponent = self.exp1

	if player:IsDucking() then exponent = self.exp2 end

	player:SetVelocity(
	Vector(
	startvel.x * exponent + self.force.x,
	startvel.y * exponent + self.force.y,
	startvel.z * exponent + self.force.z) )
end

ajet_001 = upjet_advanced:new()
ajet_002 = upjet_advanced:new({ force = Vector( 0, 0, 1400 ) })
ajet_003 = upjet_advanced:new({ force = Vector( 500, 0, 400 ) })

----====---- simple upjets
upjet_simple = trigger_ff_script:new({ force = Vector( 0, 0, 800 ), exponent = 0.9 })

function upjet_simple:allowed( input_entity )
	if IsPlayer( input_entity ) then return true; end
end

function upjet_simple:onstarttouch( input_entity )
	local player = CastToPlayer( input_entity )
	local startvel = player:GetVelocity()

	player:SetVelocity( Vector(
	startvel.x * self.exponent + self.force.x,
	startvel.y * self.exponent + self.force.y,
	startvel.z * self.exponent + self.force.z ) )
end

sjet_001 = upjet_simple:new()
sjet_002 = upjet_simple:new({ force = Vector( 0, 0, 1400 ), exponent = 0.3 })
sjet_003 = upjet_simple:new({ force = Vector( 500, 0, 400 ) })