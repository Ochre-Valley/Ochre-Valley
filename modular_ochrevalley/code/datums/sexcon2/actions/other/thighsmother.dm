/datum/sex_action/sex/other/thighsmother
	name = "Smother them with your thighs"
	intensity = 3
	debug_erp_panel_verb = FALSE

/datum/sex_action/sex/other/thighsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_HEAD))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/thighsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, target, BODY_ZONE_HEAD))
		return FALSE
	return TRUE

/datum/sex_action/sex/other/thighsmother/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]shoves [target]'s head between [user.p_their()] thighs!")

/datum/sex_action/sex/other/thighsmother/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	return span_warning("[user] [do_subtle ? "subtly " : ""]pulls [target]'s head out from inbetween [user.p_their()] thighs.")

/datum/sex_action/sex/other/thighsmother/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	switch(sex_session.force)
		if(SEX_FORCE_LOW)
			target_effect = "squeezes"
		if(SEX_FORCE_MID)
			target_effect = "smothers"
		if(SEX_FORCE_HIGH)
			target_effect = "buries"
		if(SEX_FORCE_EXTREME)
			target_effect = "suffocates"
	target.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] [target_effect] [target]'s head with [user.p_their()] thighs..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/sex/other/thighsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	playsound(target, 'sound/misc/mat/fingering.ogg', 20, TRUE, (do_subtle ? -6 : -2), ignore_walls = FALSE, quiet = TRUE)

/datum/sex_action/sex/other/thighsmother/proc/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    target.muffled = TRUE
    ADD_TRAIT(target, TRAIT_TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	target.visible_message(span_warning("My voice is quickly muffled as [user]'s thighs envelop my head"))
    .=..() //IMPORTANT!

/datum/sex_action/sex/other/thighsmother/proc/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    target.muffled = FALSE
    REMOVE_TRAIT(target, TRAIT_TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
    .=..() //IMPORTANT!

	sex_session.perform_sex_action(target, 2, 4, TRUE, sex_session.speed, sex_session.force)
	sex_session.handle_passive_ejaculation(target)
