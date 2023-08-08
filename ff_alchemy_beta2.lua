-- ff_alchemy.lua
-- Dr.Satan 08/2009
-- Modified Last: Dr.Satan 11/2009

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;

-----------------------------------------------------------------------------
-- bagless resupply
-----------------------------------------------------------------------------
alchyresup = trigger_ff_script:new({ team = Team.kUnassigned })

function alchyresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_alchyresup = alchyresup:new({ team = Team.kBlue })
red_alchyresup = alchyresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
--  lasers and respawn shields
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- engy only backpack
-----------------------------------------------------------------------------
engybackpack = info_ff_script:new({
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function engybackpack:dropatspawn() return false end

function engybackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function engybackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetClass() == Player.kEngineer then
			local dispensed = 0
		
			-- give player some health and armor
			if self.health ~= nil and self.health ~= 0 then dispensed = dispensed + player:AddHealth( self.health ) end
			if self.armor ~= nil and self.armor ~= 0 then dispensed = dispensed + player:AddArmor( self.armor ) end
		
			-- give player ammo
			if self.nails ~= nil and self.nails ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
			if self.shells ~= nil and self.shells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
			if self.rockets ~= nil and self.rockets ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
			if self.cells ~= nil and self.cells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
			if self.detpacks ~= nil and self.detpacks ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) end
			if self.mancannons ~= nil and self.mancannons ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kManCannon, self.mancannons) end
			if self.gren1 ~= nil and self.gren1 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
			if self.gren2 ~= nil and self.gren2 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
		
			-- if the player took ammo, then have the backpack respawn with a delay
			if dispensed >= 1 then
				local backpack = CastToInfoScript(entity);
				if backpack then
					backpack:EmitSound(self.touchsound);
					backpack:Respawn(self.respawntime);
				end
			end
		end
	end
end

function engybackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- custom packs
-----------------------------------------------------------------------------

alchypack_fr1 = engybackpack:new({
	health = 0,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 200,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/cells/cell.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

alchypack_fr2 = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

alchypack_rs1 = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

alchypack_rs2 = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

alchypack_rs3 = genericbackpack:new({
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

function alchypack_fr1:dropatspawn() return false end
function alchypack_fr2:dropatspawn() return false end
function alchypack_rs1:dropatspawn() return false end
function alchypack_rs2:dropatspawn() return false end
function alchypack_rs3:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for alchypacks)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   engybackpack:new({touchflags = tf}),
		   alchypack_fr1:new({touchflags = tf}),
		   alchypack_fr2:new({touchflags = tf}),
		   alchypack_rs1:new({touchflags = tf}),
		   alchypack_rs2:new({touchflags = tf}),
		   alchypack_rs3:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_engybackpack, blue_alchypack_fr1, blue_alchypack_fr2, blue_alchypack_rs1, blue_alchypack_rs2, blue_alchypack_rs3  = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_engybackpack, red_alchypack_fr1, red_alchypack_fr2, red_alchypack_rs1, red_alchypack_rs2, red_alchypack_rs3 = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})

-----------------------------------------------------------------------------
-- bouncepads
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

lift_red = base_jump:new({ pushz = 1100 })
lift_blue = base_jump:new({ pushz = 1100 })

base_waterway = trigger_ff_script:new({ puzhy = 0 })

function base_waterway:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.y = self.pushy
		player:SetVelocity( playerVel )
	end
end
		
blue_waterway_push = base_waterway:new({ pushy = 100 })
red_waterway_push = base_waterway:new({ pushy = 100 })

-----------------------------------------------------------------------------
-- locations
-----------------------------------------------------------------------------
location_basement_blue = location_info:new({ text = "Basement", team = Team.kBlue })
location_basement_red = location_info:new({ text = "Basement", team = Team.kRed })

location_batts_blue = location_info:new({ text = "Battlements", team = Team.kBlue })
location_batts_red = location_info:new({ text = "Battlements", team = Team.kRed })

location_cp_blue = location_info:new({ text = "Battlements: Cap Side", team = Team.kBlue })
location_cp_red = location_info:new({ text = "Battlements: Cap Side", team = Team.kRed })

location_ele_blue = location_info:new({ text = "Elevator", team = Team.kBlue })
location_ele_red = location_info:new({ text = "Elevator", team = Team.kRed })

location_fd_blue = location_info:new({ text = "Front Door", team = Team.kBlue })
location_fd_red = location_info:new({ text = "Front Door", team = Team.kRed })

location_fr_blue = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_fr_red = location_info:new({ text = "Flagroom", team = Team.kRed })

location_main_blue = location_info:new({ text = "Main Floor", team = Team.kBlue })
location_main_red = location_info:new({ text = "Main Floor", team = Team.kRed })

location_ramps_blue = location_info:new({ text = "Ramps", team = Team.kBlue })
location_ramps_red = location_info:new({ text = "Ramps", team = Team.kRed })

location_resup_blue = location_info:new({ text = "Resupply", team = Team.kBlue })
location_resup_red = location_info:new({ text = "Resupply", team = Team.kRed })

location_shaft_blue = location_info:new({ text = "Shaft", team = Team.kBlue })
location_shaft_red = location_info:new({ text = "Shaft", team = Team.kRed })

location_stairs_blue = location_info:new({ text = "Stairwell", team = Team.kBlue })
location_stairs_red = location_info:new({ text = "Stairwell", team = Team.kRed })

location_water_passage_blue = location_info:new({ text = "Water Tunnel", team = Team.kBlue })
location_water_passage_red = location_info:new({ text = "Water Tunnel", team = Team.kRed })

location_waterway_blue = location_info:new({ text = "Water Tunnel EXIT ONLY", team = Team.kBlue })
location_waterway_red = location_info:new({ text = "Water Tunnel EXIT ONLY", team = Team.kRed })

-- Neutral
location_water = location_info:new({ text = "Water", team = NO_TEAM })
location_yard = location_info:new({ text = "Yard", team = NO_TEAM })
