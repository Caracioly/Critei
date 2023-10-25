local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player")
local spellName, targetName, critDamage, instance

CritNotifier:RegisterEvent("PLAYER_ENTERING_WORLD")
CritNotifier:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')

------------------FUNCTIONS------------------

function PlaySound(sound)
    if critSound then
        PlaySoundFile("Interface\\AddOns\\Critei\\SFX\\" .. sound .. "SFX.ogg")
    end
end

local function ClearAllRecords()
    HIGHEST_CRIT = {}
    HIGHEST_HEAL = {}
    HIGHEST_DEF = {}
end

function SetHihgestStat(stat, XcritDamage, XtargetName, XspellName)
    stat.DAMAGE = XcritDamage
    stat.TARGET_NAME = XtargetName
    stat.SPELL_NAME = XspellName
end

local function SendYellMessage(message)
    SendChatMessage(message, "YELL", nil)
end

------------------EVENTS------------------

CritNotifier:SetScript("OnEvent", function()
    -- When ADDON is loaded
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        if HIGHEST_CRIT == 0 then
            HIGHEST_CRIT = {}
        end
        if HIGHEST_HEAL == 0 then
            HIGHEST_HEAL = {}
        end
        if HIGHEST_DEF == 0 then
            HIGHEST_DEF = {}
        end
        HIGHEST_CRIT = HIGHEST_CRIT or {}
        HIGHEST_HEAL = HIGHEST_HEAL or {}
        HIGHEST_DEF = HIGHEST_DEF or {}
        LANGUAGE = 'en-us'

        -- when you entering a instance 
    elseif event == 'ZONE_CHANGED_NEW_AREA' then
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            instance = instanceType == "party" and "Dungeon" or "Raid"
            local instanceName = GetZoneText()

            print(string.format(localization[LANGUAGE].enteringInstance, instanceName))
            print(localization[LANGUAGE].resetMessage)

            HIGHEST_CRIT = {}
            HIGHEST_HEAL = {}
            HIGHEST_DEF = {}
        end

    elseif event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then -- when a spell crit a enemy
        if string.find(arg1, "crit") then

            local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for")
            local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

            local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "Your "), string.find(arg1, "crit")
            local spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 2)

            local startDamageIndex = string.find(arg1, "for %d+")
            local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
            if not endDamageIndex then
                endDamageIndex = string.find(arg1, "%.", startDamageIndex)
            end
            local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE AMOUNT

            if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
                PlaySound("crit")
                SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
            end
        end

        -- when a healing spell crit 
    elseif event == 'CHAT_MSG_SPELL_SELF_BUFF' then
        if string.find(arg1, "critically") then

            local startNameIndex, endNameIndex = string.find(arg1, "heals "), string.find(arg1, "for") -- GET TARGET NAME
            local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

            local startIndex, endIndex = string.find(arg1, "Your "), string.find(arg1, "critically") -- GET SPELL NAME
            local spellName = string.sub(arg1, startIndex + 5, endIndex - 2)

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET THE DAMAGE AMOUNT 

            if next(HIGHEST_HEAL) == nil or critDamage > HIGHEST_HEAL.DAMAGE then
                PlaySound("heal")
                SetHihgestStat(HIGHEST_HEAL, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].healingSpellCrit, critDamage, spellName))
            end
        end

        -- when an Auto Attack crit
    elseif event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        if string.find(arg1, "crits") then

            local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for") -- GET TARGET NAME
            local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

            local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit") -- SPELL NAME AUTO ATTACK
            local spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

            if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
                PlaySound("crit")
                SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
            end
        end

        -- when someone next to you crit
    elseif event == 'CHAT_MSG_YELL' and arg2 ~= playerName then
        -- todo resolver isso aqui direito com localization
        if string.find(arg1, "Critei") and string.find(arg1, "com") then
            PlaySound("crit")
        elseif string.find(arg1, "Crited") and string.find(arg1, "with") then
            PlaySound("crit")
        elseif string.find(arg1, "Critically healed") and string.find(arg1, "with") then
            PlaySound("heal")
        elseif strin.find(arg1, "Curei ") and string.find(arg1, " com ") then
            PlaySound("heal")
        elseif string.find(arg1, "I took") and string.find(arg1, "damage from") then
            PlaySound("def")
        elseif string.find(arg1, "Tomei") and string.find(arg1, "de dano d") then
            PlaySound("def")
        end

    elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
        local endNameIndex = string.find(arg1, "crit")
        if endNameIndex then
            local targetName = string.sub(arg1, 1, endNameIndex - 1) -- GET TARGET NAME

            local startIndex, endIndex = string.find(arg1, "crits "), string.find(arg1, "you ") -- GET THE SPELL AUTO ATTACK
            local spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.") -- GET DAMAGE AMOUNT
            local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                PlaySound("def")
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].defAutoCrit, critDamage, spellName))
            end
        end

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
        local endNameIndex = string.find(arg1, "'s")
        if endNameIndex then

            local targetName = string.sub(arg1, 1, endNameIndex) -- GET TARGET NAME

            local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "'s "), string.find(arg1, "crits") -- GET SPELL NAME
            local spellName = string.sub(arg1, startSpellNameIndex + 3, endSpellNameIndex - 2)

            local startDamageIndex = string.find(arg1, "for %d+")
            local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
            if not endDamageIndex then
                endDamageIndex = string.find(arg1, "%.", startDamageIndex)
            end
            local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                PlaySound("def")
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].defSpellCrit, critDamage, spellName))
            end
        end
    end
    -- COMMANDS --
    -- TODO COMANDS PARA O DEF
    -- Slash command to check your crit record
    SLASH_CRIT1 = '/topcrit'
    SLASH_CRIT2 = '/tc'
    SlashCmdList["CRIT"] = function()
        print(string.format(localization[LANGUAGE].critMessage, HIGHEST_CRIT.DAMAGE or 0))
    end

    -- Slash command to check your heal record
    SLASH_HEAL1 = "/topheal"
    SLASH_HEAL2 = '/th'
    SlashCmdList["HEAL"] = function()
        print(string.format(localization[LANGUAGE].healMessage, HIGHEST_HEAL.DAMAGE or 0))
    end

    -- Slash command to check your def record
    SLASH_DEF1 = "/topdef"
    SLASH_DEF2 = '/td'
    SlashCmdList["DEF"] = function()
        print(string.format(localization[LANGUAGE].defMessage, HIGHEST_DEF.DAMAGE or 0))
    end

    -- Turn on / off the crit sound
    SLASH_CSFX1 = "/critsound"
    SLASH_CSFX2 = "/cs"
    SlashCmdList["CSFX"] = function()
        critSound = not critSound
        if critSound then
            print(localization[LANGUAGE].soundEnabled)
        else
            print(localization[LANGUAGE].soundDisabled)
        end
    end
    -- Change language to English
    SLASH_EN1 = "/cl-en"
    SlashCmdList["EN"] = function()
        if LANGUAGE == "en-us" then
            print("Already in English")
        end
        if LANGUAGE == "pt-br" then
            LANGUAGE = "en-us"
            print("Changed to English")
        end
    end

    -- change language to portuguese
    SLASH_BR1 = "/cl-br"
    SlashCmdList["BR"] = function()
        if LANGUAGE == "pt-br" then
            print("Já está em Portugues")
        end
        if LANGUAGE == "en-us" then
            LANGUAGE = "pt-br"
            print("Alterado para Portugues")
        end
    end

    -- help command
    SLASH_CHLP1 = "/crithelp"
    SLASH_CHLP2 = "/chelp"
    SLASH_CHLP3 = "/ch"
    SlashCmdList["CHLP"] = function()
        print(localization[LANGUAGE].commandList)
        print(localization[LANGUAGE].topcrit)
        print(localization[LANGUAGE].topheal)
        print(localization[LANGUAGE].topdef)
        print(localization[LANGUAGE].critSoundCommand)
        print(localization[LANGUAGE].critLanguage)
        print(localization[LANGUAGE].critHelp)
        print("------------------------------")
    end

    -- debug reset crit values
    SLASH_CRESET1 = "/critclear"
    SLASH_CRESET2 = "/cc"
    SlashCmdList["CRESET"] = function()
        print(localization[LANGUAGE].resetMessage)
        ClearAllRecords()
    end

    -- TEST TABLES 
    SLASH_CBT1 = "/setstat"
    SlashCmdList["CBT"] = function()
        TestSetHihgestStat()
    end

    -- PRINT TABLES --
    SLASH_CTT1 = "/critt"
    SlashCmdList["CTT"] = function()
        CritTableTest()
    end

    SLASH_HTT1 = "/healt"
    SlashCmdList["HTT"] = function()
        HealTableTest()
    end

    SLASH_DTT1 = "/deft"
    SlashCmdList["DTT"] = function()
        DefTableTest()
    end

    SLASH_TC1 = "/ctest"
    SlashCmdList["TC"] = function(input)

        if input == "spellcrit" then
            if next(HIGHEST_CRIT) == nil then
                TestChatMsgSpellSelfDamageEvent(1001)
            else
                TestChatMsgSpellSelfDamageEvent(1002)
            end
        elseif input == "spellheal" then
            if next(HIGHEST_HEAL) == nil then
                TestChatMsgSpellSelfBuffEvent(99999)
            else
                TestChatMsgSpellSelfBuffEvent(100000)
            end
        elseif input == "autocrit" then
            if next(HIGHEST_CRIT) == nil then
                TestCHAT_MSG_COMBAT_SELF_HITS(99999)
            else
                TestCHAT_MSG_COMBAT_SELF_HITS(100000)
            end
        elseif input == "autodef" then
            if next(HIGHEST_DEF) == nil then
                TestCHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS(99999)
            else
                TestCHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS(100000)
            end
        elseif input == "spelldef" then
            if next(HIGHEST_DEF) == nil then
                TestCHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(99999)
            else
                TestCHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(100000)
            end
        else
            print(string.format("Could not find the %s input", input))
            print("try: spellcrit, spellheal, autocrit, autodef, spelldef")
        end
    end
end)
