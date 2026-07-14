/datum/virtue/combat/musketeer
	name = "Musketeer"
	desc = "The thunderous crack of powder and shot is the future of war, and I've practiced with these weapons before most even knew they existed."
	custom_text = "+1 to Firearms, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list(
		"Arquebus Bullet Pouch" = /obj/item/quiver/bulletpouch/iron
	)

/datum/virtue/combat/musketeer/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/firearms) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/firearms, 1, 6))

#define UM_BOXING "Boxing"
#define UM_KARATE "Hollow Hands"
#define UM_CLAWS "Lynx Claws"
#define UM_BIGCLAWS "Bear Claws"

/datum/virtue/combat/unarmed_master
	name = "Martial Disciple"
	desc = "Through knowledge or body, I possess unique talent in wielding my bare hands as weaponry. I'll still need pugilist training, or a weighted glove, to deal significant damage with them. Martial arts are weaker for those with significant magical knowledge."
	max_choices = 2
	choice_costs = list(0, 6)
	extra_choices = list(
		UM_BOXING,
		UM_KARATE,
		UM_CLAWS,
		UM_BIGCLAWS,
	)
	choice_tooltips = list(
		UM_BOXING = "A versatile martial art, which can switch between a swift and a heavy grip, with attacks focused on windows of opportunity. You've stashed a pair of trusty bronze knuckles.",
		UM_KARATE = "An eastern martial art style, focused upon imitating weaponry and forces of nature. You're also a decent wrestler.",
		UM_CLAWS = "Whether your have claws, or technique, you are capable of quick, lashing strikes with your bare hands. You've a savage appetite to match.",
		UM_BIGCLAWS = "Whether your have claws, or technique, you are capable of vicious, rending strikes with your bare hands. You've a savage appetite to match.",
	)

/datum/virtue/combat/unarmed_master/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(triumph_check(recipient))
		recipient.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		for(var/choice in picked_choices)
			switch(choice) //Add the chosen martial art, and a "ribbon". I consider this balanced against T&R, therefore, three total 'features' are gained- unarmed skill, a martial art, and something related
				if(UM_BOXING)
					recipient.mind?.special_items["Knucks"] = /obj/item/clothing/gloves/roguetown/knuckles/bronze //straight out of T/R. 
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/abstractweapon/martialart/boxing)
				if(UM_KARATE)
					recipient.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, silent = TRUE)//Karate is a martial art which involves a deal of wrestling ability
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/abstractweapon/martialart/karate)
				if(UM_CLAWS)
					ADD_TRAIT(recipient, TRAIT_ORGAN_EATER, TRAIT_VIRTUE)//you're taking the freaky feral style
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/abstractweapon/martialart/claws)
				if(UM_BIGCLAWS)
					ADD_TRAIT(recipient, TRAIT_ORGAN_EATER, TRAIT_VIRTUE)//ditto
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/abstractweapon/martialart/bigclaws)
					
#undef UM_BOXING
#undef UM_KARATE
#undef UM_CLAWS
#undef UM_BIGCLAWS
