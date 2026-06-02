/mob/living/proc/mob_belly_transfer(var/mob/living/M)
	var/obj/belly/vore_selected_storage = M.vore_selected
	for(var/obj/belly/B as anything in vore_organs) //First remove all existing bellies in the MOB you're transforming into, otherwise it duplicates the bellies and I'm not sure why
		qdel(B)
	for(var/obj/belly/B as anything in M.vore_organs) //Then move all the bellies over, including all their contents
		B.loc = src
		B.forceMove(src)
		B.owner = src
		M.vore_organs -= B
		src.vore_organs += B
	if(vore_selected_storage)
		vore_selected = vore_selected_storage
	else
		vore_selected = pick(vore_organs)
