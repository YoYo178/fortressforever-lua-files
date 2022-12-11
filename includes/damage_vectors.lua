-- Default Settings --
local HEAD_DAMAGE = 2.0 
local HEAD_RANGE = { low = 60, high = 999 }
 
local CHEST_DAMAGE = 1.0 
local CHEST_RANGE = { low = 45, high = 60 }

local STOMACH_DAMAGE = 0.9
local STOMACH_RANGE = { low = 30, high = 45 }

local LEGS_DAMAGE = 0.5
local LEGS_RANGE = { low = 0, high = 30 }

-- Useful Stuff --
local name = "Damage Vectors ^41.1"
local function_table = { player_ondamage = player_ondamage }

-- Functions --
AddSchedule( "Vector Ver", 10, ChatToAll, name )
function player_ondamage(player, damageinfo) 
	if type(function_table.player_ondamage) == "function" then function_table.player_ondamage( player, damageinfo ) end

	if not damageinfo then return end
	
	local attacker = damageinfo:GetAttacker()
	local damage_area = damageinfo:GetDamagePosition().z
	local damage_type = damageinfo:GetDamageType()
	local rail = 4160
	local direct = 4098
	local weapon = damageinfo:GetInflictor():GetClassName()
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
		if damage_type == rail or damage_type == direct and weapon ~= "ff_weapon_sniperrifle" then
			if damage_area < LEGS_RANGE.high then
				--ChatToAll("LEGS")
				damageinfo:ScaleDamage(LEGS_DAMAGE)
			elseif damage_area > STOMACH_RANGE.low and damage_area < STOMACH_RANGE.high then
				--ChatToAll("STOMACH")
				damageinfo:ScaleDamage(STOMACH_DAMAGE)
			elseif damage_area > CHEST_RANGE.low and damage_area < CHEST_RANGE.high then
				--ChatToAll("CHEST")
				damageinfo:ScaleDamage(CHEST_DAMAGE)
			elseif damage_area > HEAD_RANGE.low then
				--ChatToAll("HEADSHOT")
				damageinfo:ScaleDamage(HEAD_DAMAGE)
			else return end
		end
			--ChatToAll(tostring(weapon))
			--ChatToAll(tostring(damageinfo:GetDamageType()))
			--ChatToAll(tostring(damageinfo:GetDamage()))
			--ChatToAll("x: "..tostring(damageinfo:GetDamagePosition().x).."Y: "..tostring(damageinfo:GetDamagePosition().y).." Z: "..tostring(damageinfo:GetDamagePosition().z))
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
	
end
