/mob/dead/observer/eye/screye/displaced_soul/me_verb(message as text)
	set name = "Me"
	set hidden = 1

	clear_typing_indicator()		// clear it immediately!
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(vessel && original_identity)
		var/raw_msg = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)
		raw_msg = parsemarkdown_basic(raw_msg, limited = TRUE, barebones = TRUE)
		if(findtext(raw_msg, "$n"))
			raw_msg = trim(replacetext(raw_msg, "$n", original_identity.name))
		else
			raw_msg = "[original_identity.name] [raw_msg]"
		log_talk(raw_msg, LOG_SAY, tag="displaced soul (to [vessel])")
		to_chat(list(src, vessel), span_deadsay(autopunct_bare(raw_msg)))

/mob/dead/observer/eye/screye/displaced_soul/me_big_verb(message as text)
	set name = "Me(big)"
	set hidden = 1

	clear_typing_indicator()		// clear it immediately!
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(vessel && original_identity)
		var/raw_msg = copytext_char(sanitize(message), 1, MAX_MESSAGE_BIGME)
		raw_msg = parsemarkdown_basic(raw_msg, limited = TRUE, barebones = TRUE)
		if(findtext(raw_msg, "$n"))
			raw_msg = trim(replacetext(raw_msg, "$n", original_identity.name))
		else
			raw_msg = "[original_identity.name] [raw_msg]"
		log_talk(raw_msg, LOG_SAY, tag="displaced soul (to [vessel])")
		to_chat(list(src, vessel), span_deadsay(autopunct_bare(raw_msg)))
