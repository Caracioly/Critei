CriteiConfig = CreateFrame("Frame", "CriteiConfig", UIParent)
CriteiConfig:SetWidth(275)
CriteiConfig:SetHeight(450)
CriteiConfig:SetPoint("CENTER", 0, 60)
CriteiConfig:SetMovable(true)
CriteiConfig:EnableMouse(true)
CriteiConfig:RegisterForDrag("LeftButton")
tinsert(UISpecialFrames, CriteiConfig:GetName())
CriteiConfig:SetScript("OnDragStart", function()
    if not CriteiConfig.isMoving then
        CriteiConfig:StartMoving()
        CriteiConfig.isMoving = true
    end
end)

CriteiConfig:SetScript("OnDragStop", function()
    if CriteiConfig.isMoving then
        CriteiConfig:StopMovingOrSizing()
        CriteiConfig.isMoving = false
    end
end)

CriteiConfig:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 18,
    edgeSize = 16,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4
    }
})
CriteiConfig:SetBackdropColor(0.2, 0.2, 0.2, 0.7)

function showCritData(instance)
    instanceNameText:SetText(string.format("%s", instance))
    local instanceData = INSTANCE_RECORDS[instance]
    if instanceData then
        local spellCRITDamage = instanceData.TOP_CRIT and instanceData.TOP_CRIT.DAMAGE or "Empty"
        local targeCRITtName = instanceData.TOP_CRIT and instanceData.TOP_CRIT.TARGET_NAME or "Empty"
        local spellCRITName = instanceData.TOP_CRIT and instanceData.TOP_CRIT.SPELL_NAME or "Empty"
        highestCritDamage:SetText(string.format("[Damage Amount]|cffffffff %s", spellCRITDamage))
        highestCritTarget:SetText(string.format("[Target Name]|cffffffff %s", targeCRITtName))
        highestCritSpell:SetText(string.format("[Spell Name]|cffffffff %s ", spellCRITName))
    else
        highestCritDamage:SetText("[Damage Amount]|cffffffff Empty")
        highestCritTarget:SetText("[Target Name]|cffffffff Empty")
        highestCritSpell:SetText("[Spell Name]|cffffffff Empty")
    end
    if instanceData then
        local spellHEALDamage = instanceData.TOP_HEAL and instanceData.TOP_HEAL.DAMAGE or "Empty"
        local targetHEALName = instanceData.TOP_HEAL and instanceData.TOP_HEAL.TARGET_NAME or "Empty"
        local spellHEALName = instanceData.TOP_HEAL and instanceData.TOP_HEAL.SPELL_NAME or "Empty"
        highestHealDamage:SetText(string.format("[Heal Amount]|cffffffff %s.", spellHEALDamage))
        highestHealTarget:SetText(string.format("[Target Name]|cffffffff %s.", targetHEALName))
        highestHealSpell:SetText(string.format("[Spell Name]|cffffffff %s.", spellHEALName))
    else
        highestHealDamage:SetText("[Damage Amount]|cffffffff Empty.")
        highestHealTarget:SetText("[Target Name]|cffffffff Empty.")
        highestHealSpell:SetText("[Spell Name]|cffffffff Empty.")
    end
    if instanceData then
        local spellDEFDamage = instanceData.TOP_DEF and instanceData.TOP_DEF.DAMAGE or "Empty"
        local targetDEFName = instanceData.TOP_DEF and instanceData.TOP_DEF.TARGET_NAME or "Empty"
        local spellDEFName = instanceData.TOP_DEF and instanceData.TOP_DEF.SPELL_NAME or "Empty"
        highestDefDamage:SetText(string.format("[Damage Taken Amount]|cffffffff %s.", spellDEFDamage))
        highestDefTarget:SetText(string.format("[Source Name]|cffffffff %s.", targetDEFName))
        highestDefSpell:SetText(string.format("[Spell Name]|cffffffff %s.", spellDEFName))
    else
        highestDefDamage:SetText("[Damage Taken Amount]|cffffffff Empty.")
        highestDefTarget:SetText("[Source Name]|cffffffff Empty.")
        highestDefSpell:SetText("[Spell Name]|cffffffff Empty.")
    end
end

-- Title
CriteiConfig.Title = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
CriteiConfig.Title:SetText("Critei Config v1.2.0")
CriteiConfig.Title:SetPoint("TOPLEFT", 10, -10)


-- Close button
CriteiConfig.CloseButton = CreateFrame("Button", nil, CriteiConfig, "UIPanelCloseButton")
CriteiConfig.CloseButton:SetPoint("TOPRIGHT", -5, -2)
CriteiConfig.CloseButton:SetScript("OnClick", function()
    CriteiConfig:Hide()
end)

local separatorLineTitle = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineTitle:SetTexture(1, 1, 1, 0.3)
separatorLineTitle:SetWidth(270)
separatorLineTitle:SetHeight(2)
separatorLineTitle:SetPoint("TOP", 0, -30)
-----------------------------------------------------------------------------------------------
instanceNameText = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
instanceNameText:SetPoint("TOP", 0, -32) -- text

highestCrit = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestCrit:SetPoint("TOPLEFT", 10, -52) -- text
highestCrit:SetText("|cFFCD853FHighest Critical Damage Amount:|r")
-------------------------------------------------------
highestCritSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritSpell:SetPoint("TOPLEFT", 20, -65) -- text
highestCritSpell:SetText("[Spell Name]|cffffffff Empty.")

highestCritTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritTarget:SetPoint("TOPLEFT", 20, -75) -- text
highestCritTarget:SetText("[Target Name]|cffffffff Empty.")

highestCritDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritDamage:SetPoint("TOPLEFT", 20, -85) -- text
highestCritDamage:SetText("[Damage Amount]|cffffffff Empty.")
--------------------------------------------------------

local separatorLineHEAL = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineHEAL:SetTexture(1, 1, 1, 0.3)
separatorLineHEAL:SetWidth(230)
separatorLineHEAL:SetHeight(1)
separatorLineHEAL:SetPoint("TOP", 0, -100)
---------------------------------------------------------------------------------------------
highestHeal = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestHeal:SetPoint("TOPLEFT", 10, -103) -- text
highestHeal:SetText("|cFFADFF2FHighest Critical Heal Amount:|r")
-------------------------------------------------------
highestHealSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealSpell:SetPoint("TOPLEFT", 20, -115) -- text
highestHealSpell:SetText("[Spell Name]|cffffffff Empty.")

highestHealTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealTarget:SetPoint("TOPLEFT", 20, -125) -- text
highestHealTarget:SetText("[Target Name]|cffffffff Empty.")

highestHealDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealDamage:SetPoint("TOPLEFT", 20, -135) -- text
highestHealDamage:SetText("[Heal Amount]|cffffffff Empty.")
------------------------------------------------------------------------------------------
local separatorLineDEF = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineDEF:SetTexture(1, 1, 1, 0.3)
separatorLineDEF:SetWidth(230)
separatorLineDEF:SetHeight(1)
separatorLineDEF:SetPoint("TOP", 0, -150)
---------------------------------------------------------------------------------------------
highestDef = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestDef:SetPoint("TOPLEFT", 10, -153) -- text
highestDef:SetText("|cFF4169E1Highest Damage Taken Amount:|r")
-------------------------------------------------------
highestDefSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefSpell:SetPoint("TOPLEFT", 20, -165) -- text
highestDefSpell:SetText("[Spell Name]|cffffffff Empty.")

highestDefTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefTarget:SetPoint("TOPLEFT", 20, -175) -- text
highestDefTarget:SetText("[Source Name]|cffffffff Empty.")

highestDefDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefDamage:SetPoint("TOPLEFT", 20, -185) -- text
highestDefDamage:SetText("[Taken Amount]|cffffffff Empty.")
------------------------------------------------------------------------------------------
local separatorLineFinal = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineFinal:SetTexture(1, 1, 1, 0.3)
separatorLineFinal:SetWidth(270)
separatorLineFinal:SetHeight(1)
separatorLineFinal:SetPoint("TOP", 0, -205)
---------------------------------------------------------------------------------------------

-- critical def dropdown--
local criticalDefDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDefDropDown:SetText("Crit Def SFX:")
criticalDefDropDown:SetPoint("BOTTOMLEFT", 15, 140) -- text

CriteiConfig.criticalDefDropDown = CreateFrame("Frame", "criticalDefDropDown", CriteiConfig, "UIDropDownMenuTemplate") -- Corrigido o nome aqui
CriteiConfig.criticalDefDropDown:SetPoint("BOTTOMRIGHT", -120, 130) -- Corrigido o nome aqui

-- critical heal dropdown--
local criticalHealDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalHealDropDown:SetText("Crit Heal SFX:")
criticalHealDropDown:SetPoint("BOTTOMLEFT", 15, 190) -- text

CriteiConfig.criticalHealDropDown = CreateFrame("Frame", "criticalHealDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalHealDropDown:SetPoint("BOTTOMRIGHT", -120, 180)

-- critical damage dropdown -------
local criticalDmgDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDmgDropDown:SetText("Cri Damage SFX:")
criticalDmgDropDown:SetPoint("BOTTOMLEFT", 15, 165) -- text

CriteiConfig.criticalDmgDropDown = CreateFrame("Frame", "criticalDmgDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalDmgDropDown:SetPoint("BOTTOMRIGHT", -120, 155)

-----Language DropDown----
local languageDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
languageDropDown:SetText("Language:")
languageDropDown:SetPoint("BOTTOMLEFT", 15, 115) -- text

CriteiConfig.languageDropDown = CreateFrame("Frame", "languageDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.languageDropDown:SetPoint("BOTTOMRIGHT", -120, 105) -- dropdown

-----Instance DropDown----
local instanceDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
instanceDropDown:SetText("Select a Instance:")
instanceDropDown:SetPoint("BOTTOMLEFT", 15, 215) -- text

CriteiConfig.InstanceDropDown = CreateFrame("Frame", "InstanceDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.InstanceDropDown:SetPoint("BOTTOMRIGHT", -120, 205) -- dropdown
CriteiConfig.SelectedInstance = "OverWorld"
UIDropDownMenu_SetText(CriteiConfig.SelectedInstance, CriteiConfig.InstanceDropDown)

-----------------------------------LINE SEPARATOR--------------------------------------------------
local separatorLineBOTTOM = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineBOTTOM:SetTexture(1, 1, 1, 0.3)
separatorLineBOTTOM:SetWidth(270)
separatorLineBOTTOM:SetHeight(2)
separatorLineBOTTOM:SetPoint("BOTTOM", 0, 90)

------- Clear Check-box ------
local clearCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
clearCheckBoxTitle:SetText("Crit Reset on Instance Entry")
clearCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 70) -- text

CriteiConfig.ClearCheckbox = CreateFrame("CheckButton", "ClearCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.ClearCheckbox:SetPoint("BOTTOMRIGHT", -30, 60) -- checkbox

--------- Yell Check-box --------
local yellCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
yellCheckBoxTitle:SetText("Yell Message on Crit")
yellCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 45) -- text

CriteiConfig.YellCheckbox = CreateFrame("CheckButton", "YellCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.YellCheckbox:SetPoint("BOTTOMRIGHT", -30, 35) -- checkbox

-------- Sound Check-box --------
local soundCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
soundCheckBoxTitle:SetText("Play Sound on Crit")
soundCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 20) -- text

CriteiConfig.CritSoundCheckbox = CreateFrame("CheckButton", "CritSoundCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.CritSoundCheckbox:SetPoint("BOTTOMRIGHT", -30, 10) -- checkbox

--------------- BOTTOM --------------

---------------------CHECKBOX----------------------------------

function OnClearCheckboxChanged()
    local isChecked = CriteiConfig.ClearCheckbox:GetChecked()
    if isChecked then
        CRITEI_CONFIG.isClearOn = true
    else
        CRITEI_CONFIG.isClearOn = false
    end
end

function OnYellCheckboxChanged()
    local isChecked = CriteiConfig.YellCheckbox:GetChecked()
    if isChecked then
        CRITEI_CONFIG.isYellOn = true
    else
        CRITEI_CONFIG.isYellOn = false
    end
end

function OnSoundCheckboxChanged()
    local isChecked = CriteiConfig.CritSoundCheckbox:GetChecked()
    if isChecked then
        CRITEI_CONFIG.isSoundOn = true
    else
        CRITEI_CONFIG.isSoundOn = false
    end
end

CriteiConfig.ClearCheckbox:SetScript("OnClick", OnClearCheckboxChanged)
CriteiConfig.YellCheckbox:SetScript("OnClick", OnYellCheckboxChanged)
CriteiConfig.CritSoundCheckbox:SetScript("OnClick", OnSoundCheckboxChanged)
-------------------------------------------------------------------------------

-- DROPDOWN LANGUAGE function
local languageList = {"en-us", "pt-br"}

function InitializeLanguageDropDown(self, level)
    local info = {}

    for _, language in pairs(languageList) do
        local currentLanguage = language
        info.text = currentLanguage
        info.value = currentLanguage
        info.func = function()
            CriteiConfig.SelectedLanguage = currentLanguage
            UIDropDownMenu_SetText(CriteiConfig.SelectedLanguage, CriteiConfig.languageDropDown)
            changeLanguage(CriteiConfig.SelectedLanguage)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end
-- DROPDOWN INSTANCE function

function InitializeInstanceDropDown(self, level)
    local info = {}

    for _, instanceName in pairs(CRITEI_CONFIG.exploredInstances) do
        local currentInstanceName = instanceName
        info.text = currentInstanceName
        info.value = currentInstanceName
        info.func = function()
            CriteiConfig.SelectedInstance = currentInstanceName
            UIDropDownMenu_SetText(CriteiConfig.SelectedInstance, CriteiConfig.InstanceDropDown)
            showCritData(CriteiConfig.SelectedInstance)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Function to initialize sound dropdowns
local soundList = {"-999", "auuu", "bonk", "minecraft", "omg", "oof", "taco", "vineboom", "weLive", "whoa"}

function InitializeCriticalDmgDropDown(self, level)
    local info = {}

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalDmgSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDmgSound, CriteiConfig.criticalDmgDropDown)
            PlaySound(CriteiConfig.SelectedCriticalDmgSound)
            changeCritSound("dmgSound", CriteiConfig.SelectedCriticalDmgSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

function InitializeCriticalHealDropDown(self, level)
    local info = {}

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalHealSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalHealSound, CriteiConfig.criticalHealDropDown)
            PlaySound(CriteiConfig.SelectedCriticalHealSound)
            changeCritSound("healSound", CriteiConfig.SelectedCriticalHealSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

function InitializeCriticalDefDropDown(self, level)
    local info = {}

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalDefSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDefSound, CriteiConfig.criticalDefDropDown)
            PlaySound(CriteiConfig.SelectedCriticalDefSound)
            changeCritSound("defSound", CriteiConfig.SelectedCriticalDefSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end
----------------------------------------------------------------------------------
