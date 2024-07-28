-----------------------------------------------------------------------------
-- base_doom.lua
-- open ended deathmatch mode loosely based on DooM (1993)
-----------------------------------------------------------------------------
--== File last modified:
-- 11 / 01 / 2024 ( dd / mm / yyyy ) by gumbuk
--== Contributors:
-- gumbuk 9
-- mv
--== Mode is hosted & developed at:
-- https://github.com/Fortress-Forever-Mapper-Union/ffmu-modes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------
TIME_WEAPONRESPAWN = 5 -- respawn time for weapons when weaponstay is off
TIME_ITEMRESPAWN = 8 -- respawn time for menial items
TIME_PRESTIGERESPAWN = 10 -- respawn time for important items
TIME_LEFTOVER_TIMEOUT = 5

WEAPONSTAY = true -- weapons don't disappear when picked up
DROPONDEATH = true -- drop weapons on death

-----------------------------------------------------------------------------
-- general functions
-----------------------------------------------------------------------------
function startup()
	SetGameDescription("DooM!!")
	
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
end

function player_spawn( input_player )
	local player = CastToPlayer( input_player )
	
	player:RemoveArmor(400)
	
	player:RemoveAllWeapons()
	player:RemoveAllAmmo( true )
	player:GiveWeapon( "ff_weapon_crowbar", false )
	player:GiveWeapon( "ff_weapon_shotgun", true )
	player:AddAmmo( Ammo.kShells, 24 )
	
	player:AddEffect( EF.kSpeedlua1, -1, -1, 1.5 )
end

function mvremove(entity) -- hack i had to do to avoid removing entities that have been removed already to avoid crashing server ~mv
	if (entity:GetClassName() == "info_ff_script" and #entity:GetName() ~= 0) then
		RemoveEntity(entity)
	end
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
			if DROPONDEATH then
				local weapon = player:GetActiveWeaponName()
				local entity = SpawnEntity("info_ff_script", tostring("playerdrop_" .. weapon:sub(11)))
				entity:Teleport(input_player:GetOrigin(), input_player:GetAngles(), input_player:GetVelocity())
				DropToFloor(entity)
				AddSchedule( tostring("removepickup" .. tostring(RandomInt(1000,9999))), TIME_LEFTOVER_TIMEOUT, mvremove, entity)
			end
		end	   
	end
end

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
----==== Weapon Pickups
pickup_base = info_ff_script:new({
	weapon = "ff_weapon_crowbar",
	model = "models/weapons/crowbar/w_crowbar.mdl",
	touchsound = "Item.Materialize",
	spawnsound = "Backpack.Touch",
	shouldDropOnDeath = false,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function pickup_base:dropatspawn() return false end

function pickup_base:precache()
	PrecacheSound(self.touchsound)
	PrecacheSound(self.spawnsound)
	PrecacheModel(self.model)
end

function pickup_base:touch( input_player )
	local player = CastToPlayer( input_player )
	local item = CastToInfoScript(entity)
	
	player:GiveWeapon( self.weapon, false )

	if (not WEAPONSTAY and not self.shouldDropOnDeath) then
		item:Respawn(TIME_WEAPONRESPAWN)
	end

	if self.shouldDropOnDeath then
		RemoveEntity(item)
	end
end

pickup_supershotgun = pickup_base:new({
	weapon = "ff_weapon_supershotgun",
	model = "models/weapons/supershotgun/w_supershotgun.mdl"
})

playerdrop_supershotgun = pickup_supershotgun:new({shouldDropOnDeath = true})

pickup_rpg = pickup_base:new({
	weapon = "ff_weapon_rpg",
	model = "models/weapons/rpg/w_rpg.mdl"
})

playerdrop_rpg = pickup_rpg:new({shouldDropOnDeath = true})

pickup_railgun = pickup_base:new({
	weapon = "ff_weapon_railgun",
	model = "models/weapons/railgun/w_railgun.mdl"
})

playerdrop_railgun = pickup_railgun:new({shouldDropOnDeath = true})

pickup_autorifle = pickup_base:new({
	weapon = "ff_weapon_autorifle",
	model = "models/weapons/autorifle/w_autorifle.mdl"
})

playerdrop_autorifle = pickup_autorifle:new({shouldDropOnDeath = true})

pickup_grenadelauncher = pickup_base:new({
	weapon = "ff_weapon_grenadelauncher",
	model = "models/weapons/grenadelauncher/w_grenadelauncher.mdl"
})

playerdrop_grenadelauncher = pickup_grenadelauncher:new({shouldDropOnDeath = true})

pickup_flamethrower = pickup_base:new({
	weapon = "ff_weapon_flamethrower",
	model = "models/weapons/flamethrower/w_flamethrower.mdl"
})

playerdrop_flamethrower = pickup_flamethrower:new({shouldDropOnDeath = true})

----==== Armor
combatarmor = info_ff_script:new({
	model = "models/items/armour/armour.mdl",
	modelskin = 0,
	touchsound = "ArmorKit.Touch",
	spawnsound = "Item.Materialize",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function combatarmor:precache()
	PrecacheSound(self.touchsound)
	PrecacheSound(self.spawnsound)
	PrecacheModel(self.model)
end

function combatarmor:touch( input_player )
	local player = CastToPlayer(input_player)
	local item = CastToInfoScript(entity)
	local maxarmor = player:GetMaxArmor()
	
	if player:GetArmor() > (maxarmor * 0.95) then return; end
	
	item:EmitSound( self.touchsound )
	item:Respawn( TIME_PRESTIGERESPAWN )
	player:AddArmor(maxarmor)
end

securityarmor = info_ff_script:new({
	model = "models/items/armour/armour.mdl",
	modelskin = 2,
	touchsound = "ArmorKit.Touch",
	spawnsound = "Item.Materialize",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function securityarmor:precache()
	PrecacheSound(self.touchsound)
	PrecacheSound(self.spawnsound)
	PrecacheModel(self.model)
end

function securityarmor:touch( input_player )
	local player = CastToPlayer(input_player)
	local item = CastToInfoScript(entity)
	local maxarmor = player:GetMaxArmor()
	local halfarmor = maxarmor/2
	
	if player:GetArmor() > (halfarmor * 0.8) then return; end
	
	item:EmitSound( self.touchsound )
	item:Respawn( TIME_ITEMRESPAWN )
	
	local givearmor = halfarmor
	givearmor = givearmor - player:GetArmor()
	player:AddArmor(givearmor)
end

--==== Ammo

-- smallshells = genericbackpack:new({
	-- health = 0,
	-- armor = 0,
	-- shells = 0,
	-- nails = 0,
	-- rockets = 0,
	-- cells = 0,
	-- gren1 = 0,
	-- gren2 = 0,
	-- respawntime = TIME_ITEMRESPAWN,
	-- model = "models/items/doom/pickups/shells/smallshells.mdl",
	-- materializesound = "Item.Materialize",
	-- touchsound = "HealthKit.Touch",
	-- notallowedmsg = "#FF_NOTALLOWEDPACK",
	-- touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
-- })

smallshells = genericbackpack:new({
	shells = 16,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/shells/smallshells.mdl",
	touchsound = "Backpack.Touch"
})

function smallshells:dropatspawn() return true end

largeshells = genericbackpack:new({
	shells = 48,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/shells/largeshells.mdl",
	touchsound = "Backpack.Touch"
})

function largeshells:dropatspawn() return true end

smallnails = genericbackpack:new({
	nails = 25,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/nails/smallnails.mdl",
	touchsound = "Backpack.Touch"
})

function smallnails:dropatspawn() return true end

largenails = genericbackpack:new({
	nails = 75,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/shells/smallshells.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function largenails:dropatspawn() return true end

powercell = genericbackpack:new({
	cells = 10,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/cells/powercell.mdl",
	touchsound = "Backpack.Touch"
})

function powercell:dropatspawn() return true end

fueltank = genericbackpack:new({
	shells = 8,
	nails = 25,
	rockets = 2,
	cells = 50,
	gren2 = 1,
	respawntime = TIME_PRESTIGERESPAWN,
	model = "models/items/doom/pickups/shells/smallshells.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function fueltank:dropatspawn() return true end

smallbag = genericbackpack:new({
	shells = 20,
	nails = 50,
	rockets = 2,
	cells = 8,
	gren1 = 1,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch"
})

function smallbag:dropatspawn() return true end

largebag = genericbackpack:new({
	shells = 40,
	nails = 75,
	rockets = 6,
	cells = 16,
	gren1 = 2,
	respawntime = TIME_PRESTIGERESPAWN,
	model = "models/items/backpack/backpack.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "Backpack.Touch"
})

function largebag:dropatspawn() return true end

stimpak = genericbackpack:new({
	health = 15,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/shells/smallshells.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "HealthKit.Touch"
})

function stimpak:dropatspawn() return true end

medkit = genericbackpack:new({
	health = 60,
	respawntime = TIME_ITEMRESPAWN,
	model = "models/items/doom/pickups/shells/smallshells.mdl", -- MISSING CUSTOM MODEL!!
	touchsound = "HealthKit.Touch"
})

function medkit:dropatspawn() return true end