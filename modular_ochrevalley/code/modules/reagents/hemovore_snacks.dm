//Snacks for Hemovore vice havers, does not work on vampires bcuz of their vitae weirdness
//has 3 tiers
//- peasant tier: made with alchemy skilldif 0 on any table using improvised ingredients, gives a little bit of nutrition and a small mood debuff for 5 minutes
//- burgher tier: made with apprentice alch at an alchemy table using mostly alchemy and raw food ingredients, gives nutrition and no buffs/debuffs
//- noble tier: made with expert alch at an alchemy table but uses a lot of ingredients found in lavish foods, fills nutrition completely and gives a good snack buff (good meal is still people exclusive)
// all are revolting to non-hemovores, the noble one specifically is hazardous to actual lyckers/vampyres.

/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/poor
	name = "bloody slop"
	desc = "A horrible mix of water, salt, and viscera, even a prisoner would at least get hardtack. For those who drink lyfeblood, this may yet be useful."
	list_reagents = list(/datum/reagent/hemosnack/poor = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/mid
	name = "alchemical vitae"
	desc = "A carefully considered mix of reagents brewed by a trained alchemist for those who drink lyfeblood. Ostensibly still disgusting for anyone who does not drink lyfeblood, and only tolerable for those who do."
	list_reagents = list(/datum/reagent/hemosnack/mid = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/good
	name = "bloodwine stew"
	desc = "A refined alchemical solution created by an expert alchemist, it combines the staples of a fine dining experience while satiating the need for lyfesblood. A luxurious meal, for those who drink lyfesblood at least."
	list_reagents = list(/datum/reagent/hemosnack/good = 30)

/datum/reagent/hemosnack
	name = "hemosnack base reagent"
	description = "u should not see this"
	color = "#0adf7b"
	taste_description = "coder mistakes"
	metabolization_rate = 1 //30 per vial, meaning adjust nutrition/hydration * 30 for resulting change

/datum/reagent/hemosnack/poor
	name = "bloody slop"
	description = "A horrible mix of water, salt, and viscera, even a prisoner would at least get hardtack. For those who drink lyfeblood, this may yet be useful."
	color = "#3d2b2b"
	taste_description = "salty giblets"

/datum/reagent/hemosnack/poor/on_mob_life(mob/living/carbon/M)
	if(!M.has_stress_event(/datum/stressevent/bloodslop) && !HAS_TRAIT(M, TRAIT_LYFE_DRINK) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_stress(/datum/stressevent/bloodslop) //wow this viscera and salt in a vial is terrible tasting
	if(!M.has_stress_event(/datum/stressevent/bloodslop/hemo) && HAS_TRAIT(M, TRAIT_LYFE_DRINK)) //i dont think someone who eats actual raw organs will care much about taste here
		M.add_stress(/datum/stressevent/bloodslop/hemo) //hemovores hate it slightly less
	if(HAS_TRAIT(M, TRAIT_LYFE_DRINK) || HAS_TRAIT(M, TRAIT_ORGAN_EATER)) //organ eaters are weirdos who will also probably enjoy this slop
		M.adjust_nutrition(10)
		M.adjust_hydration(10)
	..()

/datum/reagent/hemosnack/mid
	name = "alchemical vitae"
	description = "A carefully considered mix of reagents brewed by a trained alchemist for those who drink lyfeblood. Ostensibly still disgusting for anyone who does not drink lyfeblood, and only tolerable for those who do."
	color = "#4b2b2b"
	taste_description = "salted steak"

/datum/reagent/hemosnack/mid/on_mob_life(mob/living/carbon/M)
	if(!M.has_stress_event(/datum/stressevent/bloodslop) && !HAS_TRAIT(M, TRAIT_LYFE_DRINK) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_stress(/datum/stressevent/bloodslop)
	if(HAS_TRAIT(M, TRAIT_LYFE_DRINK) || HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.adjust_nutrition(20)
		M.adjust_hydration(20)
	..()

/datum/reagent/hemosnack/good
	name = "bloodwine stew"
	description = "A refined alchemical solution created by an expert alchemist, it combines the staples of a fine dining experience while satiating the need for lyfesblood. A luxurious meal, for those who drink lyfesblood at least."
	color = "#641b1b"
	taste_description = "berry sauce drizzled steak with garlic accents"

/datum/reagent/hemosnack/good/on_mob_life(mob/living/carbon/M)
	if(!M.has_stress_event(/datum/stressevent/bloodslop) && !HAS_TRAIT(M, TRAIT_LYFE_DRINK) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_stress(/datum/stressevent/bloodslop)
	if(HAS_TRAIT(M, TRAIT_VAMPBITE) && !HAS_TRAIT(M, TRAIT_LYFE_DRINK))
		M.add_stress(/datum/stressevent/badjuiceforvampires) //get garlicked, idiot
	if(HAS_TRAIT(M, TRAIT_LYFE_DRINK) || HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.adjust_nutrition(30)
		M.adjust_hydration(30)
		M.apply_status_effect(/datum/status_effect/buff/snackbuff) //still worse than drinking a person
	..()
