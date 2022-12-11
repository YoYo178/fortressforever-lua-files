------------------------------------------------------------
-- Base_Race.lua
-- 
------------------------------------------------------------

-- settings

RACE_TIME_PRECISION = 3

RACE_DEBUG = { ENABLED = true, SEND_TO_CHAT = false, VERBOSE = true }

------------------------------------------------------------
-- Necessary things
------------------------------------------------------------
local Races = {}
local RACE_STATS = { NUM_RACES = 0 }

local IsPlayer_base = IsPlayer
IsPlayer = function( player )
	return type(player) == "userdata" and IsPlayer_base(player)
end

------------------------------------------------------------
-- Chat commands
------------------------------------------------------------
if not chatbase_commands then IncludeScript("base_chatcommands") end

chatbase_addcommand( "top", "Displays the top <num> (default 5) in <race> (default All-Time)", "top 5 [raceid]" )
function chat_top( player, num, raceid )
	raceid = raceid or nil
	num = num ~= "" and num or 5
	num = math.max( num, 15 )
	local race = racid and GetRaceById( raceid ) or AllTime
	if race then
		race:PrintLeaderboard( num )
	end
end

chatbase_addcommand( "rank", "Displays your current rank in <race> (default All-Time)", "rank [raceid]" )
function chat_rank( player, raceid )
	raceid = raceid or nil
	local race = racid and GetRaceById( raceid ) or AllTime
	if race then
		local racer = GetRacerByPlayer( player )
		local place, record = race:GetCurrentRecord( racer )
		if place then
			RaceMessage( player, "Your "..tostring(race).." rank: #"..place.." with a time of "..record:GetTime() )
		else
			RaceMessage( player, "No current record found" )
		end
	end
end

------------------------------------------------------------
-- Class definition
------------------------------------------------------------
-- class.lua
-- Compatible with Lua 5.1 (not 5.0).
function Class(base, _ctor)
    local c = {}    -- a new class instance
    if not _ctor and type(base) == 'function' then
        _ctor = base
        base = nil
    elseif type(base) == 'table' then
    -- our new class is a shallow copy of the base class!
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj,c)
	
        if _ctor then
            _ctor(obj,...)
        end
        return obj
    end    
        
    c._ctor = _ctor
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do 
            if m == klass then return true end
            m = m._base
        end
        return false
    end
    setmetatable(c, mt)
    return c
end

------------------------------------------------------------
-- Test class
------------------------------------------------------------
local Tests = {}

Test = Class(function(self, name)
	self.name = name
	self.tests_failed = 0
	self.tests_passed = 0
	table.insert(Tests,self)
	self:start()
end)

function Test:start()
	ChatToAll("[^5"..self.name.."^]")
end

function Test:test(result, message, actual)
	if actual == false then actual = result end
	if not result then
		ChatToAll("\t[^5"..self.name.."^]^2 test failed: '"..message.."' actual: "..tostring(actual))
		self.tests_failed = self.tests_failed + 1
	else
		ChatToAll("\t[^5"..self.name.."^]^4 test passed: '"..message.."' actual: "..tostring(actual))
		self.tests_passed = self.tests_passed + 1
	end
end

function Test:finish( shouldprint )
	self.finished = true
	if shouldprint then
		self:results()
	end
end

function Test:results()
	local color = self.tests_failed > 0 and (self.tests_passed > 0 and "^3" or "^2") or "^4"
	ChatToAll("[^5"..self.name.."^]"..color.." "..self.tests_passed.." tests passed, "..self.tests_failed.." failed")
end

function TestsFinished()
	for i,v in ipairs(Tests) do
		if not v.finished then return false end
	end
	return true
end
function PrintTestResults()
	for i,v in ipairs(Tests) do
		v:results()
	end
end

------------------------------------------------------------
-- Tests
------------------------------------------------------------
function TestClasses()
	local t = Test("TestClasses")
	local lua_testclass = Class( function(self) self.test = true end )
	local derived = Class( lua_testclass, function(self) lua_testclass._ctor(self); self.test2 = true end )

	local a = lua_testclass()
	t:test(a.test == true, "a.test == true")

	local b = derived()
	t:test(b.test == true, "b.test == true")
	t:test(b.test2 == true, "b.test2 == true")

	t:finish()
end

function TestRacer()
	local t = Test("TestRacer")
	--local racer = Racer("GetPlayerByID(1)")
	local racer2 = Racer("test")
	local racer2_copy = Racer("test")
	--t:test(racer.playerindex == GetPlayerIndex( GetPlayerByID(1) ), "racer.playerindex == GetPlayerIndex( GetPlayerByID(1) )", false)
	t:test(racer2 == racer2_copy, "racer2 == racer2_copy", false)
	t:finish()
end

function TestRace()
	local t = Test("TestRace")
	local race = Race()
	race:Start()
	t:test(race.active == true, "race.active == true")
	race:End()
	t:finish()
end

function TestAsyncRace()
	local t = Test("TestAsyncRace")
	local race = AsyncRace( "test" )
	local racer = Racer("slowguy")
	race:Started( racer )
	AddSchedule("test", .1, function()
		local curtime = race:GetCurrentTime(racer)
		t:test(curtime > 0, "race:GetCurrentTime(racer) > 0", curtime)
		race:Finished( racer )
		race:Started( racer )
		AddSchedule("test2", .1, function()
			local curtime = race:GetCurrentTime(racer)
			t:test(curtime > 0, "race:GetCurrentTime(racer) > 0", curtime)
			race:Finished( racer )
			t:test(race.leaderboard[2] == nil, "race.leaderboard[2] == nil", race.leaderboard[2])
			local bestracer = Racer("test")
			race:Started(bestracer)
			race:Finished(bestracer)
			t:test(race.leaderboard[2] ~= nil, "race.leaderboard[2] ~= nil", race.leaderboard[2])
			t:finish()
		end)
	end)
end

function TestAllTime()
	local t = Test("TestAllTime")
	local race = Race()
	race:Start()
	t:test(race.active, "Race started")
	race:End()
	t:finish()
end

------------------------------------------------------------
-- Record
------------------------------------------------------------
Record = Class( function( self, racer, time, oldplace, oldrecord, place, beatenrecord )
    self.racer = racer
    self.time = time
    self.place = place
    self.beatenrecord = beatenrecord
    self.oldplace = oldplace
    self.oldrecord = oldrecord
end )

function Record:__tostring()
	return self.racer:GetName()..": "..self:GetTime()
end

function Record:GetBeatenString( recordtype )
	if self:IsPB() then
		return self.racer:GetName().." finished in "..self:GetTime()..", beating their personal best by "..round(self.oldrecord.time-self.time, RACE_TIME_PRECISION).."s (rank #"..self.place.."; old PB: "..self.oldrecord:GetTime()..")"
	else
		local beaten
		if self.beatenrecord then
			beaten = "beat "..self.beatenrecord.racer:GetName().."'s previous rank #"..self.place.." time of "..self.beatenrecord:GetTime()
		else
			beaten = "rank #"..self.place
		end
		return self.racer:GetName().." finished in "..self:GetTime()..", setting a new record ("..beaten..")"
	end
end

function Record:GetTime()
	return ( (RACE_TIME_PRECISION ~= nil and RACE_TIME_PRECISION ~= false) and round( self.time, RACE_TIME_PRECISION ) or tostring( self.time ) ).."s"
end

function Record:PlayerIndex()
	return self.racer.playerindex
end

function Record:IsPB()
	return self.oldplace == self.place
end

function Record:OnSave()
	local data = {}
	data.racer = self.racer.playerindex
	data.time = self.time
	return data
end

function Record:OnLoad( data )
	self.racer = GetRacerByIndex( data.racer )
	self.time = data.time
end

------------------------------------------------------------
-- Racer
------------------------------------------------------------
Racer = Class( function( self, player, name, names )
	self.playerindex = GetPlayerIndex( player )
	self.player = GetPlayerByIndex( self.playerindex )
	self.name = name
	self.names = names or {}
	if IsPlayer( self.player ) then
		self:AddAlias( self.player:GetName() )
	end
	self.numraces = 0
	AllTime:AddRacer(self)
end )

function Racer:__eq( other )
	RaceDebug( tostring(self).." comparing to "..tostring(other) )
	if IsPlayer( other ) then
		return other == self:GetPlayer()
	elseif other and other.playerindex then
		return self.playerindex == other.playerindex
	end
	return false
end

function Racer:__tostring()
	return self:GetName().." ("..tostring(self.playerindex)..")"
end

function Racer:GetPlayer()
	return IsPlayer( self.player ) and self.player or GetPlayerByIndex( self.playerindex )
end

function Racer:GetName()
	return self.name or "<unknown>"
end

function Racer:SetName( alias )
	self.name = alias
end

function Racer:AddAlias( alias )
	local hadnames = next(self.names) ~= nil
	aliascount = self.names[ alias ]
	self.names[ alias ] = aliascount and (aliascount + 1) or 1
	if not hadnames or (self.names[ self:GetName() ] and self.names[ alias ] > self.names[ self:GetName() ]) then
		self:SetName( alias )
	end
end

function Racer:OnSave()
	local data = {
		playerindex = self.playerindex,
		name = self.name,
		names = self.names,
		numraces = self.numraces,
	}
	return data
end

function Racer:OnLoad( data )
	self.playerindex = data.playerindex
	self.name = data.name
	self.names = data.names
	self.numraces = data.numraces
end

------------------------------------------------------------
-- Race
-- don't print anything until the race ends
-- and then print the leaderboard
------------------------------------------------------------
Race = Class( function( self, id, racers, leaderboard )
	if not id then RACE_STATS.NUM_RACES = RACE_STATS.NUM_RACES + 1 end
	self.id = id or "Race_"..RACE_STATS.NUM_RACES
	if GetRaceById( self.id ) ~= nil then
		RaceWarning( "Race with the id '"..self.id.."' already exists")
	end
	self.racers = racers or {}
	self.leaderboard = {}
	table.insert(Races, self)
end )

function Race:__tostring()
	return tostring(self.id)
end

function Race:StopTimer( racer )
	local timerid = self:GetTimerId( racer )
	local time = GetTimerTime( timerid )
	RemoveTimer( timerid )
	RaceDebug("stopped timer at "..time.." for "..(racer and (tostring(racer).." in "..tostring(self)) or tostring(self)).." with id "..timerid)
	return time
end

function Race:StartTimer( racer )
	local timerid = self:GetTimerId( racer )
	RemoveTimer( timerid )
	AddTimer( timerid, 0, 1 )
	RaceDebug("started timer for "..(racer and (tostring(racer).." in "..tostring(self)) or tostring(self)).." with id "..timerid)
end

function Race:Reset( racer )
	if IsPlayer( racer ) then racer = GetRacerByPlayer( racer ) end
	RaceDebug( tostring(racer).." reset in "..tostring(self) )
	if racer then
		self:StopTimer( racer )
		self:HUD_RemoveTimer( racer )
	else

	end
end

function Race:Finished( racer )
	if IsPlayer( racer ) then racer = GetRacerByPlayer( racer ) end
	RaceDebug( tostring(racer).." finished in "..tostring(self) )
	if racer then
		local time = self:GetCurrentTime( )
		self:CheckRecord( racer, time )
		self:HUD_RemoveTimer( racer )
		racer.numraces = racer.numraces + 1
	else

	end
end

function Race:Start()
	self:StartTimer()
	self.active = true
end

function Race:End()
	local time = self:StopTimer()
	self.active = false

	-- TODO: Handle racers that didn't finish the race
	self:PrintLeaderboard()
end

-- get either a racer's current time or the race's current time
function Race:GetCurrentTime( racer )
	local timerid = self:GetTimerId( racer )
	local time = GetTimerTime( timerid )
	RaceDebug("current time of "..time.." for "..(racer and (tostring(racer).." in "..tostring(self)) or tostring(self)).." with id "..timerid)
	return time
end

function Race:GetTimerId( racer )
	if racer and not racer.playerindex then RaceError("Racer '"..tostring(racer).."' has no playerindex (Race:GetTimerId)"); return nil end
	return self.id..(racer and "-"..racer.playerindex or "")
end

function Race:CheckRecord( racer, time )
	-- forward to AllTime
	local isalltime = false
	if AllTime and self ~= AllTime then 
		isalltime = AllTime:CheckRecord( racer, time ) 
	end

	local oldplace, oldrecord = self:GetCurrentRecord( racer )
	if oldrecord and time > oldrecord.time then
		self:OnFailedToPB( oldrecord, time )
		return false
	end

	if oldplace then
		self:RemoveFromLeaderboard( oldplace )
	end

	local newrecord = Record( racer, time, oldplace, oldrecord )
	RaceDebug("CheckRecord: "..tostring(self)..": new record: "..tostring(newrecord))
	local newplace, beatenrecord = self:InsertIntoLeaderboard( newrecord )
	newrecord.place = newplace
	newrecord.beatenrecord = beatenrecord

	RaceDebug("CheckRecord: "..tostring(self)..": new record: from ["..tostring(oldplace).."] "..tostring(oldrecord).." to ["..tostring(newplace).."] "..tostring(newrecord).." (beating "..tostring(beatenrecord)..")")

	self:OnRecordBeaten( newrecord, isalltime )
	return true
end

function Race:OnRecordBeaten( newrecord, isalltime )
	self:HUD_SetPersonalBest( newrecord )
	if self.onrecordbeatenfn then
		self.onrecordbeatenfn( newrecord, isalltime )
	end
end

function Race:OnFailedToPB( oldrecord, time )
	if self.onfailedtopbfn then
		self.onfailedtopbfn( oldrecord, time )
	end
end

function Race:GetFromLeaderboard( place )
	if place and self.leaderboard[place] then
		return self.leaderboard[place]
	end
end

function Race:RemoveFromLeaderboard( place )
	if place and self.leaderboard[place] then
		local removedrecord = self.leaderboard[place]
		table.remove( self.leaderboard, place )
		return removedrecord
	end
end

function Race:InsertIntoLeaderboard( record )
	local place = 1
	for i,v in ipairs(self.leaderboard) do
		if record.time < v.time then
			place = i
			break
		end
	end
	table.insert( self.leaderboard, place, record )
	local oldrecord = self:GetFromLeaderboard( place + 1 )
	return place, oldrecord
end

function Race:GetCurrentRecord( racer )
	if IsPlayer( racer ) then racer = GetRacerByPlayer( racer ) end
	RaceDebug("getting current record for "..tostring(racer))
	for i,v in ipairs(self.leaderboard) do
		if v.racer == racer then
			return i,v
		end
	end
end

function Race:PrintLeaderboard( num )
	num = num or 5
	RaceMessage(tostring(self).." Leaderboard")
	for i=1,num do
		if not self.leaderboard[i] then
			if i==1 then RaceMessage(" [empty]") end
			break
		end
		RaceMessage(" "..i..") "..tostring(self.leaderboard[i]))
	end
end

function Race:IsRacerAdded( racer )
	return racer and self:FindRacer( racer ) ~= false
end

function Race:GetRacer( player )
	local index = self:FindPlayer( player )
	if index then return self.racers[index] end
end

function Race:GetRacerByIndex( playerindex )
	return self:GetRacer( playerindex )
end

function Race:AddPlayer( player )
	RaceDebug(tostring(self).." adding player "..tostring(player:GetName()))
	if not IsPlayer( player ) then
		RaceError("Race:AddPlayer must be given a player")
		return nil
	end
	local racer = GetRacerByPlayer( player )
	return self:AddRacer( racer )
end

function Race:RemovePlayer( player )
	if not IsPlayer( player ) then
		RaceError("Race:RemovePlayer must be given a player")
		return nil
	end
	local racer = GetRacerByPlayer( player )
	return self:RemoveRacer( racer )
end

function Race:AddRacer( racer )
	if not self:IsRacerAdded( racer ) then
		table.insert( self.racers, racer )
		return true
	end
	return false
end

function Race:RemoveRacer( racer )
	local index = self:FindRacer( racer )
	if index then
		table.remove( self.racers, index )
		return true
	end
	return false
end

function Race:FindRacer( racer )
	for i,v in ipairs(self.racers) do
		if v == racer then return i end
	end
	return false
end

function Race:FindPlayer( player )
	for i,v in ipairs(self.racers) do
		if v.playerindex == GetPlayerIndex(player) then return i end
	end
	return false
end

function Race:HUD_AddTimer( racer )
	if racer and racer:GetPlayer() then
		local timerid = self:GetTimerId( racer )
		AddHudTimer( racer:GetPlayer(), "hud_"..timerid, timerid, 0, 40, 4, 0, 5 )
	end
end

function Race:HUD_RemoveTimer( racer )
	if racer and racer:GetPlayer() then
		local timerid = self:GetTimerId( racer )
		RemoveHudItem( racer:GetPlayer(), "hud_"..timerid )
	end
end

function Race:HUD_SetPersonalBest( newrecord )
	local racer = newrecord.racer
	if racer and racer:GetPlayer() then
		local timerid = self:GetTimerId( racer )
		AddHudText( racer:GetPlayer(), "hud_pb_"..timerid, string.format("Personal Best Time: %.3f seconds", newrecord.time), 0, 62, 4 )
		RemoveHudItem( racer:GetPlayer(), "hud_latest_"..timerid )
	end
end

function Race:HUD_SetLatestTime( oldrecord, time )
	local racer = oldrecord.racer
	if racer and racer:GetPlayer() then
		local timerid = self:GetTimerId( racer )
		AddHudText( racer:GetPlayer(), "hud_latest_"..timerid, string.format("Latest Time: %.3f seconds", time), 0, 80, 4 )
	end
end

function Race:OnSave()
	local data = {
		leaderboard = {},
		racers = {},
		id = self.id,
	}
	for i,v in ipairs(self.leaderboard) do
		table.insert( data.leaderboard, v:OnSave() )
	end
	for i,v in ipairs(self.racers) do
		table.insert( data.racers, v:OnSave() )
	end
	return data
end

function Race:OnLoad( data )
	self.id = data.id
	for i,v in pairs(data.racers) do
		local racer = GetRacerByIndex( v.playerindex )
		racer:OnLoad( v )
		if not self:IsRacerAdded( racer ) then
			table.insert( self.racers, racer )
		end
	end
	for i,v in pairs(data.leaderboard) do
		local record = Record()
		record:OnLoad( v )
		table.insert( self.leaderboard, record )
	end
end

------------------------------------------------------------
-- AsynchronousRace
-- print out records/etc immediately when they happen
------------------------------------------------------------
AsyncRace = Class(Race, function( self, id, racers, leaderboard )
	Race._ctor(self, id, racers, leaderboard)
end)

function AsyncRace:Started( racer )
	if IsPlayer( racer ) then racer = GetRacerByPlayer( racer ) end
	RaceDebug( tostring(racer).." started in "..tostring(self) )
	if racer then
		self:StartTimer( racer )
		self:HUD_AddTimer( racer )
	else

	end
end

function AsyncRace:Finished( racer )
	if IsPlayer( racer ) then racer = GetRacerByPlayer( racer ) end
	RaceDebug( tostring(racer).." finished in "..tostring(self) )
	if racer then
		local time = self:StopTimer( racer )
		self:CheckRecord( racer, time )
		self:HUD_RemoveTimer( racer )
		racer.numraces = racer.numraces + 1
	else

	end
end

AsyncRace.Start = function() RaceError( "AsyncRace can not use 'Start'; use Started( <player/racer> ) instead") end
AsyncRace.End = function() RaceError( "AsyncRace can not use 'End'; use Finished( <player/racer> ) instead") end

------------------------------------------------------------
-- Race-related Utility Functions
------------------------------------------------------------

function GetPlayerIndex( player )
	return IsPlayer(player) and player:GetSteamID() or player
end

function GetPlayerByIndex( playerindex )
	return GetPlayerBySteamID( playerindex )
end

function GetRacerByPlayer( player )
	if IsPlayer( player ) then
		local racer = GetRacerByIndex( GetPlayerIndex( player ) )
		RaceDebug("GetRacerByPlayer: "..tostring(racer))
		return racer
	end
end

function GetRacerByIndex( playerindex )
	local racer = AllTime:GetRacerByIndex( playerindex ) or Racer( playerindex )
	RaceDebug("GetRacerByIndex: "..tostring(racer))
	return racer
end

function GetRaceById( id )
	for i,race in ipairs(Races) do
		if race.id == id then
			return race
		end
	end
end

function RaceError( string )
	if RACE_DEBUG and RACE_DEBUG.SEND_TO_CHAT then
		ChatToAll( string )
	else
		ConsoleToAll( string )
	end
end

function RaceDebug( string )
	if RACE_DEBUG and RACE_DEBUG.ENABLED and RACE_DEBUG.VERBOSE then
		if RACE_DEBUG.SEND_TO_CHAT then
			ChatToAll( string )
		else
			ConsoleToAll( string )
		end
	end
end

function RaceMessage( player, string )
	if not string then string = player; player = nil end
	if player then
		ChatToPlayer( player, string )
	else
		ChatToAll( string )
	end
end


------------------------------------------------------------
-- General Utility Functions
------------------------------------------------------------

function round(num, idp)
  return string.format("%0." .. (idp or 0) .. "f", num)
end

function table.contains(table, element)
  if table == nil then
        return false
  end
  
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb,  string.format("\"%s\"\n", tostring(key)));
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("[%d] \"%s\"\n", tonumber(key), tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end


------------------------------------------------------------
-- Game callbacks and whatnot
------------------------------------------------------------

function RunTests()
	TestClasses()
	TestRacer()
	TestRace()
	TestAsyncRace()
	TestAllTime()
end

--[[
function startup()

	RunTests()
	AddScheduleRepeating("printtestresults", .5, function()
		if TestsFinished() then
			PrintTestResults()
			RemoveSchedule("printtestresults")
		end
	end)

end
]]--

function shutdown()
	RaceDebug( "shutdown called, start saving stuff" )
	SaveRaces()
end

function SaveRaces()
	local saveddata = { 
		race_stats = {
			num_races = RACE_STATS.NUM_RACES
		},
		races = {},
	}

	for i,race in ipairs(Races) do
		if race == AllTime then
			saveddata.alltime = AllTime:OnSave()
		else
			table.insert( saveddata.races, race:OnSave() )
		end
	end

	RaceDebug(to_string(saveddata))

	SaveMapData( saveddata, "race" )
end

function LoadRaces()
	local loadeddata = LoadMapData( "race" )

	RaceDebug(to_string(loadeddata))

	if loadeddata then
		if loadeddata.race_stats and loadeddata.race_stats.num_races then
			RACE_STATS.NUM_RACES = loadeddata.race_stats.num_races
		end

		AllTime:OnLoad( loadeddata.alltime )

		for i,data in ipairs( loadeddata.races ) do
			local race = Race("<UNLOADED>")
			race:OnLoad( data )
			table.insert( Races, race )
		end
	end
end

local CONNECTED_PLAYER_COUNTER = 0
function player_connected( player )
	local name = player:GetName()
	local steamid = player.GetSteamID and player:GetSteamID() or nil
	local id = player:GetId()
	local player = GetPlayerByID(id)
	RaceDebug(tostring( name ~= "" and name or "<unknown name>" ).." connected (id: "..tostring(id).." / "..tostring(steamid)..")")

	-- make a local copy of the current counter
	local scheduleid = CONNECTED_PLAYER_COUNTER

	-- check over and over until we get a valid player object
	AddScheduleRepeatingNotInfinitely( "connected_player_"..CONNECTED_PLAYER_COUNTER, 0.33, function()
		local player = GetPlayerByID(id)
		local steamid = player.GetSteamID and player:GetSteamID() or nil
		RaceDebug( "connected_player_"..scheduleid.." searching for player "..player:GetId()..": '"..player:GetName().."': "..tostring(steamid) )
		if player:GetName() ~= "" then
			RaceDebug( "connected_player_"..scheduleid.." schedule found player "..player:GetName() )
			local racer = GetRacerByPlayer( player )
			local place, pb = AllTime:GetCurrentRecord( racer )
			if pb then
				AllTime:HUD_SetPersonalBest( pb )
			end
			RaceDebug( "connected_player_"..scheduleid.." racer: "..tostring(racer) )
			RemoveSchedule( "connected_player_"..scheduleid )
		end
	end, 30 )
	CONNECTED_PLAYER_COUNTER = CONNECTED_PLAYER_COUNTER + 1
end

function player_disconnected( player )
	local playerindex = GetPlayerIndex( player )
	if playerindex and playerindex ~= player then
		local racer = GetRacerByIndex( playerindex )
		if racer.player then
			racer.player = nil
		end
	end
end

function player_namechange( player, oldname, newname )
	local playerindex = GetPlayerIndex( player )
	if playerindex and playerindex ~= player then
		local racer = GetRacerByIndex( playerindex )
		if racer then
			racer:AddAlias( newname )
		end
	end
end

------------------------------------------------------------
-- Setup/initializing/etc continued
-- this stuff goes at the bottom so that we know all the
-- classes and whatnot are defined by the time it gets here
------------------------------------------------------------

AllTime = AsyncRace("All-Time")
AllTime.onrecordbeatenfn = function( newrecord )
	RaceDebug("alltime onrecordbeatenfn "..tostring(newrecord))
	RaceMessage( newrecord:GetBeatenString( "all-time" ) )
	RaceDebug("alltime onrecordbeatenfn finished "..tostring(newrecord))
end
AllTime.onfailedtopbfn = function( oldrecord, time )
	RaceMessage( oldrecord.racer:GetPlayer(), "You finished in "..round(time, RACE_TIME_PRECISION).."s ("..round((time-oldrecord.time),RACE_TIME_PRECISION).."s slower than your personal best)" )
end

------------------------------------------------------------
-- Wrappers for AllTime functions
------------------------------------------------------------
function RunStarted( player )
	AllTime:Started( player )
end

function RunFinished( player )
	AllTime:Finished( player )
end

function RunReset( player )
	AllTime:Reset( player )
end

------------------------------------------------------------
-- Finally, load
------------------------------------------------------------
LoadRaces()