-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

---------------------
-- Global Overrides
---------------------

POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 30;

-- Edit the teams name if u want 

function startup()
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kBlue, "Blue Team" )
	SetTeamName( Team.kRed, "Red Team" )


	-- Blue Team Class limits
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 2 )
	
	-- Red Team class limits
	team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 2 )
end

-----------------------------------------------------------------------------
-- bagless resupply
-----------------------------------------------------------------------------
aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- aardvark lasers and respawn shields
-----------------------------------------------------------------------------
red_aardvarksec = red_security_trigger:new()
blue_aardvarksec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
lasers_KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function lasers_KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			if self.team == Team.kBlue then
				if redsecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
			if self.team == Team.kRed then
				if bluesecstatus == 1 then
					return EVENT_ALLOWED
				end
			end
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
sec_blue_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kBlue })
sec_red_slayer = lasers_KILL_KILL_KILL:new({ team = Team.kRed })
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
function flag_think()
    local rflag = GetInfoScriptByName( "red_flag" )
    if rflag then
        local loc = rflag:GetOrigin()
        if ( loc.z < -300 and rflag:IsDropped() ) then
            -- The red flag is dropped and in a bad location.
            -- Modified copy-paste from base_flag:onreturn to get the standardized look and feel.
            -- I would have expected base_flag:Return to call base_flag:onreturn but it does not and I cannot.
            
            -- Message that the flag has been returned. 
            local team = GetTeam( Team.kRed )
            SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", Color.kYellow, Color.kYellow)
            SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
            SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
            
            -- Clean up.
            RemoveHudItemFromAll( rflag:GetName() .. "location" ) -- Remove flag location.
            rflag:Return() -- Return to spawn.
            LogLuaEvent(0, 0, "flag_returned","flag_name",rflag:GetName()); -- Log event.
            rflag:refreshStatusIcons(rflag:GetName())  -- Refresh flag-status icons
        end
    end

    local bflag = GetInfoScriptByName( "blue_flag" )    
    if bflag then
        local loc = bflag:GetOrigin()
        if ( loc.z < -300 and bflag:IsDropped() ) then 
            -- The blue flag is dropped and in a bad location.
            -- Modified copy-paste from base_flag:onreturn to get the standardized look and feel.
            -- I would have expected base_flag:Return to call base_flag:onreturn but it does not and I cannot.
            
            -- Message that the flag has been returned. 
            local team = GetTeam( Team.kBlue )
            SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", Color.kYellow, Color.kYellow)
            SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
            SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
            
            -- Clean up.
            RemoveHudItemFromAll( bflag:GetName() .. "location" ) -- Remove flag location.
            bflag:Return() -- Return to spawn.
            LogLuaEvent(0, 0, "flag_returned","flag_name",bflag:GetName()); -- Log event.
            bflag:refreshStatusIcons(bflag:GetName())  -- Refresh flag-status icons
        end
    end
end

-- Schedule a repeating flag check. If the flag is in the pit then it should be returned.
    AddScheduleRepeating( "flag loop", 0.2, flag_think )
