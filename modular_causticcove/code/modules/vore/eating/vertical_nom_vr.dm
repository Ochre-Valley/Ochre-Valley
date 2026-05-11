/mob/living/verb/vertical_nom()
	set name = "Nom from Above"
	set desc = "Allows you to eat people who are below your tile or adjacent one. Requires passability."
	set category = "Vore" //OV EDIT

	if(stat == DEAD || IsParalyzed() || IsImmobilized() || IsStun() || IsKnockdown())
		to_chat(src, span_notice("You cannot do that while in your current state."))
		return

	if(!(src.vore_selected))
		to_chat(src, span_notice("No selected belly found."))
		return

	var/list/targets = list()

	for(var/turf/T in range(1, src))
		if(isopenspace(T))
			while(isopenspace(T))
				T = get_step_multiz(T, DOWN)
			if(T)
				for(var/mob/living/L in T)
					if(L.devourable && L.can_be_drop_prey)
						targets += L

	if(!(targets.len))
		to_chat(src, span_notice("No eligible targets found."))
		return

	var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

	if(!target)
		return

	to_chat(target, span_warning("You feel yourself being pulled up by something... Or someone?!"))
	var/starting_loc = target.loc

	if(do_after(src, 5 SECONDS, target = target))
		if(target.loc != starting_loc)
			to_chat(target, span_warning("You have interrupted whatever that was..."))
			to_chat(src, span_notice("They got away."))
			return
		if(target.buckled)
			target.buckled.unbuckle_mob()
		target.visible_message(span_warning("\The [target] suddenly disappears somewhere above!"),\
			span_danger("You are dragged above and feel yourself slipping directly into \the [src]'s [vore_selected.get_belly_name()]!"))
		to_chat(src, span_notice("You successfully snatch \the [target], slipping them into your [vore_selected.get_belly_name()]."))
		vore_selected.nom_atom(target)
