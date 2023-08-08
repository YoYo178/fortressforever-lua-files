
-- ff_urbantag.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_freezetag_r");
-----------------------------------------------------------------------------
-- One Conc
-----------------------------------------------------------------------------

conc = genericbackpack:new({
	gren2 = 1,
    respawntime = 8,
	model = "models/grenades/conc/conc.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function conc :dropatspawn() return false end

red_conc = conc:new({ touchflags = {AllowFlags.kRed} })
blue_conc = conc:new({ touchflags = {AllowFlags.kBlue} })

------------------------------------------
-- base_trigger_jumppad
-- A trigger that emulates a jump pad
------------------------------------------

base_trigger_jumppad = trigger_ff_script:new({
	teamonly = false, 
	team = Team.kUnassigned, 
	needtojump = true, 
	push_horizontal = 256,
	push_vertical = 2056,
	notouchtime = 1,
	notouch = {}
})

function base_trigger_jumppad:allowed( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		-- if jump needs to be pressed and it isn't, disallow
		if self.needtojump and not player:IsInJump() then return false; end
		-- if not able to touch, disallow
		if self.notouch[player:GetId()] then return false; end
		-- if team only and on the wrong team, disallow
		if self.teamonly and player:GetTeamId() ~= self.team then return false; end
		-- if haven't returned yet, allow
		return true;
	end
	return false;
end

function base_trigger_jumppad:ontrigger( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		-- get the direction the player is facing
		local facingdirection = player:GetAbsFacing()
		-- normalize just in case
		facingdirection:Normalize()
		-- calculate new velocity vector using the facing direction
		local newvelocity = Vector( facingdirection.x * self.push_horizontal, facingdirection.y * self.push_horizontal, self.push_vertical )
		-- really hacky way to do this, but make sure the length of the horiz of the new velocity is correct
		-- the proper way to do it is to use the player's eyeangles right vector x Vector(0,0,1)
		local newvelocityhoriz = Vector( newvelocity.x, newvelocity.y, 0 )
		while newvelocityhoriz:Length() < self.push_horizontal do
			newvelocityhoriz.x = newvelocityhoriz.x * 1.1
			newvelocityhoriz.y = newvelocityhoriz.y * 1.1
		end
		newvelocity.x = newvelocityhoriz.x
		newvelocity.y = newvelocityhoriz.y
		-- set player's velocity
		player:SetVelocity( newvelocity )
		self:addnotouch(player:GetId(), self.notouchtime)
	end
end

function base_trigger_jumppad:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule("jumppad"..entity:GetId().."notouch-" .. player_id, duration, self.removenotouch, self, player_id)
end

function base_trigger_jumppad.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

-- standard definitions
jumppad = base_trigger_jumppad:new({})
jumppad_nojump = base_trigger_jumppad:new({ needtojump = false })

-- teamonly definitions
jumppad_blue = base_trigger_jumppad:new({ teamonly = true, team = Team.kBlue })
jumppad_red = base_trigger_jumppad:new({ teamonly = true, team = Team.kRed })
jumppad_green = base_trigger_jumppad:new({ teamonly = true, team = Team.kGreen })
jumppad_yellow = base_trigger_jumppad:new({ teamonly = true, team = Team.kYellow })

jumppad_nojump_blue = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kBlue })
jumppad_nojump_red = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kRed })
jumppad_nojump_green = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kGreen })
jumppad_nojump_yellow = base_trigger_jumppad:new({ needtojump = false, teamonly = true, team = Team.kYellow })

-- special definitions
jump2056v = base_trigger_jumppad:new({push_horizontal = 256, push_vertical = 2056 })
jump1024v = base_trigger_jumppad:new({push_horizontal = 256, push_vertical = 1024 })

