IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-- Q: wow clover, there sure are alot of them!
-- A: hell yes there are.
-----------------------------------------------------------------------------------------------------------------------------IncludeScript("base_location")
location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_bluespawn = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_bluesniperhall = location_info:new({ text = "Sniper hallway", team = Team.kBlue })
location_redsniperhall = location_info:new({ text = "Sniper hallway", team = Team.kRed })
location_blueoutside = location_info:new({ text = "OutSide", team = Team.kBlue })
location_redoutside = location_info:new({ text = "OutSide", team = Team.kRed })
location_bluebaselowerlevel = location_info:new({ text = "Blue Base", team = Team.kBlue })
location_redbaselowerlevel = location_info:new({ text = "Red Base", team = Team.kRed })
location_blueupperlevel = location_info:new({ text = "Blue Upper Level", team = Team.kBlue })
location_redupperlevel = location_info:new({ text = "Red Upper Level", team = Team.kRed })
location_blueflagroom = location_info:new({ text = "Blue Flagroom", team = Team.kBlue })
location_redflagroom = location_info:new({ text = "Red Flagroom", team = Team.kRed })
location_discoroom = location_info:new({ text = "DISCO ROOM!", team = Team.kRed })
location_outsideredsnipertower = location_info:new({ text = "Sniper tower", team = Team.kRed })
location_outsidebluesnipertower = location_info:new({ text = "Sniper tower", team = Team.kBlue })
location_redbunker = location_info:new({ text = "Bunker", team = Team.kRed })
location_bluebunker = location_info:new({ text = "Bunker", team = Team.kBlue })
location_pornoroom = location_info:new({ text = "Porno Room", team = Team.kBlue })
-----------------------------------------------------------------------------------------------------------------------------
-- GENERICPACK
-- used in the spawns
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_genericpack = genericbackpack:new({
	health = 100,
	armor = 100,
	
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 80,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_genericpack:dropatspawn() return false end
blue_2fort_genericpack = ff_2fort_genericpack:new({ team = Team.kBlue })
red_2fort_genericpack = ff_2fort_genericpack:new({ team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- GRENPACK
-- fully restocks health/armor/ammo
-- gives 2 gren of each type
-- slower respawn time
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_grenpack = genericbackpack:new({
	health = 400,
	armor = 400,
	
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 2,
	gren2 = 2,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_grenpack:dropatspawn() return false end
blue_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })


-----------------------------------------------------------------------------------------------------------------------------
-- BAG AT WATER
-- open to both teams
-- gives some cells and health
-- long respawn time
-- offensive engys might have fun with this one
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_waterpack = genericbackpack:new({
	health = 30,
	armor = 30,
	
	nails = 20,
	shells = 20,
	rockets = 20,
	cells = 80,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_waterpack:dropatspawn() return false end
blue_2fort_waterpack = ff_2fort_waterpack:new({})
red_2fort_waterpack = ff_2fort_waterpack:new({})

-----------------------------------------------------------------------------------------------------------------------------
-- BAG IN SPIRAL
-- open to both teams
-- identical to water bag
-- included to increase customization for server admins
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_spiralpack = genericbackpack:new({
	health = 30,
	armor = 30,
	
	nails = 20,
	shells = 20,
	rockets = 20,
	cells = 80,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 45,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_spiralpack:dropatspawn() return false end
blue_2fort_spiralpack = ff_2fort_spiralpack:new({})
red_2fort_spiralpack = ff_2fort_spiralpack:new({})
-----------------------------------------------------------------------------------------------------------------------
 aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch( touch_entity )
if IsPlayer( touch_entity ) then
local player = CastToPlayer( touch_entity )
if player:GetTeamId() == self.team then
player:AddHealth( 400 )
player:AddArmor( 400 )
player:AddAmmo( Ammo.kNails, 400 )
player:AddAmmo( Ammo.kShells, 400 )
player:AddAmmo( Ammo.kRockets, 400 )
player:AddAmmo( Ammo.kCells, 400 )
                        player:AddAmmo( Ammo.kGren1, 400 )
                        player:AddAmmo( Ammo.kGren2, 400 )
end
end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })