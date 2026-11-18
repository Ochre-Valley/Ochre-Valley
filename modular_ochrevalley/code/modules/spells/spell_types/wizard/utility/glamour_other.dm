/obj/effect/proc_holder/spell/targeted/touch/glamourother
	name = "Copy Glamour"
	desc = "A spell favoured by Xylixians and other tricksters to cause a bit of mischief, among other things. The spell's notably weak, only visual and easy to peer through, but even a mere appearance can cause a lot of chaos. Click on the spell in your hand to adjust size scaling. Sneak if you wish to use it silently. \n (( Abuse of this spell for OOC reasons will lead to consequences from staff. ))"
	clothes_req = FALSE
	spell_tier = 1
	recharge_time = 1 MINUTES
	drawmessage = "I prepare to perform a arcyne incantation."
	dropmessage = "I release my arcyne focus."
	overlay_state = "size-change"
	castdrain = 50
	chargetime = 10
	cost = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/glamourother
	sound = 'sound/magic/whiteflame.ogg'

/obj/item/melee/touch_attack/glamourother
	name = "\improper magic touch"
	desc = "Swirling magics ready to copy a person's appearance."
	catchphrase = null
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#87d6f0"
	var/retain_scale = TRUE
/obj/item/melee/touch_attack/glamourother/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(!isliving(target))
		return
	if(!ishuman(target))
		to_chat(user, span_userdanger("<span class='warning'>I need a humen-esque body to copy!</span>"))
		return
	var/mob/living/target_live = target
	if(user.cmode || target_live.cmode) // per request of staff, no using this while in combat
		to_chat(user, span_userdanger("<span class='warning'>These magicks refuse to work while in combat!</span>"))
		return

	if(target_live?.client && !target_live.allow_mimicry)
		to_chat(user, span_userdanger("<span class='warning'>The magicks fly away, refusing to copy this one...</span>"))
		return

	if(!user.m_intent == MOVE_INTENT_SNEAK)
		playsound(loc, 'sound/magic/whiteflame.ogg', 100, FALSE, -1, ignore_walls = FALSE)

	user.apply_status_effect(/datum/status_effect/buff/glamourapplied)
	user.glamourize_sprite(target_live, FALSE, retain_scale)

	qdel(src)
/obj/item/melee/touch_attack/glamourother/attack_self(mob/user)
	var/newscale_option = TRUE

	if(tgui_alert(user, "Retain your current size instead of resetting to 100% size scale?", "Size Glamouring", list("No","Yes")) == "Yes")
		to_chat(user, span_notice("You will retain your current size when you glamour as others."))
		retain_scale = newscale_option
		return
	else
		to_chat(user, span_notice("You will be 'normal' sized when you glamour as others."))
		newscale_option = FALSE
		retain_scale = newscale_option
		return


/datum/status_effect/buff/glamourapplied
	var/removable = FALSE
	var/last_check = 0
	id = "glamourapplied"
	alert_type = /atom/movable/screen/alert/status_effect/buff/glamourapplied

/datum/status_effect/buff/glamourapplied/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	spawn(300) //is that how it work? i remember there being a better wait timer but i forgor
		if(owner && istype(owner, /mob/living))
			to_chat(owner, span_userdanger("<span class='big'>You feel like you might be able to return to your original appearance by pressing on the status effect!</span>"))
			removable = TRUE

/datum/status_effect/buff/glamourapplied/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner.glamourize_sprite(null,TRUE)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/glamourapplied
	name = "Appearance Altered"
	desc = "I've taken on the guise of someone else! (After 30 seconds, you can press this button to return to your original size.)"
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/buff/glamourapplied/Click()
	. = ..()
	var/mob/living/L = usr
	if(!istype(L)) // how though
		return
	var/datum/status_effect/buff/glamourapplied/effect = L.has_status_effect(/datum/status_effect/buff/glamourapplied)
	if(!effect.removable)
		to_chat(L, span_userdanger("<span class='warning'>I can't turn back yet!</span>"))
		return
	L.remove_status_effect(/datum/status_effect/buff/glamourapplied)

/datum/status_effect/buff/glamourapplied/proc/on_life()
	SIGNAL_HANDLER
	if(world.time < last_check + 10 SECONDS)
		return
	last_check = world.time
	var/mob/living/carbon/human/human_user = owner //Cast to human!
	if(!istype(human_user))
		return

	if(human_user.cmode) //Check if the player is in combat mode
		to_chat(human_user, span_userdanger("<span class='warning'>I can't maintain this guise in combat!</span>"))
		human_user.remove_status_effect(/datum/status_effect/buff/glamourapplied)

//might want to split these into other .dms but eh
/obj/item/book/granter/spell/bonechill/glamourcopy
	name = "Scroll of Copy Glamour"
	spell = /obj/effect/proc_holder/spell/targeted/touch/glamourother
	spellname = "Copy Glamour"
	icon_state ="scrolldarkred"
	oneuse = TRUE
	remarks = list()

/obj/item/book/granter/spell/bonechill/glamourcopy/loadout // Loadout specific ones!
	needLit = FALSE
	pages_to_mastery = 0 //OV Edit: reads faster


/datum/loadout_item/copyglamour //I'd have this even further up the list if I could, but I don't want to needlessly edit the Azure loadouts
	name = "Scroll of Copy Glamour"
	path = /obj/item/book/granter/spell/bonechill/glamourcopy/loadout

/datum/supply_pack/rogue/kink_toy/copy_glamour
	name = "Scroll of Copy Glamour"
	cost = 20
	contains = list(/obj/item/book/granter/spell/bonechill/glamourcopy)

/datum/supply_pack/rogue/luxury/copyglamour
	name = "Scroll of Copy Glamour"
	cost = 15
	contains = list(/obj/item/book/granter/spell/bonechill/glamourcopy)
