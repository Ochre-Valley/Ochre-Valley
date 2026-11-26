/datum/map_edit_operation/area_door_breaking_protections
	name = "Add Breakin Protections to Inn/Bath Doors"

/datum/map_edit_operation/area_door_breaking_protections/deploy(datum/map_config/config)
	. = ..()
	for(var/obj/structure/mineral_door/D in world)
		var/area/A = get_area(D)
		if(istype(A, /area/rogue/indoors/town/tavern) || istype(A, /area/rogue/indoors/town/bath))
			if(!D.GetComponent(/datum/component/breakin_protection))
				var/door_breakin_message = "Lockpicking this door is not allowed by the server rules and counts as breaking in to the inn. Stop breaking in now."
				var/door_examine_message = "This door counts as part of the inn. Because of this, you are not allowed to break into it."
				D.AddComponent(/datum/component/breakin_protection, breakin_prevented_message = door_breakin_message, examine_message = door_examine_message)
	return TRUE
