ManaMinder.defaults = {
    profile = {
        mainFrame = {
            position = {
                x = 0,
                y = 0
            },
            width = 200,
            scale = 1,
            alpha = 1,
            hidden = false,
            hiddenOutOfCombat = false,
            locked = false
        },
        bars = {
            height = 24,
            margin = 3,
            backgroundColor = { 0, 0, 0, 0.2 },
            cooldownColor = { 0.7, 0.7, 0.7, 0.7 },
            deficitColor = { 0.7, 0.1, 0.1, 0.7 },
            readyColor = { 0.2, 0.7, 0.2, 0.7 },
            fontSize = 11,
            fontColor = { 1, 1, 1, 1 },
            iconFontSize = 10,
            iconFontColor = { 1, 1, 1, 1 },
            animationDuration = 0.3
        },
        consumables = {
            {
                key = "MAJOR_MANA_POTION",
                priority = 1,
                type = "ITEM"
            }, {
                key = "MANA_TIDE_TOTEM",
                priority = 2,
                type = "SPELL"
            }, {
                key = "DEMONIC_RUNE",
                priority = 3,
                type = "ITEM"
            }
        }
    }
}
