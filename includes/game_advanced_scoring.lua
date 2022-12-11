-- Default Settings -- game_advanced_scoring.lua 1.2 02-21-15 | R00Kie

-- Useful Stuff --
local player_table = {}
local function_table = {
	player_ondamage = player_ondamage, 
	startup = startup, 
	player_spawn = player_spawn, 
	player_killed = player_killed
	}

if red_aardvarksec ~= nil then function_table.red_aardvarksec = { ontouch = red_aardvarksec.ontouch } end
if blue_aardvarksec ~= nil then function_table.blue_aardvarksec = { ontouch = blue_aardvarksec.ontouch } end

-- Functions --

function startup()
	if type(function_table.startup) == "function" then function_table.startup()	end
	AddSchedule( "game_advanced_scoring", 3, ChatToAll, "^2CURRENTLY TESTING:^5 Advanced Scoring 1.2")
end
function player_connected ( player_entity )
	local player = CastToPlayer ( player_entity )
	local SteamID = player:GetSteamID()

	player_table[SteamID] = 
	{
		Health = 0
	}
end

function player_spawn( player_entity )
	if type(function_table.player_spawn) == "function" then function_table.player_spawn(player_entity)	end
	local player = CastToPlayer ( player_entity )
	local SteamID = player:GetSteamID()
	
	player_table[SteamID].Health = player:GetHealth()
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
		AddSchedule( "AddPointsOnDamage"..playerID, 0, AddPointsOnDamage, player, attacker)
		FindFlag(player, attacker)
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
	if not damageinfo then return end
	
	local player = CastToPlayer( player )
	local attacker_entity = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	local attacker = CastToPlayer(attacker_entity)
	
	if not attacker then return end
	if IsPlayer( attacker ) then
		
		--AddPointsFlagDefense(player, attacker)
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end	
end
-- Custom Functions
function FindFlag(player, attacker)
	-- Get the attackers flag 
	local flag = GetInfoScriptByName("")
	if attacker:GetTeamId() == Team.kRed then
		flag = GetInfoScriptByName("red_flag")
	elseif attacker:GetTeamId() == Team.kBlue then
		flag = GetInfoScriptByName("blue_flag")
	elseif attacker:GetTeamId() == Team.kYellow then
		flag = GetInfoScriptByName("yellow_flag")
	elseif attacker:GetTeamId() == Team.kGreen then
		flag = GetInfoScriptByName("green_flag")
	end
	
	if flag then
		if player:HasItem(flag:GetName()) then
			AddSchedule( "AddPointsFlagDefense"..player:GetId(), 0, AddPointsFlagDefense, player, attacker)
		end     
	end
end

function AddPointsFlagDefense(player, attacker)
	if player:GetHealth() <= 0 then
		attacker:AddFortPoints(50, "Flag Defended!")
	end
end
--BUG YOU LOSE POINTS WHEN HEALTH IS GAINED
function ResetHealthTable(player, attacker)
	local SteamID = player:GetSteamID()
	local Health = player_table[SteamID].Health
	local CurrentHealth = player:GetHealth()
	local PlayerID = player:GetId()
	
	if Health ~= CurrentHealth then
		player_table[SteamID].Health = CurrentHealth
	end
	AddSchedule( "AddPointsOnDamage"..PlayerID, 0, AddPointsOnDamage, player, attacker)
end

function AddPointsOnDamage( player, attacker )
	local SteamID = player:GetSteamID()
	local Health = player_table[SteamID].Health
	local CurrentHealth = player:GetHealth()
	
	if CurrentHealth < 0 then
		CurrentHealth = 0
	end
	
	local LostHealth = Health - CurrentHealth
	
	if player:GetTeamId() ~= attacker:GetTeamId() then
		if LostHealth > 0 then
			attacker:AddFortPoints(LostHealth, "Player Damage")
		end
	end
	player_table[SteamID].Health = player:GetHealth()
end

-- Aardvark Based sec functions
function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				player:AddFortPoints(100, "Security Shutdown")
			end
		end
	end
	if type(function_table.red_aardvarksec.ontouch) == "function" then function_table.red_aardvarksec.ontouch (self, touch_entity) end
end

function blue_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				player:AddFortPoints(100, "Security Shutdown")
			end
		end
	end
	if type(function_table.blue_aardvarksec.ontouch) == "function" then function_table.blue_aardvarksec.ontouch (self, touch_entity) end
end
