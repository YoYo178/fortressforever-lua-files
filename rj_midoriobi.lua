IncludeScript("base_location");

location_entrance = location_info:new({text = "The Entrance", team = NO_TEAM})
location_area1 = location_info:new({text = "Area 1 - The Skippin Stones", team = NO_TEAM})
location_area2 = location_info:new({text = "Area 2 - The Rabbit Hole", team = NO_TEAM})
location_area3 = location_info:new({text = "Area 3 - Scaling, the Art", team = NO_TEAM})
location_area4 = location_info:new({text = "Area 4 - Kamikaze", team = NO_TEAM})
location_area5 = location_info:new({text = "Area 5 - Under the Bridge", team = NO_TEAM})
location_area6 = location_info:new({text = "Area 6 - Back to Basics", team = NO_TEAM})
location_area6b = location_info:new({text = "Area6:B - Back to Basics", team = NO_TEAM})
location_area6c = location_info:new({text = "Area6:C - Back to Basics", team = NO_TEAM})
location_area7 = location_info:new({text = "Area 7 - Weapon Master's Path", team = NO_TEAM})
location_area8 = location_info:new({text = "Area 8 - From Dusk till Dawn ", team = NO_TEAM})
location_area8b = location_info:new({text = "Area8:B - From Dusk till Dawn ", team = NO_TEAM})
location_area9 = location_info:new({text = "Area 9 - Sixth Sense", team = NO_TEAM})
location_area10 = location_info:new({text = "Final Area - Kuro Trial", team = NO_TEAM})
location_area10b = location_info:new({text = "FA:B - Kuro Trial", team = NO_TEAM})
location_area10c = location_info:new({text = "FA:C - Kuro Trial", team = NO_TEAM})
location_area10d = location_info:new({text = "FA:D - Kuro Trial", team = NO_TEAM})

-- Disable/Enable Concussion Effect.
CONC_EFFECT = 0

-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

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

	SetTeamName( Team.kBlue, "Disciples" )

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
	OutputEvent("welcome")

end

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end


-----------------------------------------------------------------------------
-- Conc Backpack
-----------------------------------------------------------------------------

fullbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	gren = 4,
	nails = 50,
	shells = 50,
	respawntime = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function fullbackpack:dropatspawn() return true end


function fullbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells)
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

function fullbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function fullbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end


-----------------------------------------------------------------------------
-- Health Backpack
-----------------------------------------------------------------------------

rocketsbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	shells = 50,
	nails = 50,
	gren = 4,
	respawntime = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function rocketsbackpack:dropatspawn() return false end

function rocketsbackpack:precache( )
	-- precache sounds
	--PrecacheSound(self.materializesound)
	--PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end


function rocketsbackpack:touch( touch_entity )
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
		
		if class == Player.kDemoman then
			player:AddAmmo( Ammo.kGren1, 4)
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

function rocketsbackpack:precache( )
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
	rockets = 50,
	shells = 50,
	nails = 50,
	gren = 4,
	respawntime = 0,
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
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
		end
		if class == Player.kSoldier then
			player:RemoveAmmo(Ammo.kRockets, 50)
		end
		
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity)
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound)
				backpack:Respawn(self.respawntime)
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

trigger_stripgrenades = trigger_ff_script:new()

function trigger_stripgrenades:ontouch ( touch_entity )
	local player = CastToPlayer( touch_entity )
	player:AddAmmo (Ammo.kGren1, -4)
	player:AddAmmo (Ammo.kRockets, -50)
end

endzone = trigger_ff_script:new()

function endzone:ontouch( touch_entity )
	local player = CastToPlayer( touch_entity )
	
	ConsoleToAll( player:GetName() .. " has achieved Kuro status." )
	BroadCastMessage( player:GetName() .. " has achieved Kuro status." )
	
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
	
	player:AddFrags( CONC_FRAGS )
	player:AddFortPoints( CONC_POINTS, "Passed Trial" )
end

----------------------------------------------------------------------------
-- Conc Trigger (Gives Ammo, Grenades, HP and ARMOR)
-----------------------------------------------------------------------------

trigger_health = trigger_ff_script:new({})

function trigger_health:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		class = player:GetClass()
		player:AddHealth( 400 )
		player:AddArmor( 400 )
	end
end


------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

area6_ar1 = func_button:new({})
area6_ar2 = func_button:new({})
area6_ar3 = func_button:new({})
area6_cr1 = func_button:new({})
area6_cr2 = func_button:new({})


area6_arl1 = func_button:new({})
area6_arl2 = func_button:new({})
area6_arl3 = func_button:new({})
area6_crl1 = func_button:new({})
area6_crl2 = func_button:new({})


area6_alr1 = func_button:new({})
area6_alr2 = func_button:new({})
area6_alr3 = func_button:new({})
area6_clr1 = func_button:new({})
area6_clr2 = func_button:new({})


area6_all1 = func_button:new({})
area6_all2 = func_button:new({})
area6_all3 = func_button:new({})
area6_cll1 = func_button:new({})
area6_cll2 = func_button:new({})
 
function area6_arl1:ondamage() 
	OutputEvent("area6_door_arl1", "Open" ) 
end

function area6_arl2:ondamage() 
	OutputEvent("area6_door_arl2", "Open" ) 
end

function area6_arl3:ondamage() 
	OutputEvent("area6_door_arl3", "Open" ) 
end

function area6_crl1:ondamage()
	OutputEvent("area6_door_crl1", "Open" )
end

function area6_crl2:ondamage()
	OutputEvent("area6_door_crl2", "Open" )
end

function area6_ar1:ondamage() 
	OutputEvent("area6_door_ar1", "Open" ) 
end

function area6_ar2:ondamage() 
	OutputEvent("area6_door_ar2", "Open" ) 
end

function area6_ar3:ondamage() 
	OutputEvent("area6_door_ar3", "Open" ) 
end

function area6_cr1:ondamage()
	OutputEvent("area6_door_cr1", "Open" )
end

function area6_cr2:ondamage()
	OutputEvent("area6_door_cr2", "Open" )
end

function area6_alr1:ondamage() 
	OutputEvent("area6_door_alr1", "Open" ) 
end

function area6_alr2:ondamage() 
	OutputEvent("area6_door_alr2", "Open" ) 
end

function area6_alr3:ondamage() 
	OutputEvent("area6_door_alr3", "Open" ) 
end

function area6_clr1:ondamage()
	OutputEvent("area6_door_clr1", "Open" )
end

function area6_clr2:ondamage()
	OutputEvent("area6_door_clr2", "Open" )
end


function area6_all1:ondamage() 
	OutputEvent("area6_door_all1", "Open" ) 
end

function area6_all2:ondamage() 
	OutputEvent("area6_door_all2", "Open" ) 
end

function area6_all3:ondamage() 
	OutputEvent("area6_door_all3", "Open" ) 
end

function area6_cll1:ondamage()
	OutputEvent("area6_door_cll1", "Open" )
end

function area6_cll2:ondamage()
	OutputEvent("area6_door_cll2", "Open" )
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

area9_btn_rl1 = func_button:new({})
area9_btn_rl2 = func_button:new({})
area9_btn_rr1 = func_button:new({})
area9_btn_rr2 = func_button:new({})


function area9_btn_rl1:ondamage()
	OutputEvent("area9_door_rl1", "Open" )
end

function area9_btn_rl2:ondamage()
	OutputEvent("area9_door_rl2", "Open" )
end

function area9_btn_rr1:ondamage()
	OutputEvent("area9_door_rr1", "Open" )
end

function area9_btn_rr2:ondamage()
	OutputEvent("area9_door_rr2", "Open" )
end

area9_btn_ll1 = func_button:new({})
area9_btn_ll2 = func_button:new({})
area9_btn_lr1 = func_button:new({})
area9_btn_lr2 = func_button:new({})


function area9_btn_ll1:ondamage()
	OutputEvent("area9_door_ll1", "Open" )
end

function area9_btn_ll2:ondamage()
	OutputEvent("area9_door_ll2", "Open" )
end

function area9_btn_lr1:ondamage()
	OutputEvent("area9_door_lr1", "Open" )
end

function area9_btn_lr2:ondamage()
	OutputEvent("area9_door_lr2", "Open" )
end
-----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

area10_btn_r1 = func_button:new({})

function area10_btn_r1:ondamage()
	OutputEvent("area10_door_r1", "Open" )
end
