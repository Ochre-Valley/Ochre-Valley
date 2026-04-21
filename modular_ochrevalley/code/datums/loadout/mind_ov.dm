//OV FILE

/datum/mind
	var/show_in_directory
	var/directory_tag
	var/directory_erptag
	var/directory_gendertag
	var/directory_sexualitytag
	var/directory_pvp //OV ADD
	var/directory_ad

/mob/living/mind_initialize()
	. = ..()
	if (client?.prefs)
		mind.show_in_directory = client.prefs.show_in_directory
		mind.directory_tag = client.prefs.directory_tag
		mind.directory_erptag = client.prefs.directory_erptag
		mind.directory_ad = client.prefs.directory_ad
		mind.directory_gendertag = client.prefs.directory_gendertag
		mind.directory_sexualitytag = client.prefs.directory_sexualitytag
		mind.directory_pvp = client.prefs.directory_pvp
		if(ishuman(src))
			set_character_ad_value(src, client.prefs, mind, client.prefs.directory_ad)
