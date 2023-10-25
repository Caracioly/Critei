local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player")
local spellName = ""
local targetName = ""
local critDamage = 0
local instance = ""

CritNotifier:RegisterEvent("PLAYER_ENTERING_WORLD")
CritNotifier:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')

local function PlaySound(sound)
    if critSound then
        if sound == "def" then
            PlaySoundFile("Interface\\AddOns\\Critei\\defSFX.ogg")
        elseif sound == "heal" then
            PlaySoundFile("Interface\\AddOns\\Critei\\healSFX.ogg")
        else
            PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
        end
    end
end

local function SetHihgestCrit(critDamage, targetName, spellName)
    HIGHEST_CRIT = {
        ["DAMAGE"] = critDamage,
        ["TARGET_NAME"] = targetName,
        ["SPELL_NAME"] = spellName
    }
end

local function SetHihgestHeal(critDamage, targetName, spellName)
    HIGHEST_HEAL = {
        ["DAMAGE"] = critDamage,
        ["TARGET_NAME"] = targetName,
        ["SPELL_NAME"] = spellName
    }
end

local function SetHihgestDef(critDamage, targetName, spellName)
    HIGHEST_DEF = {
        ["DAMAGE"] = critDamage,
        ["TARGET_NAME"] = targetName,
        ["SPELL_NAME"] = spellName
    }
end

local function TestSetHihgestCrit()
    SetHihgestCrit(100, "Mobsy dick", "Test Spell")

    if HIGHEST_CRIT["DAMAGE"] == 100 and HIGHEST_CRIT["TARGET_NAME"] == "Mobsy dick" and HIGHEST_CRIT["SPELL_NAME"] ==
        "Test Spell" then
        print("TestSetHihgestCrit: Teste bem-sucedido")
    else
        print("TestSetHihgestCrit: Teste falhou")
    end
end

local function SendYellMessage(message)
    SendChatMessage(message, "YELL", nil)
end

CritNotifier:SetScript("OnEvent", function()
    -- When ADDON is loaded
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        HIGHEST_DEF = {
            ["DAMAGE"] = critDamage
        }
        HIGHEST_HEAL = {
            ["DAMAGE"] = critDamage
        }
        HIGHEST_CRIT = {
            ["DAMAGE"] = critDamage
        }
        LANGUAGE = 'en-us'

        -- when you entering a instance 
    elseif event == 'ZONE_CHANGED_NEW_AREA' then
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            instance = instanceType == "party" and "Dungeon" or "Raid"
            local instanceName = GetZoneText()
            print(string.format(localization[LANGUAGE].enteringInstance, instanceName))
            print(localization[LANGUAGE].resetMessage)
            HIGHEST_CRIT["DAMAGE"] = 0
            HIGHEST_HEAL["DAMAGE"] = 0
            HIGHEST_DEF["DAMAGE"] = 0
        end

        -- when a spell crit a enemy
    elseif event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
        if string.find(arg1, "crit") then

            local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for")
            if startNameIndex and endNameIndex then
                targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1) -- GET TARGET NAME
            end

            local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "Your "), string.find(arg1, "crit")
            if startSpellNameIndex and endSpellNameIndex then
                spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 2) -- GET SPELL NAME

                local startDamageIndex = string.find(arg1, "for %d+")
                if startDamageIndex then
                    local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
                    if not endDamageIndex then
                        endDamageIndex = string.find(arg1, "%.", startDamageIndex)
                    end

                    if endDamageIndex then
                        critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE AMOUNT
                    end

                    if critDamage > HIGHEST_CRIT["DAMAGE"] then
                        SetHihgestCrit(critDamage, targetName, spellName)
                        PlaySound("crit")
                        SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
                    end
                end
            end
        end

        -- when a healing spell crit 
    elseif event == 'CHAT_MSG_SPELL_SELF_BUFF' then

        local startNameIndex, endNameIndex = string.find(arg1, "heals "), string.find(arg1, "for")
            if startNameIndex and endNameIndex then
                targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1) -- GET TARGET NAME
            end

        local startIndex, endIndex = string.find(arg1, "Your "), string.find(arg1, "critically")
        if startIndex and endIndex then
            spellName = string.sub(arg1, startIndex + 5, endIndex - 2)

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_HEAL["DAMAGE"] then
                SetHihgestHeal(critDamage, targetName, spellName)
                PlaySound("heal")
                SendYellMessage(string.format(localization[LANGUAGE].healingSpellCrit, critDamage, spellName))
            end
        end

        -- when an Auto Attack crit
    elseif event == 'CHAT_MSG_COMBAT_SELF_HITS' then
    
        local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for")
            if startNameIndex and endNameIndex then
                targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1) -- GET TARGET NAME
            end
        
        local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit")
        if startIndex and endIndex then
            spellName = localization[LANGUAGE].aa -- SPELL NAME AUTO ATTACK

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE
            end

            if critDamage > HIGHEST_CRIT["DAMAGE"] then
                SetHihgestCrit(critDamage, targetName, spellName)
                PlaySound("crit")
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
                targetName = string.sub(arg1, 1,  endNameIndex -1) -- GET TARGET NAME
            end

        local startIndex, endIndex = string.find(arg1, "crits "), string.find(arg1, "you ") --GET THE SPELL AUTO ATTACK
        if startIndex and endIndex then
            spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.") --GET DAMAGE
            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_DEF["DAMAGE"] then
                SetHihgestDef(critDamage, targetName, spellName)
                PlaySound("def")
                SendYellMessage(string.format(localization[LANGUAGE].defAutoCrit, critDamage, spellName))
            end
        end

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
        local endNameIndex = string.find(arg1, "'s")
        if endNameIndex then
            targetName = string.sub(arg1, 1,  endNameIndex) -- GET TARGET NAME
        end

        local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "'s "), string.find(arg1, "crits") -- GET SPELL NAME
        if startSpellNameIndex and endSpellNameIndex then
            spellName = string.sub(arg1, startSpellNameIndex + 3, endSpellNameIndex - 2)
            local startDamageIndex = string.find(arg1, "for %d+")
            if startDamageIndex then
                local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
                if not endDamageIndex then
                    endDamageIndex = string.find(arg1, "%.", startDamageIndex)
                end
                if endDamageIndex then
                    critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE
                end

                if critDamage > HIGHEST_DEF["DAMAGE"] then
                    SetHihgestDef(critDamage, targetName, spellName)
                    PlaySound("def")
                    SendYellMessage(string.format(localization[LANGUAGE].defSpellCrit, critDamage, spellName))
                end
            end
        end
    end
    -- COMMANDS --
    -- TODO COMANDS PARA O DEF
    -- Slash command to check your crit record
    SLASH_CRIT1 = '/topcrit'
    SLASH_CRIT2 = '/tc'
    SlashCmdList["CRIT"] = function(msg)
        print(string.format(localization[LANGUAGE].critMessage, HIGHEST_CRIT["DAMAGE"]))
    end

    -- Slash command to check your heal record
    SLASH_HEAL1 = "/topheal"
    SLASH_HEAL2 = '/th'
    SlashCmdList["HEAL"] = function(msg)
        print(string.format(localization[LANGUAGE].healMessage, HIGHEST_HEAL["DAMAGE"]))
    end

    -- Slash command to check your def record
    SLASH_DEF1 = "/topdef"
    SLASH_DEF2 = '/td'
    SlashCmdList["DEF"] = function(msg)
        print(string.format(localization[LANGUAGE].defMessage, HIGHEST_DEF["DAMAGE"]))
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
        print(localization[LANGUAGE].topdef)
        print(localization[LANGUAGE].critSoundCommand)
        print(localization[LANGUAGE].critLanguage)
        print(localization[LANGUAGE].critHelp)
        print("------------------------------")
    end

    -- debug reset crit values
    SLASH_CRESET1 = "/critclear"
    SLASH_CRESET2 = "/cc"
    SlashCmdList["CRESET"] = function(ms)
        TestSetHihgestCrit()
        print(localization[LANGUAGE].resetMessage)
        HIGHEST_CRIT["DAMAGE"] = 80
        HIGHEST_HEAL = 0
        HIGHEST_DEF = 0
    end
end)
