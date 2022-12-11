-- ff_bunkerwars.lua
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
-----------------------------------------------------------------------------

POINTS_X_KILL = 5
DAMAGE_POINTS_SCALE = 20
POINT_EVERY_X_HITS_NAIL = 5
POINT_EVERY_X_HITS_ASSAULTCANNON = 7
BLUETEAM_BASE_POINTS = 2500
REDTEAM_BASE_POINTS = 2500
-----------------------------------------------------------------------------
zerored_points = 0
zeroblue_points = 0
blueteam = Team.kBlue
redteam = Team.kRed

function precache()
    PrecacheSound("misc.bloop")
    PrecacheSound("misc.doop")
    PrecacheSound("ff_anticitizen.explode_3")
    PrecacheSound("ff_anticitizen.explode_4")
end

function startup()
    SetPlayerLimit(Team.kBlue, 0)
    SetPlayerLimit(Team.kRed, 0)
    SetPlayerLimit(Team.kYellow, -1)
    SetPlayerLimit(Team.kGreen, -1)

    local team = GetTeam(Team.kBlue)
    team:SetClassLimit(Player.kCivilian, -1)
    team:SetClassLimit(Player.kSniper, 2)

    local team = GetTeam(Team.kRed)
    team:SetClassLimit(Player.kCivilian, -1)
    team:SetClassLimit(Player.kSniper, 2)

    SetGameDescription("Bunker Wars")
    AddSchedule("prematch_start", 1, prematch)
end
local teamdata = {
    [Team.kBlue] = {
        skin = "0",
        beamcolour = "0 0 255"
    },
    [Team.kRed] = {
        skin = "1",
        beamcolour = "255 0 0"
    }
}
function prematch()
    local team = GetTeam(Team.kRed)
    team:AddScore(REDTEAM_BASE_POINTS)

    local team = GetTeam(Team.kBlue)
    team:AddScore(BLUETEAM_BASE_POINTS)
end

-- target
red_target = func_button:new({})
blue_target = func_button:new({})

bluespawn = info_ff_teamspawn:new({
    validspawn = function(self, player)
        return player:GetTeamId() == blueteam
    end
})
redspawn = info_ff_teamspawn:new({
    validspawn = function(self, player)
        return player:GetTeamId() == redteam
    end
})

-----------------------------------------------------------------------------
-- player functions
-----------------------------------------------------------------------------

local playerDamageTable = {}

function player_spawn(player_entity)

    local player = CastToPlayer(player_entity)

    player:AddHealth(100)
    player:AddArmor(300)

    player:AddAmmo(Ammo.kNails, 400)
    player:AddAmmo(Ammo.kShells, 400)
    player:AddAmmo(Ammo.kRockets, 400)
    player:AddAmmo(Ammo.kCells, 400)

    player:SetCloakable(true)
    player:SetDisguisable(true)

    -- add to table and reset touched to 0
    playerDamageTable[player:GetId()] = {
        points = 0,
        nail = 0,
        ac = 0,
        increase = false
    }

end

function player_killed(player, damageinfo)
    local player = CastToPlayer(player)

    -- if no damageinfo do nothing
    if not damageinfo then
        return
    end

    -- Entity that is attacking
    local attacker = damageinfo:GetAttacker()

    -- If no attacker do nothing
    if not attacker then
        return
    end

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
    if not player_attacker then
        return
    end

    if player:GetTeamId() ~= attacker:GetTeamId() then
        local team = GetTeam(player:GetTeamId())
        team:AddScore(0 - POINTS_X_KILL)
        playerDamageTable[player:GetId()].points = playerDamageTable[player:GetId()].points + POINTS_X_KILL
    end
    -- If player is an attacker, then do stuff
    -- show scored points
    BroadCastMessageToPlayer( player, "You dealt "..playerDamageTable[player:GetId()].points.." damage that run" )
    AddScheduleRepeatingNotInfinitely( "timer_return_schedule", .5, BroadCastMessageToPlayer, 4, player, "You dealt "..playerDamageTable[player:GetId()].points.." damage that run")

end

function player_ondamage(player, damageinfo)
    local player = CastToPlayer(player)

    -- Entity that is attacking
    local attacker = damageinfo:GetAttacker()

    -- if no damageinfo do nothing
    if not damageinfo then
        return
    end

    -- Get Damage Force
    local damage = damageinfo:GetDamage()

    -- If no attacker do nothing
    if not attacker then
        return
    end

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
    if not player_attacker then
        return
    end

    if playerDamageTable[player:GetId()].increase == true then
        damageinfo:ScaleDamage(0.25)
    end
    if playerDamageTable[attacker:GetId()].increase then
        damageinfo:ScaleDamage(2)
    end

    -- ChatToAll("Damage: "..damageinfo:GetDamage())
end

-----------------------------------------------------------------------------
-- Damage triggers
-----------------------------------------------------------------------------

-- only blue team!
function blue_target:ondamage(damageinfo)
    local attacker = CastToPlayer(damageinfo:GetAttacker())
    local temp = tostring(damageinfo:GetInflictor())
    local attackerWeapon = "look at this dude"
    if(temp:find("^ff_projectile_nail") ~= nil) then
        attackerWeapon = "ff_projectile_nail"
    elseif(temp:find("^ff_weapon_assaultcannon") ~= nil) then
        attackerWeapon = "ff_weapon_assaultcannon"
    end
    local damage = damageinfo:GetDamage()
    if IsPlayer(attacker) then
        if attacker:GetTeamId() == blueteam then
            local scaled_damage = damage / DAMAGE_POINTS_SCALE
            local damage_points = damage
            local team = GetTeam(redteam)
            local playerid = attacker:GetId()

            OutputEvent("blue_target", "Color", "255 0 0")
            OutputEvent("blue_target", "Color", "255 255 255", 0.10)

            if attackerWeapon == "ff_projectile_nail" then
                playerDamageTable[playerid].nail = playerDamageTable[playerid].nail + 1
                if playerDamageTable[playerid].nail >= POINT_EVERY_X_HITS_NAIL then
                    scaled_damage = math.floor(scaled_damage + .5) * POINT_EVERY_X_HITS_NAIL
                    damage_points = damage_points * POINT_EVERY_X_HITS_NAIL
                    playerDamageTable[playerid].nail = 0

                end
            elseif attackerWeapon == "ff_weapon_assaultcannon" then
                playerDamageTable[playerid].ac = playerDamageTable[playerid].ac + 1
                if playerDamageTable[playerid].ac >= POINT_EVERY_X_HITS_ASSAULTCANNON then
                    scaled_damage = math.floor(scaled_damage + .5) * POINT_EVERY_X_HITS_ASSAULTCANNON
                    damage_points = damage_points * POINT_EVERY_X_HITS_ASSAULTCANNON
                    playerDamageTable[playerid].ac = 0
                end
            else
                -- round to the nearest whole number
                scaled_damage = math.floor(scaled_damage) + .5)
            end

            if scaled_damage > 0 then
                team:AddScore(0 - scaled_damage)
                BLUETEAM_BASE_POINTS = BLUETEAM_BASE_POINTS - scaled_damage
                attacker:AddFortPoints(damage_points, "Damaging Red Bunker")
                target_status = true
                playerDamageTable[playerid].points = playerDamageTable[playerid].points + scaled_damage
            end
        end

        if BLUETEAM_BASE_POINTS <= 0 then
            freeze_all()
            sound_script()
            AddSchedule("blue_wins", 3, intermission)
            SpeakAll("WIN_BLUE")
            BroadCastMessage("Blue Team Wins!!", 10, Color.kBlue)
        end
    end
end
-- only red team!
function red_target:ondamage(damageinfo)
    local attacker = CastToPlayer(damageinfo:GetAttacker())
    local temp = tostring(damageinfo:GetInflictor())
    local attackerWeapon = "look at this dude"
    if(temp:find("^ff_projectile_nail") ~= nil) then
        attackerWeapon = "ff_projectile_nail"
    elseif(temp:find("^ff_weapon_assaultcannon") ~= nil) then
        attackerWeapon = "ff_weapon_assaultcannon"
    end
    local damage = damageinfo:GetDamage()
    if IsPlayer(attacker) then
        if attacker:GetTeamId() == redteam then
            local scaled_damage = damage / DAMAGE_POINTS_SCALE
            local damage_points = damage
            local team = GetTeam(blueteam)
            local redplayerid = attacker:GetId()
            zerored_points = zerored_points + REDTEAM_BASE_POINTS

            OutputEvent("red_target", "Color", "255 0 0")
            OutputEvent("red_target", "Color", "255 255 255", 0.10)

            if attackerWeapon == "ff_projectile_nail" then
                playerDamageTable[playerid].nail = playerDamageTable[playerid].nail + 1
                if playerDamageTable[playerid].nail >= POINT_EVERY_X_HITS_NAIL then
                    scaled_damage = math.floor(scaled_damage + .5) * POINT_EVERY_X_HITS_NAIL
                    damage_points = damage_points * POINT_EVERY_X_HITS_NAIL
                    playerDamageTable[playerid].nail = 0

                end
            elseif attackerWeapon == "ff_weapon_assaultcannon" then
                playerDamageTable[playerid].ac = playerDamageTable[playerid].ac + 1
                if playerDamageTable[playerid].ac >= POINT_EVERY_X_HITS_ASSAULTCANNON then
                    scaled_damage = math.floor(scaled_damage + .5) * POINT_EVERY_X_HITS_ASSAULTCANNON
                    damage_points = damage_points * POINT_EVERY_X_HITS_ASSAULTCANNON
                    playerDamageTable[playerid].ac = 0
                end
            else
                -- round to the nearest whole number
                scaled_damage = math.floor(scaled_damage) + .5)
            end

            if scaled_damage > 0 then
                team:AddScore(0 - scaled_damage)
                REDTEAM_BASE_POINTS = REDTEAM_BASE_POINTS - scaled_damage
                attacker:AddFortPoints(damage_points, "Damaging Blue Bunker")
                target_status = true
                playerDamageTable[redplayerid].points = playerDamageTable[redplayerid].points + scaled_damage

            end
        end

        if REDTEAM_BASE_POINTS <= 0 then
            freeze_all()
            sound_script()
            AddSchedule("red_wins", 3, intermission)
            SpeakAll("WIN_RED")
            BroadCastMessage("Red Team Wins!!", 10, Color.kRed)
        end
    end

end


function sound_script()
	AddScheduleRepeatingNotInfinitely( "BOOM", 0.3, play_sound, 1, 1)
	AddScheduleRepeatingNotInfinitely( "BOOM2", 0.5, play_sound, 1, 1)
	AddScheduleRepeatingNotInfinitely( "BOOM3", 0.7, play_sound, 1, 2)
end

function play_sound(sound)
	if sound == 1 then 
		BroadCastSound ( "ff_anticitizen.explode_4" )
	elseif sound == 2 then
		BroadCastSound ( "ff_anticitizen.explode_3" )
	end
end


function intermission()
    GoToIntermission()
end

function freeze_all()
    BroadCastSound("misc.bloop")

    local c = Collection()
    c:GetByFilter({CF.kPlayers})

    for temp in c.items do
        local player = CastToPlayer(temp)

        player:Freeze(true)
    end
end

-----------------------------------------------------------
-- Bunker door
-----------------------------------------------------------
base_tele_trigger = info_ff_script:new({
    team = Team.kUnassigned
})

function base_tele_trigger:allowed(trigger_entity)
    if IsPlayer(trigger_entity) then
        local player = CastToPlayer(trigger_entity)

        -- do any checks here
        if player:GetTeamId() == self.team then
            return EVENT_ALLOWED
        end
    end
    return EVENT_DISALLOWED
end

red_tele_trigger = base_tele_trigger:new({
    team = Team.kRed
})
blue_tele_trigger = base_tele_trigger:new({
    team = Team.kBlue
})

------------------------------------------------------------
-- pylon restock
------------------------------------------------------------

restock = trigger_ff_script:new({
    team = Team.kUnassigned
})

function restock:allowed(touch_entity)
    if IsPlayer(touch_entity) then
        local player = CastToPlayer(touch_entity)
        return player:GetTeamId() == self.team
    end

    return EVENT_DISALLOWED
end

function restock:ontrigger(trigger_entity)
    if IsPlayer(trigger_entity) then
        local player = CastToPlayer(trigger_entity)

        player:AddHealth(5)
        player:AddArmor(5)

        player:AddAmmo(Ammo.kNails, 5)
        player:AddAmmo(Ammo.kShells, 5)
        player:AddAmmo(Ammo.kRockets, 5)
        player:AddAmmo(Ammo.kCells, 5)

    end
end

red_health = restock:new({
    team = Team.kRed
})
blue_health = restock:new({
    team = Team.kBlue
})

-------------------------------------------------------
-- Extra Bunker Damage
-------------------------------------------------------

forthdam = info_ff_script:new({
    team = Team.kUnassigned
})

function forthdam:ontrigger(trigger_entity)
    local player = CastToPlayer(trigger_entity)
    local team = player:GetTeamId()

    if team == 2 then
        player:SetLocation(entity:GetId(), "Blue Bunker", Team.kBlue)
    end
    if team == 3 then
        player:SetLocation(entity:GetId(), "Red Bunker", Team.kRed)
    end

    player:AddAmmo(Ammo.kNails, 5)
    player:AddAmmo(Ammo.kShells, 5)
    player:AddAmmo(Ammo.kRockets, 5)
    player:AddAmmo(Ammo.kCells, 5)

    AddHudIcon(player, "HUD_Offense.vtf", "Attack", 5, 370, 25, 25, 1)
    AddHudIcon(player, "HUD_Defense.vtf", "Armor", 40, 370, 25, 25, 1)
    playerDamageTable[player:GetId()].increase = true
end

red_14 = forthdam:new({
    team = Team.kRed
})
blue_14 = forthdam:new({
    team = Team.kBlue
})

-- Normal damage
normaldam = info_ff_script:new({
    team = Team.kUnassigned
})

function normaldam:ontrigger(trigger_entity)
    if IsPlayer(trigger_entity) then
        local player = CastToPlayer(trigger_entity)
        player:SetLocation(entity:GetId(), "War Zone", Team.kUnassigned)

        RemoveHudItem(player, "Attack")
        RemoveHudItem(player, "Armor")
        playerDamageTable[player:GetId()].increase = false
    end
end

red_0 = normaldam:new({
    team = Team.kRed
})
blue_0 = normaldam:new({
    team = Team.kBlue
})