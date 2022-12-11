---------------------------------------------
-- Includes
---------------------------------------------

IncludeScript("base_teamplay");

---------------------------------------------
-- Globals
---------------------------------------------

blue = Team.kBlue
red = Team.kRed

RESTOCK_ITERATION_TIME = 10
POINTS_PER_GOAL = 1
POINTS_TO_WIN = 11
MUST_WIN_BY = 2

function precache()
	PrecacheSound("misc.dadeda")
	PrecacheSound("misc.doop")
end

---------------------------------------------
-- Main Section
---------------------------------------------

function startup()

    SetGameDescription("Car Soccer")
	
   -- Set Team Names
   
    SetTeamName(Team.kBlue, "Blue Orcas")
    SetTeamName(Team.kRed, "Red Gazelles")
    SetTeamName(Team.kYellow, "NONE")
    SetTeamName(Team.kGreen, "NONE")

   -- Set Player Limits
    SetPlayerLimit(Team.kBlue, 0)
    SetPlayerLimit(Team.kRed, 0)
    SetPlayerLimit(Team.kYellow, -1)
    SetPlayerLimit(Team.kGreen, -1)

   -- Set Class Limits
    team = GetTeam(Team.kBlue)
        team:SetClassLimit(Player.kScout, -1)
        team:SetClassLimit(Player.kSoldier, -1)
        team:SetClassLimit(Player.kPyro, -1)
        team:SetClassLimit(Player.kDemoman, -1)
        team:SetClassLimit(Player.kHwguy, -1)
        team:SetClassLimit(Player.kEngineer, -1)
        team:SetClassLimit(Player.kMedic, -1)
        team:SetClassLimit(Player.kSniper, -1)
        team:SetClassLimit(Player.kSpy, -1)
        team:SetClassLimit(Player.kCivilian, 0)

    team = GetTeam(Team.kRed)
        team:SetClassLimit(Player.kScout, -1)
        team:SetClassLimit(Player.kSoldier, -1)
        team:SetClassLimit(Player.kPyro, -1)
        team:SetClassLimit(Player.kDemoman, -1)
        team:SetClassLimit(Player.kHwguy, -1)
        team:SetClassLimit(Player.kEngineer, -1)
        team:SetClassLimit(Player.kMedic, -1)
        team:SetClassLimit(Player.kSniper, -1)
        team:SetClassLimit(Player.kSpy, -1)
        team:SetClassLimit(Player.kCivilian, 0)
end

---------------------------------------------
-- Immortal Players
---------------------------------------------

function player_ondamage(player, damageinfo)
  
	damageinfo:ScaleDamage(0)

	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then 
	    return 
	end

	-- If player killed self or teammate do nothing
	if (player:GetId() ~= player_attacker:GetId() and player:GetTeamId() == player_attacker:GetTeamId()) or player:GetTeamId() ~= player_attacker:GetTeamId() then
		damageinfo:SetDamageForce(Vector(0,0,0))
		return
	end

end

---------------------------------------------
-- Goal Things
---------------------------------------------

base_goaltrigger = trigger_ff_script:new({team = Team.kUnassigned, scoringteam = Team.kUnassigned})

function base_goaltrigger:allowed(entity)
        if entity:GetId() == GetEntityByName("ball"):GetId() then
           return EVENT_ALLOWED
        else
           return EVENT_DISALLOWED
        end
end

function base_goaltrigger:ontrigger(entity)
        local target = GetEntityByName("teleport_target")
        local target_pos = target:GetOrigin()
        local target_angle = target:GetAngles()
        entity:Teleport(target_pos, target_angle, Vector(0,0,0))
		OutputEvent("ball", "Sleep")
					
end

function base_goaltrigger:ontouch(touch_entity)
	if touch_entity:GetId() == GetEntityByName( "ball" ):GetId() then
		local team = GetTeam(self.team)
		local scoringteam = GetTeam(self.scoringteam)
	
		scoringteam:AddScore( POINTS_PER_GOAL )
		local yourteam = "Your team scored a point!"
		local enemyteam = "The enemy team scored a point!"
		SmartTeamSound( scoringteam, "misc.doop", "misc.dadeda" )
		SmartTeamMessage( scoringteam, yourteam, enemyteam, Color.kGreen, Color.kRed )
		CheckForWinner()
	end
end

function CheckForWinner()
	local team1 = GetTeam(blue)
	local team2 = GetTeam(red)
	local team1_score = team1:GetScore()
	local team2_score = team2:GetScore()
	
	if team1_score >= POINTS_TO_WIN and team1_score - team2_score >= MUST_WIN_BY then
		GameWon(team1)
		SpeakAll("WIN_BLUE")
	elseif team2_score >= POINTS_TO_WIN and team2_score - team1_score >= MUST_WIN_BY then
		GameWon(team2)
		SpeakAll("WIN_RED")
	elseif team1_score >= POINTS_TO_WIN-1 and team1_score - team2_score >= MUST_WIN_BY-1 then
		ChatToAll("Game point for ^"..(team1:GetTeamId()-1)..team1:GetName())
		BroadCastMessage("Game point for "..team1:GetName().."!")
		SmartTeamSpeak(team, "WINNING_ENEMYTEAM", "WINNING_YOURTEAM")
	elseif team2_score >= POINTS_TO_WIN-1 and team2_score - team1_score >= MUST_WIN_BY-1 then
		ChatToAll("Game point for ^"..(team2:GetTeamId()-1)..team2:GetName())
		BroadCastMessage("Game point for "..team2:GetName())
		SmartTeamSpeak(team, "WINNING_YOURTEAM", "WINNING_ENEMYTEAM")
	end
end

function GameWon(team)
	ChatToAll("^"..(team:GetTeamId()-1)..team:GetName().." ^wins!")
	BroadCastMessage( team:GetName().." wins!" )
	--GoToIntermission()

	ChatToAll("Resetting the score...")
	local team1 = GetTeam(blue)
	local team2 = GetTeam(red)
	team1:SetScore(0)
	team2:SetScore(0)
end

red_goal = base_goaltrigger:new({team = Team.kRed, scoringteam = Team.kBlue})
blue_goal = base_goaltrigger:new({team = Team.kBlue, scoringteam = Team.kRed})

---------------------------------------------
---- Prevent Ball From Going In Spawn
---------------------------------------------

ball_teleport_blue = trigger_ff_script:new()
ball_teleport_red = trigger_ff_script:new()

---------------------------------------------
-- Protect Ball From Blue Spawn
---------------------------------------------

function ball_teleport_blue:allowed(entity)
             if entity:GetId() == GetEntityByName("ball"):GetId() then
                return EVENT_ALLOWED
             else
                return EVENT_DISALLOWED
             end
end

function ball_teleport_blue:ontrigger(entity)
             local target = GetEntityByName("teleport_target")
             local target_pos = target:GetOrigin()
             local target_angle = target:GetAngles()
             entity:Teleport(target_pos, target_angle, Vector(0,0,0))
             SpeakAll ("CTF_BALLRETURN")
             BroadCastMessage("#FF_WATERPOLO_BALL_RETURN", Color.kYellow)
			 OutputEvent("ball", "Sleep")
end

---------------------------------------------
-- Protect Ball From Red Spawn
---------------------------------------------

function ball_teleport_red:allowed(entity)
             if entity:GetId() == GetEntityByName("ball"):GetId() then
                return EVENT_ALLOWED
             else
                return EVENT_DISALLOWED
             end
end

function ball_teleport_red:ontrigger(entity)
             local target = GetEntityByName("teleport_target")
             local target_pos = target:GetOrigin()
             local target_angle = target:GetAngles()
             entity:Teleport(target_pos, target_angle, Vector(0,0,0))
             SpeakAll ("CTF_BALLRETURN")
             BroadCastMessage("#FF_WATERPOLO_BALL_RETURN", Color.kYellow)
			 OutputEvent("ball", "Sleep")
end

--------------------------------------------------
---- Prevent Enemies In Spawn (Only In Jeeps)
--------------------------------------------------

jeep_teleport_blue = trigger_ff_script:new()
jeep_teleport_red = trigger_ff_script:new()

---------------------------------------------
-- Protect Red Spawn From Blue Jeeps
---------------------------------------------

-- Blue Jeeps

function jeep_teleport_red:allowed(entity)
             if entity:GetId() == GetEntityByName("bluejeep1"):GetId() then
                return EVENT_ALLOWED
             elseif entity:GetId() == GetEntityByName("bluejeep2"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep3"):GetId() then
                return EVENT_ALLOWED
			 elseif entity:GetId() == GetEntityByName("bluejeep4"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep5"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep6"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep7"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep8"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep9"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep10"):GetId() then
                return EVENT_ALLOWED
		     else
                return EVENT_DISALLOWED
             end
end

function jeep_teleport_red:ontrigger(entity)
             local target = GetEntityByName("bluejeepdest")
             local target_pos = target:GetOrigin()
             local target_angle = target:GetAngles()
             entity:Teleport(target_pos, target_angle, Vector(0,0,0))
end

---------------------------------------------
-- Protect Blue Spawn From Red Jeeps
---------------------------------------------

-- Red Jeeps

function jeep_teleport_blue:allowed(entity)
             if entity:GetId() == GetEntityByName("redjeep1"):GetId() then
                return EVENT_ALLOWED
             elseif entity:GetId() == GetEntityByName("redjeep2"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep3"):GetId() then
                return EVENT_ALLOWED
			 elseif entity:GetId() == GetEntityByName("redjeep4"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep5"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep6"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep7"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep8"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep9"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep10"):GetId() then
                return EVENT_ALLOWED
		     else
                return EVENT_DISALLOWED
             end
end

function jeep_teleport_blue:ontrigger(entity)
             local target = GetEntityByName("redjeepdest")
             local target_pos = target:GetOrigin()
             local target_angle = target:GetAngles()
             entity:Teleport(target_pos, target_angle, Vector(0,0,0))
end

---------------------------------------------
-- No Empty Jeeps In Field (Battleground?)
---------------------------------------------

emptyredjeeptele = trigger_ff_script:new()
emptybluejeeptele = trigger_ff_script:new()

-- Red Jeeps

function emptyredjeeptele:allowed(entity)
             if entity:GetId() == GetEntityByName("redjeep1"):GetId() then
                return EVENT_ALLOWED
             elseif entity:GetId() == GetEntityByName("redjeep2"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep3"):GetId() then
                return EVENT_ALLOWED
			 elseif entity:GetId() == GetEntityByName("redjeep4"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep5"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep6"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep7"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep8"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep9"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("redjeep10"):GetId() then
                return EVENT_ALLOWED
		     else
                return EVENT_DISALLOWED
             end
end

function emptyredjeeptele:ontrigger(entity)
             if entity:GetId() == GetEntityByName("redjeep1"):GetId() then
			 OutputEvent("redjeep1_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep2"):GetId() then
			 OutputEvent("redjeep2_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep3"):GetId() then
			 OutputEvent("redjeep3_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep4"):GetId() then
			 OutputEvent("redjeep4_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep5"):GetId() then
			 OutputEvent("redjeep5_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep6"):GetId() then
			 OutputEvent("redjeep6_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep7"):GetId() then
			 OutputEvent("redjeep7_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep8"):GetId() then
			 OutputEvent("redjeep8_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep9"):GetId() then
			 OutputEvent("redjeep9_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("redjeep10"):GetId() then
			 OutputEvent("redjeep10_teleactivate", "Teleport")
			 end
end

-- Blue Jeeps

function emptybluejeeptele:allowed(entity)
             if entity:GetId() == GetEntityByName("bluejeep1"):GetId() then
                return EVENT_ALLOWED
             elseif entity:GetId() == GetEntityByName("bluejeep2"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep3"):GetId() then
                return EVENT_ALLOWED
			 elseif entity:GetId() == GetEntityByName("bluejeep4"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep5"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep6"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep7"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep8"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep9"):GetId() then
                return EVENT_ALLOWED
		     elseif entity:GetId() == GetEntityByName("bluejeep10"):GetId() then
                return EVENT_ALLOWED
		     else
                return EVENT_DISALLOWED
             end
end

function emptybluejeeptele:ontrigger(entity)
             if entity:GetId() == GetEntityByName("bluejeep1"):GetId() then
			 OutputEvent("bluejeep1_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep2"):GetId() then
			 OutputEvent("bluejeep2_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep3"):GetId() then
			 OutputEvent("bluejeep3_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep4"):GetId() then
			 OutputEvent("bluejeep4_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep5"):GetId() then
			 OutputEvent("bluejeep5_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep6"):GetId() then
			 OutputEvent("bluejeep6_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep7"):GetId() then
			 OutputEvent("bluejeep7_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep8"):GetId() then
			 OutputEvent("bluejeep8_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep9"):GetId() then
			 OutputEvent("bluejeep9_teleactivate", "Teleport")
			 elseif entity:GetId() == GetEntityByName("bluejeep10"):GetId() then
			 OutputEvent("bluejeep10_teleactivate", "Teleport")
			 end
end