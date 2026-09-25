/datum/sex_action/vore/pred_hump
	name = "Hump your belly"
	debug_erp_panel_verb = FALSE
	pred_action = TRUE

/datum/sex_action/vore/pred_hump/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]mounts [user.p_their()] own [belly_name], smushing [target] within..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/pred_hump/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]humping [user.p_their()] [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/pred_hump/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	var/prey_effect
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			prey_effect = "smooshing"
		if(SEX_FORCE_MID)
			prey_effect = "squishing"
		if(SEX_FORCE_HIGH)
			prey_effect = "grinding"
		if(SEX_FORCE_EXTREME)
			prey_effect = "crushing"
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] humps down on [user.p_their()] own [belly_name], [prey_effect] [target] within..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/pred_hump/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, sex_session.get_force_sound(), 50, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE, quiet = TRUE) //OV EDIT
	if(!do_subtle)
		do_thrust_animate(user, target)
		do_onomatopoeia(user)

	var/pain_level = 0
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			pain_level = 0
		if(SEX_FORCE_MID)
			pain_level = 0
		if(SEX_FORCE_HIGH)
			pain_level = 2
		if(SEX_FORCE_EXTREME)
			pain_level = 10

	sex_session.perform_sex_action(user, 2, 0, TRUE, sex_session.speed, sex_session.force)
	if(target.digest_pain)
		sex_session.perform_sex_action(target, 0, pain_level, FALSE, sex_session.speed, sex_session.force)
	else
		sex_session.perform_sex_action(target, 0, 0, FALSE, sex_session.speed, sex_session.force)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/vore/pred_hump/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]cums as they hump [user.p_their()] own [belly_name]!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	return "away from"

/datum/sex_action/vore/pred_hump/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	return span_warning("[user] [do_subtle ? "subtly " : ""]finishes humping [user.p_their()] own [belly_name].")
