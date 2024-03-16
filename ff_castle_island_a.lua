--Special thanks to those who came before
--I borrowed some .lua from aardvark/shutdown/destroy, beautiful maps. Thanks. m0f0.



-----------------------------------------------------------------------------
-- ff_jaybases.lua
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_id");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- Gametype Setup
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Team settings
-----------------------------------------------------------------------------


function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	
	-- set team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	

-----------------------------------------------------------------------------
-- Class Settings
-----------------------------------------------------------------------------


local team = GetTeam(Team.kBlue)
 
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 1)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kPyro, 1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
local team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 2)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kPyro, 1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
end

-----------------------------------------------------------------------------
--  initial spawn health/ammo/armor
-----------------------------------------------------------------------------
function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
	player:AddHealth( 100 )
	player:AddArmor( 300 )
	
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	
	player:AddAmmo( Ammo.kGren1, 2 )
	player:AddAmmo( Ammo.kGren2, -2 )
	player:AddAmmo( Ammo.kManCannon, 1 )
    local class = player:GetClass()
    
    
end


---------------------------------------------------------------------------
--Turrets
------------------------------------------------------------

respawnturret_attackers = base_respawnturret:new({ team = attackers })
respawnturret_defenders = base_respawnturret:new({ team = defenders })

-----------------------------------------------------------------------------
-- custom packs  
-----------------------------------------------------------------------------
aardvarkpack_fr = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_ramp = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 60,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_sec = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 60,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack_fr:dropatspawn() return false end
function aardvarkpack_ramp:dropatspawn() return false end
function aardvarkpack_sec:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpacks)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack_fr:new({touchflags = tf}),
		   aardvarkpack_ramp:new({touchflags = tf}),
		   aardvarkpack_sec:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack_fr, blue_aardvarkpack_ramp, blue_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_aardvarkpack_fr, red_aardvarkpack_ramp, red_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack_fr, yellow_aardvarkpack_ramp, yellow_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack_fr, green_aardvarkpack_ramp, green_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- bouncepads for lifts  (borrowed from destroy thanks)
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 600 })
lift_blue = base_jump:new({ pushz = 380})

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

--red locations
location_red_spawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_red_entryway = location_info:new({ text = "Red Entryway", team = Team.kRed })
location_red_shoop = location_info:new({ text = "Red Shoop Tunnel", team = Team.kRed })
location_red_security = location_info:new({ text = "Red Laser Control", team = Team.kRed })
location_red_ramps = location_info:new({ text = "Red Ramp Side", team = Team.kRed })
location_red_frontdoor = location_info:new({ text = "Red Front Door", team = Team.kRed })
location_red_batts = location_info:new({ text = "Red Battlements", team = Team.kRed })
location_red_yard = location_info:new({ text = "Yard Red Side", team = Team.kRed })

--blue locations
location_blue_spawn = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_blue_entryway = location_info:new({ text = "Blue Entryway", team = Team.kBlue })
location_blue_shoop = location_info:new({ text = "Blue Shoop Tunnel", team = Team.kBlue })
location_blue_security = location_info:new({ text = "Blue Laser Control", team = Team.kBlue })
location_blue_ramps = location_info:new({ text = "Blue Ramp Side", team = Team.kBlue })
location_blue_frontdoor = location_info:new({ text = "Blue Front Door", team = Team.kBlue })
location_blue_batts = location_info:new({ text = "Blue Battlements", team = Team.kBlue })
location_blue_yard = location_info:new({ text = "Yard Blue Side", team = Team.kBlue })

--neutral locations
location_cave = location_info:new({ text = "Yard Cave Connector", team = Team.kUnassigned })


-----------------------------------------------------------------------------
-- Detpack code taken off the .lua section of the forums and ksour :)
-----------------------------------------------------------------------------
detpack_trigger = trigger_ff_script:new({ })

 function detpack_trigger:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		local detpack = CastToDetpack( trigger_entity )
		if detpack:GetTeamId() == attackers then
			BroadCastMessage("The Castle Has Been Breached ! ! !")
			BroadCastSound( "otherteam.flagstolen" )
			OutputEvent("detpack_hole", "Toggle")
			OutputEvent("detpack_debris", "Toggle")
			OutputEvent("break1", "PlaySound")
-------------THIS PORTION DOESNT WORK FOR SOME REASON -----------------
		else
			BroadCastMessageToPlayer( player,  "You Can't Destroy your own gate NOOB" )	
		end
	end
	return EVENT_DISALLOWED
end


detpack_trigger2 = trigger_ff_script:new({ })

function detpack_trigger2:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		local detpack = CastToDetpack( trigger_entity )
		if detpack:GetTeamId() == attackers then
			BroadCastMessage("The Side Barricade Has Been Breached ! ! !")
			BroadCastSound( "otherteam.flagstolen" )
			OutputEvent("detpack_hole2", "Toggle")
			OutputEvent("red_doorhack", "open")
			OutputEvent("break2", "PlaySound")
		end
------------------------------------------------------------------------
-------------THIS PORTION DOESNT WORK FOR SOME REASON -----------------
		local detpacka = CastToDetpack( trigger_entity )
		if detpacka:GetTeamId() == defenders then
			DisplayMessage( player, "You Can't Destroy your own barricade NOOB" )
			BroadCastMessageToPlayer( player, "You Can't Destroy your own barricade NOOB" )
		end
-------------------------------------------------------------------------
-------------------------------------------------------------------------
	end
	return EVENT_DISALLOWED
end




---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Generators Destroy   Borrowed and modified from Dropdown, Thx
--Ideally this destroys the generator when it's running
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------


-- blue_gen_trigger = trigger_ff_script:new({ team = Team.kBlue })
-- bluefire = 0

-- function blue_gen_trigger:onexplode( trigger_entity  ) 
	-- if IsDetpack( trigger_entity ) then 
            -- local detpacka = CastToDetpack( trigger_entity )
		-- if detpacka:GetTeamId() == defenders then
			-- if bluegenup == 1 then
				-- if bluefire == 1 then
					-- OutputEvent( "blue_doorhack", "Close" )
					-- BroadCastMessage("Generator Destroyed - Light Bridge Deactivated!")
					-- bluefire = 0
					-- bluegenup = 0
				-- end
			-- end
		-- end
     
	-- end 
	-- return EVENT_ALLOWED
-- end

-- function blue_gen_trigger:allowed( trigger_entity ) return EVENT_DISALLOWED 
-- end


---------------------------------------------------------------------------
--This basically says if you're in the trigger brush w/a spanner then bluescannerclang==1
---------------------------------------------------------------------------

-- blue_gen_repair_trigger = func_button:new({ team = Team.kBlue })
-- blue_gen_repair_trigger_script = trigger_ff_script:new()
-- bluespannerclang = 0
-- bluegenup = 0
-- blueclangcntr = 0


-- function blue_gen_repair_trigger_script:ontouch( touch_entity )
	-- if IsPlayer( touch_entity ) then
		-- local player = CastToPlayer( touch_entity )
			-- if player:GetActiveWeaponName() == "ff_weapon_spanner" then
				-- bluespannerclang = 1
				-- DisplayMessage( player, "You are repairing the Light Bridge" )
			-- end
	-- end
-- end

-- function blue_gen_repair_trigger_script:onendtouch()
	-- bluespannerclang = 0
-- end

---------------------------------------------------------------------------
--This basically says if bluescannerclang==1 aand the generator is down you can fix it
--What does bluefire do?
---------------------------------------------------------------------------

-- function blue_gen_repair_trigger:ondamage()
	-- if bluespannerclang == 1 then
		-- if bluegenup == 0 then
			-- if bluefire == 0 then
				-- OutputEvent( "bluespannerhit", "PlaySound" )
				-- blueclangcntr = blueclangcntr + 1
				-- if blueclangcntr == 10 then
					-- BroadCastMessage("The Generator is halfway fixed")
				-- end
				-- if blueclangcntr > 20 then
					-- blueclangcntr = 0             
					-- BroadCastMessage("The generator is fixed. Light Bridge Activated!")
					-- OpenDoor("blue_doorhack")
					-- bluespannerclang = 0
					-- bluegenup = 1
					-- bluefire = 1
					-- end
			-- end
		-- end
	-- end
	-- return EVENT_DISALLOWED
-- end
--Error calling onexplode ([string "maps\ff_castle_island_a.lua"]:233: attempt to call method 'GetTeamID' (a nil value)) ent: detpack_trigger

NUM_HITS_TO_REPAIR = 20
FORT_POINTS_PER_DET = 30
FORT_POINTS_PER_REPAIR = 30

function gen_ondet( team )
	local teamstring = "blue"
	if team == Team.kRed then teamstring = "red" end
	
	BroadCastMessage("#FF_"..string.upper(teamstring).."_GENBLOWN")
	
	-- outputs, add any thing you want to happen when the generator is detted here
	-- teamstring is either "red" or "blue"
	OutputEvent( "blue_doorhack", "Close" )
	BroadCastMessage ("The generator is destroyed, blue engies repair it!")
	
end

function gen_onrepair( team )
	local teamstring = "blue"
	if team == Team.kRed then teamstring = "red" end
	
	BroadCastMessage("#FF_"..string.upper(teamstring).."_GEN_OK")
	
	-- outputs, add any thing you want to happen when the generator is repaired here
	-- teamstring is either "red" or "blue"
	
	OutputEvent( "blue_doorhack", "Open")
	BroadCastMessage("The generator is fixed. Light Bridge Activated!")
		
end

function gen_onclank( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	OutputEvent( "bluespannerhit", "PlaySound" )
end

generators = {
	[Team.kBlue] = {
		-- I made this one and the generators now get activated but det doesn't work
		status=1,
		repair_status=0
	},
	[Team.kRed] = {
		status=0,
		repair_status=0
	}
}

base_gen_trigger = trigger_ff_script:new({ team = Team.kUnassigned })

function base_gen_trigger:onexplode( trigger_entity  ) 
	if generators[self.team].status == 0 then
		if IsDetpack( trigger_entity ) then 
			detpack = CastToDetpack( trigger_entity )
			if IsPlayer( detpack:GetOwner() ) then
				local player = detpack:GetOwner()
				--if player:GetTeamId() ~= self.team then
				if player:GetTeamId() == Team.kRed then
					player:AddFortPoints( FORT_POINTS_PER_DET, "Detting the generator" )
					gen_ondet( self.team )
					generators[self.team].status = 1
					generators[self.team].repair_status = 0
				end
			end
		end
	end
	return EVENT_ALLOWED
end

function base_gen_trigger:allowed( trigger_entity ) 
	if IsPlayer( trigger_entity ) then
		return EVENT_ALLOWED
	end
	return EVENT_DISALLOWED
end

function base_gen_trigger:ontouch( trigger_entity ) 
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() ~= self.team then
			if generators[self.team].status == 0 then
				BroadCastMessageToPlayer( player, "You can detonate this generator using a detpack" )
			end
		else
			if generators[self.team].status == 1 then
				BroadCastMessageToPlayer( player, "You can repair this generator by hitting it with a wrench" )
			end
		end
	end
end

blue_gen_trigger = base_gen_trigger:new({ team = Team.kBlue })
red_gen_trigger = base_gen_trigger:new({ team = Team.kRed })

base_gen = func_button:new({ team = Team.kUnassigned })

function base_gen:ondamage()
	if generators[self.team].status == 1 then
		if IsPlayer( GetPlayerByID(info_attacker) ) then
			local player = CastToPlayer( GetPlayerByID(info_attacker) )
			if player:GetTeamId() == self.team then
				if info_classname == "ff_weapon_spanner" then
					generators[self.team].repair_status = generators[self.team].repair_status + 1
					if generators[self.team].repair_status == 10 then
						BroadCastMessage("The Generator is halfway fixed")
					end
					if generators[self.team].repair_status >= NUM_HITS_TO_REPAIR then
						player:AddFortPoints( FORT_POINTS_PER_REPAIR, "Repairing the generator" )
						gen_onrepair( self.team )
						generators[self.team].status = 0
					else
						gen_onclank( player )
					end
				end
			end
		end
	end
end

blue_gen = base_gen:new({ team = Team.kBlue })
red_gen = base_gen:new({ team = Team.kRed })
