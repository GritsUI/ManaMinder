local playerClass = UnitClass("player")

local spells = {}

if playerClass == "Shaman" then
    spells["MANA_TIDE_TOTEM"] = {
        name = "Mana Tide Totem",
        spellId = 17359,
        iconTexture = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
        cooldown = 300,
        requiredDeficit = 1000
    }
end

ManaMinder.spells = spells
