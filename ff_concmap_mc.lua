-- ff_concmpa_mc.lua

----------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");

-- Disable/Enable Concussion Effect.
CONC_EFFECT = 0

-- Freestyle / Race modes.
CONC_MODE = CONC_FREESTYLE

-- Race Restart Delay
RESTART_DELAY = 10

-- Points and Frags you receive for touching EndZone.
CONC_POINTS = 110
CONC_FRAGS = 10

reached_end = 0
CONC_FREESTYLE = 0
CONC_RACE = 1

-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then return EVENT_DISALLOWED end
	return EVENT_ALLOWED
end

-----------------------------------------------------------------------------
-- Team settings
-----------------------------------------------------------------------------

function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	SetTeamName(Team.kBlue, "Concers")

-----------------------------------------------------------------------------
-- Class Settings
-----------------------------------------------------------------------------

local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kDemoman, -1)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSoldier, -1)
	team:SetClassLimit(Player.kHwguy, -1)
	team:SetClassLimit(Player.kSpy, -1)
	team:SetClassLimit(Player.kSniper, -1)
	team:SetClassLimit(Player.kPyro, -1)
	team:SetClassLimit(Player.kEngineer, -1)

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
	model = "models/grenades/conc/conc.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function concbackpack:dropatspawn() return true end

function concbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

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

trigger_conc = trigger_ff_script:new({})
function trigger_conc:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
local player = CastToPlayer( touch_entity )
local class = player:GetClass()
if class == Player.kScout or class == Player.kMedic then
player:AddAmmo( Ammo.kGren2, 4 )
end
end
end

location_jump1 = location_info:new({ text = "Jump 1", team = Team.kBlue })
location_jump2 = location_info:new({ text = "Jump 2", team = Team.kBlue })
location_jump3 = location_info:new({ text = "Jump 3", team = Team.kBlue })
location_jump4 = location_info:new({ text = "Jump 4", team = Team.kBlue })
location_jump5 = location_info:new({ text = "Jump 5", team = Team.kBlue })
location_jump6 = location_info:new({ text = "Jump 6", team = Team.kBlue })
location_jump7 = location_info:new({ text = "Jump 7", team = Team.kBlue })
location_jump8 = location_info:new({ text = "Jump 8", team = Team.kBlue })
location_jump9 = location_info:new({ text = "Jump 9", team = Team.kBlue })
location_jump10 = location_info:new({ text = "Jump 10", team = Team.kBlue })
location_jumpextra = location_info:new({ text = "Well done you have finished the map grats", team = Team.kBlue })

function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
    player:RemoveAmmo( Ammo.kGren1, 4 )
    player:RemoveAmmo( Ammo.kGren2, 4 )
    local class = player:GetClass()
    
    if class == Player.kScout or class == Player.kMedic then
	player:AddArmor( 400 )
	player:AddAmmo( Ammo.kGren2, 4 )
    end
end

