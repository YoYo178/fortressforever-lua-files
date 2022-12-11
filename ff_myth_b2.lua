IncludeScript( "base_ctf" );

---------------------------------
-- Blue door
---------------------------------

blue_door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door_trigger:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity ) 
		return player:GetTeamId() == self.team 
	end 

	return EVENT_DISALLOWED 
end 

function blue_door_trigger:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then 
		OutputEvent("blue_door_left", "Open")
		OutputEvent("blue_door_right", "Open")
	end 
end 

---------------------------------
-- Red door
---------------------------------

red_door_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door_trigger:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity ) 
		return player:GetTeamId() == self.team 
	end 

	return EVENT_DISALLOWED 
end 

function red_door_trigger:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then 
		OutputEvent("red_door_left", "Open")
		OutputEvent("red_door_right", "Open")
	end 
end 

---------------------------------
-- Spawnpacks
---------------------------------

spawnpack = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	gren1 = 0,
	gren2 = 0,
	cells = 50,
	armor = 200,
	health = 100,
    respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function spawnpack :dropatspawn() return false end

red_spawnpack = spawnpack:new({ touchflags = {AllowFlags.kRed} })
blue_spawnpack = spawnpack:new({ touchflags = {AllowFlags.kBlue} })

---------------------------------
-- Nade Spawnpacks
---------------------------------

nadepack = genericbackpack:new({
	grenades = 0,
	bullets = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	gren1 = 2,
	gren2 = 1,
	cells = 0,
	armor = 0,
	health = 0,
    respawntime = 25,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function nadepack :dropatspawn() return false end

red_nadepack = nadepack:new({ touchflags = {AllowFlags.kRed} })
blue_nadepack = nadepack:new({ touchflags = {AllowFlags.kBlue} })

---------------------------------
-- Packs
---------------------------------

pack = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	gren1 = 0,
	gren2 = 0,
	cells = 50,
	armor = 25,
	health = 10,
    respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function pack :dropatspawn() return false end

red_pack = pack:new({ touchflags = {AllowFlags.kRed} })
blue_pack = pack:new({ touchflags = {AllowFlags.kBlue} })