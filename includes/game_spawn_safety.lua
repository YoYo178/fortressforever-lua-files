--game_spawn_safety.lua 1.0 (5-30-2015) R00Kie
-- Default Settings --
local IMMUNE_TIME = 3

-- Useful Stuff --
local player_table = {}
local function_table = { player_spawn = player_spawn, player_ondamage = player_ondamage }

-- Functions --

-- Add protection and hud indicator on spawn
function player_spawn( player_entity )
	if type(function_table.player_spawn) == "function" then
		function_table.player_spawn( player_entity)
	end
	
	local player = CastToPlayer ( player_entity )
	local steam_id = player:GetSteamID()
	
	player_table[steam_id] = { ["immune"] = true }
	AddHudText(player, "text_"..steam_id, "Spawn Protection: ", 2, 426, 0)
	AddHudTimer(player, "timer_"..steam_id, IMMUNE_TIME + 1, -1, 80, 426, 0)
	AddSchedule( "add_immune_"..steam_id, IMMUNE_TIME, remove_immune, player)
end

function player_ondamage(player, damageinfo) 
	if type(function_table.player_ondamage) == "function" then
		function_table.player_ondamage(player, damageinfo)
	end

	if not damageinfo then return end

	local player_name = player:GetName()
	local attacking_player = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	local attacker = CastToPlayer( attacking_player )
	
	if not attacker then return end
	
	-- If the player is the attacker, remove immune
	if player_table[attacker:GetSteamID()].immune == true and attacker:GetName() == player_name or damageinfo:GetDamage() > 0 then
		remove_immune ( attacker )
	end
	
	-- Deny damage to players that are immune and send a message
	if player_table[player:GetSteamID()].immune == true then
		damageinfo:SetDamage(0)
		damageinfo:SetDamageForce( Vector(0,0,0) )
		ChatToPlayer(attacker, player_name.." has Spawn Protection!")
	end
end

function remove_immune ( player )
	local steam_id = player:GetSteamID()
	
	RemoveHudItem( player, "timer_"..steam_id)
	RemoveHudItem( player, "text_"..steam_id) 
	player_table[steam_id].immune = false
end