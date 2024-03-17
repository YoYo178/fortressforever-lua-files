-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_location");
IncludeScript("base_respawnturret");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------
-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock

-----------------------------------------------------------------------------
-- setting up detpack trigger once
-----------------------------------------------------------------------------
DETPACKTRIGGER = {blueteam = false, redteam = false, yellowteam = false, greenteam = false}


blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kGreen} })

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kYellow} })						  

-- red cap point
red_cap = basecap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})

-- yellow cap point						
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"blue_flag","red_flag","green_flag"}})

-- green cap point						
green_cap = basecap:new({team = Team.kGreen,
						item = {"blue_flag","red_flag","yellow_flag"}})

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------
function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, -1)
	SetPlayerLimit(Team.kRed, -1)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kGreen)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kYellow)
	team:SetClassLimit(Player.kCivilian, -1)
end

function precache()
	-- precache sounds
	PrecacheSound("ff_vault.zelda_nes_secret")
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("vox.yourcap")
	PrecacheSound("vox.enemycap")
	PrecacheSound("vox.yourstole")
	PrecacheSound("vox.enemystole")
	PrecacheSound("vox.yourflagret")
	PrecacheSound("vox.enemyflagret")
end



-----------------------------------------------------------------------------
-- team restrictions
-----------------------------------------------------------------------------
--SetPlayerLimit( Team.kBlue, -1 )
--SetPlayerLimit( Team.kRed, -1)
--SetPlayerLimit( Team.kYellow, 0)
--SetPlayerLimit( Team.kGreen, 0 )

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- FIESTA!
-----------------------------------------------------------------------------

base_wall_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_wall_trigger:onexplode( explosion_entity )
  if IsDetpack( explosion_entity ) then
    local detpack = CastToDetpack( explosion_entity )

    -- GetTeamId() might not exist for buildables, they have their own seperate shit and it might be named differently
    if detpack:GetTeamId() ~= self.team then
      if not DETPACKTRIGGER[self.team] then
        OutputEvent( self.team_name .. "_wall", "Kill","", 0.00 )
        BroadCastSound ( "ff_vault.zelda_nes_secret" )
        BroadCastMessage( "FIESTA!" )
	  DETPACKTRIGGER[self.team] = true;
      end 
  end
end

-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
return EVENT_ALLOWED
end

yellow_wall_trigger = base_wall_trigger:new({ team = Team.kYellow, team_name = "yellow" })
green_wall_trigger = base_wall_trigger:new({ team = Team.kGreen, team_name = "green" })

-----------------------------------------------------------------------------
-- Force Fields Clip
-----------------------------------------------------------------------------

clip_brush = trigger_ff_clip:new({ clipflags = 0 })

green_clip = clip_brush:new({ clipflags = {ClipFlags.kClipTeamYellow} })
yellow_clip = clip_brush:new({ clipflags = {ClipFlags.kClipTeamGreen} })

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

-- base button stuff (common functionality)
button_common = func_button:new({ team = Team.kUnassigned }) 

function button_common:allowed( allowed_entity ) 
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- TODO this doesn't work
function button_common:onfailuse( use_entity )
	if IsPlayer( use_entity ) then
		local player = CastToPlayer( use_entity )
		BroadCastMessageToPlayer( player, "It would be pretty dumb to open your own vault door." )
	end
end

-----------------------------------------------------------------------------
-- Green Vault Button Inputs
-----------------------------------------------------------------------------

-- green button
--button_green = button_common:new({ team = Team.kYellow, sec_up = true }) 

button_green = button_common:new({ 
	team = Team.kYellow, 
	sec_up = true, 
	sec_down_icon = "hud_cp_neutral.vtf",
	sec_up_icon = "hud_cp_green.vtf", 
	sec_num_icon = "hud_cp_1.vtf",
	iconx = 60,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 3
})

-----------------------------------------------------------------------------
-- Green Vault Button Responses
-----------------------------------------------------------------------------
function button_green:OnIn() 
	BroadCastMessage( "Green's Vault is opening!" )
	SpeakAll( "SD_GREENDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "green-sec-up")
    RemoveHudItemFromAll( "green-sec-number")
	AddHudIconToAll( self.sec_down_icon, "green-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "green-sec-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )


--	RemoveHudItemFromAll( "hud_cp_green.vtf" )
--	AddHudIconToAll( "hud_cp_neutral.vtf", "hud_cp_neutral.vtf", 10,10,10,10,2 )
end 

function button_green:OnOut()
	BroadCastMessage( "Green's Vault is closed!" )
	SpeakAll( "SD_GREENUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "green-sec-down" )
    RemoveHudItemFromAll( "green-sec-number")
	AddHudIconToAll( self.sec_up_icon, "green-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "green-sec-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end

-----------------------------------------------------------------------------
-- Green Silo Button Inputs
-----------------------------------------------------------------------------

-- green button
--button_green = button_common:new({ team = Team.kYellow, sec_up = true }) 

green_silo_button = button_common:new({ 
	team = Team.kYellow, 
	sec_up = true, 
	sec_down_icon = "hud_cp_neutral.vtf", 
	sec_up_icon = "hud_cp_green.vtf", 
	sec_num_icon = "hud_cp_2.vtf",
	iconx = 80,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 3
}) 

-----------------------------------------------------------------------------
-- Green Silo Button Responses
-----------------------------------------------------------------------------
function green_silo_button:OnIn() 
	BroadCastMessage( "Green's Silo Door is opening!" )
	SpeakAll( "SD_GREENDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "green-silo-up")
	RemoveHudItemFromAll( "green-silo-number")
	AddHudIconToAll( self.sec_down_icon, "green-silo-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "green-silo-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end 

function green_silo_button:OnOut()
	BroadCastMessage( "Green's Silo Door is closed!" )
	SpeakAll( "SD_GREENUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "green-silo-down" )
	RemoveHudItemFromAll( "green-silo-number")
	AddHudIconToAll( self.sec_up_icon, "green-silo-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "green-silo-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end



-----------------------------------------------------------------------------
-- Yellow Vault Button Inputs
-----------------------------------------------------------------------------

-- yellow button
--button_yellow = button_common:new({ team = Team.kYellow, sec_up = true }) 

button_yellow = button_common:new({ 
	team = Team.kGreen, 
	sec_up = true, 
	sec_down_icon = "hud_cp_neutral.vtf",
	sec_up_icon = "hud_cp_yellow.vtf", 
	sec_num_icon = "hud_cp_1.vtf",
	iconx = 60,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 2
})

-----------------------------------------------------------------------------
-- Yellow Vault Button Responses
-----------------------------------------------------------------------------
function button_yellow:OnIn() 
	BroadCastMessage( "Yellow's Vault is opening!" )
	SpeakAll( "SD_YELLOWDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "yellow-sec-up")
    RemoveHudItemFromAll( "yellow-sec-number")
	AddHudIconToAll( self.sec_down_icon, "yellow-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "yellow-sec-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )


--	RemoveHudItemFromAll( "hud_cp_yellow.vtf" )
--	AddHudIconToAll( "hud_cp_neutral.vtf", "hud_cp_neutral.vtf", 10,10,10,10,2 )
end 

function button_yellow:OnOut()
	BroadCastMessage( "Yellow's Vault is closed!" )
	SpeakAll( "SD_YELLOWUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "yellow-sec-down" )
    RemoveHudItemFromAll( "yellow-sec-number")
	AddHudIconToAll( self.sec_up_icon, "yellow-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "yellow-sec-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end

-----------------------------------------------------------------------------
-- Yellow Silo Button Inputs
-----------------------------------------------------------------------------

-- yellow button
--button_yellow = button_common:new({ team = Team.kYellow, sec_up = true }) 

yellow_silo_button = button_common:new({ 
	team = Team.kGreen, 
	sec_up = true, 
	sec_down_icon = "hud_cp_neutral.vtf", 
	sec_up_icon = "hud_cp_yellow.vtf", 
	sec_num_icon = "hud_cp_2.vtf",
	iconx = 80,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 2
}) 

-----------------------------------------------------------------------------
-- Yellow Silo Button Responses
-----------------------------------------------------------------------------
function yellow_silo_button:OnIn() 
	BroadCastMessage( "yellow's Silo Door is opening!" )
	SpeakAll( "SD_YELLOWDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "yellow-silo-up")
	RemoveHudItemFromAll( "yellow-silo-number")
	AddHudIconToAll( self.sec_down_icon, "yellow-silo-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "yellow-silo-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end 

function yellow_silo_button:OnOut()
	BroadCastMessage( "Yellow's Silo Door is closed!" )
	SpeakAll( "SD_YELLOWUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "yellow-silo-down" )
	RemoveHudItemFromAll( "yellow-silo-number")
	AddHudIconToAll( self.sec_up_icon, "yellow-silo-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
    AddHudIconToAll( self.sec_num_icon, "yellow-silo-number", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end


-------------------------
-- flaginfo
-------------------------

---------------------------- COPIED FROM BASE_CTF ----------------

function flaginfo( player_entity )
-- at the moment this is crappy workaround - simply displays the home icon
	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, green_flag.name .. "_c" )
	RemoveHudItem( player, green_flag.name .. "_d" )

	RemoveHudItem( player, yellow_flag.name .. "_c" )
	RemoveHudItem( player, yellow_flag.name .. "_d" )

	-- copied from blue_flag variables
	AddHudIcon( player, green_flag.hudstatusiconhome, ( green_flag.name.. "_h" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	AddHudIcon( player, yellow_flag.hudstatusiconhome, ( yellow_flag.name.. "_h" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )


	flag = GetInfoScriptByName("yellow_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, yellow_flag.hudstatusiconcarried, ( yellow_flag.name.. "_c" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, yellow_flag.hudstatusicondropped, ( yellow_flag.name.. "_d" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("green_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, green_flag.hudstatusiconcarried, ( green_flag.name.. "_c" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, green_flag.hudstatusicondropped, ( green_flag.name.. "_d" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	end

----------------- END PASTE FROM CTF ---------------------------------

	RemoveHudItem( player, "yellow-sec-number" )
	RemoveHudItem( player, "green-sec-number" )
	RemoveHudItem( player, "yellow-silo-number" )
	RemoveHudItem( player, "green-silo-number" )
	
	RemoveHudItem( player, "yellow-sec-down" )
	RemoveHudItem( player, "green-sec-down" )
	RemoveHudItem( player, "yellow-sec-up" )
	RemoveHudItem( player, "green-sec-up" )
	
	RemoveHudItem( player, "yellow-silo-down" )
	RemoveHudItem( player, "green-silo-down" )
	RemoveHudItem( player, "yellow-silo-up" )
	RemoveHudItem( player, "green-silo-up" )

		if button_green.sec_up == true then
			AddHudIcon( player, button_green.sec_up_icon, "green-sec-up", button_green.iconx, button_green.icony, button_green.iconw, button_green.iconh, button_green.iconalign )
			AddHudIcon( player, button_green.sec_num_icon, "green-sec-number", button_green.iconx, button_green.icony, button_green.iconw, button_green.iconh, button_green.iconalign )
		else
			AddHudIcon( player, button_green.sec_down_icon, "green-sec-down", button_green.iconx, button_green.icony, button_green.iconw, button_green.iconh, button_green.iconalign )
			AddHudIcon( player, button_green.sec_num_icon, "green-sec-number", button_green.iconx, button_green.icony, button_green.iconw, button_green.iconh, button_green.iconalign )
		end

		if green_silo_button.sec_up == true then
			AddHudIcon( player, green_silo_button.sec_up_icon, "green-silo-up", green_silo_button.iconx, green_silo_button.icony, green_silo_button.iconw, green_silo_button.iconh, green_silo_button.iconalign )
			AddHudIcon( player, green_silo_button.sec_num_icon, "green-silo-number", green_silo_button.iconx, green_silo_button.icony, green_silo_button.iconw, green_silo_button.iconh, green_silo_button.iconalign )
		else
			AddHudIcon( player, green_silo_button.sec_down_icon, "green-silo-down", green_silo_button.iconx, green_silo_button.icony, green_silo_button.iconw, green_silo_button.iconh, green_silo_button.iconalign )
			AddHudIcon( player, green_silo_button.sec_num_icon, "green-silo-number", green_silo_button.iconx, green_silo_button.icony, green_silo_button.iconw, green_silo_button.iconh, green_silo_button.iconalign )
		end
		
		if button_yellow.sec_up == true then
			AddHudIcon( player, button_yellow.sec_up_icon, "yellow-sec-up", button_yellow.iconx, button_yellow.icony, button_yellow.iconw, button_yellow.iconh, button_yellow.iconalign )
			AddHudIcon( player, button_yellow.sec_num_icon, "yellow-sec-number", button_yellow.iconx, button_yellow.icony, button_yellow.iconw, button_yellow.iconh, button_yellow.iconalign )
		else
			AddHudIcon( player, button_yellow.sec_down_icon, "yellow-sec-down", button_yellow.iconx, button_yellow.icony, button_yellow.iconw, button_yellow.iconh, button_yellow.iconalign )
			AddHudIcon( player, button_yellow.sec_num_icon, "yellow-sec-number", button_yellow.iconx, button_yellow.icony, button_yellow.iconw, button_yellow.iconh, button_yellow.iconalign )
		end

		if yellow_silo_button.sec_up == true then
			AddHudIcon( player, yellow_silo_button.sec_up_icon, "yellow-silo-up", yellow_silo_button.iconx, yellow_silo_button.icony, yellow_silo_button.iconw, yellow_silo_button.iconh, yellow_silo_button.iconalign )
			AddHudIcon( player, yellow_silo_button.sec_num_icon, "yellow-silo-number", yellow_silo_button.iconx, yellow_silo_button.icony, yellow_silo_button.iconw, yellow_silo_button.iconh, yellow_silo_button.iconalign )
		else
			AddHudIcon( player, yellow_silo_button.sec_down_icon, "yellow-silo-down", yellow_silo_button.iconx, yellow_silo_button.icony, yellow_silo_button.iconw, yellow_silo_button.iconh, yellow_silo_button.iconalign )
			AddHudIcon( player, yellow_silo_button.sec_num_icon, "yellow-silo-number", yellow_silo_button.iconx, yellow_silo_button.icony, yellow_silo_button.iconw, yellow_silo_button.iconh, yellow_silo_button.iconalign )
		end
end