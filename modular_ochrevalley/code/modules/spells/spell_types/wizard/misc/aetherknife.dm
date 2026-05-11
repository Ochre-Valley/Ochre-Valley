/datum/action/cooldown/spell/aetherknife
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Aetherknife"
	desc = "Congeal magickal energies into a blade which gains a bonus to power based on INT.\n\
	The blade lasts until a new one is summoned or the spell is forgotten. Deals physical damage."
	fluff_desc = "Invented by a mage who felt that the magician's brick was too crude, but still wanted a way to bypass magical defenses."
	button_icon_state = "arcyne_forge"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Desperta ferro!") // "Awake iron!", battlecry of the Almogavars.
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/conjured_knife = null

/datum/action/cooldown/spell/aetherknife/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_knife)
		qdel(conjured_knife)
	var/obj/item/rogueweapon/R = new /obj/item/rogueweapon/aetherknife(user.drop_location())
	R.AddComponent(/datum/component/conjured_item)

	if(user.STAINT > 10)
		var/int_scaling = user.STAINT - 10
		R.force = R.force + int_scaling
		R.throwforce = R.throwforce + int_scaling * 2
		R.name = "aetherknife +[int_scaling]"
	user.put_in_hands(R)
	src.conjured_knife = R
	return TRUE

/datum/action/cooldown/spell/aetherknife/Destroy()
	if(src.conjured_knife)
		conjured_knife.visible_message(span_warning("[conjured_knife] disintegrates into glittering motes!"))
		qdel(conjured_knife)
	return ..()

//this is otherwise just a 1:1 with the brick except that it's stab instead of smash, and scales with knife skill not mace skill
/obj/item/rogueweapon/aetherknife
	name = "aetherknife"
	desc = "A knife formed out of congealed magickal energies. Makes for a very deadly melee and throwing weapon."
	icon_state = "throw_knifesil"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	dropshrink = 0.75
	force = 15
	throwforce = 20
	throw_speed = 4
	wdefense = 3
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_SWIFT
	max_integrity = 50
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/thrust/pick)
	associated_skill = /datum/skill/combat/knives
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'

	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS
	edelay_type = 1
	sellprice = 0 //it's a magic knife that you can summon back, it should be worthless

	COOLDOWN_DECLARE(flip_cooldown)

/obj/item/rogueweapon/aetherknife/rmb_self(mob/user)
	. = ..()
	if(.)
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, flip_cooldown))
		return

	COOLDOWN_START(src, flip_cooldown, 3 SECONDS)
	if((user.get_skill_level(/datum/skill/combat/knives) < 3) && prob(40))
		user.visible_message(
			span_danger("[user] loses concentration whilst trying to show off with their [src]!"),
			span_userdanger("You lose your concentration whilst trying to show off with your [src]!"),
		)
		user.dropItemToGround(src, TRUE) //you just drop it on a fumble instead of hurting your foot, since with high int it would do much more damage than regular knife fumbles
	else
		user.visible_message(
			span_notice("[user] spins [src] around [user.p_their()] finger"),
			span_notice("You spin [src] around your finger"),
		)
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return
