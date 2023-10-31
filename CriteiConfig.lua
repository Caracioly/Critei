CriteiConfig = CreateFrame("Frame", "CriteiConfig", UIParent)
CriteiConfig:SetWidth(275)
CriteiConfig:SetHeight(450)
CriteiConfig:SetPoint("CENTER", 0, 60)
CriteiConfig:SetMovable(true)
CriteiConfig:EnableMouse(true)
CriteiConfig:RegisterForDrag("LeftButton")
tinsert(UISpecialFrames, CriteiConfig:GetName())

-- drag start function
CriteiConfig:SetScript("OnDragStart", function()
    if not CriteiConfig.isMoving then
        CriteiConfig:StartMoving()
        CriteiConfig.isMoving = true
    end
end)
-- drag stop function
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

-- print function
function showCritData(instance)
    instanceNameText:SetText(string.format("%s", instance))
    local instanceData = INSTANCE_RECORDS[instance]
    if instanceData then
        local spellCRITDamage = instanceData.TOP_CRIT and instanceData.TOP_CRIT.DAMAGE or "Empty"
        local targeCRITtName = instanceData.TOP_CRIT and instanceData.TOP_CRIT.TARGET_NAME or "Empty"
        local spellCRITName = instanceData.TOP_CRIT and instanceData.TOP_CRIT.SPELL_NAME or "Empty"

        local spellHEALDamage = instanceData.TOP_HEAL and instanceData.TOP_HEAL.DAMAGE or "Empty"
        local targetHEALName = instanceData.TOP_HEAL and instanceData.TOP_HEAL.TARGET_NAME or "Empty"
        local spellHEALName = instanceData.TOP_HEAL and instanceData.TOP_HEAL.SPELL_NAME or "Empty"

        local spellDEFDamage = instanceData.TOP_DEF and instanceData.TOP_DEF.DAMAGE or "Empty"
        local targetDEFName = instanceData.TOP_DEF and instanceData.TOP_DEF.TARGET_NAME or "Empty"
        local spellDEFName = instanceData.TOP_DEF and instanceData.TOP_DEF.SPELL_NAME or "Empty"

        highestHealDamage:SetText(string.format("[Heal Amount]|cffffffff %s.", spellHEALDamage))
        highestHealTarget:SetText(string.format("[Target Name]|cffffffff %s.", targetHEALName))
        highestHealSpell:SetText(string.format("[Spell Name]|cffffffff %s.", spellHEALName))

        highestDefDamage:SetText(string.format("[Damage Taken Amount]|cffffffff %s.", spellDEFDamage))
        highestDefTarget:SetText(string.format("[Source Name]|cffffffff %s.", targetDEFName))
        highestDefSpell:SetText(string.format("[Spell Name]|cffffffff %s.", spellDEFName))

        highestCritDamage:SetText(string.format("[Damage Amount]|cffffffff %s", spellCRITDamage))
        highestCritTarget:SetText(string.format("[Target Name]|cffffffff %s", targeCRITtName))
        highestCritSpell:SetText(string.format("[Spell Name]|cffffffff %s ", spellCRITName))
    else
        highestCritDamage:SetText("[Damage Amount]|cffffffff Empty")
        highestCritTarget:SetText("[Target Name]|cffffffff Empty")
        highestCritSpell:SetText("[Spell Name]|cffffffff Empty")

        highestHealDamage:SetText("[Damage Amount]|cffffffff Empty.")
        highestHealTarget:SetText("[Target Name]|cffffffff Empty.")
        highestHealSpell:SetText("[Spell Name]|cffffffff Empty.")

        highestDefDamage:SetText("[Damage Taken Amount]|cffffffff Empty.")
        highestDefTarget:SetText("[Source Name]|cffffffff Empty.")
        highestDefSpell:SetText("[Spell Name]|cffffffff Empty.")
    end
end

-- frame title
CriteiConfig.Title = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
CriteiConfig.Title:SetText("Critei Config")
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

-- instance title
instanceNameText = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
instanceNameText:SetPoint("TOP", 0, -32) 

-- critical record title
highestCrit = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestCrit:SetPoint("TOPLEFT", 10, -52) 
highestCrit:SetText("|cFFCD853FHighest Critical Damage Amount:|r")
-- spell name
highestCritSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritSpell:SetPoint("TOPLEFT", 20, -65)
highestCritSpell:SetText("[Spell Name]|cffffffff Empty.")
-- target name
highestCritTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritTarget:SetPoint("TOPLEFT", 20, -75) 
highestCritTarget:SetText("[Target Name]|cffffffff Empty.")
-- damage amount
highestCritDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestCritDamage:SetPoint("TOPLEFT", 20, -85)
highestCritDamage:SetText("[Damage Amount]|cffffffff Empty.")

local separatorLineHEAL = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineHEAL:SetTexture(1, 1, 1, 0.3)
separatorLineHEAL:SetWidth(230)
separatorLineHEAL:SetHeight(1)
separatorLineHEAL:SetPoint("TOP", 0, -100)

-- heal record title
highestHeal = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestHeal:SetPoint("TOPLEFT", 10, -103) 
highestHeal:SetText("|cFFADFF2FHighest Critical Heal Amount:|r")
-- spell name
highestHealSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealSpell:SetPoint("TOPLEFT", 20, -115) 
highestHealSpell:SetText("[Spell Name]|cffffffff Empty.")
-- target name
highestHealTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealTarget:SetPoint("TOPLEFT", 20, -125) 
highestHealTarget:SetText("[Target Name]|cffffffff Empty.")
-- heal amount
highestHealDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestHealDamage:SetPoint("TOPLEFT", 20, -135) 
highestHealDamage:SetText("[Heal Amount]|cffffffff Empty.")

local separatorLineDEF = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineDEF:SetTexture(1, 1, 1, 0.3)
separatorLineDEF:SetWidth(230)
separatorLineDEF:SetHeight(1)
separatorLineDEF:SetPoint("TOP", 0, -150)

-- def record title
highestDef = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestDef:SetPoint("TOPLEFT", 10, -153)
highestDef:SetText("|cFF4169E1Highest Damage Taken Amount:|r")
-- spell name
highestDefSpell = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefSpell:SetPoint("TOPLEFT", 20, -165) 
highestDefSpell:SetText("[Spell Name]|cffffffff Empty.")
-- source name
highestDefTarget = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefTarget:SetPoint("TOPLEFT", 20, -175)
highestDefTarget:SetText("[Source Name]|cffffffff Empty.")
-- taken amount
highestDefDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
highestDefDamage:SetPoint("TOPLEFT", 20, -185) 
highestDefDamage:SetText("[Taken Amount]|cffffffff Empty.")

local separatorLineFinal = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineFinal:SetTexture(1, 1, 1, 0.3)
separatorLineFinal:SetWidth(270)
separatorLineFinal:SetHeight(1)
separatorLineFinal:SetPoint("TOP", 0, -205)

-- critical def sound text
local criticalDefDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDefDropDown:SetText("Crit Def SFX:")
criticalDefDropDown:SetPoint("BOTTOMLEFT", 15, 140) 
-- critical def sound dropdown
CriteiConfig.criticalDefDropDown = CreateFrame("Frame", "criticalDefDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalDefDropDown:SetPoint("BOTTOMRIGHT", -120, 130) 

-- critical heal sound text
local criticalHealDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalHealDropDown:SetText("Crit Heal SFX:")
criticalHealDropDown:SetPoint("BOTTOMLEFT", 15, 190) 
-- critical heal sound dropdown
CriteiConfig.criticalHealDropDown = CreateFrame("Frame", "criticalHealDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalHealDropDown:SetPoint("BOTTOMRIGHT", -120, 180)

-- critical damage sound sound
local criticalDmgDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDmgDropDown:SetText("Cri Damage SFX:")
criticalDmgDropDown:SetPoint("BOTTOMLEFT", 15, 165)
-- critical damage sound dropdown
CriteiConfig.criticalDmgDropDown = CreateFrame("Frame", "criticalDmgDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalDmgDropDown:SetPoint("BOTTOMRIGHT", -120, 155)

-- Language DropDown text
local languageDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
languageDropDown:SetText("Language:")
languageDropDown:SetPoint("BOTTOMLEFT", 15, 115) -- text
-- language dropdown
CriteiConfig.languageDropDown = CreateFrame("Frame", "languageDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.languageDropDown:SetPoint("BOTTOMRIGHT", -120, 105) 

-- instance dropdown text
local instanceDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
instanceDropDown:SetText("Select a Instance:")
instanceDropDown:SetPoint("BOTTOMLEFT", 15, 215) 
-- instance dropdown
CriteiConfig.InstanceDropDown = CreateFrame("Frame", "InstanceDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.InstanceDropDown:SetPoint("BOTTOMRIGHT", -120, 205) 
CriteiConfig.SelectedInstance = "OverWorld"
UIDropDownMenu_SetText(CriteiConfig.SelectedInstance, CriteiConfig.InstanceDropDown)

local separatorLineBOTTOM = CriteiConfig:CreateTexture(nil, "BACKGROUND")
separatorLineBOTTOM:SetTexture(1, 1, 1, 0.3)
separatorLineBOTTOM:SetWidth(270)
separatorLineBOTTOM:SetHeight(2)
separatorLineBOTTOM:SetPoint("BOTTOM", 0, 90)

-- clear text
local clearCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
clearCheckBoxTitle:SetText("Crit Reset on Instance Entry")
clearCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 70) 
-- clear checkbox
CriteiConfig.ClearCheckbox = CreateFrame("CheckButton", "ClearCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.ClearCheckbox:SetPoint("BOTTOMRIGHT", -30, 60) 

-- yell text
local yellCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
yellCheckBoxTitle:SetText("Yell Message on Crit")
yellCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 45) 
-- yell check box
CriteiConfig.YellCheckbox = CreateFrame("CheckButton", "YellCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.YellCheckbox:SetPoint("BOTTOMRIGHT", -30, 35) 

-- sound text
local soundCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
soundCheckBoxTitle:SetText("Play Sound on Crit")
soundCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 20) 
-- sound checkbox
CriteiConfig.CritSoundCheckbox = CreateFrame("CheckButton", "CritSoundCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.CritSoundCheckbox:SetPoint("BOTTOMRIGHT", -30, 10)

-- Clear checkbox
function OnClearCheckboxChanged()
    local isChecked = CriteiConfig.ClearCheckbox:GetChecked()
    if isChecked then
        CRITEI_CONFIG.isClearOn = true
    else
        CRITEI_CONFIG.isClearOn = false
    end
end

-- Yell checkbox
function OnYellCheckboxChanged()
    local isChecked = CriteiConfig.YellCheckbox:GetChecked()
    if isChecked then
        CRITEI_CONFIG.isYellOn = true
    else
        CRITEI_CONFIG.isYellOn = false
    end
end

-- Sound CheckBox
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

-- function to select a language
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

-- Functin to select a instance 
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

-- All SFX
local soundList = {"-999", "auuu", "bonk", "dks", "minecraft", "omg", "oof", "pipe", "taco", "vineboom", "weLive", "whoa"}

-- Select the Damage crit sound
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

-- Select the Heal crit sound
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

-- Select the Damage Taken crit sound
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
