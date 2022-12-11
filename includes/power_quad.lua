-----------------------------------------------------------------------
---Lua by Bridget and Squeek made for zE Palace Servers
-----------------------------------------------------------------------

---HUD icons and Quad Power

settings = {
    red_vtf        = "quad.vtf",
    red_quad    = 4,
    blue_vtf    = "blue.vtf",
    blue_quad    = 1,
    green_vtf    = "easy.vtf",
    green_quad    = 4,
    yellow_vtf    = "double.vtf",
    yellow_quad    = 2
}

function returnInformation(team)
    i = {vtf="",quad=0}
    if team == Team.kRed     then    i["vtf"]=settings["red_vtf"];        i["quad"]=settings["red_quad"]             end
    if team == Team.kBlue     then    i["vtf"]=settings["blue_vtf"];        i["quad"]=settings["blue_quad"]             end
    if team == Team.kGreen     then     i["vtf"]=settings["green_vtf"];        i["quad"]=settings["green_quad"]         end
    if team == Team.kYellow then     i["vtf"]=settings["yellow_vtf"];    i["quad"]=settings["yellow_quad"]        end
    return i
end

---Remove Grenades and stuff at spawn

function player_spawn(player_entity)
    local player = CastToPlayer(player_entity)
    
    -- Ammo removal
    if player:GetClass() == Player.kDemoman then
        player:RemoveWeapon("ff_weapon_deploydetpack")
   	player:RemoveAmmo(Ammo.kGren2, 4)
	player:AddAmmo( Ammo.kRockets, 400)
        player:AddAmmo( Ammo.kShells, 400 ) 
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kPyro then
        player:RemoveAmmo(Ammo.kGren2, 4)
	player:AddAmmo( Ammo.kCells, 400 )
 	player:AddAmmo( Ammo.kRockets, 400)
 	player:AddAmmo( Ammo.kShells, 400 )
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kSoldier then
        player:RemoveAmmo(Ammo.kGren2, 4)
	player:AddAmmo( Ammo.kShells, 400 )
        player:AddAmmo( Ammo.kRockets, 400) 
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kEngineer then
        player:RemoveAmmo(Ammo.kGren2, 4)
	player:AddAmmo( Ammo.kCells, 400 )
    	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 ) 
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kMedic then
        player:RemoveAmmo(Ammo.kGren1, 4)
	player:AddAmmo( Ammo.kGren2, 4 )
 	player:AddAmmo( Ammo.kNails, 400 )
 	player:AddAmmo( Ammo.kShells, 400 ) 
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kScout then
        player:RemoveAmmo(Ammo.kManCannon, 1)
 	player:RemoveAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
 	player:AddAmmo( Ammo.kNails, 400 )
   	player:AddArmor( 400 ) 
    elseif player:GetClass() == Player.kSpy then
  	player:RemoveAmmo(Ammo.kGren2, 4)
 	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kNails, 400 ) 
   	player:AddArmor( 400 )
    elseif player:GetClass() == Player.kSniper then
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
   	player:AddArmor( 400 )
    end

	--Remove HUD icon     

    i = returnInformation(player:GetTeamId())
    RemoveHudItem(player, "quad_icon");
    if i["quad"] > 1 and player:GetClass() ~= Player.kScout and player:GetClass() ~= Player.kMedic and player:GetClass() ~= Player.kCivilian then
        AddHudIcon(player, i["vtf"], "quad_icon", 5, 119, 48, 48, 0)
    end
    return true
end

function player_switchteam(player, old, new)
    RemoveHudItem(player, "quad_icon"); return true
end

---Quad and no damage except for trigger_hurt

function player_ondamage( player, damageinfo )

    -- if no damageinfo do nothing
    if not damageinfo then return end

    -- remove all fall damage
    if damageinfo:GetDamageType() == Damage.kFall then
        damageinfo:SetDamage(0)
        return
    end

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
	
	if player:GetTeamId() == Team.kGreen then ApplyToPlayer(player, {AT.kReloadClips}) end

    -- If attacker is also the victim (self damage)
    if player:GetId() == player_attacker:GetId() then
        -- change push force
        local damage_force = damageinfo:GetDamageForce()
        i = returnInformation(player:GetTeamId())
        damageinfo:SetDamageForce(Vector(damage_force.x*i["quad"], damage_force.y*i["quad"], damage_force.z*i["quad"]))
        -- set damage to zero
        damageinfo:SetDamage(0)
        return
    end

    -- for everyone else, use attackers quad force
    -- change push force
    local damage_force = damageinfo:GetDamageForce()
    i = returnInformation(player_attacker:GetTeamId())
    damageinfo:SetDamageForce(Vector(damage_force.x*i["quad"], damage_force.y*i["quad"], damage_force.z*i["quad"]))
    -- set damage to zero
    damageinfo:SetDamage(0)
 
end