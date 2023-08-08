IncludeScript("base_ctf");
IncludeScript("base_shutdown");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Offensive and Defensive Spawns
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Feel free to reuse this if needed.
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- plasma resupply (bagless)
-----------------------------------------------------------------------------
plasmaresup = trigger_ff_script:new({ team = Team.kUnassigned })

function plasmaresup:ontouch( touch_entity )
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

blue_plasmaresup = plasmaresup:new({ team = Team.kBlue })
red_plasmaresup = plasmaresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

phantompack = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 50,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function phantompack:dropatspawn() return false end

red_phantompack = phantompack:new({ touchflags = {AllowFlags.kRed} })
blue_phantompack = phantompack:new({ touchflags = {AllowFlags.kBlue} })

concpack = genericbackpack:new({
	health = 0,
	armor = 0,
	mancannons = 1,
	gren1 = 0,
	gren2 = 2,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function concpack:dropatspawn() return false end

red_concpack = concpack:new({ touchflags = {AllowFlags.kRed} })
blue_concpack = concpack:new({ touchflags = {AllowFlags.kBlue} })

-----------------------------------------------------------------------------
-- phantom lasers and respawn shields
-----------------------------------------------------------------------------
KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red hurts blueteam and vice-versa

red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })

-- airlift

blue_air_lift_button = func_button:new({})
function blue_air_lift_button:ondamage() OutputEvent( "blue_air_lift_push", "Enable" ) end
function blue_air_lift_button:ondamage() OutputEvent( "blue_air_lift_push", "Disable", "4.0" ) end
function blue_air_lift_button:ondamage() OutputEvent( "bfan", "start" ) end
function blue_air_lift_button:ondamage() OutputEvent( "bfan", "stop", "4.0" ) end
function blue_air_lift_button:ontouch() OutputEvent( "blue_air_lift_push", "Enable" ) end
function blue_air_lift_button:ontouch() OutputEvent( "blue_air_lift_push", "Disable", "4.0" ) end 
function blue_air_lift_button:ontouch() OutputEvent( "bfan", "start" ) end
function blue_air_lift_button:ontouch() OutputEvent( "bfan", "stop", "4.0" ) end

blue_air_lift_button1 = func_button:new({})
function blue_air_lift_button1:ondamage() OutputEvent( "blue_air_lift_push1", "Open" ) end
function blue_air_lift_button1:ondamage() OutputEvent( "blue_air_lift_push1", "Close", "6.0" ) end
function blue_air_lift_button1:ontouch() OutputEvent( "blue_air_lift_push1", "Open" ) end
function blue_air_lift_button1:ontouch() OutputEvent( "blue_air_lift_push1", "close", "6.0" ) end 

red_air_lift_button = func_button:new({})
function red_air_lift_button:ondamage() OutputEvent( "red_air_lift_push", "Enable" ) end
function red_air_lift_button:ondamage() OutputEvent( "red_air_lift_push", "Disable", "4.0" ) end
function red_air_lift_button:ondamage() OutputEvent( "rfan", "start" ) end
function red_air_lift_button:ondamage() OutputEvent( "rfan", "stop", "4.0" ) end
function red_air_lift_button:ontouch() OutputEvent( "red_air_lift_push", "Enable" ) end
function red_air_lift_button:ontouch() OutputEvent( "red_air_lift_push", "Disable", "4.0" ) end 
function red_air_lift_button:ontouch() OutputEvent( "rfan", "start" ) end
function red_air_lift_button:ontouch() OutputEvent( "rfan", "stop", "4.0" ) end

red_air_lift_button1 = func_button:new({})
function red_air_lift_button1:ondamage() OutputEvent( "red_air_lift_push1", "Open" ) end
function red_air_lift_button1:ondamage() OutputEvent( "red_air_lift_push1", "Close", "6.0" ) end
function red_air_lift_button1:ontouch() OutputEvent( "red_air_lift_push1", "Open" ) end
function red_air_lift_button1:ontouch() OutputEvent( "red_air_lift_push1", "close", "6.0" ) end 

grenpack = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 00,
	nails = 000,
	shells = 000,
	rockets = 00,
	cells = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
