IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("power_quad");


SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

-- concpillar_b3.lua

function startup()
SetTeamName( Team.kBlue, "Blue Team" )
SetTeamName( Team.kRed, "Quad" )
SetTeamName( Team.kYellow, "Double" )
SetTeamName( Team.kGreen, "Easy Quad" )

SetPlayerLimit( Team.kBlue, 0 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, 0 )
SetPlayerLimit( Team.kGreen, 0 )

-- BLUE TEAM
local team = GetTeam( Team.kBlue )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, 0 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- RED TEAM
local team = GetTeam( Team.kRed )
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, 0 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, 0 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, 0 )

-- Yellow TEAM
local team = GetTeam( Team.kYellow )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- Green TEAM
local team = GetTeam( Team.kGreen )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

end


-----------------------------------------------------------------------------
-- Stuff that resup bags give
-----------------------------------------------------------------------------

concbackpack = info_ff_script:new({
	rockets = 50,
	gren = 4,
	shells = 60,
	cells = 60,
	nails = 60,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function concbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kPyro then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kSniper then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kSpy then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kEngineer then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
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
-- Make sound on bag respawn
-----------------------------------------------------------------------------

function concbackpack:dropatspawn() return true end

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

--
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end