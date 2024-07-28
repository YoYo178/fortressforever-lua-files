IncludeScript( "base_arena" )
IncludeScript( "addon_instagib" )

require "devbox_skyscraper"

BLASTJUMP_MODIFIER = Vector( 1.2, 1.2, 2 ) -- multiplier for self knockback

smallpack = optionalbackpack:new({
	health = 15,
	respawntime = smallpack_return,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

bigpack = optionalbackpack:new({
	health = 50,
	respawntime = bigpack_return,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch"
})