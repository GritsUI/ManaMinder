local sounds = {
  ["Bell"] = {
    name = "Bell",
    path = "Sound\\Doodad\\BellTollNightElf.wav",
    type = "FILE"
  },
  ["Raid Warning"] = {
    name = "Raid Warning",
    path = "RaidWarning",
    type = "STANDARD"
  }
}

local soundsList = {
  sounds["Bell"],
  sounds["Raid Warning"]
}

ManaMinder.sounds = sounds
ManaMinder.soundsList = soundsList
