-----------------------------------------------------------------------------
-- Team Setup
-----------------------------------------------------------------------------

function startup()

	-- team names
	SetTeamName( Team.kBlue, "Moon Berry's" )
	SetTeamName( Team.kRed, "Fetus's" )
	SetTeamName( Team.kYellow, "Vertical Impact" )
	SetTeamName( Team.kGreen, "Tyrant^vi" )

	-- team limitations
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 ) 
	
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	
	local team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kYellow )
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	local team = GetTeam( Team.kYellow )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	local team = GetTeam( Team.kGreen )
	team:SetAllies( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetAllies( Team.kYellow )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	class = player:GetClass()
	if class == Player.kSoldier or class == Player.kDemoman then
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, -4 )
	else
		player:AddAmmo( Ammo.kGren1, -4 )
		player:AddAmmo( Ammo.kGren2, 4 )
	end
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
end

-----------------------------------------------------------------------------
-- Conc Backpack
-----------------------------------------------------------------------------
zion = info_ff_script:new({
	health = 200,
	armor = 200,
	grenades = 200,
	bullets = 200,
	shells = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	gren2 = 4,
	respawntime = 1,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function zion:dropatspawn() return true end

function zion:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function zion:touch( touch_entity )
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
		if self.gren2 ~= nil then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
	
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

function zion:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- Conc Resupply Zone
-----------------------------------------------------------------------------
--
--trigger_conc = trigger_ff_script:new({})
--
--fuction trigger_conc:ontouch( touch_entity )
--	if IsPlayer( touch_entity ) then
--		local player = CastToPlayer ( touch_entity )
--			class = player:GetClass()
--			if class == Player.kSoldier or class == Player.kDemoman then
--				player:AddAmmo( Ammo.kGren1, 4 )
--				player:AddAmmo( Ammo.kGren2, -4 )
--			else
--				player:AddAmmo( Ammo.kGren1, -4 )
--				player:AddAmmo( Ammo.kGren2, 4 )
--			end
--			player:AddHealth( 400 )
--			player:AddArmor( 400 )
--	
--			player:AddAmmo( Ammo.kNails, 400 )
--			player:AddAmmo( Ammo.kShells, 400 )
--			player:AddAmmo( Ammo.kRockets, 400 )
--			player:AddAmmo( Ammo.kCells, 400 )
--	
--end

-----------------------------------------------------------------------------
-- Spawn Functions
-----------------------------------------------------------------------------
anyspawn = { validspawn = blueallowedmethod, redallowedmethod, yellowallowedmethod, greenallowedmethod }