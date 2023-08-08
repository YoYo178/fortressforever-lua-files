-----------------------------------------------------------------------------
-- ff_roasted_classic.lua
-- Mapped by Gator
-- AIM: toaogatortfc
-- Steam Friends Name: alligator123
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- startup
-----------------------------------------------------------------------------
function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)
	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	OutputEvent("fr_fish", "StopSound")
	AddSchedule( "play_fish", 1, OutputEvent, "fr_fish", "PlaySound" )
	OutputEvent("fr_fish_x", "StopSound")
	AddSchedule( "play_fish_x", 1, OutputEvent, "fr_fish_x", "PlaySound" )
end
-----------------------------------------------------------------------------
-- respawn protection
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
-----------------------------------------------------------------------------
-- resupplypack
-----------------------------------------------------------------------------
resupplypack = genericbackpack:new({
	health = 400,
	armor = 400,
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
function resupplypack:dropatspawn() return false end
-----------------------------------------------------------------------------
-- resupplypack_nade
-----------------------------------------------------------------------------
resupplypack_nade = genericbackpack:new({
	gren1 = 4,
	gren2 = 4,
	detpacks = 1,
	mancannons = 1,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function resupplypack_nade:dropatspawn() return false end
resupplypack_nade_blue = resupplypack_nade:new({ touchflags = {AllowFlags.kBlue} })
resupplypack_nade_red = resupplypack_nade:new({ touchflags = {AllowFlags.kRed} })
-----------------------------------------------------------------------------
-- toproompack_nade
-----------------------------------------------------------------------------
toproompack_nade = genericbackpack:new({
	gren1 = 2,
	gren2 = 2,
	detpacks = 1,
	mancannons = 1,
	health = 50,
	armor = 50,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function toproompack_nade:dropatspawn() return false end
toproompack_nade_blue = toproompack_nade:new({ touchflags = {AllowFlags.kBlue} })
toproompack_nade_red = toproompack_nade:new({ touchflags = {AllowFlags.kRed} })
-----------------------------------------------------------------------------
-- flagroompack
-----------------------------------------------------------------------------
flagroompack = genericbackpack:new({
	armor = 50,
	nails = 80,
	shells = 80,
	rockets = 80,
	cells = 80,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function flagroompack:dropatspawn() return false end
flagroompack_blue = flagroompack:new({ touchflags = {AllowFlags.kBlue} })
flagroompack_red = flagroompack:new({ touchflags = {AllowFlags.kRed} })
-----------------------------------------------------------------------------
-- blue door
-----------------------------------------------------------------------------
blue_spawn1door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn1door", "Open")
   end 
end

blue_spawn2door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 
function blue_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function blue_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn2door", "Open")
   end 
end
-----------------------------------------------------------------------------
-- red doors
-----------------------------------------------------------------------------
red_spawn1door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn1door", "Open")
   end 
end

red_spawn2door_trigger = trigger_ff_script:new({ team = Team.kRed }) 
function red_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 
        return EVENT_DISALLOWED 
end 
function red_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn2door", "Open")
   end 
end 
-----------------------------------------------------------------------------
-- blue custom locations
-----------------------------------------------------------------------------
location_blue_control_center_x = location_info:new({ text = "Control Center", team = Team.kBlue })
location_blue_lower_level_x = location_info:new({ text = "Lower Level", team = Team.kBlue })
location_blue_water_access_x = location_info:new({ text = "Water Access", team = Team.kBlue })
location_blue_T_junction_x = location_info:new({ text = "T-Junction", team = Team.kBlue })
location_blue_flagroom_water_x = location_info:new({ text = "Flag Room Water", team = Team.kBlue })
location_blue_default_flag_spot_x = location_info:new({ text = "Default Flag Location", team = Team.kBlue })
location_blue_upper_level_x = location_info:new({ text = "Upper Level", team = Team.kBlue })
location_blue_grenade_room_x = location_info:new({ text = "Grenade Room", team = Team.kBlue })
location_blue_water_tunnel_x = location_info:new({ text = "Water Tunnel", team = Team.kBlue })
location_blue_battlements_x = location_info:new({ text = "Battlements", team = Team.kBlue })
location_blue_spawn_x = location_info:new({ text = "Respawn", team = Team.kBlue })
-----------------------------------------------------------------------------
-- red custom locations
-----------------------------------------------------------------------------
location_red_control_center_x = location_info:new({ text = "Control Center", team = Team.kRed })
location_red_lower_level_x = location_info:new({ text = "Lower Level", team = Team.kRed })
location_red_water_access_x = location_info:new({ text = "Water Access", team = Team.kRed })
location_red_T_junction_x = location_info:new({ text = "T-Junction", team = Team.kRed })
location_red_flagroom_water_x = location_info:new({ text = "Flag Room Water", team = Team.kRed })
location_red_default_flag_spot_x = location_info:new({ text = "Default Flag Location", team = Team.kRed })
location_red_upper_level_x = location_info:new({ text = "Upper Level", team = Team.kRed })
location_red_grenade_room_x = location_info:new({ text = "Grenade Room", team = Team.kRed })
location_red_water_tunnel_x = location_info:new({ text = "Water Tunnel", team = Team.kRed })
location_red_battlements_x = location_info:new({ text = "Battlements", team = Team.kRed })
location_red_spawn_x = location_info:new({ text = "Respawn", team = Team.kRed })
-----------------------------------------------------------------------------
-- custom yard locations
-----------------------------------------------------------------------------
location_blue_yard_water_x = location_info:new({ text = "Yard Water", team = Team.kBlue })
location_red_yard_water_x = location_info:new({ text = "Yard Water", team = Team.kRed })
