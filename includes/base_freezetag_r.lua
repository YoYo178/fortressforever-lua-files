IncludeScript("base_teamplay");
IncludeScript("base_respawnturret");

NUMBER_OF_IT = 1 -- default; not used if GET_NUMBER_IT_FROM_NUMPLAYERS = true
GET_NUMBER_IT_FROM_NUMPLAYERS = true
TAG_RADIUS = 64
UNFREEZE_RADIUS = 128
ROUND_TIME = 90

SCORE_PER_RUNNER_WIN = 1
SCORE_PER_IT_WIN = 1

FORT_POINTS_PER_FREEZE = 100
FORT_POINTS_PER_UNFREEZE = 100

NO_TAG_BACK_TIME = 2

NUMBER_OF_FROZEN = -1

AUTO_RESTOCK_ROCKETS = true
AUTO_RESTOCK_CONCS = true
RESTOCK_ITERATION_TIME = 1

RUNNER_TEAM = Team.kBlue
IT_TEAM = Team.kRed
FROZEN_TEAM = Team.kYellow
DISABLED_TEAM = Team.kGreen

player_table = {}
no_tag = true

ItCollection = Collection()
RunnerCollection = Collection()

round_timer = 0
draw_timer = false

-- startup
function startup()

	SetGameDescription( "Freeze Tag" )

	SetTeamName( RUNNER_TEAM, "Runners" )
	SetTeamName( IT_TEAM, "It" )
	SetTeamName( FROZEN_TEAM, "Frozen" )
	
	SetPlayerLimit(RUNNER_TEAM, 0)
	SetPlayerLimit(IT_TEAM, 1)
	SetPlayerLimit(FROZEN_TEAM, -1)
	SetPlayerLimit(DISABLED_TEAM, -1)
	
	-- Red is it
	local team = GetTeam( IT_TEAM )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	-- Blue is scared
	local team = GetTeam( RUNNER_TEAM )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	-- Blue is scared
	local team = GetTeam( FROZEN_TEAM )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	
	InitialRound()
	no_tag = true
	
	if AUTO_RESTOCK_CONCS then
		AddScheduleRepeating( "RestockConcs", RESTOCK_ITERATION_TIME, scheduleGiveConcs )
	end
	if AUTO_RESTOCK_ROCKETS then
		AddScheduleRepeating( "RestockRockets", RESTOCK_ITERATION_TIME, scheduleGiveRockets )
	end
end

-----------------------------------------
-- functions
-----------------------------------------

function Freeze( tagger, tagged )
	ApplyToPlayer( tagged, { AT.kChangeTeamYellow } )
	tagged:Freeze(true)
	
	if tagged:GetLocation() ~= nil then
		BroadCastMessage( tagged:GetName().." got frozen by "..tagger:GetName().." in the "..tagged:GetLocation().."!" )
	else
		BroadCastMessage( tagged:GetName().." got frozen by "..tagger:GetName().."!" )
	end
	BroadCastMessageToPlayer( tagged, "You got frozen by "..tagger:GetName().."!" )
	BroadCastMessageToPlayer( tagger, "You froze "..tagged:GetName().."!" )
	
    tagger:AddFortPoints( FORT_POINTS_PER_FREEZE, "Freezing a Runner" ) 
	
	if NUMBER_OF_FROZEN < 0 then NUMBER_OF_FROZEN = 0 end
	NUMBER_OF_FROZEN = NUMBER_OF_FROZEN + 1
	--SetPlayerLimit(FROZEN_TEAM, NUMBER_OF_FROZEN)
	
	player_table[tagged:GetSteamID()].no_unfreeze = true
	AddSchedule( "notagbacks"..tagged:GetSteamID(), NO_TAG_BACK_TIME, EndNoUnFreeze, tagged:GetSteamID() )
	
	if GetTeam( RUNNER_TEAM ):GetNumPlayers() == 0 and GetTeam( FROZEN_TEAM ):GetNumPlayers() > 0 then
		RoundEnd()
	end
	
	HUD_UpdateNumFrozen()
end

function UnFreeze( toucher, touched )
	--ConsoleToAll( "[script] should be working "..touched:GetName().." by "..toucher:GetName() )
	ApplyToPlayer( touched, { AT.kChangeTeamBlue } )
	touched:Freeze(false)
	
    toucher:AddFortPoints( FORT_POINTS_PER_UNFREEZE, "Unfreezing a Runner" ) 
	
	NUMBER_OF_FROZEN = NUMBER_OF_FROZEN - 1
	if NUMBER_OF_FROZEN == 0 then NUMBER_OF_FROZEN = -1 end
	--SetPlayerLimit(FROZEN_TEAM, NUMBER_OF_FROZEN)
	
	--player_table[touched:GetSteamID()].no_freeze = true
	--AddSchedule( "notagbacks"..touched:GetSteamID(), NO_TAG_BACK_TIME, EndNoFreeze, touched:GetSteamID() )
	
	BroadCastMessage( touched:GetName().." got unfrozen by "..toucher:GetName().."!" )
	BroadCastMessageToPlayer( touched, "You got unfrozen by "..toucher:GetName().."!" )
	BroadCastMessageToPlayer( toucher, "You unfroze "..touched:GetName().."!" )
	
	player_table[touched:GetSteamID()].no_freeze = true
	AddSchedule( "notagbacks"..touched:GetSteamID(), NO_TAG_BACK_TIME, EndNoFreeze, touched:GetSteamID() )
	
	HUD_UpdateNumFrozen()
end

function FreezeAllIt( )
	local c = Collection()
	
	c:GetByFilter( {CF.kPlayers, CF.kTeamRed} )
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			player:Freeze(true)
		end
	end
end

function EndNoFreeze( playerid )
	player_table[playerid].no_freeze = false
end

function EndNoUnFreeze( playerid )
	player_table[playerid].no_unfreeze = false
end

function MakeIt( it )
	ApplyToPlayer( it, { AT.kChangeTeamRed } )
	ApplyToPlayer( it, { AT.kChangeClassSoldier, AT.kRespawnPlayers } )
	BroadCastMessageToPlayer( it, "You're it!" )
end

function EndIt( old_it )
	ApplyToPlayer( old_it, { AT.kChangeClassScout, AT.kChangeTeamBlue } )
end

function scheduleGiveConcs()
	local c = Collection()
	-- get all players
	c:GetByFilter({CF.kPlayers, CF.kPlayerScout, CF.kTeamBlue })
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			UpdateTeamObjectiveIcon(GetTeam(Team.kRed), player)
			--player:AddAmmo( Ammo.kGren2, 4 )
			--player:AddAmmo( Ammo.kManCannon, 1 )
		end
	end
end

function scheduleGiveRockets()
	local c2 = Collection()
	-- get all players
	c2:GetByFilter({CF.kPlayers, CF.kPlayerSoldier})
	-- loop through all players
	for temp in c2.items do
		local player = CastToPlayer( temp )
		if player then
			player:AddAmmo( Ammo.kRockets, 100 )
			ApplyToPlayer( player, { AT.kReloadClips } )
		end
	end
end

function RoundEndRunners()
	draw_timer = false
	no_tag = true
	flaginfo( nil )
	
	local team = GetTeam(RUNNER_TEAM)
	team:AddScore( SCORE_PER_RUNNER_WIN )
	
	BroadCastMessage( "ROUND OVER! Runners win!" )
	RemoveSchedule( "RoundReset" )
	AddSchedule( "RoundReset", 5, RoundReset )
	FreezeAllIt()
end

function RoundEnd()
	RemoveSchedule( "round_end_runner" )
	
	draw_timer = false
	no_tag = true
	flaginfo( nil )
	
	local team = GetTeam(IT_TEAM)
	team:AddScore( SCORE_PER_IT_WIN )
	
	BroadCastMessage( "ROUND OVER! It team wins!" )
	RemoveSchedule( "RoundReset" )
	AddSchedule( "RoundReset", 5, RoundReset )
end

function InitialRound()
	draw_timer = false
	no_tag = true
	flaginfo( nil )
	
	BroadCastMessage( "Game starting in 5 seconds..." )
	AddSchedule( "gamestart1", 1, BroadCastMessage, "Game starting in 4 seconds..." )
	AddSchedule( "gamestart2", 2, BroadCastMessage, "Game starting in 3 seconds..." )
	AddSchedule( "gamestart3", 3, BroadCastMessage, "Game starting in 2 seconds..." )
	AddSchedule( "gamestart4", 4, BroadCastMessage, "Game starting in 1 seconds..." )

	RemoveSchedule( "RoundReset" )
	AddSchedule( "RoundReset", 5, RoundReset )
end

function RoundReset()

	DesignateTeams()
	
	ApplyToTeam( GetTeam( IT_TEAM ), { AT.kDisallowRespawn } )
	ApplyToTeam( GetTeam( RUNNER_TEAM ), { AT.kDisallowRespawn } )
			
	-- switch all its
	for temp in ItCollection.items do
		local player = CastToPlayer( temp )
		if player then
			ApplyToPlayer( player, { AT.kChangeTeamRed } )
			ApplyToPlayer( player, { AT.kChangeClassSoldier, AT.kDisallowRespawn, AT.kKillPlayers, AT.kStopPrimedGrens } )
		end
	end
	-- switch all runners
	for temp in RunnerCollection.items do
		local player = CastToPlayer( temp )
		if player then
			ApplyToPlayer( player, { AT.kChangeTeamBlue } )
			ApplyToPlayer( player, { AT.kChangeClassScout, AT.kAllowRespawn, AT.kRespawnPlayers, AT.kStopPrimedGrens } )
		end
	end
	
	AddSchedule( "Allowspawn1", 5, ApplyToTeam, GetTeam( IT_TEAM ), { AT.kAllowRespawn, AT.kRespawnPlayers } )
	
	AddSchedule( "Allowspawn2", 0, BroadCastMessage, "5" )
	AddSchedule( "Allowspawn3", 1, BroadCastMessage, "4" )
	AddSchedule( "Allowspawn4", 2, BroadCastMessage, "3" )
	AddSchedule( "Allowspawn5", 3, BroadCastMessage, "2" )
	AddSchedule( "Allowspawn6", 4, BroadCastMessage, "1" )
	AddSchedule( "Allowspawn7", 5, BroadCastMessage, "Ready or not, here they come!" )
	
	AddSchedule( "SetupTimer", 5, SetupTimer )
	
	HUD_UpdateNumFrozen()
end

---[[
	function CalcNumIt()
	local num_players = GetTeam( RUNNER_TEAM ):GetNumPlayers() + GetTeam( FROZEN_TEAM ):GetNumPlayers() + GetTeam( IT_TEAM ):GetNumPlayers()
	-- Using math.floor(num_players / 3.1 + 1):
	--
	--	Total	It		Runners
	--	------	------	-------
	--	1		1		0
	--	2		1		1
	--	3		1		2
	--	4		2		2
	--	5		2		3
	--	6		2		4
	--	7		3		4
	--	8		3		5
	--	9		3		6
	--	10		4		6
	--	11		4		7
	--	12		4		8
	--	...		...		...
	NUMBER_OF_IT = math.floor(num_players / 3.1 + 1)
end
--]]
---[[
function DesignateTeams()
	 CalcNumIt()
	
	ItCollection:RemoveAllItems()
	RunnerCollection:RemoveAllItems()
	
	local translation_table = {}
	local index = 0
	for i,v in pairs(player_table) do
		if GetPlayerByID( i ) then
			local playerx = GetPlayerByID( i )
			-- remove entries of players that arent on a team anymore
			if playerx:GetTeamId() ~= RUNNER_TEAM and playerx:GetTeamId() ~= IT_TEAM and playerx:GetTeamId() ~= FROZEN_TEAM then
				table.remove(player_table, i)
			-- copy indexes into another table that is easier to traverse
			else
				table.insert(translation_table, i)
				ConsoleToAll("[SCRIPT] "..playerx:GetName().." added to the translation table")
			end
		-- remove entries that arent players
		else
			table.remove(player_table, i)
		end
	end
	
	-- fill ItCollection with NUMBER_OF_IT random players from the table
	while (ItCollection:Count() < NUMBER_OF_IT) and (# translation_table >= NUMBER_OF_IT - ItCollection:Count()) do
		local num_players = # translation_table
		local randomindex = math.random(num_players)
		ConsoleToAll("[SCRIPT] Random Index: "..randomindex.." / "..# translation_table)
		if GetPlayerByID( translation_table[randomindex] ) then
			local playerx = GetPlayerByID( translation_table[randomindex] )
			ItCollection:AddItem( playerx )
			table.remove(translation_table, randomindex)
			ConsoleToAll("[SCRIPT] "..playerx:GetName().." added to the it collection")
		end
	end
	-- fill RunnerCollection with the rest of the players in the table
	for i,v in pairs(translation_table) do
		if GetPlayerByID( v ) then
			local playerx = GetPlayerByID( v )
			RunnerCollection:AddItem( playerx )
			ConsoleToAll("[SCRIPT] "..playerx:GetName().." added to the runner collection")
		end
	end
end

function SetupTimer()
	no_tag = false
	
	round_timer = ROUND_TIME
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, round_timer )
	AddSchedule( "round_end_runner", ROUND_TIME, RoundEndRunners )
	
	draw_timer = true
	flaginfo( nil )
end

function timer_schedule()
	round_timer = round_timer - 1
end
--]]
--------------------------------------
-- player functions
--------------------------------------

-- spawns attackers with flags
function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	
	player:Freeze( false )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )
	
	player:RemoveWeapon( "ff_weapon_shotgun" )
	player:RemoveWeapon( "ff_weapon_supershotgun" )
	player:RemoveWeapon( "ff_weapon_nailgun" )
	player:RemoveWeapon( "ff_weapon_supernailgun" )
	player:RemoveWeapon( "ff_weapon_autorifle" )
	
	local id = player:GetSteamID()
	
	 CalcNumIt()
	
	local team_it = GetTeam( IT_TEAM )
	if team_it:GetNumPlayers() < NUMBER_OF_IT then
		MakeIt( player )
	end
	
	-- goalies run fast
	if player:GetClass() ~= Player.kSoldier then
		player:RemoveEffect( EF.kSpeedlua1 )
	else
		player:AddEffect( EF.kSpeedlua1, -1, 0, 2 )
		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
	end
	
	for i,v in pairs(player_table) do
		if GetPlayerByID( i ) then
			local playerx = GetPlayerByID( i )
			if playerx:GetTeamId() ~= RUNNER_TEAM and playerx:GetTeamId() ~= IT_TEAM and playerx:GetTeamId() ~= FROZEN_TEAM then
				table.remove(player_table, i)
			end
		else
			table.remove(player_table, i)
		end
	end
	
	player_table[id] = { no_freeze = false, no_unfreeze = false }
	
end

function player_switchteam( player, old_team, new_team )
	--ConsoleToAll( "[script] old team: "..old_team )
	if old_team == FROZEN_TEAM then
		return false
	end
	if new_team == Team.kSpectator then
		table.remove(player_table, i)
		-- TODO: check if was it, and swap in a new one if necessary
	end
	return true
end

function player_disconnected( player )
	table.remove(player_table, player:GetSteamID())
end

function player_ondamage( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end
	
	-- Get Damage Force
	damageinfo:SetDamage(0)
  
	-- Get Damage Force
	local damage = damageinfo:GetDamage()

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
	if (player:GetSteamID() == player_attacker:GetSteamID()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
		return 
	end

	local damageforce = damageinfo:GetDamageForce()
	local weapon = damageinfo:GetInflictor():GetClassName()
  
	-- rocket shots stop players dead
	if weapon == "ff_projectile_rocket" and player_attacker:GetTeamId() == IT_TEAM then
		--player:SetVelocity( Vector(0,0,0) )
		--damageinfo:SetDamageForce( Vector(0,0,0) )
		--damageinfo:SetDamageForce(Vector( 0 - damageforce.x, 0 - damageforce.y, damageforce.z ))
	end
	
end

--------------------------------
-- detect touches
--------------------------------


-- conc tag arena
arena = trigger_ff_script:new({})

function arena:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		return true
	end
	return false
end

function arena:ontrigger( trigger_entity )
	
	local c = Collection()
	
	c:GetByFilter( {CF.kPlayers, CF.kTeamRed} )
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			detect_touch( player )
		end
	end
	
	local d = Collection()
	
	d:GetByFilter( {CF.kPlayers, CF.kTeamYellow} )
	for temp in d.items do
		local player = CastToPlayer( temp )
		if player then
			detect_touch( player )
		end
	end
	
end

function detect_touch( player_tagger )
	
	if no_tag then return end
	
	local c = Collection()
	
	local radius = TAG_RADIUS
	if player_tagger:GetTeamId() == FROZEN_TEAM then radius = UNFREEZE_RADIUS end
	
	c:GetInSphere( player_tagger, radius, {CF.kPlayers, CF.kTeamBlue, CF.kTraceBlockWalls} )
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			if player_tagger:GetTeamId() == IT_TEAM then
				if player_table[player:GetSteamID()].no_freeze then return end
				Freeze( player_tagger, player )
				return
			elseif player_tagger:GetTeamId() == FROZEN_TEAM then
				if player_table[player_tagger:GetSteamID()].no_unfreeze then return end
				UnFreeze( player, player_tagger )
				return
			end
		end
	end
	
end

function HUD_UpdateNumFrozen()
	ConsoleToAll("[script] called")
	AddHudTextToAll( "num_frozen", GetTeam( FROZEN_TEAM ):GetNumPlayers().." / "..(GetTeam( FROZEN_TEAM ):GetNumPlayers() + GetTeam( RUNNER_TEAM ):GetNumPlayers()).." Runners Frozen", 0, 46, 4 )
end

function flaginfo( player )
	if IsPlayer( player ) then
		AddHudText( player, "num_frozen", GetTeam( FROZEN_TEAM ):GetNumPlayers().." / "..(GetTeam( FROZEN_TEAM ):GetNumPlayers() + GetTeam( RUNNER_TEAM ):GetNumPlayers()).." Runners Frozen", 0, 46, 4 )
		
		if draw_timer then
			AddHudText( player, "round_text", "Round Ends In:", 0, 62, 4 )
			AddHudTimer( player, "round_timer", round_timer + 1, -1, 0, 70, 4 )
		else
			RemoveHudItem( player, "round_timer" )
			RemoveHudItem( player, "round_text" )
		end
	else
		if draw_timer then
			AddHudTextToAll( "round_text", "Round Ends In:", 0, 62, 4 )
			AddHudTimerToAll( "round_timer", round_timer + 1, -1, 0, 70, 4 )
		else
			RemoveHudItemFromAll( "round_timer" )
			RemoveHudItemFromAll( "round_text" )
		end
	end
end