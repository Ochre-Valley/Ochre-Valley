GLOBAL_DATUM(character_directory, /datum/character_directory)
GLOBAL_LIST_INIT(char_directory_tags, list("Pred", "Pred-Pref", "Prey", "Prey-Pref", "Switch", "Non-Vore", "Unset"))
GLOBAL_LIST_INIT(char_directory_erptags, list("Dominant", "Dom-Pref", "Submissive", "Sub-Pref", "Switch", "No ERP", "Unset"))
GLOBAL_LIST_INIT(char_directory_sexualitytags, list("Straight", "Bisexual", "Pansexual", "Gay", "Lesbian", "Asexual", "Demisexual", "Flexible", "Other", "Unset"))
GLOBAL_LIST_INIT(char_directory_gendertags, list("Male", "Female", "Feminine", "Masculine", "Nonbinary", "Trans Man", "Trans Woman", "Other", "Flexible", "Ungendered", "Unset"))
GLOBAL_LIST_INIT(char_directory_pvp, list("No PvP", "Ask First", "Open to PvP"))

/proc/get_character_ad_value(mob/living/carbon/human/character, datum/preferences/prefs, datum/mind/mind)
	var/current_ad = prefs?.directory_ad
	if(isnull(current_ad))
		current_ad = mind?.directory_ad
	if(isnull(current_ad))
		current_ad = character?.client?.prefs?.directory_ad
	if(isnull(current_ad))
		current_ad = character?.mind?.directory_ad
	return current_ad

/proc/set_character_ad_value(mob/living/carbon/human/character, datum/preferences/prefs, datum/mind/mind, new_value, notify_roleplay_viewers = FALSE)
	if(prefs)
		prefs.directory_ad = new_value
	if(mind)
		mind.directory_ad = new_value

	if(character)
		if(new_value)
			var/formatted_ad = parsemarkdown_basic(html_encode(new_value), hyperlink = TRUE)
			LAZYSET(GLOB.roleplay_ads, character.mobid, "<b>[html_encode(character.real_name)]</b> - [formatted_ad]<BR>")

			if(notify_roleplay_viewers)
				for(var/client/advertisee in (GLOB.clients - character.client))
					if(!(advertisee.prefs.toggles & ROLEPLAY_ADS))
						continue
					to_chat(advertisee, span_info("[character.real_name] has set a roleplay ad."))
		else
			LAZYREMOVE(GLOB.roleplay_ads, character.mobid)

	refresh_character_ad_examine_panels(character, prefs || character?.client?.prefs, mind || character?.mind)

/client/verb/show_character_directory()
	set name = "Character Directory"
	set category = "OOC"
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
/*	
	if(!usr.checkMoveCooldown())
		to_chat(usr, span_warning("Don't spam character directory refresh."))
		return
	usr.setMoveCooldown(10)
*/

	if(!GLOB.character_directory)
		GLOB.character_directory = new
	GLOB.character_directory.ui_interact(mob)


// This is a global singleton. Keep in mind that all operations should occur on usr, not src.
/datum/character_directory
/datum/character_directory/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/character_directory/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterDirectory", "Character Directory")
		ui.open()

/datum/character_directory/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	if (user?.mind)
		data["personalVisibility"] = user.mind.show_in_directory
		data["personalTag"] = user.mind.directory_tag || "Unset"
		data["personalErpTag"] = user.mind.directory_erptag || "Unset"
		data["personalGenderTag"] = user.mind.directory_gendertag || "Unset"
		data["personalSexualityTag"] = user.mind.directory_sexualitytag || "Unset"
		data["personalPvPTag"] = user.mind.directory_pvp || "No PvP"
	else if (user?.client?.prefs)
		data["personalVisibility"] = user.client.prefs.show_in_directory
		data["personalTag"] = user.client.prefs.directory_tag || "Unset"
		data["personalErpTag"] = user.client.prefs.directory_erptag || "Unset"
		data["personalGenderTag"] = user.client.prefs.directory_gendertag || "Unset"
		data["personalSexualityTag"] = user.client.prefs.directory_sexualitytag || "Unset"
		data["personalPvPTag"] = user.client.prefs.directory_pvp || "No PvP"

	return data

GLOBAL_LIST_EMPTY(chardirectory_photos)
/mob/proc/set_chardirectory_photo(base64)
	LAZYSET(GLOB.chardirectory_photos, REF(src), base64)

/mob/proc/get_chardirectory_photo()
	if(LAZYACCESS(GLOB.chardirectory_photos, REF(src)))
		return LAZYACCESS(GLOB.chardirectory_photos, REF(src))

	var/icon/F = getFlatIcon(src, defdir = SOUTH, no_anim = TRUE)
	var/new_base64 = "'data:image/png;base64,[icon2base64(F)]'"
	set_chardirectory_photo(new_base64)
	return new_base64

/datum/character_directory/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	var/list/directory_mobs = list()
	for(var/client/C in GLOB.clients)
		// Allow opt-out.
		if(C?.mob?.mind ? !C.mob.mind.show_in_directory : !C?.prefs?.show_in_directory)
			continue

		// These are the three vars we're trying to find
		// The approach differs based on the mob the client is controlling
		var/name = null
		var/species = null
		var/ooc_notes = null
		var/ooc_notes_favs = null
		var/ooc_notes_likes = null
		var/ooc_notes_maybes = null
		var/ooc_notes_dislikes = null
		var/ooc_notes_style = null
		var/nsfw_ooc_notes = null
		var/gendertag = null
		var/sexualitytag = null
		var/flavor_text = null
		var/nsfw_flavor_text = null
		var/custom_link = null
		var/tag
		var/erptag
		var/character_ad
		var/pvp
		var/photo = C.mob?.get_chardirectory_photo()
		if (C.mob?.mind) //could use ternary for all three but this is more efficient
			tag = C.mob.mind.directory_tag || "Unset"
			erptag = C.mob.mind.directory_erptag || "Unset"
			character_ad = get_character_ad_value(C.mob, C.prefs, C.mob.mind)
			gendertag = C.mob.mind.directory_gendertag || "Unset"
			sexualitytag = C.mob.mind.directory_sexualitytag || "Unset"
			pvp = C.mob.mind.directory_pvp || "No PvP"
		else
			tag = C.prefs.directory_tag || "Unset"
			erptag = C.prefs.directory_erptag || "Unset"
			character_ad = get_character_ad_value(null, C.prefs, null)
			gendertag = C.prefs.directory_gendertag || "Unset"
			sexualitytag = C.prefs.directory_sexualitytag || "Unset"
			pvp = C.prefs.directory_pvp || "No PvP"

		if(ishuman(C.mob))
			var/mob/living/carbon/human/H = C.mob
			var/strangername = H.real_name
			/*
			if(GLOB.data_core && GLOB.data_core.general)
				if(!find_general_record("name", H.real_name))
					if(!find_record("name", H.real_name, GLOB.data_core.hidden_general))
						strangername = "unknown"
			*/
			name = strangername
			species = H.dna.species.name
			ooc_notes = H.ooc_notes_cached
			flavor_text = H.flavortext_cached
			nsfw_ooc_notes = H.erpprefs_cached
			nsfw_flavor_text = H.nsfwflavortext_cached
			//photo = get_headshot_icon(H) //Does not work properly, sadly!

/*
		if(isanimal(C.mob))
			var/mob/living/simple_mob/S = C.mob
			name = S.name
			species = S.character_directory_species()
			ooc_notes = S.ooc_notes
			if(S.ooc_notes_style && (S.ooc_notes_favs || S.ooc_notes_likes || S.ooc_notes_maybes || S.ooc_notes_dislikes))
				ooc_notes = S.ooc_notes + "\n\n"
				ooc_notes_favs = S.ooc_notes_favs
				ooc_notes_likes = S.ooc_notes_likes
				ooc_notes_maybes = S.ooc_notes_maybes
				ooc_notes_dislikes = S.ooc_notes_dislikes
				ooc_notes_style = S.ooc_notes_style
			else
				if(S.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[S.ooc_notes_favs]"
				if(S.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[S.ooc_notes_likes]"
				if(S.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[S.ooc_notes_maybes]"
				if(S.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[S.ooc_notes_dislikes]"
			flavor_text = S.desc
*/

		// It's okay if we fail to find OOC notes and flavor text
		// But if we can't find the name, they must be using a non-compatible mob type currently.
		if(!name)
			continue
		if(character_ad)
			character_ad = parsemarkdown_basic(html_encode(character_ad), hyperlink = TRUE)

		directory_mobs.Add(list(list(
			"ckey" = C.ckey,
			"name" = name,
			"species" = species,
			"ooc_notes_favs" = ooc_notes_favs,
			"ooc_notes_likes" = ooc_notes_likes,
			"ooc_notes_maybes" = ooc_notes_maybes,
			"ooc_notes_dislikes" = ooc_notes_dislikes,
			"ooc_notes_style" = ooc_notes_style,
			"nsfw_ooc_notes" = nsfw_ooc_notes,
			"gendertag" = gendertag,
			"sexualitytag" = sexualitytag,
			"ooc_notes" = ooc_notes,
			"tag" = tag,
			"erptag" = erptag,
			"pvptag" = pvp,
			"character_ad" = character_ad,
			"flavor_text" = flavor_text,
			"nsfw_flavor_text" = nsfw_flavor_text,
			"custom_link" = custom_link,
			"photo" = photo,
		)))

	data["directory"] = directory_mobs

	return data


/datum/character_directory/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "refresh")
		// This is primarily to stop malicious users from trying to lag the server by spamming this verb
		/*
		if(!ui.user.checkMoveCooldown())
			to_chat(ui.user, span_warning("Don't spam character directory refresh."))
			return
		ui.user.setMoveCooldown(10)
		*/
		update_ui_static_data(ui.user, ui)
		return TRUE
	else if(action == "openExamine")
		return open_character_examine(ui.user, params["ckey"], params["open_ad"])
	else
		return check_for_mind_or_prefs(ui.user, action, params["overwrite_prefs"])

/datum/character_directory/proc/open_character_examine(mob/user, target_ckey, open_ad = FALSE)
	if(!user || !target_ckey)
		return FALSE

	var/client/target_client = GLOB.directory[target_ckey]
	if(!target_client)
		to_chat(user, span_warning("That character is no longer available. Try refreshing the directory."))
		return FALSE

	var/datum/examine_panel/character_examine_panel
	if(ishuman(target_client.mob))
		character_examine_panel = new(target_client.mob)
		character_examine_panel.holder = target_client.mob
	else if(target_client.prefs)
		character_examine_panel = new
		character_examine_panel.pref = target_client.prefs
	else
		to_chat(user, span_warning("That character does not currently have profile data available."))
		return FALSE

	character_examine_panel.open_character_ad_on_open = !!open_ad
	character_examine_panel.viewing = user
	character_examine_panel.ui_interact(user)
	return TRUE

/datum/character_directory/proc/check_for_mind_or_prefs(mob/user, action, overwrite_prefs)
	if (!user.client)
		return
	var/can_set_prefs = overwrite_prefs && !!user.client.prefs
	var/can_set_mind = !!user.mind
	if (!can_set_prefs && !can_set_mind)
		if (!overwrite_prefs && !!user.client.prefs)
			to_chat(user, span_warning("You cannot change these settings if you don't have a mind to save them to. Enable overwriting prefs and switch to a slot you're fine with overwriting."))
		return
	switch(action)
		if ("setTag")
			var/list/new_tag = tgui_input_list(user, "Pick a new Vore tag for the character directory", "Character Tag", GLOB.char_directory_tags)
			if(!new_tag)
				return
			return set_for_mind_or_prefs(user, action, new_tag, can_set_prefs, can_set_mind)
		if ("setErpTag")
			var/list/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags)
			if(!new_erptag)
				return
			return set_for_mind_or_prefs(user, action, new_erptag, can_set_prefs, can_set_mind)
		if ("setPvPTag")
			var/list/new_pvp = tgui_input_list(user, "Choose your PvP opt-in status (Note, opting into PvP does not mean that proper escalation should not be followed):", "Directory Tag", GLOB.char_directory_pvp)
			if(!new_pvp)
				return
			return set_for_mind_or_prefs(user, action, new_pvp, can_set_prefs, can_set_mind)
		if ("setVisible")
			var/visible = TRUE
			if (can_set_mind)
				visible = user.mind.show_in_directory
			else if (can_set_prefs)
				visible = user.client.prefs.show_in_directory
			to_chat(user, span_notice("You are now [!visible ? "shown" : "not shown"] in the directory."))
			return set_for_mind_or_prefs(user, action, !visible, can_set_prefs, can_set_mind)
		if ("editAd")
			var/current_ad = get_character_ad_value(user, can_set_prefs ? user.client.prefs : null, can_set_mind ? user.mind : null)
			var/new_ad = tgui_input_text(user, "Change your character ad", "Character Ad", current_ad, MAX_MESSAGE_LEN, TRUE, prevent_enter = TRUE)
			if(isnull(new_ad))
				return
			return set_for_mind_or_prefs(user, action, new_ad, can_set_prefs, can_set_mind)
		if("setGenderTag")
			var/list/new_gendertag = tgui_input_list(usr, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags)
			if(!new_gendertag)
				return
			return set_for_mind_or_prefs(user, action, new_gendertag, can_set_prefs, can_set_mind)
		if("setSexualityTag")
			var/list/new_sexualitytag = tgui_input_list(usr, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags)
			if(!new_sexualitytag)
				return
			return set_for_mind_or_prefs(user, action, new_sexualitytag, can_set_prefs, can_set_mind)

/datum/character_directory/proc/set_for_mind_or_prefs(mob/user, action, new_value, can_set_prefs, can_set_mind)
	can_set_prefs &&= !!user.client.prefs
	can_set_mind &&= !!user.mind
	if (!can_set_prefs && !can_set_mind)
		to_chat(user, span_warning("You seem to have lost either your mind, or your current preferences, while changing the values.[action == "editAd" ? " Here is your ad that you wrote. [new_value]" : null]"))
		return
	switch(action)
		if ("setTag")
			if (can_set_prefs)
				user.client.prefs.directory_tag = new_value
			if (can_set_mind)
				user.mind.directory_tag = new_value
			return TRUE
		if ("setErpTag")
			if (can_set_prefs)
				user.client.prefs.directory_erptag = new_value
			if (can_set_mind)
				user.mind.directory_erptag = new_value
			return TRUE
		if ("setVisible")
			if (can_set_prefs)
				user.client.prefs.show_in_directory = new_value
			if (can_set_mind)
				user.mind.show_in_directory = new_value
			return TRUE
		if ("editAd")
			set_character_ad_value(user, can_set_prefs ? user.client.prefs : null, can_set_mind ? user.mind : null, new_value)
			return TRUE
		if ("setGenderTag")
			if (can_set_prefs)
				user.client.prefs.directory_gendertag = new_value
			if (can_set_mind)
				user.mind.directory_gendertag = new_value
		if ("setSexualityTag")
			if (can_set_prefs)
				user.client.prefs.directory_sexualitytag = new_value
			if (can_set_mind)
				user.mind.directory_sexualitytag = new_value
