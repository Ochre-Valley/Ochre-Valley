
/datum/asset/spritesheet/pref_badges
	name = "pref_badges"

/datum/asset/spritesheet/pref_badges/create_spritesheets() // preserving save data
	var/icon/badges = icon('modular_ochrevalley/icons/pref_icons.dmi')
	InsertAll("", badges)
