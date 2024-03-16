-- ff_wcrats_b3.lua stolen from turkeyburgers.lua by Fat-Suzy

-- turkeyburgers.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
-- IncludeScript("base_soldierarena");
IncludeScript("base_teamplay");

function startup()
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )

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
	player:AddAmmo( Ammo.kManCannon, 1 )
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
	
	player:SetGravity( 0.5 )
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

-- dmg
function player_ondamage( player_entity, damageinfo )
end

-----------------------------------------------------------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------------------------------------------------------
ff_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 1,
	gren2 = 1,
	
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_waterpack:dropatspawn() return false end
blue_2fort_waterpack = ff_2fort_waterpack:new({})
red_2fort_waterpack = ff_2fort_waterpack:new({})

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------

