ManaMinder.defaults = {
    profile = {
        mainFrame = {
            position = {
                x = 0,
                y = 0
            },
            width = 200
        },
        bars = {
            height = 25,
            alpha = 1,
            margin = 3,
            backgroundColor = { 0, 0, 0, 0.2 },
            cooldownColor = { 0.7, 0.7, 0.7, 0.7 },
            deficitColor = { 0.7, 0.1, 0.1, 0.7 },
            readyColor = { 0.2, 0.7, 0.2, 0.7 },
            fontSize = 11,
            fontColor = { 1, 1, 1, 1 },
            iconFontSize = 10,
            iconFontColor = { 1, 1, 1, 1 }
        },
        consumables = {
            {
                key = "MAJOR_MANA_POTION",
                priority = 1,
                enabled = true
            },
            {
                key = "DEMONIC_RUNE",
                priority = 2,
                enabled = true
            }
        }
    }
}
