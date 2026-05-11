/mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
	icon = 'modular_ochrevalley/icons/roguetown/mob/dendor_touched.dmi'
	name = "mouse"
	desc = "A feral animal of some sorts!"
	icon_state = "mouse"
	icon_living = "mouse"
	icon_dead = "mouse_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 15
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list()
	butcher_results = list()
	perfect_butcher_results = list()
	head_butcher = null
	faction = list("zombie")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 10
	melee_damage_upper = 15
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list()
	pooptype = null
	STACON = 10
	STASTR = 10
	STASPD = 10
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = null
	retreat_health = 0.3
	food = 0
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = null
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0

/obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched
	name = "Animal Form"
	desc = ""
	overlay_state = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 5 MINUTES
	cooldown_min = 5 MINUTES
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
	convert_damage = FALSE
	do_gib = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched/Shapeshift(mob/living/caster)
	var/cursed_animal
	var/cursed_animal_colour
	if(caster.mind)
		if(caster.client.prefs?.cursed_animal)
			cursed_animal = caster.client.prefs?.cursed_animal
			cursed_animal_colour = caster.client.prefs?.cursed_animal_colour
	if(!cursed_animal)
		return

	var/obj/shapeshift_holder/H = locate(/obj/shapeshift_holder) in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	if(do_gib)
		playsound(caster.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)

	// Create the new form
	var/mob/living/shape = new shapeshift_type(get_turf(caster))
	shape.name = "[cursed_animal]"
	shape.icon_state = "[cursed_animal]"
	if(cursed_animal_colour)
		shape.color = cursed_animal_colour

	// Create holder INSIDE the new form, passing shape explicitly
	H = new /obj/shapeshift_holder(shape, src, caster, shape)

	if(do_gib)
		caster.spawn_gibs(FALSE)

/obj/shapeshift_holder/dendor_touched/Initialize(mapload, obj/effect/proc_holder/spell/targeted/shapeshift/source, mob/living/caster, mob/living/new_shape)
	if(!caster)
		return ..()
	src.source = source
	stored = caster
	shape = new_shape

	if(!stored || !shape)
		to_chat(caster, "Initialize failure: invalid mobs | stored=[stored] shape=[shape]")
		CRASH("shapeshift holder initialized without valid mobs")

	if(!isliving(shape))
		to_chat(caster, "Initialize failure: shape not living | shape=[shape]")
		CRASH("shapeshift holder received non-living shape")

	if(stored.mind)
		stored.mind.transfer_to(shape)

	rebuild_perception(shape)
	hard_reset_spatial(shape)

	stored.forceMove(src)
	stored.notransform = TRUE
	
	shape.visible_message(span_warning("[stored] has twisted brutally into an animal form."),span_warningbig("Shrouded within the darkness, you have been forced to transform into your cursed animal form."))
	playsound(shape.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	
	slink = soullink(/datum/soullink/shapeshift, stored, shape)
	if(slink)
		slink.source = src
	
	shape.mob_belly_transfer(stored)
	VORE_PREF_TRANSFER(shape, stored)

/obj/shapeshift_holder/dendor_touched/restore(death=FALSE, knockout=0)
	if(restoring || QDELETED(src))
		return

	restoring = TRUE

	if(slink)
		qdel(slink)
		slink = null

	if(!stored)
		qdel(src)
		return

	var/mob/living/temp = stored
	stored = null

	var/turf/original_turf = get_turf(src)

	if(original_turf)
		temp.forceMove(original_turf)
		hard_reset_spatial(temp)
	
	if(isbelly(shape.loc))
		var/obj/belly/B = shape.loc
		temp.forceMove(B)

	temp.notransform = FALSE

	var/datum/mind/M = temp?.mind || shape?.mind
	if(M)
		M.transfer_to(temp)

	rebuild_perception(temp)

	var/obj/effect/track/the_evidence = new(temp.loc)
	the_evidence.handle_creation(temp)

	if(ishuman(temp))
		var/mob/living/carbon/human/us = temp
		for(var/datum/charflaw/dendor_touched/touched in us.charflaws)
			touched.last_transform = world.time

	if(knockout)
		temp.Unconscious(knockout, TRUE, TRUE)

	if(death)
		temp.death()
	else if(source?.convert_damage && shape)
		temp.revive(full_heal = TRUE, admin_revive = FALSE)

		var/damage_percent = (shape.maxHealth - shape.health) / max(shape.maxHealth, 1)
		var/damapply = temp.maxHealth * damage_percent
		temp.apply_damage(damapply, source.convert_damage_type, forced = TRUE)

	temp.mob_belly_transfer(shape)
	VORE_PREF_TRANSFER(temp, shape)

	if(shape)
		var/mob/living/old_shape = shape
		shape = null
		qdel(old_shape)

	stored = temp
	

	qdel(src)

/datum/stressevent/dendor_touched
	timer = 6 MINUTES
	stressadd = 7
	desc = span_red("It has been daes since I turned! The beast is burning inside me, I must let it free!")

/datum/status_effect/debuff/dendor_touched
	id = "dendor_touched"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dendor_touched
	effectedstats = list(STATKEY_WIL = -3,STATKEY_INT = -2)
	duration = 200

/atom/movable/screen/alert/status_effect/debuff/dendor_touched
	name = "Dendor Touched"
	desc = "You must unleash the beast!"
	icon_state = "debuff"
