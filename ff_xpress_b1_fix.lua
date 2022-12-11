IncludeScript("base_ctf");
IncludeScript("base_teamplay");

POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 30

--------------------------------------------------
-- flag return fixes by -_YoYo178_-
--------------------------------------------------

--------------------------------------------------
-- Make the flag return after falling in the void
--------------------------------------------------

flagreturn = trigger_ff_script:new()

--------------------------------------------------
function flagreturn:allowed(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		return EVENT_ALLOWED
	else
		return EVENT_DISALLOWED
	end
end

function flagreturn:ontrigger(trigger_player)
	if IsPlayer(trigger_player) then
		local player = CastToPlayer(trigger_player)
		
		local redflag = GetInfoScriptByName("red_flag")
		local redflagorigin = redflag:GetOrigin()
		
		local blueflag GetInfoScriptByName("blue_flag")
		local blueflagorigin = blueflag:GetOrigin()
		
		local target = GetEntityByName("void")
		local targetorigin = target:GetOrigin()
		
		if redflagorigin.z < targetorigin.z then
			FLAG_RETURN_TIME = 1
		end
		if redflagorigin.z > targetorigin.z then
			FLAG_RETURN_TIME = 30
		end
		if blueflagorigin.z < targetorigin.z then
			FLAG_RETURN_TIME = 1
		end
		if blueflagorigin.z > targetorigin.z then
			FLAG_RETURN_TIME = 30
		end
	end
end 
