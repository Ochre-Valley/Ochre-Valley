/datum/preferences/should_hide_pq_for(mob/user)
	return hide_pq

/datum/preferences/handle_title_pref_selection(mob/user)
	var/old = titles_pref
	var/titles_input = tgui_input_list(user, "Choose your character's titles", "TITLES", GLOB.titles_list)
	if(titles_input)
		titles_pref = titles_input
	verbose_pref_log_change(user, "notice", "Titles", old, titles_pref)

/datum/job/constant_ui_data()
	var/list/data = ..()
	data["titles"][TITLES_N] = n_title || display_title || title
	return data

/datum/preferences/get_all_virtues()
	var/list/data = ..()
	data += extravirtue
	return data

/datum/preferences/set_virtue_by_index(index, datum/virtue/new_virtue)
	if(index == 3)
		QDEL_NULL(extravirtue)
		extravirtue = new_virtue
		return TRUE
	return ..()

/datum/preferences/get_virtue_slot_names()
	var/list/data = ..()
	data += "Extra Virtue"
	return data
