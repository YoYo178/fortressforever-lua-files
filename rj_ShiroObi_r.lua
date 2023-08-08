IncludeScript("base_location");

location_teleport = location_info:new({text = "Jump Select Screen", team = NO_TEAM})
location_jump1 = location_info:new({text = "Jump 1 - Across the River", team = NO_TEAM})
location_jump2 = location_info:new({text = "Jump 2 - Double Up", team = NO_TEAM})
location_jump3 = location_info:new({text = "Jump 3 - Timing Your Senses", team = NO_TEAM})
location_jump4 = location_info:new({text = "Jump 4 - Around the Corner", team = NO_TEAM})
location_jump5 = location_info:new({text = "Jump 5 - Dolphin Technique", team = NO_TEAM})
location_jump6 = location_info:new({text = "Jump 6 - Dolphin Evolved", team = NO_TEAM})
location_jump7 = location_info:new({text = "Jump 7 - Ricochet", team = NO_TEAM})
location_jump8 = location_info:new({text = "Jump 8 - Kiiro Ichi ", team = NO_TEAM})
location_jump9 = location_info:new({text = "Jump 9 - Kiiro Ni", team = NO_TEAM})
location_jump10 = location_info:new({text = "Jump 10 - Aka Ichi", team = NO_TEAM})
location_jump11 = location_info:new({text = "Jump 11 - Aka Ni", team = NO_TEAM})
location_jump12 = location_info:new({text = "Jump 12 - Midori Obi Trial", team = NO_TEAM})

--Modified base_conc below

-- Disable/Enable Concussion Effect.
CONC_EFFECT = 1

-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

-- Freestyle / Race modes.
CONC_MODE = CONC_FREESTYLE

-- Race Restart Delay
RESTART_DELAY = 0

-- Points and Frags you receive for touching EndZone.
CONC_POINTS = 100
CONC_FRAGS = 50

-- Disable/Enable classes allowed.
SOLDIER = 1
SCOUT = 1
MEDIC = 1
DEMOMAN = 1
ENGINEER = 0
PYRO = 0
SNIPER = 0
HWGUY = 0

-- Disable/Enable Invunerability
INVUL = 0

---------------------------------
-- DO NOT CHANGE THESE
---------------------------------
reached_end = 0
CONC_FREESTYLE = 0
CONC_RACE = 0
---------------------------------

function startup()

	SetTeamName( Team.kBlue, "Jumpers" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, -1 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	ShouldEnableClass( team, SOLDIER, Player.kSoldier )
	ShouldEnableClass( team, DEMOMAN, Player.kDemoman )
	ShouldEnableClass( team, PYRO, Player.kPyro )
	ShouldEnableClass( team, ENGINEER, Player.kEngineer )

end

function ShouldEnableClass( team, classtype, class )
	if classtype == 1 then
		team:SetClassLimit( class, 0 )
	else
		team:SetClassLimit( class, -1 )
	end
end

-----------------------------------------------------------------------------
-- Ammo Check
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kGren1, -4)
	player:AddAmmo( Ammo.kGren2, -4)
	
	--class = player:GetClass()
	--if class == Player.kSoldier or class == Player.kDemoman then
		--player:AddAmmo( Ammo.kGren1, 4 )
		--player:AddAmmo( Ammo.kGren2, -4 )
	--else
		--player:AddAmmo( Ammo.kGren1, -4 )
		--player:AddAmmo( Ammo.kGren2, 4 )
	--end

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kRockets, 30 )
	player:AddAmmo( Ammo.kNails, 200 )

end

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end

-----------------------------------------------------------------------------
-- Conc Backpack
-----------------------------------------------------------------------------

concbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	gren = 4,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function concbackpack:dropatspawn() return true end

function concbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
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

function concbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function concbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- Health Backpack
-----------------------------------------------------------------------------

healthbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	gren = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function healthbackpack:dropatspawn() return false end

function healthbackpack:precache( )
	-- precache sounds
	--PrecacheSound(self.materializesound)
	--PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function healthbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			player:AddAmmo( Ammo.kGren1, -4)
			player:AddAmmo( Ammo.kGren2, -4)
			--dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
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

function healthbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end
--grenades ONLY pack, no rockets
grenbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = -400,
	gren = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function grenbackpack:dropatspawn() return false end

function grenbackpack:precache( )
	-- precache sounds
	--PrecacheSound(self.materializesound)
	--PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function grenbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		player:AddAmmo (Ammo.kRockets, -400)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
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
end--------

function grenbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end
-- End Zone Entity
-----------------------------------------------------------------------------

stripGrenades = trigger_ff_script:new()

function stripGrenades:ontouch ( touch_entity )
	local player = CastToPlayer( touch_entity )
	player:AddAmmo (Ammo.kGren1, -4)
	player:AddAmmo (Ammo.kRockets, -50)
end

endzone = trigger_ff_script:new()

function endzone:ontouch( touch_entity )
	local player = CastToPlayer( touch_entity )
	
	ConsoleToAll( player:GetName() .. " has achieved Midori status." )
	BroadCastMessage( player:GetName() .. " has achieved Midori status." )
	
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
	
	player:AddFrags( CONC_FRAGS )
	player:AddFortPoints( CONC_POINTS, "Passed Trial" )
end

----------------------------------------------------------------------------
-- Conc Trigger (Gives Ammo, Grenades, HP and ARMOR)
-----------------------------------------------------------------------------

trigger_conc = trigger_ff_script:new({})

function trigger_conc:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			player:AddAmmo(Ammo.kGren1, self.gren)
		else
			player:AddAmmo(Ammo.kGren2, self.gren)
		end
		player:AddHealth( 400 )
		player:AddArmor( 400 )
	end
end