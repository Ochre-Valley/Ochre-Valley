/mob/living/carbon/human/get_movespeed_modifiers()
	var/list/considering = ..()
	. = considering
	if(HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
		for(var/id in .)
			var/list/data = .[id]
			if(data[MOVESPEED_DATA_INDEX_FLAGS] & IGNORE_NOSLOW)
				.[id] = data

/mob/living/carbon/human/update_equipment_speed_mods()
	. = ..()
	update_move_intent_slowdown()

/mob/living/carbon/human/get_effective_speed()
	var/cap = get_ac_speed()
	if(cap && STASPD > cap)
		return cap
	return STASPD

/mob/living/carbon/human/proc/get_ac_speed()
	if(HAS_TRAIT(src, TRAIT_ARMOR_NOSPDCAP))
		return 0
	var/highest_class = ARMOR_CLASS_NONE
	for(var/obj/item/clothing/C in list(wear_armor, wear_shirt, wear_pants, head))
		if(C.armor_class > highest_class)
			highest_class = C.armor_class
	switch(highest_class)
		if(ARMOR_CLASS_LIGHT)
			return AC_LIGHT_SPDCAP
		if(ARMOR_CLASS_MEDIUM)
			return AC_MEDIUM_SPDCAP
		if(ARMOR_CLASS_HEAVY)
			return AC_HEAVY_SPDCAP
	return 0

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube, paralyze, forcedrop)
	if(HAS_TRAIT(src, TRAIT_NOSLIPALL))
		return 0
	if (!(lube&GALOSHES_DONT_HELP))
		if(HAS_TRAIT(src, TRAIT_NOSLIPWATER))
			return 0
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP)
				return 0
	return ..()

/mob/living/carbon/human/Move(NewLoc, direct)
/*	if(fixedeye || tempfixeye)
		switch(dir)
			if(NORTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(SOUTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(EAST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)
			if(WEST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)*/

	. = ..()
	if(loc == NewLoc)

		if(hostage) // If we have a hostage.
			hostage.hostagetaker = null
			hostage = null
			to_chat(src, "<span class='danger'>I need to stand still to make sure I don't lose concentration on my hostage!</span>")

		if(hostagetaker) // If we are TAKEN hostage. Confusing vars at first but then it makes sense.
			attackhostage()

		if(wear_armor && istype(wear_armor, /obj/item/clothing)) //CC Edit: More powder flask shitcode runtimes
			if(mobility_flags & MOBILITY_STAND)
				wear_armor.step_action()

		if(wear_shirt && istype(wear_shirt, /obj/item/clothing)) //CC Edit: More powder flask shitcode runtimes
			if(mobility_flags & MOBILITY_STAND)
				wear_shirt.step_action()

		if(cloak && istype(cloak, /obj/item/clothing)) //CC Edit: More powder flask shitcode runtimes
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/C = isclothing(cloak) ? cloak : null
				C?.step_action()

		if(shoes)
			var/obj/item/clothing/shoes/S = shoes
			if(mobility_flags & MOBILITY_STAND && istype(S))
				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					for(var/obj/effect/decal/cleanable/blood/footprints/oldFP in T)
						if (oldFP.blood_state == S.blood_state)
							return
					//No oldFP or they're all a different kind of blood
					S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state] - BLOOD_LOSS_PER_STEP)
					if (S.bloody_shoes[S.blood_state] > BLOOD_LOSS_IN_SPREAD)
						var/obj/effect/decal/cleanable/blood/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state] - BLOOD_LOSS_IN_SPREAD
						FP.add_blood_DNA(S.return_blood_DNA())
						var/datum/component/decal/blood/shoe_blood = S.GetComponent(/datum/component/decal/blood)
						if(shoe_blood?.blood_color)
							FP.set_blood_color(shoe_blood.blood_color)
						FP.update_icon()
					update_inv_shoes()
				//End bloody footprints
				S.step_action()
		if(mouth)
			if(src.mind?.has_antag_datum(/datum/antagonist/zombie) && (!src.handcuffed) && prob(50))
				visible_message(span_warning("[src] spits out [mouth]."))
				dropItemToGround(mouth, silent = FALSE)

		if(istype(get_turf(src), /turf/open/floor/rogue/snow) && !HAS_TRAIT(src, TRAIT_LIGHT_STEP))
			var/obj/effect/decal/cleanable/blood/footprints/mud/mudprint = new /obj/effect/decal/cleanable/blood/footprints/mud(get_turf(src))
			mudprint.entered_dirs |= dir
			mudprint.update_icon()

// ===== MOUNTING PONIES =====

/mob/living/carbon/human/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!force && !HAS_TRAIT(src, TRAIT_MOUNTABLE))
		return FALSE

	if(..()) // call parent buckle
		var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
		if(!buckled_mobs || buckled_mobs.Find(M) == 1)
			riding_datum.vehicle_move_delay = 2
			if(M.mind)
				var/riding_skill = M.get_skill_level(/datum/skill/misc/riding)
				if(riding_skill)
					riding_datum.vehicle_move_delay = max(1, 2 - (riding_skill * 0.2))
		return TRUE
	return FALSE

/mob/living/carbon/human/post_buckle_mob(mob/living/M)
	var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
	riding_datum.handle_vehicle_layer()
	riding_datum.handle_vehicle_offsets()

/mob/living/carbon/human/relaymove(mob/user, direction)
	if(HAS_TRAIT(src, TRAIT_MOUNTABLE))
		var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
		if(riding_datum)
			// one rider
			var/mob/living/driver = null
			if(buckled_mobs && buckled_mobs.len)
				driver = buckled_mobs[1]
			if(!driver || user != driver)
				return
			return riding_datum.handle_ride(driver, direction)
	return ..()

/mob/living/carbon/human/Knockdown(amount, updating = TRUE)
	. = ..() // parent Knockdown
	if(length(buckled_mobs))
		for(var/mob/living/carbon/human/rider in buckled_mobs)
			unbuckle_mob(rider, TRUE)
			to_chat(rider, span_warning("You fall off [src] as they collapse!"))
			to_chat(src, span_warning("[rider] tumbles off you as you fall!"))

/mob/living/carbon/human/attackby(obj/item/I, mob/living/user, params)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("[user]'s attack is redirected to [mount]'s chest!"))
			user.zone_selected = BODY_ZONE_CHEST
			return mount.attackby(I, user, params)
	// OV Edit Start
	if(IsPetrified() && istype(I, /obj/item/rogueweapon/hammer))
		if(hammer_sculpt_petrified(user))
			return TRUE
		var/obj/item/bodypart/reattach_limb = get_petrified_reattachable_bodypart(user)
		if(reattach_limb)
			user.visible_message(span_notice("[user] begins hammering [reattach_limb] back onto [src]."), span_notice("I begin hammering [reattach_limb] back onto [src]."))
			playsound(get_turf(src), 'sound/items/bsmith1.ogg', 100, FALSE)
			if(do_after(user, 5 SECONDS, target = src))
				if(!QDELETED(reattach_limb) && user.is_holding(reattach_limb) && IsPetrified() && can_reattach_petrified_bodypart(reattach_limb))
					user.temporarilyRemoveItemFromInventory(reattach_limb, TRUE)
					reattach_limb.attach_limb(src, TRUE)
					playsound(get_turf(src), 'sound/items/bsmith3.ogg', 100, FALSE)
					user.visible_message(span_notice("[user] hammers [reattach_limb] back onto [src]."), span_notice("I hammer [reattach_limb] back onto [src]."))
			return TRUE
		if(hammer_remove_petrified_bodypart(user))
			return TRUE
		hammer_repair_petrified(user)
		return TRUE
	// OV Edit End
	return ..()

// OV Edit Start
/mob/living/carbon/human/attack_right(mob/user, params)
	if(hammer_pose_petrified(user))
		return TRUE
	return ..()

/mob/living/carbon/human/proc/get_petrified_reattachable_bodypart(mob/living/user)
	if(!user)
		return null
	for(var/obj/item/bodypart/held_bodypart as anything in user.held_items)
		if(can_reattach_petrified_bodypart(held_bodypart))
			return held_bodypart
	return null

/mob/living/carbon/human/proc/can_reattach_petrified_bodypart(obj/item/bodypart/reattach_limb)
	if(!istype(reattach_limb))
		return FALSE
	if(get_bodypart(reattach_limb.body_zone))
		return FALSE
	if(reattach_limb.original_owner == src)
		return TRUE
	if(istype(reattach_limb, /obj/item/bodypart/head) && reattach_limb.name == "[real_name]'s head")
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/hammer_sculpt_petrified(mob/living/user)
	if(!user || user.zone_selected != BODY_ZONE_PRECISE_STOMACH)
		return FALSE
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return TRUE
	var/obj/item/held = user.get_active_held_item()
	if(!istype(held, /obj/item/rogueweapon/hammer))
		to_chat(user, span_warning("I need to keep holding the hammer."))
		return TRUE
	if(!perform_mirror_transform(src, user, TRUE))
		return TRUE
	if(QDELETED(src) || !IsPetrified())
		return TRUE
	refresh_petrified_visual_state()
	if(QDELETED(user))
		return TRUE
	held = user.get_active_held_item()
	if(Adjacent(user) && istype(held, /obj/item/rogueweapon/hammer))
		playsound(get_turf(src), 'sound/items/bsmith2.ogg', 100, FALSE)
		user.visible_message(span_notice("[user] sculpts [src]'s petrified form with [held]."), span_notice("I sculpt [src]'s petrified form with [held]."))
	return TRUE

/mob/living/carbon/human/proc/hammer_pose_petrified(mob/user)
	if(!IsPetrified() || !user || user.zone_selected != BODY_ZONE_PRECISE_STOMACH)
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!istype(held, /obj/item/rogueweapon/hammer))
		return FALSE
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return TRUE
	var/new_pose = tgui_input_text(user, "Set [src]'s pose (MARKDOWN AVAILABLE):", "SET POSE", pose_text, multiline = FALSE, encode = TRUE, bigmodal = TRUE, max_length = 256)
	if(isnull(new_pose))
		return TRUE
	if(QDELETED(src) || QDELETED(user) || !IsPetrified())
		return TRUE
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return TRUE
	held = user.get_active_held_item()
	if(!istype(held, /obj/item/rogueweapon/hammer))
		to_chat(user, span_warning("I need to keep holding the hammer."))
		return TRUE
	if(!length(new_pose))
		pose_text = ""
		user.visible_message(span_notice("[user] smooths [src]'s pose away with [held]."), span_notice("I clear [src]'s pose."))
		return TRUE
	pose_text = parsemarkdown_basic(new_pose)
	user.visible_message(span_notice("[user] sets [src]'s pose with careful taps of [held]."), span_notice("I set [src]'s pose."))
	return TRUE

/mob/living/carbon/human/proc/hammer_remove_petrified_bodypart(mob/living/user)
	if(!user)
		return FALSE
	var/target_zone = check_zone(user.zone_selected)
	if(!(target_zone in list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
		return FALSE
	var/obj/item/bodypart/bodypart = get_bodypart(user.zone_selected)
	if(!bodypart || bodypart.body_zone != target_zone)
		to_chat(user, span_warning("[src] has no petrified limb there to remove."))
		return TRUE
	user.visible_message(span_notice("[user] begins carefully working [bodypart] free from [src]'s petrified body."), span_notice("I begin carefully working [bodypart] free from [src]'s petrified body."))
	playsound(get_turf(src), 'sound/items/bsmith1.ogg', 100, FALSE)
	if(!do_after(user, 5 SECONDS, target = src))
		return TRUE
	if(QDELETED(src) || QDELETED(user) || QDELETED(bodypart))
		return TRUE
	if(!IsPetrified() || bodypart.owner != src || check_zone(user.zone_selected) != target_zone)
		return TRUE
	var/obj/item/held = user.get_active_held_item()
	if(!istype(held, /obj/item/rogueweapon/hammer))
		to_chat(user, span_warning("I need to keep holding the hammer."))
		return TRUE
	if(bodypart.drop_limb(FALSE))
		refresh_petrified_visual_state()
		playsound(get_turf(src), 'sound/items/bsmith3.ogg', 100, FALSE)
		user.visible_message(span_notice("[user] carefully removes [bodypart] from [src]'s petrified body."), span_notice("I carefully remove [bodypart] from [src]'s petrified body."))
	return TRUE

/mob/living/carbon/human/proc/has_petrified_repair_damage()
	if(!IsPetrified())
		return FALSE
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.brute_dam || bodypart.burn_dam || length(bodypart.wounds) || bodypart.disabled != BODYPART_NOT_DISABLED)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/repair_petrified_tick()
	var/list/damaged_parts = list()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.brute_dam || bodypart.burn_dam || length(bodypart.wounds) || bodypart.disabled != BODYPART_NOT_DISABLED)
			damaged_parts += bodypart
	if(!length(damaged_parts))
		return FALSE
	var/obj/item/bodypart/repairing = pick(damaged_parts)
	repairing.heal_damage(15, 15, 0, null, FALSE)
	if(!repairing.brute_dam && !repairing.burn_dam)
		repairing.wounds = null
		repairing.disabled = BODYPART_NOT_DISABLED
	update_damage_overlays()
	updatehealth()
	return TRUE

/mob/living/carbon/human/proc/hammer_repair_petrified(mob/living/user)
	if(!has_petrified_repair_damage())
		to_chat(user, span_warning("[src] does not need repairs."))
		return
	user.visible_message(span_notice("[user] begins hammering cracks and fractures smooth in [src]'s petrified body."), span_notice("I begin hammering cracks and fractures smooth in [src]'s petrified body."))
	do
		if(!IsPetrified() || QDELETED(src) || QDELETED(user))
			return
		if(!Adjacent(user))
			to_chat(user, span_warning("I need to stay close to repair [src]."))
			return
		var/obj/item/held = user.get_active_held_item()
		if(!istype(held, /obj/item/rogueweapon/hammer))
			to_chat(user, span_warning("I need to keep holding the hammer."))
			return
		if(!do_after(user, CLICK_CD_MELEE, target = src))
			return
		playsound(get_turf(src), pick('sound/items/bsmith1.ogg', 'sound/items/bsmith2.ogg', 'sound/items/bsmith3.ogg'), 100, FALSE)
		if(repair_petrified_tick())
			user.visible_message(span_info("[user] repairs some of the damage in [src]'s petrified body."), span_info("I repair some of the damage in [src]'s petrified body."))
		if(!has_petrified_repair_damage())
			user.visible_message(span_info("[user] finishes repairing [src]'s petrified body."), span_info("I finish repairing [src]'s petrified body."))
			return
	while(has_petrified_repair_damage())
// OV Edit End

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("[M]'s attack is redirected to [mount]!"))
			mount.attack_animal(M)
			return TRUE
	return ..()

/mob/living/carbon/human/bullet_act(obj/projectile/P)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("The [P] is redirected to [mount]!"))
			return mount.bullet_act(P)
	return ..()
