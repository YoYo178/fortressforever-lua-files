--IncludeScript("base_soldierarena")
IncludeScript("base_teamplay");

function startup()
	-- set up team limits (only red & blue)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

       local team = GetTeam(Team.kBlue)
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kHwguy, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kEngineer, 0 )
team:SetClassLimit( Player.kCivilian, -1 )

team = GetTeam(Team.kRed)
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kHwguy, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kEngineer, 0 )
team:SetClassLimit( Player.kCivilian, -1 )



end

