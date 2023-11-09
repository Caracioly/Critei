local CritNotifier = CreateFrame("Frame")
local playerName = UnitName("player")
local spellName, targetName, critDamage, instance, chatID, chatName
local isYellValid = false
local yellKeywords = {"Critei", "Crited", "Critically", "Curei", "took", "Tomei"}

CritNotifier:RegisterEvent("VARIABLES_LOADED")
CritNotifier:RegisterEvent("PLAYER_ENTERING_WORLD")
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
CritNotifier:RegisterEvent('CHAT_MSG_SPELL_SELF_BUFF')
CritNotifier:RegisterEvent('CHAT_MSG_YELL')
CritNotifier:RegisterEvent('ADDON_LOADED')
CritNotifier:RegisterEvent("CHAT_MSG_CHANNEL")

function changeCritSound(type, sound)
    if type == "defSound" then
        CRITEI_CONFIG.defSound = sound
    elseif type == "healSound" then
        CRITEI_CONFIG.healSound = sound
    elseif type == "dmgSound" then
        CRITEI_CONFIG.dmgSound = sound
    else
        print(string.format(localization[CRITEI_CONFIG.language].soundNotFound))
    end
end

function AddInstanceToRecords(instance_name)
    local exists = false
    for _, instance in ipairs(CRITEI_CONFIG.exploredInstances) do
        if instance == instance_name then
            exists = true
            break
        end
    end
    if not exists then
        table.insert(CRITEI_CONFIG.exploredInstances, instance_name)
    end
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

function SetInstanceRecord(stat, XcritDamage, XtargetName, XspellName)
    local inInstance, instanceType = IsInInstance()
    local instanceName = GetZoneText()
    if (inInstance and (instanceType == "party" or instanceType == "raid")) or instanceType == "none" then
        if instanceType == "none" then
            instanceName = "OverWorld"
        end
        if not INSTANCE_RECORDS[instanceName] then
            AddInstanceToRecords(instanceName)
        end
        if XcritDamage > INSTANCE_RECORDS[instanceName][stat].DAMAGE then
            print(string.format(localization[CRITEI_CONFIG.language].recordBrokenINS, instanceName))
            INSTANCE_RECORDS[instanceName][stat].DAMAGE = XcritDamage
            INSTANCE_RECORDS[instanceName][stat].TARGET_NAME = XtargetName
            INSTANCE_RECORDS[instanceName][stat].SPELL_NAME = XspellName
        end
    end
end

function PlaySound(sound)
    if CRITEI_CONFIG.isSoundOn then
        PlaySoundFile("Interface\\AddOns\\Critei\\SFX\\" .. sound .. ".ogg")
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
    if CRITEI_CONFIG.isYellOn then
        SendChatMessage(message, "YELL", nil)
    end
end

CritNotifier:SetScript("OnEvent", function()
    -- When ADDON is loaded
    if event == "ADDON_LOADED" and arg1 == "Critei" then
        HIGHEST_CRIT = HIGHEST_CRIT or {}
        HIGHEST_HEAL = HIGHEST_HEAL or {}
        HIGHEST_DEF = HIGHEST_DEF or {}
        INSTANCE_RECORDS = INSTANCE_RECORDS or {
            ["OverWorld"] = {
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
        }
        CRITEI_CONFIG = CRITEI_CONFIG or {
            isClearOn = true,
            isYellOn = true,
            isSoundOn = true,
            language = "en-us",
            dmgSound = "vineboom",
            healSound = "whoa",
            defSound = "omg",
            exploredInstances = {
                [1] = "OverWorld"
            }
        }

    elseif event == "VARIABLES_LOADED" then
        CriteiConfig.SelectedCriticalDefSound = CRITEI_CONFIG.defSound
        UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDefSound, CriteiConfig.criticalDefDropDown)

        CriteiConfig.SelectedCriticalDmgSound = CRITEI_CONFIG.dmgSound
        UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDmgSound, CriteiConfig.criticalDmgDropDown)

        CriteiConfig.SelectedCriticalHealSound = CRITEI_CONFIG.healSound
        UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalHealSound, CriteiConfig.criticalHealDropDown)

        CriteiConfig.SelectedLanguage = CRITEI_CONFIG.language
        UIDropDownMenu_SetText(CriteiConfig.SelectedLanguage, CriteiConfig.languageDropDown)

        UIDropDownMenu_Initialize(CriteiConfig.InstanceDropDown, InitializeInstanceDropDown)
        UIDropDownMenu_Initialize(CriteiConfig.languageDropDown, InitializeLanguageDropDown)
        UIDropDownMenu_Initialize(CriteiConfig.criticalDmgDropDown, InitializeCriticalDmgDropDown)
        UIDropDownMenu_Initialize(CriteiConfig.criticalHealDropDown, InitializeCriticalHealDropDown)
        UIDropDownMenu_Initialize(CriteiConfig.criticalDefDropDown, InitializeCriticalDefDropDown)

        CriteiConfig.ClearCheckbox:SetChecked(CRITEI_CONFIG.isClearOn)
        CriteiConfig.YellCheckbox:SetChecked(CRITEI_CONFIG.isYellOn)
        CriteiConfig.CritSoundCheckbox:SetChecked(CRITEI_CONFIG.isSoundOn)

        instanceNameText:SetText(string.format("%s", CriteiConfig.SelectedInstance))

        showCritData("OverWorld")

        chatID, chatName = GetChannelName("LFT");
        if not (chatID > 0 and chatName ~= nil) then
            local channel_type, channel_name = JoinChannelByName("LFT", nil, nil)
        end

    elseif event == 'PLAYER_ENTERING_WORLD' then
        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            instance = instanceType == "party" and "Dungeon" or "Raid"
            local instanceName = GetZoneText()

            print(string.format(localization[CRITEI_CONFIG.language].enteringInstance, instanceName))
            if CRITEI_CONFIG.isClearOn then
                ClearAllRecords()
            end
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

            if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
                SendYellMessage(string.format(localization[CRITEI_CONFIG.language].autoAndSpellSCrit, critDamage,
                spellName))
                PlaySound(CriteiConfig.SelectedCriticalDmgSound)
                SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
                SendChatMessage(CRITEI_CONFIG.dmgSound, "CHANNEL", nil, chatID)
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

            if next(HIGHEST_HEAL) == nil or critDamage > HIGHEST_HEAL.DAMAGE then
                SendYellMessage(string.format(localization[CRITEI_CONFIG.language].healingSpellCrit, critDamage,
                    spellName))
                PlaySound(CriteiConfig.SelectedCriticalHealSound)
                SetHihgestStat(HIGHEST_HEAL, critDamage, targetName, spellName)
                SendChatMessage(CRITEI_CONFIG.healSound, "CHANNEL", nil, chatID)
            end
        end

        -- when an Auto Attack crit
    elseif event == 'CHAT_MSG_COMBAT_SELF_HITS' then
        if string.find(arg1, "crit") then

            local startNameIndex, endNameIndex = string.find(arg1, "crit "), string.find(arg1, "for") -- GET TARGET NAME
            targetName = string.sub(arg1, startNameIndex + 5, endNameIndex - 2)

            local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit") -- SPELL NAME AUTO ATTACK
            spellName = localization[CRITEI_CONFIG.language].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

            SetInstanceRecord("TOP_CRIT", critDamage, targetName, spellName)

            if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
                SendYellMessage(string.format(localization[CRITEI_CONFIG.language].autoAndSpellSCrit, critDamage,
                spellName))
                PlaySound(CriteiConfig.SelectedCriticalDmgSound)
                SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
                SendChatMessage(CRITEI_CONFIG.dmgSound, "CHANNEL", nil, chatID)
            end
        end

    elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
        local endNameIndex = string.find(arg1, "crit")
        if endNameIndex then
            targetName = string.sub(arg1, 1, endNameIndex - 2) -- GET TARGET NAME

            local startIndex, endIndex = string.find(arg1, "crits "), string.find(arg1, "you ") -- GET THE SPELL AUTO ATTACK
            spellName = localization[CRITEI_CONFIG.language].aa

            local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.") -- GET DAMAGE AMOUNT
            critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))

            SetInstanceRecord("TOP_DEF", critDamage, targetName, spellName)

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                SendChatMessage(CRITEI_CONFIG.defSound, "CHANNEL", nil, chatID)
                PlaySound(CriteiConfig.SelectedCriticalDefSound)
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[CRITEI_CONFIG.language].defAutoCrit, critDamage, spellName))
            end
        end

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" then
        local endNameIndex = string.find(arg1, "'s")
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

            if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
                SendChatMessage(CRITEI_CONFIG.defSound, "CHANNEL", nil, chatID)
                PlaySound(CriteiConfig.SelectedCriticalDefSound)
                SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
                SendYellMessage(string.format(localization[CRITEI_CONFIG.language].defSpellCrit, critDamage, spellName))
            end
        end

        local soundList = {"-999", "auuu", "bonk", "dks", "minecraft", "omg", "oof", "pipe", "taco", "vineboom",
                           "weLive", "whoa"}

    elseif event == 'CHAT_MSG_YELL' and arg2 ~= playerName then
        for _, keyword in ipairs(yellKeywords) do
            if string.find(arg1, keyword) then
                isYellValid = true
                break
            end
        end

    elseif event == 'CHAT_MSG_CHANNEL' then
        if arg8 == chatID and arg2 ~= playerName then
            if string.find(table.concat(soundList, " "), arg1) then
                if isYellValid then
                    PlaySound(arg1)
                    isYellValid = false
                end
            end
        end
    end

    -- change language 
    function changeLanguage(languageToChange)
        CRITEI_CONFIG.language = languageToChange
        CRITEI_CONFIG.language = CRITEI_CONFIG.language
    end

    -- COMMANDS --
    -- reset crit values
    SLASH_CRESET1 = "/critclear"
    SLASH_CRESET2 = "/cc"
    SlashCmdList["CRESET"] = function()
        print(localization[CRITEI_CONFIG.language].resetMessage)
        ClearAllRecords()
    end

    SLASH_CRITEI1 = "/critei"
    SlashCmdList["CRITEI"] = function()
        showCritData(CriteiConfig.SelectedInstance)
        CriteiConfig:Show()
    end
end)