local playerClass = UnitClass("player")

local consumables = {
    ["MINOR_MANA_POTION"] = {
        name = "Minor Mana Potion",
        itemId = 2455,
        iconTexture = "Interface\Icons\INV_Potion_70",
        cooldown = 120,
        maxMana = 181
    },
    ["LESSER_MANA_POTION"] = {
        name = "Lesser Mana Potion",
        itemId = 3385,
        iconTexture = "Interface\Icons\INV_Potion_71",
        cooldown = 120,
        maxMana = 361
    },
    ["MANA_POTION"] = {
        name = "Mana Potion",
        itemId = 3827,
        iconTexture = "Interface\Icons\INV_Potion_72",
        cooldown = 120,
        maxMana = 586
    },
    ["GREATER_MANA_POTION"] = {
        name = "Greater Mana Potion",
        itemId = 6149,
        iconTexture = "Interface\Icons\INV_Potion_73",
        cooldown = 120,
        maxMana = 901
    },
    ["SUPERIOR_MANA_POTION"] = {
        name = "Superior Mana Potion",
        itemId = 13443,
        iconTexture = "Interface\Icons\INV_Potion_74",
        cooldown = 120,
        maxMana = 1501
    },
    ["MAJOR_MANA_POTION"] = {
        name = "Major Mana Potion",
        itemId = 13444,
        iconTexture = "Interface\Icons\INV_Potion_76",
        cooldown = 120,
        maxMana = 2250
    },
    ["MAJOR_REJUVENATION_POTION"] = {
        name = "Major Rejuvenation Potion",
        itemId = 18253,
        iconTexture = "Interface\Icons\INV_Potion_47",
        cooldown = 120,
        maxMana = 1761
    },
    ["DEMONIC_RUNE"] = {
        name = "Demonic Rune",
        itemId = 12662,
        iconTexture = "Interface\Icons\INV_Misc_Rune_04",
        cooldown = 120,
        maxMana = 1500
    },
    ["DARK_RUNE"] = {
        name = "Dark Rune",
        itemId = 20520,
        iconTexture = "Interface\Icons\Spell_Shadow_SealOfKings",
        cooldown = 120,
        maxMana = 1500
    },
    ["LILY_ROOT"] = {
        name = "Lily Root",
        itemId = 14894,
        iconTexture = "Interface\Icons\INV_Misc_Herb_02",
        cooldown = 120,
        maxMana = 676
    }
}

if playerClass == "Mage" then
    consumables["MANA_AGATE"] = {
        name = "Mana Agate",
        itemId = 5514,
        iconTexture = "Interface\Icons\INV_Misc_Gem_Emerald_01",
        cooldown = 0,
        maxMana = 426
    }
    consumables["MANA_JADE"] = {
        name = "Mana Jade",
        itemId = 5513,
        iconTexture = "Interface\Icons\INV_Misc_Gem_Emerald_02",
        cooldown = 0,
        maxMana = 651
    }
    consumables["MANA_CITRINE"] = {
        name = "Mana Citrine",
        itemId = 8007,
        iconTexture = "Interface\Icons\INV_Misc_Gem_Opal_01",
        cooldown = 0,
        maxMana = 926
    }
    consumables["MANA_RUBY"] = {
        name = "Mana Ruby",
        itemId = 8008,
        iconTexture = "Interface\Icons\INV_Misc_Gem_Ruby_01",
        cooldown = 0,
        maxMana = 1201
    }
end

ManaMinder.consumables = consumables
