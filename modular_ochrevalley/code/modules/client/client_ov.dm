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

