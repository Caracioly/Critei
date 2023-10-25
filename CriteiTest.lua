function TestSetHihgestStat()
    SetHihgestStat(HIGHEST_CRIT, 1000, "AnDrE ", "Test Spell")
    SetHihgestStat(HIGHEST_HEAL, 1000, "AnDrE ", "Test Spell")
    SetHihgestStat(HIGHEST_DEF, 1000, "AnDrE ", "Test Spell")

    if HIGHEST_CRIT.DAMAGE == 1000 and HIGHEST_CRIT.TARGET_NAME == "AnDrE " and HIGHEST_CRIT.SPELL_NAME == "Test Spell" then
        print("TestSetHihgestCrit: Teste bem-sucedido")
    else
        print("TestSetHihgestCrit: Teste falhou")
    end

    if HIGHEST_HEAL.DAMAGE == 1000 and HIGHEST_HEAL.TARGET_NAME == "AnDrE " and HIGHEST_HEAL.SPELL_NAME == "Test Spell" then
        print("TestSetHihgestHeal: Teste bem-sucedido")
    else
        print("TestSetHihgestHeal: Teste falhou")
    end

    if HIGHEST_DEF.DAMAGE == 1000 and HIGHEST_DEF.TARGET_NAME == "AnDrE " and HIGHEST_DEF.SPELL_NAME == "Test Spell" then
        print("TestSetHihgesDef: Teste bem-sucedido")
    else
        print("TestSetHihgesDef: Teste falhou")
    end
end

function CritTableTest()
    print("----")
    print("HIGHEST" .. ORANGERED .. " CRIT" .. END)
    print(HIGHEST_CRIT)
    print(HIGHEST_CRIT.DAMAGE or nil)
    print(HIGHEST_CRIT.TARGET_NAME or nil)
    print(HIGHEST_CRIT.SPELL_NAME or nil)
    print("----")
end

function HealTableTest()
    print("----")
    print("HIGHEST" .. GREENYELLOW .. " HEAL" .. END)
    print(HIGHEST_HEAL.DAMAGE or nil)
    print(HIGHEST_HEAL.TARGET_NAME or nil)
    print(HIGHEST_HEAL.SPELL_NAME or nil)
    print("----")
end

function DefTableTest()
    print("----")
    print("HIGHEST" .. ROYALBLUE .. " DEF" .. END)
    print(HIGHEST_DEF.DAMAGE or nil)
    print(HIGHEST_DEF.TARGET_NAME or nil)
    print(HIGHEST_DEF.SPELL_NAME or nil)
    print("----")
end

-- Função de teste para o evento CHAT_MSG_SPELL_SELF_DAMAGE
function TestChatMsgSpellSelfDamageEvent(damage)
    local event = 'CHAT_MSG_SPELL_SELF_DAMAGE'
    local arg1 = "Your Fireball crits EvilMonster for " .. damage .. "."

    -- Simule os parâmetros necessários para o evento
    local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for")
    local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

    local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "Your "), string.find(arg1, "crit")
    local spellName = string.sub(arg1, startSpellNameIndex + 5, endSpellNameIndex - 2)

    local startDamageIndex = string.find(arg1, "for %d+")
    local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
    if not endDamageIndex then
        endDamageIndex = string.find(arg1, "%.", startDamageIndex)
    end
    local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE AMOUNT

    if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
        PlaySound("crit")
        print(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
        SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
    end
end

function TestChatMsgSpellSelfBuffEvent(healing)
    local event = 'CHAT_MSG_SPELL_SELF_BUFF'
    local arg1 = "Your Healing Touch critically heals FriendlyPlayer for " .. healing .. "."

    -- Simule os parâmetros necessários para o evento
    if string.find(arg1, "critically") then

        local startNameIndex, endNameIndex = string.find(arg1, "heals "), string.find(arg1, "for") -- GET TARGET NAME
        local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

        local startIndex, endIndex = string.find(arg1, "Your "), string.find(arg1, "critically") -- GET SPELL NAME
        local spellName = string.sub(arg1, startIndex + 5, endIndex - 2)

        local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
        local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET THE DAMAGE AMOUNT 

        if next(HIGHEST_HEAL) == nil or critDamage > HIGHEST_HEAL.DAMAGE then
            PlaySound("heal")
            SetHihgestStat(HIGHEST_HEAL, critDamage, targetName, spellName)
            print(string.format(localization[LANGUAGE].healingSpellCrit, critDamage, spellName))
        end
    end
end

function TestCHAT_MSG_COMBAT_SELF_HITS(damage)
    local event = "CHAT_MSG_COMBAT_SELF_HITS"
    local arg1 = "You crits Defias Trapper for " .. damage .. "."
    if string.find(arg1, "crits") then

        local startNameIndex, endNameIndex = string.find(arg1, "crits "), string.find(arg1, "for") -- GET TARGET NAME
        local targetName = string.sub(arg1, startNameIndex + 6, endNameIndex - 1)

        local startIndex, endIndex = string.find(arg1, "You "), string.find(arg1, "crit") -- SPELL NAME AUTO ATTACK
        local spellName = localization[LANGUAGE].aa

        local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.")
        local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

        if next(HIGHEST_CRIT) == nil or critDamage > HIGHEST_CRIT.DAMAGE then
            PlaySound("crit")
            SetHihgestStat(HIGHEST_CRIT, critDamage, targetName, spellName)
            print(string.format(localization[LANGUAGE].autoAndSpellSCrit, critDamage, spellName))
        end
    end
end

function TestCHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS(took)
    local event = "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"
    local arg1 = "Defias Bandit crits you for " .. took .. "."

    local endNameIndex = string.find(arg1, "crit")
    if endNameIndex then
        local targetName = string.sub(arg1, 1, endNameIndex - 1) -- GET TARGET NAME

        local startIndex, endIndex = string.find(arg1, "crits "), string.find(arg1, "you ") -- GET THE SPELL AUTO ATTACK
        local spellName = localization[LANGUAGE].aa

        local startDamageIndex, endDamageIndex = string.find(arg1, "for "), string.find(arg1, "%.") -- GET DAMAGE AMOUNT
        local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex))

        if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
            PlaySound("def")
            SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
            print(string.format(localization[LANGUAGE].defAutoCrit, critDamage, spellName))
        end
    end
end

function TestCHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(took)
    local event = "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"
    local arg1 = "Defias Rogue Wizard's Frostbolt crits you for " .. took .. " Frost damage."

    local endNameIndex = string.find(arg1, "'s")
    if endNameIndex then

        local targetName = string.sub(arg1, 1, endNameIndex) -- GET TARGET NAME

        local startSpellNameIndex, endSpellNameIndex = string.find(arg1, "'s "), string.find(arg1, "crits") -- GET SPELL NAME
        local spellName = string.sub(arg1, startSpellNameIndex + 3, endSpellNameIndex - 2)

        local startDamageIndex = string.find(arg1, "for %d+")
        local _, endDamageIndex = string.find(arg1, "%d+", startDamageIndex)
        if not endDamageIndex then
            endDamageIndex = string.find(arg1, "%.", startDamageIndex)
        end
        local critDamage = tonumber(string.sub(arg1, startDamageIndex + 4, endDamageIndex)) -- GET DAMAGE

        if next(HIGHEST_DEF) == nil or critDamage > HIGHEST_DEF.DAMAGE then
            PlaySound("def")
            SetHihgestStat(HIGHEST_DEF, critDamage, targetName, spellName)
            print(string.format(localization[LANGUAGE].defSpellCrit, critDamage, spellName))
        end
    end
end

