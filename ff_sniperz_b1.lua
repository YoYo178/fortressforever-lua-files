
-- ff_sniperz.lua - map by zE

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");
-----------------------
function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)



        local team = GetTeam( Team.kBlue )
       

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 10 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 10 )
	team:SetClassLimit( Player.kCivilian, -1 )

        local team = GetTeam( Team.kRed )
	

        team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 10 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 10 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

-----------------------------------
