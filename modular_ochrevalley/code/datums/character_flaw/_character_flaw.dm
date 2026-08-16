GLOBAL_LIST_INIT(dendor_touched_animals, list(
	"mouse",
	"cat",
	"cabbit",
	"volf",
	"honeyspider",
	"rat",
	"rakkun",
	"venard",
	"cow",
	"bull",
	"chicken",
	"lynx",
	"badger"
))

/datum/charflaw/hemovore
	name = "Hemovore"
	desc = "Be it by birth or curse, I can only gain sustenance through the blood of the living"

/datum/charflaw/hemovore/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_LYFE_DRINK, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_VAMPBITE, TRAIT_GENERIC)

/datum/charflaw/hemovore/flaw_on_moved(mob/user, atom/OldLoc, movement_dir) //THIS SEEMS VERY JANK AND MAY NEED TO BE CHANGED BUT NO OTHER FLAW PROC SEEMED TO WORK
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_VIRTUE) || HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_GENERIC)) //Coded NOHUNGER removal, so when combined with Deathless you still have the HUNGER
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_VIRTUE)
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
		to_chat(H, span_danger("My hunger brays at the back of my mind."))

/obj/item/grabbing/bite/proc/check_hemovore(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_LYFE_DRINK))
		return FALSE //only hemovores get the snowflake check~
	if(iscarbon(grabbed))
		var/mob/living/carbon/target = grabbed
		if(target.cmode)
			to_chat(user, span_warning("My meal is fighting back! I can't get a clean bite."))
			return FALSE //target is actively fighting
		if(ishuman(target)) //check if the target is human, so their armor can be checked. If the target is human, we get the best stab resist on this zone. 
			var/mob/living/carbon/human/humantarget = target
			var/def_zone = limb_grabbed.body_zone
			var/obj/item/clothing/prot = humantarget.get_best_worn_armor(def_zone, "stab")
			if(prot)
				var/armoramount = prot.armor.getRating("stab")
				if(armoramount >= DBLOCK_HEAVY) //Hemovores can bite thru leather and below, intended to bypass natural armor. This means they can bite through bronze right now, unfortunately, but it's for scenes!!
					to_chat(user, span_warning("My meal is protected! I can't get a clean bite."))
					return FALSE
				else if(armoramount) //tell that you're biting through the armor. I don't actually want to damage it, this is mostly for scenes anyways
					to_chat(user, span_warning("I bite through the target's [prot]"))
		var/ramount = 15
		var/rid = /datum/reagent/vampsolution
		target.reagents.add_reagent(rid, ramount)
		user.drinksomeblood(grabbed, sublimb_grabbed)
		return TRUE
	return FALSE //you should never get this far. you've somehow tried to drink from something other than a carbon mob.

/datum/charflaw/dendor_touched
	name = "Dendor Touched"
	desc = "Cursed by Dendor, you transform into an animal every time you enter total darkness."
	var/starting_leeway = 5 MINUTES				//How long after spawning do they start TFing
	var/next_check = 0							//Time of next check
	var/check_interval = 10 SECONDS				//How often to check (when not in countdown)
	var/animal_curse = "mouse"					//Animal they TF into
	var/last_transform = 0						//Last time they TFd
	var/time_since_transform = 0				//Used to calculate how long since last TF
	var/transform_stress_time = 60 MINUTES		//How long without TFing before they start getting debuffed
	var/countdown = 0							//A countdown up to 4 on ticks when in darkness to ensure they are actually in dark and not just experiencing a lighting blip
	var/animal_colour = "#FFFFFF"				//Colour overlay of animal form

/datum/charflaw/dendor_touched/on_mob_creation(mob/user)
	next_check = world.time + starting_leeway
	last_transform = world.time
	
/datum/charflaw/dendor_touched/flaw_on_life(mob/user)
	if(!user)
		return
	if(!ishuman(user))
		return
	if(user.stat || !isturf(user.loc))
		return
	if(world.time > next_check)
		for(var/obj/item/flashlight/our_light in user.contents) //If they're wearing or holding an active light, just bypass this whole check
			if(our_light.on)
				countdown = 0
				next_check = world.time + check_interval
				return
		if(countdown > 4)
			animal_tf(user)
		else
			check_buildup(user)

/datum/charflaw/dendor_touched/apply_post_equipment(mob/user)
	if(user.mind)
		if(user.client.prefs?.cursed_animal)
			animal_curse = user.client.prefs?.cursed_animal
			animal_colour = user.client.prefs?.cursed_animal_colour
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched)

/datum/charflaw/dendor_touched/proc/animal_tf(mob/user)
	countdown = 0
	if(world.time > next_check)
		next_check = world.time + check_interval
		var/turf/our_turf = get_turf(user)
		var/turf_light = our_turf.get_lumcount()
		if(turf_light > 0.04)
			time_since_transform = world.time - last_transform
			var/mob/living/L = user
			if(time_since_transform > transform_stress_time)
				L.add_stress(/datum/stressevent/dendor_touched)
				L.apply_status_effect(/datum/status_effect/debuff/dendor_touched)
			return
		var/mob/living/carbon/human/cursed = user
		var/obj/shapeshift_holder/dendor_touched/H = locate() in cursed
		last_transform = world.time
		time_since_transform = 0
		if(!H)
			cursed.drop_all_held_items()
			var/shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
			var/mob/living/shape = new shapeshift_type(cursed.loc)
			cursed.remove_stress(/datum/stressevent/dendor_touched)
			cursed.remove_status_effect(/datum/status_effect/debuff/dendor_touched)

			H = new(shape,null,cursed,shape)
			shape.name = "[animal_curse]"
			shape.icon_state = "[animal_curse]"
			shape.color = animal_colour
			
			for(var/obj/effect/proc_holder/spell/targeted/shapeshift/the_spell in shape.mind.spell_list)
				the_spell.charge_counter = 0
				the_spell.start_recharge()

			return

/datum/charflaw/dendor_touched/proc/check_buildup(mob/user)
	var/turf/our_turf = get_turf(user)
	var/turf_light = our_turf.get_lumcount()
	if(turf_light > 0.04)
		next_check = world.time + check_interval
		countdown = 0
		return
	if(countdown == 1)
		to_chat(user, span_warning("I can feel my animal form being drawn out in the darkness..."))
	countdown = countdown + 1
	next_check = world.time + 5
