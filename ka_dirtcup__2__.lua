
--ka_dirtcup - round mode--

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay");


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

DOOR_TIMER = 10
ROUND_TIMER_START = 60
ROUND_TIMER_STOP = 0
ROUND_TIMER_CURRENT = ROUND_TIMER_START
ROUND_TIMER_HUD = 70


text_hudstatusx = 0
text_hudstatusy = 40
text_hudstatusalign = 4



-----------------------------------------------------------------------------
--Initial Stuff
-----------------------------------------------------------------------------

-- precache (sounds)
function precache()
	PrecacheSound("misc.bizwarn")
	PrecacheSound("otherteam.flagstolen")
	
end



function startup()
	-- set up team limits	
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, 0 )
	SetPlayerLimit( Team.kGreen, 0 )


	SetTeamName( Team.kBlue, "Blue Team" )
        SetTeamName( Team.kRed, "Red Team" )
        SetTeamName( Team.kYellow, "Spectators" )
        SetTeamName( Team.kGreen, "Spectators" )



	-- both teams limited to Spy
	for i = Team.kBlue, Team.kRed do
		local team = GetTeam( i )

		team:SetClassLimit( Player.kScout, -1 )
		team:SetClassLimit( Player.kSniper, -1 )
		team:SetClassLimit( Player.kSoldier, -1 )
		team:SetClassLimit( Player.kDemoman, -1 )
		team:SetClassLimit( Player.kMedic, -1 )
		team:SetClassLimit( Player.kHwguy, -1 )
		team:SetClassLimit( Player.kPyro, -1 )
		team:SetClassLimit( Player.kSpy, 0 )
		team:SetClassLimit( Player.kEngineer, -1 )
		team:SetClassLimit( Player.kCivilian, -1 )
	end


	-- both teams limited to Civilian
	for u = Team.kYellow, Team.kGreen do
		local team = GetTeam( u )

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

	-- Start door schedule and warning schedule
	StartDoorWarningSchedule()
	StartDoorOpenSchedule()
	
end



-----------------------------------------------------------------------------
--Player Stuff
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	AddHudText(player, "round_end_text", "Round Timer", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
	AddHudTimer(player, "round_end_timer", ROUND_TIMER_HUD + 1, -1, text_hudstatusx, text_hudstatusy+6, text_hudstatusalign)
	

        class = player:GetClass()
	if class == Player.kSpy then

		player:AddHealth( -55 )
                player:AddArmor( -300 )	
	
		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
		player:RemoveWeapon( "ff_weapon_tranq" )
		player:RemoveWeapon( "ff_weapon_supershotgun" )
		player:RemoveWeapon( "ff_weapon_nailgun" )

		player:SetDisguisable( false )
		player:SetCloakable( false )


        else

		player:AddHealth( 400 )
		player:AddArmor( 400 )

		              
                
	end



        

end


--Dead players stay dead until round ends
function player_killed( killed_entity )
	local player = CastToPlayer( killed_entity )
        
        player:SetRespawnable( false )

	BroadCastMessageToPlayer( player, "Respawn disabled until round ends.." )
	
end

--Disallow suicide
function player_onkill( player )
	
	return false
  	
end

--Remove round timer from hud on teamswitch
--function player_switchteam( player, currentteam, desiredteam )
--    if desiredteam == Team.kSpectator or desiredteam == Team.kYellow or desiredteam == Team.kGreen then
--    	RemoveHudItem( player, round_end_text )
--	RemoveHudItem( player, round_end_timer )
--    end
--    return true
--end







-----------------------------------------------------------------------------
-- Map Schedules 1
-----------------------------------------------------------------------------
--function DoCaptureLogic()
--	
--	DoRoundResetLogic()	
--end

function DoRoundResetLogic()
		

	-- stop round timer schedule if its still going
	DeleteSchedule( "round_timer_schedule" )

	

	-- Reset round timer
	ResetRoundTimer()

	--Remove hud
	update_round_hud()	

	-- close door
	OutputEvent( "blocker", "Enable" )

	-- reset door schedule
	StartDoorOpenSchedule()
        StartDoorWarningSchedule()
	
	-- finally, respawn everybody
	RespawnEveryone()
end





function StartDoorWarningSchedule()
	BroadCastMessage("#FF_MAP_10SECWARN")
	AddSchedule("the_wall_9secwarn", 1, the_wall_9secwarn )
end

function the_wall_9secwarn()
	BroadCastMessage("#FF_MAP_9SECWARN")
	AddSchedule("the_wall_8secwarn", 1, the_wall_8secwarn )
end

function the_wall_8secwarn()
	BroadCastMessage("#FF_MAP_8SECWARN")
	AddSchedule("the_wall_7secwarn", 1, the_wall_7secwarn )
end

function the_wall_7secwarn()
	BroadCastMessage("#FF_MAP_7SECWARN")
	AddSchedule("the_wall_6secwarn", 1, the_wall_6secwarn )
end

function the_wall_6secwarn()
	BroadCastMessage("#FF_MAP_6SECWARN")
	AddSchedule("the_wall_5secwarn", 1, the_wall_5secwarn )
end

function the_wall_5secwarn()
	BroadCastMessage("#FF_MAP_5SECWARN")
	AddSchedule("the_wall_4secwarn", 1, the_wall_4secwarn )
end

function the_wall_4secwarn()
	BroadCastMessage("#FF_MAP_4SECWARN")
	AddSchedule("the_wall_3secwarn", 1, the_wall_3secwarn )
end

function the_wall_3secwarn()
	BroadCastMessage("#FF_MAP_3SECWARN")
	AddSchedule("the_wall_2secwarn", 1, the_wall_2secwarn )
end

function the_wall_2secwarn()
	BroadCastMessage("#FF_MAP_2SECWARN")
	AddSchedule("the_wall_1secwarn", 1, the_wall_1secwarn )
end

function the_wall_1secwarn()
	BroadCastMessage("#FF_MAP_1SECWARN")
end


function StartDoorOpenSchedule()
	
	AddSchedule( "door_open_schedule", DOOR_TIMER, door_open_schedule )
end

function ResetRoundTimer()
	ROUND_TIMER_CURRENT = ROUND_TIMER_START
end

function RespawnEveryone()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
	
end

-----------------------------------------------------------------------------
-- Map Schedules 2
-----------------------------------------------------------------------------
function door_open_schedule()

	round_timer_warning()
		
	OutputEvent( "blocker", "Disable" )

        BroadCastSound("otherteam.flagstolen")	
	
	AddScheduleRepeating( "round_timer_schedule", 1, round_timer_schedule )
	
end


function round_timer_warning()

         AddSchedule( "_halfwarn", 30, _halfwarn )
         

end

function _halfwarn()

	AddSchedule( "_15secondwarn", 15, _15secondwarn ) 
	BroadCastMessage( "30 seconds remaining" )

end


function _15secondwarn()
	
	AddSchedule( "_5secondwarn", 10, _5secondwarn )

	BroadCastMessage( "15 seconds remaining" )
        BroadCastSound("misc.bizwarn")

end

function _5secondwarn()
	
	BroadCastMessage( "5.." )
	SpeakAll("AD_5SEC")

	AddSchedule( "_4secondwarn", 1, _4secondwarn )
end

function _4secondwarn()
	
	BroadCastMessage( "4.." )
	SpeakAll("AD_4SEC")

	AddSchedule( "_3secondwarn", 1, _3secondwarn )
end

function _3secondwarn()
	
	BroadCastMessage( "3.." )
	SpeakAll("AD_3SEC")

	AddSchedule( "_2secondwarn", 1, _2secondwarn )
end

function _2secondwarn()
	
	BroadCastMessage( "2.." )
	SpeakAll("AD_2SEC")

	AddSchedule( "_1secondwarn", 1, _1secondwarn )
end

function _1secondwarn()
	
	BroadCastMessage( "1.." )
	SpeakAll("AD_1SEC")

end




function round_timer_schedule()
	

	-- Adjust round timer
	ROUND_TIMER_CURRENT = ROUND_TIMER_CURRENT - 1

	

	if (ROUND_TIMER_CURRENT < 1) then
		DoRoundResetLogic()
	end	
end

-----------------------------------------------------------
--Hud Timer
-----------------------------------------------------------


function update_round_hud()


	RemoveHudItemFromAll( "round_end_text" )
	RemoveHudItemFromAll( "round_end_timer" )
	
end


-----------------------------------------------------------
--Spawn Protection
-----------------------------------------------------------


KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })
function KILL_KILL_KILL:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red hurts blueteam and vice-versa

red_spawn_protect = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_spawn_protect = KILL_KILL_KILL:new({ team = Team.kRed })


