/datum/sex_action/vore/stroke
	name = "Stroke Over Prey"
	debug_erp_panel_verb = FALSE
	pred_action = TRUE

/datum/sex_action/vore/stroke/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]begins to stroke over [user.p_their()] own [belly_name], feeling up [target] within..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/stroke/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] stops stroking over [target] [do_subtle ? "subtly " : ""]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/stroke/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	var/prey_effect
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			prey_effect = "massaging"
		if(SEX_FORCE_MID)
			prey_effect = "stroking across"
		if(SEX_FORCE_HIGH)
			prey_effect = "kneading over"
		if(SEX_FORCE_EXTREME)
			prey_effect = "squeezing down on"
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] feels over [user.p_their()] own [belly_name], [prey_effect] [target] within..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/stroke/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)

	var/pain_level = 0
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			pain_level = 0
		if(SEX_FORCE_MID)
			pain_level = 0
		if(SEX_FORCE_HIGH)
			pain_level = 0
		if(SEX_FORCE_EXTREME)
			pain_level = 5

	sex_session.perform_sex_action(user, 1, 0, TRUE, sex_session.speed, sex_session.force)
	if(target.digest_pain)
		sex_session.perform_sex_action(target, 0, pain_level, FALSE, sex_session.speed, sex_session.force)
	else
		sex_session.perform_sex_action(target, 0, 0, FALSE, sex_session.speed, sex_session.force)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/vore/stroke/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]cums as they feel [target] within [user.p_their()] [belly_name]!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	return "away from"

/datum/sex_action/vore/stroke/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	return span_warning("[user] [do_subtle ? "subtly " : ""]finishes stroking over [user.p_their()] own [belly_name].")
