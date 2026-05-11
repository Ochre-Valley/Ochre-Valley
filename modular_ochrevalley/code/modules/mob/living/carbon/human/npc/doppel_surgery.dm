/datum/surgery_step/doppel_empower
	name = "Infuse Lux"
	implements = list(
		/obj/item/reagent_containers/doppel_heart = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 10 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_MASTER
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/doppel_empower/validate_target(mob/user, mob/living/carbon/target, target_zone, datum/intent/intent)
	. = ..()
	var/obj/item/organ/heart/H = target.getorganslot(ORGAN_SLOT_HEART)
	if(!H)
		to_chat(user, "[target] is missing their heart!")
		return FALSE

/datum/surgery_step/doppel_empower/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to infuse [target] with the doppel heart."),
		span_notice("[user] begins to work the doppel heart into [target]."),
		span_notice("[user] begins to work the doppel heart into [target]."))
	return TRUE

/datum/surgery_step/doppel_empower/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("You succeed in infusing the doppel heart."),
		"[user] works the doppel heart into [target]'s innards.",
		"[user] works the doppel heart into [target]'s innards.")
	target.Jitter(100)
	target.visible_message(span_notice("[target] looks energized!"), span_green("I feel a new power course through me!"))
	var/obj/item/reagent_containers/doppel_heart/the_heart = tool
	switch(the_heart.affected_stat)
		if("str")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_str)
		if("int")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_int)
		if("spd")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_spd)
		if("per")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_per)
		if("wil")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_wil)
		if("con")
			target.apply_status_effect(/datum/status_effect/buff/doppel_hearted_con)
	qdel(tool)
	return TRUE

/datum/surgery_step/doppel_empower/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("I screwed up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] works the doppel heart into [target]'s innards."), TRUE)
	return TRUE
