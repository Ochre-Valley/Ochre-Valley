/datum/preferences
	var/epilepsy = FALSE

/mob/verb/toggle_epilepsy_safe()
	set name = "Toggle Epilepsy Safe Mode"
	set category = "Preferences.Options"

	if(client?.prefs)
		client.prefs.epilepsy = !client.prefs.epilepsy
		to_chat(src, span_notice("You [client.prefs.epilepsy ? "will" : "will not"] be on Epilepsy Safe Mode."))
