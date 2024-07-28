--[[
ISC License

Copyright 2024 mv <mv@darkok.xyz>

Permission to use, copy, modify, and/or distribute this software for any 
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--]]

gamemodes = {}
player_table = {}
vote_selections = {}

rtv = {
	initvotes = 0,
	wait = 10,
	voting = false,
	minplayers = 4
}

function register_gm(key, gamemode_name, gamemode_init, gamemode_end)
    if gamemodes[key] ~= nil then
        return false
    end
	gamemodes[key] = {init = gamemode_init, name = gamemode_name, endfunc = gamemode_end, currentlyrunning = false}
	return true
end

function rtv.init()
	rtv.voting = true
	previousgamemode = ""
	local count = 0
	DestroyMenu("gmvote")
	CreateMenu("gmvote", "Gamemode Voting", rtv.wait)
	for k, v in pairs(gamemodes) do
		count = count + 1
		vote_selections[count] = k
		if v.currentlyrunning then previousgamemode = k end
		AddMenuOption("gmvote", count, v.name .. (v.currentlyrunning and " (Currently running)" or ""))
	end
	
	for _, player in pairs(player_table) do
			player.vote = nil
	end

	for _, player in ipairs(GetPlayers()) do
		ShowMenuToPlayer(player, "gmvote")
	end
	
	AddSchedule( "endvoteresults", rtv.wait, function()
		rtv.voting = false
		rtv.initvotes = 0
		ConsoleToAll("end vote!")
	    local voteCounts = {}
		for _, player in pairs(player_table) do
			player.voted = nil
			local voteOption = player.vote
			if voteOption then
				if not voteCounts[voteOption] then
					voteCounts[voteOption] = 1
				else
					voteCounts[voteOption] = voteCounts[voteOption] + 1
				end
			end
		end

		local winningOption, maxVotes = nil, 0
		for option, count in pairs(voteCounts) do
			if count > maxVotes then
				maxVotes = count
				winningOption = option
			end
		end
		ChatToAll(gamemodes[winningOption].name .. " won! switching right now")
		gamemodes[previousgamemode].currentlyrunning = false
		gamemodes[previousgamemode].endfunc()
		gamemodes[winningOption].currentlyrunning = true
		gamemodes[winningOption].init()
	end)
end

function rtv.shouldchange()
	return rtv.initvotes >= math.floor(NumPlayers()*0.66)
end

function rtv.canvote(player)
	if rtv.voting then
		ChatToPlayer(player, "There is currently a vote in progress!")
		return false
	end

	if player_table[player:GetSteamID()].voted then
		ChatToPlayer(player, "You have already voted to Rock the Vote!")
		return false
	end

	if NumPlayers() < rtv.minplayers then
		ChatToPlayer(player, "You need more players before you can rock the vote!")
        return false
    end

	return true
end

-- Event listeners
function player_onmenuselect( player, menu_name, num )
	if menu_name == "gmvote" then
		if player_table[player:GetSteamID()] == nil then player_table[player:GetSteamID()] = {} end
		ChatToAll(player:GetName() .. " has voted for " .. gamemodes[vote_selections[num]].name)
		player_table[player:GetSteamID()].vote = vote_selections[num]
	end
end


function player_onchat( player, chatstring )
	local player = CastToPlayer( player )
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
	if player_table[player:GetSteamID()] == nil then player_table[player:GetSteamID()] = {} end
	
	if message == "vote" then 
		if rtv.canvote(player) then
			rtv.initvotes = rtv.initvotes + 1
			player_table[player:GetSteamID()].voted = true
			
			ChatToAll(tostring(player:GetName()).." has voted. ("..rtv.initvotes.."/"..math.floor(NumPlayers()*0.66)..")" )
			if rtv.shouldchange() then
				rtv.init()
			end
		end
		return false
	end
	return true
end

function player_disconnected( player )
	local player = CastToPlayer ( player )
	if player_table[player:GetSteamID()].voted then
		rtv.initvotes = rtv.initvotes - 1
		if rtv.shouldchange() then
			rtv.init()
		end
	end
	player_table[player:GetSteamID()] = nil
end