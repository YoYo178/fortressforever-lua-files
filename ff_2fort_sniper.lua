
IncludeScript("base_ctf")
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------

function startup()
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 ) 

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )	

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
end


-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60


