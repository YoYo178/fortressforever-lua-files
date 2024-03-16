-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------------------------------------------------------
---waterbag---
vidars_waterbag = genericbackpack:new({
	health = 20,
	armor = 20,
	grenades = 10,
	nails = 30,
	shells = 30,
	rockets = 10,
	cells = 30,
	gren1 = 0,
	gren2 = 0,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_waterbag:dropatspawn() return false end
pack_waterbag = vidars_waterbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue ,AllowFlags.kRed } })


---cavebag---
vidars_cavebag = genericbackpack:new({
	health = 25,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_cavebag:dropatspawn() return false end
pack_cavebag = vidars_cavebag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue ,AllowFlags.kRed } })

---flagroom---
vidars_flagbag = genericbackpack:new({
	health = 25,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_flagbag:dropatspawn() return false end
blue_pack_flagbag = vidars_flagbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_pack_flagbag = vidars_flagbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

---topbag---
vidars_topbag = genericbackpack:new({
	health = 40,
	armor = 40,
	grenades = 10,
	nails = 30,
	shells = 30,
	rockets = 10,
	cells = 30,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_topbag:dropatspawn() return false end
blue_pack_topbag = vidars_topbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_pack_topbag = vidars_topbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })


---ladderbag---
vidars_ladderbag = genericbackpack:new({
	health = 40,
	armor = 40,
	grenades = 10,
	nails = 30,
	shells = 30,
	rockets = 10,
	cells = 30,
	gren1 = 1,
	gren2 = 2,
	detpack = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_ladderbag:dropatspawn() return false end
blue_pack_ladderbag = vidars_ladderbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_pack_ladderbag = vidars_ladderbag:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })


---respawn gren pack---
vidars_respawngrenpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	gren1 = 4,
	gren2 = 4,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_respawngrenpack:dropatspawn() return false end
blue_pack_respawn_grenades = vidars_respawngrenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_pack_respawn_grenades = vidars_respawngrenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

---respawn pack---
vidars_respawnpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	gren1 = 0,
	gren2 = 0,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function vidars_respawnpack:dropatspawn() return false end
blue_pack_respawn = vidars_respawnpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_pack_respawn = vidars_respawnpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------------------------------------------------------
-- doors
-----------------------------------------------------------------------------------------------------------------------------
-- red  --
red_script_door_topspawn_a = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_topspawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_topspawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_topspawn_a", "Open")
   end
end

red_script_door_topspawn_b = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_topspawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_topspawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_topspawn_b", "Open")
   end
end

red_script_door_topspawn_c = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_topspawn_c:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_topspawn_c:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_topspawn_c", "Open")
   end
end

red_script_door_botspawn_a = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_botspawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_botspawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_botspawn_a", "Open")
   end
end
red_script_door_botspawn_b = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_botspawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_botspawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_botspawn_b", "Open")
   end
end


red_script_door_front = trigger_ff_script:new({  })
function red_script_door_front:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_door_front", "Open")
   end
end

red_script_door_flagroom = trigger_ff_script:new({ team = Team.kRed })
function red_script_door_flagroom :allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function red_script_door_flagroom :ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("red_door_flagroom", "Open")
   end
end


-- blue  --
blue_script_door_topspawn_a = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_topspawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_topspawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_topspawn_a", "Open")
   end
end

blue_script_door_topspawn_b = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_topspawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_topspawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_topspawn_b", "Open")
   end
end

blue_script_door_topspawn_c = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_topspawn_c:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_topspawn_c:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_topspawn_c", "Open")
   end
end

blue_script_door_botspawn_a = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_botspawn_a:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_botspawn_a:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_botspawn_a", "Open")
   end
end
blue_script_door_botspawn_b = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_botspawn_b:allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_botspawn_b:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_botspawn_b", "Open")
   end
end


blue_script_door_front = trigger_ff_script:new({  })
function blue_script_door_front:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("blue_door_front", "Open")
   end
end

blue_script_door_flagroom = trigger_ff_script:new({ team = Team.kBlue })
function blue_script_door_flagroom :allowed( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    return player:GetTeamId() == self.team
  end
  return EVENT_DISALLOWED
end
function blue_script_door_flagroom :ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
    OutputEvent("blue_door_flagroom", "Open")
   end
end


-----------------------------------------------------------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------
-- destructables
-----------------------------------------------------------------------------------------------------------------------------
---grates---
base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })
function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
			if self.team_name == "red" then BroadCastMessage("#FF_RED_GRATEBLOWN") end
			if self.team_name == "blue" then BroadCastMessage("#FF_BLUE_GRATEBLOWN") end
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end
red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })

---ice---
base_ice_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })
function base_ice_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_icewall", "Kill" )
			OutputEvent( self.team_name .. "_icewall_wall", "Kill" )
			OutputEvent( self.team_name .. "_icewall2", "Kill" )
			OutputEvent( self.team_name .. "_icewall_wall2", "Kill" )
			--if self.team_name == "red" then BroadCastMessage("#FF_RED_GRATEBLOWN") end
			--if self.team_name == "blue" then BroadCastMessage("#FF_BLUE_GRATEBLOWN") end
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_ice_trigger = base_ice_trigger:new({ team = Team.kRed, team_name = "red" })
blue_ice_trigger = base_ice_trigger:new({ team = Team.kBlue, team_name = "blue" })
