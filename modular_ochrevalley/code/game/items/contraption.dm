/obj/item/rogueweapon/contraption/linker/mace
	var/demomod = 0.05 //amount of a structure destroyed with a single hit
	special = /datum/special_intent/dissassemble
	associated_skill = /datum/skill/combat/maces

/datum/intent/mace/demolish/lesser //defined downstream as I remove demolish from wrenches upstream.
	desc = "A deliberate structure-breaking blow. Deals bonus damage equal to a percentage of a target structure's maximum integrity."
	demolition_mod = 2.5

/obj/item/rogueweapon/contraption/linker/mace/preloaded
	current_charge = 80

/obj/item/rogueweapon/contraption/linker/mace/big/preloaded
	current_charge = 80

/datum/special_intent/dissassemble
	name = "Dissassemble"
	desc = "Try to catch one of the target's limbs with your weapons, immobilizing both of you. After a mote of work, use your engineering skill to attempt to twist the limb- removing mechanical or otherwise loose limbs from vulnerable or unarmored targets, and attempting to dislocate otherwise."
	tile_coordinates = list(list(0,0))
	post_icon_state = "aimwarn"
	pre_icon_state = "trap"
	respect_adjacency = TRUE
	delay = 0.6 SECONDS //not a long delay, but perhaps too long. This can be countered easily by kicking the attacker
	cooldown = 30 SECONDS
	stamcost = 25
	custom_skill = /datum/skill/craft/engineering
	var/dam = 10 //applies this, and then this again, multiplied by five, through armor.
	var/wrenchdelay = 1.2 SECONDS

/datum/special_intent/dissassemble/apply_hit(turf/T)
	var/list/targets = list()
	var/target_zone = get_aimed_zone(howner)
	var/vulnerableto = FALSE
	for(var/mob/living/L in get_hearers_in_view(0, T)) //prioritize based on what mobs we'll hurt the most, as we'll choose one target in the end
		var/priority = 1
		if(L == howner)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(HAS_TRAIT(L, TRAIT_IRONMAN))
				priority = 5
			else
				var/obj/item/bodypart/bodypart = H.get_bodypart(target_zone)
				if(bodypart && !QDELETED(bodypart))
					if(bodypart.rotted || bodypart.skeletonized || HAS_TRAIT(L, TRAIT_EASYDISMEMBER))
						priority = 3
					if(bodypart.status == BODYPART_ROBOTIC)
						priority = 5
		else if(L.mob_biotypes & MOB_ROBOTIC)
			priority = 2
		if(L.stat)
			priority = min(0, priority - 3)
		else if(!(L.mobility_flags & MOBILITY_STAND))
			priority = min(0, priority - 1)
		targets[L] = priority
	targets = sortTim(targets, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	var/mob/living/finaltarget
	if(targets.len)
		finaltarget = targets[1]
	if(finaltarget)
		if(finaltarget.has_status_effect(/datum/status_effect/debuff/exposed) || finaltarget.has_status_effect(/datum/status_effect/debuff/vulnerable))
			vulnerableto = TRUE
		apply_generic_weapon_damage(finaltarget, dam, "blunt", target_zone, bclass = BCLASS_TWIST, no_pen = TRUE)
		playsound(finaltarget.loc, 'sound/items/bsmithfail.ogg', 100, TRUE)
		howner.Immobilize(wrenchdelay)
		finaltarget.Immobilize(wrenchdelay)
		howner.changeNext_move(wrenchdelay) //you don't get to do anything until you finish the move
		addtimer(CALLBACK(src, PROC_REF(wrenchlimb), finaltarget, target_zone, vulnerableto), wrenchdelay)
		if(ishuman(finaltarget))
			var/mob/living/carbon/human/humantarget = finaltarget
			var/obj/item/bodypart/bodyparttarget = humantarget.get_bodypart(target_zone)
			if(bodyparttarget && !QDELETED(bodyparttarget))
				finaltarget.visible_message(span_warning("[howner] clamps [iparent] around [humantarget]'s [bodyparttarget]!"), span_userdanger("[howner] clamps [iparent] around your [bodyparttarget]!"))
				var/obj/item/clothing/prot = humantarget.get_best_worn_armor(target_zone, "blunt")
				if(prot)
					var/armoramount = prot.armor.getRating("blunt")
					if(armoramount >= DR_LIGHT) //nearly any blunt protection. This wrenches plate as good as it does robots, though
						vulnerableto = TRUE
					else if(armoramount <= DR_SUPER) //good, padded armor nosells the vulnerability completely
						vulnerableto = FALSE
			else
				finaltarget.visible_message(span_warning("[howner] clamps [iparent] around [humantarget]!"), span_userdanger("[howner] clamps [iparent] around you!"))
		else
			finaltarget.visible_message(span_warning("[howner] clamps [iparent] around [finaltarget]!"), span_userdanger("[howner] clamps [iparent] around you!"))
	..()

/datum/special_intent/dissassemble/proc/wrenchlimb(var/mob/living/target, target_zone, vulnerable = FALSE)
	var/userstrength = max(0, howner.STASTR - 10)
	var/robottarget = FALSE
	var/trydismember = FALSE
	var/realdamage = dam
	if(get_dist(howner, target) > 1)//keep close to the target
		howner.visible_message(span_warning("[howner] lost their grip on [target]!"), span_userdanger("You've lost your grip on [target]!"))
		return FALSE
	if(howner.stat != CONSCIOUS || howner.IsParalyzed() || howner.IsStun() || QDELETED(howner) || !isturf(howner.loc) || !(howner.mobility_flags & MOBILITY_STAND))
		howner.visible_message(span_warning("[howner] lost their grip on [target]!"), span_userdanger("You've lost your grip on [target]!"))
		return FALSE //don't lose your sight of the target
	if(isitem(iparent))
		var/obj/item/I = iparent
		if(!locate(I) in howner.held_items)
			howner.visible_message(span_warning("[howner] lost their grip on [I]!"), span_userdanger("You've lost your grip on [I]!"))
			return
		if(I.gripped_intents && I.wielded)
			userstrength += 2 //the big wrench is more effective at this attack, it gets more leverage when wielded
		realdamage = get_complex_damage(I, howner)
	if(ishuman(target))
		var/mob/living/carbon/H = target
		apply_generic_weapon_damage(H, realdamage * 2, "blunt", target_zone, bclass = BCLASS_TWIST, full_pen = TRUE)//simple, really. this is all that's applied
		var/obj/item/bodypart/bodypart = H.get_bodypart(target_zone)
		if(bodypart && !QDELETED(bodypart))
			if(bodypart.status == BODYPART_ROBOTIC || HAS_TRAIT(target, TRAIT_IRONMAN))
				robottarget = TRUE
				trydismember = TRUE
			if(bodypart.rotted || bodypart.skeletonized || HAS_TRAIT(target, TRAIT_EASYDISMEMBER))
				trydismember = TRUE
			if(trydismember)
				if(robottarget)
					userstrength += howner.get_skill_level(/datum/skill/craft/engineering)
				if(!vulnerable)
					userstrength = min(5, userstrength / 2)
				var/attemptforce = realdamage * min(userstrength, 10)
				if(prob(bodypart.dismemberment_chance_from_force(attemptforce))) //checks chance to dismember.
					if(istype(bodypart, /obj/item/bodypart/head) || istype(bodypart, /obj/item/bodypart/chest)) //we don't decap or disembowel.
						apply_generic_weapon_damage(H, realdamage, "blunt", target_zone, bclass = BCLASS_TWIST, full_pen = TRUE) //instead, just do another damage proc
					else if(bodypart.dismember(BRUTE, BCLASS_TWIST, howner, damage = attemptforce))//armor is checked in this proc. if there's armor, we don't get the dismember. this can, however, deal particularly nasty damage to armor with poor blunt protection
						if(robottarget)
							playsound(howner.loc, 'sound/items/beartrap2.ogg', 100, FALSE)
						else
							playsound(howner.loc, 'sound/items/beartrap.ogg', 100, FALSE)
						H.visible_message(span_warning("[howner] twists [H]'s [bodypart] clean off!"), span_userdanger("[howner] tears [bodypart] from your body!"))
						return TRUE
			playsound(howner.loc, 'sound/items/garrotebreak.ogg', 100, FALSE)
			H.visible_message(span_warning("[howner] twists [H]'s [bodypart] with [iparent]!"), span_userdanger("[howner] painfully twists your [bodypart] with [iparent]!"))
	else  //simplemob! we deal double damage, with a bonus against equivalent biotypes
		realdamage *= 2
		if(target.mob_biotypes & MOB_ROBOTIC) //theoretically, very powerful. In practice, there are no robotic simplemobs.
			realdamage *= howner.get_skill_level(/datum/skill/craft/engineering)
		else if(target.mob_biotypes & MOB_UNDEAD) //things that'd normally have easydismember as carbons take more damage
			realdamage *= 1.5 //equivalent to dismember chance bonus from easydismember, and the damage boost recieved from hitting a torso dismember!
		apply_generic_weapon_damage(target, realdamage, "blunt", target_zone, bclass = BCLASS_TWIST, full_pen = TRUE)


/obj/item/rogueweapon/contraption/linker/mace/attack_turf(turf/T, mob/living/user, multiplier)
	. = ..()
	if(. && istype(user?.used_intent, /datum/intent/mace/demolish))
		demolish_turf(T, user)

/obj/item/rogueweapon/contraption/linker/mace/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(. && istype(user?.used_intent, /datum/intent/mace/demolish))
		demolish_obj(O, user)

/obj/item/rogueweapon/contraption/linker/mace/proc/demolish_turf(turf/T, mob/living/user)
	if(QDELETED(T))
		return FALSE

	if(isnull(T.max_integrity))
		return FALSE

	if(T.max_integrity > 3000)
		to_chat(user, "Too hard, sire!")
		return FALSE

	var/bonus_damage = round(T.max_integrity * demomod)

	T.take_damage(bonus_damage, BRUTE, d_type, 1)
	to_chat(user, span_warning("Your blow expertly caves into [T]! (+[bonus_damage])"))
	return TRUE

/obj/item/rogueweapon/contraption/linker/mace/proc/demolish_obj(obj/O, mob/living/user)
	if(QDELETED(O))
		return FALSE

	if(isnull(O.max_integrity))
		return FALSE

	if(O.max_integrity > 3000)
		to_chat(user, "Too hard, sire!")
		return FALSE

	var/bonus_damage = round(O.max_integrity * demomod)

	O.take_damage(bonus_damage, BRUTE, d_type, 1)
	to_chat(user, span_warning("Your blow expertly caves into [O]! (+[bonus_damage])"))
	return TRUE
