--== surf_assassin_r ==----== PartialSchism ==--
-------------
--Includes---
-------------


IncludeScript("base_teamplay");
IncludeScript("base_surf");

CIV_SPEED = 2.0



--------------
--Startup-----
--------------

function startup()

	SetTeamName( Team.kBlue, "Blue Surfers" )
        SetTeamName( Team.kRed, "Red Surfers" )
	

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	
	
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, 1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kEngineer, 1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )


        -- RED TEAM
	local team = GetTeam( Team.kRed )
	
	
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, 1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kEngineer, 1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kScout, 0 )

end


--------------
--Spawn-------
--------------

-- Give everyone a full resupply, but strip grenades
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

	
	player:RemoveAmmo( Ammo.kDetpack, 1 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- Civs run fast
	if player:GetClass() ~= Player.kCivilian then
		player:RemoveEffect( EF.kSpeedlua1 )
	else
		player:AddEffect( EF.kSpeedlua1, -1, 0, CIV_SPEED )

	end

end

------------------
--Packs-----------
------------------

ammo_bag1 = genericbackpack:new({
	health = 40,
	armor = 40,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
        mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammo_bag1:dropatspawn() return false end



ammo_bag2 = genericbackpack:new({
	health = 400,
	armor = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
        mancannons = 0,
	gren1 = 2,
	gren2 = 2,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammo_bag2:dropatspawn() return false end


------------------
--No Fall Damage--
------------------

--function player_ondamage( player, damageinfo )
--  if damageinfo:GetDamageType() == 32 then
--     damageinfo:SetDamage( 0 )
--	        
--
--  end 
--
--end


function player_ondamage( player, damageinfo )
	
	local attacker = damageinfo:GetAttacker()

	if damageinfo:GetDamageType() == 32 then
              damageinfo:SetDamage( 0 )
	        

        end 

	-- Civs have "UNAGI POWER, UNAGI!"
	
	if IsPlayer( attacker ) then
		attacker = CastToPlayer( attacker )
		if attacker:GetClass() == Player.kCivilian and attacker:GetTeamId() ~= player:GetTeamId() then
			
			damageinfo:ScaleDamage(69)
		
		end
	end


end
