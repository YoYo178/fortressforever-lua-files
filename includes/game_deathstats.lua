-- game_deathstats.lua v0.2 (3-24-15 3:38pm) R00Kie

local player_table = { }
local function_table = {
	player_connected = player_connected,
	player_ondamage = player_ondamage, 
	startup = startup, 
	player_spawn = player_spawn, 
	player_killed = player_killed
	}

-- FF Function Calls
function player_connected( player )
	if type(function_table.player_connected) == "function" then function_table.player_connected(player)	end
	
	player_table[player:GetId()] = { total_damage = 0, attackers = {}, hud_items = {} }
end
function startup()
	if type(function_table.startup) == "function" then function_table.startup()	end

	set_cvar("mp_forcerespawn", 0 )
end
function player_spawn( player )
	if type(function_table.player_spawn) == "function" then function_table.player_spawn(player)	end
	local player = CastToPlayer ( player )
	local SteamID = player:GetSteamID()
	
	RemoveHudOnSpawn(player)
	--AddHudOnDeath(player) -- Debug
	-- Debug
end

function player_ondamage(player, damageinfo) 
	if type(function_table.player_ondamage) == "function" then function_table.player_ondamage(player, damageinfo) end

	if not damageinfo then return end
	local player_name = player:GetName()
	local attacking_player = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	local attacker = CastToPlayer( attacking_player )
	local damage = damageinfo:GetDamage()
	local playerID = player:GetId()
	
	if not attacker then return end
	
	-- If the player is the attacker, remove immune
	if IsPlayer(attacker) then
		player_table[player:GetId()].total_damage = player_table[player:GetId()].total_damage + damage
		AddKillerInfo(player, damageinfo)
		OnTakeDamage(player)
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end
end

function player_killed( player, damageinfo )
	if type(function_table.player_killed) == "function" then function_table.player_killed(player, damageinfo) end
	-- suicides have no damageinfo
	PrintKillerInfo(player)
	if not damageinfo then return end
	
	local player = CastToPlayer( player )
	local attacker_entity = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	local attacker = CastToPlayer(attacker_entity)

	if not attacker then return end
	if IsPlayer( attacker ) then
		
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end	
end
-- Script Functions
function OnTakeDamage(player)
	AddTimer( "DamageTimer_"..player:GetId(), 0, 1 )
end

function RemoveHudOnSpawn(player)
	local pid = player:GetId()
	RemoveTimer( "DamageTimer_"..pid )
	RemoveHudItem( player, "BGFILL" )
	RemoveHudItem( player, "death_time" )
	RemoveHudItem( player, "WIP" )
	
	for _, v in ipairs(player_table[pid].hud_items) do
		RemoveHudItem( player, v )
	end
	player_table[pid] = { total_damage = 0, attackers = {}, hud_items = {} }
end
function PrintKillerInfo(player)
	local pid = player:GetId()
	local DeathTimer = GetTimerTime( "DamageTimer_"..player:GetId())
	
	local hash = {}
	local hash2 = {}
	local itr = 0 
	AddHudIcon(player, "hud_statusbar_256_128.vtf", "BGFILL", -250, 200, 500, 200, 2)-- for testing
	for _, v in ipairs(player_table[pid].attackers) do
		if (not hash[v]) then
			itr = itr + 1
			AddHudText(player, "Name"..itr,v , -280 + (50 * itr ), 20, 3, 2)
			AddHudText(player, "Divider"..itr,"_____________" , -280 + ( 50 * itr ), 20, 3, 2)
			table.insert(player_table[pid].hud_items, "Name"..itr)
			table.insert(player_table[pid].hud_items, "Divider"..itr)
			hash[v] = true
		end
		local itr2 = 0 
		for _, v2 in ipairs(player_table[pid].attackers.attacker_name) do
			if (not hash2[v2]) then
				itr2 = itr2 + 1
				AddHudText(player, "Weapon"..itr2,v2 , -230, 10 + (-8*itr2) , 3, 2)
				table.insert(player_table[pid].hud_items, "Weapon"..itr2)
				hash2[v2] = true
			end
		end
	end
	AddHudText(player, "death_time", "Took "..tostring(math.floor(player_table[player:GetId()].total_damage)).." damage in "..string.format("%.2f", DeathTimer ).." Seconds", -80, -150, 3, 2)
	AddHudText(player, "WIP","Death Stats plugin is still in development." , -80, -180, 3, 2)
end
function AddKillerInfo(player, damageinfo)
	local attacking_player = damageinfo:GetAttacker()
	local attacker = CastToPlayer( attacking_player )
	local attacker_name = attacker:GetName()
	--local damage = damageinfo:GetDamage() -- Damage not included yet
	local weapon = damageinfo:GetInflictor():GetClassName()
	local pid = player:GetId()
	
	table.insert(player_table[pid].attackers, attacker_name)
	
	local hash = {}
	for _, v in ipairs(player_table[pid].attackers) do
		if (not hash[v]) then
			if player_table[pid].attackers.attacker_name == nil then player_table[pid].attackers.attacker_name = {} end
			table.insert(player_table[pid].attackers.attacker_name, weapon)
		end
	end
end