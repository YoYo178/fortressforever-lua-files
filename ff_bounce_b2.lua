
-- base_ctf4.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")

-----------------------------------------------------------------------------
-- map level handlers
-----------------------------------------------------------------------------
function startup()
	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)
	
	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

function player_killed( player, damageinfo )
  local attacker = damageinfo:GetAttacker()
  if IsPlayer( attacker ) then
    local team = attacker:GetTeam()
    team:AddScore( 1 )

  end

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, blue_flag.name .. "_c" )
	RemoveHudItem( player, blue_flag.name .. "_d" )

	RemoveHudItem( player, red_flag.name .. "_c" )
	RemoveHudItem( player, red_flag.name .. "_d" )

	RemoveHudItem( player, green_flag.name .. "_c" )
	RemoveHudItem( player, green_flag.name .. "_d" )

	RemoveHudItem( player, yellow_flag.name .. "_c" )
	RemoveHudItem( player, yellow_flag.name .. "_d" )

	-- copied from blue_flag variables
	AddHudIcon( player, blue_flag.hudstatusiconhome, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	AddHudIcon( player, red_flag.hudstatusiconhome, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	AddHudIcon( player, green_flag.hudstatusiconhome, ( green_flag.name.. "_h" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	AddHudIcon( player, yellow_flag.hudstatusiconhome, ( yellow_flag.name.. "_h" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )

	local flag = GetInfoScriptByName("blue_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( blue_flag.name.. "_c" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( blue_flag.name.. "_d" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("red_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( red_flag.name.. "_c" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( red_flag.name.. "_d" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	end

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
end