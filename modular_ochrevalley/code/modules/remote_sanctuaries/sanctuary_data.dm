/datum/sanctuary_data
	var/owner_ckey
	var/turf/min_turf
	var/min_x
	var/mix_y
	var/min_z
	var/max_x
	var/max_y
	var/max_z
	/// The template that was used to generate our sanctuary.
	var/datum/map_template/remote_sanctuary/used_template
	/// The KEYMASTER exit in this sanctuary that can take players out of it. The portal leading out of the sanctuary will always be made around this KEYMASTER.
	var/obj/item/roguemachine/keymaster_exit/sanctuary_exit
	/// The KEYMASTER that was used to create this sanctuary. The portal leading to the sanctuary will always be made around this KEYMASTER.
	var/obj/item/roguemachine/keymaster/sanctuary_return_point
	/// The portal leading back to the game world, if any. Should always be created within the sanctuary itself. Should be null if there is no portal.
	var/obj/structure/fluff/traveltile/sanctuary_portal/portal_to_gameworld
	/// The portal leading to the sanctuary. Should always be created somewhere in the main game world. Should be null if there is no portal.
	var/obj/structure/fluff/traveltile/sanctuary_portal/portal_to_sanctuary
	var/owner_voice_color
	var/owner_real_name
	/// How many more spare keys the KEYMASTER will be able to regurgitate for this sanctuary's owner.
	var/spare_keys_remaining = 5

/// Returns whether or not this sanctuary was created in the wretch coast.
/datum/sanctuary_data/proc/is_wretch_made()
	return sanctuary_return_point.for_wretches
