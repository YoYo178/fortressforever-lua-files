
-- ff_island_dm.lua


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kRed, "Red Islanders" )
	SetTeamName( Team.kBlue, "Blue Survivors" )
end

function precache()
	PrecacheSound( "Backpack.Touch" )
end



-- Everyone to spawns with everything
function player_spawn( player_entity )
	-- 400 for overkill. of course the values
	-- get clamped in game code
	--local player = GetPlayer(player_id)
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

function player_onkill( player )
	-- Test, Don't let blue team suicide.
--  	if player:GetTeamId() == Team.kBlue then
--  		return false
--  	end
	return true
end

-- Get team points for killing a player
function player_killed( player_entity, damageinfo )
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		
		local player = CastToPlayer( player_entity )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			--local victim = GetPlayer(player_id)
			
			if not (player:GetTeamId() == killer:GetTeamId()) then
				local killersTeam = killer:GetTeam()	
				killersTeam:AddScore(1)
			end
		end	
	end
end

-- Just here because
function player_ondamage( player_entity, damageinfo )
end

---------------------------------
-- Allstuffs
---------------------------------

fullpack = genericbackpack:new({
	grenades = 50,
	bullets = 0,
	nails = 0,
	shells = 100,
	rockets = 50,
	gren1 = 4,
	gren2 = 4,
	cells = 0,
	armor = 300,
	health = 100,
    respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fullpack :dropatspawn() return false end

red_fullpack = fullpack:new({ touchflags = {AllowFlags.kRed} })
blue_fullpack = fullpack:new({ touchflags = {AllowFlags.kBlue} })



---------------------------------
-- Locations
---------------------------------
location_island = location_info:new({ text = "Deserted island", team = NO_TEAM })
