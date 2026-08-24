/datum/virtue/combat/musketeer
	name = "Musketeer"
	desc = "The thunderous crack of powder and shot is the future of war, and I've practiced with these weapons before most even knew they existed."
	custom_text = "+1 to Firearms, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list(
		"Arquebus Bullet Pouch" = /obj/item/quiver/bulletpouch/iron
		"Powder Flask" = /obj/item/powderflask
	)

/datum/virtue/combat/musketeer/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/firearms) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/firearms, 1, 6))
