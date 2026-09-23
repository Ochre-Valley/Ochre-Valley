/datum/map_edit_operation/deploy_keymasters
	name = "Deploy KEYMASTERs"
	/// Templates we will deploy depending on what town map we're on
	var/list/town_templates_to_use = alist(
		"map_files/ovdun_world" = list("keymaster_stand_town_dun", 106, 88, 2), //X 106, Y 88, Z 2
		"map_files/jagged_jaw" = list("keymaster_stand_town_jagged", 178, 183, 3), // x 178, Y 183, Z 3
		"map_files/roguetest" = list("keymaster_stand_roguetest", 14, 46, 1), // x 14, Y 46, Z 1
	)
	var/wretch_coast_template = "keymaster_stand_wretch"
	var/wretch_deploy_x = 9
	var/wretch_deploy_y = 48
	var/wretch_deploy_z = 2

/// Clears a predefined zone on a given Z-level of objects and mobs.
/datum/map_edit_operation/deploy_keymasters/proc/clear_area(min_x, min_y, max_x, max_y, z)
	// Because template loading doesn't clear out objects or mobs that might be in the way,
	// we first gotta do it ourselves!
	// Atoms have not yet initialized while we're doing this, so this should be fine...?
	for(var/s_x in min_x to max_x)
		for(var/s_y in min_y to max_y)
			var/turf/T = locate(s_x, s_y, z)
			for(var/thing in T.contents)
				if(isobj(thing))
					qdel(thing)
				if(ismob(thing))
					qdel(thing)

/datum/map_edit_operation/deploy_keymasters/deploy(datum/map_config/config)
	. = ..()
	// Look for the wretch coast's z-level!
	// This is gonna be a dumb approach to find it because there's no identifying characteristics for it
	// Beyond the unique name. But HEY, IT WORKS!!
	var/wretch_z = 1
	var/wretch_coast_found = FALSE
	for(var/A in SSmapping.z_list)
		var/datum/space_level/S = A
		if(S.name == "Wretch Coast")
			wretch_z = S.z_value
			wretch_coast_found = TRUE
			break
	// Get the bottommost z-level of the current map
	var/town_z = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
	// Now where we go on the town is going to depend on what town map we're on...
	var/list/our_operation = town_templates_to_use[config.map_path]
	if(our_operation)
		var/template_id = our_operation[1]
		var/our_x = our_operation[2]
		var/our_y = our_operation[3]
		var/our_z = our_operation[4]
		if(!template_id || !our_x || !our_y || !our_z)
			return FALSE
		var/datum/map_template/M = SSmapping.map_templates[template_id]
		if(!M)
			return FALSE
		// We have our template and our coordinates. Clear 'em out
		// Just do it for the bottommost Z-level of the template, anything more is overkill and unnecessary
		clear_area(our_x, our_y, our_x + M.width-1, our_y + M.height-1, town_z + our_z-1)
		// With all that cleared out, deploy it!
		var/turf/target = locate(our_x, our_y, town_z + our_z - 1)
		if(!target)
			return FALSE
		if(!M.load(target))
			return FALSE

	if(wretch_coast_found)
		var/datum/map_template/M = SSmapping.map_templates[wretch_coast_template]
		if(!M)
			return FALSE
		var/min_x = wretch_deploy_x
		var/min_y = wretch_deploy_y
		var/max_x = wretch_deploy_x + M.width - 1
		var/max_y = wretch_deploy_y + M.height - 1
		var/our_z = wretch_z + wretch_deploy_z - 1

		clear_area(min_x, min_y, max_x, max_y, our_z)
		if(!M.load(locate(min_x, min_y, our_z)))
			return FALSE

	return TRUE
