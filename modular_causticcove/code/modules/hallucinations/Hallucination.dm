//Imagine seeing a bunch of wolves and/or goblins or/skeletons charging at you all of a sudden and you start swinging wildly
//People would be hella scared and startled by that and ask you MANY questions...
/obj/effect/hallucination/danger/fake_ambush
	name = "unknown!?.."
	desc = "OH SHIT OH SHIT OH SHIT OH SHIT OH SHIT OH SHIT OH FUCK OH FUCK OH FUCK OH FUCK OH FUCK"
	obj_integrity = 1
	max_integrity = 1
	var/list/chosen_mob = list()

/obj/effect/hallucination/danger/fake_ambush/Initialize(mapload, targ, chosen)
	. = ..()
	target = targ
	chosen_mob = chosen
	show_icon()
	START_PROCESSING(SSobj, src)

/obj/effect/hallucination/danger/fake_ambush/show_icon()
	//Delete our previous image...
	target.client.images -= image
	var/dir
	dir = get_dir(src, target)
	switch(chosen_mob)
		if("volf")
			image = image('icons/roguetown/mob/monster/volf.dmi',src,"vve",OBJ_LAYER+0.01, dir) //OV Edit - changed to new upstream file
		if("skele")
			image = image('icons/mob/skeletons.dmi',src,"skeleton",OBJ_LAYER+0.01, dir)
		if("goblin")
			image = image('icons/roguetown/mob/monster/goblins.dmi',src,"goblin",OBJ_LAYER+0.01, dir)
		if("coon")
			image = image('icons/roguetown/mob/monster/raccoon.dmi',src,"raccoon",OBJ_LAYER+0.01, dir)
		if("fox")
			image = image('icons/roguetown/mob/monster/fox.dmi',src,"fox",OBJ_LAYER+0.01, dir)
		if("dire")
			image = image('icons/roguetown/mob/monster/direbear.dmi',src,"direbear",OBJ_LAYER+0.01, dir)
		if("badger")
			image = image('icons/roguetown/mob/monster/badger.dmi',src,"badger",OBJ_LAYER+0.01, dir)
		if("???")
			image = image('icons/roguetown/mob/monster/horrors.dmi',src,"horror[rand(1,5)]",OBJ_LAYER+0.01, dir)
		if(null) //In case we didn't get one somehow when initializing...
			image = image('icons/mob/abyssal_medium.dmi',src,"dreamfiend",OBJ_LAYER+0.01, dir)
	if(!image) //We hadn't loaded our image yet...
		return
	if(target.client) //Load our new image and dir.
		target.client.images += image

/obj/effect/hallucination/danger/fake_ambush/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/hallucination/danger/fake_ambush/proc/helper_proc()
	sleep(rand(10,30))
	to_chat(target, span_bold("Wait... What!?"))
	target.clear_fullscreen("brute") //Was it real..?
	target.clear_fullscreen("painflash") //Was it real..?

//VERY simple pathfinding.
/obj/effect/hallucination/danger/fake_ambush/process()
	show_icon() //Update dir / icons after Init.

	if(Adjacent(target) && prob(50)) //Some chance to not stun them; To not only scare people but actually allow people to believe in false combat...
		target.jitteriness += 25 //Lets reduce this.
		target.do_jitter_animation(target.jitteriness)
		target.Stun(20)
		target.Paralyze(30)
		target.emote("painscream")
		to_chat(target, span_boldred("THEY GOT ME!!!"))
		target.playsound_local(target, 'sound/misc/stolen.ogg', 66)
		//Caustic Edit
		if(target.show_redflash())
			target.overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash) //Fake pain...
			target.overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, 5) //Fake pain... boogaloo...
		//Caustic Edit End
		for(var/obj/effect/hallucination/danger/fake_ambush/A in range(10, target))
			if(A.target == target)//Make sure we're actually qdel'ing our hallucinations and not others...
				qdel(A)
		helper_proc()
		qdel(src)
	
	if(prob(15))
		switch(chosen_mob)
			if("skele")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg'), 100, 0)
			if("goblin")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/gob/aggro (1).ogg','sound/vo/mobs/gob/aggro (2).ogg','sound/vo/mobs/gob/aggro (3).ogg','sound/vo/mobs/gob/aggro (4).ogg'), 100, 0)
			if("dire")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/direbear/direbear_attack1.ogg','sound/vo/mobs/direbear/direbear_attack2.ogg','sound/vo/mobs/direbear/direbear_attack3.ogg'), 100, 0)
			if("volf")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 100, 0)
			if("fox")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 100, 0)
			if("coon")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 100, 0)
			if("badger")
				target.playsound_local(get_turf(src), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 100, 0)
			if("???")
				target.playsound_local(get_turf(src), 'sound/misc/astratascream.ogg', 100, 1)
			if(null)
				target.playsound_local(get_turf(src), pick('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg'), 100, 1)
	var/next_turf = get_step(src, get_dir(src, target))
	for(var/obj/effect/hallucination/danger/fake_ambush/O in next_turf)
		//You can't walk here partner... Try another way!
		dir = pick(ALL_CARDINALS)
		step(src, dir)
		return
		
	face_atom(target) //Face the hallucinatee.
	show_icon() //Update dir post-facing...
	step(src, src.dir) //Step...
	target.playsound_local(get_turf(src), pick('sound/foley/footsteps/FTGRA_A1.ogg','sound/foley/footsteps/FTGRA_A2.ogg','sound/foley/footsteps/FTGRA_A3.ogg','sound/foley/footsteps/FTGRA_A4.ogg'), 100, 1)
	sleep(rand(2,7)) //False lag/delay to simulate SSmob ticker delay...

	if(prob(33)) //RNG! Repeat!!
		face_atom(target)
		show_icon()
		step(src, src.dir)
		target.playsound_local(get_turf(src), pick('sound/foley/footsteps/FTGRA_A1.ogg','sound/foley/footsteps/FTGRA_A2.ogg','sound/foley/footsteps/FTGRA_A3.ogg','sound/foley/footsteps/FTGRA_A4.ogg'), 100, 1)
		sleep(rand(1,5))

		if(prob(22)) //AND AGAIN! We got lucky!
			face_atom(target)
			show_icon()
			step(src, src.dir)
			target.playsound_local(get_turf(src), pick('sound/foley/footsteps/FTGRA_A1.ogg','sound/foley/footsteps/FTGRA_A2.ogg','sound/foley/footsteps/FTGRA_A3.ogg','sound/foley/footsteps/FTGRA_A4.ogg'), 100, 1)

/obj/effect/hallucination/danger/fake_ambush/attack_hand()
	to_chat(target, span_bold("It turned to thin air..."))
	qdel(src)

/obj/effect/hallucination/danger/fake_ambush/attackby(obj/item/I, mob/living/user, params)
	to_chat(target, span_bold("It phased through it..."))
	qdel(src)

/obj/effect/hallucination/danger/fake_ambush/bullet_act(obj/projectile/P)
	. = ..()
	to_chat(target, span_bold("It flies right through it..."))
	qdel(src)

/datum/hallucination/fake_ambush/New(mob/living/carbon/carbon, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/loc_list = list()
	var/given_loc
	var/list/chosen_mob = list()
	var/list/possible_references = list("volf","skele","goblin","coon","fox","dire","badger","???")
	chosen_mob = pick(possible_references)
	if(!target.halimage)
		for(var/obj/structure/flora/newtree/T in view(6, target))
			loc_list += T.loc
		if(!loc_list.len) //Failsafe.
			for(var/turf/open/floor/O in view(6, target))
				loc_list += get_turf(O)

		if(prob(15))//If you get real unlucky you'd get 5...
			for(var/i in 1 to 5)
				given_loc = pick(loc_list)
				new /obj/effect/hallucination/danger/fake_ambush(given_loc, target, chosen_mob)
			target.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg','sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
			return
		for(var/i in 1 to rand(1,3))
			given_loc = pick(loc_list)
			new /obj/effect/hallucination/danger/fake_ambush(given_loc, target, chosen_mob)
		target.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg','sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
	QDEL_IN(src, 50) //Garuntee jumpscare sound plays...

/datum/hallucination/door_knock/New(mob/living/carbon/carbon, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/possible_doors = list()
	var/list/chosen_door = list()
	for(var/obj/structure/mineral_door/D in oview(7, target))
		if(D.door_opened)
			continue
		possible_doors += D
	if(possible_doors.len)
		chosen_door = pick(possible_doors)
	if(isobj(chosen_door)) //Only do this if we actually have a door k thx bye
		target.playsound_local(get_turf(chosen_door), 'sound/foley/doors/knocking.ogg', 100, 1)
	else if(!isobj(chosen_door))
		var/turf/t = random_far_turf()
		if(prob(50)) //Scare the player if we can't find an in-game door. May need to be tuned louder...
			target.playsound_local(t, pick('modular_causticcove/sound/hallucinations/door_knock_variant1.ogg','modular_causticcove/sound/hallucinations/door_knock_variant2.ogg','modular_causticcove/sound/hallucinations/door_knock_variant3.ogg'), 100, 0)

	QDEL_IN(src, 30) //Garuntee knocking sound plays...


/datum/hallucination/psydon_is_here
	var/HE_IS_HERE = FALSE

/datum/hallucination/psydon_is_here/New(mob/living/carbon/carbon, forced = TRUE)
	set waitfor = FALSE
	..()
	//Commence maniac turf shake once we hit the "GOD IS HERE"
	START_PROCESSING(SSfastprocess, src)
	SEND_SOUND(target, 'modular_causticcove/sound/hallucinations/PSYDONISHERE.ogg')
	sleep(10 SECONDS) //Let them slowly realize the music is playing.
	to_chat(target, "<h1 class='alert'>PSYDON IS COMING!!!</h1>")
	sleep(46 SECONDS) //Wait for ~56 Seconds until the "GOD IS HERE" kicks in with the music (Sleep 46 seconds due to prior 10 seconds)
	HE_IS_HERE = TRUE
	to_chat(target, "<h1 class='alert'>PSYDON IS HERE!!!</h1>")
	to_chat(target, "<br><br><span class='alert'>PSYDON IS HERE!!! PSYDON IS HERE!!! PSYDON IS HERE!!! PSYDON IS HERE!!! PSYDON IS HERE!!!</span><br><br>")
	target.Stun(100)
	target.Paralyze(100)
	target.emote("painscream")
	handle_visions(target, THERE_HE_IS = TRUE)
	sleep(25 SECONDS)
	STOP_PROCESSING(SSfastprocess, src) //Stop the process NOW!!!
	qdel(src)

/datum/hallucination/psydon_is_here/process(mob/living/carbon/carbon)
	if(!target.mind.current)
		STOP_PROCESSING(SSfastprocess, src)
		return
	if(HE_IS_HERE)
		handle_visions(target)
		handle_floors(target.mind.current)
		handle_walls(target.mind.current)

//MANIAC HALLUCINATION SHIT BEGIN
/////////////////////////////////
/datum/hallucination/psydon_is_here/proc/handle_visions(mob/living/target, THERE_HE_IS)
	if(target.client)
		if(prob(10)) //WE CAN'T HANDLE THIS!!!
			target.Stun(100)
			target.Paralyze(100)
			if(prob(66)) //Lets not spam painscream TOO much... But let others at least slightly know something is wrong with them.
				target.emote("painscream")
			target.overlay_fullscreen("HE_IS_HERE", /atom/movable/screen/fullscreen/zezuspsyst_subtle)
			if(THERE_HE_IS) //The initial sight should be longer when he first arrives as a subtle jumpscare.
				sleep(25) //Long sleep to avoid epilepsy issues.
				target.clear_fullscreen("HE_IS_HERE")
				return
			sleep(15) //See above sleep
			target.clear_fullscreen("HE_IS_HERE")
		
/datum/hallucination/psydon_is_here/proc/handle_floors(mob/living/dreamer)
	if(!dreamer.client)
		return
	//HE SHATTERS OUR EXPECATIONS OF WHAT DREARY REALITY WE ARE IN
	for(var/turf/open/floor in view(dreamer))
		if(!prob(15))
			continue
		if(prob(99))
			INVOKE_ASYNC(src, PROC_REF(handle_floor_twitch), floor, dreamer)
		else
			INVOKE_ASYNC(src, PROC_REF(handle_floor_symbol), floor, dreamer)

/datum/hallucination/psydon_is_here/proc/handle_floor_twitch(turf/open/floor, mob/living/dreamer)
	var/mutable_appearance/fake_floor = image(floor.icon, floor, floor.icon_state, floor.layer + 0.01)
	dreamer.client.images += fake_floor
	var/offset_y = pick(-4, -3, -2, 2, 3, 4)
	var/offset_x = pick(-3, -2, 2, 3)
	var/disappearfirst = rand(1 SECONDS, 3 SECONDS) * abs(offset_y)
	animate(fake_floor, pixel_y = offset_y, pixel_x = offset_x, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(1 SECONDS, 3 SECONDS) * abs(offset_y)
	animate(fake_floor, pixel_y = -offset_y, pixel_x = -offset_x, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= fake_floor

/datum/hallucination/psydon_is_here/proc/handle_floor_symbol(turf/open/floor, mob/living/dreamer)
	var/image/psydon_symbol = image('icons/roguetown/misc/rituals.dmi', floor, "psydon_chalky")
	dreamer.client?.images += psydon_symbol
	var/offset_y = pick(-2, -1, 1, 2)
	var/offset_x = pick(-2, -1, 1, 2)
	var/disappearfirst = rand(2 SECONDS, 4 SECONDS)
	animate(psydon_symbol, pixel_y = offset_y, pixel_x = offset_x, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(2 SECONDS, 4 SECONDS)
	animate(psydon_symbol, pixel_y = -offset_y, pixel_x = -offset_x, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= psydon_symbol

/datum/hallucination/psydon_is_here/proc/handle_walls(mob/living/dreamer)
	if(!dreamer.client)
		return
	//HE IS HERE!!! HE IS HERE!!! HE IS HERE!!!
	for(var/turf/closed/wall in view(dreamer))
		if(!prob(2))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_wall_mask), wall, dreamer)

/datum/hallucination/psydon_is_here/proc/handle_wall_mask(turf/closed/wall, mob/living/dreamer)
	var/image/psydon_mask = image('icons/roguetown/clothing/masks.dmi', wall, "psydonmask")
	dreamer.client?.images += psydon_mask
	var/offset_y = pick(-4, -3, -2, 2, 3, 4)
	var/offset_x = pick(-2, -1, 1, 2)
	var/disappearfirst = rand(2 SECONDS, 4 SECONDS)
	animate(psydon_mask, pixel_y = offset_y, pixel_x = offset_x, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(2 SECONDS, 4 SECONDS)
	animate(psydon_mask, pixel_y = -offset_y, pixel_x = -offset_x, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	dreamer.client?.images -= psydon_mask
///////////////////////////////
//MANIAC HALLUCINATION SHIT END
