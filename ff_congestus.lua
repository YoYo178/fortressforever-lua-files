
-- ff_congestus.lua

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------

location_yard = location_info:new({ text = "Yard", team = NO_TEAM })
location_tunnel = location_info:new({ text = "Tunnel", team = NO_TEAM })

location_blue_batts = location_info:new({ text = "Battlements", team = Team.kBlue })
location_red_batts = location_info:new({ text = "Battlements", team = Team.kRed })

location_blue_sspawn = location_info:new({ text = "Storage Spawn", team = Team.kBlue })
location_red_sspawn = location_info:new({ text = "Storage Spawn", team = Team.kRed })

location_blue_shall = location_info:new({ text = "Storage Hall", team = Team.kBlue })
location_red_shall = location_info:new({ text = "Storage Hall", team = Team.kRed })

location_blue_cspawn = location_info:new({ text = "CP Spawn", team = Team.kBlue })
location_red_cspawn = location_info:new({ text = "CP Spawn", team = Team.kRed })

location_blue_chall = location_info:new({ text = "Capture Hall", team = Team.kBlue })
location_red_chall = location_info:new({ text = "Capture Hall", team = Team.kRed })

location_blue_cap = location_info:new({ text = "Capture Point", team = Team.kBlue })
location_red_cap = location_info:new({ text = "Capture Point", team = Team.kRed })

location_blue_frupper = location_info:new({ text = "Flagroom: Top", team = Team.kBlue })
location_red_frupper = location_info:new({ text = "Flagroom: Top", team = Team.kRed })

location_blue_frlower = location_info:new({ text = "Flagroom: Floor", team = Team.kBlue })
location_red_frlower = location_info:new({ text = "Flagroom: Floor", team = Team.kRed })

location_blue_ramproom = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_red_ramproom = location_info:new({ text = "Ramp Room", team = Team.kRed })

location_blue_lowerspawn = location_info:new({ text = "Lower Spawn", team = Team.kBlue })
location_red_lowerspawn = location_info:new({ text = "Lower Spawn", team = Team.kRed })

-----------------------------------------------------------------------------
-- BLUE spawn 1
-----------------------------------------------------------------------------

blue_spawndoor_basement_trigger = trigger_ff_script:new({ team = Team.kBlue })
function blue_spawndoor_basement_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function blue_spawndoor_basement_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("blue_spawndoor_basement_left", "Open")
      OutputEvent("blue_spawndoor_basement_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- BLUE spawn2
-----------------------------------------------------------------------------

blue_spawndoor_storage_trigger = trigger_ff_script:new({ team = Team.kBlue })
function blue_spawndoor_storage_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function blue_spawndoor_storage_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("blue_spawndoor_storage_left", "Open")
      OutputEvent("blue_spawndoor_storage_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- BLUE spawn 3
-----------------------------------------------------------------------------

blue_spawndoor_capture_trigger = trigger_ff_script:new({ team = Team.kBlue })
function blue_spawndoor_capture_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function blue_spawndoor_capture_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("blue_spawndoor_capture_left", "Open")
      OutputEvent("blue_spawndoor_capture_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- RED spawn 1
-----------------------------------------------------------------------------

red_spawndoor_basement_trigger = trigger_ff_script:new({ team = Team.kRed })
function red_spawndoor_basement_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function red_spawndoor_basement_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_spawndoor_basement_left", "Open")
      OutputEvent("red_spawndoor_basement_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- RED spawn 2
-----------------------------------------------------------------------------

red_spawndoor_storage_trigger = trigger_ff_script:new({ team = Team.kRed })
function red_spawndoor_storage_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function red_spawndoor_storage_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_spawndoor_storage_left", "Open")
      OutputEvent("red_spawndoor_storage_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- RED spawn 3
-----------------------------------------------------------------------------

red_spawndoor_capture_trigger = trigger_ff_script:new({ team = Team.kRed })
function red_spawndoor_capture_trigger:allowed( touch_entity )
   if IsPlayer( touch_entity ) then
             local player = CastToPlayer( touch_entity )
             return player:GetTeamId() == self.team
   end

        return EVENT_DISALLOWED
end
function red_spawndoor_capture_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then
      OutputEvent("red_spawndoor_capture_left", "Open")
      OutputEvent("red_spawndoor_capture_right", "Open")
   end
end

-----------------------------------------------------------------------------
-- CONGESTUS pack
-- custom backpack which fully restocks ammo/health/armor, floats, respawns in one second, and gives full concs to medic and scout
-- two classes are derived from this to accomdated team-specific usage
-----------------------------------------------------------------------------

basecongypack = genericbackpack:new({
	health = 500,
	armor = 500,
	
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	
	gren1 = 0,
	gren2 = 4,
	
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function basecongypack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		local dispensed = 0
		
		-- give player some health and armor
		if self.health ~= nil then dispensed = dispensed + player:AddHealth( self.health ) end
		if self.armor ~= nil then dispensed = dispensed + player:AddArmor( self.armor ) end
		
		-- give player ammo
		if self.nails ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.gren1 ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
		
		-- gives 
		local class = player:GetClass()
		if class == Player.kScout or class == Player.kMedic then
			if self.gren2 ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
		end
		
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function basecongypack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- BLUE pack
-----------------------------------------------------------------------------

blue_congypack = basecongypack:new({
	touchflags = {AllowFlags.kBlue}
})

-----------------------------------------------------------------------------
-- RED pack
-----------------------------------------------------------------------------

red_congypack = basecongypack:new({
	touchflags = {AllowFlags.kRed}
})
