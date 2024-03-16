require "base_ctf"

function player_ondamage(victim, damageinfo)
	damageinfo:SetDamage(0)
	local damageforce = damageinfo:GetDamageForce()
	damageinfo:SetDamageForce(Vector( damageforce.x * 2, damageforce.y * 2, damageforce.z * 2))
end