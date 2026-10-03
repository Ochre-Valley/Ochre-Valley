
//an unholy amalgam of spell/touch and rogueweapons. 
//what follows below is blatant and totally cringe copypasta
/datum/action/cooldown/spell/abstractweapon

	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE
	charge_required = FALSE
	has_visual_effects = FALSE
	click_to_activate = FALSE

	/// Typepath of what hand we create on initial cast.
	var/obj/item/rogueweapon/abstractweapon/hand_path = /obj/item/rogueweapon/abstractweapon/
	/// Ref to the hand we currently have deployed.
	var/obj/item/rogueweapon/abstractweapon/attached_hand
	/// The message displayed to the person upon creating the touch hand
	var/draw_message = "looks confused. Contact a coder!" //formated as [user] [message]
	/// The message displayed upon willingly dropping / deleting / cancelling the touch hand before using it
	var/drop_message = "goes back to normal."//formated as [user] [message]

/datum/action/cooldown/spell/abstractweapon/Destroy()
	// If we have an owner, the hand is cleaned up in Remove(), which Destroy() calls.
	if(!owner)
		QDEL_NULL(attached_hand)
	return ..()

/datum/action/cooldown/spell/abstractweapon/Remove(mob/living/remove_from)
	remove_hand(remove_from)
	return ..()

// PreActivate is overridden to not check is_valid_target on the caster, as it makes less sense.
/datum/action/cooldown/spell/abstractweapon/PreActivate(atom/target)
	return Activate(target)

/datum/action/cooldown/spell/abstractweapon/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return !!attached_hand

/datum/action/cooldown/spell/abstractweapon/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	if(!(carbon_owner.mobility_flags & MOBILITY_USE))
		return FALSE
	return TRUE

/**
 * Creates a new hand_path hand and equips it to the caster.
 *
 * If the equipping action fails, reverts the cooldown and returns FALSE.
 * Otherwise, registers signals and returns TRUE.
 */
/datum/action/cooldown/spell/abstractweapon/proc/create_hand(mob/living/carbon/cast_on)
	SHOULD_CALL_PARENT(TRUE)
	if(cast_on.get_num_arms() > 1)
		if(cast_on.active_hand_index != cast_on.domhand)
			cast_on.swap_hand() //we always want to be using the dominant hand if it's free
	var/obj/item/rogueweapon/abstractweapon/new_hand = new hand_path(cast_on, src)
	var/twohands = new_hand.twohands_required
	if(cast_on.get_num_arms() == 1)
		to_chat(owner, span_userdanger("get arms = 1"))
		new_hand.twohands_required = FALSE //in the specific situation that you're too crippled, you are assumed to be trained one-handed
		twohands = FALSE
	if(!cast_on.put_in_hands(new_hand, del_on_fail = TRUE))
		reset_spell_cooldown()
		to_chat(cast_on, span_warning("My hands are full!"))
		if(!QDELETED(new_hand))
			QDEL_NULL(new_hand)
	if(twohands)
		new_hand.wield(cast_on)
		if(!new_hand.wielded)
			to_chat(cast_on, span_warning("This stance requires use of both hands!"))
			reset_spell_cooldown()
			if(!QDELETED(new_hand))
				QDEL_NULL(new_hand)
			return FALSE

	attached_hand = new_hand
	new_hand.afterequip(cast_on)
	register_hand_signals()
	cast_on.visible_message(span_alert("[cast_on] [draw_message]"))
	return TRUE

/**
 * Unregisters any signals and deletes the hand currently summoned by the spell.
 *
 * If reset_cooldown_after is TRUE, we will additionally refund the cooldown of the spell.
 * If reset_cooldown_after is FALSE, we will instead just start the spell's cooldown
 */
/datum/action/cooldown/spell/abstractweapon/proc/remove_hand(mob/living/hand_owner, reset_cooldown_after = FALSE)
	if(!QDELETED(attached_hand))
		unregister_hand_signals()
		hand_owner?.temporarilyRemoveItemFromInventory(attached_hand)
		QDEL_NULL(attached_hand)
	owner.visible_message(span_alert("[hand_owner] [drop_message]"))
	attached_hand = null
	StartCooldown()
	build_all_button_icons()

/// Registers all signal procs for the hand.
/datum/action/cooldown/spell/abstractweapon/proc/register_hand_signals()
	SHOULD_CALL_PARENT(TRUE)
	RegisterSignal(attached_hand, COMSIG_PARENT_QDELETING, PROC_REF(on_hand_deleted))
	RegisterSignal(attached_hand, COMSIG_ITEM_DROPPED, PROC_REF(on_hand_dropped))

/// Unregisters all signal procs for the hand.
/datum/action/cooldown/spell/abstractweapon/proc/unregister_hand_signals()
	SHOULD_CALL_PARENT(TRUE)

	UnregisterSignal(attached_hand, list(
		// COMSIG_ITEM_AFTERATTACK,
		COMSIG_PARENT_QDELETING,
		COMSIG_ITEM_DROPPED,
	))

/datum/action/cooldown/spell/abstractweapon/cast(mob/living/carbon/cast_on)
	if(!QDELETED(attached_hand) && (attached_hand))
		remove_hand(cast_on, reset_cooldown_after = TRUE)
		return

	create_hand(cast_on)

	return ..()
B
/datum/action/cooldown/spell/abstractweapon/proc/on_hand_deleted(datum/source)
	SIGNAL_HANDLER

	remove_hand(owner, reset_cooldown_after = TRUE)

/**
 * Signal proc for [COMSIG_ITEM_DROPPED] from our attached hand.
 *
 * unused due to the base type having del_on_drop, but may come in handy
 */
/datum/action/cooldown/spell/abstractweapon/proc/on_hand_dropped(datum/source, mob/living/dropper)
	SIGNAL_HANDLER
	return

/**
 * Spell weapon!
 *
 * When used as intended, should carry most effects of a 
 */
/obj/item/rogueweapon/abstractweapon
	name = "\improper abstract weapon"
	desc = "You shouldn't be wielding this. Tell a coder! "
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE //by default, use both hands
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	max_blade_int = 900
	max_integrity = 900
	smeltresult = null
	/// A weakref to what spell made us.
	var/datum/weakref/spell_which_made_us
	var/mob/living/owner

	var/datum/action/cooldown/spell/abstractweapon/creating_spell

/obj/item/rogueweapon/abstractweapon/New(loc, datum/action/cooldown/spell/abstractweapon/spell)
	creating_spell = spell
	..()

/obj/item/rogueweapon/abstractweapon/proc/afterequip(mob/living/carbon/user)
	SHOULD_CALL_PARENT(TRUE)
	if(user)
		owner = user
		RegisterSignal(owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(updateequip))
		RegisterSignal(owner, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(updateequip))
		updateequip()

	
/obj/item/rogueweapon/abstractweapon/proc/updateequip()
	if(loc != owner)
		if(!QDELETED(src))
			QDEL_NULL(src)
			return

/obj/item/rogueweapon/abstractweapon/Destroy()
	if(owner)
		UnregisterSignal(owner, list(
			COMSIG_MOB_EQUIPPED_ITEM,
			COMSIG_MOB_UNEQUIPPED_ITEM,
		))
	return ..()
	

/obj/item/rogueweapon/abstractweapon/Initialize(mapload)
	. = ..()

	if(creating_spell)
		spell_which_made_us = WEAKREF(creating_spell)
		creating_spell = null

/obj/item/rogueweapon/abstractweapon/ungrip(mob/living/carbon/user, show_message, show_balloon)
	. = ..()
	if(twohands_required && !wielded)	
		wield(user)
