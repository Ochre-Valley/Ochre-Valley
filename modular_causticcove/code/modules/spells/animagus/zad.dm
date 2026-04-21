/mob/living/carbon/human/species/animagus/zad // The scout! Uses cabbit wildshape for stats and skills, may need tweaking.
	name = "Zad"
	race = /datum/species/shapezad
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/zad_skin
	wildshape_icon = 'icons/roguetown/mob/monster/crow.dmi'
	wildshape_icon_state = "crow_flying"
	movement_type = FLYING
	var/fly_time = 3 SECONDS

/mob/living/carbon/human/species/animagus/zad/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)

		STASTR = 2
		STACON = 2
		STAWIL = 7
		STAPER = 12
		STASPD = 12
		STALUC = 12

		AddSpell(new /obj/effect/proc_holder/spell/self/zadclaws)
		real_name = "Zad"
		verbs += list(/mob/living/carbon/human/species/animagus/zad/proc/fly_up, /mob/living/carbon/human/species/animagus/zad/proc/fly_down)

/datum/species/shapezad
	name = "zad"
	id = "shapezad"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_WILD_EATER,
		TRAIT_NASTY_EATER, // Opportunistic carrion bird. Opposed to wild eater, this lets them eat poison berries and organs.
		TRAIT_HARDDISMEMBER,
		TRAIT_DODGEEXPERT,
		TRAIT_BRITTLE,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapezad/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/crow.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "crow_flying"
	human.update_damage_overlays()
	return TRUE

/datum/species/shapezad/on_species_gain(mob/living/carbon/carbon, datum/species/old_species)
	. = ..()
	RegisterSignal(carbon, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapezad/update_damage_overlays(mob/living/carbon/human/human)
	human.remove_overlay(DAMAGE_LAYER)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/skin_armor/zad_skin
	slot_flags = null
	name = "zad's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	sewrepair = FALSE
	max_integrity = 1
	item_flags = DROPDEL

/datum/intent/simple/zad
	name = "claw"
	clickcd = 8
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "cuts", "scratches")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/zad_claw
	name = "zad talon"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 200
	max_integrity = 200
	force = 8
	block_chance = 0
	wdefense = 1
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/zad)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/zad_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/zad_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/zad_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/zadclaws
	name = "Zad Talons"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/zadclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/zad_claw/left/left = user.get_active_held_item()
	var/obj/item/rogueweapon/zad_claw/right/right = user.get_inactive_held_item()

	if(extended)
		if(istype(left, /obj/item/rogueweapon/zad_claw))
			user.dropItemToGround(left, TRUE)
			qdel(left)

		if(istype(right, /obj/item/rogueweapon/zad_claw))
			user.dropItemToGround(right, TRUE)
			qdel(right)

		extended = FALSE
		return

	left = new(user, 1)
	right = new(user, 2)
	user.put_in_hands(left, TRUE, FALSE, TRUE)
	user.put_in_hands(right, TRUE, FALSE, TRUE)
	extended = TRUE

/mob/living/carbon/human/species/animagus/zad/proc/fly_up()
	set category = "Winged Form"
	set name = "Fly Up"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to ascend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time)) //OV AP merge 4.11.26 - target commented out
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("I fly up."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/carbon/human/species/animagus/zad/proc/fly_down()
	set category = "Winged Form"
	set name = "Fly Down"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to descend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time)) //OV AP merge 4.11.26 - target commented out
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("I fly down."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))
