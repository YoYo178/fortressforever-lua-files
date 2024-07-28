-- ff_faithless_a1.lua
-- a faithless recreation of Facing Worlds
-- alpha 1 version, highly unfinished

-- made for the Fortress Forever Gamemode Resource by gumbuk 9


IncludeScript("base_ctp")
IncludeScript("base_location")
--[[ IncludeScript("base_respawnturret")
	ughhh i should probably add these to this version of the map but like,
	that'd need a small degree of redesigning, cause i went too long without ]]
-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------
POINTS_PER_PLAQUE = 5
FORTPOINTS_PER_PLAQUE = 400
FORTPOINTS_PER_PLAQUESTEAL = 100
FORTPOINTS_PER_PLAQUERETURN = 100
PLAQUE_RETURN_TIME = -1
PLAQUE_THROW_SPEED = 330

slamming = {}

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------

function startup()
	SetGameDescription("Capture The Plaque")

	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kHwguy, 2)
	team:SetClassLimit(Player.kSniper, 3)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kHwguy, 2)
	team:SetClassLimit(Player.kSniper, 3)

	AddScheduleRepeating( "voidcheck", 1, voidcheck )
end

function player_ondamage( input_player, damageinfo )

	if not damageinfo then return end

	local attacker = damageinfo:GetAttacker()
	local player = CastToPlayer( input_player )
	local victimID = player:GetSteamID()
	
	----==== Slam Elevator
	for key, value in pairs(slamming) do
		-- ConsoleToAll("key "..tostring(key).." ".."value "..tostring(value))
		if slamming[victimID] and damageinfo:GetDamageType() == 32 then
		damageinfo:SetDamage(0) end
	end
end

function voidcheck() --  yeeknoew, check if the plaques are in the void
	-- should this be hardcoded?
	local voidpos = -768
	for key, value in pairs(plaquelist) do
		local plaque = CastToInfoScript(key)
		if plaque:GetOrigin().z < voidpos then plaque:Return() end
	end
end

-----------------------------------------------------------------------------
-- Entities
-----------------------------------------------------------------------------
----==== InfoScripts
-- voidbeacon = info_ff_script:new({ model = "" })

----==== TriggerScripts
slamtrigger = trigger_ff_script:new({})

function slamtrigger:allowed( input_entity ) if input_entity and IsPlayer( input_entity ) then return true; end end

function slamtrigger:onstarttouch( input_player )
	local player = CastToPlayer( input_player )
	local steamID = player:GetSteamID()
	slamming[steamID] = player
end

function slamtrigger:ontrigger( input_player )
	local player = CastToPlayer( input_player )
	local velocity = player:GetVelocity()

	player:SetVelocity( Vector( velocity.x, velocity.y, velocity.z - 64 ) )
end

function slamtrigger:onendtouch( input_player )
	local player = CastToPlayer( input_player )
	local steamID = player:GetSteamID()
	slamming[steamID] = nil
end

risetrigger = trigger_ff_script:new({}) -- using these because trigger_push refuses to work

function risetrigger:allowed( input_entity ) if input_entity and IsPlayer( input_entity ) then return true; end end

function risetrigger:ontrigger( input_player )
	local player = CastToPlayer( input_player )
	local velocity = player:GetVelocity()

	if velocity.z < 1024 then
		player:SetVelocity( Vector( velocity.x, velocity.y, velocity.z + 64 ) )
	else
		player:SetVelocity( Vector( velocity.x, velocity.y, 1024 ) )
	end
end

flightcontrol = trigger_ff_script:new({}) -- this is so extra......

function flightcontrol:allowed( input_entity ) if input_entity and IsPlayer( input_entity ) then return true; end end

function flightcontrol:ontrigger( input_player )
	local player = CastToPlayer( input_player )
	local velocity = player:GetVelocity()

	if velocity.z > 512 then
		player:SetVelocity( Vector( velocity.x, velocity.y, velocity.z - 400 ) )
	else
		player:SetVelocity( Vector( velocity.x, velocity.y, 512 ) )
	end
end

----==== Pickups
peak_armor = genericbackpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",

	health = 30,
	armor = 90,

	gren2 = 2,

	respawntime = 20
})

peak_backpack = genericbackpack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "Backpack.Touch",

	shells = 50,
	nails = 50,
	cells = 50,
	rockets = 4,

	respawntime = 8
})

grate_armor = genericbackpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",

	health = 60,
	armor = 60,

	gren1 = 1,
	gren2 = 1,

	respawntime = 15
})

grate_backpack = genericbackpack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "Backpack.Touch",

	shells = 60,
	nails = 30,
	cells = 100,
	rockets = 8,

	respawntime = 8
})

nest_armor = genericbackpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",

	health = 30,
	armor = 60,

	gren1 = 1,

	respawntime = 15
})

nest_backpack = genericbackpack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "Backpack.Touch",

	shells = 80,
	nails = 30,
	cells = 100,
	rockets = 16,

	respawntime = 8
})

lobby_armor = genericbackpack:new({
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",

	health = 30,
	armor = 80,

	gren1 = 1,

	respawntime = 15
})

lobby_backpack = genericbackpack:new({
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "Backpack.Touch",

	shells = 80,
	nails = 30,
	cells = 100,
	rockets = 16,

	respawntime = 8
})

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_space = location_info:new({ text = "Outer Space", team = NO_TEAM })
location_asteroid = location_info:new({ text = "Asteroid", team = NO_TEAM })

-- notable places
location_peak_b = location_info:new({ text = "Peak", team = Team.kBlue })
location_grate_b = location_info:new({ text = "Grate", team = Team.kBlue })
location_nest_b = location_info:new({ text = "Nest", team = Team.kBlue })
location_lobby_b = location_info:new({ text = "Lobby", team = Team.kBlue })
-- transient areas
location_drop_b = location_info:new({ text = "Long Way Down...", team = Team.kBlue })
location_elevator_b = location_info:new({ text = "Elevator", team = Team.kBlue })
location_arch_b = location_info:new({ text = "Front Arch", team = Team.kBlue })
location_ring_b = location_info:new({ text = "Stone Ring", team = Team.kBlue })


-- notable places
location_peak_r = location_info:new({ text = "Peak", team = Team.kRed })
location_grate_r = location_info:new({ text = "Grate", team = Team.kRed })
location_nest_r = location_info:new({ text = "Nest", team = Team.kRed })
location_lobby_r = location_info:new({ text = "Lobby", team = Team.kRed })
-- transient areas
location_drop_r = location_info:new({ text = "Long Way Down...", team = Team.kRed })
location_elevator_r = location_info:new({ text = "Elevator", team = Team.kRed })
location_arch_r = location_info:new({ text = "Front Arch", team = Team.kRed })
location_ring_r = location_info:new({ text = "Stone Ring", team = Team.kRed })


-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------
meth_blue_asteroid = function( self, input_player ) return ( input_player:GetTeamId() == Team.kBlue ) end
meth_red_asteroid = function( self, input_player ) return ( input_player:GetTeamId() == Team.kRed ) end

blue_asteroid = { validspawn = meth_blue_asteroid }
red_asteroid = { validspawn = meth_red_asteroid }