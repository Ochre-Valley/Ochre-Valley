/datum/sex_action/oral/biting
	name = "Bite them"
	check_same_tile = FALSE
	target_priority = 100
	intensity = 2
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/oral/biting/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/biting/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/biting/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/body_part = bodyzone2readablezone(user.zone_selected)
	user.visible_message(span_warning("[user] starts [do_subtle ? "subtly " : ""]biting [target]'s [body_part]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/biting/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/body_part = bodyzone2readablezone(user.zone_selected)
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]biting [target]'s [body_part]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/biting/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/oral/biting/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/body_part = bodyzone2readablezone(user.zone_selected)
	user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]cums whilst biting [target]'s [body_part]!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	return "on"

/datum/sex_action/oral/biting/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/body_part = bodyzone2readablezone(user.zone_selected)
	var/prey_effect
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			prey_effect = "nibbles"
		if(SEX_FORCE_MID)
			prey_effect = "bites"
		if(SEX_FORCE_HIGH)
			prey_effect = "chomps"
		if(SEX_FORCE_EXTREME)
			prey_effect = "mauls"

	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] [prey_effect] [target]'s [body_part]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/biting/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.make_sucking_noise(do_subtle)
	// you want to know how i got these scars?
	if(istype(user.head, /obj/item/clothing/head/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE, quiet = TRUE) //OV EDIT
	if(!do_subtle)
		do_thrust_animate(user, target)

	var/pleasure_level = 0
	var/pain_level = 0
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			pleasure_level = 1
			pain_level = 0
		if(SEX_FORCE_MID)
			pleasure_level = 1
			pain_level = 0
		if(SEX_FORCE_HIGH)
			pleasure_level = 1
			pain_level = 2
		if(SEX_FORCE_EXTREME)
			pleasure_level = 0
			pain_level = 10

	sex_session.perform_sex_action(target, pleasure_level, pain_level, TRUE, sex_session.speed, sex_session.force)
	sex_session.perform_sex_action(user, 1, 0, TRUE, sex_session.speed, sex_session.force)
