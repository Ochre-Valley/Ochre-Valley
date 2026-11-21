//OV FILE
/*
/datum/preferences
	var/show_in_directory = FALSE
	var/directory_tag = "Unset"
	var/directory_erptag = "Unset"
	var/directory_gendertag = "Unset"
	var/directory_sexualitytag = "Unset"
	var/directory_pvp = "No PvP"
	var/directory_ad

*/
/datum/preferences
	var/block_mindlink = FALSE

/client/verb/toggle_mindlink()
	set name = "Toggle Mindlink/Message Blocking"
	set category = "IC"
	set desc = "Block mindlinks/messages (This also will keep you from mindlinking yourself to anyone!)"
	if(prefs)
		if(prefs.block_mindlink)
			prefs.block_mindlink = FALSE
			prefs.save_preferences()
			to_chat(src, span_notice("You may now be contacted via mindlink/message"))
		else
			prefs.block_mindlink = TRUE
			prefs.save_preferences()
			to_chat(src, span_notice("You will no longer be able to be contacted via mindlink/message"))

/proc/hypnotic_gaze_is_blocked(client/C)
	if(!C?.prefs?.path || !fexists(C.prefs.path))
		return FALSE
	var/savefile/S = new /savefile(C.prefs.path)
	if(!S)
		return FALSE
	var/blocked = FALSE
	S["block_hypnotic_gaze"] >> blocked
	return blocked

/client/verb/toggle_hypnotic_gaze_blocking()
	set name = "Toggle Hypnotic Command Blocking"
	set category = "Vore.Misc"
	set desc = "Choose whether to receive Hypnotic Command consent prompts."
	if(!prefs?.path)
		to_chat(src, span_warning("Your preferences could not be saved."))
		return

	var/savefile/S = new /savefile(prefs.path)
	if(!S)
		to_chat(src, span_warning("Your preferences could not be saved."))
		return

	var/blocked = FALSE
	S["block_hypnotic_gaze"] >> blocked
	blocked = !blocked
	WRITE_FILE(S["block_hypnotic_gaze"], blocked)
	if(blocked)
		to_chat(src, span_notice("Hypnotic Command consent prompts are blocked."))
	else
		to_chat(src, span_notice("Hypnotic Command consent prompts are enabled."))
