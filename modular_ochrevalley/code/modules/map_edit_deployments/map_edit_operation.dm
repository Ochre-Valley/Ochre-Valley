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


/// Clears a predefined zone on a given Z-level of objects and mobs.
/datum/map_edit_operation/proc/clear_area(min_x, min_y, max_x, max_y, z)
	// Atoms have not yet initialized while we're doing this, so this should be fine...?
	for(var/s_x in min_x to max_x)
		for(var/s_y in min_y to max_y)
			var/turf/T = locate(s_x, s_y, z)
			for(var/thing in T.contents)
				if(isobj(thing))
					qdel(thing)
				if(ismob(thing))
					qdel(thing)

/datum/map_edit_operation/precise_coordinates

/datum/map_edit_operation/precise_coordinates/proc/get_town_operations()
	SHOULD_CALL_PARENT(FALSE)
	RETURN_TYPE(/list)
	return list()

/datum/map_edit_operation/precise_coordinates/proc/get_wretchcoast_operations()
	SHOULD_CALL_PARENT(FALSE)
	RETURN_TYPE(/list)
	return list()

/datum/map_edit_operation/precise_coordinates/proc/do_operation_from_list(list/L, target_x as num, target_y as num, target_z as num)
	SHOULD_CALL_PARENT(TRUE)
	if(!target_x || !target_y || !target_z)
		return FALSE
	return TRUE

/datum/map_edit_operation/precise_coordinates/deploy(datum/map_config/config)
	// Check if we have any town operations first
	var/list/town_ops = get_town_operations()
	if(length(town_ops))
		var/current_map_z = get_bottommost_z_town()
		var/list/our_operation = town_ops[config.map_path]
		for(var/list/operation_spot in our_operation)
			if(!do_operation_from_list(operation_spot, operation_spot["x"], operation_spot["y"], operation_spot["z"] + current_map_z - 1))
				return FALSE

	// Now we do the same thing but for the wretch coast
	var/list/wretchcoast_ops = get_wretchcoast_operations()
	if(length(wretchcoast_ops))
		var/wretchcoast_z = get_bottommost_z_wretchcoast()
		// Sanity check because SOMETIMES the wretch coast doesn't load (i.e. roguetest)
		if(wretchcoast_z)
			for(var/list/operation_spot in wretchcoast_ops)
				if(!do_operation_from_list(operation_spot, operation_spot["x"], operation_spot["y"], operation_spot["z"] + wretchcoast_z - 1))
					return FALSE
	return TRUE



/datum/map_edit_operation/precise_coordinates/template_deployment
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

/datum/map_edit_operation/precise_coordinates/template_deployment/get_town_operations()
	return templates_by_mappath

/datum/map_edit_operation/precise_coordinates/template_deployment/get_wretchcoast_operations()
	return templates_by_mappath_wretchcoast

/datum/map_edit_operation/precise_coordinates/template_deployment/do_operation_from_list(list/L, target_x as num, target_y as num, target_z as num)
	. = ..()
	if(!.)
		return FALSE
	var/template_id = L["template"]
	if(!template_id)
		return FALSE
	var/datum/map_template/M = SSmapping.map_templates[template_id]
	if(!M)
		return FALSE
	// We have our template and our coordinates. Clear 'em out
	// Just do it for the bottommost Z-level of the template, anything more is overkill and unnecessary
	clear_area(target_x, target_y, target_x + M.width-1, target_y + M.height-1, target_z)
	// With all that cleared out, deploy it!
	var/turf/target = locate(target_x, target_y, target_z)
	if(!target)
		return FALSE
	if(!M.load(target))
		return FALSE

	return TRUE

/datum/map_edit_operation/precise_coordinates/generic_type_spawner
	/**
	Key is the map path of the current map config.

	Value is a list of nested associated lists containing:
	- `"type"` - The type of the atom to spawn
	- `"name"` - If defined, the object of this spawned type will be given this as a name. (Optional)
	- `"x"` - X coordinate WITHIN THE MAP BOUNDS at which to deploy the template (AKA, the Z coordinate to deploy it relative to the map itself. Z 1 is the bottommost z-level of the current map, 2 is the 2nd from the bottom, etc.)
	- `"y"` - Y coordinate
	- `"z"` - Z coordinate

	With this, We can choose to deploy any number of templates at given coordinates on particular maps.
	#### Example:
	```DreamMaker
	spawntypes_by_mappath = alist(
		"map_files/ovdun_world" = list(
			list(
				"type" = /mob/living/carbon/human/species/goblin/npc/cave,
				"name" = "surprise gobbo", // The "name" parameter is optional!
				"x" = 106,
				"y" = 88,
				"z" = 2
			)
		)
	)
	```
	*/
	var/list/spawntypes_by_mappath = alist()
	/**
	Similar to `spawntypes_by_mappath`, but instead contains a list of nested associated lists that it always deploys onto the wretch coast - IF we can locate it.
	#### Example:
	```DreamMaker
	spawntypes_by_mappath_wretchcoast = list(
		list(
			"type" = /mob/living/carbon/human/species/goblin/npc/cave,
			"name" = "surprise gobbo", // The "name" parameter is optional!
			"x" = 9,
			"y" = 48,
			"z" = 2
		)
	)
	```
	*/
	var/list/spawntypes_by_mappath_wretchcoast = list()

/datum/map_edit_operation/precise_coordinates/generic_type_spawner/get_town_operations()
	return spawntypes_by_mappath

/datum/map_edit_operation/precise_coordinates/generic_type_spawner/get_wretchcoast_operations()
	return spawntypes_by_mappath_wretchcoast

/datum/map_edit_operation/precise_coordinates/generic_type_spawner/do_operation_from_list(list/L, target_x as num, target_y as num, target_z as num)
	. = ..()
	if(!.)
		return FALSE
	var/spawn_type = L["type"]
	if(!spawn_type)
		return FALSE
	var/turf/T = locate(target_x, target_y, target_z)
	if(!T)
		return FALSE
	var/atom/A = new spawn_type(T)
	if(!A)
		return FALSE
	var/spawn_name = L["name"]
	if(spawn_name)
		A.name = spawn_name
	var/spawn_px = L["pixel_x"]
	if(isnum(spawn_px))
		A.pixel_x = spawn_px
	var/spawn_py = L["pixel_y"]
	if(isnum(spawn_py))
		A.pixel_y = spawn_py
	var/spawn_density = L["density"]
	if(isnum(spawn_density))
		A.density = spawn_density

	return TRUE
