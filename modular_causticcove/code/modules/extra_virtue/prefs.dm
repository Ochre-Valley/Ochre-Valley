/datum/preferences
	var/datum/virtue/extravirtue = new /datum/virtue/none

/datum/preferences/proc/load_extra_virtue(S)
	var/extravirtue_type
	S["extravirtue"] >> extravirtue_type
	var/error_check = FALSE
	var/error_found = FALSE
	if(istype(extravirtue_type, /datum/virtue))
		extravirtue = extravirtue_type
		error_check = TRUE
	else if(ispath(extravirtue_type, /datum/virtue))
		extravirtue = new extravirtue_type
	else
		extravirtue = new /datum/virtue/none

	if(error_check)
		//Future-proofing sanity checks in case virtues get adjusted later. We do a full reset if we find any discrepancies.
		var/datum/virtue/sane_extravirtue = new extravirtue.type
		error_found = FALSE

		if(extravirtue.name != sane_extravirtue.name)	//We should keep the names & descs updated across saves, too
			virtue.name = sane_extravirtue.name

		if(extravirtue.desc != sane_extravirtue.desc)	//Not errors warranting a full reset, in theory, anyway.
			extravirtue.desc = sane_extravirtue.desc


		if(length(extravirtue.picked_choices) > sane_extravirtue.max_choices)
			error_found = TRUE
		
		if(sane_extravirtue.max_choices != extravirtue.max_choices)
			error_found = TRUE
		
		if(length(extravirtue.extra_choices) != length(sane_extravirtue.extra_choices))
			error_found = TRUE
		
		if(!error_found)
			for(var/choice in extravirtue.extra_choices)
				if(!(choice in sane_extravirtue.extra_choices))
					error_found = TRUE
					break

			var/total_ours = 0
			var/total_sane = 0

			for(var/cost in extravirtue.choice_costs)
				total_ours += cost
			for(var/cost in sane_extravirtue.choice_costs)
				total_sane += cost
				
			if(total_ours != total_sane)
				error_found = TRUE

		if(error_found)
			extravirtue = sane_extravirtue
			qdel(virtue)
		else
			qdel(sane_extravirtue)
			extravirtue.on_load()

/datum/preferences/proc/save_extra_virtue(S)
	WRITE_FILE(S["extravirtue"], extravirtue)

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
		if(!istype(virtue, /datum/virtue/combat/rotcured) && !istype(virtuetwo, /datum/virtue/combat/rotcured) && !istype(extravirtue, /datum/virtue/combat/rotcured)) //OV Edit - Rotcured Color Catch for Extra Virtue
			if(skin_tone == SKIN_COLOR_ROT)
				var/new_tone = random_skin_tone()
				skin_tone = new_tone
				features["mcolor"] = sanitize_hexcolor(new_tone)
				try_update_mutant_colors()
