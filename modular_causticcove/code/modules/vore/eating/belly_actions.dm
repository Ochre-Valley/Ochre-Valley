/obj/belly/proc/instant_digest(mob/user, mob/living/target)
	if(target.absorbed)
		to_chat(user, span_warning("\The [target] is absorbed, and cannot presently be digested."))
		return FALSE
	if(tgui_alert(target, "\The [user] is attempting to instantly digest you. Is this something you are okay with happening to you?","Instant Digest", list("No", "Yes")) != "Yes")
		to_chat(user, span_warning("\The [target] declined your digest attempt."))
		to_chat(target, span_warning("You declined the digest attempt."))
		return FALSE
	// must be checked after alert
	if(target.loc != src)
		to_chat(user, span_warning("\The [target] is no longer in \the [src]."))
		return FALSE

	if(isliving(user))
		var/mob/living/l = user
		var/thismuch = target.health + 100
		/*if(ishuman(l))
			var/mob/living/carbon/human/h = l
			thismuch = thismuch * h.species.digestion_nutrition_modifier*/ //I don't believe we have these modifiers on all species.
		l.adjust_nutrition(thismuch)
	target.death()		// To make sure all on-death procs get properly called
	if(target)
		if(target.client?.prefs.digestion_noises)
			if(!fancy_vore)
				SEND_SOUND(target, sound(get_sfx("classic_death_sounds")))
			else
				SEND_SOUND(target, sound(get_sfx("fancy_death_prey")))
		//target.mind?.vore_death = TRUE //Possibly was commented out because of the return gems
		handle_digestion_death(target)
	return TRUE

/obj/belly/proc/instant_break_bone(mob/user, mob/living/target)
	if(!ishuman(target))
		to_chat(user, span_warning("\The [target] has no breakable organs."))
		return FALSE
	if(target.absorbed)
		to_chat(user, span_warning("\The [target] is absorbed, and cannot presently be broken."))
		return FALSE
	if(tgui_alert(target, "\The [user] is attempting to break one of your bones. Is this something you are okay with happening to you?","Break Bones", list("No", "Yes")) != "Yes")
		to_chat(user, span_warning("\The [target] declined your breaking bones attempt."))
		to_chat(target, span_warning("You declined the breaking bones attempt."))
		return FALSE
	if(target.loc != src)
		to_chat(user, span_warning("\The [target] is no longer in \the [src]."))
		return FALSE
	var/mob/living/carbon/human/human_target = target
	var/list/possible_targets = human_target.get_fracturable_organs()
	if(!LAZYLEN(possible_targets)) // why does pick runtime on empty lists....
		to_chat(user, span_warning("\The [target] has no breakable organs."))
		return FALSE

	var/obj/item/bodypart/BP = pick(possible_targets)
	var/wound_path = /datum/wound/fracture
	// Apply body-part-specific wound variants
	if(BP.body_zone == BODY_ZONE_HEAD)
		wound_path = /datum/wound/fracture/head
	else if(BP.body_zone == BODY_ZONE_CHEST)
		wound_path = /datum/wound/fracture/chest

	var/datum/wound/modified_wound = new wound_path()
	modified_wound.bleed_rate = 0

	to_chat(user, span_warning("You break [target]'s [BP]!"))
	BP.add_wound(modified_wound)
	return TRUE

/mob/living/carbon/human/proc/get_fracturable_organs()
	. = list()

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		var/wound_path = /datum/wound/fracture
		// Apply body-part-specific wound variants
		if(BP.body_zone == BODY_ZONE_HEAD)
			wound_path = /datum/wound/fracture/head
		else if(BP.body_zone == BODY_ZONE_CHEST)
			wound_path = /datum/wound/fracture/chest

		var/datum/wound/primordial_wound = GLOB.primordial_wounds[wound_path]
		if(!primordial_wound.can_apply_to_bodypart(BP))
			continue
		. += BP

/obj/belly/proc/instant_absorb(mob/user, mob/living/target)
	if(tgui_alert(target, "\The [user] is attempting to instantly absorb you. Is this something you are okay with happening to you?","Instant Absorb", list("No", "Yes")) != "Yes")
		to_chat(user, span_warning("\The [target] declined your absorb attempt."))
		to_chat(target, span_warning("You declined the absorb attempt."))
		return FALSE
	if(target.loc != src)
		to_chat(user, span_warning("\The [target] is no longer in \the [src]."))
		return FALSE
	if(isliving(user))
		var/mob/living/l = user
		l.adjust_nutrition(target.nutrition)
		var/n = 0 - target.nutrition
		target.adjust_nutrition(n)
	absorb_living(target)
	return TRUE

/obj/belly/proc/instant_knockout(mob/user, mob/living/target)
	if(tgui_alert(target, "\The [user] is attempting to instantly make you unconscious, you will be unable until ejected from the pred. Is this something you are okay with happening to you?","Instant Knockout", list("No", "Yes")) != "Yes")
		to_chat(user, span_warning("\The [target] declined your knockout attempt."))
		to_chat(target, span_warning("You declined the knockout attempt."))
		return FALSE
	if(target.loc != src)
		to_chat(user, span_warning("\The [target] is no longer in \the [src]."))
		return FALSE
	target.AdjustSleeping(500000)
	to_chat(target, span_warning("\The [user] has put you to sleep, you will remain unconscious until ejected from the belly."))
	return TRUE
