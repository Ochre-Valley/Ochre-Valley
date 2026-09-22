/datum/sex_action/vore/tentacle
	name = "Fuck Prey"
	debug_erp_panel_verb = FALSE
	pred_action = TRUE

/datum/sex_action/vore/tentacle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]penetrates [target] with appendages in [user.p_their()] [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/tentacle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]penetrating [target] in [user.p_their()] [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/tentacle/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] fucks [target] with appendages in [user.p_their()] [belly_name]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/vore/tentacle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE, quiet = TRUE) //OV EDIT
	if(!do_subtle)
		do_onomatopoeia(user)

	var/pain_level = 0
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			pain_level = 0
		if(SEX_FORCE_MID)
			pain_level = 0
		if(SEX_FORCE_HIGH)
			pain_level = 1
		if(SEX_FORCE_EXTREME)
			pain_level = 5

	sex_session.perform_sex_action(user, 2, 0, TRUE, sex_session.speed, sex_session.force)
	if(target.digest_pain)
		sex_session.perform_sex_action(target, 0, pain_level, FALSE, sex_session.speed, sex_session.force)
	else
		sex_session.perform_sex_action(target, 0, 0, FALSE, sex_session.speed, sex_session.force)

	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/vore/tentacle/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	user.visible_message(span_love("[user] [do_subtle ? "subtly " : ""]fills [target] with cum within [user.p_their()] [belly_name]!"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	user.try_impregnate(target)
	user.virginity = FALSE
	return "into"

/datum/sex_action/vore/tentacle/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	var/belly_name = get_belly_name(user, target)
	return span_warning("[user] [do_subtle ? "subtly " : ""]finishes humping [user.p_their()] own [belly_name].")
