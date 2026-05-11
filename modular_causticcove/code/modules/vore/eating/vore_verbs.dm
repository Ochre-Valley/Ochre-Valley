//Test to see if we can shred a mob. Some child override needs to pass us a target. We'll return it if you can.
/mob/living/var/vore_shred_time = 45 SECONDS
/mob/living/proc/can_shred(var/mob/living/carbon/human/target)
	//Needs to have organs to be able to shred them.
	if(!istype(target))
		to_chat(src,span_warning("You can't shred that type of creature."))
		return FALSE
	//Needs to be capable (replace with incapacitated call?)
	if(stat || lying || restrained() || buckled)
		to_chat(src,span_warning("You cannot do that in your current state!"))
		return FALSE
	//Needs to be adjacent, at the very least.
	if(!Adjacent(target))
		to_chat(src,span_warning("You must be next to your target."))
		return FALSE
	//Cooldown on abilities
	if(last_special > world.time)
		to_chat(src,span_warning("You can't perform an ability again so soon!"))
		return FALSE

	return target

//Human test for shreddability, returns the mob if they can be shredded.
/mob/living/carbon/human/vore_shred_time = 10 SECONDS
/mob/living/carbon/human/can_shred()
	//Humans need a grab
	var/obj/item/grabbing/G = get_active_held_item()
	if(!istype(G))
		to_chat(src,span_warning("You have to have a very strong grip on someone first!"))
		return FALSE
	if(G.grab_state != GRAB_NECK)
		to_chat(src,span_warning("You must have a tighter grip to severely damage this creature!"))
		return FALSE

	return ..(G.grabbed)

/mob/living/simple_animal/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,span_warning("There's nobody nearby to use this on."))

		target = tgui_input_list(src,"Who do you wish to target?","Damage/Remove Prey's Organ", choices)
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/verb/shred_limb()
	set name = "Damage Prey's Organ" //OV EDIT
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Vore" //OV EDIT

	//can_shred() will return a mob we can shred, if we can shred any.
	var/mob/living/carbon/human/T = can_shred()
	if(!istype(T))
		return //Silent, because can_shred does messages.

	//Let them pick any of the target's external organs
	var/obj/item/bodypart/T_ext = tgui_input_list(src, "What do you wish to severely damage?", "Organ Choice", T.bodyparts) //D for destroy.
	if(!T_ext) //Picking something here is critical.
		return
	if(T_ext.body_part == CHEST || T_ext.body_part == HEAD)
		if(tgui_alert(src, "Are you sure you wish to severely damage their [T_ext]? It will likely kill [T]...","Shred Limb",list("Yes", "No")) != "Yes")
			return //If they reconsider, don't continue.

	//Any internal organ, if there are any //Caustic - We don't reaaaaally have individual organ damage as a thing here, I THINK? So it might be better to just not bother with this for now.
	/*var/obj/item/organ/internal/T_int = tgui_input_list(src,"Do you wish to severely damage an internal organ, as well? If not, click 'cancel'", "Organ Choice", T_ext.internal_organs)
	if(T_int && (T_int.organ_flags & ORGAN_VITAL))
		if(tgui_alert(src, "Are you sure you wish to severely damage their [T_int]? It will likely kill [T]...","Shred Limb",list("Yes", "No")) != "Yes")
			return*/ //If they reconsider, don't continue.

	//And a belly, if they want
	var/obj/belly/B = tgui_input_list(src,"To where do you wish to swallow the organ if you tear if out? If not at all, click 'cancel'", "Organ Choice", vore_organs)

	if(can_shred(T) != T)
		to_chat(src,span_warning("Looks like you lost your chance..."))
		return

	last_special = world.time + vore_shred_time
	visible_message(span_danger("[src] appears to be preparing to do something to [T]!")) //Let everyone know that bad times are ahead

	if(do_after(src, vore_shred_time, target = T)) //Ten seconds. You have to be in a neckgrab for this, so you're already in a bad position.
		if(can_shred(T) != T)
			to_chat(src,span_warning("Looks like you lost your chance..."))
			return

//		T.add_modifier(/datum/modifier/gory_devourment, 10 SECONDS) //CHOMPEdit - Don't need this because we don't do resleeving sickness.

		//Removing an internal organ
		/*if(T_int && T_int.damage >= 25) //Internal organ and it's been severely damaged
			T.apply_damage(15, BRUTE, T_ext) //Damage the external organ they're going through.
			T_int.Remove(T)
			if(B)
				T_int.forceMove(B) //Move to pred's gut
				visible_message(span_danger("[src] severely damages [T_int.name] of [T]!"))
			else
				T_int.forceMove(T.loc)
				visible_message(span_danger("[src] severely damages [T_ext.name] of [T], resulting in their [T_int.name] coming out!"),span_warning("You tear out [T]'s [T_int.name]!"))*/

		//Removing an external organ
		/*else*/ if(/*!T_int && */T_ext.brute_dam >= 25)
			//Is it groin/chest? You can't remove those.
			if(!T_ext.dismemberable)
				T.apply_damage(25, BRUTE, T_ext)
				visible_message(span_danger("[src] severely damages [T]'s [T_ext.name]!"))
			else if(B)
				T_ext.drop_limb(1) //Clean cut so it doesn't kill the prey completely.
				T_ext.forceMove(B)
				visible_message(span_warning("[src] swallows [T]'s [T_ext.name] into their [lowertext(B.name)]!"))
			else
				T_ext.drop_limb(1) //Clean cut so it doesn't kill the prey completely.
				T_ext.forceMove(T.loc)
				visible_message(span_warning("[src] tears off [T]'s [T_ext.name]!"),span_warning("You tear off [T]'s [T_ext.name]!"))

		//Not targeting an internal organ w/ > 25 damage , and the limb doesn't have < 25 damage.
		else
			//if(T_int)
			//	T_int.damage = 25 //Internal organs can only take damage, not brute damage.
			T.apply_damage(25, BRUTE, T_ext)
			visible_message(span_danger("[src] severely damages [T]'s [T_ext.name]!"))

		log_combat(src,T,"Shredded (hardvore)")

/mob/living/proc/shred_limb_temp()
	set name = "Damage Prey's Organ (beartrap)" //OV EDIT
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Vore" //OV EDIT
	shred_limb()

/mob/verb/toggle_vore_health_bars()
	set name = "Toggle Auto Healthbars"
	set category = "Vore"

	if(client?.prefs)
		client.prefs.vore_health_bars = !client.prefs.vore_health_bars
		to_chat(src, span_notice("Digestion Healthbars [client.prefs.vore_health_bars ? "will" : "will not"] automatically print to chat."))

/mob/verb/toggle_digest_noises()
	set name = "Toggle Digest Noises"
	set category = "Vore"

	if(client?.prefs)
		client.prefs.digestion_noises = !client.prefs.digestion_noises
		to_chat(src, span_notice("You [client.prefs.digestion_noises ? "will" : "will not"] hear digestion noises."))

/mob/verb/toggle_eating_noises()
	set name = "Toggle Eating Noises"
	set category = "Vore"

	if(client?.prefs)
		client.prefs.eating_noises = !client.prefs.eating_noises
		to_chat(src, span_notice("You [client.prefs.eating_noises ? "will" : "will not"] hear eating noises."))

/mob/verb/toggle_belch_noises()
	set name = "Toggle Belch Noises"
	set category = "Vore"

	if(client?.prefs)
		client.prefs.belch_noises = !client.prefs.belch_noises
		to_chat(src, span_notice("You [client.prefs.belch_noises ? "will" : "will not"] hear burps and belches."))

//OV edit
/mob/verb/toggle_vore_fx()
	set name = "Toggle Vore FX"
	set category = "Vore"

	show_vore_fx = !show_vore_fx
	if(client.prefs_vr)
		client.prefs_vr.show_vore_fx = show_vore_fx
	if (isbelly(loc))
		var/obj/belly/B = loc
		B.vore_fx(src, TRUE)
	else
		clear_fullscreen("belly")
	if(!hud_used.hud_shown)
		toggle_hud_vis()
	
	to_chat(src, span_notice("You [show_vore_fx ? "will now" : "will no longer"] see vore belly overlays. NOTE: This preferences has NOT been saved, to save please use the vore panel."))

/mob/verb/toggle_spont_pred()
	set name = "Toggle Spont Pred"
	set category = "Vore"

	can_be_drop_pred = !can_be_drop_pred
	if(client.prefs_vr)
		client.prefs_vr.can_be_drop_pred = can_be_drop_pred
	to_chat(src, span_notice("You [can_be_drop_pred ? "will now" : "will not"] vore other players spontaneously. NOTE: This preferences has NOT been saved, to save please use the vore panel."))

/mob/verb/toggle_spont_prey()
	set name = "Toggle Spont Prey"
	set category = "Vore"

	can_be_drop_prey = !can_be_drop_prey
	if(client.prefs_vr)
		client.prefs_vr.can_be_drop_prey = can_be_drop_prey
	to_chat(src, span_notice("You [can_be_drop_prey ? "will now" : "will not"] be vored by other players spontaneously. NOTE: This preferences has NOT been saved, to save please use the vore panel."))
//OV edit end
