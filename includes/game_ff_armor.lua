--game_ff_armor.lua 1.1 (5-30-2015) R00Kie

-- Default Settings --
TEAM_DAMAGE_ALLOWED = true
TEAM_DAMAGE = 5 -- Divide damage by this much for less armor removed.

MIRROR_DAMAGE_ALLOWED = true
MIRROR_DAMAGE = 5 -- Divide damage by this much for less armor removed.

-- Useful Stuff --
local player_table = {}
local function_table = { player_ondamage = player_ondamage, startup = startup }
local friendly_fire = false

-- Functions --

function startup()
	if type(function_table.startup) == "function" then function_table.startup()	end
	if GetConvar("mp_friendlyfire") == 1 then
		friendly_fire = true
		AddSchedule( "Game_ff_armor", 3, ChatToAll, "^4Armor-only^5 Friendly Fire (Disabled)")
	else
		friendly_fire = false
		AddSchedule( "Game_ff_armor", 3, ChatToAll, "^4Armor-only^5 Friendly Fire (Enabled)")
	end
end

function player_ondamage(player, damageinfo) 
	if type(function_table.player_ondamage) == "function" then function_table.player_ondamage(player, damageinfo) end

	if not damageinfo then return end

	local player_name = player:GetName()
	local attacking_player = damageinfo:GetAttacker()
	local weapon = damageinfo:GetInflictor():GetClassName()
	local attacker = CastToPlayer( attacking_player )
	local damage = damageinfo:GetDamage()
	if not attacker then return end
	
	-- If the player is the attacker, remove immune
	if IsPlayer(attacker) then
		if player:GetTeamId() == attacker:GetTeamId() and player:GetId() ~= attacker:GetId() and not friendly_fire then
			--ChatToAll( damageinfo:GetDamage().." Damage"..player:GetId().." : "..attacker:GetId() )
			if TEAM_DAMAGE_ALLOWED then
				player:RemoveArmor(math.ceil(damage / 5))
			end
			if MIRROR_DAMAGE_ALLOWED then
				attacker:RemoveArmor(math.ceil(damage / 5))
			end
		end
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end
end