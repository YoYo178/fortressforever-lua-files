-----------------------------------------------------------------------------
-- base_fueldrain.lua
-- open end deathmatch mode where you play as a robot powered by liquid fuel
-----------------------------------------------------------------------------
--== File last modified:
-- 11 / 01 / 2024 ( dd / mm / yyyy ) by gumbuk
--== Contributors:
-- gumbuk 9
--== Mode is hosted & developed at:
-- https://github.com/Fortress-Forever-Mapper-Union/ffmu-modes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------
playerlist = {}

defaultweapons = {
	slot1 = "ff_weapon_crowbar",
	slot2 = "ff_weapon_shotgun",
	slot3 = "ff_weapon_supershotgun",
	slot4 = "ff_weapon_supernailgun",
	slot5 = "ff_weapon_ic"
}

--[[ 
	define every weapon's properties, so that you can lookup what you need for it.
	may not even be implemented in base gamemode with model and icon,
	but that's on whoever wants to use it in their map ]]
	
wepdef = {
	ff_weapon_crowbar =		{ slot = "slot1",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 0 },
	ff_weapon_knife = 		{ slot = "slot1",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 0 },
	ff_weapon_medkit =		{ slot = "slot1",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 0 },
	ff_weapon_spanner =		{ slot = "slot1",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 0 },
	ff_weapon_shotgun =		{ slot = "slot2",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 20 },
	ff_weapon_railgun =		{ slot = "slot2",	icon = "vgui/notyet",	ammotype = Ammo.kNails,	ammocount = 35 },
	ff_weapon_sniperrifle =	{ slot = "slot2",	icon = "vgui/notyet",	ammotype = Ammo.kNails, ammocount = 25 },
	ff_weapon_tranq = 		{ slot = "slot2",	icon = "vgui/notyet",	ammotype = Ammo.kNails,	ammocount = 15 },
	ff_weapon_supershotgun =	{ slot = "slot3",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 35 },
	ff_weapon_autorifle = 	{ slot = "slot3",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 60 },
	ff_weapon_jumpgun = 		{ slot = "slot3",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 0 },
	ff_weapon_tommygun = 		{ slot = "slot3",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 40 },
	ff_weapon_nailgun = 		{ slot = "slot4",	icon = "vgui/notyet",	ammotype = Ammo.kNails,	ammocount = 40 },
	ff_weapon_supernailgun = 	{ slot = "slot4",	icon = "vgui/notyet",	ammotype = Ammo.kNails,	ammocount = 50 },
	ff_weapon_grenadelauncher = { slot = "slot4",	icon = "vgui/notyet",	ammotype = Ammo.kRockets,	ammocount = 12 },
	ff_weapon_flamethrower =	{ slot = "slot4",	icon = "vgui/notyet",	ammotype = Ammo.kCells,	ammocount = 60 },
	ff_weapon_rpg = 			{ slot = "slot5",	icon = "vgui/notyet",	ammotype = Ammo.kRockets,	ammocount = 8 },
	ff_weapon_pipelauncher =	{ slot = "slot5",	icon = "vgui/notyet",	ammotype = Ammo.kRockets,	ammocount = 12 },
	ff_weapon_assaultcannon =	{ slot = "slot5",	icon = "vgui/notyet",	ammotype = Ammo.kShells,	ammocount = 80 },
	ff_weapon_ic =			{ slot = "slot5",	icon = "vgui/notyet",	ammotype = Ammo.kRockets,	ammocount = 12 }
}

-----------------------------------------------------------------------------
-- functions
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("FuelDrain")

	for i = Team.kBlue, Team.kGreen do
		local team = GetTeam(i)
		team:SetClassLimit( Player.kScout, -1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, 0 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, -1 )
		team:SetClassLimit( Player.kHwguy, -1 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, -1 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit( Player.kCivilian, -1 )
	end
	
	playerlist = {}
	AddScheduleRepeating( "fueldrain", 2, tickfuel )
end

function tickfuel()
	for key, value in pairs(playerlist) do
		local armor = value.cast:GetArmor()
		value.cast:RemoveArmor( 2 )
		if armor == 0 then value.cast:AddHealth( -70 ) end
	end
end

function player_spawn( input_entity )
	local player = CastToPlayer(input_entity)
	local steamID = player:GetSteamID()
	
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	
	if playerlist[steamID] == nil then playerlist_default(player) end
	
	player:RemoveAllWeapons()
	player:GiveWeapon(playerlist[steamID].slot1, false)
	player:GiveWeapon(playerlist[steamID].slot2, false)
	player:GiveWeapon(playerlist[steamID].slot3, true)
	player:GiveWeapon(playerlist[steamID].slot4, false)
	player:GiveWeapon(playerlist[steamID].slot5, false)
end

function playerlist_default( input_player )
	-- input should be an already cast player. assume so.
	local steamID = input_player:GetSteamID()
	playerlist[steamID] = {}
	
	playerlist[steamID].cast = input_player
	
	playerlist[steamID].slot1 = defaultweapons.slot1
	playerlist[steamID].slot2 = defaultweapons.slot2
	playerlist[steamID].slot3 = defaultweapons.slot3
	playerlist[steamID].slot4 = defaultweapons.slot4
	playerlist[steamID].slot5 = defaultweapons.slot5
	
end

function player_killed( input_player, damageinfo )
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()
		local player = CastToPlayer( input_player )
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			if not (player:GetTeamId() == killer:GetTeamId()) then
				local killersTeam = killer:GetTeam()	
				killersTeam:AddScore(1)
			end
		end	   
	end
end

function player_disconnect( input_entity )
	local player = CastToPlayer(input_entity)
	playerlist[player:GetSteamID()] = nil
end

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
----==== economics
fueljug = genericbackpack:new({
	armor = 25,
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function fueljug:dropatspawn() return true; end

gascan = genericbackpack:new({
	armor = 65,
	respawntime = 12,
	model = "models/props_junk/gascan001a.mdl", -- HL2 model will do
	touchsound = "Backpack.Touch"
})

function gascan:dropatspawn() return true; end

blowtorch = genericbackpack:new({
	health = 45,
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function blowtorch:dropatspawn() return true; end

maintdepot = genericbackpack:new({ -- maintenance depot
	health = 45,
	armor = 45,
	respawntime = 12,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function maintdepot:dropatspawn() return true; end

ammodepot = genericbackpack:new({
	shells = 40,
	nails = 100,
	rockets = 6,
	cells = 70,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function ammodepot:dropatspawn() return true; end

artillerydepot = genericbackpack:new({
	rockets = 10,
	gren1 = 3,
	gren2 = 1,
	respawntime = 16,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function artillerydepot:dropatspawn() return true; end

----==== weapons
genericweapon = info_ff_script:new({
	weapon = "ff_weapon_crowbar",
	model = "models/weapons/crowbar/w_crowbar.mdl",
	touchsound = "ArmorKit.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function genericweapon:precache()
	PrecacheSound( self.touchsound )
	PrecacheModel( self.model )
	info_ff_script.precache( self )
end

function genericweapon:touch( input_entity )
	local player = CastToPlayer( input_entity )
	local steamID = player:GetSteamID()
	local slot = tostring(wepdef[self.weapon].slot)
	local item = CastToInfoScript( entity )

	playerlist[steamID][slot] = self.weapon
	
	item:EmitSound( self.touchsound )
	item:Respawn( RandomInt( 15, 22 ) )
end

function genericweapon:dropatspawn() return false; end

-- slot 1
weapon_crowbar = genericweapon:new({ --[[ :) ]] })
weapon_knife = genericweapon:new({ weapon = "ff_weapon_knife", model = "models/weapons/knife/w_knife.mdl" })
-- weapon_medkit = genericweapon:new({ weapon = "ff_weapon_medkit", model = "models/weapons/medkit/w_medkit.mdl" }) -- dying from running out of fuel displays medkit icon, so. also it'd be a bit cracked.
-- weapon_spanner = genericweapon:new({ weapon = "ff_weapon_spanner", model = "models/weapons/spanner/w_spanner.mdl" }) -- reduntant :(

-- slot 2
weapon_shotgun = genericweapon:new({ weapon = "ff_weapon_shotgun", model = "models/weapons/shotgun/w_shotgun.mdl" })
weapon_tranq = genericweapon:new({ weapon = "ff_weapon_tranq", model = "models/weapons/tranq/w_tranq.mdl" })
weapon_railgun = genericweapon:new({ weapon = "ff_weapon_railgun", model = "models/weapons/railgun/w_railgun.mdl" })
-- weapon_sniper = genericweapon:new({ weapon = "ff_weapon_sniperrifle", model = "models/weapons/sniperrifle/w_sniperrifle.mdl" }) -- cracked

-- slot 3
weapon_supershotgun = genericweapon:new({ weapon = "ff_weapon_supershotgun", model = "models/weapons/supershotgun/w_supershotgun.mdl" })
weapon_autorifle = genericweapon:new({ weapon = "ff_weapon_autorifle", model = "models/weapons/autorifle/w_autorifle.mdl" })
weapon_jumpgun = genericweapon:new({ weapon = "ff_weapon_jumpgun", model = "models/weapons/railgun/w_railgun.mdl" })
-- weapon_tommygun = genericweapon:new({ weapon = "ff_weapon_tommygun", model = "models/weapons/tommygun/w_tommygun.mdl" }) -- redundant :(

-- slot 4
weapon_nailgun = genericweapon:new({ weapon = "ff_weapon_nailgun", model = "models/weapons/nailgun/w_nailgun.mdl" })
weapon_supernailgun = genericweapon:new({ weapon = "ff_weapon_supernailgun", model = "models/weapons/supernailgun/w_supernailgun.mdl" })
weapon_grenadelauncher = genericweapon:new({ weapon = "ff_weapon_grenadelauncher", model = "models/weapons/grenadelauncher/w_grenadelauncher.mdl" })
weapon_flamethrower = genericweapon:new({ weapon = "ff_weapon_flamethrower", model = "models/weapons/flamethrower/w_flamethrower.mdl" })

-- slot 5
weapon_ic = genericweapon:new({ weapon = "ff_weapon_ic", model = "models/weapons/incendiarycannon/w_incendiarycannon.mdl" })
weapon_rpg = genericweapon:new({ weapon = "ff_weapon_rpg", model = "models/weapons/rpg/w_rpg.mdl" })
weapon_pipelauncher = genericweapon:new({ weapon = "ff_weapon_pipelauncher", model = "models/weapons/pipelauncher/w_pipelauncher.mdl" })
-- weapon_assaultcannon = genericweapon:new({ weapon = "ff_weapon_assaultcannon", model = "models/weapons/assaultcannon/w_assaultcannon.mdl" }) -- cracked
