IncludeScript("base_ctf");
IncludeScript("base_teamplay");

POINTS_PER_CAPTURE = 10;

function flag_think()
    local rflag = GetInfoScriptByName( "red_flag" )
    if rflag then
        local loc = rflag:GetOrigin()
        if ( loc.z < -1300 and rflag:IsDropped() ) then
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
        if ( loc.z < -1300 and bflag:IsDropped() ) then 
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