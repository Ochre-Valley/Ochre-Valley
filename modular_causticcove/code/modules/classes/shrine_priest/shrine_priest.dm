#define CHOICE_NORMALMISSIONARY "Not terribly. (Normal Missionary)"
#define CHOICE_SHRINEPRIEST "Closely! (Shrine Priest)"
#define SHRINEPRIEST_TUTORIAL "You are a shrine priest from the far eastern lands of Kazengun, trained in the holy arts of your homeland. You have a history of performing rituals, communing with the spirits, laying those spirits to rest, and more such holy services at shrine that was your charge. For one reason or another you have departed from both your shrine and Kazengun, and have traveled far across the seas to the west."

/datum/outfit/job/roguetown/adventurer/missionary/proc/apply_shrine_priest(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/kazengun
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty
	belt = /obj/item/storage/belt/rogue/leather/tossbelt/blade/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	head = null // A lot of hoods are applied by normal Missionary...
	to_chat(H, span_notice(SHRINEPRIEST_TUTORIAL))
	// Sovlful additional text based on specific patrons
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			to_chat(H, span_warning("Even the people of your homeland reviled those who harness the gifts of Zimiko. You will show these people why they, too, are wrong to reject the power of the so-called 'Bastard Daughter'."))
		if(/datum/patron/inhumen/graggar)
			to_chat(H, span_warning("Those of your homeland reviled Gaiyuke for his relentless, violent pursuits. You will show these people, too, the true reason for Gaiyuke's fury."))
		if(/datum/patron/inhumen/baotha)
			to_chat(H, span_warning("Baosumi brought Joy and Pleasure to this world. In your homeland, she is respected and revered like the rest of the Twelve. Here, though, she is decried as a being of Evil. It's a good thing you know better."))
		if(/datum/patron/inhumen/matthios)
			to_chat(H, span_warning("Matoko brought Wealth and Trade to this world. In your homeland, he is respected and revered like the rest of the Twelve. Here, though, he is decried as a being of Evil. It's a good thing you know better."))

/datum/outfit/job/roguetown/adventurer/missionary/proc/try_get_shrinepriest_choice(mob/living/carbon/human/H)
	var/datum/preferences/prefs = H.client?.prefs
	var/start_choices = list(CHOICE_NORMALMISSIONARY, CHOICE_SHRINEPRIEST)
	// If we're Kazengunese and aren't Undivded (Undivided is not a thing in Kazengun; they worship the Twelve, not the Ten!)
	if(prefs && istype(prefs.virtue_origin, /datum/virtue/origin/kazengun) && !istype(H.patron, /datum/patron/divine/undivided))
		var/choice = tgui_input_list(H, "How tightly bound to the traditions of my homeland am I? (This only affects my starting outfit.)", "Shrine Priest?", start_choices, CHOICE_NORMALMISSIONARY)
		return (choice == CHOICE_SHRINEPRIEST)
	return FALSE

#undef CHOICE_NORMALMISSIONARY
#undef CHOICE_SHRINEPRIEST
#undef SHRINEPRIEST_TUTORIAL
