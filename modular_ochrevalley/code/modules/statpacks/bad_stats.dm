//I want to nerf myself but I don't want to nerf EVERYTHING. These stat packs mostly nerf you but you do get a little pay off with an extra virtue (still objectively worse than the virtuous statpack).

/datum/statpack/wildcard/weakling
	name = "Weakling"
	desc = "Your body is physically weak, you struggle to carry heavy objects and weild weapons. Even modest hits against your body can lead to major injury."
	stat_array = list(STAT_STRENGTH = -4, STAT_CONSTITUTION = -4, STAT_FORTUNE = 1)
	virtuous = TRUE

/datum/statpack/wildcard/imbecile
	name = "Imbecile"
	desc = "You are mentally weak, you struggle to focus and wrap your mind around complex problems. You struggle to complete simple tasks and get exhausted very quickly."
	stat_array = list(STAT_INTELLIGENCE = -4, STAT_WILLPOWER = -4, STAT_FORTUNE = 1)
	virtuous = TRUE

/datum/statpack/wildcard/laggard
	name = "Laggard"
	desc = "You are physically slow, your hands and body quivers. Moving is difficult for you, making it hard to dodge and react, but you also struggle with hitting where you intend to."
	stat_array = list(STAT_SPEED = -4, STAT_PERCEPTION = -4, STAT_FORTUNE = 1)
	virtuous = TRUE
