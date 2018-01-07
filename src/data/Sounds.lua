local sounds = {
  ["Alright"] = {
    name = "Alright",
    path = "Sound\\Creature\\Peasant\\PeasantYes3.wav",
    type = "FILE"
  },
  ["Bell"] = {
    name = "Bell",
    path = "Sound\\Doodad\\BellTollNightElf.wav",
    type = "FILE"
  },
  ["Fireworks"] = {
    name = "Fireworks",
    path = "Sound\\Doodad\\G_FireworkBoomGeneral3.wav",
    type = "FILE"
  },
  ["Gong"] = {
    name = "Gong",
    path = "Sound\\Doodad\\G_GongTroll01.wav",
    type = "FILE"
  },
  ["Map Ping"] = {
    name = "Map Ping",
    path = "MapPing",
    type = "STANDARD"
  },
  ["Okie Dokie"] = {
    name = "Okie Dokie",
    path = "Sound\\Creature\\Peon\\PeonYes4.wav",
    type = "FILE"
  },
  ["Raid Warning"] = {
    name = "Raid Warning",
    path = "RaidWarning",
    type = "STANDARD"
  },
  ["Righto"] = {
    name = "Righto",
    path = "Sound\\Creature\\Peasant\\PeasantYes1.wav",
    type = "FILE"
  },
  ["Whip"] = {
    name = "Whip",
    path = "Sound\\Item\\Weapons\\Whip\\BullWhipHit3.wav",
    type = "FILE"
  },
  ["Wisp"] = {
    name = "Wisp",
    path = "Sound\\Event Sounds\\Wisp\\WispReady1.wav",
    type = "FILE"
  },
  ["Yarrrr"] = {
    name = "Yarrrr",
    path = "Sound\\Spells\\YarrrrImpact.wav",
    type = "FILE"
  }
}

local soundsList = {
  sounds["Alright"],
  sounds["Bell"],
  sounds["Fireworks"],
  sounds["Gong"],
  sounds["Map Ping"],
  sounds["Okie Dokie"],
  sounds["Raid Warning"],
  sounds["Righto"],
  sounds["Whip"],
  sounds["Wisp"],
  sounds["Yarrrr"]
}

ManaMinder.sounds = sounds
ManaMinder.soundsList = soundsList
