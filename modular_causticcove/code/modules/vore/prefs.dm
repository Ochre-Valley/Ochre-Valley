/datum/preferences
	var/show_in_directory = 1	//Show in Character Directory
	var/directory_tag = "Unset" //Sorting tag to use in character directory
	var/directory_erptag = "Unset"	//ditto, but for non-vore scenes
	var/directory_gendertag = "Unset" // Gender stuff!
	var/directory_sexualitytag = "Unset" // Sexuality!
	var/directory_ad = ""		//Advertisement stuff to show in character directory.
	var/directory_pvp = "Unset" //OV ADD

	var/vore_health_bars = TRUE //It seems like these were swapped for the toggles below some time ago
	var/digestion_noises = TRUE
	var/eating_noises = TRUE
	var/belch_noises = TRUE
	///If they are currently in the process of swapping slots, don't let them open 999 windows for it and get confused
	//var/selecting_slots = FALSE //Was only used in one place to load belly info, in living_vr.dm

// Vorey sounds
/*/datum/preference/toggle/belch_noises // Belching noises - pref toggle for 'em
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "BELCH_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/eating_noises
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "EATING_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/digestion_noises
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "DIGEST_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/vore_health_bars
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "VORE_HEALTH_BARS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER*/
