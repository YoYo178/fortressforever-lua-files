-- ff_talos_warehouse.lua
-----------------------------------------------------------------------------
-- a custom alternate lua made by -_YoYo178_- (a edited version of ff_aardvark.lua)
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_LENGTH = 30;

-----------------------------------------------------------------------------
-- set class limits
-----------------------------------------------------------------------------
local startup_base = startup or function() end
function startup()
	startup_base()

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)
end

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = red_security_trigger:new()
blue_aardvarksec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_aardvarkdoorhack")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Disable")

	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
end

local security_on_base = security_on
function security_on( team )
	security_on_base( team )

	CloseDoor(team.."_aardvarkdoorhack")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Enable")
end

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------
Blue_Slayer = not_red_trigger:new({team = Team.kRed})
Red_slayer = not_blue_trigger:new({team = Team.kBlue})
sec_blue_slayer = not_red_trigger:new()
sec_red_slayer = not_blue_trigger:new()

