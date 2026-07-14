// OV File

/datum/intent/shoot/arquebus
    chargetime = 1 // Fallback value if something that isn't a mob/living aims this.
    chargedrain = 0

/datum/intent/shoot/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem]!"))
		playsound(mastermob, pick('sound/foley/equip/rummaging-01.ogg'), 100, FALSE)

/datum/intent/shoot/arquebus/get_chargetime()
	if(mastermob) // chargetime isn't used here. Returning chargetime if it's falsy doesn't make any sense either.
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4.6 // skill block
		newtime -= mastermob.STAPER // per block
		return max(newtime, 1) // Master skill and 16 PER will hit the aim time floor.
	return chargetime

/datum/intent/arc/arquebus
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/arquebus/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem] for a precise shot!"))
		playsound(mastermob, pick('sound/foley/equip/rummaging-01.ogg'), 100, FALSE)

/datum/intent/arc/arquebus/get_chargetime()
	if(mastermob)
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4.6
		newtime -= mastermob.STAPER
		return max(newtime, 12) // Raise the aim time floor like bow arc, instead of raising the floor and making it much faster to reach it like crossbow arc.
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/get_npc_chargetime(mob/living/user)
	// Same logic as the normal chargetime proc, but we are given a user in the params.
	var/newtime = 40
	newtime -= user.get_skill_level(/datum/skill/combat/firearms) * 4.6
	newtime -= user.STAPER
	return max(newtime, 1) * ARCHER_NPC_ROF_PENALTY // NPCs shoot slower than players though.
	
/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/
	name = "arquebus rifle"
	desc = "A gunpowder weapon that shoots an armor piercing metal ball."
	icon = 'modular_causticcove/icons/weapons/arquebus.dmi'
	dam_icon = 'icons/effects/item_damage64.dmi'
	icon_state = "arquebus"
	item_state = "arquebus"
	dropshrink = 0.6 // OV Edit, I think this might look nicer.
	force = 10
	force_wielded = 15
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/arquebus, /datum/intent/arc/arquebus, /datum/intent/buttstroke)
	internal_magazine = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/arquebus
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 4 SECONDS
	can_parry = TRUE
	minstr = 6
	walking_stick = TRUE
	experimental_onback = TRUE
	flags_ai_inventory = AI_ITEM_GUN
	cartridge_wording = "musketball"
	load_sound = 'modular_causticcove/sound/arquebus/musketload.ogg'
	fire_sound = "modular_causticcove/sound/arquebus/arquefire.ogg"
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK // You need to be able to hit it to repair it. Adding other rogueweapon tags too.
	max_integrity = 250
	integrity_failure = 0.2
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	pickup_sound = 'modular_causticcove/sound/sheath_sounds/draw_from_holster.ogg'
	var/spread_num = 10
	damfactor = 2
	var/range = 30
	var/onehanded = FALSE
	var/reloaded = FALSE
	var/load_time = 50
	var/gunpowder = FALSE
	var/obj/item/ramrod/myrod = null
	var/gunchannel

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/examine(mob/user)
	. = ..()
	if(reloaded && chambered)
		. += span_notice("It is loaded with [chambered] and ready to fire!")
	else if(chambered)
		. += span_notice("It is loaded with [chambered]. It still needs to be tamped down")
		if(myrod)
			. += span_notice("The ramrod can be retrieved by right-clicking [src] with an empty hand")
	else if(gunpowder)
		. += span_notice("It's filled with powder, and ready for shot!")
	else
		. += span_notice("It's empty. It can be filled with a Powder Flask.")


/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Black powder weapons increase in accuracy with a higher <b>PERCEPTION</b>, but deal a static amount of damage \
	regardless of character stats.")
	. += span_info("Black powder weapons must be loaded with powder, then a bullet, which must then be forced down the barrel with a ramrod.")
	. += span_info("Most black powder weapons come with a ramroad stored on them, which can be pulled out with a right click from an empty hand. They can be stored back on the weapon by left clicking them when there isn't a bullet that needs ramming down.")
	. += span_info("The weapon's ramrod may be used to unload the weapon, by right-clicking on it while it's loaded.")
	if(onehanded)
		. += span_info("This weapon can be used in one hand, at the penalty of aim time.")

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_AFTER_STORAGE_INSERT, PROC_REF(checkstoragevalidity))
	RegisterSignal(src, COMSIG_AFTER_STORAGE_REMOVE, PROC_REF(checkstoragevalidity))
	myrod = new /obj/item/ramrod(src)
	
/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/Destroy()
	UnregisterSignal(src, COMSIG_AFTER_STORAGE_INSERT)
	UnregisterSignal(src, COMSIG_AFTER_STORAGE_REMOVE)
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	fire_sound = pick(
		"modular_causticcove/sound/arquebus/arquefire.ogg",
		"modular_causticcove/sound/arquebus/arquefire2.ogg",
		"modular_causticcove/sound/arquebus/arquefire3.ogg",
		"modular_causticcove/sound/arquebus/arquefire4.ogg",
		"modular_causticcove/sound/arquebus/arquefire5.ogg",
	)
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/shoot_with_empty_chamber()
	playsound(src.loc, 'modular_causticcove/sound/arquebus/musketcock.ogg', 100, FALSE)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/firearm_skill = (user?.mind ? user.get_skill_level(/datum/skill/combat/firearms) : 1)
	spread = (spread_num - firearm_skill)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		BB.damage = BB.damage * damfactor
		BB.range = range
	gunpowder = FALSE
	reloaded = FALSE
	..()
	new /obj/effect/particle_effect/sparks/muzzle(get_ranged_target_turf(user, user.dir, 1))
	spawn (5)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
	spawn (10)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
	spawn (16)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
	for(var/mob/M in range(5, user))
		if(!M.stat)
			shake_camera(M, 3, 1)

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded) //Trying to unwield it
		ungrip(user)
		return
	if(gripped_intents)
		wield(user)
	update_icon()


/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/proc/checkstoragevalidity(datum/source, obj/storage_master, mob/user, datum/storage_datum)
	var/force_unload = FALSE
	if(istype(storage_master, /obj/item/storage))
		var/obj/item/storage/str = storage_master
		force_unload = str.force_stored_weapon_unload
	else if(istype(storage_master, /obj/item/clothing))
		var/obj/item/clothing/clth = storage_master
		force_unload = clth.force_stored_weapon_unload
	if(force_unload)
		unload()

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/proc/unload(mob/user)
	if(gunpowder)
		gunpowder = FALSE
		reloaded = FALSE
		if(chambered)
			if(user)
				user.visible_message(span_notice("[user] unloads the [chambered] from [src]."))
			else
				visible_message(span_notice("[chambered] spills from [src]'s barrel!"))
			LAZYREMOVE(magazine.stored_ammo, chambered)
			chambered.forceMove(get_turf(src))
			chambered = null
			return TRUE
		if(user)
			user.visible_message(span_notice("[user] unloads the powder from [src]."))
			return TRUE
		visible_message(span_notice("Powder spills from [src]'s barrel!"))
		return TRUE
	return FALSE


/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/attack_right(mob/user)
	var/held_item = user.get_active_held_item()
	if(held_item)
		if(istype(held_item, /obj/item/ramrod) && (chambered || gunpowder))
			to_chat(user, span_notice("I begin to unload the [src]!"))
			user.visible_message(span_notice("[user] begins rooting [user.get_active_held_item()] around in the barrel of the [src]."))
			playsound(src, 'modular_causticcove/sound/arquebus/ramrod.ogg',  100)
			if(do_after(user, load_time, src))
				user.visible_message(span_notice("[user] unloads [src]."))
				unload(user)
		return
	else
		if(myrod)
			playsound(src, "sound/items/sharpen_short1.ogg",  100)
			to_chat(user, span_notice("I draw the ramrod from [src]!"))
			var/obj/item/ramrod/AM
			for(AM in src)
				user.put_in_hands(AM)
				myrod = null
		else
			to_chat(user, span_warning("There is no rod stowed in [src]!"))

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/attackby(obj/item/A, mob/living/carbon/user, params) // Reloading code for rifle
	if (gunchannel) // If you send null, you're going to stop all sound channels!
		user.stop_sound_channel(gunchannel)
	var/firearm_skill = (user?.mind ? user.get_skill_level(/datum/skill/combat/firearms) : 1)
	var/load_time_skill = load_time - (load_time * firearm_skill / 10) // 10% faster for each skill level
	gunchannel = SSsounds.random_available_channel()

	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(user.get_inactive_held_item() != src && user.get_active_held_item() != src) // You have to hold it to load it.
			return
		if(chambered)
			to_chat(user, span_warning("There is already [chambered] in [src]!"))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill [src] with gunpowder first!"))
			return
		if(!istype(A, /obj/item/ammo_casing/caseless/rogue/bullet))
			to_chat(user, span_warning("[A] cannot be fired from [src]."))
			return
		playsound(src, 'modular_causticcove/sound/arquebus/musketload.ogg',  100)
		user.visible_message(span_notice("[user] forces [A] down the barrel of [src]."))

	if(istype(A, /obj/item/powderflask))
		if(user.get_inactive_held_item() != src) // You have to hold it to load it.
			return
		if(gunpowder)
			user.visible_message(span_notice("[src] is already filled with gunpowder!</span>"))
			return
		playsound(src, 'modular_causticcove/sound/arquebus/pour_powder.ogg',  100)
		if(do_after(user, load_time_skill, src))
			user.visible_message(span_notice("[user] fills [src] with gunpowder.</span>"))
			gunpowder = TRUE
		return
	if(istype(A, /obj/item/ramrod))
		var/obj/item/ramrod/R=A
		if(!reloaded && chambered)
			if(user.get_inactive_held_item() != src) // You have to hold it to load it.
				return
			user.visible_message(span_notice("[user] begins ramming the [R] down the barrel of [src]."))
			playsound(src, 'modular_causticcove/sound/arquebus/ramrod.ogg',  100)
			if(do_after(user, load_time_skill, src))
				user.visible_message(span_notice("[user] has finished reloading [src]."))
				reloaded = TRUE
			return
		if(reloaded && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, 'modular_causticcove/sound/sheath_sounds/put_back_dagger.ogg',  100)
			user.visible_message(span_notice("[user] stows [R] under the barrel of [src]."))
		if(!chambered && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, 'modular_causticcove/sound/sheath_sounds/put_back_dagger.ogg',  100)
			user.visible_message(span_notice("[user] stows [R] under the barrel of [src] without chambering it."))
		if(!myrod == null)
			to_chat(user, span_warning("There's already a [R] inside of [src]."))
			return
	user.stop_sound_channel(gunchannel)
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/can_shoot()
	if (!reloaded)
		return FALSE
	return ..()

/datum/intent/shoot/arquebus/pistol
    chargetime = 1
    chargedrain = 0

/datum/intent/shoot/arquebus/pistol/can_charge()
    return TRUE

/datum/intent/shoot/arquebus/pistol/get_chargetime()
	if(mastermob)
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4 // skill block
		newtime -= mastermob.STAPER // per block
		if(mastermob.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item()) // If slurbows don't care if your other arm is disabled, I guess pistols don't either.
			newtime *= 1.5 // It takes longer to aim one-handed.
		return max(newtime, 1) // Legendary and 15 PER will hit the aim time floor.
	return chargetime

/datum/intent/arc/arquebus/pistol
    chargetime = 12
    chargedrain = 0

/datum/intent/arc/arquebus/pistol/can_charge()
	return TRUE

/datum/intent/arc/arquebus/pistol/get_chargetime()
	if(mastermob)
		var/newtime = 40
		newtime -= mastermob.get_skill_level(/datum/skill/combat/firearms) * 4
		newtime -= mastermob.STAPER
		if(mastermob.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item())
			newtime *= 1.5
		return max(newtime, 12)
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol/get_npc_chargetime(mob/living/user)
	var/newtime = 40
	newtime -= user.get_skill_level(/datum/skill/combat/firearms) * 4
	newtime -= user.STAPER
	if(user.get_num_arms(FALSE) < 2 || user.get_inactive_held_item())
		newtime *= 1.5
	return max(newtime, 1) * ARCHER_NPC_ROF_PENALTY

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
	name = "arquebus pistol"
	icon = 'icons/roguetown/weapons/32.dmi'
	dam_icon = 'icons/effects/item_damage32.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	force_wielded = null
	possible_item_intents = list(/datum/intent/shoot/arquebus/pistol, /datum/intent/arc/arquebus/pistol, /datum/intent/mace/strike/wood)
	gripped_intents = null
	pixel_y = 0
	pixel_x = 0
	bigboy = FALSE
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	equip_delay_self = 1.5 SECONDS
	unequip_delay_self = 1.5 SECONDS
	inv_storage_delay = 2 SECONDS
	walking_stick = FALSE
	max_integrity = 80
	slot_flags = ITEM_SLOT_HIP
	range = 10
	onehanded = TRUE
	var/can_spin = TRUE
	var/last_spunned
	var/spin_cooldown = 3 SECONDS

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol/getonmobprop(tag)
    . = ..()
    if(tag)
        switch(tag)
            if("gen")
                return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
            if("onbelt")
                return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol/attack_self(mob/living/user)
	var/string = "smoothly"
	var/list/strings_noob = list("unsurely", "nervously", "anxiously", "timidly", "shakily", "clumsily", "fumblingly", "awkwardly")
	var/list/strings_moderate = list("smoothly", "confidently", "determinately", "calmly", "skillfully", "decisively")
	var/list/strings_pro = list("masterfully", "expertly", "flawlessly", "elegantly", "artfully", "impeccably")
	var/firearm_skill = (user?.mind ? user.get_skill_level(/datum/skill/combat/firearms) : 1)
	var/noob_spin_sound = 'sound/combat/weaponr1.ogg'
	var/pro_spin_sound = 'modular_causticcove/sound/arquebus/gunspin.ogg'
	var/spin_sound
	if(firearm_skill <= 2)
		string = pick(strings_noob)
		spin_sound = noob_spin_sound
	if((firearm_skill > 2) && (firearm_skill <= 4))
		string = pick(strings_moderate)
		spin_sound = pro_spin_sound
	if((firearm_skill > 4) && (firearm_skill <= 6))
		string = pick(strings_pro)
		spin_sound = pro_spin_sound
	if(world.time > last_spunned + spin_cooldown)
		can_spin = TRUE
	if(can_spin)
		user.play_overhead_indicator('icons/effects/effects.dmi', "emote", 10, OBJ_LAYER)
		user.visible_message("<span class='emote'>[user] spins [src] around their fingers [string]!</span>")
		playsound(src, spin_sound, 100, FALSE, ignore_walls = FALSE)
		last_spunned = world.time
		/*if(firearm_skill <= 2)
			if(prob(35))
				shoot_live_shot(message = 0)
				user.visible_message("<span class='danger'>[user] accidentally discharges [src]!</span>")*/ // This is supposed to make the gun go off but someone forgot what they were doing while writing it I guess.
		if(firearm_skill <= 3)
			if(prob(50))
				user.visible_message(span_danger("[user] accidentally drops [src]!"))
				user.dropItemToGround(src)
		can_spin = FALSE

/obj/item/quiver/bulletpouch/attackby(obj/A, loc, params)
	// /obj/item/quiver/attackby(obj/A, loc, params) already handles feeding ammo to the pouch.
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/B = A
		if(arrows.len && B.gunpowder && !B.chambered)
			var/obj/item/ammo_casing/caseless/rogue/AR = pick_ammo(/obj/item/ammo_casing/caseless/rogue/bullet)
			if(AR)
				arrows -= AR
				B.attackby(AR, loc, params)
				if(ismob(loc))
					var/mob/M = loc
					if(HAS_TRAIT(M, TRAIT_COMBAT_AWARE))
						M.balloon_alert(M, "[length(arrows)] left...")
		return
	..()

/obj/item/storage
	var/force_stored_weapon_unload = TRUE

/obj/item/clothing
	var/force_stored_weapon_unload = TRUE

/* Definitions for if someone wants to allow guns into belts, cloaks, or what have you later. I've erred on the side of conservative for now
/obj/item/clothing/cloak
	force_stored_weapon_unload = FALSE

/obj/item/storage/belt
	force_stored_weapon_unload = FALSE
*/
