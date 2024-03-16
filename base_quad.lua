-- base_quad.lua

----------------------------------------------------------------------
-- Quad icon
----------------------------------------------------------------------

hudicon = "hud_quad"
hudx = 5
hudy = 110
hudw = 48
hudh = 48
huda = 1
hudstatusicon = "hud_quad.vtf"

----------------------------------------------------------------------
-- Set hud icon at spawn
----------------------------------------------------------------------

function player_spawn( player_entity )
    local player = CastToPlayer( player_entity )
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
        if player:GetTeamId() ~= Team.kRed then
	    RemoveHudItem( player, hudstatusicon )
 	else
 	    AddHudIcon(player, hudicon, hudstatusicon, hudx, hudy, hudw, hudh, huda)
	end
    else
	RemoveHudItem( player, hudstatusicon )
    end
end

								
----------------------------------------------------------------------
-- Remove hud icon if player changes to spectator
----------------------------------------------------------------------

function player_switchteam( player, currentteam, desiredteam )
    if desiredteam == Team.kSpectator then
    	RemoveHudItem( player, hudstatusicon )
    end
    return true
end

----------------------------------------------------------------------
-- Set quad and invul when damage is taken by soldier and demoman and pyro
----------------------------------------------------------------------

function player_ondamage( player, damageinfo )
    if player:GetTeamId() ~= Team.kRed then return end
    local class = player:GetClass()
    if class == Player.kSoldier or class == Player.kDemoman or class==Player.kPyro then
	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 4, damageforce.y * 4, damageforce.z * 4))
	damageinfo:SetDamage( 0 )
    end
end


