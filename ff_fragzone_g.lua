-- ff_fz_beta.lua v0.1
-- LUA by sidd
-- Map by GambiT **robbheb82@cox.net**

-----------------------------------------------------------------------------
-- Entities:
-----------------------------------------------------------------------------
--fullgrenbag is a info_ff_script with full grenades. blue_fullgrenbag and red_fullgrenbag are team specific
--fullammobag is same, but with ammo
-----------------------------------------------------------------------------
-- Gameplay info
-----------------------------------------------------------------------------
-- two teams, red and blue, full ammo on spawn
-- no special scoring, just frag away!
-----------------------------------------------------------------------------

IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("base");

function startup()
	-- only red and blue teams
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )
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
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})
-----------------------------------------------------------------------------
-- bag containing fullammo, but no grenades
-----------------------------------------------------------------------------
fullammobag = genericbackpack:new({
	health = 400,
	armor = 400,
        grenades = 400,  -- this is pipe launcher grenades, not frags
	bullets = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	respawntime = 1,
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
-- backpack entity setup (modified for fullgrenbag and fullammobag)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   fullgrenbag:new({touchflags = tf}),
		   fullammobag:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_fullgrenbag, blue_fullammobag = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_fullgrenbag, red_fullammobag = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
