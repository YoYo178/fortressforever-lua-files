-- WELCOME TO SPIDER CROSSINGS
-- GET THE FUCK OUT OF MY LUA
-- THANK YOU
-- NEON

-----------------------------------------------------------------------------
-- Includes
-----------------------------------------------------------------------------

IncludeScript("base");
IncludeScript("base_ctf");
IncludeScript("base_teamplay");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------

resup_validspawn = function(self,player) return player:GetTeamId() == self.team and (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic or player:GetClass() == Player.kSniper or player:GetClass() == Player.kSpy) end
shoop_validspawn = function(self,player) return player:GetTeamId() == self.team and not resup_validspawn(self,player) end

blue_shoopspawn = info_ff_teamspawn:new( { validspawn = shoop_validspawn, team=Team.kBlue } )
blue_resupspawn = info_ff_teamspawn:new( { validspawn = resup_validspawn, team=Team.kBlue } )

red_shoopspawn = info_ff_teamspawn:new( { validspawn = shoop_validspawn, team=Team.kRed } )
red_resupspawn = info_ff_teamspawn:new( { validspawn = resup_validspawn, team=Team.kRed } )

-----------------------------------------------------------------------------
-- small lift
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 600 })
lift_blue = base_jump:new({ pushz = 600 })
midlift_red = base_jump:new({ pushz = 760 })
midlift_blue = base_jump:new({ pushz = 760 })
spawnlift_red = base_jump:new({ pushz = 1200 })
spawnlift_blue = base_jump:new({ pushz = 1200 })

-----------------------------------------------------------------------------
-- yard lift
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

-----------------------------------------------------------------------------
-- Team Only Doors
-----------------------------------------------------------------------------

blue_only = bluerespawndoor
red_only = redrespawndoor