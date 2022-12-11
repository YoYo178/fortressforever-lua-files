-- List of Weapons that will be given to players in order.
local weapon_list = {
    'ff_weapon_rpg',
    'ff_weapon_crowbar',
    'ff_weapon_shotgun',
}

local player_table = {}
local functionList = {
    startup = startup,
    player_spawn = player_spawn,
    player_onchat = player_onchat,
    player_killed = player_killed
}

-- Game Callbacks

function startup()
    if type(functionList.startup) == "function" then
        functionList.startup()
    end
end

function player_connected(player)
    local player = CastToPlayer(player)
    
    player_table[player:GetSteamID()] = {
        current_weapon = 1
    }
end

function player_spawn(player)
    if type(functionList.player_spawn) == "function" then
        functionList.player_spawn(player)
    end

    local player = CastToPlayer(player)
   
    RestockFull(player)
    player:GiveWeapon(GetCurrentWeapon(player), true)
end

function player_killed(player, damageinfo)
    if type(functionList.player_killed) == "function" then
        functionList.player_killed(player, damageinfo)
    end

    local player = CastToPlayer(player)
    if not damageinfo then return end
    local attacker = CastToPlayer(damageinfo:GetAttacker())
    if not IsPlayer(attacker) then return end

    if not (player:GetTeamId() == attacker:GetTeamId()) then
        GiveNextWeapon(attacker)
    end
end

-- Do stuff when a player chats.
function player_onchat(player, chatstring)	
    local player = CastToPlayer(player)
    local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
    
    if message == "!next" then
        GiveNextWeapon(player)
        return false
    end
    
    if message == "!reset" then
        ResetAllLevels()
        return false
    end

    return true -- All other chat should be allowed.
end

-- Utility functions

-- Give the next weapon if the player doesn't win.
function GiveNextWeapon(player)
    player_table[player:GetSteamID()].current_weapon = player_table[player:GetSteamID()].current_weapon + 1
    
    if not CheckForWin(player) then
        RestockFull(player)
        player:GiveWeapon(GetCurrentWeapon(player), true)
    end
end

-- Resupply a player with full of everything
function RestockFull(player)
    player:RemoveAllWeapons()
    player:RemoveAllAmmo(true)
    player:AddAmmo( Ammo.kNails, 400 )
    player:AddAmmo( Ammo.kShells, 400 )
    player:AddAmmo( Ammo.kRockets, 400 )
    player:AddAmmo( Ammo.kCells, 400 )
end

-- get the current weapon a player has
function GetCurrentWeapon(player)
    return weapon_list[player_table[player:GetSteamID()].current_weapon]
end

-- If a player wins then end the game.
function CheckForWin(player)
    if player_table[player:GetSteamID()].current_weapon > table.getn(weapon_list) then
        ChatToAll(player:GetName().." Wins!")
        ResetAllLevels()
        RespawnAllPlayers()
        return true
    end	
end

 -- Reset all gun levels.
function ResetAllLevels()
    for k in pairs(player_table) do
        player_table[k].current_weapon = 1
    end

    return true
end

-- Respawn all players
function RespawnAllPlayers()
    ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end