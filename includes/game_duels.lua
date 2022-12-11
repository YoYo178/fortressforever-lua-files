-- Default Settings --
local REQUEST_RADIUS = 128
local FIGHT_TIME = 30

local USE_OBJECTIVEICON = true
local RESTOCK_PLAYER = true

-- Useful Stuff --
local player_table = {}
local function_table = { player_spawn = player_spawn, player_ondamage = player_ondamage, startup = startup, player_killed = player_killed }
function_table.baseflag = { touch = baseflag.touch }
num_fights = 0
-- Functions --

function startup()
	if type(function_table.startup) == "function" then function_table.startup()	end
	AddSchedule( "Game_duels", 3, ChatToAll, "Running Game Dueling")
	AddScheduleRepeating( "Search_Request", 1, search_player)
end

function player_spawn( player_entity )
	if type(function_table.player_spawn) == "function" then function_table.player_spawn( player_entity ) end
	
	local player = CastToPlayer ( player_entity )
	player_table[player:GetId()] = { accepted_duel = false, starting_duel = false }	
end

function player_ondamage(player, damageinfo) 
	if type(function_table.player_ondamage) == "function" then function_table.player_ondamage( player, damageinfo ) end

	if not damageinfo then return end

	local damage = damageinfo:GetDamage()
	local attacker = damageinfo:GetAttacker()

	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
		
		local attacker_duel = player_table[player_attacker:GetId()].accepted_duel
		local player_duel = player_table[player:GetId()].accepted_duel
		local player_start = player_table[player:GetId()].starting_duel
		
		if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then return end
		
		if player_start then 
			damageinfo:SetDamage(0)
			damageinfo:SetDamageForce( Vector(0,0,0) )
			return
		end
		
		if attacker_duel and player_duel then
			-- ChatToAll("YES!") -- Debug
			return
		elseif not attacker_duel and not player_duel then
			return
		else
			ChatToPlayer(player_attacker, "In a Duel!")
			damageinfo:SetDamage(0)
			damageinfo:SetDamageForce( Vector(0,0,0) )
		end
	
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

	local damageforce = damageinfo:GetDamageForce()
	local weapon = damageinfo:GetInflictor():GetClassName()
end

function player_killed(player, damageinfo)
	if type(function_table.player_killed) == "function" then function_table.player_killed( player, damageinfo ) end

	if not damageinfo then return end

	local damage = damageinfo:GetDamage()
	local attacker = damageinfo:GetAttacker()

	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
		
		local attacker_duel = player_table[player_attacker:GetId()].accepted_duel
		local player_duel = player_table[player:GetId()].accepted_duel
		
		if player_duel then
			fight_end(player, player_attacker)
		end
		
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

	local damageforce = damageinfo:GetDamageForce()
	local weapon = damageinfo:GetInflictor():GetClassName()
end

function accept_duel(player, player_requester)
	-- Send Player information
	BroadCastMessageToPlayer(player, "CHALLENGE ACCPETED")
	
	AddSchedule( "P3", 1, BroadCastMessageToPlayer, player, "3")
	AddSchedule( "P2", 2, BroadCastMessageToPlayer, player, "2")
	AddSchedule( "P1", 3, BroadCastMessageToPlayer, player, "1")
	
	player_table[player:GetId()].accepted_duel = true
	player_table[player:GetId()].starting_duel = true
	
	if RESTOCK_PLAYER then
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, 4 )
		player:AddHealth(100)
		player:AddArmor(300)
	end
	
	-- Send Requester information
	BroadCastMessageToPlayer(player_requester, "CHALLENGE ACCPETED")
	
	AddSchedule( "R3", 1, BroadCastMessageToPlayer, player_requester, "3")
	AddSchedule( "R2", 2, BroadCastMessageToPlayer, player_requester, "2")
	AddSchedule( "R1", 3, BroadCastMessageToPlayer, player_requester, "1")
	
	player_table[player_requester:GetId()].accepted_duel = true
	player_table[player_requester:GetId()].starting_duel = true
	
	if RESTOCK_PLAYER then
		player_requester:AddAmmo( Ammo.kGren1, 4 )
		player_requester:AddAmmo( Ammo.kGren2, 4 )
		player_requester:AddHealth(100)
		player_requester:AddArmor(300)
	end
	
	--Send Other Information
	if USE_OBJECTIVEICON then
		UpdateObjectiveIcon(player_requester, player)
		UpdateObjectiveIcon(player, player_requester)
	end
	
	AddSchedule( "Fight", 4, fight, player, player_requester )
	-- ChatToAll("CHALLENGE ACCEPTED!") --Debug
end

function fight(player, player_requester)
	local timer = FIGHT_TIME
	
	-- Send Player information
	BroadCastMessageToPlayer(player, "Fight!")
	
	player_table[player:GetId()].starting_duel = false
	
	AddHudTimer(player, "hud_timer"..player:GetId() ,timer, -1, 0, 70, 4)
	
	
	-- Send Requester information
	BroadCastMessageToPlayer(player_requester, "Fight!")
	
	player_table[player_requester:GetId()].starting_duel = false	
	
	AddHudTimer(player_requester, "hud_timer"..player_requester:GetId() ,timer, -1, 0, 70, 4)
	
	--Send Other Information
	num_fights = num_fights + 1
	AddSchedule( "fight_time"..num_fights, timer, fight_end, player, player_requester)
end

function fight_end(player, player_requester)
	-- Send Player information
	BroadCastMessageToPlayer(player, player_requester:GetName().." Won the Duel!")
	
	RemoveHudItem( player, "hud_timer"..player:GetId() )
	
	player_table[player:GetId()].accepted_duel = false
	
	-- Send Requester information
	BroadCastMessageToPlayer(player_requester, player_requester:GetName().." Won the Duel!")
	
	RemoveHudItem( player_requester, "hud_timer"..player_requester:GetId() )
	
	player_table[player_requester:GetId()].accepted_duel = false
	
	--Send Other Information
	if USE_OBJECTIVEICON then
		UpdateObjectiveIcon(player_requester, nil)
		UpdateObjectiveIcon(player, nil)
	end
	-- ChatToAll("Fight Over!")--Debug
	ObjectiveNotice( player_requester, "Won a Duel!" )
	DeleteSchedule( "fight_time"..num_fights )
end

function request_message(player, player_requester)
	BroadCastMessageToPlayer( player_requester, player:GetName().." Has Challenged You to a Duel! " )
	BroadCastMessageToPlayer( player_requester, "Hold USE to Accept!" )
end

function search_player()
	local c = Collection()
	
	c:GetByFilter({CF.kPlayers, CF.kTeamRed})
	--c:GetByFilter({CF.kPlayers, CF.kTeamBlue})
	--c:GetByFilter({CF.kPlayers, CF.kTeamYellow})
	--c:GetByFilter({CF.kPlayers, CF.kTeamGreen})
	
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			duel_request( player )
		end
	end
end

function duel_request(player_requester)
	local c = Collection()
	local radius = REQUEST_RADIUS
	
	c:GetInSphere( player_requester, radius, {CF.kPlayers, CF.kTeamBlue, CF.kTraceBlockWalls} )
	for temp in c.items do
		local player = CastToPlayer( temp )
		
		local requester_duel = player_table[player_requester:GetId()].accepted_duel
		local player_duel = player_table[player:GetId()].accepted_duel
		
		if player then
			if player_requester:GetTeamId() == Team.kRed and not requester_duel then 
				if player:IsInUse() then
					request_message(player, player_requester)
				end
			end	
			if player:GetTeamId() == Team.kBlue and not player_duel then
				if player_requester:IsInUse() then
					request_message(player_requester, player)
				end
			end
			if player_requester:IsInUse() and player:IsInUse() and not requester_duel then	-- 
				accept_duel(player, player_requester)
			end
		end
	end
end

function baseflag:touch ( touch_entity )
	local player = CastToPlayer ( touch_entity )

	if not player_table[player:GetId()].accepted_duel then
		if type(function_table.baseflag.touch) == "function" then
			function_table.baseflag.touch (self, touch_entity)
		end
		
	-- Send message to players trying to take a protected flag
	else	
		ChatToPlayer(player, "You are in a duel! You can't do that!")
	end
end