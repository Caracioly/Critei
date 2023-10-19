local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player");

-- CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
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
    end

    -- When you crital hit
    if event == "UNIT_COMBAT" and arg3 == "CRITICAL" and arg1 == 'target' then
        local msg = ""
        local critAmount = arg4
        local spellName = arg2
        if arg2 == 'HEAL' then
            if arg4 > HIGHEST_HEAL then
                HIGHEST_HEAL = critAmount
                msg = "Critei " .. critAmount .. " de cura" -- heal case
                PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
            end
        else
            if arg4 > HIGHEST_CRIT then
                HIGHEST_CRIT = critAmount
                msg = "Critei " .. critAmount .. " de dano" -- damage case
                PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
            end
        end
        SendChatMessage(msg, "YELL", nill)
    end

    if event == 'CHAT_MSG_YELL' and arg2 ~= playerName then
        if string.find(arg1, "Critei (%d+) de") then
            PlaySoundFile("Interface\\AddOns\\Critei\\critSFX.ogg")
        end
    end

    -- COMANDS --
    -- Slash command to check your crit record
    SLASH_CRIT1 = '/topcrit'
    SlashCmdList["CRIT"] = function(msg)
        print("Seu maior dano critico foi " .. HIGHEST_CRIT)
    end

    -- Slash command to check your heal record
    SLASH_HEAL1 = "/topheal"
    SlashCmdList["HEAL"] = function(msg)
        print("Sua maior cura critica foi " .. HIGHEST_HEAL)
    end

    -- debug reset crit values
    SLASH_CRESET1 = "/critreset"
    SlashCmdList["CRESET"] = function(ms)
        print("Resetando os valores criticos")
        HIGHEST_CRIT = 0
        HIGHEST_HEAL = 0
    end

end)

-- SPELLCAST_STOP
-- Fired when a spell cast stops. Called twice when the spell is channelled. Once at start, once at completion.
