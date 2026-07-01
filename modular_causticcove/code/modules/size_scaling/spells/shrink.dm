/obj/effect/proc_holder/spell/targeted/touch/sizespell
	name = "Reduce/Grow Person"
	desc = "A basic trick many apprentices would use to prank their master. (( Abuse of this spell for combat purposes will lead to consequences from staff. ))" // Scene tool, shouldnt have combat applications. Maybe have it disable automatically when entering combat mode?
	clothes_req = FALSE
	spell_tier = 1
	recharge_time = 2 MINUTES
	drawmessage = "I prepare to perform a arcyne incantation."
	dropmessage = "I release my arcyne focus."
	overlay_state = "size-change"
	castdrain = 50
	chargetime = 10
	cost = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/sizespell

/obj/item/melee/touch_attack/sizespell
	name = "\improper magic touch"
	desc = "Size altering magics remain ready to unleash in your palm.\n \
	Focus (click) on it to adjust the desired target scale!"
	catchphrase = null
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#33ff00" // this produces green because the icon base is yellow but someone else can fix that if they want
	var/target_scale = 1

/obj/item/melee/touch_attack/sizespell/attack_self(mob/user)
	var/new_target_scale = tgui_input_number(user, "What desired size scale? (Between [RESIZE_MINIMUM * 100] and [RESIZE_MAXIMUM * 100], 100 is normal)", "Target Size", (RESIZE_STANDARD * 100), (RESIZE_MAXIMUM * 100), (RESIZE_MINIMUM * 100), round_value = FALSE)
	if(new_target_scale)
		if(new_target_scale < (RESIZE_MINIMUM * 100) || new_target_scale > (RESIZE_MAXIMUM * 100))
			to_chat(user, "<font color='red'>Value must be between [RESIZE_MINIMUM * 100] and [RESIZE_MAXIMUM * 100].</font>")
			return
		target_scale = (new_target_scale / 100)

/obj/item/melee/touch_attack/sizespell/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(!isliving(target))
		return
	
	var/mob/living/target_live = target
	if(target_scale == target_live.size_multiplier)
		return
	if(target_scale < target_live.size_multiplier) //Reduce
		shrink_target(target, user)
	else //Grow
		grow_target(target, user)

	var/datum/status_effect/buff/sizechanged/size_status = target_live.apply_status_effect(/datum/status_effect/buff/sizechanged)
	if(istype(size_status))
		size_status.original_scale = target_live.size_multiplier
	
	target_live.resize(target_scale, allow_stripping = TRUE) //OV EDIT
	qdel(src)

/obj/item/melee/touch_attack/sizespell/proc/shrink_target(mob/living/target, mob/living/carbon/human/user)
	if(!isliving(target))
		return
	if(user == target)
		user.visible_message(span_notice("[user] rapidly changes in size!"), span_notice("I rapidly shrink down!"))
	else	
		user.visible_message(span_notice("[user] touch [target], and they changes in size!"), span_notice("I touch [target] and they shrink in size!"))

/obj/item/melee/touch_attack/sizespell/proc/grow_target(mob/living/target, mob/living/carbon/human/user)
	if(!isliving(target))
		return
	if(user == target)
		user.visible_message(span_notice("[user] rapidly changes in size!"), span_notice("I rapidly grow bigger!"))
	else	
		user.visible_message(span_notice("[user] touch [target], and they changes in size!"), span_notice("I touch [target] and they grow in size!"))

/datum/status_effect/buff/sizechanged
	var/removable = FALSE
	id = "sizechanged"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sizechanged
	var/original_scale = 1

/datum/status_effect/buff/sizechanged/on_apply()
	. = ..()
	//var/mob/living/target = owner
	spawn(300) //is that how it work? i remember there being a better wait timer but i forgor
		if(owner && istype(owner, /mob/living))
			to_chat(owner, span_userdanger("<span class='big'>You feel like you might be able to return to your size by pressing on the status effect!</span>"))
			removable = TRUE

/datum/status_effect/buff/sizechanged/on_remove()
	var/mob/living/target = owner
	target.resize(original_scale, allow_stripping = TRUE) //OV EDIT
	. = ..()

/atom/movable/screen/alert/status_effect/buff/sizechanged
	name = "Size Altered"
	desc = "I'm not my normal size! (After 30 seconds, you can press this button to return to your original size.)"
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/buff/sizechanged/Click()
	. = ..()
	var/mob/living/L = usr
	if(!istype(L)) // how though
		return
	var/datum/status_effect/buff/sizechanged/effect = L.has_status_effect(/datum/status_effect/buff/sizechanged)
	if(!effect.removable)
		to_chat(L, span_userdanger("<span class='warning'>I can't turn back yet!</span>"))
		return
	L.remove_status_effect(/datum/status_effect/buff/sizechanged)
