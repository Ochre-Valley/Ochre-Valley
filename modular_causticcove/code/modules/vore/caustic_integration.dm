/mob/living //Caustic - This MIGHT be able to be removed if the Chompers integration works out
	//oh no vore time
	var/voremode = FALSE

/mob/living/proc/toggle_vore_mode()
	if(cmode)
		return FALSE
	//.voremode = !voremode
	//init_vore()
	if(!client?.prefs_vr)
		return FALSE

	client.prefs_vr.devourable = !client.prefs_vr.devourable
	if(client.prefs_vr.devourable)
		to_chat(src, span_info("I feel voracious."))
	else
		to_chat(src, span_info("I no longer feel voracious."))
	return TRUE

/mob/proc/disable_vore_mode()
	return

/mob/living/disable_vore_mode()
	voremode = FALSE

/mob/living/carbon/verb/toggle_vore_mode_verb()
	set name = "Toggle Vore Mode"
	set category = "Vore.Preferences" // OV Edit
	toggle_vore_mode()
