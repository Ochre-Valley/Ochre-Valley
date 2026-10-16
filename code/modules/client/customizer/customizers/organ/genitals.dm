/datum/customizer/organ/penis
	abstract_type = /datum/customizer/organ/penis
	name = "Penis"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = MALE

/datum/customizer/organ/penis/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/penis
	abstract_type = /datum/customizer_choice/organ/penis
	name = "Penis"
	organ_type = /obj/item/organ/penis
	organ_slot = ORGAN_SLOT_PENIS
	organ_dna_type = /datum/organ_dna/penis
	customizer_entry_type = /datum/customizer_entry/organ/penis
	tgui_template = "FeatureChoicePenis"

/datum/customizer_choice/organ/penis/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/penis/penis_entry = entry
	penis_entry.penis_size = sanitize_integer(penis_entry.penis_size, MIN_PENIS_SIZE, MAX_PENIS_SIZE, DEFAULT_PENIS_SIZE)
	if(!(penis_entry.sheath_type in list(SHEATH_TYPE_NONE, SHEATH_TYPE_NORMAL, SHEATH_TYPE_SLIT)))
		penis_entry.sheath_type = SHEATH_TYPE_NONE

/datum/customizer_choice/organ/penis/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/penis/penis_dna = organ_dna
	var/datum/customizer_entry/organ/penis/penis_entry = entry
	penis_dna.penis_size = penis_entry.penis_size
	penis_dna.functional = penis_entry.functional
	penis_dna.sheath_type = penis_entry.sheath_type

/datum/customizer_choice/organ/penis/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/penis/penis_entry = entry
	data["penis_size"] = find_key_by_value(PENIS_SIZES_BY_NAME, penis_entry.penis_size)
	data["penis_functional"] = penis_entry.functional
	data["sheath_type"] = find_key_by_value(SHEATH_TYPES_BY_NAME, penis_entry.sheath_type)

	return data

/datum/customizer_choice/organ/penis/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/penis/penis_entry = entry
	switch(params["customizer_task"])
		if("penis_size")
			var/named_size = tgui_input_list(user, "Choose your penis size:", "Character Preference", PENIS_SIZES_BY_NAME, find_key_by_value(PENIS_SIZES_BY_NAME, penis_entry.penis_size))
			if(isnull(named_size))
				return TRUE
			var/new_size = PENIS_SIZES_BY_NAME[named_size]
			var/old_size = penis_entry.penis_size
			for(var/key in PENIS_SIZES_BY_NAME)
				if(PENIS_SIZES_BY_NAME[key] == old_size)
					old_size = key
					break
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" size", old_size, named_size)
			penis_entry.penis_size = new_size
			return TRUE
		if("functional")
			penis_entry.functional = !penis_entry.functional
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" functionality", !penis_entry.functional ? "Functional" : "Not Functional", penis_entry.functional ? "Functional" : "Not Functional")
			return TRUE
		if("sheath_type")
			var/named_sheath = tgui_input_list(user, "Choose your sheath type:", "Character Preference", SHEATH_TYPES_BY_NAME, find_key_by_value(SHEATH_TYPES_BY_NAME, penis_entry.sheath_type))
			if(isnull(named_sheath))
				return TRUE
			var/new_sheath = SHEATH_TYPES_BY_NAME[named_sheath]
			var/old_sheath = find_key_by_value(SHEATH_TYPES_BY_NAME, penis_entry.sheath_type)
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" sheath", old_sheath, named_sheath)
			penis_entry.sheath_type = new_sheath
			return TRUE

/datum/customizer_entry/organ/penis
	var/penis_size = DEFAULT_PENIS_SIZE
	var/functional = TRUE
	var/sheath_type = SHEATH_TYPE_NONE

/datum/customizer/organ/penis/human
	customizer_choices = list(/datum/customizer_choice/organ/penis/human)

/datum/customizer/organ/penis/anthro
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/human_anthro,
		/datum/customizer_choice/organ/penis/knotted,
		/datum/customizer_choice/organ/penis/equine,
		/datum/customizer_choice/organ/penis/tapered_mammal,
		/datum/customizer_choice/organ/penis/tapered,
		/datum/customizer_choice/organ/penis/tapered_double,
		/datum/customizer_choice/organ/penis/tapered_double_knot,
		/datum/customizer_choice/organ/penis/barbed,
		/datum/customizer_choice/organ/penis/barbed_knotted,
		/datum/customizer_choice/organ/penis/tentacle,
		)

/datum/customizer/organ/penis/canine
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/human_anthro,
		/datum/customizer_choice/organ/penis/knotted,
		)

/datum/customizer/organ/penis/feline
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/human_anthro,
		/datum/customizer_choice/organ/penis/barbed,
		/datum/customizer_choice/organ/penis/barbed_knotted,
		)

/datum/customizer/organ/penis/lizard
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/human_anthro,
		/datum/customizer_choice/organ/penis/tapered,
		/datum/customizer_choice/organ/penis/tapered_double,
		/datum/customizer_choice/organ/penis/tapered_double_knot,
		)

/datum/customizer/organ/penis/equine
	customizer_choices = list(
		/datum/customizer_choice/organ/penis/human_anthro,
		/datum/customizer_choice/organ/penis/equine,
		)

/datum/customizer_choice/organ/penis/human
	name = "Plain Penis"
	organ_type = /obj/item/organ/penis
	sprite_accessories = list(
		/datum/sprite_accessory/penis/human,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/human,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)
	allows_accessory_color_customization = FALSE

/datum/customizer_choice/organ/penis/human_anthro
	name = "Plain Penis"
	organ_type = /obj/item/organ/penis
	sprite_accessories = list(
		/datum/sprite_accessory/penis/human,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/human,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)
	allows_accessory_color_customization = TRUE

/datum/customizer_choice/organ/penis/knotted
	name = "Knotted Penis"
	organ_type = /obj/item/organ/penis/knotted
	sprite_accessories = list(
		/datum/sprite_accessory/penis/knotted,
		/datum/sprite_accessory/penis/knotted2,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/knotted,
		/datum/sprite_accessory/penis/hyper/knotted2,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/equine
	name = "Equine Penis"
	organ_type = /obj/item/organ/penis/equine
	sprite_accessories = list(
		/datum/sprite_accessory/penis/flared,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/flared,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/tapered_mammal
	name = "Tapered Penis (Mammal)"
	organ_type = /obj/item/organ/penis/tapered_mammal
	sprite_accessories = list(
		/datum/sprite_accessory/penis/tapered_mammal,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/tapered_mammal,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/tapered
	name = "Tapered Penis"
	organ_type = /obj/item/organ/penis/tapered
	sprite_accessories = list(
		/datum/sprite_accessory/penis/tapered,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/tapered,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/tapered_double
	name = "Hemi Tapered Penis"
	organ_type = /obj/item/organ/penis/tapered_double
	sprite_accessories = list(
		/datum/sprite_accessory/penis/hemi,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/hemi,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/tapered_double_knot
	name = "Knotted Hemi Tapered Penis"
	organ_type = /obj/item/organ/penis/tapered_double_knotted
	sprite_accessories = list(
		/datum/sprite_accessory/penis/hemiknot,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/hemiknot,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/barbed
	name = "Barbed Penis"
	organ_type = /obj/item/organ/penis/barbed
	sprite_accessories = list(
		/datum/sprite_accessory/penis/barbknot,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/barbknot,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/barbed_knotted
	name = "Barbed Knotted Penis"
	organ_type = /obj/item/organ/penis/barbed_knotted
	sprite_accessories = list(
		/datum/sprite_accessory/penis/barbknot,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/barbknot,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

/datum/customizer_choice/organ/penis/tentacle
	name = "Tentacle Penis"
	organ_type = /obj/item/organ/penis/tentacle
	sprite_accessories = list(
		/datum/sprite_accessory/penis/tentacle,
		//OV ADD START
		/datum/sprite_accessory/penis/hyper/tentacle,
		/datum/sprite_accessory/penis/hyper/nondescript,
		//OV ADD END
		)

//OV edit
/mob/living/carbon/proc/change_penis_size_customizer(mob/living/carbon/user) // This could have been done better, but i'm too stupid and tired to get something out of it
	var/obj/item/organ/penis/_penis = getorganslot("penis")
	var/datum/preferences/prefs = user.client.prefs
	var/datum/customizer_entry/organ/penis/penis_entry = null
	if(!_penis)
		to_chat(user, "<span class='warning'>What penis?</span>")
		return
	if (!prefs)
		return

	for (var/datum/customizer_entry/entry in prefs.customizer_entries)
		if (istype(entry, /datum/customizer_entry/organ/penis))
			penis_entry = entry
			break

	var/named_size = input(user, "Choose your penis size:", "Penis", find_key_by_value(PENIS_SIZES_BY_NAME, penis_entry.penis_size)) as anything in PENIS_SIZES_BY_NAME

	if (isnull(named_size))
		return

	var/new_size = PENIS_SIZES_BY_NAME[named_size]

	penis_entry.penis_size = sanitize_integer(new_size, MIN_PENIS_SIZE, MAX_PENIS_SIZE, DEFAULT_PENIS_SIZE)

	_penis.penis_size = penis_entry.penis_size
	user.regenerate_icons()
//OV edit end

/datum/customizer/organ/testicles
	abstract_type = /datum/customizer/organ/testicles
	name = "Testicles"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = MALE

/datum/customizer/organ/testicles/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/testicles
	abstract_type = /datum/customizer_choice/organ/testicles
	name = "Testicles"
	organ_type = /obj/item/organ/testicles
	organ_dna_type = /datum/organ_dna/testicles
	customizer_entry_type = /datum/customizer_entry/organ/testicles
	organ_slot = ORGAN_SLOT_TESTICLES
	tgui_template = "FeatureChoiceTesticles"
	var/can_customize_size = TRUE

/datum/customizer_choice/organ/testicles/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/testicles/testicles_entry = entry
	testicles_entry.ball_size = sanitize_integer(testicles_entry.ball_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE, DEFAULT_TESTICLES_SIZE)

/datum/customizer_choice/organ/testicles/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/testicles/testicles_dna = organ_dna
	var/datum/customizer_entry/organ/testicles/testicles_entry = entry
	if(can_customize_size)
		testicles_dna.ball_size = testicles_entry.ball_size
	testicles_dna.virility = testicles_entry.virility

/datum/customizer_choice/organ/testicles/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/testicles/testicles_entry = entry
	data["can_customize_size"] = can_customize_size
	data["ball_size"] = find_key_by_value(TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size)
	data["virile"] = testicles_entry.virility

	return data

/datum/customizer_choice/organ/testicles/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/testicles/testicles_entry = entry
	switch(params["customizer_task"])
		if("ball_size")
			var/named_size = tgui_input_list(user, "Choose your ball size:", "Ball Size", TESTICLE_SIZES_BY_NAME, find_key_by_value(TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size))
			if(isnull(named_size))
				return TRUE
			var/new_size = TESTICLE_SIZES_BY_NAME[named_size]
			var/old_size = testicles_entry.ball_size
			for(var/key in TESTICLE_SIZES_BY_NAME)
				if(TESTICLE_SIZES_BY_NAME[key] == old_size)
					old_size = key
					break
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" size", old_size, named_size)
			testicles_entry.ball_size = new_size
			return TRUE
		if("virile")
			testicles_entry.virility = !testicles_entry.virility
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" virility", !testicles_entry.virility ? "Virile" : "Sterile", testicles_entry.virility ? "Virile" : "Sterile")
			return TRUE

/datum/customizer/organ/testicles/external
	customizer_choices = list(/datum/customizer_choice/organ/testicles/external)

/datum/customizer/organ/testicles/human
	customizer_choices = list(/datum/customizer_choice/organ/testicles/human)

/datum/customizer/organ/testicles/internal
	customizer_choices = list(/datum/customizer_choice/organ/testicles/internal)

/datum/customizer/organ/testicles/anthro
	customizer_choices = list(
		/datum/customizer_choice/organ/testicles/external,
		/datum/customizer_choice/organ/testicles/internal,
	)

/datum/customizer_choice/organ/testicles/external
	name = "Testicles"
	sprite_accessories = list(
		/datum/sprite_accessory/testicles/pair,
		//OV ADD START
		/datum/sprite_accessory/testicles/sheath,
		//OV ADD END
		)

/datum/customizer_choice/organ/testicles/human
	name = "Testicles"
	sprite_accessories = list(
		/datum/sprite_accessory/testicles/pair,
		//OV ADD START
		/datum/sprite_accessory/testicles/sheath,
		//OV ADD END
		)
	allows_accessory_color_customization = FALSE

/datum/customizer_choice/organ/testicles/internal
	name = "Internal testicles"
	organ_type = /obj/item/organ/testicles/internal
	sprite_accessories = null
	can_customize_size = FALSE

/datum/customizer_entry/organ/testicles
	var/ball_size = DEFAULT_TESTICLES_SIZE
	var/virility = TRUE

//OV edit
/mob/living/carbon/proc/change_testicle_size_customizer(mob/living/carbon/user) // This could have been done better, but i'm too stupid and tired to get something out of it
	var/obj/item/organ/testicles/_testicles = getorganslot("testicles")
	var/datum/preferences/prefs = user.client.prefs
	var/datum/customizer_entry/organ/testicles/testicles_entry = null
	if(!_testicles)
		to_chat(user, "<span class='warning'>What testicles?</span>")
		return
	if (!prefs)
		return

	for (var/datum/customizer_entry/entry in prefs.customizer_entries)
		if (istype(entry, /datum/customizer_entry/organ/testicles))
			testicles_entry = entry
			break

	var/named_size = input(user, "Choose your ball size:", "Testicles", find_key_by_value(TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size)) as anything in TESTICLE_SIZES_BY_NAME

	if (isnull(named_size))
		return

	var/new_size = TESTICLE_SIZES_BY_NAME[named_size]

	testicles_entry.ball_size = sanitize_integer(new_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE, DEFAULT_TESTICLES_SIZE)

	_testicles.ball_size = testicles_entry.ball_size
	user.regenerate_icons()
//OV edit end

/datum/customizer/organ/breasts
	abstract_type = /datum/customizer/organ/breasts
	name = "Breasts"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = FEMALE

/datum/customizer/organ/breasts/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/breasts
	abstract_type = /datum/customizer_choice/organ/breasts
	name = "Breasts"
	customizer_entry_type = /datum/customizer_entry/organ/breasts
	organ_type = /obj/item/organ/breasts
	organ_slot = ORGAN_SLOT_BREASTS
	organ_dna_type = /datum/organ_dna/breasts
	tgui_template = "FeatureChoiceBreasts"

/datum/customizer_choice/organ/breasts/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/breasts/breasts_entry = entry
	breasts_entry.breast_size = sanitize_integer(breasts_entry.breast_size, MIN_BREASTS_SIZE, MAX_BREASTS_SIZE, DEFAULT_BREASTS_SIZE)

/datum/customizer_choice/organ/breasts/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/breasts/breasts_dna = organ_dna
	var/datum/customizer_entry/organ/breasts/breasts_entry = entry
	breasts_dna.breast_size = breasts_entry.breast_size

/datum/customizer_choice/organ/breasts/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/breasts/breasts_entry = entry
	data["breast_size"] = find_key_by_value(BREAST_SIZES_BY_NAME, breasts_entry.breast_size)

	return data

/datum/customizer_choice/organ/breasts/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/customizer_entry/organ/breasts/breasts_entry = entry
	switch(params["customizer_task"])
		if("breast_size")
			var/named_size = tgui_input_list(user, "Choose your breast size:", "Breast Size", BREAST_SIZES_BY_NAME, find_key_by_value(BREAST_SIZES_BY_NAME, breasts_entry.breast_size))
			if(isnull(named_size))
				return TRUE
			var/new_size = BREAST_SIZES_BY_NAME[named_size]
			var/old_size = breasts_entry.breast_size
			for(var/key in BREAST_SIZES_BY_NAME)
				if(BREAST_SIZES_BY_NAME[key] == old_size)
					old_size = key
					break
			prefs.verbose_pref_log_change(user, "notice", "\"[name]\" size", old_size, named_size)
			breasts_entry.breast_size = new_size
			return TRUE

/datum/customizer_entry/organ/breasts
	var/breast_size = DEFAULT_BREASTS_SIZE

/datum/customizer/organ/breasts/human
	customizer_choices = list(/datum/customizer_choice/organ/breasts/human)

/datum/customizer_choice/organ/breasts/human
	sprite_accessories = list(
		/datum/sprite_accessory/breasts/pair,
		//OV ADD START
		/datum/sprite_accessory/breasts/hyper/pair,
		//OV ADD END
		)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/breasts/animal
	customizer_choices = list(/datum/customizer_choice/organ/breasts/animal)

/datum/customizer_choice/organ/breasts/animal
	sprite_accessories = list(
		/datum/sprite_accessory/breasts/pair,
		/datum/sprite_accessory/breasts/quad,
		/datum/sprite_accessory/breasts/sextuple,
		//OV ADD START
		/datum/sprite_accessory/breasts/hyper/pair,
		/datum/sprite_accessory/breasts/hyper/quad,
		/datum/sprite_accessory/breasts/hyper/sextuple,
		//OV ADD END
		)

//OV edit
/mob/living/carbon/proc/change_breast_size_customizer(mob/living/carbon/user) // This could have been done better, but i'm too stupid and tired to get something out of it
	var/obj/item/organ/breasts/_breasts = getorganslot("breasts")
	var/datum/preferences/prefs = user.client.prefs
	var/datum/customizer_entry/organ/breasts/breasts_entry = null
	if(!_breasts)
		to_chat(user, "<span class='warning'>What breasts?</span>")
		return
	if (!prefs)
		return

	for (var/datum/customizer_entry/entry in prefs.customizer_entries)
		if (istype(entry, /datum/customizer_entry/organ/breasts))
			breasts_entry = entry
			break

	var/named_size = input(user, "Choose your breast size:", "Breasts", find_key_by_value(BREAST_SIZES_BY_NAME, breasts_entry.breast_size)) as anything in BREAST_SIZES_BY_NAME

	if (isnull(named_size))
		return

	var/new_size = BREAST_SIZES_BY_NAME[named_size]

	breasts_entry.breast_size = sanitize_integer(new_size, MIN_BREASTS_SIZE, MAX_BREASTS_SIZE, DEFAULT_BREASTS_SIZE)

	_breasts.breast_size = breasts_entry.breast_size
	user.regenerate_icons()
//OV edit end

/datum/customizer/organ/vagina
	abstract_type = /datum/customizer/organ/vagina
	name = "Vagina"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = FEMALE

/datum/customizer/organ/vagina/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/vagina
	abstract_type = /datum/customizer_choice/organ/vagina
	name = "Vagina"
	customizer_entry_type = /datum/customizer_entry/organ/vagina
	organ_type = /obj/item/organ/vagina
	organ_slot = ORGAN_SLOT_VAGINA
	organ_dna_type = /datum/organ_dna/vagina
	tgui_template = "FeatureChoiceVagina"

/datum/customizer_entry/organ/vagina
	var/fertility = TRUE

/datum/customizer_choice/organ/vagina/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/vagina/vagina_dna = organ_dna
	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	vagina_dna.fertility = vagina_entry.fertility

/datum/customizer_choice/organ/vagina/tgui_pref_choices(datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	var/list/data = ..()

	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	data["fertility"] = vagina_entry.fertility

	return data

/datum/customizer_choice/organ/vagina/handle_tgui_act(list/params, datum/tgui/ui, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	. = ..()
	if(.)
		return

	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	switch(params["customizer_task"])
		if("fertile")
			vagina_entry.fertility = !vagina_entry.fertility
			prefs.verbose_pref_log_change(ui.user, "notice", "\"[name]\" fertility", !vagina_entry.fertility ? "Fertile" : "Sterile", vagina_entry.fertility ? "Fertile" : "Sterile")
			return TRUE

/datum/customizer/organ/vagina/human
	customizer_choices = list(/datum/customizer_choice/organ/vagina/human)

/datum/customizer_choice/organ/vagina/human
	sprite_accessories = list(
		/datum/sprite_accessory/vagina/human,
		/datum/sprite_accessory/vagina/gaping,
		/datum/sprite_accessory/vagina/hairy,
		)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/vagina/human_anthro
	customizer_choices = list(/datum/customizer_choice/organ/vagina/human_anthro)

/datum/customizer_choice/organ/vagina/human_anthro
	sprite_accessories = list(
		/datum/sprite_accessory/vagina/human,
		/datum/sprite_accessory/vagina/gaping,
		/datum/sprite_accessory/vagina/hairy,
		)
	allows_accessory_color_customization = TRUE

/datum/customizer/organ/vagina/animal
	customizer_choices = list(/datum/customizer_choice/organ/vagina/animal)

/datum/customizer_choice/organ/vagina/animal
	sprite_accessories = list(
		/datum/sprite_accessory/vagina/human,
		/datum/sprite_accessory/vagina/gaping,
		/datum/sprite_accessory/vagina/hairy,
		/datum/sprite_accessory/vagina/spade,
		/datum/sprite_accessory/vagina/furred,
		)

/datum/customizer/organ/vagina/anthro
	customizer_choices = list(/datum/customizer_choice/organ/vagina/anthro)

/datum/customizer_choice/organ/vagina/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/vagina/human,
		/datum/sprite_accessory/vagina/gaping,
		/datum/sprite_accessory/vagina/hairy,
		/datum/sprite_accessory/vagina/spade,
		/datum/sprite_accessory/vagina/furred,
		/datum/sprite_accessory/vagina/cloaca,
		)
