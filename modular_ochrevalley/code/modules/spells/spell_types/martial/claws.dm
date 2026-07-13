/datum/action/cooldown/spell/abstractweapon/martialart/bigclaws
	name = "Direbear Stance"
	desc = "Bare both hands, curling fingers as if into talons to rip and tear into your foes.\n \
	<b>CUT</b>: Swing with your claws. Does comparable damage to a punch, cutting the target at the cost of being slower and clumsier. \n \
	<b>LUNGE</b>: A telegraphed attempt to plunge your claws into a target, penetrating light armor! \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>FRENZY</b>: A skilled user of this stance can execute a wild, cleaving slash that can hit multiple targets.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i> "
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/bigclaws
	draw_message = "Curls their hands into terrible claws!" 
	drop_message = "loses their clawed stance!"
	

/obj/item/rogueweapon/abstractweapon/martialart/bigclaws //Similar to handclaws, with lower damage and armor penetration.
	name = "Heavy Claws"
	desc = "Your hands, curled into terrible claws"
	force = 15 
	tiermult = 2.5 //Damage scales about as hard as normal fists- a t4 user is about 10 damage behind someone with gronnic claws
	wbalance = WBALANCE_HEAVY
	possible_item_intents = list(/datum/intent/claw/cut/martial, /datum/intent/claw/lunge/martial, /datum/intent/claw/rend)
	masterstring = "As a master of this stance, my lunge and slash can penetrate greater protection, and I gain access to a wild, cleaving slash."
	masterintents = list(/datum/intent/claw/cut/martial/master, /datum/intent/claw/lunge/martial/master, /datum/intent/claw/rend, /datum/intent/claw/cleave)

/datum/action/cooldown/spell/abstractweapon/martialart/claws
	name = "Badger Stance"
	desc = "Bare both hands, curling fingers as if into claws to slice into your foes.\n \
	<b>CUT</b>: A fast slice of the claws. Pays for sharpness in that its raw damage is significantly lesser than a simple punch. \n \
	<b>SLASH</b>: A swift slash which can hit multiple targets. \n \
	<b>REND</b>: A telegraphed strike  for high damage, perfect for disemboweling unarmored targets!\n \
	<b>JAB</b>: A skilled user of this stance can execute a swift jab, able to penetrate light armor.\n \
	<i>A 'martial art' of no certain origin, practiced and taught first by those blessed by dendor's gift of claws.</i>"
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/claws
	draw_message = "Curls their hands into claws!" 
	drop_message = "loses their clawed stance!"
	

/obj/item/rogueweapon/abstractweapon/martialart/claws //Similar in damage to a dagger, but most users won't be able to deal with armor
	name = "Claws"
	desc = "Your hands, curled into claws"
	force = 12 
	tiermult = 2 //lower scaling than normal punches. a tier 4 user will be roughly on par with a steel dagger in damage
	wbalance = WBALANCE_SWIFT
	possible_item_intents = list(/datum/intent/claw/cut/martial/quick, /datum/intent/claw/cleave/fast, /datum/intent/claw/rend)
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
	cleave = /datum/cleave_pattern/wide_sweep
	desc = "Slash wildly, cleaving up to two nearby targets."

/datum/intent/claw/cleave/fast
	name = "slash"
	desc = "Slash wildly, cleaving up to one adjacent target."
	cleave = /datum/cleave_pattern/adjacent
	clickcd = CLICK_CD_MELEE
