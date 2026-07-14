//SLIME FORM WOOO

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze
	name = "Blob Form"
	desc = ""
	overlay_state = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	convert_damage = FALSE
	do_gib = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering
	name = "suffering ooze"
	melee_damage_lower = 1
	melee_damage_upper = 1
	del_on_deaggro = null
	defprob = 70
	move_to_delay = 20
	STASTR = 2
	STASPD = 2

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering/revive(full_heal = FALSE, admin_revive = FALSE)
	var/obj/shapeshift_holder/ooze_death/H = locate() in src
	if(H)
		H.restore()

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze/Shapeshift(mob/living/caster)
	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	var/mob/living/shape = new shapeshift_type(caster.loc)
	if(ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		shape.color = "#[human_caster.dna.features["mcolor"]]"
	H = new(shape,src,caster,shape)
	shape.name = "[shape]"
	shape.faction = caster.faction

	clothes_req = FALSE
	human_req = FALSE

	if(do_gib)
		playsound(caster.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		caster.spawn_gibs(FALSE)

/obj/shapeshift_holder/ooze_death/Initialize(mapload,mob/living/caster)
	if(!caster)
		return ..()
	shape = loc
	if(!istype(shape))
		to_chat(caster, "Initialize failure: please report: | stored=[caster] shape=[shape]")
		CRASH("shapeshift holder created outside mob/living")
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)

	rebuild_perception(shape)
	hard_reset_spatial(shape)

	stored.forceMove(src)
	stored.notransform = TRUE
	shape.visible_message(span_warning("[stored] has lost their form, they are vulnerable and near death."),span_warningbig("You have been near killed, you can no longer maintain your form. You will need to be revived to return to your humen form."))
	playsound(shape.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	slink = soullink(/datum/soullink/shapeshift, stored , shape)
	slink.source = src

	shape.mob_belly_transfer(stored)
	VORE_PREF_TRANSFER(shape, stored)

/obj/shapeshift_holder/ooze_death/restore(death=FALSE, knockout=0)
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

	temp.revive(full_heal = TRUE, admin_revive = FALSE)
	to_chat(temp, span_notice("Bug notice: If you can no longer see emotes, move to a different z level and back (up/down a level). This is a known bug."))
	temp.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/ooze)
	temp.Knockdown(200)
	temp.Stun(200)
	temp.apply_status_effect(/datum/status_effect/debuff/revived)
	temp.adjust_fire_stacks(2)
	
	temp.mob_belly_transfer(shape)
	VORE_PREF_TRANSFER(temp, shape)

	qdel(shape)
	shape = null
