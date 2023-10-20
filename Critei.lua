local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player")
local spellName = ""
local critDamage = 0

CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('COMBAT_TEXT_UPDATE')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')
CritNotifier:RegisterEvent('UNIT_COMBAT')
CritNotifier:SetScript("OnEvent", function()
    -- When ADDON is loaded
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        if HIGHEST_CRIT == nil then
            HIGHEST_CRIT = 0;
        end
        if HIGHEST_HEAL == nil then
            HIGHEST_HEAL = 0;
        end
        if critSound == nil then
            critSound = true
        end
    end

    -- when you do crit spell damage
    if event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
        critDamage = 0
        local startSpellNameIndex = string.find(arg1, "Your ")
        local endSpellNameIndex = string.find(arg1, "crit")
        if startSpellNameIndex and endSpellNameIndex then
            spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 1)

            local startDamageIndex = string.find(arg1, "for ")
            local _, endDamageIndex = string.find(arg1, "%d+ ", startDamageIndex)

            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_CRIT then
                HIGHEST_CRIT = critDamage
                msg = "Critei " .. critDamage .. " com " .. spellName -- damage case
                if critSound then
                    PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
                end
                SendChatMessage(msg, "YELL", nil)
            end
        end

    end

    -- when you crit a healing spell
    if event == 'CHAT_MSG_SPELL_SELF_BUFF' then
        critDamage = 0
        local startIndex = string.find(arg1, "Your ")
        local endIndex = string.find(arg1, "critically")
        if startIndex and endIndex then
            spellName = string.sub(arg1, startIndex + 5, endIndex - 1)

            local startDamageIndex = string.find(arg1, "for ")
            local endDamageIndex = string.find(arg1, "%.")

            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_HEAL then
                HIGHEST_HEAL = critDamage
                msg = "Curei " .. critDamage .. " com " .. spellName -- heal case
                if critSound then
                    PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
                end
                SendChatMessage(msg, "YELL", nil)
            end
        end

    end

    -- when you crit a Auto Ataque
    if event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        critDamage = 0
        local startIndex = string.find(arg1, "You ")
        local endIndex = string.find(arg1, "crit")
        if startIndex and endIndex then
            spellName = "Auto Ataque"

            local startDamageIndex = string.find(arg1, "for ")
            local endDamageIndex = string.find(arg1, "%.")

            if startDamageIndex and endDamageIndex then
                critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))
            end

            if critDamage > HIGHEST_CRIT then
                HIGHEST_CRIT = critDamage
                msg = "Critei " .. critDamage .. " com " .. spellName -- damage case
                if critSound then
                    PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
                end
                SendChatMessage(msg, "YELL", nil)
            end
        end

    end

    -- if someone in the party critical hit as well you gonna hear the crit sound
    if event == 'CHAT_MSG_YELL' and arg2 ~= playerName then
        if string.find(arg1, "Critei") and string.find(arg1, "com") then
            if critSound then
                PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
            end
        end
    end

    -- COMANDS --
    -- Slash command to check your crit record
    SLASH_CRIT1 = '/topcrit'
    SLASH_CRIT2 = '/tc'
    SlashCmdList["CRIT"] = function(msg)
        print("Seu maior dano critico foi " .. HIGHEST_CRIT)
    end

    -- Slash command to check your heal record
    SLASH_HEAL1 = "/topheal"
    SLASH_HEAL2 = '/th'
    SlashCmdList["HEAL"] = function(msg)
        print("Sua maior cura critica foi " .. HIGHEST_HEAL)
    end

    -- Turn on / off the crit sound
    SLASH_CSFX1 = "/critsound"
    SLASH_CSFX2 = "/cs"
    SlashCmdList["CSFX"] = function(msg)
        critSound = not critSound
        if critSound then
            print("Som habilitado")
        else
            print("Som desabilitado")
        end
    end

    -- help command
    SLASH_CHLP1 = "/crithelp"
    SLASH_CHLP2 = "/ch"
    SlashCmdList["CHLP"] = function(msg)
        print("---Lista de Comandos---")
        print("/topcrit ou /tc -> Mostra o maior dano critico do personagem.")
        print("/topheal ou /th-> Mostra a maior cura critica do personagem.")
        print("/critsound ou /cs -> Habilita / Desabilita o som do critico.")
        print("/crithelp or /ch -> Abre o menu de comandos.")
        print("------------------------------")
    end

    -- debug reset crit values
    SLASH_CRESET1 = "/critclear"
    SLASH_CRESET2 = "/cc"
    SlashCmdList["CRESET"] = function(ms)
        print("Resetando os valores criticos")
        HIGHEST_CRIT = 0
        HIGHEST_HEAL = 0
    end
end)
