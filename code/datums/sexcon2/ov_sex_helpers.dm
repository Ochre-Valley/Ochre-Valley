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

/mob/living/carbon/human/verb/masturbate()
	set name = "Masturbate"
	set category = "IC"

	try_initiate_sex(src)
