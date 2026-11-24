/obj/item/reformation_gem
	name = "gem of reformation"
	icon = 'modular_causticcove/icons/items/reformgem/gem.dmi'
	icon_state = "reform_gem"
	desc = "A sickly green gem that pulses with strange powers native to this region of the world."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 1 //you get NOTHING
	var/reform_outline = "reform_outline"

/obj/item/reformation_gem/Initialize()
	. = ..()
	src.add_filter(reform_outline, 2, list("type" = "outline", "color" = "#ff0080", "alpha" = 100, "size" = 1.5))

/obj/item/reformation_gem/examine(mob/user)
	. = ..()
	. += span_notice("A gem used to reform a person's body after it has been digested. To use, activate in hand, preferably somewhere out of the way. This item is NOT to be used in normal revivals and is purely a scene tool. Using this item for anything else is an abuse of mechanics.")

/obj/item/reformation_gem/attack_self(mob/living/user)
	..()
	var/turf/target_turf = get_step(user, user.dir)
	var/image/preview = image('icons/effects/effects.dmi', target_turf, "launchpad_target")
	preview.plane = ABOVE_HUD_PLANE
	user.client.images += preview
	if(target_turf.is_blocked_turf(TRUE) || !isfloorturf(target_turf))
		preview.color = COLOR_RED
		remove_preview_after_delay(preview, user)
		to_chat(user, span_warning("I can't make a portal in front of me; there's an obstruction there."))
		return FALSE
	// Show a preview render of the spot
	var/confirm = tgui_alert(user, "Spawn a reformation portal in the highlighted spot?", "CONFIRM REFORMATION PORTAL", list("Yes", "No"))
	delete_preview_render(preview, user)
	if(confirm == "Yes")
		if(target_turf.is_blocked_turf(TRUE))
			to_chat(user, span_warning("The targeted location is blocked, I cannot create a reformation gate here."))
			return FALSE
		if(isfloorturf(target_turf))
			create_portal(user, target_turf)
			return TRUE
	return FALSE

/obj/item/reformation_gem/proc/remove_preview_after_delay(image/preview_render, mob/user)
	animate(preview_render, alpha = 0, 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(delete_preview_render), preview_render, user), 1 SECONDS, TIMER_DELETE_ME)

/obj/item/reformation_gem/proc/delete_preview_render(image/preview_render, mob/user)
	user.client.images -= preview_render

/obj/item/reformation_gem/proc/create_portal(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You create a reformation portal!</span>")
	new /obj/structure/respawn_portal(location)
	qdel(src)


/datum/crafting_recipe/roguetown/survival/reform_gem
	name = "gem of reformation"
	result = /obj/item/reformation_gem
	reqs = list(
		/obj/item/natural/rock = 1,
		/datum/reagent/medicine/healthpot = 5,
		)
	craftdiff = 2
	subtype_reqs = TRUE
