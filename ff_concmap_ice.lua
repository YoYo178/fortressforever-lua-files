IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("base_conc")

function startup()

	SetTeamName( Team.kBlue, "icesterzzz" )	

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
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

reload = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function reload:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

------------------------------------------------------------------
-- BAGS
------------------------------------------------------------------

swampbag = genericbackpack:new({
	health = 200,
	armor = 150,
	grenades = 60,
	bullets = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	gren1 = 4,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function swampbag:dropatspawn() return false end