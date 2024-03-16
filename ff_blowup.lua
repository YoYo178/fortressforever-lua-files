--------------------------------------------------------------------------------
-- Map by zE, Lua by Bridget and Squeek
--------------------------------------------------------------------------------

-- includes
IncludeScript("base_push");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )
SetConvar( "cr_engineer", 0 )

-- Only allow blue team and the class scout
function startup()

AddScheduleRepeating( "restock", 1, restock_all )

SetTeamName( Team.kBlue, "Blue Team" )
SetTeamName( Team.kRed, "Quad" )
SetTeamName( Team.kYellow, "Double" )
SetTeamName( Team.kGreen, "Easy Quad" )

SetPlayerLimit( Team.kBlue, -1 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, 0 )
SetPlayerLimit( Team.kGreen, -1 )

-- BLUE TEAM
local team = GetTeam( Team.kBlue )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, -1 )

-- RED TEAM
local team = GetTeam( Team.kRed )
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, 0 )

-- Yellow TEAM
local team = GetTeam( Team.kYellow )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, 0 )

-- Green TEAM
local team = GetTeam( Team.kGreen )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )
end


function restock_all()
	local c = Collection()
	-- get all players
	c:GetByFilter({CF.kPlayers})
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			-- add ammo/health/armor/etc
			class = player:GetClass()
			if class == Player.kSoldier or class == Player.kDemoman then
				player:AddAmmo( Ammo.kGren1, 2 )
				player:AddAmmo(Ammo.kRockets, 50)
				player:AddAmmo( Ammo.kShells, 50 )
			elseif class == Player.kPyro then
				player:AddAmmo( Ammo.kGren1, 2 )
				player:AddAmmo(Ammo.kRockets, 50)
				player:AddAmmo( Ammo.kCells, 50 )
				player:AddAmmo( Ammo.kShells, 50 )
			else
				player:AddAmmo( Ammo.kCells, 50 )
			end
		end
	end
end

-----------------------------------------------------------------------
----------Lua by Bridget and Squeek
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
	player:AddAmmo( Ammo.kRockets, 400) 
        player:RemoveAmmo(Ammo.kGren2, 4)
    elseif player:GetClass() == Player.kPyro then
        player:RemoveAmmo(Ammo.kGren2, 4)
 	player:AddAmmo( Ammo.kRockets, 400) 
    elseif player:GetClass() == Player.kSoldier then
        player:RemoveAmmo(Ammo.kGren2, 4)
	player:AddAmmo( Ammo.kShells, 400 )
        player:AddAmmo( Ammo.kRockets, 400) 
    elseif player:GetClass() == Player.kEngineer then
 	player:RemoveWeapon("ff_weapon_railgun")
        player:RemoveAmmo(Ammo.kGren2, 4)
    	player:RemoveAmmo(Ammo.kGren1, 4)
	player:RemoveAmmo( Ammo.kNails, 400 )
    elseif player:GetClass() == Player.kMedic then
        player:RemoveAmmo(Ammo.kGren1, 4)
	player:AddAmmo( Ammo.kGren2, 4 )
 	player:AddAmmo( Ammo.kNails, 400 )
 	player:AddAmmo( Ammo.kShells, 400 )
    elseif player:GetClass() == Player.kScout then
        player:RemoveAmmo(Ammo.kManCannon, 1)
	player:AddAmmo( Ammo.kShells, 400 )
 	player:AddAmmo( Ammo.kNails, 400 )
    elseif player:GetClass() == Player.kSpy then
  	player:RemoveAmmo(Ammo.kGren2, 4) 
    end

---Remove HUD icon     

    i = returnInformation(player:GetTeamId())
    RemoveHudItem(player, "quad_icon");
    if i["quad"] > 1 then
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
