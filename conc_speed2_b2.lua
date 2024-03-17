IncludeScript("base_push");
IncludeScript("base_ctf4");
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("power_quad");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )

function startup()

AddScheduleRepeating( "restock", 1, restock_all )

SetTeamName( Team.kBlue, "Conc" )
SetTeamName( Team.kRed, "Quad" )
SetTeamName( Team.kYellow, "Double" )
SetTeamName( Team.kGreen, "Reverse" )

SetPlayerLimit( Team.kBlue, 0 )
SetPlayerLimit( Team.kRed, 0 )
SetPlayerLimit( Team.kYellow, 0 )
SetPlayerLimit( Team.kGreen, 0 )

-- BLUE TEAM
local team = GetTeam( Team.kBlue )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, 0 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, -1 )
team:SetClassLimit( Player.kDemoman, -1 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- RED TEAM
local team = GetTeam( Team.kRed )
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, 0 )
team:SetClassLimit( Player.kEngineer, 0 )

-- Yellow TEAM
local team = GetTeam( Team.kYellow )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kGreen)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, -1 )
team:SetClassLimit( Player.kMedic, -1 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

-- Green TEAM
local team = GetTeam( Team.kGreen )
team:SetAllies( Team.kRed)
team:SetAllies( Team.kBlue)
team:SetAllies( Team.kYellow)

team:SetClassLimit( Player.kHwguy, -1 )
team:SetClassLimit( Player.kSpy, -1 )
team:SetClassLimit( Player.kCivilian, -1 )
team:SetClassLimit( Player.kSniper, -1 )
team:SetClassLimit( Player.kScout, 0 )
team:SetClassLimit( Player.kMedic, 0 )
team:SetClassLimit( Player.kSoldier, 0 )
team:SetClassLimit( Player.kDemoman, 0 )
team:SetClassLimit( Player.kPyro, -1 )
team:SetClassLimit( Player.kEngineer, -1 )

end

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

-- Disable conc effect
CONC_EFFECT = 0

--
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end

--------------------
--Locations
--------------------

location_stage1 = location_info:new({ text = "Jump [1] ", team = NO_TEAM })
location_stage2 = location_info:new({ text = "Jump [2] ", team = NO_TEAM })
location_stage3 = location_info:new({ text = "Jump [3] ", team = NO_TEAM })
location_stage4 = location_info:new({ text = "Jump [4] ", team = NO_TEAM })
location_stage5 = location_info:new({ text = "Jump [5] ", team = NO_TEAM })
location_stage6 = location_info:new({ text = "Jump [6]", team = NO_TEAM })
location_stage7 = location_info:new({ text = "Jump [7]", team = NO_TEAM })
location_stage8 = location_info:new({ text = "Jump [8]", team = NO_TEAM })
location_stage9 = location_info:new({ text = "Jump [9]", team = NO_TEAM })
location_stage10 = location_info:new({ text = "Jump [10]", team = NO_TEAM })
location_stage11 = location_info:new({ text = "Jump [11]", team = NO_TEAM })
location_stage12 = location_info:new({ text = "Jump [12]", team = NO_TEAM })
location_stage13 = location_info:new({ text = "Jump [13]", team = NO_TEAM })
location_stage14 = location_info:new({ text = "Jump [14]", team = NO_TEAM })
location_stage15 = location_info:new({ text = "Jump [15]", team = NO_TEAM })
location_stage16 = location_info:new({ text = "Jump [16]", team = NO_TEAM })
location_stage17 = location_info:new({ text = "Jump [17]", team = NO_TEAM })
location_stage18 = location_info:new({ text = "Jump [18]", team = NO_TEAM })
location_stage19 = location_info:new({ text = "Jump [19]", team = NO_TEAM })
location_stage20 = location_info:new({ text = "Jump [20]", team = NO_TEAM })
location_stage21 = location_info:new({ text = "Jump [21]", team = NO_TEAM })
location_stage22 = location_info:new({ text = "Jump [22]", team = NO_TEAM })
location_stage23 = location_info:new({ text = "Jump [23]", team = NO_TEAM })
location_stage24 = location_info:new({ text = "Jump [24]", team = NO_TEAM })
location_stage25 = location_info:new({ text = "Jump [25]", team = NO_TEAM })
location_stage26 = location_info:new({ text = "Jump [26]", team = NO_TEAM })
location_stage27 = location_info:new({ text = "Jump [27]", team = NO_TEAM })
location_stage28 = location_info:new({ text = "Jump [28]", team = NO_TEAM })
location_stage29 = location_info:new({ text = "Jump [29]", team = NO_TEAM })
location_stage30 = location_info:new({ text = "Jump [30]", team = NO_TEAM })
location_stage31 = location_info:new({ text = "Jump [31]", team = NO_TEAM })
location_stage32 = location_info:new({ text = "The END", team = NO_TEAM })

-----------------------------------------------------------------------------
-- teleports
-----------------------------------------------------------------------------
teamteleport = trigger_ff_script:new({ team = Team.kUnassigned })

function teamteleport:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_teamteleport = teamteleport:new({ team = Team.kBlue })
red_teamteleport = teamteleport:new({ team = Team.kRed })
yellow_teamteleport = teamteleport:new({ team = Team.kYellow })
green_teamteleport = teamteleport:new({ team = Team.kGreen })

--------------------
--Finish Zones
--------------------

finish2 = trigger_ff_script:new({})

function finish2:ontouch(touch_entity)
         if IsPlayer(touch_entity) then
            local player = CastToPlayer(touch_entity)
            player:AddFortPoints( 100, "Completed the Map")

            BroadCastMessage( player:GetName() .. " has Completed the Map!" )
------------------------------------------------------------------
-- Messages
------------------------------------------------------------------

trigger_message_base = trigger_ff_script:new({ message="Default" })

function trigger_message_base:ontouch( touch_entity )
  if IsPlayer( touch_entity ) then
    local player = CastToPlayer( touch_entity )
    BroadCastMessageToPlayer( player, self.message )
  end
end

trigger_message1 = trigger_message_base:new({ message="-[ Map made by Koochie.ii ]-" })
trigger_message2 = trigger_message_base:new({ message="Thks for playng conc_speed2 :D!!!" })
trigger_message3 = trigger_message_base:new({ message="- Concs removed -" })
trigger_message4 = trigger_message_base:new({ message="Now find those secrets D;" })
trigger_message5 = trigger_message_base:new({ message="Heheheheeeehehe" })
trigger_message6 = trigger_message_base:new({ message="Ooooooooomg" })
trigger_message7 = trigger_message_base:new({ message="De Macona haft mere Hmmmmmm" })


         end
end

------------------------------------------------------
--FLAGS -- taken from Concmap.lua by Public_Slots_Free
------------------------------------------------------
-----


local flags = {"red_flag", "blue_flag", "green_flag", "yellow_flag", "red_flag2", "blue_flag2", "green_flag2", "yellow_flag2"}


-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

blue_flag2 = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

red_flag2 = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})
						  
yellow_flag2 = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

green_flag2 = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green_new.vtf",
						 hudx = 5,
						 hudy = 119,
						 hudwidth = 56,
						 hudheight = 56,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen, AllowFlags.kRed}})

-----------------------------------------------------------------------------
-- Flag (allows own team to get their flag)
-----------------------------------------------------------------------------

function baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	-- make sure they don't have any flags already
	for i,v in ipairs(flags) do
		if player:HasItem(v) then return end
	end
	
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP")
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		RemoveHudItemFromAll( flag:GetName() .. "_h" )
		RemoveHudItemFromAll( flag:GetName() .. "_d" )
		AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flag:GetName() .. "_c" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )

		-- log action in stats
		player:AddAction(nil, "ctf_flag_touch", flag:GetName())

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
end


function baseflag:dropitemcmd( owner_entity )

end

-----------------------------------------------------------------------------
-- Conc Backpack
-----------------------------------------------------------------------------

grenadebackpack = genericbackpack:new({
	rockets = 50,
	gren = 4,
	shells = 60,
	cells = 60,
	nails = 60,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function grenadebackpack:dropatspawn() return true end


function grenadebackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kPyro then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		elseif class == Player.kEngineer then
			dispensed = dispensed + player:AddAmmo( Ammo.kGren1, 2 )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
			dispensed = dispensed + player:AddAmmo( Ammo.kCells, self.cells )
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
			dispensed = dispensed + player:AddAmmo( Ammo.kShells, self.shells )
			dispensed = dispensed + player:AddAmmo( Ammo.kNails, self.nails )
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

function grenadebackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function grenadebackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

------------------------------------------------------------------
--conc remove
------------------------------------------------------------------

conc_remover = trigger_ff_script:new({})

function conc_remover:ontrigger(allowed_entity)
	if IsPlayer(allowed_entity) then
		local player = CastToPlayer(allowed_entity)
		if player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic then
			player:RemoveAmmo(Ammo.kGren2, 4)
		end
	end
end

function restock_all()
	local c = Collection()
	-- get all players
	c:GetByFilter({CF.kPlayers})
	-- loop through all players
	for temp in c.items do
		local player = CastToPlayer( temp )
		if player then
			-- add ammo/health/armor/etc
			class = player:GetClass()
			if player:GetTeamId() == Team.kGreen then
				if player:GetClass() == Player.kSoldier then
					player:AddAmmo( Ammo.kGren1, 2 )
					player:AddAmmo(Ammo.kRockets, 50)
					player:AddAmmo( Ammo.kShells, 50 )	
				elseif player:GetClass() == Player.kDemoman then
					player:AddAmmo( Ammo.kGren1, 2 )
					player:AddAmmo(Ammo.kRockets, 50)
					player:AddAmmo( Ammo.kShells, 50 )
				elseif player:GetClass() == Player.kScout then
					player:AddAmmo(Ammo.kGren2, 3)
					player:AddAmmo( Ammo.kShells, 50 )
					player:AddAmmo( Ammo.kNails, 50 )
				elseif player:GetClass() == Player.kMedic then
					player:AddAmmo(Ammo.kGren2, 3)
					player:AddAmmo( Ammo.kShells, 50 )
					player:AddAmmo( Ammo.kNails, 50 )
				elseif player:GetClass() == Player.kPyro then
					player:AddAmmo( Ammo.kGren1, 2 )
					player:AddAmmo(Ammo.kRockets, 50)
					player:AddAmmo( Ammo.kCells, 50 )
					player:AddAmmo( Ammo.kShells, 50 )
				end
			end
		end
	end
end
