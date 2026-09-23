/datum/map_edit_operation
	var/name = "NAME THIS OPERATION, SIRE!"


/// Deploys the map edit configuration, letting it perform its edits as the developer sees fit.
///
/// - `config`: The map config file of this round's current map.
///
/// #### Returns:
/// `TRUE` on a successful deployment, `FALSE` otherwise. Save `FALSE` returns for occurrences in deployment that would otherwise cause unrecoverable runtimes, such as failed sanity checks.
/datum/map_edit_operation/proc/deploy(datum/map_config/config)
	return TRUE
