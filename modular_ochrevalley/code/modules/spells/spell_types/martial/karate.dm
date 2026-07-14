/datum/action/cooldown/spell/abstractweapon/martialart/karate
	name = "Hollow Hand Stance"
	desc = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>AXE HAND</b>: A telegraphed hit which does heavy damage to objects. \n \
	<b>KANABO STRIKE</b>: A telegraphed strike with the palm, knocking the target back.\n \
	<b>WRING</b>: A telegraphed strike which deals TWIST damage to the target.\n \
	<b>FLYING LIGHTNING KICK</b>: Your special is a leap into a distant tile, after which you execute a series of wild kicks!\n \
	<i>A Kazengun martial art tradition, refined from an ancient lingyuan style.</i>"
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/karate
	draw_message = "Enters the Hollow Hand stance." 
	drop_message = "drops their stance!"
	
/obj/item/rogueweapon/abstractweapon/martialart/karate
	name = "Hollow Palms"
	desc = "Your hands- bereft of weapons, yet still deadly"
	force = 15 
	tiermult = 2.5 //Damage scales about as hard as normal fists. Our power scales with our intent
	wbalance = WBALANCE_NORMAL
	possible_item_intents = list(/datum/intent/martial/jab/karate, /datum/intent/martial/chop, /datum/intent/martial/smash, /datum/intent/martial/dislocate)
	masterstring = "As a master of this stance, my chop becomes sharp, my kanabo deals more knockback, and my wring comes out quicker."
	masterintents = list(/datum/intent/martial/jab/karate, /datum/intent/martial/chop/master, /datum/intent/martial/smash/master, /datum/intent/martial/dislocate/master)
	special = /datum/special_intent/flyingkick //this is a meme. if it turns out to be powerful, i am ver  dum


/datum/intent/martial/jab/karate
	hitsound = list('sound/combat/hits/kick/kick.ogg')

/datum/intent/martial/chop
	name = "Axe Hand"
	desc = "A slow, telegraphed chop, which deals greater damage to objects"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	penfactor = PEN_NONE
	damfactor = 1.5
	swingdelay = 10
	demolition_mod = 3
	clickcd = CLICK_CD_GLACIAL

/datum/intent/martial/chop/master 
	blade_class = BCLASS_CHOP
	penfactor = PEN_LIGHT
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	item_d_type = "slash"

/datum/intent/martial/smash
	name = "Kanabo Strike"
	desc = "A telegraphed palm strike, knocking the target back"
	icon_state = "insmash"
	attack_verb = list("strikes")
	damfactor = 1.2
	chargetime = 5
	chargedrain = 2
	var/knockback = 3

/datum/intent/martial/smash/master
	chargedrain = 1
	knockback = 4

/datum/intent/martial/smash/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] reels their hand back with an open palm!"))

/datum/intent/martial/smash/smash/spec_on_apply_effect(mob/living/H, mob/living/user, params) //copypasted from mace smashes! the difference here is that we don't scale off of strength for this martial art 
	if(user?.client?.chargedprog < 100) //not fully charged? you get NOTHING
		return
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(knockback)
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback, \
		knockback, \
		user, \
		spin = FALSE, \
		force = H.move_force)
// Do not call handle_knockback like in knockback cuz that means it will hardstun.


/datum/intent/martial/dislocate
	name = "Wring"
	desc = "Grab and wrench whatever you can get your hands on, dealing TWIST damage!"
	blade_class = BCLASS_TWIST
	icon_state = "intwist"
	attack_verb = list("strikes")
	damfactor = 1.2
	intent_intdamage_factor = 0.4
	chargetime = 10
	chargedrain = 1
	clickcd = CLICK_CD_CHARGED

/datum/intent/martial/dislocate/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] holds both hands up, with fingers curled..."))

/datum/intent/martial/dislocate/master
	chargetime = 7

/datum/special_intent/flyingkick
	name = "Flying Thunder Kick"
	desc = "Leap at the target tile, before releasing a flurry of kicks in random directions"
	cooldown = 30 SECONDS
	stamcost = 40 //cheaper than a jump, but you'll pay stamina for every kick you make
	tile_coordinates = list(list(0,0))
	respect_adjacency = FALSE
	range = 5

/datum/special_intent/flyingkick/apply_hit(turf/T)
	. = ..()
	var/mob/living/kicker = howner
	var/efficacy = kicker.get_skill_level(/datum/skill/combat/unarmed) //first calc uses this, if it's someone's unarmed special
	if(istype(iparent, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/weapon = iparent
		efficacy = kicker.get_skill_level(weapon.associated_skill)
	
	var/jumprange = min(3, efficacy) //default range limit is equal to that of a running jump
	if(HAS_TRAIT(kicker, TRAIT_LEAPER)) //but acrobats can go a bit further
		jumprange += 1
	if(!kicker.check_armor_skill() || kicker.get_item_by_slot(SLOT_LEGCUFFED))
		jumprange = 1
	
	kicker.OffBalance(40)
	var/kickamt = rand(efficacy * 2, efficacy * 4) //there's not much point in kicking this much, given kicks knock people back. pointlessly flashy 
	kicker.jump_action_resolve(T, 0, jumprange, TRUE, kickamt + 2)
	while(kicker.throwing)
		sleep(1)
	if(kicker.stat != CONSCIOUS || kicker.IsParalyzed() || kicker.IsStun() || QDELETED(kicker) || !isturf(kicker.loc) || !(kicker.mobility_flags & MOBILITY_STAND))
		return //you fucked up, or got sent to a belly like a dumbass

	
	//first, we're gonna try and stomp anyone we landed on, and directly in front of us
	kicker.try_kick(get_turf(kicker))
	kicker.try_kick(get_step(get_turf(kicker), kicker.dir))
	var/soundchoice = pick(PUNCHWOOSH)
	playsound(kicker, soundchoice, 100, TRUE)
	sleep(1)
	//next, we're going to execute the actual "tornado kick. For every point of Kickamt, kick a random adjacent tile"
	kicker.visible_message(span_warning("[kicker] leaps forwards, executing a flurry of wild kicks!"))
	for(var/I in 1 to kickamt)
		if(kicker.stat != CONSCIOUS || kicker.IsParalyzed() || kicker.IsStun() || QDELETED(kicker) || !isturf(kicker.loc) || !(kicker.mobility_flags & MOBILITY_STAND))
			break
		var/dir = pick(GLOB.alldirs)
		kicker.try_kick(get_step(get_turf(kicker), dir))
		var/sound = pick(PUNCHWOOSH)
		playsound(kicker, sound, 50, TRUE)
		var/obj/effect/temp_visual/special_intent/fx = new (T, 3)
		fx.icon = _icon
		fx.icon_state = "kick_fx"
		sleep(1)

