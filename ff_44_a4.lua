-----------------------------------------------------------------------------
-- ff_44_a4.lua
-- This is 44 a Fortress-Forever map inspired by TFC's 55.
-- Origianl 55 by Brian "Pigeons" Steele
-- Huge thanks to FDA, NeoNL, and Squeek.
-- It's a ctf map.
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- Location Spawns
-----------------------------------------------------------------------------

red_o_only  = function(_, player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
red_d_only  = function(_, player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

red_ospawn  = { validspawn = red_o_only }
red_dspawn  = { validspawn = red_d_only }

blue_o_only = function(_, player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
blue_d_only = function(_, player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- Small Lift
-----------------------------------------------------------------------------
base_jump   = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player    = CastToPlayer(trigger_entity)
		local playerVel = player:GetVelocity()
		playerVel.z     = self.pushz
		player:SetVelocity(playerVel)
	end
end

fr_vent_red1                      = base_jump:new({ pushz = 700, pushx = 700 })
fr_vent_blue1                     = base_jump:new({ pushz = 700, pushx = 700 })

-----------------------------------------------------------------------------
-- Pit Capture Points
-----------------------------------------------------------------------------
-- save all the functions in a table
-- so we don't accidentally overwrite any saved functions in other files
local saved_functions             = {}

-- save the function in the table
saved_functions.basecap           = {}
saved_functions.basecap.ontrigger = basecap.ontrigger

function basecap:ontrigger(trigger_entity)
	-- save last points per capture
	local last_points_per_cap     = POINTS_PER_CAPTURE
	local last_fortpoints_per_cap = FORTPOINTS_PER_CAPTURE

	-- set points per capture to this cap points settings if they are defined
	if self.teampoints ~= nil then POINTS_PER_CAPTURE = self.teampoints end
	if self.fortpoints ~= nil then FORTPOINTS_PER_CAPTURE = self.fortpoints end

	if type(saved_functions.basecap.ontrigger) == "function" then
		-- call the saved function
		saved_functions.basecap.ontrigger(self, trigger_entity)
	end

	-- reset points per cap to what it was
	POINTS_PER_CAPTURE     = last_points_per_cap
	FORTPOINTS_PER_CAPTURE = last_fortpoints_per_cap
end

-- cap points that give 20 points instead of 10
blue_cap_bonus   = blue_cap:new({ teampoints = 20, fortpoints = 2000 })
red_cap_bonus    = red_cap:new({ teampoints = 20, fortpoints = 2000 })
yellow_cap_bonus = yellow_cap:new({ teampoints = 20, fortpoints = 2000 })
green_cap_bonus  = green_cap:new({ teampoints = 20, fortpoints = 2000 })

--------------------------------------------------------------------------
-- Yard Lift with push based on the triggering class's speed
-- Push is multiplied by the class's speed / 400 (scout speed) to the power of speedbias
-- Higher speedbias = slow classes get pushed a lot less and vice versa
--------------------------------------------------------------------------
base_angle_jump  = trigger_ff_script:new({ pushz = 0, pushx = 0, pushy = 0, speedbias = 0 })

function base_angle_jump:ontouch(trigger_entity)
	if IsPlayer(trigger_entity) then
		local player     = CastToPlayer(trigger_entity)
		local playerVel  = player:GetVelocity()
		local speedRatio = (player:MaxSpeed() / 400) ^ self.speedbias;
		if self.pushz ~= 0 then playerVel.z = self.pushz * speedRatio end
		if self.pushx ~= 0 then playerVel.x = self.pushx * speedRatio end
		if self.pushy ~= 0 then playerVel.y = self.pushy * speedRatio end
		player:SetVelocity(playerVel)
	end
end

yardvent_red  = base_angle_jump:new({ pushz = 760, pushx = -0, pushy = 1800, speedbias = 1 })
yardvent_blue = base_angle_jump:new({ pushz = 760, pushx = -0, pushy = -1800, speedbias = 1 })
fr_vent_red2  = base_angle_jump:new({ pushy = -1600 })
fr_vent_blue2 = base_angle_jump:new({ pushy = 1600 })

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------
hurt          = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		local player = CastToPlayer(allowed_entity)
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt  = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })
