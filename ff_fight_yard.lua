IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60

function startup()

	-- set up team limits (blue & red are unlimited, while yellow and green get 1 goalie each)
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( Team.kBlue, "Blue" )
	SetTeamName( Team.kRed, "Red" )

	local team = GetTeam(Team.kBlue)
	team:SetAllies( Team.kYellow )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

-- Spawn doors
spawn_door_trigger = trigger_ff_script:new({ team = Team.kUnassigned, doorname = "" })

function spawn_door_trigger:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			if self.doorname then
				OpenDoor( self.doorname )
			end
		end
	end
end

red_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door1" })
red_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kRed, doorname = "red_spawn_door2" })
blue_spawn_door1_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door1" })
blue_spawn_door2_trigger = spawn_door_trigger:new({ team = Team.kBlue, doorname = "blue_spawn_door2" })
