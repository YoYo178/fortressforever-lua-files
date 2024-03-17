IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("base_conc")

function startup()

	SetTeamName( Team.kBlue, "Conc and Quad" )	

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

--
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

------------------------------------------------------------------
-- RESUPPLY ZONE
------------------------------------------------------------------

function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	
	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

resuppz = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resuppz:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

-----------------------------------------------------------------------------
-- Quad
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )
	if player:GetClass() ~= Player.kSoldier then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 1.7, damageforce.y * 1.7, damageforce.z * 1.7))
	    damageinfo:SetDamage( 0 )
	end
	if player:GetClass() ~= Player.kDemoman then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 1.7, damageforce.y * 1.7, damageforce.z * 1.7))
	    damageinfo:SetDamage( 0 )
	end
	if player:GetClass() ~= Player.kPyro then
	    local damageforce = damageinfo:GetDamageForce()
	    damageinfo:SetDamageForce(Vector( damageforce.x * 1.7, damageforce.y * 1.7, damageforce.z * 1.7))
	    damageinfo:SetDamage( 0 )
	end
end
