/datum/action/cooldown/spell/bind_item
	name = "Bind Item"
	desc = "Make your currently held item the item for your dormancy vice."
	click_to_activate = FALSE

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_time = 6 SECONDS
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/bind_item/can_cast_spell(feedback)
	if(istype(owner.loc, /obj/item)) //Do we care if you can untransform yourself? I don't think so.
		var/obj/item/the_item = owner.loc
		if(the_item.mob_possession) //Again, stop micros or soulgemmed people
			return TRUE //Does this mean we don't check a bunch of shit? Yeah, but the spell has no cost, and the rest doesn't matter if they're in an item.
	. = ..()

/datum/action/cooldown/spell/bind_item/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/datum/charflaw/dormancy/cf = H.get_flaw(/datum/charflaw/dormancy)
	if(!cf)
		to_chat(usr, "You do not have the vice this ability is associated with!")
	if(!cf.target)
		var/obj/item/the_item = H.get_active_held_item()
		if(!the_item)
			to_chat(usr, "No item in hand!")
			return FALSE
		if(istype(the_item, /obj/item/holder/micro) || istype(the_item, /obj/item/melee/new_touch_attack) || istype(the_item, /obj/item/melee/touch_attack) || istype(the_item, /obj/item/handmirror/magic))
			to_chat(usr, "Invalid item!")
			return FALSE
		var/datum/component/conjured_item/isConjured = the_item.GetComponent(/datum/component/conjured_item)
		if(isConjured)
			to_chat(usr, "Cannot bind to a conjured item!")
			return FALSE
		cf.target = the_item
		the_item.forceMove(H)
		name = "Enter/Leave Dormancy"
		desc = "Go into or leave your dormant state."
	else
		if(isturf(H.loc))
			cf.target.forceMove(H.loc)
			H.forceMove(cf.target)
			cf.target.visible_message(span_warning("[cf.target] glows momentarily, before their form morphs into that of [cf.target]!"))
			cf.target.mob_possession = H
		else if(H.loc == cf.target)
			if(H.energy <= H.max_energy/2)
				to_chat(usr, span_warning("You lack the energy to return to your active form!"))
				return FALSE
			else
				H.forceMove(get_turf(cf.target))
				cf.target.forceMove(H)
				cf.target.visible_message(span_warning("[cf.target] glows momentarily, before its form morphs into that of [H]!"))
				cf.target.mob_possession = null
		else
			to_chat(usr, span_warning("You are unable to revert to your dormant state at this moment!"))
			return FALSE

/datum/stressevent/unbound
	timer = 6 MINUTES
	stressadd = 7
	desc = span_red("Without an item to retreat to, my mind feels lost and muddled!")

/datum/status_effect/debuff/unbound
	id = "unbound"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/unbound
	effectedstats = list(STATKEY_WIL = -3,STATKEY_INT = -2)
	duration = 200

/atom/movable/screen/alert/status_effect/debuff/unbound
	name = "Unbound"
	desc = "I must bind an item to myself!"
	icon_state = "debuff"

