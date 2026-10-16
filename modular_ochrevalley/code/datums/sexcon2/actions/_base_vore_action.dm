/datum/sex_action/vore
	var/pred_action = FALSE
	var/prey_action = FALSE

/datum/sex_action/vore/proc/check_if_pred(mob/living/carbon/human/user, mob/living/carbon/human/target) //Test if the target is in one of your bellies
	if(!isbelly(target.loc))
		return FALSE
	for(var/obj/belly/our_bellies in user.contents)
		if(our_bellies == target.loc)
			return TRUE
	return FALSE

/datum/sex_action/vore/proc/check_if_prey(mob/living/carbon/human/user, mob/living/carbon/human/target) //Test if the user is in one of the target's bellies
	if(!isbelly(user.loc))
		return FALSE
	for(var/obj/belly/our_bellies in target.contents)
		if(our_bellies == user.loc)
			return TRUE
	return FALSE

/datum/sex_action/vore/proc/get_belly_name(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(pred_action)
		if(check_if_pred(user, target))
			var/obj/belly/our_belly = target.loc
			return our_belly.name
		else if(user.vore_selected)
			return user.vore_selected.name
	if(prey_action)
		if(check_if_prey(user, target))
			var/obj/belly/our_belly = user.loc
			return our_belly.name
		else if(target.vore_selected)
			return target.vore_selected.name
	return "belly"

/datum/sex_action/vore/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(debug_erp_panel_verb)
		return FALSE
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(pred_action && check_if_pred(user, target))
		return TRUE
	if(prey_action && check_if_prey(user, target))
		return TRUE
	return FALSE

/datum/sex_action/vore/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(pred_action && check_if_pred(user, target))
		return TRUE
	if(prey_action && check_if_prey(user, target))
		return TRUE
	return FALSE
