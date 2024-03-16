--== surf_assassin ==----== PartialSchism ==--
-------------
--Includes---
-------------


IncludeScript("base_teamplay");
IncludeScript("base_surf");



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
	
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )


        -- RED TEAM
	local team = GetTeam( Team.kRed )
	
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kScout, -1 )

end


--------------
--Spawn-------
--------------

function player_spawn( player_entity ) 
   local player = CastToPlayer( player_entity ) 

   player:AddHealth( 400 ) 
   player:AddArmor( 400 ) 
   player:AddAmmo( Ammo.kNails, 300 )
   player:AddAmmo( Ammo.kShells, 300 )
   player:RemoveAmmo( Ammo.kGren1, 4 )
   player:RemoveAmmo( Ammo.kGren2, 4 )
                

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
	cells = 0,
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
	cells = 0,
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

function player_ondamage( player, damageinfo )
  if damageinfo:GetDamageType() == 32 then
     damageinfo:SetDamage( 0 )
	        

  end 

end