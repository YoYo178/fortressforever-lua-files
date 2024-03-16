-----------------------------------------------------------------------------
-- Conc_project_b1 by mentaL - Moone - TheMedic - zE
-----------------------------------------------------------------------------

IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("base_push");
IncludeScript("power_quad");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )


-----------------------------------------------------------------------------
-- Teams
-----------------------------------------------------------------------------

function startup()

AddScheduleRepeating( "restock", 1, restock_all )

SetTeamName( Team.kBlue, "Conc" )
SetTeamName( Team.kRed, "Quad" )
SetTeamName( Team.kGreen, "Easy Quad" )

SetPlayerLimit( Team.kBlue, 0 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, -1 )
SetPlayerLimit( Team.kGreen, 0 )

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
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
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
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, -1 )

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

--------------------
--Locations
--------------------

location_stagemedic1 = location_info:new({ text = "TheMedic Stage #1", team = Team.kUnassigned })
location_stagemedic2 = location_info:new({ text = "TheMedic Stage #2", team = Team.kUnassigned })
location_stagemedic3 = location_info:new({ text = "TheMedic Stage #3", team = Team.kUnassigned })
location_stagemoone1 = location_info:new({ text = "Moone Stage #1", team = Team.kUnassigned })
location_stagemoone2 = location_info:new({ text = "Moone Stage #2", team = Team.kUnassigned })
location_stagemoone3 = location_info:new({ text = "Moone Stage #3", team = Team.kUnassigned })
location_stageze1 = location_info:new({ text = "zE Stage #1", team = Team.kUnassigned })
location_stageze2 = location_info:new({ text = "zE Stage #2", team = Team.kUnassigned })
location_stageze3 = location_info:new({ text = "zE Stage #3", team = Team.kUnassigned })
location_stagemental1 = location_info:new({ text = "mentaL Stage #1", team = Team.kUnassigned })
location_stagemental2 = location_info:new({ text = "mentaL Stage #2", team = Team.kUnassigned })
location_stagemental3 = location_info:new({ text = "mental Stage #3", team = Team.kUnassigned })

-----------------------------------------------------------------------------
-- Disable conc effect
-----------------------------------------------------------------------------

CONC_EFFECT = 0

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end


----------------------------------------------------------------------
-- Quad and Ez Quad from concmap_exist
----------------------------------------------------------------------

function player_ondamage( player, damageinfo )
    if player:GetTeamId() ~= Team.kRed and player:GetTeamId() ~= Team.kGreen  then return end
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	damageinfo:SetDamage( 0 )
	if player:GetTeamId() ~= Team.kGreen  then return end
		ApplyToPlayer(player, { AT.kReloadClips })
    end
end


------------------------------------------------------------------------------- Auto health
-----------------------------------------------------------------------------
		
function GiveHealth(player_entity)
    if IsPlayer(player_entity) then
            local player = CastToPlayer(player_entity)
            player:AddHealth(400)
            player:AddArmor(400)
    end
end

------------------------------------------------------------------------
-- Auto-restock code (without triggers) - from conc_speed2
------------------------------------------------------------------------
-- Instructions:
--   Put AddScheduleRepeating( "restock", 1, restock_all ) in
--   your Lua's startup() function
------------------------------------------------------------------------

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
				player:AddAmmo(Ammo.kGren2, 3)
				player:AddAmmo( Ammo.kShells, 50 )
				player:AddAmmo( Ammo.kNails, 50 )
			end
		end
	end
end