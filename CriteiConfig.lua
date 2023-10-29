CriteiConfig = CreateFrame("Frame", "CriteiConfig", UIParent)
CriteiConfig:SetWidth(275)
CriteiConfig:SetHeight(450)
CriteiConfig:SetPoint("CENTER", 0, 60)
CriteiConfig:SetMovable(true)
CriteiConfig:EnableMouse(true)
CriteiConfig:RegisterForDrag("LeftButton")
CriteiConfig:SetScript("OnDragStart", CriteiConfig.StartMoving)
CriteiConfig:SetScript("OnDragStop", CriteiConfig.StopMovingOrSizing)
tinsert(UISpecialFrames, CriteiConfig:GetName())

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
CriteiConfig:SetBackdropColor(0.2, 0.2, 0.2, 0.5)

function doTheThing()
    instanceName:SetText(string.format("%s", CriteiConfig.SelectedInstance))
end

-- Title
CriteiConfig.Title = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
CriteiConfig.Title:SetText("Critei Config")
CriteiConfig.Title:SetPoint("TOP", 0, -10)

-- Close button
CriteiConfig.CloseButton = CreateFrame("Button", nil, CriteiConfig, "UIPanelCloseButton")
CriteiConfig.CloseButton:SetPoint("TOPRIGHT", -5, -5)
CriteiConfig.CloseButton:SetScript("OnClick", function()
    CriteiConfig:Hide()
end)

instanceName = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
instanceName:SetPoint("TOP", 0, -50) -- text
-----------------------------------------------------------------------------------------------
highestCrit = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
highestCrit:SetPoint("TOPLEFT", 10, -65) -- text
highestCrit:SetText("|cFFCD853FHighest Critical Damage|r")
-------------------------------------------------------
-- highestCritDamage = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- highestCritDamage:SetPoint("TOPLEFT", 10, -70) -- text
-- highestCritDamage:SetText(""..ORANGERED.."4654545"..END)

-- highestCritHeal = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- highestCritHeal:SetPoint("TOPLEFT", 10, -80) -- text
-- highestCritHeal:SetText(GREENYELLOW.."Target: Defias maluco"..END)

-- highestCritDef = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- highestCritDef:SetPoint("TOPLEFT", 10, -90) -- text
-- highestCritDef:SetText(ROYALBLUE.."Frost nova"..END)
---------------------------------------------------------------------------------------------


-- -- Texto de Maior Cura Crítica
-- local healingText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- healingText:SetText("Highest Critical Healing: Qual skill ele usou / em quem")
-- healingText:SetPoint("TOP", 0, -70)
-- healingText:SetTextColor(0, 1, 0) -- Cor verde

-- -- Texto de Maior Defesa Crítica
-- local defenseText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
-- defenseText:SetText("Highest Critical Defense: Qual skill ele Tomou / Quem que foi")
-- defenseText:SetPoint("TOP", 0, -100)
-- defenseText:SetTextColor(0, 0, 1) -- Cor azul


-- critical def dropdown--
local criticalDefDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDefDropDown:SetText("Crit Def SFX:")
criticalDefDropDown:SetPoint("BOTTOMLEFT", 15, 215) -- text

CriteiConfig.criticalDefDropDown = CreateFrame("Frame", "criticalDefDropDown", CriteiConfig, "UIDropDownMenuTemplate") -- Corrigido o nome aqui
CriteiConfig.criticalDefDropDown:SetPoint("BOTTOMRIGHT", -120, 205) -- Corrigido o nome aqui


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
languageDropDown:SetPoint("BOTTOMLEFT", 15, 140) -- text

CriteiConfig.languageDropDown = CreateFrame("Frame", "languageDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.languageDropDown:SetPoint("BOTTOMRIGHT", -120, 130) -- dropdown


-----Instance DropDown----
local instanceDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
instanceDropDown:SetText("Select a Instance:")
instanceDropDown:SetPoint("BOTTOMLEFT", 15, 115) -- text

CriteiConfig.InstanceDropDown = CreateFrame("Frame", "InstanceDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.InstanceDropDown:SetPoint("BOTTOMRIGHT", -120, 105) -- dropdown
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
    local info = UIDropDownMenu_CreateInfo()

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
    local info = UIDropDownMenu_CreateInfo()

    for _, instanceName in pairs(CRITEI_CONFIG.exploredInstances) do
        local currentInstanceName = instanceName
        info.text = currentInstanceName
        info.value = currentInstanceName
        info.func = function()
            CriteiConfig.SelectedInstance = currentInstanceName
            UIDropDownMenu_SetText(CriteiConfig.SelectedInstance, CriteiConfig.InstanceDropDown)
            print(CriteiConfig.SelectedInstance)
            doTheThing(CriteiConfig.SelectedInstance)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Function to initialize sound dropdowns
local soundList = {"-999", "bonk", "minecraft", "omg", "oof", "taco", "vineboom", "weLive", "whoa"}

function InitializeCriticalDmgDropDown(self, level)
    local info = UIDropDownMenu_CreateInfo()

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalDmgSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDmgSound, CriteiConfig.criticalDmgDropDown)
            PlaySound(CriteiConfig.SelectedCriticalDmgSound)
            changeCritSound("dmgSound",CriteiConfig.SelectedCriticalDmgSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

function InitializeCriticalHealDropDown(self, level)
    local info = UIDropDownMenu_CreateInfo()

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalHealSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalHealSound, CriteiConfig.criticalHealDropDown)
            PlaySound(CriteiConfig.SelectedCriticalHealSound)
            changeCritSound("healSound",CriteiConfig.SelectedCriticalHealSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

function InitializeCriticalDefDropDown(self, level)
    local info = UIDropDownMenu_CreateInfo()

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalDefSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDefSound, CriteiConfig.criticalDefDropDown)
            PlaySound(CriteiConfig.SelectedCriticalDefSound)
            changeCritSound("defSound" ,CriteiConfig.SelectedCriticalDefSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end
----------------------------------------------------------------------------------


-- Adicione um print fora do script do evento para verificar.
-- CriteiConfig:Hide() 

------- Exemplo de Botão
-- CriteiConfig.Button = CreateFrame("Button", nil, CriteiConfig, "UIPanelButtonTemplate")
-- CriteiConfig.Button:SetWidth(100)
-- CriteiConfig.Button:SetHeight(30)
-- CriteiConfig.Button:SetPoint("TOP", 0, -100) -- Posição ajustada
-- CriteiConfig.Button:SetText("Clique em Mim")
-- CriteiConfig.Button:SetScript("OnClick", function()
--     print("Botão Clicado!")
-- end)

-------- Exemplo de Text Input
-- CriteiConfig.TextInput = CreateFrame("EditBox", nil, CriteiConfig, "InputBoxTemplate")
-- CriteiConfig.TextInput:SetWidth(200)
-- CriteiConfig.TextInput:SetHeight(20)
-- CriteiConfig.TextInput:SetPoint("TOP", 0, -70) -- Posição ajustada
-- CriteiConfig.TextInput:SetAutoFocus(false) -- Para não focar automaticamente
