/datum/preferences/get_all_virtues()
	var/list/data = ..()
	data += extravirtue
	return data

/datum/preferences/set_virtue_by_index(index, datum/virtue/new_virtue)
	if(index == 3)
		QDEL_NULL(extravirtue)
		extravirtue = new_virtue
		return TRUE
	return ..()

/datum/preferences/get_virtue_slot_names()
	var/list/data = ..()
	data += "Extra Virtue"
	return data
