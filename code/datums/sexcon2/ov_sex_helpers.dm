// OV File

// Note: partner may be src!
// This is a helper to initiate sex sessions when MiddleMouseDrop_T is inaccessible (vore usually)
/mob/living/carbon/human/proc/try_initiate_sex(mob/living/carbon/human/partner)
	if(!istype(partner))
		to_chat(src, span_warning("I can't fuck this."))
		return FALSE

	// Hard Locks (used for deadites)
	if(!can_do_sex)
		to_chat(src, span_warning("I can't do this."))
		return FALSE

	if(!partner.can_do_sex)
		to_chat(src, span_warning("[partner] can't do this."))
		return FALSE

	// Check Prefs
	if(!client?.prefs?.sexable)
		to_chat(src, span_warning("Your ERP Preferences in options is disabled."))
		return FALSE

	if(!partner?.client?.prefs?.sexable)
		to_chat(src, span_warning("[partner] doesn't wish to be touched. (Their ERP preference under options)"))
		to_chat(partner, span_warning("[src] failed to touch you. (Your ERP preference under options)"))
		return FALSE

	// Check vore
	if(absorbed)
		to_chat(src, span_warning("You can't do this while absorbed."))
		return FALSE
	if(partner.absorbed)
		to_chat(src, span_warning("You can't reach [partner]."))
		return FALSE

	// Sex time!
	if(!start_sex_session(partner))
		to_chat(src, span_warning("I am already sexing."))
		return FALSE

	return TRUE

/* Redundant due to open_erp()
/mob/living/carbon/human/verb/masturbate()
	set name = "Masturbate"
	set category = "IC"

	if(IsPetrified())
		to_chat(src, span_warning("You cannot do this while petrified."))
		return

	try_initiate_sex(src)
*/

//OPEN ERP panel with a verb, allowing it to work on prey in bellies

/mob/living/carbon/human/verb/open_erp()
	set name = "Open ERP panel"
	set category = "IC"

	if(stat)
		to_chat(src,span_warning("You can't do that right now."))
		return
	if(IsPetrified())
		to_chat(src, span_warning("I can't do that while petrified."))
		return
	if(IsSleeping())
		to_chat(src,span_warning("You can't do that while sleeping."))
		return

	var/list/potential_targets = list()

	if(istype(loc, /obj/belly))
		var/obj/belly/our_belly = loc
		var/may_bang_pred = our_belly.owner.client && our_belly.owner.client.prefs && our_belly.owner.client.prefs.sexable == TRUE
		if(isliving(our_belly.owner) && may_bang_pred)	//Only target living
			potential_targets |= our_belly.owner
		for(var/mob/living/carbon/human/L in our_belly.contents) //fuck people in the same belly!
			var/may_bang = L.client && L.client.prefs && L.client.prefs.sexable == TRUE
			if(!isliving(L))	//Only target living
				continue
			if(!may_bang)
				continue
			potential_targets |= L
	else
		for(var/mob/living/carbon/human/L in view(1))
			var/may_bang = L.client && L.client.prefs && L.client.prefs.sexable == TRUE
			if(!isliving(L))	//Only target living
				continue
			if(!may_bang)
				continue
			potential_targets |= L

	for(var/obj/belly/B in contents)
		for(var/mob/living/carbon/human/L in B.contents)
			var/may_bang = L.client && L.client.prefs && L.client.prefs.sexable == TRUE
			if(!isliving(L))	//Only target living
				continue
			if(!may_bang)
				continue
			potential_targets |= L

	for(var/thing in contents)
		if(!istype(thing,/obj/item/holder/micro))	//U can also eat players in your hand
			continue
		var/obj/item/holder/micro/M = thing
		if(M.held_mob == src)
			continue
		var/may_bang = M.held_mob.client && M.held_mob.client.prefs && M.held_mob.client.prefs.sexable == TRUE
		if(!may_bang)
			continue

		potential_targets |= M.held_mob

	if(potential_targets.len <= 0)
		to_chat(src, span_warning("There are no valid targets in range."))
		return

	var/mob/living/carbon/human/choice = tgui_input_list(src,"Who would you like to ERP with?","ERP Panel",potential_targets)

	if(!choice)
		return
	if(get_dist(get_turf(src),get_turf(choice)) > 1)
		to_chat(src, span_warn("\The [choice] is too far away."))
		return

	//ERP panel time
	var/mob/living/carbon/human/target = choice
	var/mob/living/carbon/human/human_user = src

	if(!istype(human_user))
		return
	if(!(human_user.can_do_sex && target.can_do_sex))
		to_chat(src, "<span class='warning'>I can't do this.</span>")
		return

	if(target == human_user)
		var/mob/living/carbon/human/head_target = human_user.get_held_petrified_head_target()
		if(head_target)
			target = head_target
	var/may_bang = target.client && target.client.prefs && target.client.prefs.sexable == TRUE

	#ifdef LOCALTEST
		may_bang = TRUE
	#endif

	if(!may_bang) // Don't bang someone that doesn't want it.
		to_chat(src, "<span class='warning'>[target] doesn't wish to be touched. (Their ERP preference under options)</span>")
		to_chat(target, "<span class='warning'>[src] failed to touch you. (Your ERP preference under options)</span>")
		return

	if(target.IsPetrified() && !target.is_petrified_sensitive())
		to_chat(src, span_warning("[target] is not sensitive to that while petrified."))
		return

	if(!src.start_sex_session(target))
		to_chat(src, "<span class='warning'>I'm already sexing.</span>")
		return
