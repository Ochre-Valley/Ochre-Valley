/datum/map_edit_operation
	var/name = "NAME THIS OPERATION, SIRE!"
	var/is_deployable = FALSE


/// Deploys the map edit configuration, letting it perform its edits as the developer sees fit.
///
/// - `config`: The map config file of this round's current map.
///
/// #### Returns:
/// `TRUE` on a successful deployment, `FALSE` otherwise. Save `FALSE` returns for occurrences in deployment that would otherwise cause unrecoverable runtimes, such as failed sanity checks.
/datum/map_edit_operation/proc/deploy(datum/map_config/config)
	return TRUE

// Helper procs for various operations that will likely be frequently used by these

/// Gets the value of the bottommost Z-coordinate of the current town map.
///
/// #### Returns
/// The z-level of the wretch coast. Returns 0 if it was NOT found.
/datum/map_edit_operation/proc/get_bottommost_z_wretchcoast()
	// Look for the wretch coast's z-level!
	// This is gonna be a dumb approach to find it because there's no identifying characteristics for it
	// Beyond the unique name. But HEY, IT WORKS!!
	var/wretch_z = 0
	for(var/A in SSmapping.z_list)
		var/datum/space_level/S = A
		if(S.name == "Wretch Coast")
			wretch_z = S.z_value
			break
	return wretch_z

/// Gets the value of the bottommost Z-coordinate of the current town map.
/datum/map_edit_operation/proc/get_bottommost_z_town()
	return SSmapping.levels_by_trait(ZTRAIT_STATION)[1]


/datum/map_edit_operation/template_deployment
	/**
	Key is the map path of the current map config.

	Value is a list of nested associated lists containing:
	- `"template"` - The ID of the map template to deploy
	- `"x"` - X coordinate WITHIN THE MAP BOUNDS at which to deploy the template (AKA, the Z coordinate to deploy it relative to the map itself. Z 1 is the bottommost z-level of the current map, 2 is the 2nd from the bottom, etc.)
	- `"y"` - Y coordinate
	- `"z"` - Z coordinate

	With this, We can choose to deploy any number of templates at given coordinates on particular maps.
	#### Example:
	```DreamMaker
	templates_by_mappath = alist(
		"map_files/ovdun_world" = list(
			list(
				"template" = "keymaster_stand_town_dun",
				"x" = 106,
				"y" = 88,
				"z" = 2
			)
		)
	)
	```
	*/
	var/list/templates_by_mappath = alist()
	/**
	Similar to `templates_by_mappath`, but instead contains a list of nested associated lists that it always deploys onto the wretch coast - IF we can locate it.
	#### Example:
	```DreamMaker
	templates_by_mappath_wretchcoast = list(
		list(
			"template" = "keymaster_stand_wretch",
			"x" = 9,
			"y" = 48,
			"z" = 2
		)
	)
	```
	*/
	var/list/templates_by_mappath_wretchcoast = list()

/datum/map_edit_operation/template_deployment/deploy(datum/map_config/config)
	// Check if we have any town map templates first
	if(length(templates_by_mappath))
		var/current_map_z = get_bottommost_z_town()
		var/list/our_operation = templates_by_mappath[config.map_path]
		for(var/list/template_spot in our_operation)
			if(!load_template_from_list(template_spot, current_map_z))
				return FALSE

	// Now we do the same thing but for the wretch coast
	if(length(templates_by_mappath_wretchcoast))
		var/wretchcoast_z = get_bottommost_z_wretchcoast()
		// Sanity check because SOMETIMES the wretch coast doesn't load (i.e. roguetest)
		if(wretchcoast_z)
			for(var/list/template_spot in templates_by_mappath_wretchcoast)
				if(!load_template_from_list(template_spot, wretchcoast_z))
					return FALSE
	return TRUE

/// Clears a predefined zone on a given Z-level of objects and mobs.
/datum/map_edit_operation/template_deployment/proc/clear_area(min_x, min_y, max_x, max_y, z)
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

/datum/map_edit_operation/template_deployment/proc/load_template_from_list(list/L, target_z)
	var/template_id = L["template"]
	var/our_x = L["x"]
	var/our_y = L["y"]
	var/our_z = L["z"]
	if(!template_id || !our_x || !our_y || !our_z)
		return FALSE
	our_z += target_z - 1
	var/datum/map_template/M = SSmapping.map_templates[template_id]
	if(!M)
		return FALSE
	// We have our template and our coordinates. Clear 'em out
	// Just do it for the bottommost Z-level of the template, anything more is overkill and unnecessary
	clear_area(our_x, our_y, our_x + M.width-1, our_y + M.height-1, our_z)
	// With all that cleared out, deploy it!
	var/turf/target = locate(our_x, our_y, our_z)
	if(!target)
		return FALSE
	if(!M.load(target))
		return FALSE

	return TRUE
