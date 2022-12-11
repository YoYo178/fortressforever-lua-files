IncludeScript("base_location");

location_area1 = location_info:new({text = "Area 1 - The Classic", team = NO_TEAM})
location_area2 = location_info:new({text = "Area 2 - Quadangular", team = NO_TEAM})
location_area3 = location_info:new({text = "Area 3 - Precision 101", team = NO_TEAM})
location_area4 = location_info:new({text = "Area 4 - Be the Dolphin", team = NO_TEAM})
location_area5 = location_info:new({text = "Area 5 - Like a Record", team = NO_TEAM})
location_area6 = location_info:new({text = "Area 6 - Out of Order", team = NO_TEAM})
location_area7 = location_info:new({text = "Area 7 - The Stair Master", team = NO_TEAM})
location_area8 = location_info:new({text = "Area 8 - Mario Style", team = NO_TEAM})
location_area9 = location_info:new({text = "Area 9 - That Sinking Feeling", team = NO_TEAM})
location_area10 = location_info:new({text = "Area 10 - Ace in the Hole", team = NO_TEAM})
location_area11 = location_info:new({text = "Area 11 - The Triple", team = NO_TEAM})
location_area12 = location_info:new({text = "Area 12 - The Triple...Wha?", team = NO_TEAM})
location_area13 = location_info:new({text = "Area 13 - All Together Now", team = NO_TEAM})
location_area14 = location_info:new({text = "Final Area - Tricky", team = NO_TEAM})

--Modified base_conc below

-- Disable/Enable Concussion Effect.
CONC_EFFECT = 1

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
SCOUT = 0
MEDIC = 0
DEMOMAN = 1
ENGINEER = 0
PYRO = 1
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

	SetTeamName( Team.kBlue, "Rocketeers" )

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
-- Health Backpack
-----------------------------------------------------------------------------

rocketsbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	gren = 4,
	respawntime = 1,
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
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, -4)
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
	
	ConsoleToAll( player:GetName() .. " has earned the title 'Rocketeer'" )
	BroadCastMessage( player:GetName() .. " has earned the title 'Rocketeer'" )
	
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
		player:AddHealth( 400 )
		player:AddArmor( 400 )
	end
end

------------------------------------------
--button code
------------------------------------------
area6_btn_la = func_button:new({})
area6_btn_lb = func_button:new({})
area6_btn_ra = func_button:new({})
area6_btn_rb = func_button:new({})

function area6_btn_la:ondamage()
	OutputEvent("area6_door_la", "Open")
end

function area6_btn_lb:ondamage()
	OutputEvent("area6_door_lb", "Open")
end

function area6_btn_ra:ondamage()
	OutputEvent("area6_door_ra", "Open")
end

function area6_btn_rb:ondamage()
	OutputEvent("area6_door_rb", "Open")
end

area13_btn_la2 = func_button:new({})
area13_btn_lb2 = func_button:new({})
area13_btn_ra2 = func_button:new({})
area13_btn_rb2 = func_button:new({})

function area13_btn_la2:ondamage()
	OutputEvent("area13_door_la2", "Open")
end

function area13_btn_lb2:ondamage()
	OutputEvent("area13_door_lb2", "Open")
end

function area13_btn_ra2:ondamage()
	OutputEvent("area13_door_ra2", "Open")
end

function area13_btn_rb2:ondamage()
	OutputEvent("area13_door_rb2", "Open")
end
