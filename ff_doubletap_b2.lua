-----------------------------------------------------------------------------
-- ff_jaybases.lua
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")
IncludeScript("base_shutdown")

-----------------------------------------------------------------------------
-- Gametype Setup
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Timer for map, needs tweaked
-----------------------------------------------------------------------------
local player = CastToPlayer( player_entity )
AddHudTimer(player, "timer", 1000, -1, 0, 70, 4)

-----------------------------------------------------------------------------
-- Team settings
-----------------------------------------------------------------------------


function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	SetTeamName(Team.kBlue, "Blue m0f0's")
	SetTeamName(Team.kRed,  "Red m0f0's")

	

-----------------------------------------------------------------------------
-- Class Settings
-----------------------------------------------------------------------------


local team = GetTeam(Team.kBlue)
 
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, 2)
	team:SetClassLimit(Player.kPyro, 2)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
local team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kSoldier, 0)
	team:SetClassLimit(Player.kHwguy, 0)
	team:SetClassLimit(Player.kSpy, 0)
	team:SetClassLimit(Player.kSniper, 2)
	team:SetClassLimit(Player.kPyro, 2)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kCivilian, -1)
	
end


-----------------------------------------------------------------------------
--  To initially spawn full
-----------------------------------------------------------------------------
function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
    player:AddAmmo( Ammo.kGren1, 4 )
    player:AddAmmo( Ammo.kGren2, 4 )
	player:AddAmmo( Ammo.kManCannon, 1 )
    local class = player:GetClass()
    
    
end

-----------------------------------------------------------------------------
-- Offensive and Defensive Spawns
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Feel free to reuse this if needed.
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }



-----------------------------------------------------------------------------
--  Trigger to kill for spawns
-----------------------------------------------------------------------------

kill_trigger = trigger_ff_script:new({team = Team.kUnassigned})
red_spawn = kill_trigger:new({team = Team.kBlue})
blue_spawn = kill_trigger:new({team = Team.kRed})

function kill_trigger:allowed(activator)
	if IsPlayer(activator) then
		local player = CastToPlayer(activator)
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end





-----------------------------------------------------------
-- Packs
-----------------------------------------------------------
red_level_pack = genericbackpack:new({
	health = 10,
	armor = 20,
	nails = 50,
	rockets = 15,
	cells = 35,
	gren1 = 0,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

red_spawn_pack = genericbackpack:new({
	health = 150,
	armor = 150,
	nails = 50,
	rockets = 25,
	cells = 200,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

blue_level_pack = genericbackpack:new({
	health = 10,
	armor = 20,
	nails = 50,
	rockets = 15,
	cells = 35,
	gren1 = 0,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})
	
blue_spawn_pack = genericbackpack:new({
	health = 150,
	armor = 150,
	nails = 50,
	rockets = 25,
	cells = 200,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})



-----------------------------------------------------------
-- Extra points/Bonuses
-----------------------------------------------------------
crow_points = trigger_ff_script:new({
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function crow_points:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
        
		player:AddFortPoints ( CROW_FORTPOINTS, "#FF_FORTPOINTS_CAPTUREFLAG" )
		BroadCastMessageToPlayer( player, "Nice Conc - 10 bonuses points added" )            
            
         end
end





-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_r1 = location_info:new({ text = "Jump - 1", team = NO_TEAM })
location_r2 = location_info:new({ text = "Jump - 2", team = NO_TEAM })
location_r3 = location_info:new({ text = "Jump - 3", team = NO_TEAM })
location_r4 = location_info:new({ text = "Jump - 4", team = NO_TEAM })
location_r5 = location_info:new({ text = "Jump - 5", team = NO_TEAM })
location_r6 = location_info:new({ text = "Jump - 6", team = NO_TEAM })
location_r7 = location_info:new({ text = "Jump - 7", team = NO_TEAM })
location_r8 = location_info:new({ text = "Jump - 8", team = NO_TEAM })
location_r9 = location_info:new({ text = "Jump - 9", team = NO_TEAM })
location_r10 = location_info:new({ text = "Jump - 10", team = NO_TEAM })
location_r11 = location_info:new({ text = "Outside - Top Of Map", team = NO_TEAM })
location_r12 = location_info:new({ text = "Jump - 12", team = NO_TEAM })

location_b1 = location_info:new({ text = "Jump - 1", team = NO_TEAM })
location_b2 = location_info:new({ text = "Jump - 2", team = NO_TEAM })
location_b3 = location_info:new({ text = "Jump - 3", team = NO_TEAM })
location_b4 = location_info:new({ text = "Jump - 4", team = NO_TEAM })
location_b5 = location_info:new({ text = "Jump - 5", team = NO_TEAM })
location_b6 = location_info:new({ text = "Jump - 6", team = NO_TEAM })
location_b7 = location_info:new({ text = "Jump - 7", team = NO_TEAM })
location_b8 = location_info:new({ text = "Jump - 8", team = NO_TEAM })
location_b9 = location_info:new({ text = "Jump - 9", team = NO_TEAM })
location_b10 = location_info:new({ text = "Jump - 10", team = NO_TEAM })
location_b11 = location_info:new({ text = "Outside - Top Of Map", team = NO_TEAM })
location_b12 = location_info:new({ text = "Jump - 12", team = NO_TEAM })







------------------------------------------
-- base_trigger_jumppad
-- A trigger that emulates a jump pad
------------------------------------------

base_trigger_jumppad = trigger_ff_script:new({
	teamonly = false, 
	team = Team.kUnassigned, 
	needtojump = true, 
	push_horizontal = 150,
	push_vertical = 600,
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