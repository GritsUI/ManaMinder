ManaMinder.defaults = {
  profile = {

  },
  char = {
    mainFrame = {
      position = {
        x = 0,
        y = 0
      },
      width = 200,
      hidden = false,
      hiddenOutOfCombat = false,
      hiddenSolo = false,
      hiddenGroup = false,
      hiddenRaid = false,
      locked = false
    },
    bars = {
      height = 24,
      margin = 2,
      backgroundColor = { 0, 0, 0, 0.2 },
      cooldownColor = { 0.7, 0.7, 0.7 },
      cooldownFontColor = { 1, 1, 1 },
      cooldownAlpha = 0.7,
      cooldownText = "%cooldown%",
      deficitColor = { 0.7, 0.1, 0.1 },
      deficitFontColor = { 1, 1, 1 },
      deficitAlpha = 0.7,
      deficitText = "+%deficit%",
      readyColor = { 0.2, 0.7, 0.2 },
      readyFontColor = { 1, 1, 1 },
      readyAlpha = 1,
      readyText = "Ready",
      fontSize = 11,
      iconFontSize = 10,
      iconFontColor = { 1, 1, 1 },
      animationDuration = 0.3,
      texture = "Smooth"
    },
    alertFrame = {
      enabled = true,
      position = {
        x = 0,
        y = 250
      },
      size = 50,
      fontSize = 20,
      animationDuration = 0.3,
      text = "%name% is Ready",
      duration = 5,
      soundEnabled = true,
      soundType = "Bell",
    },
    consumables = {
      {
        key = "MAJOR_MANA_POTION",
        priority = 1,
        type = "ITEM"
      }, {
        key = "DEMONIC_RUNE",
        priority = 2,
        type = "ITEM"
      }, {
        key = "DARK_RUNE",
        priority = 3,
        type = "ITEM"
      }
    },
    combinePotions = true,
    combineRunes = true,
    combineGems = true
  }
}
