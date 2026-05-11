/obj/item/digestion_remains
	name = "bone"
	desc = "A bleached bone. It's very non-descript and its hard to tell what species or part of the body it came from."
	icon = 'modular_ochrevalley/icons/obj/bones_vr.dmi'
	icon_state = "generic-1"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'   //sounds kinda like a bone
	pickup_sound = 'modular_ochrevalley/sounds/foley/equip/woodweapon.ogg'
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL

	possible_item_intents = list(/datum/intent/use, /datum/intent/crush_remains)

	// admin logging
	var/pred_ckey
	var/pred_name
	var/prey_ckey
	var/prey_name

/obj/item/digestion_remains/Initialize(mapload, mob/living/pred, mob/living/prey)
	. = ..()
	if(!mapload)
		if(pred)
			pred_ckey = pred.ckey
			pred_name = pred.name
		if(prey)
			prey_ckey = prey.ckey
			prey_name = prey.name

			dropshrink = prey.size_multiplier
			update_transform()

/obj/item/digestion_remains/attack_self(mob/user)
	. = ..()
	if(user.used_intent.type == /datum/intent/crush_remains)
		to_chat(user, span_warning("As you squeeze the [name], it crumbles into dust and falls apart into nothing!"))
		qdel(src)
	else
		to_chat(user, span_notice("Switch to crush intent to crush these."))

/datum/intent/crush_remains
	name = "crush"
	icon_state = "incrush"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/digestion_remains/variant1 //Generic bone variations
	icon_state = "generic-2"

/obj/item/digestion_remains/variant2
	icon_state = "generic-3"

/obj/item/digestion_remains/variant3
	icon_state = "generic-4"

/obj/item/digestion_remains/synth //synthbones start
	name = "ruined component"
	desc = "A ruined component. It seems to have come from some sort of metal entity, but there's no telling what kind."
	icon_state = "synth-1"

/obj/item/digestion_remains/synth/variant1 
	icon_state = "synth-2"

/obj/item/digestion_remains/synth/variant2
	icon_state = "synth-3"

/obj/item/digestion_remains/synth/variant3
	icon_state = "synth-4"

/obj/item/digestion_remains/ribcage //ribcage start
	name = "ribcage"
	desc = "A bleached ribcage. It's very white and definitely has seen better times. Hard to tell what it belonged to."
	icon_state = "ribcage"

/obj/item/digestion_remains/skull //skull start
	name = "skull"
	desc = "A bleached skull. It looks very weakened. You can't quite tell what species it belonged to."
	icon_state = "skull"

/obj/item/digestion_remains/skull/Initialize(mapload, mob/living/pred, mob/living/prey)
	. = ..()
	if(!mapload && ishuman(prey))
		var/mob/living/carbon/human/human_prey = prey
		var/species_name = human_prey.dna.species.name

		desc = "A bleached skull. It looks very weakened. Seems like it belonged to some kind of [species_name]."
		if(human_prey.getorganslot(ORGAN_SLOT_SNOUT))
			icon_state = "skull_taj"
