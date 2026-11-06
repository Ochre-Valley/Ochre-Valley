//A component that can be expanded in future for tracking GM made quests

/client/proc/item_gm_quest(obj/item/I in world)
	set name = "Make Quest Item"
	set category = null
	set hidden = 0

	var/chosen_colour = color_pick_sanitized(usr,"Which colour should the outline be? Cancel to have no outline.","Aura")
	var/target_area = tgui_input_list(usr, "Where is the delivery area?", "Delivery", GLOB.sortedAreas)

	if(!chosen_colour)
		I.AddComponent(/datum/component/gm_quest, TRUE, "ff0000", target_area)
	else
		I.AddComponent(/datum/component/gm_quest, FALSE, chosen_colour, target_area)

/mob/living/proc/mob_gm_quest(mob/user)
	var/chosen_colour = color_pick_sanitized(user,"Which colour should the outline be? Cancel to have no outline.","Aura")

	if(!chosen_colour)
		AddComponent(/datum/component/gm_quest, TRUE, "ff0000")
	else
		AddComponent(/datum/component/gm_quest, FALSE, chosen_colour)

/datum/component/gm_quest
	var/is_mob = FALSE
	var/no_outline = FALSE
	var/chosen_colour = "#ff0000"
	var/target_area = null
	var/outline_filter_id = "gm_quest_item_outline"


/datum/component/gm_quest/Initialize(no_outline_start, chosen_colour_start, target_area_start)
	is_mob = ismob(parent)

	no_outline = no_outline_start
	chosen_colour = "#[chosen_colour_start]"
	target_area = target_area_start

	if(is_mob)
		var/mob/M = parent
		if(!no_outline)
			M.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "[chosen_colour]", "size" = 0.5))
		RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(on_target_death))
		RegisterSignal(parent, COMSIG_MOB_DIGESTION_DEATH, PROC_REF(on_target_death)) // OV Add: Digestion death counts as quest completion
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_mob_examine))
	else
		var/obj/item/I = parent
		if(!no_outline)
			I.add_filter(outline_filter_id, 2, list("type" = "outline", "color" = "[chosen_colour]", "size" = 0.5))
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_dropped))

/datum/component/gm_quest/Destroy()
	if(QDELETED(parent))
		return ..()

	if(isitem(parent))
		var/obj/item/I = parent
		I.remove_filter(outline_filter_id)
	if(ismob(parent))
		var/mob/M = parent
		M.remove_filter(outline_filter_id)
	return ..()

/datum/component/gm_quest/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("This looks to be an important item!")
	if(target_area)
		examine_list += span_notice("This needs to be delivered to [target_area]!")

/datum/component/gm_quest/proc/on_mob_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("They are important for some reason or another...")

/datum/component/gm_quest/proc/on_target_death(mob/living/dead_mob, gibbed)
	SIGNAL_HANDLER

	dead_mob.remove_filter(outline_filter_id)
	log_and_message_admins(span_yellow("GM Quest Notice: ")+span_green("[dead_mob] has been defeated!"))

/datum/component/gm_quest/proc/on_item_dropped(obj/item/dropped_item, mob/user)
	SIGNAL_HANDLER

	if(!target_area)
		return

	var/turf/drop_turf = get_turf(dropped_item)
	var/area/drop_area = get_area(drop_turf)
	if(!istype(drop_area, target_area))
		return

	dropped_item.remove_filter(outline_filter_id)
	log_and_message_admins(span_yellow("GM Quest Notice: ")+span_green("[dropped_item] has been taken to its delivery location!"))
