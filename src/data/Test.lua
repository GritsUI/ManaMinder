local majorManaPotion = ManaMinder.consumables['MAJOR_MANA_POTION']
local demonicRune = ManaMinder.consumables['DEMONIC_RUNE']
local marlisEye = ManaMinder.items['MARLIS_EYE']
local manaTide = ManaMinder.spells['MANA_TIDE_TOTEM']

local testBarData = {
  {
    key = majorManaPotion.key,
    group = majorManaPotion.group,
    priority = 1,
    count = 8,
    cooldown = 0,
    cooldownStart = 0,
    cooldownRemaining = 0,
    requiredDeficit = 0,
    deficitRemaining = 0,
    texture = majorManaPotion.iconTexture,
    type = "ITEM",
    bag = 1,
    slot = 1
  }, {
    key = demonicRune.key,
    group = demonicRune.group,
    priority = 2,
    count = 14,
    cooldown = 0,
    cooldownStart = 0,
    cooldownRemaining = 0,
    requiredDeficit = 0,
    deficitRemaining = 500,
    texture = demonicRune.iconTexture,
    type = "ITEM",
    bag = 1,
    slot = 1
  }, {
    key = marlisEye.key,
    group = marlisEye.group,
    priority = 3,
    cooldown = 120,
    cooldownStart = 0,
    cooldownRemaining = 32,
    requiredDeficit = 0,
    deficitRemaining = 0,
    texture = marlisEye.iconTexture,
    type = "EQUIPPED",
    slot = 1
  }, {
    key = manaTide.key,
    group = manaTide.group,
    priority = 4,
    cooldown = 120,
    cooldownStart = 0,
    cooldownRemaining = 97,
    requiredDeficit = 0,
    deficitRemaining = 0,
    texture = manaTide.iconTexture,
    type = "SPELL",
    spellId = 1
  }
}

ManaMinder.testBarData = testBarData
