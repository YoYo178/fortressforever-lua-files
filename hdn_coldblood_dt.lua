 IncludeScript("base_teamplay");

function startup()
	-- Names
	SetTeamName( Team.kRed, "Red" )
	SetTeamName( Team.kBlue, "Blue" )
	SetTeamName( Team.kGreen, "Green" )
	SetTeamName( Team.kYellow, "Yellow" )
	 
	-- Team limits
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )

	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, 0 )
 
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, 0 )

	local team = GetTeam( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, 0 )
 
	local team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, 0 )


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
	player:RemoveAmmo( Ammo.kGren1, 3 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
end


-- Just here because
function player_ondamage( player_entity, damageinfo )
end

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

---------------------
--Backpacks
---------------------
genpack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 60,
	mancannons = 1,
	gren1 = 1,
	gren2 = 0,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack:dropatspawn() return false 
end

genpack_grenpack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	cells = 120,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function genpack_grenpack:dropatspawn() return false 
end

