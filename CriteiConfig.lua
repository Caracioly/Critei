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
CriteiConfig:SetBackdropColor(0.2, 0.2, 0.2, 0.3)

-- Title
CriteiConfig.Title = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
CriteiConfig.Title:SetText("Critei Config")
CriteiConfig.Title:SetPoint("TOP", 0, -10)

-- Close button
CriteiConfig.CloseButton = CreateFrame("Button", nil, CriteiConfig, "UIPanelCloseButton")
CriteiConfig.CloseButton:SetPoint("TOPRIGHT", -5, -5)
CriteiConfig.CloseButton:SetScript("OnClick", function()
    CriteiConfig:Hide()
end)

-- critical dropdown -------
local criticalDmgDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
criticalDmgDropDown:SetText("Cri Damage SFX:")
criticalDmgDropDown:SetPoint("BOTTOMLEFT", 15, 165) -- text

CriteiConfig.criticalDmgDropDown = CreateFrame("Frame", "criticalDmgDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.criticalDmgDropDown:SetPoint("BOTTOMRIGHT", -120, 155)
CriteiConfig.SelectedCriticalDmgSound = "vineboom"
UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDmgSound, CriteiConfig.criticalDmgDropDown)

-----Language DropDown----
local languageDropDown = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
languageDropDown:SetText("Language:")
languageDropDown:SetPoint("BOTTOMLEFT", 15, 140) -- text

CriteiConfig.languageDropDown = CreateFrame("Frame", "languageDropDown", CriteiConfig, "UIDropDownMenuTemplate")
CriteiConfig.languageDropDown:SetPoint("BOTTOMRIGHT", -120, 130) -- dropdown
CriteiConfig.SelectedLanguage = "en-us"
UIDropDownMenu_SetText(CriteiConfig.SelectedLanguage, CriteiConfig.languageDropDown)

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

------- Clear Check-box------
local clearCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
clearCheckBoxTitle:SetText("Crit Reset on Instance Entry")
clearCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 70) -- text

CriteiConfig.CheckBox = CreateFrame("CheckButton", "ClearCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.CheckBox:SetPoint("BOTTOMRIGHT", -30, 60) -- checkbox

---------Yell Check-box--------
local yelldCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
yelldCheckBoxTitle:SetText("Yell Message on Crit")
yelldCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 45) -- text

CriteiConfig.CheckBox = CreateFrame("CheckButton", "YellCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.CheckBox:SetPoint("BOTTOMRIGHT", -30, 35) -- checkbox 
-------- Sound Check-box-----------
local soundCheckBoxTitle = CriteiConfig:CreateFontString(nil, "ARTWORK", "GameFontNormal")
soundCheckBoxTitle:SetText("Play Sound on Crit")
soundCheckBoxTitle:SetPoint("BOTTOMLEFT", 15, 20) -- text

CriteiConfig.CheckBox = CreateFrame("CheckButton", "CritSoundCheckBox", CriteiConfig, "UICheckButtonTemplate")
CriteiConfig.CheckBox:SetPoint("BOTTOMRIGHT", -30, 10) -- checkbox

--------------- BOTTOM ------------------------------
-- DROPDOWN SOUND

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
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Function to initialize sound dropdowns
local soundList = {"-999", "bonk", "minecraft", "omg", "oof", "taco", "vineboom", "weLive", "whoa"}

function InitializeCriticalDmgDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo()

    for _, sound in pairs(soundList) do
        local currentSound = sound
        info.text = currentSound
        info.value = currentSound
        info.func = function()
            CriteiConfig.SelectedCriticalDmgSound = currentSound
            UIDropDownMenu_SetText(CriteiConfig.SelectedCriticalDmgSound, CriteiConfig.criticalDmgDropDown)
            PlaySound(CriteiConfig.SelectedCriticalDmgSound)
            print(CriteiConfig.SelectedCriticalDmgSound)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

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
