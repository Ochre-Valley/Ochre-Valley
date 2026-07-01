/datum/charflaw/ravenous //Code taken directly from the "Bottomless" Vice from Caustic Cove, modified for linear progression rather than exponential
	name = "Ravenous" //The Vice itself
	desc = "My hunger constantly grows, up to a point. Even when I should be full, I still feel empty..."
	var/last_check = 0

/datum/charflaw/ravenous/flaw_on_life(mob/user) //The Vice's workflow, again taken directly from CC but with two minor modifications
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	if(user.stat == DEAD)
		return
	last_check = world.time
	if(user.maxnutrition < 7000) //This is the Cap that prevents it from scaling beyond a value: 6k-8k value suggested by Ryumi
		user.maxnutrition += 10.0 //Calling a CC variable
	if(user.maxnutrition * 0.8 > user.nutrition)
		user.add_stress(/datum/stressevent/glutton) //Calling a CC stressevent
	else
		user.remove_stress(/datum/stressevent/glutton)
