/mob/living/carbon/human/verb/become_deadite()
	set name = "Become Deadite"
	set category = "IC"
	set desc = "For use in an emergency where you can't be revived in town."

	if(stat != DEAD)
		to_chat(src, "You can only use this verb when dead in a place that prevents you from deaditing normally.")
		return

	var/area/A = get_area(src)
	if(!istype(A, /area/rogue/indoors/town))
		to_chat(src, "You can only use this verb when dead in a place that prevents you from deaditing normally.")
		return

	if(!(mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		to_chat(src, "You are not able to become a deadite.")
		return

	if(HAS_TRAIT(src, TRAIT_DNR) || HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		to_chat(src, "You are not able to become a deadite.")
		return

	var/confirmation = tgui_alert(src, "This verb will turn you into a deadite after 3 minutes of not being interrupted. Do not use this if someone is actively working to revive you, this is intended for when you are stuck with nobody around to save you. Are you sure you want to do this?", "Become Deadite", list("Begin", "Cancel"))

	if(confirmation != "Begin")
		return

	visible_message(span_warning("[src] begins steadily rotting once again, they will soon raise as a deadite if not interrupted."))
	log_and_message_admins("[src] is forcing their deadite transformation")

	if(!do_after_dead(src, 3 MINUTES, src))
		to_chat(src, "Your raising from the dead was interrupted.")
		return

	if(stat != DEAD)
		to_chat(src, "You can only use this verb when dead in a place that prevents you from deaditing normally.")
		return

	A = get_area(src)
	if(!istype(A, /area/rogue/indoors/town))
		to_chat(src, "You can only use this verb when dead in a place that prevents you from deaditing normally.")
		return

	zombie_check()
	var/datum/antagonist/zombie/Z = mind.has_antag_datum(/datum/antagonist/zombie)
	if(Z && !Z.has_turned && !Z.revived && stat == DEAD)
		infected = TRUE
		log_and_message_admins("[src] has successfully used Become Deadite")
		Z.wake_zombie(TRUE)
	else
		to_chat(src, "Something went wrong and you weren't able to become a deadite.")

/proc/do_after_dead(mob/user, delay, atom/target = null, progress = TRUE, datum/callback/extra_checks = null, same_direction = FALSE, no_interrupt = FALSE, allow_movement = FALSE)
	if(!user)
		return FALSE

	if(user.doing)
		if(no_interrupt)
			return
		return FALSE

	user.doing = TRUE
	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	var/atom/Tloc = null
	if(target && !isturf(target))
		Tloc = target.loc

	var/atom/Uloc = user.loc
	var/original_dir = user.dir

	var/drifting = FALSE

	delay *= user.do_after_coefficent()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, user)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = TRUE
	while (world.time < endtime)
		stoplag(1)
		if (progress)
			progbar.update(world.time - starttime)

		if(QDELETED(user) || (!drifting && !allow_movement && user.loc != Uloc) || (extra_checks && !extra_checks.Invoke()) || (same_direction && user.dir != original_dir))
			. = FALSE
			break

		if(!user.doing)
			. = FALSE
			break

		if(!QDELETED(Tloc) && (QDELETED(target) || Tloc != target.loc))
			if((Uloc != Tloc || Tloc != user) && !drifting)
				. = FALSE
				break

	user.doing = FALSE
	SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)
	if (progress)
		qdel(progbar)
