-- FF_I_Stole_This.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

function player_spawn( player )
	local player = CastToPlayer ( player )
	local MaxHealth = (player:GetMaxHealth() * 1.25) - player:GetMaxHealth()
	
	player:AddHealth(MaxHealth, true) 			player:AddArmor(200)
end

function player_killed( player, damageinfo )
	-- suicides have no damageinfo
	if not damageinfo then return end
	
	local player = CastToPlayer( player )
	local attacker_entity = damageinfo:GetAttacker()
	local attacker = CastToPlayer(attacker_entity)

	if not attacker then return end
	
	if IsPlayer( attacker ) then
		if player:GetId() ~= attacker:GetId() then
			local MaxHealth = (attacker:GetMaxHealth() * 1.25) - attacker:GetMaxHealth()
			
			attacker:ReloadClips()
			attacker:AddHealth(100, false)
			attacker:AddHealth(MaxHealth, true)
			attacker:AddArmor(200)
			attacker:AddAmmo( Ammo.kShells, 400 )
			attacker:AddAmmo( Ammo.kRockets, 400 )
		end
	elseif IsSentrygun(attacker) then
	elseif IsDetpack(attacker) then
	elseif IsDispenser(attacker) then
	else
		return
	end	
end