IncludeScript("base_ctf");

------------------------------------------
-- jump triggers
------------------------------------------
base_jump = trigger_ff_script:new({ pushx = 0, pushy = 0, pushz = 0 })

-- push people when they touch the trigger
function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		
		player:SetVelocity( Vector( self.pushx, self.pushy, self.pushz ) )
	end
end

-- blueside red ramp
rredjump = base_jump:new({ pushx = -1500, pushy = -1500, pushz = 0  })

--blueside blue ramp
rbluejump = base_jump:new({ pushx = 1500, pushy = 1500, pushz = 0  })

--redside red ramp
lbluejump = base_jump:new({ pushx = -1500, pushy = 1500, pushz = 0  })


--redside blue ramp
lredjump = base_jump:new({ pushx = 1500, pushy = -1500, pushz = 0  })

------------------------------------------
-- Class Limits
------------------------------------------

function startup()
    -- Team limits.
    SetPlayerLimit(Team.kBlue, 0)
    SetPlayerLimit(Team.kRed, 0)
    SetPlayerLimit(Team.kYellow, -1)
    SetPlayerLimit(Team.kGreen, -1)

    -- Blue team limits.
    local team = GetTeam(Team.kBlue)
    team:SetClassLimit(Player.kCivilian, -1)
    team:SetClassLimit(Player.kSniper, -1)
    team:SetClassLimit(Player.kPyro, -1)
    team:SetClassLimit(Player.kEnginner, 1)

    -- Red team limits.
    team = GetTeam(Team.kRed)
    team:SetClassLimit(Player.kCivilian, -1)
    team:SetClassLimit(Player.kSniper, -1)
    team:SetClassLimit(Player.kPyro, -1)
    team:SetClassLimit(Player.kEnginner, 1)

end

------------------------------------------
-- remove projectiles (Credit to Squeek)
-- http://forums.fortress-forever.com/showthread.php?t=19904
------------------------------------------

remove_projectiles = trigger_ff_script:new({ })

function remove_projectiles:allowed(allowed_entity)
	if IsNotProjectile(allowed_entity) then
		return false
	end
	return true
end

function IsNotProjectile( allowed_entity )
	return IsPlayer(allowed_entity) or IsGrenade(allowed_entity) or IsTurret(allowed_entity) or IsDispenser(allowed_entity) or IsSentrygun(allowed_entity) or IsDetpack(allowed_entity)
end

-----------------------------------------------------------------------------
-- Trigger for chasm (Borrowed from ff_haberton's lua, credit to Soylent)
--
-- This removes all entities that I could figure out how to destroy.
--
-- It does not touch players because Respawn()-ing them would destroy turrets
-- jump pads and dispensers.
--
-- It does not touch flags because it cannot. Flags are remove by flag_think(),
-- called every few hundred milliseconds; flag_think respawns flags that fall
-- below a certain z-value.
-----------------------------------------------------------------------------
chasm_trigger = trigger_ff_script:new( )
function chasm_trigger:ontouch( touch_entity )
    if touch_entity then -- Make sure there is legitimate touch_entity.
        if IsPlayer(touch_entity) then return   -- Don't touch players.
        else RemoveEntity( touch_entity )       -- Indiscriminately removes detpacks, grenades, pipes and possible other stuff.
        end
    end
end

-----------------------------------------------------------------------------
-- Kills errant flags. Repeatedly triggered by AddScheduleRepeating from startup every few hundred ms.
-----------------------------------------------------------------------------
function flag_think()
    local rflag = GetInfoScriptByName( "red_flag" )
    
    if rflag then
        local loc = rflag:GetOrigin()
        if ( loc.z < -352 and rflag:IsDropped() ) then
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
        if ( loc.z < -352 and bflag:IsDropped() ) then 
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