-- ff_redgiant.lua
-- Map by GambiT **robbheb82@cox.net**
-- Fortress Forever FTW!!!

-----------------------------------------------------------------------------
-- Gameplay info
-----------------------------------------------------------------------------
-- Capture the enemy flag!!
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_teamplay");
IncludeScript("base");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
-----------------------------------------------------------------------------

function startup()
	-- only red and blue teams
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )
        
        local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

-- Give everyone a full resupply including grenades
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )

	player:AddAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

-----------------------------------------------------------------------------
-- bag containing fullgrens, comes back every 1 seconds
-----------------------------------------------------------------------------
fullgrenbag = genericbackpack:new({
	gren1 = 4,
	gren2 = 4,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})
-----------------------------------------------------------------------------
-- bag containing fullammo, but no grenades
-----------------------------------------------------------------------------
fullammobag = genericbackpack:new({
        grenades = 400,  -- this is pipe launcher grenades, not frags
	bullets = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	respawntime = 5,
        model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function fullgrenbag:dropatspawn() return false end
function fullammobag:dropatspawn() return false end

-----------------------------------------------------------------------------
-- bag containing fullammo, but no grenades or health
-----------------------------------------------------------------------------
fullammobagmid = genericbackpack:new({
        grenades = 400,  -- this is pipe launcher grenades, not frags
	bullets = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	respawntime = 5,
        model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function fullgrenbag:dropatspawn() return false end
function fullammobag:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Health Kit (backpack-based)
-----------------------------------------------------------------------------
rghealthkit = genericbackpack:new({
	health = 50,
        respawntime = 10,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

-----------------------------------------------------------------------------
-- Ammo Kit (backpack-based)
-----------------------------------------------------------------------------
rgammobackpack = genericbackpack:new({
	health = 50,
        armor = 50,
        grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
        respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function rgammobackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Armor Kit (backpack-based)
-----------------------------------------------------------------------------
rgarmorkit = genericbackpack:new({
	armor = 200,
	cells = 150,
        respawntime = 10,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	botgoaltype = Bot.kBackPack_Armor
})

function armorkit:dropatspawn() return true end

-----------------------------------------------------------------------------
-- backpack entity setup
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
                   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   fullgrenbag:new({touchflags = tf}),
		   fullammobag:new({touchflags = tf}),
                   rgammobackpack:new({touchflags = tf}),
                   rghealthkit:new({touchflags = tf}),
                   rgarmorkit:new({touchflags = tf})
end

-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------

blue_door1_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door1_left", "Open") 
      OutputEvent("blue_door1_right", "Open") 
   end 
end 

blue_door2_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door2_left", "Open") 
      OutputEvent("blue_door2_right", "Open") 
   end 
end

red_door1_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door1_left", "Open") 
      OutputEvent("red_door1_right", "Open") 
   end 
end 

red_door2_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door2_left", "Open") 
      OutputEvent("red_door2_right", "Open") 
   end 
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_fullgrenbag, blue_fullammobag, blue_rgammobackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_fullgrenbag, red_fullammobag, red_rgammobackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
