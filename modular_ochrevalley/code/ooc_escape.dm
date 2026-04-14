//OV FILE
/mob/living/verb/ooc_escape()
	set name = "OOC Escape"
	set category = "OOC"

	if(isturf(src.loc))	//Doesn't work if you aren't contained in some way
		to_chat(src,span_warning("You are already on the ground. OOC Escape can not help you here."))
		return
	
	if(!loc)
		log_and_message_admins(span_warning("is trying to OOC escape, but they appear to be in nullspace, they probably need help."))
		return
	
	if(tgui_alert(src,"Are you sure? This should only be used in situations where you are OOC uncomfortable or otherwise unintentionally stuck.","OOC Escape",list("Cancel","Escape")) != "Escape")
		return

	var/atom/where = loc
	var/msg = "has OOC escaped. "
	if(istype(where, /obj/item/capture_crystal))
		var/obj/item/capture_crystal/old_crystal = where
		old_crystal.Destroy()
		old_crystal.visible_message(span_warning("The crystal shatters!"))
	forceMove(get_turf(src))
	if(isitem(where))
		var/obj/item/the_loc = where
		if(the_loc.mob_possession)
			the_loc.mob_possession = null
	if(isbelly(where))	//For vore
		if(pulledby)
			pulledby.stop_pulling()
		var/obj/belly/B = where
		msg += "They were in [key_name(B.owner)]'s [B]. "
	else if(istype(where,/obj/item/holder/micro))	//For micros
		var/obj/item/holder/micro/mh = where
		mh.dump_mob()
	else	//For everything else
		msg += "They were in [where]. "
	msg += "They have been placed on \the [loc]. [ADMIN_JMP(src)]"
	log_and_message_admins(msg)
