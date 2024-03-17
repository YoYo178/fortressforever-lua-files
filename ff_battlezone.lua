----------------------------------------------------------------------
-- Definitions
----------------------------------------------------------------------

BALL_RETURN_TIME = 0
SCORE_TIME = 5
ADD_POINTS = 1
POINT_MULTIPLIER = 1
----------------------------------------------------------------------
-- Startup
----------------------------------------------------------------------

function startup()
	SetTeamName(Team.kBlue, "Blue Parrots")
	SetTeamName(Team.kRed, "Red Parrots")
	SetTeamName(Team.kYellow, "Yellow Parrots")
	SetTeamName(Team.kGreen, "Green Parrots")
	
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kRed)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kYellow)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kGreen)
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end
----------------------------------------------------------------------
-- Kills
----------------------------------------------------------------------
function player_killed( player_id )
        -- If you kill someone, give your team a point
        local killer = GetPlayer(killer)
        local victim = GetPlayer(player_id)
       
        if not (victim:GetTeamId() == killer:GetTeamId()) then
                local killersTeam = killer:GetTeam()
                killersTeam:AddScore(1)
        end
end
----------------------------------------------------------------------
-- Player Spawn
----------------------------------------------------------------------
function player_spawn( player_entity )
local player = CastToPlayer( player_entity )

player:AddHealth( 400 )
player:AddArmor( 400 )
player:AddAmmo( Ammo.kNails, 400 )
player:AddAmmo( Ammo.kShells, 400 )
player:AddAmmo( Ammo.kRockets, 400 )
player:AddAmmo( Ammo.kCells, 400 )
end

----------------------------------------------------------------------
-- Respawn
----------------------------------------------------------------------

redallowedmethod = function(self,player) return player:GetTeamId() == Team.kRed end
blueallowedmethod = function(self,player) return player:GetTeamId() == Team.kBlue end
yellowallowedmethod = function(self,player) return player:GetTeamId() == Team.kYellow end
greenallowedmethod = function(self,player) return player:GetTeamId() == Team.kGreen end

red_spawn = {validspawn = redallowedmethod}
blue_spawn = {validspawn = blueallowedmethod}
green_spawn = {validspawn = greenallowedmethod}
yellow_spawn = {validspawn = yellowallowedmethod}
-----------------------------------------------------------------------------
-- Ball Configuration
-----------------------------------------------------------------------------
ball = info_ff_script:new({
	name = "ball",
	team = Team.kUnassigned,
	model = "models/items/ball/ball.mdl",
	modelskin = 0,
	tosssound = "Flag.Toss",
	capnotouchtime = 1,
	dropnotouchtime = 1,
	returnnotouchtime = 1,
	notouchall = nil,
	status = 0,
	hudicon = "hud_ball",
	hudx = 5,
	hudy = 210,
	hudw = 48,
	hudh = 48,
	huda = 1,
	hudstatusiconxrb = 60,
	hudstatusiconyrb = 5,
	hudstatusiconxyg = 53,
	hudstatusiconyyg = 25,
	hudstatusicon = "hud_ball.vtf",
	hudstatusiconw = 15,
	hudstatusiconh = 15,
	hudstatusiconalignby = 2,
	hudstatusiconalignrg = 3,
	botgoaltype = Bot.kFlag,
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})
function ball:hasanimation() return true end

function ball:attachoffset() return Vector(32, 0, 0) end

function ball:precache()
	PrecacheSound(self.tosssound)
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	info_ff_script.precache(self)
end

function ball:spawn()
	self.notouch = {}
	info_ff_script.spawn(self)
	self.status = 0
end

function ball:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name.."-"..player_id, duration, self.removenotouch, self, player_id)	
end

function ball.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function ball:addnotouchall(duration)
	self.notouchall = duration
	AddSchedule(self.name.."-all", duration, self.removenotouchall, self)	
end

function ball.removenotouchall(self)
	self.notouchall = nil
end

function ball:touch(touch_entity)
	if IsPlayer(touch_entity) then
		local player = CastToPlayer(touch_entity)
		if self.notouch[player:GetId()] then return; end
		if self.notouchall then return; end
	
		if player:GetTeamId() ~= self.team then
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			SmartSpeak(player, "CTF_YOUHAVEBALL", "CTF_TEAMHASBALL", "CTF_ENEMYHASBALL")
			SmartMessage(player, "You have the ball!", "#FF_TEAMHASBALL", "#FF_ENEMYHASBALL")
			
			player:SetDisguisable(false)
			player:SetCloakable(false)
			
			local ball = CastToInfoScript(entity)
			ball:Pickup(player)
			self.status = 1
			AddHudIcon(player, self.hudicon, ball:GetName(), self.hudx, self.hudy, self.hudw, self.hudh, self.huda)
			RemoveHudItemFromAll("ball-icon-dropped")

			local team = player:GetTeamId()
			if (team == Team.kBlue) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-blue", self.hudstatusiconxrb, self.hudstatusiconyrb, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignby)
			elseif (team == Team.kRed) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-red", self.hudstatusiconxrb, self.hudstatusiconyrb, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignrg)
			elseif (team == Team.kYellow) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-yellow", self.hudstatusiconxyg, self.hudstatusiconyyg, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignby)
			elseif (team == Team.kGreen) then
				AddHudIconToAll(self.hudstatusicon, "ball-icon-green", self.hudstatusiconxyg, self.hudstatusiconyyg, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalignrg)
			end
			
			AddScheduleRepeating("scoretimer", SCORE_TIME, AddPoints, player)
		end
	end
end

function ball:onownerdie(owner_entity)
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 0.0)
	self.status = 2
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		RemoveHudItem(player, ball:GetName())

		local team = player:GetTeamId()
		if (team == Team.kBlue) then
			RemoveHudItemFromAll("ball-icon-blue")
		elseif (team == Team.kRed) then
			RemoveHudItemFromAll("ball-icon-red")
		elseif (team == Team.kYellow) then
			RemoveHudItemFromAll("ball-icon-yellow")
		elseif (team == Team.kGreen) then
			RemoveHudItemFromAll("ball-icon-green")
		end
	end
end

function ball:ownerfeign(owner_entity)
	local ball = CastToInfoScript(entity)
	ball:Drop(BALL_RETURN_TIME, 0.0)
	self.status = 2
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		RemoveHudItem(player, ball:GetName())

		local team = player:GetTeamId()
		if (team == Team.kBlue) then
			RemoveHudItemFromAll("ball-icon-blue")
		elseif (team == Team.kRed) then
			RemoveHudItemFromAll("ball-icon-red")
		elseif (team == Team.kYellow) then
			RemoveHudItemFromAll("ball-icon-yellow")
		elseif (team == Team.kGreen) then
			RemoveHudItemFromAll("ball-icon-green")
		end
	end
end

function ball:dropitemcmd(owner_entity) return false end

function ball:ondrop(owner_entity)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
		SmartMessage(player, "#FF_YOUBALLDROP", "#FF_TEAMBALLDROP", "#FF_ENEMYBALLDROP")
		RemoveSchedule("scoretimer")
	end
	
	local ball = CastToInfoScript(entity)
	ball:EmitSound(self.tosssound)
end

function ball:onloseitem(owner_entity)
	if IsPlayer(owner_entity) then
		local player = CastToPlayer(owner_entity)
		player:SetDisguisable(true)
		player:SetCloakable(true)
		self:addnotouch(player:GetId(), self.capnotouchtime)
	end
end

function ball:onreturn()
	BroadCastMessage("#FF_BALLRETURN")
	BroadCastSound ("yourteam.flagreturn")
	SpeakAll("CTF_BALLRETURN")
	self.status = 0
	-- No touching for a bit after return
	self:addnotouchall(self.returnnotouchtime)
	-- Set ball location to yard
	current_ball_location = "yard"
	UpdateBallLocation()
end

ball = ball:new({name = "Ball"})

----------------------------------------------------------------------
-- Add Points
----------------------------------------------------------------------

function AddPoints(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		local team = player:GetTeam()
		team:AddScore(ADD_POINTS)
		player:AddFortPoints(ADD_POINTS*POINT_MULTIPLIER, "Holding the ball.")
	end
end

----------------------------------------------------------------------
-- Has Ball
----------------------------------------------------------------------

function HasBall(player_entity)
	if IsPlayer(player_entity) then
		local player = CastToPlayer(player_entity)
		local ball = GetInfoScriptByName("ball")
		if ball then
			if player:HasItem(ball:GetName()) then
				return true
			end
		end
	end
	return false
end
