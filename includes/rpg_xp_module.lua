local xp_module = {}
local LevelUpDelay

function xp_module.NewExperienceLine(playerID)
    local self = {}

    local xp = 0
    local xp_to_next = 98
    function self.GetXp() return xp end
    function self.SetXp(int) xp = int end
    function self.GainXp(amount) xp = xp + amount end

    function self.GetXpToNext() return xp_to_next end
    function self.SetXpToNext(int)  xp_to_next = int end

    local level = 1
    function self.GetLevel() return level end
    function self.SetLevel(int) level = int end
    function self.LevelUp()
        level = level + 1
        if level == 6 or level == 11 or level == 18 then
            playerID.SetAllowUlt(true)
            self.IncUnusedUlts()
        elseif level > 18 then return end
        xp =  xp % xp_to_next -- Keep leftover xp on lvel
        local toFloor = math.floor
        xp_to_next = toFloor(xp_to_next * 1.15)
        xp_module.LevelUp(playerID)
    end


    local unused_skills = 0
    function self.GetUnusedSkills() return unused_skills end
    function self.SetUnusedSkills(int) unused_skills = int end
    function self.IncUnusedSkills() unused_skills = unused_skills + 1 end
    function self.DecUnusedSkills()
        if unused_skills > 0 then
            unused_skills = unused_skills - 1
        end
    end

    local unused_ults = 0
    function self.GetUnusedUlts() return unused_ults end
    function self.IncUnusedUlts() unused_ults = unused_ults + 1 end
    function self.DecUnusedUlts()
        if unused_ults > 0 then
            unused_ults = unused_ults - 1
        end
    end

    function self.GetUnusedPoints() return unused_ults + unused_skills end

    function self.SpendPoints()
        if self.GetUnusedUlts() > 0 then
            playerID.SetAllowUlt(true)
            self.DecUnusedUlts()
        end
        LevelUpDelay(playerID)
    end
    --Basic Skills
    local regen_level = 0
    function self.GetRegenLevel() return regen_level end
    function self.LevelUpRegen()
        regen_level = regen_level + 1
    end

    local resistance_level = 0
    function self.GetResistLevel() return resistance_level end
    function self.LevelUpResist()
         resistance_level = resistance_level + 1
    end

    local speed_level = 0
    function self.GetSpeedLevel() return speed_level end
    function self.LevelUpSpeed()
        speed_level = speed_level + 1
    end

    -- Offensive Basic Skill
    local throw_level = 0
    function self.GetFlagThrowLevel() return throw_level end
    function self.LevelUpFlagThrow()
        throw_level = throw_level + 1
    end

    -- Defensive Basic Skill
    local damage_level = 0
    function self.GetDamageLevel() return damage_level end
    function self.LevelUpDamage()
        damage_level = damage_level + 1
    end

    -- Four Ultra Skills
    local ult = { false, false, false, false }
    function self.GetUlt(int)
        return ult[int]
    end

    function self.LevelUlt(int)
        ult[int] = true
		playerID.SetAllowUlt(false)
    end

    function self.ResetSkills()
        local player = playerID.GetPlayer()
        if level >= 6 then self.IncUnusedUlts() end
        if level >= 11 then self.IncUnusedUlts() end
        if level >= 18 then self.IncUnusedUlts() end
        unused_skills = level - self.GetUnusedUlts() -  1
        damage_level = 0
        throw_level = 0
        speed_level = 0
        resistance_level = 0
        regen_level = 0
        ult = { false, false, false, false }
    end

    return self
end

function xp_module.LevelUp(playerID)
    local player = playerID.GetPlayer()
    local level = playerID.GetLevel()
    local steam_id = playerID.GetSteamID()

    --Because everyone loves points, right?
    player:AddFortPoints(100 * level, "Leveling up!")

	ObjectiveNotice(player, "Level "..level.."!" )
	BroadCastMessageToPlayer(player, "LEVEL "..level.."!", 6, Color.kWhite)
	ChatToPlayer(player,"^5You are now level ^4"..level)

	AddSchedule("level_up"..steam_id, 2, LevelUpDelay, playerID)
end

function LevelUpDelay(playerID)
    local player = playerID.GetPlayer()
    local level = playerID.GetLevel()

	DestroyMenu( "LEVEL_UP" )
    DestroyMenu( "LEVEL_UP_ULT" )

	if playerID.IsAllowUlt() then --Get ult at 6, 11, 18
		CreateMenu( "LEVEL_UP_ULT", "Select an Ultimate", -1 )

        local ult_name = playerID.GetUltName(1)
        local ult_desc = playerID.GetUltDesc(1)
        -- Show players ults they dont already have
		if not playerID.GetUlt(1) then
			AddMenuOption( "LEVEL_UP_ULT", 6 , ult_name .." (".. ult_desc ..")")
		end
		if not playerID.GetUlt(2) then
            ult_name = playerID.GetUltName(2)
            ult_desc = playerID.GetUltDesc(2)
			AddMenuOption( "LEVEL_UP_ULT", 7 , ult_name .." (".. ult_desc ..")")
		end
		if not playerID.GetUlt(3) then
            ult_name = playerID.GetUltName(3)
            ult_desc = playerID.GetUltDesc(3)
			AddMenuOption( "LEVEL_UP_ULT", 8 , ult_name .." (".. ult_desc ..")")
		end
		if not playerID.GetUlt(4) then
            ult_name = playerID.GetUltName(4)
            ult_desc = playerID.GetUltDesc(4)
			AddMenuOption( "LEVEL_UP_ULT", 9 , ult_name .." (".. ult_desc ..")")
		end

		ShowMenuToPlayer(player, "LEVEL_UP_ULT")
	else
		-- Check to see if player selected auto leveling
		if not playerID.GetAutoLevel() then
            local class_id = playerID.GetClassID()
			--Create a menu with some level up choices and label them!
			CreateMenu( "LEVEL_UP", "Choose a skill", -1 )
			AddMenuOption( "LEVEL_UP", 6 , "5% Increased Resistance")
			AddMenuOption( "LEVEL_UP", 7 , "5% Increased Speed")
			AddMenuOption( "LEVEL_UP", 8 , "5% Health and Armor Regeneration")

			-- Add Offensive skills to Offensive classes
			if class_id == 1 or class_id == 5 or class_id == 8 then
				AddMenuOption( "LEVEL_UP", 9 , "15% Increased Flag Throwing")
			else
				AddMenuOption( "LEVEL_UP", 9 , "5% Increased Damage")
			end

			ShowMenuToPlayer(player, "LEVEL_UP")
		else
			local auto_choice = RandomInt(1, 4)

			if auto_choice == 1 then
				playerID.LevelUpResist()
			elseif auto_choice == 2 then
				playerID.LevelUpSpeed()
			elseif auto_choice == 3 then
				playerID.LevelUpRegen()
			elseif auto_choice == 4 then
				if class_id == 1 or class_id == 5 or class_id == 8 then
					playerID.LevelUpFlagThrow()
				else
					playerID.LevelUpDamage()
				end
			end -- auto choice
		end -- auto level
	end
    BroadCastSoundToPlayer(player, "Misc.Unagi")
end

return xp_module
