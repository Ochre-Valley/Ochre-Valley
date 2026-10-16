/datum/preferences/ui_data_character_creator_identity(mob/user)
	var/list/data = ..()

	data += list(
		"show_in_directory" = show_in_directory,
		"directory_tag" = directory_tag,
		"directory_erptag" = directory_erptag,
		"directory_gendertag" = directory_gendertag,
		"directory_sexualitytag" = directory_sexualitytag,
	)

	data += list(
		"directory_pvp" = directory_pvp,
		"badge_gng" = badge_gng,
		"badge_vore" = badge_vore,
		"badge_willing" = badge_willing,
		"badge_sexuality" = badge_sexuality,
		"badge_erp" = badge_erp,
		"badge_lean" = badge_lean,
		"badge_type" = badge_type,
	)
	return data
