/datum/sex_action/vore/prey_squirm
	name = "Squirm in belly"
	debug_erp_panel_verb = FALSE
	prey_action = TRUE

/datum/sex_action/vore/prey_squirm/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]begins to squirm within [target]'s [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/prey_squirm/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]squirming within [target]'s [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/prey_squirm/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	var/prey_effect
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			prey_effect = "wriggles within"
		if(SEX_FORCE_MID)
			prey_effect = "squirms within"
		if(SEX_FORCE_HIGH)
			prey_effect = "struggles against"
		if(SEX_FORCE_EXTREME)
			prey_effect = "fights against"
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] [prey_effect] [target]'s [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/prey_squirm/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/slosh_sound = pick(GLOB.slosh)
	playsound(target, slosh_sound, 200, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE, quiet = TRUE) //OV EDIT
	if(!do_subtle)
		do_onomatopoeia(user)

	var/pleasure_level = 0
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			pleasure_level = 2
		if(SEX_FORCE_MID)
			pleasure_level = 1
		if(SEX_FORCE_HIGH)
			pleasure_level = 0
		if(SEX_FORCE_EXTREME)
			pleasure_level = 0

	sex_session.perform_sex_action(target, 2, 0, TRUE, sex_session.speed, sex_session.force)
	sex_session.perform_sex_action(user, pleasure_level, 0, FALSE, sex_session.speed, sex_session.force)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/vore/prey_squirm/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]cums as they squirm within [target]'s [belly_name]!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	return "within"

/datum/sex_action/vore/prey_squirm/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]finishes squirming.")
