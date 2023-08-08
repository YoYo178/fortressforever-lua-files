
-- base_shutdown.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 45;

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
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDBUTTON" )
	end
end

-----------------------------------------------------------------------------
-- Button inputs (touch, use, damage etc.)
-----------------------------------------------------------------------------

-- red button
--button_red = button_common:new({ team = Team.kBlue, sec_up = true }) 

button_red = button_common:new({ 
	team = Team.kBlue, 
	sec_up = true, 
	sec_down_icon = "hud_secdown.vtf", 
	sec_up_icon = "hud_secup_red.vtf", 
	iconx = 60,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 3
}) 

-----------------------------------------------------------------------------
-- Button responses 
-----------------------------------------------------------------------------
function button_red:OnIn() 
	BroadCastMessage( "#FF_RED_SECURITY_DEACTIVATED" )
	SpeakAll( "SD_REDDOWN" )

	self.sec_up = false
	red_sound_laser = false

	RemoveHudItemFromAll( "red-sec-up")
	AddHudIconToAll( self.sec_down_icon, "red-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )

--	RemoveHudItemFromAll( "hud_cp_red.vtf" )
--	AddHudIconToAll( "hud_cp_neutral.vtf", "hud_cp_neutral.vtf", 10,10,10,10,2 )
end 

function button_red:OnOut()
	BroadCastMessage( "#FF_RED_SECURITY_ACTIVATED" )
	SpeakAll( "SD_REDUP" )

	self.sec_up = true
	red_sound_laser = true

	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( self.sec_up_icon, "red-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end

-----------------------------------------------------------------------------
-- Button inputs (touch, use, damage etc.)
-----------------------------------------------------------------------------

-- blue button
--button_blue = button_common:new({ team = Team.kRed, sec_up = true }) 

button_blue = button_common:new({ 
	team = Team.kRed, 
	sec_up = true, 
	sec_down_icon = "hud_secdown.vtf", 
	sec_up_icon = "hud_secup_blue.vtf", 
	iconx = 60,
	icony = 25,
	iconw = 16,
	iconh = 16,
	iconalign = 2
}) 

-----------------------------------------------------------------------------
-- Button responses 
-----------------------------------------------------------------------------
function button_blue:OnIn() 
	BroadCastMessage( "#FF_BLUE_SECURITY_DEACTIVATED" )
	SpeakAll( "SD_BLUEDOWN" )

	self.sec_up = false

	RemoveHudItemFromAll( "blue-sec-up")
	AddHudIconToAll( self.sec_down_icon, "blue-sec-down", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )

--	RemoveHudItem( player, "hud_cp_blue.vtf")
--	AddHudIconToAll( "hud_cp_neutral.vtf", "hud_cp_neutral2.vtf", 10,10,10,10,3 )
end 

function button_blue:OnOut()
	BroadCastMessage( "#FF_BLUE_SECURITY_ACTIVATED" )
	SpeakAll( "SD_BLUEUP" )

	self.sec_up = true

	RemoveHudItemFromAll( "blue-sec-down")
	AddHudIconToAll( self.sec_up_icon, "blue-sec-up", self.iconx, self.icony, self.iconw, self.iconh, self.iconalign )
end

-----------------------------------------------------------------------------
-- Hurts
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-- function precache()
	-- precache sounds	
--	PrecacheSound("vox.blueup")
--	PrecacheSound("vox.bluedown")
--	PrecacheSound("vox.redup")
--	PrecacheSound("vox.reddown")
-- end


-------------------------
-- flaginfo
-------------------------

---------------------------- COPIED FROM BASE_CTF ----------------

function flaginfo( player_entity )
-- at the moment this is crappy workaround - simply displays the home icon
	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, blue_flag.name )
	RemoveHudItem( player, blue_flag.name .. "_c" )
	RemoveHudItem( player, blue_flag.name .. "_d" )

	RemoveHudItem( player, red_flag.name )
	RemoveHudItem( player, red_flag.name .. "_c" )
	RemoveHudItem( player, red_flag.name .. "_d" )

	-- copied from blue_flag variables
	AddHudIcon( player, blue_flag.hudstatusiconhome, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	AddHudIcon( player, red_flag.hudstatusiconhome, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	
	local flag = GetInfoScriptByName("blue_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("red_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	end

----------------- END PASTE FROM CTF ---------------------------------

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

		if button_blue.sec_up == true then
			AddHudIcon( player, button_blue.sec_up_icon, "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, button_blue.iconalign )
		else
			AddHudIcon( player, button_blue.sec_down_icon, "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, button_blue.iconalign )
		end

		if button_red.sec_up == true then
			AddHudIcon( player, button_red.sec_up_icon, "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, button_red.iconalign )
		else
			AddHudIcon( player, button_red.sec_down_icon, "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, button_red.iconalign )
		end
		
	function player_spawn( player_entity ) 
		local player = CastToPlayer( player_entity ) 

		player:AddHealth( 400 ) 
		player:AddArmor( 400 ) 

		player:AddAmmo( Ammo.kNails, 400 ) 
		player:AddAmmo( Ammo.kShells, 400 ) 
		player:AddAmmo( Ammo.kRockets, 400 ) 
		player:AddAmmo( Ammo.kCells, 400 ) 

	end

end