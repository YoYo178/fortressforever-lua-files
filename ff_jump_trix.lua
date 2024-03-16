IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- set class limits
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("Fly!")

	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, 0)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, 0)
end 

-----------------------------------------------------------------------------
-- Player spawn: give full health, armor, and ammo
-----------------------------------------------------------------------------
function player_spawn( player_entity ) 
	local player = CastToPlayer( player_entity ) 

	player:AddHealth( 400 ) 
	player:AddArmor( 400 ) 

	player:AddAmmo( Ammo.kNails, 400 ) 
	player:AddAmmo( Ammo.kShells, 400 ) 
	player:AddAmmo( Ammo.kRockets, 400 ) 
	player:AddAmmo( Ammo.kCells, 400 ) 
end

-----------------------------------------------------------------------------
-- Spawn functions
-----------------------------------------------------------------------------
redspawn = { validspawn = redallowedmethod }
bluespawn = { validspawn = blueallowedmethod }
greenspawn = { validspawn = greenallowedmethod }
yellowspawn = { validspawn = yellowallowedmethod }

resupply_settings = {
	resupply_interval = 1, -- in seconds
	reload_clips = true,
	health = 0,
	armor = 0,
	grenades = 0, -- blue/green pipes
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	mancannons = 0,
	gren1 = 3,
	gren2 = 3
}

-- utility function to return a list of all players in the server
function resupply_getallplayers()
	local players = {}
	for index=1,22 do
		local player = GetPlayerByID(index)
		if (player ~= nil) then
			table.insert( players, player );
		end
	end
	return players
end

-- so we don't overwrite startup
local resupply_savedfuncs = {}
resupply_savedfuncs.startup = startup

function startup()
	-- check to make sure the saved function is actually a function
	if type(resupply_savedfuncs.startup) == "function" then
		-- call the saved function
		resupply_savedfuncs.startup()
	end
	
	-- start resupply schedule
	AddScheduleRepeating( "resupply_schedule", resupply_settings.resupply_interval, resupply_scheduled );
end

function resupply_scheduled()
	local players = resupply_getallplayers();
	for i,player in pairs(players) do
		resupply( player )
	end
end

function resupply( player )
	if IsPlayer( player ) then
		-- reload clips
		if resupply_settings.reload_clips == true then player:ReloadClips() end
	
		-- give player health and armor
		if resupply_settings.health ~= nil then player:AddHealth( resupply_settings.health ) end
		if resupply_settings.armor ~= nil then player:AddArmor( resupply_settings.armor ) end
	
		-- give player ammo
		if resupply_settings.nails ~= nil then player:AddAmmo(Ammo.kNails, resupply_settings.nails) end
		if resupply_settings.shells ~= nil then player:AddAmmo(Ammo.kShells, resupply_settings.shells) end
		if resupply_settings.rockets ~= nil then player:AddAmmo(Ammo.kRockets, resupply_settings.rockets) end
		if resupply_settings.cells ~= nil then player:AddAmmo(Ammo.kCells, resupply_settings.cells) end
		if resupply_settings.detpacks ~= nil then player:AddAmmo(Ammo.kDetpack, resupply_settings.detpacks) end
		if resupply_settings.mancannons ~= nil then player:AddAmmo(Ammo.kManCannon, resupply_settings.mancannons) end
		if resupply_settings.gren1 ~= nil then player:AddAmmo(Ammo.kGren1, resupply_settings.gren1) end
		if resupply_settings.gren2 ~= nil then player:AddAmmo(Ammo.kGren2, resupply_settings.gren2) end
	end
end

-- so we don't overwrite the function
local nodamage_savedfuncs = {}
nodamage_savedfuncs.player_ondamage = player_ondamage

function player_ondamage( player, damageinfo )

	-- check to make sure the saved function is actually a function
	if type(nodamage_savedfuncs.player_ondamage) == "function" then
		-- call the saved function
		nodamage_savedfuncs.player_ondamage( player, damageinfo )
	end

	-- if no damageinfo do nothing
	if not damageinfo then return end
	
	-- set damage to zero
	damageinfo:SetDamage(0)
	
end