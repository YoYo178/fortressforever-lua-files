-- ff_escape-facility.lua

IncludeScript("base_teamplay");
IncludeScript("base_location");

function startup()

	SetTeamName( Team.kBlue, "The Survivors" )
	SetTeamName( Team.kRed, "none" )
	SetTeamName( Team.kYellow, "none" )
	SetTeamName( Team.kGreen, "none" )

	SetPlayerLimit( Team.kBlue, 0 ) -- Escape The Abandoned Facility.
	SetPlayerLimit( Team.kRed, -1 ) -- none.	
	SetPlayerLimit( Team.kYellow, -1 ) -- none.
	SetPlayerLimit( Team.kGreen, -1 ) -- none.

	team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

end