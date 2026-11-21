/obj/item/cheat_tablet
	name = "\improper ye olde tablet o' cheating"
	desc = span_danger("This item is not canon. If you think it is canon, no it isn't.")
	icon = 'modular_ochrevalley/code/modules/admin/admin_items/cheat_items.dmi'
	icon_state = "tablet"
	var/tablet_overlay_state
	w_class = WEIGHT_CLASS_TINY

/obj/item/cheat_tablet/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/cheat_tablet/update_icon()
	. = ..()
	if(!tablet_overlay_state)
		CRASH("Cheating table doesn't have tablet_overlay_state set!")
	cut_overlays()
	var/image/tablet_overlay = image(icon, src, tablet_overlay_state)
	add_overlay(tablet_overlay)

/obj/item/cheat_tablet/repair_all_gear
	name = "\improper ye olde tablet o' cheating (REPAIR)"
	desc = span_blue("USE ME ON A BROKEN THING, OR A PERSON WITH BROKEN THINGS ON THEM.\n<blink>I AM NOT CANON.</blink>")
	tablet_overlay_state = "tablet-repair"

/obj/item/cheat_tablet/repair_all_gear/proc/full_repair_item(obj/item/I)
	. = FALSE
	// Copypasted this from admin "repair all" command in inventory_panel.dm
	if(I.obj_integrity < I.max_integrity)
		if(I.obj_broken)
			I.obj_fix(null, TRUE)
		else
			I.obj_integrity = I.max_integrity
		I.update_icon()
		. = TRUE
	// Also restore sharpness
	if(I.max_blade_int > 0 && I.blade_int < I.max_blade_int)
		I.blade_int = I.max_blade_int

/obj/item/cheat_tablet/repair_all_gear/proc/repair_vfx(mob/living/user, atom/target)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(target)
	S.set_up(1, 1, front)
	S.start()
	addtimer(CALLBACK(src, PROC_REF(repair_vfx_end), user, target), 0.9 SECONDS) // Roughly when the big final hit in the sound effect goes off

/obj/item/cheat_tablet/repair_all_gear/proc/repair_vfx_end(mob/living/user, atom/target)
	user.flash_fullscreen("whiteflash")
	shake_camera(user, 1, 1)
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_turf(target)
	S.set_up(1, 1, front)
	S.start()

/obj/item/cheat_tablet/repair_all_gear/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(ishuman(target) && ishuman(user))
		var/mob/living/carbon/human/H = target
		var/repaired_count = 0
		for(var/obj/item/I in H.GetAllContents())
			if(full_repair_item(I))
				repaired_count++
		if(repaired_count > 0)
			var/is_committing_to_the_funny = prob(10)
			if(is_committing_to_the_funny)
				playsound(get_turf(target), 'modular_ochrevalley/sounds/misc/omega_repair_rare.ogg', 100, TRUE)
			else
				playsound(get_turf(target), 'modular_ochrevalley/sounds/misc/omega_repair.ogg', 100, TRUE)
			if(H == user)
				user.visible_message(span_notice("\The [user] repairs all [repaired_count] of [H.p_their()] damaged gear items in one fell swoop."), span_notice("I repair all [repaired_count] of my damaged gear items in one fell swoop."))
			else
				user.visible_message(span_notice("\The [user] repairs all [repaired_count] of [H]'s damaged gear items in one fell swoop."), span_notice("I repair all [repaired_count] of [H]'s damaged gear items in one fell swoop."))
			repair_vfx(user, target)
			user.changeNext_move(CLICK_CD_GLACIAL)
		else
			if(H == user)
				to_chat(user, span_warning("Nothing on me needs to be repaired."))
			else
				to_chat(user, span_warning("Nothing on \the [H] needs to be repaired."))
	else if(isitem(target))
		var/obj/item/I = target
		if(full_repair_item(I))
			var/is_committing_to_the_funny = prob(10)
			if(is_committing_to_the_funny)
				playsound(get_turf(target), 'modular_ochrevalley/sounds/misc/omega_repair_rare.ogg', 100, TRUE)
			else
				playsound(get_turf(target), 'modular_ochrevalley/sounds/misc/omega_repair.ogg', 100, TRUE)
			user.visible_message(span_notice("\The [user] repairs \the [I] with minimal effort."), span_notice("I repair \the [I] with minimal effort."))
			user.changeNext_move(CLICK_CD_GLACIAL)
			repair_vfx(user, target)
		else
			to_chat(user, span_warning("That doesn't need repairing."))

/obj/item/cheat_tablet/full_heal
	name = "\improper ye olde tablet o' cheating (HEAL)"
	desc = span_blue("USE ME ON ONE WHO HAS NEED.\n<blink>I AM NOT CANON.</blink>")
	tablet_overlay_state = "tablet-heal"

/obj/item/cheat_tablet/full_heal/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target) || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/mob/living/L = target
	L.fully_heal(admin_revive = TRUE)
	L.Jitter(5)
	playsound(L, 'sound/magic/heal_new.ogg', 100, FALSE)
	if(user == target)
		user.visible_message(span_notice("\The [user] performs a MIGHTY HEAL upon [H.p_themselves()]!"), span_notice("I perform a MIGHTY HEAL upon myself!"))
	else
		user.visible_message(span_notice("\The [user] performs a MIGHTY HEAL upon \the [L]!"), span_notice("I perform a MIGHTY HEAL upon \the [L]!"))
	user.changeNext_move(CLICK_CD_GLACIAL)
