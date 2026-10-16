/datum/preferences/ui_act_character_creator_villain(action, list/params, datum/tgui/ui, datum/ui_state/state)
	.=..()
	if(.)
		return

	var/mob/user = ui.user

	switch (action)
		if("werewolf_headshot_link")
			to_chat(user, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, [span_bold("do not use a real life photo or use any image that is less than serious.")]"))
			to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
			to_chat(user, span_notice("Keep in mind that the photo will be downsized to 325x325 pixels, so the more square the photo, the better it will look."))
			var/new_werewolf_headshot_link = tgui_input_text(user, "Input the Werewolf Headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox, file garden):", "Werewolf Headshot", werewolf_headshot_link, max_length = MAX_MESSAGE_LEN, encode = FALSE)
			if(new_werewolf_headshot_link == null)
				return CHARACTER_ACT_DATA_UPDATE
			if(new_werewolf_headshot_link == "")
				verbose_pref_log_change(user, "notice", "Werewolf Headshot", html_encode(werewolf_headshot_link), "")
				werewolf_headshot_link = null
				return CHARACTER_ACT_DATA_UPDATE
			if(!valid_headshot_link(user, new_werewolf_headshot_link))
				to_chat(user, span_notice("Invalid image link. Make sure it's a direct link from a valid host (gyazo, discord, lensdump, imgbox, catbox, file garden)."))
				return CHARACTER_ACT_DATA_UPDATE
			verbose_pref_log_change(user, "notice", "Werewolf Headshot", html_encode(werewolf_headshot_link), html_encode(new_werewolf_headshot_link))
			werewolf_headshot_link = new_werewolf_headshot_link
			to_chat(user, span_notice("Successfully updated werewolf headshot picture"))
			log_game("[user] has set their Werewolf Headshot image to '[html_encode(werewolf_headshot_link)]'.")
			return CHARACTER_ACT_DATA_UPDATE

		if("werewolf_setdesc")
			var/new_werewolfdesc = tgui_input_text(user, "Input your werewolf description:", "WEREWOLF IDENTITY", werewolf_setdesc, max_length = MAX_NOTE_SIZE, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
			if(new_werewolfdesc == null)
				return CHARACTER_ACT_DATA_UPDATE
			var/max_length = MAX_NOTE_SIZE
			var/value = trim(params["value"], PREVENT_CHARACTER_TRIM_LOSS(max_length)) || null
			var/prev_length = length(werewolf_setdesc)
			if(new_werewolfdesc == "")
				werewolf_setdesc = null
				return CHARACTER_ACT_DATA_UPDATE
			werewolf_setdesc = new_werewolfdesc
			werewolf_setdesc_cached = parsemarkdown_basic(parse_spoilers(html_encode(werewolf_setdesc)), hyperlink = TRUE)
			verbose_pref_log_change(user, "notice", "Werewolf Description", "[prev_length] characters", "[length(value)] characters")
			log_game("[user] has set their Werewolf Description to '[html_encode(werewolf_setdesc)]")
			return CHARACTER_ACT_DATA_UPDATE

		if("werewolf_setname")
			var/new_name = tgui_input_text(user, "The name of this beast?", "Werewolf Name", werewolf_setname, encode = FALSE)
			if(new_name == "")
				verbose_pref_log_change(user, "notice", "Werewolf Name", werewolf_setname, new_name)
				werewolf_setname = null
				to_chat(user, "<font color='red'>Werewolf name had length of zero, it has been reset. If it remains nothing it will be randomly generated per round!</font>")
				return CHARACTER_ACT_DATA_UPDATE
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					verbose_pref_log_change(user, "notice", "Werewolf Name", werewolf_setname, new_name)
					werewolf_setname = new_name
				else
					to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,."))
			return CHARACTER_ACT_DATA_UPDATE
