/datum/preferences/ui_data_character_creator_villain(mob/user)
	var/list/data = ..()

	data += list(
		"werewolf_headshot_link" = werewolf_headshot_link,
		"werewolf_setname" = werewolf_setname,
		"werewolf_setdesc" = werewolf_setdesc,
	)

	return data
