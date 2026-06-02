//Saves the sunstrike from deletion for an admin smite

/obj/effect/temp_visual/firewave/sun_mark
	icon = 'modular_ochrevalley/icons/effects/160x160.dmi'
	icon_state = "sun"
	alpha = 5
	duration = 1 MINUTES
	pixel_x = -64
	pixel_y = -64
	light_outer_range = 5
	light_color = "#ffb300ff"

/obj/effect/temp_visual/firewave/sun_mark/Initialize(mapload)
	. = ..()
	SpinAnimation(20)

/obj/effect/temp_visual/firewave/sun_mark/pre_sunstrike
	duration = 30 SECONDS

/obj/effect/temp_visual/firewave/sunstrike/primary
	alpha = 0
	duration = 11 SECONDS

/obj/effect/temp_visual/firewave/sunbeam
	icon = 'icons/effects/32x96.dmi'
	icon_state = "sunstrike"
	alpha = 5
	duration = 15.5

/obj/effect/temp_visual/firewave/sunstrike/primary/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/temp_visual/firewave/sunstrike/primary, pre_strike), TRUE), 1 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/temp_visual/firewave/sunstrike/primary, strike), TRUE), 10 SECONDS)

/obj/effect/temp_visual/firewave/sunstrike/primary/proc/pre_strike()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/revive.ogg', 80, TRUE)
	loud_message("<font size = 9>[span_purple("THE SKY IS FLOODED WITH WHITE FIRE!!")]</font><br>", hearing_distance = 14)

	for(var/turf/Target_turf in range(1, get_turf(src)))
		for(var/mob/living/L in Target_turf.contents)
			to_chat(L, span_userdanger("I feel a terrifyingly heavy gaze upon me!!"))

/obj/effect/temp_visual/firewave/sunstrike/primary/proc/strike()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/astrata_choir.ogg', 100, TRUE)
	explosion(T, -1, 0, 0, 0, 0, flame_range = 0, soundin = 'sound/misc/explode/incendiary (1).ogg')
	var/obj/effect/temp_visual/mark = new /obj/effect/temp_visual/firewave/sunbeam(T)

	animate(mark, alpha = 255, time = 10, flags = ANIMATION_PARALLEL)
	for(var/turf/turf as anything in RANGE_TURFS(6, T))
		if(prob(20))
			new /obj/effect/hotspot(get_turf(turf))
	for(var/turf/Target_turf in range(5, T))
		for(var/mob/living/L in Target_turf.contents)
			to_chat(L, span_userdanger("The sun crushes you!!"))
			var/dist_to_epicenter = get_dist(T, L)
			var/firedamage = 200 - (dist_to_epicenter*15)
			var/firestack = 10 - dist_to_epicenter
			L.adjustFireLoss(firedamage)
			L.adjust_fire_stacks(firestack)
			L.ignite_mob()
			if(!L.mind || istype(L, /mob/living/simple_animal))
				L.adjustFireLoss(500)
				if(dist_to_epicenter <= 3)
					L.gib()
			if(dist_to_epicenter == 1) //pre-center
				L.adjustFireLoss(100) //185 firedamage
				new /obj/effect/hotspot(get_turf(L))
			if(dist_to_epicenter == 0) //center
				explosion(T, -1, 1, 1, 0, 0, flame_range = 1, soundin = 'sound/misc/explode/incendiary (1).ogg')
				new /obj/effect/hotspot(get_turf(L))
				if(!((L.patron?.type) == /datum/patron/divine))
					L.gib()
				else
					L.adjustFireLoss(500)
					L.stat = DEAD
	for(var/obj/item/I in range(1, T))
		qdel(I)
	for (var/obj/structure/damaged in view(2, T))
		if(!istype(damaged, /obj/structure/flora/newbranch))
			damaged.take_damage(500,BRUTE,"blunt",1)
	for (var/turf/closed/wall/damagedwalls in view(1, T))
		damagedwalls.take_damage(1100,BRUTE,"blunt",1)
	for (var/turf/closed/mineral/aoemining in view(2, T))
		aoemining.lastminer = usr
		aoemining.take_damage(1100,BRUTE,"blunt",1)
	sleep(10)
	animate(mark, alpha = 5, time = 10, flags = ANIMATION_PARALLEL)
