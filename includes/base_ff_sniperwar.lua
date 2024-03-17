
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- Snipers Only
-----------------------------------------------------------------------------

function startup()

	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 32 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 32 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

-- Give everyone a full resupply, but strip grenades
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	
end

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------
sniper_resupply = genericbackpack:new({ 
	health = 100,
	armor = 50,
	bullets = 75,
	shells = 100,
	nails = 200,
	touchsound = "ArmorKit.Touch",
	respawntime = .5,
	model = "",
	botgoaltype = Bot.kBackPack_Health
})

function sniper_resupply:dropatspawn() return false end

sniper_resupply_partial = genericbackpack:new({ 
	health = 20,
	armor = 15,
	bullets = 15,
	shells = 20,
	nails = 20,
	touchsound = "ArmorKit.Touch",
	respawntime = .5,
	model = "",
	botgoaltype = Bot.kBackPack_Health
})

function sniper_resupply_partial:dropatspawn() return false end