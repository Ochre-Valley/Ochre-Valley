/client/proc/spawn_player(var/client/C in GLOB.clients)
	set name = "Spawn Player"
	set desc = "Spawn a character as a specified job, with their currently loaded char slot"
	set category = "-Admin-"
	if(!holder)
		return
	//Setup and option selections
	if(!istype(C.mob, /mob/dead))
		if(tgui_alert(usr, "Target is still alive, are you sure you want to delete and respawn them?", "Target Still Alive!", list("Yes", "No")) != "Yes")
			return
	var/list/job_list = sortList(build_loadout_job_list())
	var/selected_title = tgui_input_list(usr, "Select a job to spawn [C.key] as:", "Job Selection", job_list)
	var/selected_job_path = job_list[selected_title]
	if(!selected_job_path)
		to_chat(usr, span_warning("No Job Selected!"))
		return
	var/selected_advclass_path = null
	var/is_migrant = ispath(selected_job_path, /datum/migrant_role)
	if(is_migrant)
		var/datum/migrant_role/migrant_datum = MIGRANT_ROLE(selected_job_path)
		if(migrant_datum.advclass_cat_rolls && length(migrant_datum.advclass_cat_rolls))
		
			// Get advclasses from the role class handler
			var/list/advclass_choices = list()
			for(var/category in migrant_datum.advclass_cat_rolls)
				for(var/datum/advclass/advclass_instance in SSrole_class_handler.sorted_class_categories[category])
					advclass_choices[advclass_instance.name] = advclass_instance.type
			
			
			if(length(advclass_choices))
				var/selected = tgui_input_list(usr, "Select advclass:", "Advclass Selection", sortList(advclass_choices))
				to_chat(usr, span_notice("Advclass selected: [selected]"))
				selected_advclass_path = advclass_choices[selected]
	else
		// Regular job
		var/datum/job/selected_job = SSjob.type_occupations[selected_job_path]
		
		if(length(selected_job?.job_subclasses))
			var/list/advclass_choices = list()
			for(var/advclass_path in selected_job.job_subclasses)
				var/datum/advclass/AC = advclass_path
				advclass_choices[initial(AC.name)] = advclass_path
			
			var/selected = tgui_input_list(usr, "Select advclass:", "Advclass Selection", sortList(advclass_choices))
			to_chat(usr, span_notice("Advclass selected: [selected]"))
			selected_advclass_path = advclass_choices[selected]
	var/turf/location = usr.loc //Fallback to user location if anything weird happens
	do
		switch(tgui_alert(usr,"Where should [C.prefs.real_name] be spawned?", "Where to spawn?", list("Here", "Offset", "Coordinates")))
			if("Offset")
				var/x = input(usr, "Set X offset", "X Offset", 0) as num
				var/y = input(usr, "Set Y offset", "Y Offset", 0) as num
				var/z = input(usr, "Set Z offset", "Z Offset", 0) as num
				location = locate(usr.loc.x + x, usr.loc.y + y, usr.loc.z + z)
			if("Coordinates")
				var/x = input(usr, "Set X position", "X Position", 0) as num
				var/y = input(usr, "Set Y position", "Y Position", 0) as num
				var/z = input(usr, "Set Z position", "Z Position", 0) as num
				location = locate(x, y, z)
			if("Here")
				location = usr.loc
			if(null)
				to_chat(usr, span_danger("No spawn position selected"))
				return
		if(!location)
			to_chat(usr, span_danger("Invalid coordinates for spawn!"))
	while(!location)
	var/announce = tgui_alert(usr, "Add [C.prefs.real_name] to the actor list? (This will announce their arrival if their role normally would)", "Hide from actor list?", list("Yes", "No")) == "Yes"
	if(tgui_alert(usr, "You are spawning [C.prefs.real_name]/([C.ckey]) as [selected_title] at ([location.x],[location.y],[location.z]), is this correct?", "Confirmation", list("Yes", "Cancel")) != "Yes")
		return
	//Actual Spawning stuff
	var/mob/living/carbon/human/new_character = new
	GLOB.loadout_selected_jobs[REF(new_character)] = selected_job_path
	if(selected_advclass_path)
		GLOB.loadout_selected_advclasses[REF(new_character)] = selected_advclass_path
	C.prefs.copy_to(new_character)
	new_character.dna.update_dna_identity()
	location.JoinPlayerHere(new_character, FALSE)
	if(C.mob) //Delete whatever they are
		safe_round_remove(C.mob)
	new_character.key = C.key
	new_character.roll_stats(null)
	apply_full_job_loadout(new_character, selected_job_path, announce)
	apply_prefs_sizecat(new_character, C)
	apply_character_post_equipment(new_character,C)
	message_admins("[key_name_admin(usr)] has spawned [ADMIN_LOOKUPFLW(new_character)] as [selected_title].")
	log_admin("[key_name(usr)] has spawned [key_name(new_character)] as [selected_title].")
	
//Why did this not already exist? Removes a mob from the round, freeing up job slot, effectively far travel
/proc/safe_round_remove(mob/M, announce = FALSE)
	if(M.mind)
		var/datum/job/mob_job = SSjob.GetJob(M.mind.assigned_role)
		if(mob_job)
			mob_job.current_positions = max(0, mob_job.current_positions - 1)
		var/target_job = SSrole_class_handler.get_advclass_by_name(M.advjob)
		if(target_job)
			SSrole_class_handler.adjust_class_amount(target_job, -1)
		M.mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			M.mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == M.real_name)
				GLOB.head_bounties -= removing_bounty
	for(var/obj/item/holder/micro/micro in M)
		M.dropItemToGround(micro, TRUE, TRUE)
	if(SSticker.rulermob == M)
		SSticker.rulermob = null
	if(SSticker.regentmob == M)
		SSticker.regentmob = null
	GLOB.chosen_names -= M.real_name
	LAZYREMOVE(GLOB.actors_list, M.mobid)
	LAZYREMOVE(GLOB.roleplay_ads, M.mobid)
	//No coin forfeiture for admemery, move on to announcing and deleting embeds
	if(M.job in ANNOUNCE_ON_FAR_TRAVEL_ROLES && announce)
		var/datum/job/announce_job = SSjob.GetJob(M.job)
		var/announce_title = announce_job ? announce_job.get_informed_title(M) : M.job
		scom_announce("[M.real_name] the [announce_title] has left the vicinity of [SSticker.realm_name].")
	var/mob/living/L = M
	if(istype(L) && L.has_embedded_objects())
		var/list/embeds = L.get_embedded_objects()
		for(var/thing in embeds)
			QDEL_NULL(thing)
	QDEL_NULL(M)
