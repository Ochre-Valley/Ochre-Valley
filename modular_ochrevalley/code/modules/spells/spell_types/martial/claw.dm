/datum/action/cooldown/spell/abstractweapon/martialart/bigclaws
	name = "Direbear Stance"
	desc = "Bare both hands, curling fingers as if into talons to rip and tear into your foes.\n \
	<b>CUT</b>: Swing with your claws. Does comparable damage to a punch, cutting the target at the cost of being slower and clumsier. \n \
	<b>LUNGE</b>: A telegraphed attempt to plunge your claws into a target, penetrating light armor! \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>FRENZY</b>: A skilled user of this stance can execute a wild, cleaving slash that can hit multiple targets.\n \
	<b>POUNCE</b>: Your special is a POUNCE, leaping to a nearby tile before attacking and exposing all targets in a frontal arc. Both yourself, and the targets, are rooted in place.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i> "
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/bigclaws
	draw_message = "Curls their hands into terrible claws!" 
	drop_message = "loses their clawed stance!"
	button_icon_state = "bigclaws"

/obj/item/rogueweapon/abstractweapon/martialart/bigclaws //Similar to handclaws, with lower damage and armor penetration.
	name = "Heavy Claws"
	desc = "Your hands, curled into terrible claws"
	force = 15 
	tiermult = 2.5 //Damage scales about as hard as normal fists- a t4 user is about 10 damage behind someone with gronnic claws
	wbalance = WBALANCE_HEAVY
	sharpness = IS_SHARP
	icon_state = "bigclaws"
	possible_item_intents = list(/datum/intent/claw/cut/martial, /datum/intent/claw/lunge/martial, /datum/intent/claw/rend)
	gripped_intents = list(/datum/intent/claw/cut/martial, /datum/intent/claw/lunge/martial, /datum/intent/claw/rend)
	baseintents = list(/datum/intent/claw/cut/martial, /datum/intent/claw/lunge/martial, /datum/intent/claw/rend)
	masterstring = "As a master of this stance, my lunge and slash can penetrate greater protection, and I gain access to a wild, cleaving slash."
	masterintents = list(/datum/intent/claw/cut/martial/master, /datum/intent/claw/lunge/martial/master, /datum/intent/claw/rend, /datum/intent/claw/cleave)
	special = /datum/special_intent/pounce 

/datum/action/cooldown/spell/abstractweapon/martialart/claws
	name = "Lynx Stance"
	desc = "Bare both hands, curling fingers as if into claws to slice into your foes.\n \
	<b>CUT</b>: A fast slice of the claws. Pays for sharpness in that its raw damage is significantly lesser than a simple punch. \n \
	<b>SLASH</b>: A swift slash which can hit multiple targets. \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>JAB</b>: A skilled user of this stance can execute a swift jab, able to penetrate light armor.\n \
	<b>DASH</b>: Your special is a DASH, giving you a bonus to SPEED, and allowing you to move through occupied spaces for a brief moment.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i>"
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/claws
	draw_message = "Curls their hands into claws!" 
	drop_message = "loses their clawed stance!"
	charge_time = 0.5 SECONDS
	button_icon_state = "claw"
	

/obj/item/rogueweapon/abstractweapon/martialart/claws //Similar in damage to a dagger, but most users won't be able to deal with armor
	name = "Claws"
	desc = "Your hands, curled into claws"
	force = 12 
	tiermult = 2 //lower scaling than normal punches. a tier 4 user will be roughly on par with a steel dagger in damage
	wbalance = WBALANCE_SWIFT
	twohands_required = FALSE //hope this isn't a bad idea
	sharpness = IS_SHARP
	icon_state = "claw"
	possible_item_intents = list(/datum/intent/claw/cut/martial/quick, /datum/intent/claw/cleave/fast, /datum/intent/claw/rend)
	baseintents = list(/datum/intent/claw/cut/martial/quick, /datum/intent/claw/cleave/fast, /datum/intent/claw/rend)
	masterstring = "As a master of this stance, my rend deals greater damage, and I gain access to a thrust attack with light armor penetration."
	masterintents = list(/datum/intent/claw/cut/martial/quick, /datum/intent/claw/cleave/fast, /datum/intent/claw/rend/steel, /datum/intent/dagger/thrust/martial)
	special = /datum/special_intent/dagger_dash

/datum/intent/claw/cut/martial
	icon_state = "inclaw"

/datum/intent/claw/cut/martial/master
	penfactor = PEN_LIGHT

/datum/intent/claw/cut/martial/quick
	damfactor = 0.9
	clickcd = CLICK_CD_FAST

/datum/intent/claw/lunge/martial
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_HEAVY
	penfactor = PEN_MEDIUM //as clumsy to use as steel claws, with lower penetration

/datum/intent/claw/lunge/martial/master //equivalent to steel claws (worse than iron, surprisingly)
	penfactor = PEN_HEAVY 

/datum/intent/dagger/thrust/martial //a slower version of a dagger thrust
	name = "jab"
	attack_verb = list("jabs", "stabs")
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/cleave
	name = "frenzy"
	icon_state = "incleave"
	attack_verb = list("claws through")
	animname = "cut"
	blade_class = BCLASS_CUT
	penfactor = PEN_NONE
	clickcd = CLICK_CD_GLACIAL
	item_d_type = "slash"
	cleave = /datum/cleave_pattern/frontal_arc
	desc = "Slash wildly, cleaving up to four nearby targets."

/datum/intent/claw/cleave/fast
	name = "slash"
	desc = "Slash wildly, cleaving up to one adjacent target."
	cleave = /datum/cleave_pattern/adjacent
	clickcd = CLICK_CD_MELEE

/datum/special_intent/pounce//high risk, high reward. If you whiff, immobilize yourself. if you hit 
	name = "Pounce"
	desc = "Leap at the target tile, rooting both yourself and adjacent targets in a frontal arc. Other targets hit are Exposed"
	cooldown = 30 SECONDS
	stamcost = 50 
	post_icon_state = "heavy_attack"
	pre_icon_state = "trap"
	respect_adjacency = FALSE
	delay = 0 //you get to jump into place instantly
	range = 3
	use_clickloc = TRUE
	tile_coordinates = list(list(0, 0))
	var/list/secondary_coordinates = list(list(-1, 0), list(0, 1), list(1, 0), list(-1, 1), list(1, 1))
	var/list/secondary_delay = 0.6 SECONDS
	var/turf/pouncedto
	var/dmg = 45
	var/exposedur = 3 SECONDS
	var/immobdur = 3 SECONDS

/datum/special_intent/pounce/apply_hit(turf/T)
	. = ..()
	var/mob/living/pouncer = howner
	if(!pouncedto)
		pouncer.OffBalance(30)
		pouncer.jump_action_resolve(T, 0, 3, FALSE, 3 SECONDS)
		sleep(1)
		while(pouncer.throwing)
			sleep(1)
		pouncedto = get_turf(pouncer)
		var/sfx = pick(list('sound/combat/ground_smash1.ogg','sound/combat/ground_smash2.ogg','sound/combat/ground_smash3.ogg'))
		playsound(pouncer, sfx, 200, TRUE)
		//okay, so this next step is copypasted from create_grid. We're essentially creating a new grid at the location the pouncer, and manually calling process_grid
		var/list/turflist = list()
		for(var/list/l in secondary_coordinates)
			var/dx = l[1]
			var/dy = l[2]
			switch(howner.dir)
				//if(NORTH) Do nothing because the coords are meant to be written from north-facing perspective. All is well.
				if(SOUTH)
					dx = -dx
					dy = -dy
				if(WEST)
					var/holder = dx
					dx = -dy
					dy = holder
				if(EAST)
					var/holder = dx
					dx = dy
					dy = -holder
			var/turf/step = locate((pouncedto.x + dx), (pouncedto.y + dy), pouncedto.z)
			if(step && isturf(step) && !step.density)	//We try to avoid doing Specials in walls.
				turflist.Add(step)
		if(turflist.len)
			_process_grid(turflist, secondary_delay)
		return
	if(pouncer.stat != CONSCIOUS || pouncer.IsParalyzed() || pouncer.IsStun() || QDELETED(pouncer) || !isturf(pouncer.loc) || !(pouncer.mobility_flags & MOBILITY_STAND))
		return
	if(get_turf(pouncer) != pouncedto)
		return
	if(istype(iparent, /obj/item/rogueweapon/abstractweapon/martialart))	
		var/obj/item/rogueweapon/abstractweapon/martialart/weapon = iparent
		dmg = (weapon.force * 3)
		exposedur = weapon.tier SECONDS 
		immobdur = weapon.tier SECONDS
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(isbelly(L.loc))
			continue
		if(L != howner)
			apply_generic_weapon_damage(L, dmg, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)
			L.apply_status_effect(/datum/status_effect/debuff/exposed, exposedur)
			L.Immobilize(immobdur)
			playsound(L, 'sound/combat/brutal_impalement.ogg', 100, TRUE)

/datum/special_intent/pounce/_reset()
	pouncedto = null
	. = ..()
