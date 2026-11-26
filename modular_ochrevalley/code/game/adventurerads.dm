//OV add starts here: lets adventurers advertise
/datum/job/roguetown/adventurer/Topic(href, list/href_list)
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	if(href_list["merc_ad"])
		roleprefs["merc_ad"] = tgui_input_text(usr, "How do you advertise yourself?", "Mercenary Statue", max_length=300)
		update_subprefs_window(usr)
	. = ..()

/datum/job/roguetown/adventurer/update_subprefs_window(mob/user)
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	var/datum/advclass/favorite = roleprefs["favorite_advclass"]
	var/favorite_name = favorite ? favorite::name : "Choose"
	var/HTML = {"
		<i>You can choose a favorite subclass here. You'll automatically select this subclass on roundstart if possible.</i><br/><br/>
		<b>Selected class:</b> <a href="?src=[REF(src)];class=1">[favorite_name]</a><br/><br/>
		<i>Set your advertisement here to automatically enroll with the mercenary statue on spawn. You'll be set to 'Available' status immediately if this is set.</i><br/>
		<b>Mercenary advertisement:</b> <a href="?src=[REF(src)];merc_ad=1">Edit</a>
		[roleprefs["merc_ad"] ? "<hr/>[roleprefs["merc_ad"]]<hr/>":""]
		<center><a href="?src=[REF(src)];subprefsexit=1">EXIT</a>\t\t<a href="?src=[REF(src)];subprefsreset=1">RESET</a></center>
	"}
	// the fact that the window width/height will be different each time is the main reason this isn't all done in a parent proc on /datum/job
	var/datum/browser/popup = new(user, "[JOB_SUBPREFS_WINDOW_ID]", "<div align='center'>[title] Preferences</div>", 500, 350)
	popup.set_content(HTML)
	popup.open(FALSE)
	if(winexists(usr, "[JOB_SUBPREFS_WINDOW_ID]"))
		winset(usr, "[JOB_SUBPREFS_WINDOW_ID]", "focus=true")
