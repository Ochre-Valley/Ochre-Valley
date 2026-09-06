/datum/customizer_entry/organ/belly
	var/belly_size = DEFAULT_BELLY_SIZE

/datum/customizer/organ/belly
	abstract_type = /datum/customizer/organ/belly
	name = "Belly"
	allows_disabling = FALSE
	default_disabled = FALSE

/datum/customizer/organ/belly/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/belly
	abstract_type = /datum/customizer_choice/organ/belly
	name = "Belly"
	customizer_entry_type = /datum/customizer_entry/organ/belly
	organ_type = /obj/item/organ/belly
	organ_slot = ORGAN_SLOT_BELLY
	organ_dna_type = /datum/organ_dna/belly
	tgui_template = "FeatureChoiceBelly"

/datum/customizer_choice/organ/belly/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	belly_entry.belly_size = sanitize_integer(belly_entry.belly_size, MIN_BELLY_SIZE, MAX_BELLY_SIZE, DEFAULT_BELLY_SIZE)

/datum/customizer_choice/organ/belly/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/belly/belly_dna = organ_dna
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	belly_dna.belly_size = belly_entry.belly_size

/datum/customizer_choice/organ/belly/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/belly/belly_entry = entry
	data["belly_size"] = find_key_by_value(BELLY_SIZES_BY_NAME, belly_entry.belly_size)

	return data

/datum/customizer_choice/organ/belly/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	switch(params["customizer_task"])
		if("belly_size")
			var/named_size = tgui_input_list(user, "Choose your belly size:", "Belly Size", BELLY_SIZES_BY_NAME, find_key_by_value(BELLY_SIZES_BY_NAME, belly_entry.belly_size))
			if(isnull(named_size))
				return TRUE
			var/new_size = BELLY_SIZES_BY_NAME[named_size]
			var/old_size = belly_entry.belly_size
			for(var/key in BELLY_SIZES_BY_NAME)
				if(BELLY_SIZES_BY_NAME[key] == old_size)
					old_size = key
					break
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" size", old_size, named_size)
			belly_entry.belly_size = new_size
			return TRUE

/datum/customizer/organ/belly/human
	customizer_choices = list(/datum/customizer_choice/organ/belly/human)

/datum/customizer_choice/organ/belly/human
	sprite_accessories = list(/datum/sprite_accessory/belly/plain)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/belly/animal
	customizer_choices = list(/datum/customizer_choice/organ/belly/animal)

/datum/customizer_choice/organ/belly/animal
	sprite_accessories = list(/datum/sprite_accessory/belly/plain)

//OV edit
/mob/living/carbon/verb/changebellysize()
	set name = "Change Asset Size"
	set category = "Vore.Misc"
	set desc = "Change the size of your belly or other assets"
	var/list/all_assets = list("Belly", "Breasts", "Butt", "Penis", "Testicles")
	var/option = tgui_input_list(src, "Which asset do you wish to resize?", "Asset Selection", all_assets)
	if(!option)
		return
	switch(option)
		if("Belly")
			change_belly_size_customizer(src)
		if("Breasts")
			change_breast_size_customizer(src)
		if("Butt")
			change_butt_size_customizer(src)
		if("Penis")
			change_penis_size_customizer(src)
		if("Testicles")
			change_testicle_size_customizer(src)

/mob/living/carbon/proc/change_belly_size_customizer(mob/living/carbon/user) // This could have been done better, but i'm too stupid and tired to get something out of it
	var/obj/item/organ/belly/_belly = getorganslot("belly")
	var/datum/preferences/prefs = user.client.prefs
	var/datum/customizer_entry/organ/belly/belly_entry = null
	if(!_belly)
		to_chat(user, "<span class='warning'>What belly?</span>")
		return
	if (!prefs)
		return

	for (var/datum/customizer_entry/entry in prefs.customizer_entries)
		if (istype(entry, /datum/customizer_entry/organ/belly))
			belly_entry = entry
			break

	var/named_size = input(user, "Choose your belly size:", "Belly", find_key_by_value(GLOB.named_belly_sizes, belly_entry.belly_size)) as anything in GLOB.named_belly_sizes

	if (isnull(named_size))
		return

	var/new_size = GLOB.named_belly_sizes[named_size]

	belly_entry.belly_size = sanitize_integer(new_size, MIN_BELLY_SIZE, MAX_BELLY_SIZE, DEFAULT_BELLY_SIZE)

	_belly.belly_size = belly_entry.belly_size
	user.regenerate_icons()
//OV edit end

/datum/customizer_entry/organ/butt
	var/butt_size = DEFAULT_BUTT_SIZE

/datum/customizer/organ/butt
	abstract_type = /datum/customizer/organ/butt
	name = "Butt"
	allows_disabling = FALSE
	default_disabled = FALSE

/datum/customizer_choice/organ/butt
	abstract_type = /datum/customizer_choice/organ/butt
	name = "Butt"
	customizer_entry_type = /datum/customizer_entry/organ/butt
	organ_type = /obj/item/organ/butt
	organ_slot = ORGAN_SLOT_BUTT
	organ_dna_type = /datum/organ_dna/butt
	tgui_template = "FeatureChoiceButt"

/datum/customizer_choice/organ/butt/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/butt/butt_entry = entry
	butt_entry.butt_size = sanitize_integer(butt_entry.butt_size, MIN_BUTT_SIZE, MAX_BUTT_SIZE, DEFAULT_BUTT_SIZE)

/datum/customizer_choice/organ/butt/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/butt/butt_dna = organ_dna
	var/datum/customizer_entry/organ/butt/butt_entry = entry
	butt_dna.butt_size = butt_entry.butt_size

/datum/customizer_choice/organ/butt/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/butt/butt_entry = entry
	data["butt_size"] = find_key_by_value(BUTT_SIZES_BY_NAME, butt_entry.butt_size)

	return data

/datum/customizer_choice/organ/butt/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/butt/butt_entry = entry
	switch(params["customizer_task"])
		if("butt_size")
			var/named_size = tgui_input_list(user, "Choose your butt size:", "Butt Size", BUTT_SIZES_BY_NAME, find_key_by_value(BUTT_SIZES_BY_NAME, butt_entry.butt_size))
			if(isnull(named_size))
				return TRUE
			var/new_size = BUTT_SIZES_BY_NAME[named_size]
			var/old_size = butt_entry.butt_size
			for(var/key in BUTT_SIZES_BY_NAME)
				if(BUTT_SIZES_BY_NAME[key] == old_size)
					old_size = key
					break
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" size", old_size, named_size)
			butt_entry.butt_size = new_size
			return TRUE

/datum/customizer/organ/butt/human
	customizer_choices = list(/datum/customizer_choice/organ/butt/human)

/datum/customizer_choice/organ/butt/human
	sprite_accessories = list(/datum/sprite_accessory/butt/pair)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/butt/animal
	customizer_choices = list(/datum/customizer_choice/organ/butt/animal)

/datum/customizer_choice/organ/butt/animal
	sprite_accessories = list(/datum/sprite_accessory/butt/pair)

//OV edit
/mob/living/carbon/proc/change_butt_size_customizer(mob/living/carbon/user) // This could have been done better, but i'm too stupid and tired to get something out of it
	var/obj/item/organ/butt/_butt = getorganslot("butt")
	var/datum/preferences/prefs = user.client.prefs
	var/datum/customizer_entry/organ/butt/butt_entry = null
	if(!_butt)
		to_chat(user, "<span class='warning'>What butt?</span>")
		return
	if (!prefs)
		return

	for (var/datum/customizer_entry/entry in prefs.customizer_entries)
		if (istype(entry, /datum/customizer_entry/organ/butt))
			butt_entry = entry
			break

	var/named_size = input(user, "Choose your butt size:", "Butt", find_key_by_value(GLOB.named_butt_sizes, butt_entry.butt_size)) as anything in GLOB.named_butt_sizes

	if (isnull(named_size))
		return

	var/new_size = GLOB.named_butt_sizes[named_size]

	butt_entry.butt_size = sanitize_integer(new_size, MIN_BUTT_SIZE, MAX_BUTT_SIZE, DEFAULT_BUTT_SIZE)

	_butt.butt_size = butt_entry.butt_size
	user.regenerate_icons()
//OV edit end
