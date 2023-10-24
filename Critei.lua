local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player")
local spellName = ""
local instance = ""
local critDamage = 0

CritNotifier:RegisterEvent("PLAYER_ENTERING_WORLD")
CritNotifier:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')

local function PlayCritSound()
    if critSound then
        PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
    end
end

local function SendYellMessage(message)
    SendChatMessage(message, "YELL", nil)
end

CritNotifier:SetScript("OnEvent", function()
    -- When ADDON is loaded
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        HIGHEST_CRIT = HIGHEST_CRIT or 0
        HIGHEST_HEAL = HIGHEST_HEAL or 0
        critSound = critSound or true
        LANGUAGE = 'en-us'
    end

    -- when you entering a instance 
    if event == 'ZONE_CHANGED_NEW_AREA' then
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            instance = instanceType == "party" and "Dungeon" or "Raid"
            print(string.format(localization[LANGUAGE].enteringInstance, instance))
            print(localization[LANGUAGE].resetMessage)
            HIGHEST_CRIT = 0
            HIGHEST_HEAL = 0
        end

        -- when a spell crit a enemy
    elseif event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
        critDamage = 0
        local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "Your "), string.find(arg1, "crit")
        if startSpellNameIndex and endSpellNameIndex then
            spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 2)

            local startDamageIndex = string.find(arg1, "for %d+")
            if startDamageIndex then
                local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
                if not endDamageIndex then
                    endDamageIndex = string.find(arg1, "%.", startDamageIndex)
                end
                if endDamageIndex then
                    critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
                end

                if critDamage > HIGHEST_CRIT then
                    HIGHEST_CRIT = critDamage
                    PlayCritSound()
                    SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
                end
            end
        end

        -- when a healing spell crit 
    elseif event == 'CHAT_MSG_SPELL_SELF_BUFF' then
        critDamage = 0
        local startIndex, endIndex = string.find(arg1, "Your "), string.find(arg1, "critically")
        if startIndex and endIndex then
            spellName = string.sub(arg1, startIndex + 5, endIndex - 2)

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_HEAL then
                HIGHEST_HEAL = critDamage
                PlayCritSound()
                SendYellMessage(string.format(localization[LANGUAGE].healingSpellCrit, critDamage, spellName))
            end
        end

        -- when an Auto Attack crit
    elseif event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        critDamage = 0
        local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit")
        if startIndex and endIndex then
            spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_CRIT then
                HIGHEST_CRIT = critDamage
                PlayCritSound()
                SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
            end
        end

        -- when someone next to you crit
    elseif event == 'CHAT_MSG_YELL' and arg2 ~= playerName then
        if string.find(arg1, "Critei") and string.find(arg1, "com") or string.find(arg1, "Crited") and
            string.find(arg1, "with") or string.find(arg1, "Critically healed") and string.find(arg1, "with") then
            PlayCritSound()
        end
    end
    -- COMMANDS --

    -- Slash command to check your crit record
    SLASH_CRIT1 = '/topcrit'
    SLASH_CRIT2 = '/tc'
    SlashCmdList["CRIT"] = function(msg)
        print(string.format(localization[LANGUAGE].critMessage, HIGHEST_CRIT))
    end

    -- Slash command to check your heal record
    SLASH_HEAL1 = "/topheal"
    SLASH_HEAL2 = '/th'
    SlashCmdList["HEAL"] = function(msg)
        print(string.format(localization[LANGUAGE].healMessage, HIGHEST_HEAL))
    end

    -- Turn on / off the crit sound
    SLASH_CSFX1 = "/critsound"
    SLASH_CSFX2 = "/cs"
    SlashCmdList["CSFX"] = function(msg)
        critSound = not critSound
        if critSound then
            print(localization[LANGUAGE].soundEnabled)
        else
            print(localization[LANGUAGE].soundDisabled)
        end
    end
    -- Change language to English
    SLASH_EN1 = "/cl-en"
    SlashCmdList["EN"] = function(msg)
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
    SlashCmdList["BR"] = function(msg)
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
    SlashCmdList["CHLP"] = function(msg)
        print(localization[LANGUAGE].commandList)
        print(localization[LANGUAGE].topcrit)
        print(localization[LANGUAGE].topheal)
        print(localization[LANGUAGE].critSoundCommand)
        print(localization[LANGUAGE].critLanguage)
        print(localization[LANGUAGE].critHelp)
        print("------------------------------")
    end

    -- debug reset crit values
    SLASH_CRESET1 = "/critclear"
    SLASH_CRESET2 = "/cc"
    SlashCmdList["CRESET"] = function(ms)
        print(localization[LANGUAGE].resetMessage)
        HIGHEST_CRIT = 0
        HIGHEST_HEAL = 0

    end

end)
