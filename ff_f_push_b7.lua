-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_push");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

local orig_startup = startup

function startup()
	-- set up team names.  Localisation? 
	SetTeamName( Team.kBlue, "Blue - Fortification" )
	SetTeamName( Team.kRed, "Red - Fortification" )

	orig_startup()
end