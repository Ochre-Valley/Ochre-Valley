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
	name = "Pugilist Discipline"
	desc = "Through knowledge or body, I possess unique talent in wielding my bare hands as weaponry- affording me Journeyman unarmed skill, and a unique martial art. I'll still need pugilist training, or a weighted glove, to deal significant damage with them. Martial arts are weaker for those with significant magical knowledge."
	max_choices = 2
	choice_costs = list(0, 6)
	extra_choices = list(
		UM_BOXING,
		UM_KARATE,
		UM_CLAWS,
		UM_BIGCLAWS,
	)
	choice_tooltips = list(
		UM_BOXING = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>SUCKER PUNCH</b>: A very weak punch which can't be dodged or parried. \n \
	<b>LEFT HOOK</b>: In swift stance, your special attack is a swift LEFT HOOK to the mouth, which dazes the target. If the target is exposed, vulnerable, or unprepared for combat, they're SILENCED \n \
	You can switch your grip to enable HEAVY stance, switching to the following intents: \n \
	<b>CROSS</b>: A strong, straight punch with your main hand.\n \
	<b>HAYMAKER</b>: A slow, predictable punch, which hits hard and can daze the target if it damages their head, as well as knock them back if you're strong enough.\n \
	<b>UPPER CUT</b>: In heavy stance, your special attack is an UPPER CUT, a slow, charged hit. Does massive damage to vulnerable targets, and knocks them down!\n \
	<b>Knucks</b>: I've stashed a pair of bronze knuckles.\n \
	<i>A homegrown azurian martial art emphasizing a strong form and center of balance, favored for its usefulness to people of most builds in pit-fights</i>",
		UM_KARATE = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>AXE HAND</b>: A telegraphed hit which does heavy damage to objects. \n \
	<b>KANABO STRIKE</b>: A telegraphed strike with the palm, knocking the target back.\n \
	<b>WRING</b>: A telegraphed strike which deals TWIST damage to the target.\n \
	<b>FLYING THUNDER KICK</b>: Your special is a leap into a distant tile, after which you execute a series of wild kicks!\n \
	<b>Wrestler</b>: My training affords me apprentice-level wrestling knowledge.\n \
	<i>A Kazengun martial art tradition, refined from an ancient lingyuan style.</i>",
		UM_CLAWS = "Bare both hands, curling fingers as if into claws to slice into your foes. This is a remarkably swift stance to enter, and requires only one free hand.\n \
	<b>CUT</b>: A fast slice of the claws. Pays for sharpness in that its raw damage is significantly lesser than a simple punch. \n \
	<b>SLASH</b>: A swift slash which can hit multiple targets. \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>JAB</b>: A skilled user of this stance can execute a swift jab, able to penetrate light armor.\n \
	<b>DASH</b>: Your special is a DASH, giving you a bonus to SPEED, and allowing you to move through occupied spaces for a brief moment.\n \
	<b>Organ Eater</b>: These feral gifts allow me to stomach organs and uncooked food.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i>",
		UM_BIGCLAWS = "Bare both hands, curling fingers as if into talons to rip and tear into your foes.\n \
	<b>CUT</b>: Swing with your claws. Does comparable damage to a punch, cutting the target at the cost of being slower and clumsier. \n \
	<b>LUNGE</b>: A telegraphed attempt to plunge your claws into a target, penetrating light armor! \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>FRENZY</b>: A skilled user of this stance can execute a wild, cleaving slash that can hit multiple targets.\n \
	<b>POUNCE</b>: Your special is a POUNCE, leaping to a nearby tile before attacking and exposing all targets in a frontal arc. Both yourself, and the targets, are rooted in place.\n \
	<b>Organ Eater</b>: These feral gifts allow me to stomach organs and uncooked food.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i> ",
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
