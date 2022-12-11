function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end


ftw = trigger_ff_script:new()

function ftw:ontouch()
	AddHudIconToAll("hud_team_red.vtf", "winner", 0, 64, 128, 128, 4)
	AddHudIconToAll("hud_team_blue.vtf", "loser1", -128, 272, 64, 64, 4)
	AddHudIconToAll("hud_team_green.vtf", "loser2", 0, 272, 64, 64, 4)
	AddHudIconToAll("hud_team_yellow.vtf", "loser3", 128, 272, 64, 64, 4)

	AddHudTextToAll("winscore", "120", 0, 192, 4)
	AddHudTextToAll("wintext", "Red Team WINS!", 0, 200, 4)

	AddHudTextToAll("losetext1", "2nd Place", 98, 256, 2)
	AddHudTextToAll("losescore1", "90", 120, 336, 2)

	AddHudTextToAll("losetext2", "3rd Place", 4, 256, 4)
	AddHudTextToAll("losescore2", "50", 0, 336, 4)

	AddHudTextToAll("losetext3", "  4th Place", 132, 256, 4)
	AddHudTextToAll("losescore3", "10", 128, 336, 4)

end

function ftw:onendtouch()
	RemoveHudItemFromAll("winner")
	RemoveHudItemFromAll("loser1")
	RemoveHudItemFromAll("loser2")
	RemoveHudItemFromAll("loser3")

	RemoveHudItemFromAll("winscore")
	RemoveHudItemFromAll("wintext")

	RemoveHudItemFromAll("losetext1")
	RemoveHudItemFromAll("losescore1")

	RemoveHudItemFromAll("losetext2")
	RemoveHudItemFromAll("losescore2")

	RemoveHudItemFromAll("losetext3")
	RemoveHudItemFromAll("losescore3")

end
