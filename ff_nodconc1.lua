--ff_nod_juggle.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");

-------------------------------------------------------------------------------
-- Comment out bits after here if you don't want them in your shitty map...
-- Credits go to Caesium, Circuitous, and Nodnarb (mechanical rabbit).
-------------------------------------------------------------------------------

function startup()
	-- Only allow blue team
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	-- Rename blue team
	SetTeamName( Team.kBlue, "Conc Jumpers" )

	-- Only allow scouts and medics on the blue team
	local team = GetTeam( Team.kBlue )
        -- Makes it to where Blue & Red act as one team (a.k.a. allies)
        team:SetAllies( Team.kRed )
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

	-- Give everyone everything once a second
	AddScheduleRepeating("addstuff", 1, addstuff)
end

-- Jump 1 Location
location_jump1 = location_info:new({ text = "Jump 1", team = NO_TEAM })

-- Jump 2 Location
location_jump2 = location_info:new({ text = "Jump 2", team = NO_TEAM })

-- Jump 3 Location
location_jump3 = location_info:new({ text = "Jump 3", team = NO_TEAM })

-- Jump 4 Location
location_jump4 = location_info:new({ text = "Jump 4", team = NO_TEAM })

-- Jump 5 Location
location_jump5 = location_info:new({ text = "Jump 5", team = NO_TEAM })

-- Jump 6 Location
location_jump6 = location_info:new({ text = "Jump 6", team = NO_TEAM })

-- Jump 7 Location
location_jump7 = location_info:new({ text = "Jump 7", team = NO_TEAM })

-- Jump 8 Location
location_jump8 = location_info:new({ text = "Jump 8", team = NO_TEAM })


-- Disable conc effect
function player_onconc( player_entity, concer_entity )
	return EVENT_DISALLOWED
end

-- Disable tranq effect
function player_ontranq( player_entity, tranqer_entity )
	return EVENT_DISALLOWED
end

-- Disable damage
function player_ondamage( player, damageinfo )
	damageinfo:SetDamage(0);
end

-- Give everyone everything
function addstuff()
	local c = Collection()	
	c:GetByFilter({CF.kPlayers})
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player:IsAlive() then
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
	end
end