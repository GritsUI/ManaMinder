local spells = {
  ["MANA_TIDE_TOTEM"] = {
    name = "Mana Tide Totem",
    key = "MANA_TIDE_TOTEM",
    spellId = 17359,
    iconTexture = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
    requiredDeficit = 1000,
    type = "SPELL",
    class = "Shaman"
  },
  ["EVOCATION"] = {
    name = "Evocation",
    key = "EVOCATION",
    spellId = 12051,
    iconTexture = "Interface\\Icons\\Spell_Nature_Purge",
    requiredDeficit = 4000,
    type = "SPELL",
    class = "Mage"
  }
}

ManaMinder.spells = spells
