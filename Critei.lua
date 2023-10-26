local CritNotifier = CreateFrame('FRAME')
local playerName = UnitName("player")
local spellName, targetName, critDamage, instance

CritNotifier:RegisterEvent("VARIABLES_LOADED")
CritNotifier:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')

------------------FUNCTIONS------------------
function CheckVariabletype()
    if type(HIGHEST_CRIT) == "number" then
        HIGHEST_CRIT = {}
    end
    if type(HIGHEST_HEAL) == "number" then
        HIGHEST_HEAL = {}
    end
    if type(HIGHEST_DEF) == "number" then
        HIGHEST_DEF = {}
    end
end

function AddInstanceToRecords(instance_name)
    if not INSTANCE_RECORDS[instance_name] then
        INSTANCE_RECORDS[instance_name] = {
            TOP_CRIT = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            },
            TOP_HEAL = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            },
            TOP_DEF = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            }
        }
    end
end

function AddOverWordToRecords()
    local inInstance, instanceType = IsInInstance()
    if not OVERWORLD_RECORDS["OverWorld"] then
        OVERWORLD_RECORDS["OverWorld"] = {
            TOP_CRIT = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            },
            TOP_HEAL = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            },
            TOP_DEF = {
                SPELL_NAME = "",
                TARGET_NAME = "",
                DAMAGE = 0
            }
        }
    end
end

function SetOverWordRecord(stat, XcritDamage, XtargetName, XspellName)
    local inInstance, instanceType = IsInInstance()
    if instanceType == "none" then
        if XcritDamage > OVERWORLD_RECORDS["OverWorld"][stat].DAMAGE then
            print(string.format( localization[LANGUAGE].recordBrokenOVW, stat))
            OVERWORLD_RECORDS["OverWorld"][stat].DAMAGE = XcritDamage
            OVERWORLD_RECORDS["OverWorld"][stat].TARGET_NAME = XtargetName
            OVERWORLD_RECORDS["OverWorld"][stat].SPELL_NAME = XspellName
        end
    end
end

function SetInstanceRecord(stat, XcritDamage, XtargetName, XspellName)
    local inInstance, instanceType = IsInInstance()
    if inInstance and (instanceType == "party" or instanceType == "raid") then
        local instanceName = GetZoneText()
        if XcritDamage > INSTANCE_RECORDS[instanceName][stat].DAMAGE then
            print(string.format(localization[LANGUAGE].recordBrokenINS, instanceName , stat))
            INSTANCE_RECORDS[instanceName][stat].DAMAGE = XcritDamage
            INSTANCE_RECORDS[instanceName][stat].TARGET_NAME = XtargetName
            INSTANCE_RECORDS[instanceName][stat].SPELL_NAME = XspellName
        end
    end
end

function PlaySound(sound)
    if critSound then
        PlaySoundFile("Interface\\AddOns\\Critei\\SFX\\" .. sound .. "SFX.ogg")
    end
end

local function ClearAllRecords()
    HIGHEST_CRIT = {}
    HIGHEST_HEAL = {}
    HIGHEST_DEF = {}
    CheckVariabletype()
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
        HIGHEST_CRIT = HIGHEST_CRIT or {}
        HIGHEST_HEAL = HIGHEST_HEAL or {}
        HIGHEST_DEF = HIGHEST_DEF or {}
        OVERWORLD_RECORDS = OVERWORLD_RECORDS or {}
        INSTANCE_RECORDS = INSTANCE_RECORDS or {}
        LANGUAGE = 'en-us'

    elseif event == "VARIABLES_LOADED" then
        CheckVariabletype()

    elseif event == 'ZONE_CHANGED_NEW_AREA' then
        AddOverWordToRecords()
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            instance = instanceType == "party" and "Dungeon" or "Raid"
            local instanceName = GetZoneText()

            AddInstanceToRecords(instanceName)

            print(string.format(localization[LANGUAGE].enteringInstance, instanceName))

            ClearAllRecords()
        end

    elseif event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then -- when a spell crit a enemy
        if string.find(arg1, "crit") then

            local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for")
            targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 2)

            local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "Your "), string.find(arg1, "crit")
            spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 2)

            local startDamageIndex = string.find(arg1, "for %d+")
            local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
            if not endDamageIndex then
                endDamageIndex = string.find(arg1, "%.", startDamageIndex)
            end
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE AMOUNT

            SetInstanceRecord("TOP_CRIT", critDamage, targetName, spellName)
            SetOverWordRecord("TOP_CRIT", critDamage, targetName, spellName)

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
            targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 2)

            local startIndex, endIndex = string.find(arg1, "Your "), string.find(arg1, "critically") -- GET SPELL NAME
            spellName = string.sub(arg1, startIndex + 5, endIndex - 2)

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET THE DAMAGE AMOUNT

            SetInstanceRecord("TOP_HEAL", critDamage, targetName, spellName)
            SetOverWordRecord("TOP_HEAL", critDamage, targetName, spellName)

            if next(HIGHEST_HEAL) == nil or critDamage > HIGHEST_HEAL.DAMAGE then
                PlaySound("heal")
                SetHihgestStat(HIGHEST_HEAL, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].healingSpellCrit, critDamage, spellName))
            end
        end

        -- when an Auto Attack crit
    elseif event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        if string.find(arg1, "crit") then

            local startNameIndex, endNameIndex = string.find(arg1, "crit "), string.find(arg1, "for") -- GET TARGET NAME
            targetName = string.sub(arg1, startNameIndex + 5, endNameIndex - 2)

            local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit") -- SPELL NAME AUTO ATTACK
            spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

            SetInstanceRecord("TOP_CRIT", critDamage, targetName, spellName)
            SetOverWordRecord("TOP_CRIT", critDamage, targetName, spellName)

            if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
                PlaySound("crit")
                SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
            end
        end

    elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
        local endNameIndex = string.find(arg1, "crit")
        if endNameIndex then
            targetName = string.sub(arg1, 1, endNameIndex - 2) -- GET TARGET NAME

            local startIndex, endIndex = string.find(arg1, "crits "), string.find(arg1, "you ") -- GET THE SPELL AUTO ATTACK
            spellName = localization[LANGUAGE].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.") -- GET DAMAGE AMOUNT
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))

            SetInstanceRecord("TOP_DEF", critDamage, targetName, spellName)
            SetOverWordRecord("TOP_DEF", critDamage, targetName, spellName)

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                PlaySound("def")
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].defAutoCrit, critDamage, spellName))
            end
        end

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
        local endNameIndex = string.find(arg1, "'s") -- and crits
        if endNameIndex and string.find(arg1, "crits") then

            targetName = string.sub(arg1, 1, endNameIndex) -- GET TARGET NAME

            local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "'s "), string.find(arg1, "crits") -- GET SPELL NAME
            spellName = string.sub(arg1, startSpellNameIndex + 3, endSpellNameIndex - 2)

            local startDamageIndex = string.find(arg1, "for %d+")
            local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
            if not endDamageIndex then
                endDamageIndex = string.find(arg1, "%.", startDamageIndex)
            end
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

            SetInstanceRecord("TOP_DEF", critDamage, targetName, spellName)
            SetOverWordRecord("TOP_DEF", critDamage, targetName, spellName)

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                PlaySound("def")
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[LANGUAGE].defSpellCrit, critDamage, spellName))
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
        elseif string.find(arg1, "Curei ") and string.find(arg1, " com ") then
            PlaySound("heal")
        elseif string.find(arg1, "I took") and string.find(arg1, "damage from") then
            PlaySound("def")
        elseif string.find(arg1, "Tomei") and string.find(arg1, "de dano d") then
            PlaySound("def")
        end
    end

    -- COMMANDS --
    -- TODO COMANDS PARA O DEF
    -- Slash command to check your crit record
    SLASH_CRIT1 = '/top'
    SLASH_CRIT2 = '/t'
    SlashCmdList["CRIT"] = function(msg)
        if msg == "crit" then
            if next(HIGHEST_CRIT) == nil then
                print(localization[LANGUAGE].emptyData)
            else
                print(string.format(localization[LANGUAGE].critMessage, HIGHEST_CRIT.DAMAGE))
            end
        elseif msg == "heal" then
            if next(HIGHEST_HEAL) == nil then
                print(localization[LANGUAGE].emptyData)
            else
                print(string.format(localization[LANGUAGE].healMessage, HIGHEST_HEAL.DAMAGE))
            end
        elseif msg == "def" then
            if next(HIGHEST_DEF) == nil then
                print(localization[LANGUAGE].emptyData)
            else
                print(string.format(localization[LANGUAGE].defMessage, HIGHEST_DEF.DAMAGE))
            end
        end
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

    -- PRINT TABLES --
    SLASH_CTT1 = "/crit"
    SlashCmdList["CTT"] = function(msg)
        if msg == "heal" then
            HealTableTest()
        elseif msg == "def" then
            DefTableTest()
        elseif msg == "crit" then
            CritTableTest()
        end
    end
end)
