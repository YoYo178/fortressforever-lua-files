-----------------------------------------------------------------------------
-- ff_juggleface.lua modified for zE Palace Servers
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");
IncludeScript("power_quad");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- Cvars specific for zE Palace servers, if you dont have those plugins remove this part or might crash your server!
-----------------------------------------------------------------------------

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

-----------------------------------------------------------------------------
-- Teams
-----------------------------------------------------------------------------

function startup()
SetTeamName( Team.kBlue, "Conc" )
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
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- RED TEAM
local team = GetTeam( Team.kRed )
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, -1 )

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

grenadebackpack = info_ff_script:new({
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

function grenadebackpack:touch( touch_entity )
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

-----------------------------------------------------------------------------
-- Make sound on bag respawn
-----------------------------------------------------------------------------

function grenadebackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function grenadebackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- Put the resup bags at ground level
-----------------------------------------------------------------------------

function grenadebackpack:dropatspawn() return true end

-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

location_ground = location_info:new({ text = "Ground", team = NO_TEAM })
location_stage1 = location_info:new({ text = "Stage 1", team = NO_TEAM })
location_stage2 = location_info:new({ text = "Stage 2", team = NO_TEAM })
location_stage3 = location_info:new({ text = "Stage 3", team = NO_TEAM })
location_stage4 = location_info:new({ text = "Stage 4", team = NO_TEAM })
location_stage5 = location_info:new({ text = "Stage 5", team = NO_TEAM })
location_stage6 = location_info:new({ text = "Stage 6", team = NO_TEAM })
location_stage7 = location_info:new({ text = "Stage 7", team = NO_TEAM })
location_stage8 = location_info:new({ text = "Stage 8", team = NO_TEAM })
location_stage9 = location_info:new({ text = "Stage 9", team = NO_TEAM })
location_stage10 = location_info:new({ text = "Stage 10", team = NO_TEAM })
location_stage11 = location_info:new({ text = "Stage 11", team = NO_TEAM })
location_stage12 = location_info:new({ text = "Stage 12", team = NO_TEAM })
location_stage13 = location_info:new({ text = "Stage 13", team = NO_TEAM })
location_stage14 = location_info:new({ text = "Stage 14", team = NO_TEAM })
location_top = location_info:new({ text = "Top", team = NO_TEAM })

-----------------------------------------------------------------------------
-- Conc Trigger (Gives Ammo, Grenades, HP and ARMOR)
-----------------------------------------------------------------------------

conc_resup = trigger_ff_script:new({})

function conc_resup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
			player:AddAmmo(Ammo.kGren2, 4)
			player:AddAmmo( Ammo.kShells, 40 )
			player:AddAmmo( Ammo.kNails, 40 )
		elseif  player:GetClass() == Player.kPyro then
			player:AddAmmo( Ammo.kCells, 120 )
			player:AddAmmo( Ammo.kGren1, 2 )
			player:AddAmmo( Ammo.kRockets, 40 )
			player:AddAmmo( Ammo.kShells, 40 )
		elseif  player:GetClass() == Player.kEngineer then
			player:AddAmmo( Ammo.kGren1, 2 )
			player:AddAmmo( Ammo.kNails, 40 )
			player:AddAmmo( Ammo.kShells, 40 )
			player:AddAmmo( Ammo.kCells, 120 )
		else
			player:AddAmmo(Ammo.kGren1, 2)
			player:AddAmmo(Ammo.kRockets, 40)
			player:AddAmmo( Ammo.kShells, 40 )
		end
	end
end


