/datum/preferences
	var/datum/virtue/extravirtue = new /datum/virtue/none

/datum/preferences/proc/load_extra_virtue(S)
	var/extravirtue_type
	S["extravirtue"] >> extravirtue_type
	var/list/extravirtue_choices = list()
	var/virtextra
	S["extravirtuechoices"] >> virtextra
	extravirtue_choices = virtextra

	if(istype(extravirtue_type, /datum/virtue))
		var/datum/virtue/V = extravirtue_type
		extravirtue = new V.type
		if(length(V.picked_choices))
			extravirtue.picked_choices = V.picked_choices
		qdel(V)
	else if(ispath(extravirtue_type, /datum/virtue))
		extravirtue = new extravirtue_type
	else
		extravirtue = new /datum/virtue/none

	if(length(extravirtue_choices))
		extravirtue.picked_choices = extravirtue_choices.Copy()

	extravirtue.on_load()

/datum/preferences/proc/save_extra_virtue(S)
	WRITE_FILE(S["extravirtue"], extravirtue.type)
	WRITE_FILE(S["extravirtuechoices"] , extravirtue.picked_choices)

/datum/preferences/proc/get_extra_virtue_htmlpick()
	return "<b>Extra Virtue:</b> <a href='?_src_=prefs;preference=extravirtue;task=input'>[extravirtue]</a><BR>"

/datum/preferences/proc/get_extra_virtue_input(mob/user)
	var/list/virtue_choices = list()
	for (var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		if (!V.name)
			continue
		if ((V.name == virtue.name || V.name == virtuetwo.name || V.name == extravirtue.name) && !istype(V, /datum/virtue/none))
			if(!V.stackable)
				continue
		if (istype(V, /datum/virtue/origin))
			continue
		if (V.unlisted)
			continue
		if (istype(V, /datum/virtue/heretic) && !istype(selected_patron, /datum/patron/inhumen))
			continue
		if (V.restricted == TRUE)
			if((pref_species.type in V.races))
				continue
		virtue_choices[V.name] = V
	virtue_choices = sort_list(virtue_choices)
	var/result = tgui_input_list(user, "What strength shall you wield?", "VIRTUES",virtue_choices)

	if (result)
		var/datum/virtue/virtue_chosen = virtue_choices[result]
		extravirtue = new virtue_chosen.type
		to_chat(user, process_virtue_text(virtue_chosen))
		if(!istype(virtue, /datum/virtue/combat/second_chance) && !istype(virtuetwo, /datum/virtue/combat/second_chance) && !istype(extravirtue, /datum/virtue/combat/second_chance)) //OV Edit - Second Chance Color Catch for Extra Virtue
			if(skin_tone == SKIN_COLOR_ROT)
				var/new_tone = random_skin_tone()
				skin_tone = new_tone
				features["mcolor"] = sanitize_hexcolor(new_tone)
				try_update_mutant_colors()
