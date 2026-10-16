GLOBAL_LIST_EMPTY(sizecats)
#define TRAIT_SIZECAT "SizeCat"

/datum/sizecat //Reworking this to basically entirely be a handler for the buff and debuff for being grown/shrunk!
	/// What the sizecat is called.
	var/name
	/// A brief, in-character description of what the sizecat does.
	var/desc
	/// A list containing any traits we need to add to the mob.
	//var/list/added_traits = list()

	var/custom_text
	var/starting_scale = 1


/datum/sizecat/New()
	. = ..()

/datum/sizecat/proc/apply_to_living(mob/living/recipient)
	return

/datum/sizecat/proc/remove_sizecat_from_living(mob/living/recipient)
	return

/*/datum/sizecat/proc/handle_traits(mob/living/recipient)
	if (!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_SIZECAT)*/

/mob
	var/datum/sizecat/current_size

/proc/apply_sizecat(mob/living/recipient, datum/sizecat/sizecat_type)
	if(!istype(recipient))
		return
	if(!istype(sizecat_type))
		return

	sizecat_type.apply_to_living(recipient)
	recipient.current_size = sizecat_type

//If this is called, make sure you assign the new one through the above proc! Even if it's None!
/proc/remove_sizecat(mob/living/recipient)
	if(!istype(recipient))
		return

	if(istype(recipient.current_size))
		recipient.current_size.remove_sizecat_from_living(recipient)
		recipient.current_size = null
		recipient.remove_movespeed_modifier(MOVESPEED_ID_MACROMICRO)

/proc/apply_prefs_sizecat(mob/living/character, client/player)
	if (!player)
		player = character.client
	if (!player)
		return
	if (!player.prefs)
		return
	//var/datum/sizecat/sizecat_type = player.prefs.sizecat //OV REMOVE
	//OV edit
	if(ishuman(character))
		var/mob/living/carbon/human/us = character
		var/new_body_size = us.dna.features["body_size"]
		character.resize(new_body_size, forced = TRUE, ignore_prefs = TRUE)
	//OV edit end
