/datum/action/cooldown/spell/abstractweapon/martialart/karate
	name = "Hollow Hand Stance"
	desc = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>AXE HAND</b>: A telegraphed hit which does heavy damage to objects. \n \
	<b>KANABO STRIKE</b>: A telegraphed strike with the palm, knocking the target back.\n \
	<b>WRING</b>: A telegraphed strike which deals TWIST damage to the target.\n \
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
	//special = 


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
