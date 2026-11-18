/datum/charflaw/bottomless
	name = "Bottomless"
	//OV edit - Description expanded upon to differentiate from Ravenous
	desc = "My hunger grows exponentially and without limit! I need more food! MORE!"
	//OV edit end
	var/last_check = 0

/datum/charflaw/bottomless/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	if(user.stat == DEAD)
		return

	if(HAS_TRAIT_FROM(user, TRAIT_NOHUNGER, TRAIT_VIRTUE) || HAS_TRAIT_FROM(user, TRAIT_NOHUNGER, TRAIT_GENERIC)) //Coded NOHUNGER removal but JANK
		REMOVE_TRAIT(user, TRAIT_NOHUNGER, TRAIT_VIRTUE)
		REMOVE_TRAIT(user, TRAIT_NOHUNGER, TRAIT_GENERIC)
		to_chat(user, span_danger("My bottomless hunger brays at the back of my mind."))

	last_check = world.time
	user.maxnutrition += user.maxnutrition * 0.002
	if(user.maxnutrition * 0.8 > user.nutrition)
		user.add_stress(/datum/stressevent/glutton)
	else
		user.remove_stress(/datum/stressevent/glutton)



