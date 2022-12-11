IncludeScript("base_ctf");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 25

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------
function startup()

	SetGameDescription( "Capture the Dong" )
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, 0)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, 0)
end

-----------------------------------------------------------------------------
-- Yard Lift
-----------------------------------------------------------------------------
base_angle_jump = trigger_ff_script:new( {pushz=0, pushx=0, pushy=0} )

function base_angle_jump:ontouch( trigger_entity )
if IsPlayer(trigger_entity) then
local player = CastToPlayer(trigger_entity)
local playerVel = player:GetVelocity()
if self.pushz ~= 0 then playerVel.z = self.pushz end
if self.pushx ~= 0 then playerVel.x = self.pushx end
if self.pushy ~= 0 then playerVel.y = self.pushy end
player:SetVelocity( playerVel )
end
end

angle_jump1 = base_angle_jump:new( {pushz=700, pushx=700} )
angle_jump2 = base_angle_jump:new( {pushz=700, pushx=-700} )
