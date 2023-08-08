-----------------------------------------------------------------------------
-- conc_course.lua
-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base_teamplay")
IncludeScript("base_conc")

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------

SOLDIER = 1
SCOUT = 1
MEDIC = 1
DEMOMAN = 1
ENGINEER = 1
PYRO = 1

playerStateTable = {}

ammobag = concbackpack

function ammobag:touch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)

		local dispensed = 0

		-- give player some health and armor
		dispensed = dispensed + player:AddHealth(self.health)
		dispensed = dispensed + player:AddArmor(self.armor)
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kPyro or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
		end

		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function precache()
	-- precache sounds
	PrecacheSound("conc_course.checkpoint")
end

function player_spawn(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		if not playerStateTable then
			playerStateTable[player:GetId()] = 0
		end
		player:AddHealth(400)
		player:AddArmor(400)

		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kPyro or class == Player.kDemoman then
			player:AddAmmo(Ammo.kGren1, 4)
			player:AddAmmo(Ammo.kGren2, -4)
		else
			player:AddAmmo(Ammo.kGren1, -4)
			player:AddAmmo(Ammo.kGren2, 4)
		end

		-- Add items (similar to both teams)
		player:AddAmmo(Ammo.kShells, 200)
		player:AddAmmo(Ammo.kRockets, 30)
		player:AddAmmo(Ammo.kNails, 200)
		team = player:GetTeam()
		if playerStateTable[player:GetId()] ~= nil then
			jump = playerStateTable[player:GetId()]['jump'] + 1
			player:SetLocation(math.random(100), 'Jump ' .. jump, team:GetTeamId())
		else
			player:SetLocation(math.random(100), 'Jump 1', team:GetTeamId())
		end
	end
end

messagetrigger  = trigger_ff_script:new({ msg = 0, location = '' })
set_jumppos     = trigger_ff_script:new({ pos = 0, pointmsg = 'Starting', points = 0 })
takebonus       = trigger_ff_script:new({ pos = 0, pointmsg = 'Starting', points = 0 })
conctimer_start = trigger_ff_script:new({ timer = 0, pos = 0 })
conctimer_end   = trigger_ff_script:new({
	timer = 0,
	pos = 0,
	bronzetime = 150,
	silvertime = 100,
	goldtime = 50,
	bronzepoints = 50,
	silverpoints = 100,
	goldpoints = 150
})

function messagetrigger:onendtouch(touch_entity)
	local player = CastToPlayer(touch_entity)
	BroadCastMessageToPlayer(player, self.msg);
	if self.location ~= '' then
		player:SetLocation(self.id, self.location, 0)
	end
end

returnbutton = func_button:new({ team = Team.kUnassigned })

function returnbutton:onuse(touch_entity)
	local player = CastToPlayer(touch_entity)
	if playerStateTable[player:GetId()] ~= nil then
		playerStateTable[player:GetId()]['jump'] = playerStateTable[player:GetId()]['jump'] - 1
	end
	player:Respawn()
end

function set_jumppos:onendtouch(touch_entity)
	local player = CastToPlayer(touch_entity)
	if playerStateTable[player:GetId()] == nil then playerStateTable[player:GetId()] = { jump = 0, maxjump = 0 } end
	if playerStateTable[player:GetId()]['jump'] < self.pos then
		ConsoleToAll(self.pos .. " reached by player, last checkpoint was " .. playerStateTable[player:GetId()]['jump']);
		playerStateTable[player:GetId()]['jump'] = self.pos
		if playerStateTable[player:GetId()]['maxjump'] < self.pos then
			playerStateTable[player:GetId()]['maxjump'] = self.pos
			player:AddFortPoints(self.points, self.pointmsg);
		end
		local jumpposition = self.pos + 1;
		team = player:GetTeam()
		player:SetLocation(self.pos, 'Jump ' .. jumpposition, team:GetTeamId())
	end
end

function takebonus:onendtouch(touch_entity)
	local player = CastToPlayer(touch_entity)
	if playerStateTable[player:GetId()]['bonus'] == nil then playerStateTable[player:GetId()]['bonus'] = {} end
	if not playerStateTable[player:GetId()]['bonus'][self.pos] then
		playerStateTable[player:GetId()]['bonus'][self.pos] = true
		player:AddFortPoints(self.points, self.pointmsg);
		ConsoleToAll("Player took bonus " .. self.pos);
	end
end

nonades = nogrens

function spawn_check(self, player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		if playerStateTable[player:GetId()] ~= nil then
			if playerStateTable[player:GetId()]['jump'] == self.checkpoint then return true end
		else
			if self.checkpoint == 0 then return true end
		end
	end
	return false;
end

function player_disconnect(player_entity)
	local player = CastToPlayer(player_entity)
	playerStateTable[player:GetId()] = nil;
	return true;
end

function player_switchteam(player_entity)
	local player = CastToPlayer(player_entity)
	playerStateTable[player:GetId()] = nil;
	return true;
end

concspawn_0      = { validspawn = spawn_check, checkpoint = 0 }
concspawn_1      = { validspawn = spawn_check, checkpoint = 1 }
concspawn_2      = { validspawn = spawn_check, checkpoint = 2 }
concspawn_3      = { validspawn = spawn_check, checkpoint = 3 }
concspawn_4      = { validspawn = spawn_check, checkpoint = 4 }
concspawn_5      = { validspawn = spawn_check, checkpoint = 5 }
concspawn_6      = { validspawn = spawn_check, checkpoint = 6 }
concspawn_7      = { validspawn = spawn_check, checkpoint = 7 }
concspawn_8      = { validspawn = spawn_check, checkpoint = 8 }
concspawn_9      = { validspawn = spawn_check, checkpoint = 9 }
concspawn_10     = { validspawn = spawn_check, checkpoint = 10 }
concspawn_11     = { validspawn = spawn_check, checkpoint = 11 }
concspawn_12     = { validspawn = spawn_check, checkpoint = 12 }
concspawn_13     = { validspawn = spawn_check, checkpoint = 13 }
concspawn_14     = { validspawn = spawn_check, checkpoint = 14 }
concspawn_15     = { validspawn = spawn_check, checkpoint = 15 }
concspawn_16     = { validspawn = spawn_check, checkpoint = 16 }
concspawn_17     = { validspawn = spawn_check, checkpoint = 17 }
concspawn_18     = { validspawn = spawn_check, checkpoint = 18 }
concspawn_19     = { validspawn = spawn_check, checkpoint = 19 }
concspawn_20     = { validspawn = spawn_check, checkpoint = 20 }
concspawn_21     = { validspawn = spawn_check, checkpoint = 21 }
concspawn_22     = { validspawn = spawn_check, checkpoint = 22 }
concspawn_23     = { validspawn = spawn_check, checkpoint = 23 }
concspawn_24     = { validspawn = spawn_check, checkpoint = 24 }
concspawn_25     = { validspawn = spawn_check, checkpoint = 25 }
concspawn_26     = { validspawn = spawn_check, checkpoint = 26 }
concspawn_27     = { validspawn = spawn_check, checkpoint = 27 }
concspawn_28     = { validspawn = spawn_check, checkpoint = 28 }
concspawn_29     = { validspawn = spawn_check, checkpoint = 29 }
concspawn_30     = { validspawn = spawn_check, checkpoint = 30 }

endmessage       = messagetrigger:new({
	msg = 'Gratz! You have reached the end of the course!',
	location = 'The end!',
	id = 1
})

concbonus1       = takebonus:new({ pos = 1, pointmsg = 'Taking Bonus Route', points = 25 })
concbonus2       = takebonus:new({ pos = 2, pointmsg = 'Taking Bonus Route', points = 25 })
concbonus3       = takebonus:new({ pos = 3, pointmsg = 'Taking Bonus Route', points = 25 })
concbonus4       = takebonus:new({ pos = 4, pointmsg = 'Taking Bonus Route', points = 25 })
concbonus5       = takebonus:new({ pos = 5, pointmsg = 'Taking Bonus Route', points = 25 })

conctimer1_start = conctimer_start:new({ timer = 1, pos = 27 });
conctimer1_end   = conctimer_start:new({
	timer = 1,
	pos = 27,
	bronzetime = 150,
	silvertime = 100,
	goldtime = 50,
	bronzepoints = 50,
	silverpoints = 100,
	goldpoints = 150
});

conctrigger1  = set_jumppos:new({ pos = 1, pointmsg = 'Reaching 1st Checkpoint', points = 25 })
conctrigger2  = set_jumppos:new({ pos = 2, pointmsg = 'Reaching 2nd Checkpoint', points = 50 })
conctrigger3  = set_jumppos:new({ pos = 3, pointmsg = 'Reaching 3rd Checkpoint', points = 10 })
conctrigger4  = set_jumppos:new({ pos = 4, pointmsg = 'Reaching 4th Checkpoint', points = 75 })
conctrigger5  = set_jumppos:new({ pos = 5, pointmsg = 'Reaching 5th Checkpoint', points = 30 })
conctrigger6  = set_jumppos:new({ pos = 6, pointmsg = 'Reaching 6th Checkpoint', points = 10 })
conctrigger7  = set_jumppos:new({ pos = 7, pointmsg = 'Reaching 7th Checkpoint', points = 25 })
conctrigger8  = set_jumppos:new({ pos = 8, pointmsg = 'Reaching 8th Checkpoint', points = 125 })
conctrigger9  = set_jumppos:new({ pos = 9, pointmsg = 'Reaching 9th Checkpoint', points = 150 })
conctrigger10 = set_jumppos:new({ pos = 10, pointmsg = 'Reaching 10th Checkpoint', points = 10 })
conctrigger11 = set_jumppos:new({ pos = 11, pointmsg = 'Reaching 11th Checkpoint', points = 25 })
conctrigger12 = set_jumppos:new({ pos = 12, pointmsg = 'Reaching 12th Checkpoint', points = 50 })
conctrigger13 = set_jumppos:new({ pos = 13, pointmsg = 'Reaching 13th Checkpoint', points = 75 })
conctrigger14 = set_jumppos:new({ pos = 14, pointmsg = 'Reaching 14th Checkpoint', points = 10 })
conctrigger15 = set_jumppos:new({ pos = 15, pointmsg = 'Reaching 15th Checkpoint', points = 10 })
conctrigger16 = set_jumppos:new({ pos = 16, pointmsg = 'Reaching 16th Checkpoint', points = 10 })
conctrigger17 = set_jumppos:new({ pos = 17, pointmsg = 'Reaching 17th Checkpoint', points = 10 })
conctrigger18 = set_jumppos:new({ pos = 18, pointmsg = 'Reaching 18th Checkpoint', points = 10 })
conctrigger19 = set_jumppos:new({ pos = 19, pointmsg = 'Reaching 19th Checkpoint', points = 10 })
conctrigger20 = set_jumppos:new({ pos = 20, pointmsg = 'Reaching 20th Checkpoint', points = 10 })
conctrigger21 = set_jumppos:new({ pos = 21, pointmsg = 'Reaching 21st Checkpoint', points = 10 })
conctrigger22 = set_jumppos:new({ pos = 22, pointmsg = 'Reaching 22nd Checkpoint', points = 10 })
conctrigger23 = set_jumppos:new({ pos = 23, pointmsg = 'Reaching 23rd Checkpoint', points = 10 })
conctrigger24 = set_jumppos:new({ pos = 24, pointmsg = 'Reaching 24th Checkpoint', points = 10 })
conctrigger25 = set_jumppos:new({ pos = 25, pointmsg = 'Reaching 25th Checkpoint', points = 10 })
conctrigger26 = set_jumppos:new({ pos = 26, pointmsg = 'Reaching 26th Checkpoint', points = 10 })
conctrigger27 = set_jumppos:new({ pos = 27, pointmsg = 'Reaching 27th Checkpoint', points = 10 })
conctrigger28 = set_jumppos:new({ pos = 28, pointmsg = 'Reaching 28th Checkpoint', points = 10 })
conctrigger29 = set_jumppos:new({ pos = 29, pointmsg = 'Reaching 29th Checkpoint', points = 10 })
conctrigger30 = set_jumppos:new({ pos = 30, pointmsg = 'Reaching 30th Checkpoint', points = 10 })
