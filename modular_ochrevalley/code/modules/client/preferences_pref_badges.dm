/datum/preferences/proc/handle_pref_badge_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("choose_grab_and_gulp")
			var/new_choice = tgui_input_list(user, "Do you want players to be able to grab you for scenes with minimal RP build up?","Grab and Gulp",list("No","Yes"))
			if(!new_choice)
				return
			badge_gng = new_choice
		if("choose_vore_pref")
			var/new_choice = tgui_input_list(user, "What are your preferences in vore for allowing digestion, absorption and endo scenes?","Digest/Absorb/Endo",list("Unset","Endo","Absorption","Digestion","Endo and Absorption","Endo and Digestion","Absorption and Digestion","All"))
			if(!new_choice)
				return
			badge_vore = new_choice
		if("choose_willingness")
			var/new_choice = tgui_input_list(user, "What levels of willingness are you comfortable with in your scenes?","Willingness",list("Unset","Willing","Dubcon","Unwilling","Willing and Dubcon","Willing and Unwilling","Dubcon and Unwilling","All"))
			if(!new_choice)
				return
			badge_willing = new_choice
		if("choose_sexuality")
			var/new_choice = tgui_input_list(user, "When it comes to looking for scenes, how would you describe your sexuality in regards to partners you are interested in?","Scene Partner Pref",list("Unset","Straight","Gay","Lesbian","Bisexual","Pansexual","Asexual","Demisexual"))
			if(!new_choice)
				return
			badge_sexuality = new_choice
		if("choose_erp_pref")
			var/new_choice = tgui_input_list(user, "Are you looking for scenes other than vore, involving other sorts of erotic RP?","Allow ERP",list("No","Yes"))
			if(!new_choice)
				return
			badge_erp = new_choice
		if("choose_vore_lean")
			var/new_choice = tgui_input_list(user, "How would you describe your character in terms of vore?","Pred/Prey lean",list("Unset","Pred Only","Pred-leaning","Switch","Prey-leaning","Prey Only"))
			if(!new_choice)
				return
			badge_lean = new_choice
		if("choose_vore_type")
			var/new_choice = tgui_input_list(user, "Which methods of vore do you enjoy? OV is Oral Vore, AV is Anal Vore, CV is Cock Vore and UB in Unbirth. Other methods should be detailed in your OOC notes.","Vore Methods",list("Unset","OV","AV","CV","UB","OV and AV","OV and CV","OV and UB","AV and CV","AV and UB","CV and UB","OV, AV and CV","OV, AV and UB","OV, CV and UB","AV, CV and UB","OV, AV, CV and UB"))
			if(!new_choice)
				return
			badge_type = new_choice

/datum/preferences/proc/print_badges_page()
	var/list/dat = list()
	dat += "<b>Grab and Gulp:</b> <a href='?_src_=prefs;preference=choose_grab_and_gulp;task=change_pref_badge'>[badge_gng]</a><br>"
	dat += "<b>Digest/Absorb/Endo:</b> <a href='?_src_=prefs;preference=choose_vore_pref;task=change_pref_badge'>[badge_vore]</a><br>"
	dat += "<b>Willingness:</b> <a href='?_src_=prefs;preference=choose_willingness;task=change_pref_badge'>[badge_willing]</a><br>"
	dat += "<b>Scene Partner Pref:</b> <a href='?_src_=prefs;preference=choose_sexuality;task=change_pref_badge'>[badge_sexuality]</a><br>"
	dat += "<b>Allow non-vore ERP:</b> <a href='?_src_=prefs;preference=choose_erp_pref;task=change_pref_badge'>[badge_erp]</a><br>"
	dat += "<b>Pred/Prey lean:</b> <a href='?_src_=prefs;preference=choose_vore_lean;task=change_pref_badge'>[badge_lean]</a><br>"
	dat += "<b>Vore Methods:</b> <a href='?_src_=prefs;preference=choose_vore_type;task=change_pref_badge'>[badge_type]</a><br>"
	return dat

/datum/preferences/proc/show_pref_badge_ui(mob/user)
	var/list/dat = list()
	dat += print_badges_page()
	var/datum/browser/popup = new(user, "pref_badge_customization", "<div align='center'>Preference Badges</div>", 350, 510)
	popup.set_content(dat.Join())
	popup.open(FALSE)

