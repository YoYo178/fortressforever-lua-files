-----------------------------------------------------------------------------
-- Conc_fatal.lua modified for zE Palace Servers
-----------------------------------------------------------------------------

IncludeScript("base_location");
IncludeScript("base_teamplay");
IncludeScript("power_quad");

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
-- Disable conc effect
-----------------------------------------------------------------------------

CONC_EFFECT = 0

function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
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
		elseif class == Player.kSniper then
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
-- Stuff from the original lua
-----------------------------------------------------------------------------

conctrigger1 = set_jumppos:new({pos = 1, pointmsg = '1st Checkpoint', points = 25})
conctrigger2 = set_jumppos:new({pos = 2, pointmsg = '2nd Checkpoint', points = 50})
conctrigger3 = set_jumppos:new({pos = 3, pointmsg = '3rd Checkpoint', points = 10})
conctrigger4 = set_jumppos:new({pos = 4, pointmsg = '4th Checkpoint', points = 75})
conctrigger5 = set_jumppos:new({pos = 5, pointmsg = '5th Checkpoint', points = 30})
conctrigger6 = set_jumppos:new({pos = 6, pointmsg = '6th Checkpoint', points = 10})
conctrigger7 = set_jumppos:new({pos = 7, pointmsg = '7th Checkpoint', points = 25})
conctrigger8 = set_jumppos:new({pos = 8, pointmsg = '8th Checkpoint', points = 125})
conctrigger9 = set_jumppos:new({pos = 9, pointmsg = '9th Checkpoint', points = 150})
conctrigger10 = set_jumppos:new({pos = 10, pointmsg = '10th Checkpoint', points = 100})
conctrigger11 = set_jumppos:new({pos = 11, pointmsg = '11th Checkpoint', points = 255})
conctrigger12 = set_jumppos:new({pos = 12, pointmsg = '12th Checkpoint', points = 505})
conctrigger13 = set_jumppos:new({pos = 13, pointmsg = '13th Checkpoint', points = 750})
conctrigger14 = set_jumppos:new({pos = 14, pointmsg = '14th Checkpoint', points = 100})
conctrigger15 = set_jumppos:new({pos = 15, pointmsg = '15th Checkpoint', points = 100})
conctrigger16 = set_jumppos:new({pos = 16, pointmsg = '16th Checkpoint', points = 1000})
conctrigger17 = set_jumppos:new({pos = 17, pointmsg = '17th Checkpoint', points = 1000})
conctrigger18 = set_jumppos:new({pos = 18, pointmsg = '18th Checkpoint', points = 100})
conctrigger19 = set_jumppos:new({pos = 19, pointmsg = '19th Checkpoint', points = 1050})
conctrigger20 = set_jumppos:new({pos = 20, pointmsg = '20th Checkpoint', points = 100})
conctrigger21 = set_jumppos:new({pos = 21, pointmsg = '21st Checkpoint', points = 100})
conctrigger22 = set_jumppos:new({pos = 22, pointmsg = '22nd Checkpoint', points = 100})
conctrigger23 = set_jumppos:new({pos = 23, pointmsg = '23rd Checkpoint', points = 100})
conctrigger24 = set_jumppos:new({pos = 24, pointmsg = '24th Checkpoint', points = 100})
conctrigger25 = set_jumppos:new({pos = 25, pointmsg = '25th Checkpoint', points = 100})
conctrigger26 = set_jumppos:new({pos = 26, pointmsg = '26th Checkpoint', points = 100})
conctrigger27 = set_jumppos:new({pos = 27, pointmsg = 'THE END! =D', points = 69})
conctrigger28 = set_jumppos:new({pos = 28, pointmsg = 'Surf Bowl!!', points = 69})
conctrigger29 = set_jumppos:new({pos = 29, pointmsg = '29th Checkpoint', points = 100})
conctrigger30 = set_jumppos:new({pos = 30, pointmsg = '30th Checkpoint', points = 100})