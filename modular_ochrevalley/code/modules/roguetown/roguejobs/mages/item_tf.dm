/obj/effect/decal/cleanable/roguerune/arcyne/item_tf
	name = "Consolidation rune"
	desc = "arcane symbols pulse upon the ground..."
	icon_state = "6"
	invocation = "Materia Unita!"
	color = "#a0d145"
	spellbonus = 15
	scribe_damage = 10
	can_be_scribed = TRUE
	rituals = list(/datum/runeritual/item_tf::name = /datum/runeritual/item_tf)
	require_mage_user = FALSE

/obj/effect/decal/cleanable/roguerune/arcyne/item_tf/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the rune with ONE item and ONE humen on it to merge the humen into the item.")
	. += span_info("This can be reversed by putting the possessed item back onto the rune and using it again.")
	. += span_info("Be wary that destroying the item in any way (including using it in crafting) will KILL the mob inside.")

/obj/effect/decal/cleanable/roguerune/arcyne/item_tf/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
//	if(!buffed)
	var/list/items_to_use = list()
	var/list/humans_to_use = list()
	for(var/atom/close_atom as anything in range(0, src))
		if(!ismovable(close_atom))
			continue
		if(close_atom == src)
			continue
		if(close_atom.invisibility)
			continue
		if(close_atom == usr)
			continue
		if(isitem(close_atom))
			var/obj/item/close_item = close_atom
			if(close_item.item_flags & ABSTRACT) //woops sacrificed your own head
				continue
			items_to_use += close_atom
		if(ishuman(close_atom))
			humans_to_use += close_atom

	/*
	for(var/i in items_to_use)
		message_admins("[i] in items_to_use")
	for(var/i in humans_to_use)
		message_admins("[i] in humans_to_use")
	*/
	
	if(items_to_use.len != 1)
		for(var/atom/invoker in invokers)
			if(!isliving(invoker))
				continue
			var/mob/living/living_invoker = invoker
			to_chat(living_invoker, "There must be a single item on the rune to consolidate!")
		return
	
	var/obj/item/the_item
	for(var/obj/item/our_item in items_to_use)
		the_item = our_item
	
	if(the_item.mob_possession)
		if(the_item.mob_possession in the_item.contents)
			var/our_loc = get_turf(the_item)
			the_item.mob_possession.forceMove(our_loc)
			visible_message(src, span_warning("[the_item.mob_possession] is separated from [the_item]!"))
		the_item.mob_possession = null
		return

	if(humans_to_use.len != 1)
		for(var/atom/invoker in invokers)
			if(!isliving(invoker))
				continue
			var/mob/living/living_invoker = invoker
			to_chat(living_invoker, "There must be a single humen on the rune to consolidate!")
		return

	var/mob/living/the_mob
	for(var/mob/living/our_mob in humans_to_use)
		the_mob = our_mob

	if(!the_mob.allow_spontaneous_tf || !the_mob.client) //Don't allow pref breaks or mobs without clients to avoid powergaming.
		for(var/atom/invoker in invokers)
			if(!isliving(invoker))
				continue
			var/mob/living/living_invoker = invoker
			to_chat(living_invoker, "The rune fails to invoke as [the_mob]'s lux refuses to combine with [the_item].")
		return
	
	the_item.mob_possession = the_mob
	the_mob.forceMove(the_item)
	visible_message(src, span_warning("[the_mob] is merged into [the_item]!"))

	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src] saps your strength!"))
	do_invoke_glow()

/datum/runeritual/item_tf
	name = "Merge lux with object"
	tier = 1
	blacklisted = FALSE

/datum/runeritual/item_tf/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE
