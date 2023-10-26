-- function TestSetHihgestStat()
--     SetHihgestStat(HIGHEST_CRIT, 1000, "AnDrE ", "Test Spell")
--     SetHihgestStat(HIGHEST_HEAL, 1000, "AnDrE ", "Test Spell")
--     SetHihgestStat(HIGHEST_DEF, 1000, "AnDrE ", "Test Spell")

--     if HIGHEST_CRIT.DAMAGE == 1000 and HIGHEST_CRIT.TARGET_NAME == "AnDrE " and HIGHEST_CRIT.SPELL_NAME == "Test Spell" then
--         print("TestSetHihgestCrit: Teste bem-sucedido")
--     else
--         print("TestSetHihgestCrit: Teste falhou")
--     end

--     if HIGHEST_HEAL.DAMAGE == 1000 and HIGHEST_HEAL.TARGET_NAME == "AnDrE " and HIGHEST_HEAL.SPELL_NAME == "Test Spell" then
--         print("TestSetHihgestHeal: Teste bem-sucedido")
--     else
--         print("TestSetHihgestHeal: Teste falhou")
--     end

--     if HIGHEST_DEF.DAMAGE == 1000 and HIGHEST_DEF.TARGET_NAME == "AnDrE " and HIGHEST_DEF.SPELL_NAME == "Test Spell" then
--         print("TestSetHihgesDef: Teste bem-sucedido")
--     else
--         print("TestSetHihgesDef: Teste falhou")
--     end
-- end

function CritTableTest()
    print("----")
    print("HIGHEST" .. ORANGERED .. " CRIT" .. END)
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

    
