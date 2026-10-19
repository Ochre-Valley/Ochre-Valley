/obj/item/reagent_containers/glass/retort
	name = "retort"
	desc = "A small, convenient piece of artifice that heats liquids to separate out their components."
	volume = 60
	amount_per_transfer_from_this = 5
	icon = 'modular_ochrevalley/icons/obj/retort.dmi'
	icon_state = "retort"

/obj/item/reagent_containers/glass/filter/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("The retort will filter from most to least plentiful, with the reagent highest in the list taking precedence when ties occur")

/obj/item/reagent_containers/glass/retort/attack_obj(obj/target, mob/user)
	if(user.used_intent.type == INTENT_GENERIC)
		return ..()

	// Provide actual messages telling you whether either or both of the containers is closed. I don't care to refactor all this other reagent_containers stuff rn.
	var/nodup = FALSE
	var/they_closed = FALSE
	if(istype(target, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/they = target
		if(they.closed)
			they_closed = TRUE

	switch(user.used_intent.type)
		if(INTENT_POUR)
			if(closed)
				if(they_closed)
					to_chat(user, span_warning("[src] and [target] are corked!"))
					nodup = TRUE
				else
					to_chat(user, span_warning("[src] I'm trying to pour from is corked!"))
			if(they_closed && !nodup)
				to_chat(user, span_warning("[src] I'm trying to fill up is corked!"))
		if(INTENT_FILL)
			if(closed)
				if(they_closed)
					to_chat(user, span_warning("[src] and [target] are corked!"))
					nodup = TRUE
				else
					to_chat(user, span_warning("[src] I'm trying to fill up is corked!"))
			if(they_closed && !nodup)
				to_chat(user, span_warning("[src] I'm trying to pour from is corked!"))
		if(INTENT_SPLASH)
			if(closed)
				if(!user.mob_timers["splashclosed_notif"] || (world.time > (user.mob_timers["splashclosed_notif"] + 0.3 SECONDS)))
					to_chat(user, span_warning("[src] I'm trying to splash with is corked!"))
					user.mob_timers["splashclosed_notif"] = world.time

	if(!spillable)
		to_chat(user, span_warning("[src] is closed!"))
		return

	if(target.is_refillable() && (user.used_intent.type == INTENT_POUR)) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] is empty!"))
			return

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] is full."))
			return
		user.visible_message(span_notice("[user] pours [src] into [target]."), \
						span_notice("I pour [src] into [target]."))
		if(user.m_intent != MOVE_INTENT_SNEAK)
			if(poursounds)
				playsound(user.loc,pick(poursounds), 100, TRUE)
		var/datum/reagent/current = reagents.get_master_reagent()
		for(var/i in 1 to 11)
			if(do_after(user, 8, target = target))
				if(!current)
					break
				if(!current.volume)
					break
				if(target.reagents.holder_full())
					break
				if(!reagents.trans_id_to(target, current.type, amount_per_transfer_from_this,))
					reagents.reaction(target, TOUCH, amount_per_transfer_from_this)
			else
				break
		return

	else if(target.is_drainable() && (user.used_intent.type == INTENT_FILL)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty!"))
			return

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] is full."))
			return
		if(user.m_intent != MOVE_INTENT_SNEAK)
			if(fillsounds)
				playsound(user.loc,pick(fillsounds), 100, TRUE)
		user.visible_message(span_notice("[user] fills [src] with [target]."), \
							span_notice("I fill [src] with [target]."))
		for(var/i in 1 to 11)
			if(do_after(user, 8, target = target))
				if(reagents.holder_full())
					break
				if(!target.reagents.total_volume)
					break
				target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
				onfill(target, user, silent = TRUE)
			else
				break
		return

	if(!isnull(reagents))
		if(reagents.total_volume && user.used_intent.type == INTENT_SPLASH)
			user.visible_message(span_danger("[user] splashes the contents of [src] onto [target]!"), \
								span_notice("I splash the contents of [src] onto [target]."))
			reagents.reaction(target, TOUCH)
			reagents.clear_reagents()
			return

/datum/crafting_recipe/roguetown/engineering/retort
	name = "copper retort"
	result = /obj/item/reagent_containers/glass/retort
	reqs = list(
		/obj/item/ingot/copper = 1,
		/obj/item/magic/infernal/ash = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/retort
	name = "copper retort (Alchemy)"
	result = /obj/item/reagent_containers/glass/retort
	reqs = list(
		/obj/item/ingot/copper = 1,
		/obj/item/magic/infernal/ash = 1,
	)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 2

/datum/supply_pack/rogue/tools/scissors
	name = "Retort"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/retort)
