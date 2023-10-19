local CritNotifier = CreateFrame('FRAME')

CritNotifier:RegisterEvent('ADDON_LOADED')
CritNotifier:RegisterEvent('UNIT_COMBAT')
CritNotifier:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        if HIGHEST_CRIT == nil then
            HIGHEST_CRIT = 0;
        end
        if HIGHEST_HEAL == nil then
            HIGHEST_HEAL = 0;
        end
        DEFAULT_CHAT_FRAME:AddMessage("Addon loaded, HIGHEST_CRIT = " .. HIGHEST_CRIT)
        DEFAULT_CHAT_FRAME:AddMessage("Addon loaded, HIGHEST_HEAL = " .. HIGHEST_HEAL)
    end
    if event == "UNIT_COMBAT" and arg3 == "CRITICAL" and arg1 == 'target' then
        local msg = ""
        if arg2 == 'HEAL' then
            if arg4 > HIGHEST_HEAL then
                HIGHEST_HEAL = arg4
                msg = "Critei " .. arg4 .. " de cura" -- heal case
            end
        else
            if arg4 > HIGHEST_CRIT then
                HIGHEST_CRIT = arg4
                msg = "Critei " .. arg4 .. " de dano" -- damage case
            end
        end
        SendChatMessage(msg, "YELL", nill)
    end

end)


