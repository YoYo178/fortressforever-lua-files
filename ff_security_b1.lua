IncludeScript("base_ctf")

-- fixed version as of May 5, 2019

NUM_HITS_TO_REPAIR = 4
FORT_POINTS_PER_DET = 100
FORT_POINTS_PER_REPAIR = 100

-- precache (sounds)
function precache()
	PrecacheSound("misc.bloop")
	PrecacheSound("misc.buzwarn")
	PrecacheSound("misc.doop")
end

function gen_ondet( team )
	local teamstring = "blue"
	if team == Team.kRed then teamstring = "red" end
	
	BroadCastMessage("#FF_"..string.upper(teamstring).."_GENBLOWN")
	SmartTeamSound(GetTeam(team), "misc.buzwarn", "misc.doop")
	
	-- outputs, add any thing you want to happen when the generator is detted here
	-- teamstring is either "red" or "blue"
	OutputEvent( teamstring.."_lasers", "TurnOff" )
	OutputEvent( teamstring.."_gen_spark", "StartSpark" )
	OutputEvent( teamstring.."_lasers_hurt", "Disable" )
end

function gen_onrepair( team )
	local teamstring = "blue"
	if team == Team.kRed then teamstring = "red" end
	
	BroadCastMessage("#FF_"..string.upper(teamstring).."_GEN_OK")
	SmartTeamSound(GetTeam(team), "misc.doop", "misc.buzwarn")
	
	-- outputs, add any thing you want to happen when the generator is repaired here
	-- teamstring is either "red" or "blue"
	OutputEvent( teamstring.."_lasers", "TurnOn" )
	OutputEvent( teamstring.."_gen_spark", "StopSpark" )
	OutputEvent( teamstring.."_lasers_hurt", "Enable" )
end

function gen_onclank( player )
	-- add any thing you want to happen when the generator is hit by a wrench (while its detted) here
	ConsoleToAll("playing sound to "..player:GetName())
	BroadCastSoundToPlayer(player, "misc.bloop")
end

generators = {
	[Team.kBlue] = {
		status=0,
		repair_status=0
	},
	[Team.kRed] = {
		status=0,
		repair_status=0
	}
}

base_gen_trigger = trigger_ff_script:new({ team = Team.kUnassigned })

function base_gen_trigger:onexplode( trigger_entity  ) 
	if generators[self.team].status == 0 then
		if IsDetpack( trigger_entity ) then 
			detpack = CastToDetpack( trigger_entity )
			if IsPlayer( detpack:GetOwner() ) then
				local player = detpack:GetOwner()
				if player:GetTeamId() ~= self.team then
					player:AddFortPoints( FORT_POINTS_PER_DET, "Detting the generator" )
					gen_ondet( self.team )
					generators[self.team].status = 1
					generators[self.team].repair_status = 0
				end
			end
		end
	end
	return EVENT_ALLOWED
end

function base_gen_trigger:allowed( trigger_entity ) 
	if IsPlayer( trigger_entity ) then
		return EVENT_ALLOWED
	end
	return EVENT_DISALLOWED
end

function base_gen_trigger:ontouch( trigger_entity ) 
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() ~= self.team then
			if generators[self.team].status == 0 then
				BroadCastMessageToPlayer( player, "You can detonate this generator using a detpack" )
			end
		else
			if generators[self.team].status == 1 then
				BroadCastMessageToPlayer( player, "You can repair this generator by hitting it with a wrench" )
			end
		end
	end
end

blue_gen_trigger = base_gen_trigger:new({ team = Team.kBlue })
red_gen_trigger = base_gen_trigger:new({ team = Team.kRed })

base_gen = func_button:new({ team = Team.kUnassigned })

function base_gen:ondamage( damageinfo )
	local attacker = damageinfo:GetAttacker()
	if generators[self.team].status == 1 then
		if IsPlayer( attacker ) then
			local player = CastToPlayer( attacker )
			if player:GetTeamId() == self.team then
  				local weapon = damageinfo:GetInflictor():GetClassName()
				if weapon == "ff_weapon_spanner" then
					generators[self.team].repair_status = generators[self.team].repair_status + 1
					if generators[self.team].repair_status >= NUM_HITS_TO_REPAIR then
						player:AddFortPoints( FORT_POINTS_PER_REPAIR, "Repairing the generator" )
						gen_onrepair( self.team )
						generators[self.team].status = 0
					else
						gen_onclank( player )
					end
				end
			end
		end
	end
end

blue_gen = base_gen:new({ team = Team.kBlue })
red_gen = base_gen:new({ team = Team.kRed })

base_lasers_hurt = trigger_ff_script:new({ team = Team.kUnassigned })

function base_lasers_hurt:allowed( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		return player:GetTeamId() ~= self.team
	end
	return EVENT_DISALLOWED
end

blue_lasers_hurt = base_lasers_hurt:new({ team = Team.kBlue })
red_lasers_hurt = base_lasers_hurt:new({ team = Team.kRed })

-----------------------------------------------------------------------------
--lzr
-----------------------------------------------------------------------------
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


red_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
blue_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
