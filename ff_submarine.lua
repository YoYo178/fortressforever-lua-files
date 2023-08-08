-- ff_submarine.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
-----------------------------------------------------------------------------
-- Spawn Supplies
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 0 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kBullets, 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 0 )
	player:AddAmmo( Ammo.kGren1, 0 )
	player:AddAmmo( Ammo.kGren2, 0 )
end
-----------------------------------------------------------------------------
-- Bags
-----------------------------------------------------------------------------

customhealthkit = genericbackpack:new({
	health = 33,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch"
})
customarmorkit = genericbackpack:new({
	armor = 300,
	cells = 50,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})
customammopack = genericbackpack:new({
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 50,
	cells = 50,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
customgrenadepack = genericbackpack:new({
	grenades = 20,
	gren1 = 2,
	gren2 = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_bluespawnpool = location_info:new({ text = "Blue Spawn Pool", team = Team.kBlue })
location_bluecompressionchamber = location_info:new({ text = "Blue Compression Chamber", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Blue Flagroom", team = Team.kBlue })
location_bluebottomcorridors = location_info:new({ text = "Blue Bottom Corridors", team = Team.kBlue })
location_bluetopcorridors = location_info:new({ text = "Blue Top Corridors", team = Team.kBlue })

location_redspawnpool = location_info:new({ text = "Red Spawn Pool", team = Team.kRed })
location_redcompressionchamber = location_info:new({ text = "Red Compression Chamber", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Red Flagroom", team = Team.kRed })
location_redbottomcorridors = location_info:new({ text = "Red Bottom Corridors", team = Team.kRed })
location_redtopcorridors = location_info:new({ text = "Red Top Corridors", team = Team.kRed })

location_middlesubmarine = location_info:new({ text = "Middle Submarine", team = NO_TEAM })

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------
pressure_button1mirror = func_button:new({}) 
function pressure_button1mirror:ondamage() OutputEvent( "pressure_button1mirror", "Open" ) end 
function pressure_button1mirror:ontouch() OutputEvent( "pressure_button1mirror", "Open" ) end 

pressure_button1 = func_button:new({}) 
function pressure_button1:ondamage() OutputEvent( "pressure_button1", "Open" ) end 
function pressure_button1:ontouch() OutputEvent( "pressure_button1", "Open" ) end 

