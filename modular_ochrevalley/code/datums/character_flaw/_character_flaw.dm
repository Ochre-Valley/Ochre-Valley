/datum/charflaw/hemovore
	name = "Hemovore"
	desc = "Be it by birth or curse, I can only gain sustenance through the blood of the living"

/datum/charflaw/hemovore/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_LYFE_DRINK, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_VAMPBITE, TRAIT_GENERIC)

/datum/charflaw/hemovore/flaw_on_moved(mob/user, atom/OldLoc, movement_dir) //THIS SEEMS VERY JANK AND MAY NEED TO BE CHANGED BUT NO OTHER FLAW PROC SEEMED TO WORK
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_VIRTUE) || HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_GENERIC)) //Coded NOHUNGER removal, so when combined with Deathless you still have the HUNGER
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_VIRTUE)
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
		to_chat(H, span_danger("My hunger brays at the back of my mind."))
