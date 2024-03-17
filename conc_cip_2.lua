-----------------------------------------------------------------------------
-- Conc_cip_2.lua modified for zE Palace Servers
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
-- Stuff that trigger resup give
-----------------------------------------------------------------------------

resuppz = trigger_ff_script:new({})

function resuppz:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
			player:AddAmmo(Ammo.kGren2, 4)
			player:AddAmmo( Ammo.kShells, 40 )
			player:AddAmmo( Ammo.kNails, 40 )
		elseif
			player:GetClass() == Player.kPyro then
			player:AddAmmo( Ammo.kCells, 120 )
			player:AddAmmo( Ammo.kGren1, 2 )
			player:AddAmmo( Ammo.kRockets, 40 )
			player:AddAmmo( Ammo.kShells, 40 )
		else
			player:AddAmmo(Ammo.kGren1, 2)
			player:AddAmmo(Ammo.kRockets, 40)
			player:AddAmmo( Ammo.kShells, 40 )
		end
	end
end