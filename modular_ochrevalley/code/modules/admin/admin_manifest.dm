GLOBAL_DATUM(admin_manifest, /datum/admin_manifest)

/client/proc/admin_manifest()
	set name = "Show Manifest.Admin"
	set category = "Admin"
	if(!holder)
		return
	if(!GLOB.admin_manifest)
		GLOB.admin_manifest = new
	GLOB.admin_manifest.ui_interact(mob)

/datum/admin_manifest
/datum/admin_manifest/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/admin_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminManifest", "Admin Manifest")
		ui.open()

/datum/admin_manifest/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	var/list/manifest_mobs = list()

	for(var/client/C in GLOB.clients)
		var/mob/living/L = C.mob
		if(isobserver(C.mob))
			L = C.mob.mind.current
		if(istype(L))
			var/key = C.ckey
			var/name = L.real_name
			var/job = L.get_role_title()
			var/list/sorted_actors = get_sorted_actors_list()
			var/category = sorted_actors[L.mobid] ? sorted_actors[L.mobid]["category"] : "Nobodies"
			var/photo = L.get_chardirectory_photo()
			var/afk = C.is_afk() ? "AFK" : "Active"
			var/mobState = L.stat
			var/antag = L.mind?.special_role ? L.mind.special_role : "None"
			manifest_mobs.Add(list(list(
				"ckey" = key,
				"name" = name,
				"job" = job,
				"category" = category,
				"photo" = photo,
				"afk" = afk,
				"state" = mobState,
				"antag" = antag,
			)))
	data["directory"] = manifest_mobs
	return data
/datum/admin_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "refresh")
		update_ui_static_data(ui.user, ui)
		return TRUE
	if(action == "playerPanel")
		var/client/target_client = GLOB.directory[params["ckey"]]
		if(target_client)
			ui.user.client.show_player_panel_next(target_client.mob)
			return TRUE
		return FALSE
