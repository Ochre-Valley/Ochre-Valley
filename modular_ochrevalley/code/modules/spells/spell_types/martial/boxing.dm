/datum/action/cooldown/spell/abstractweapon/martialart/boxing
	name = "Bare-knuckle Boxing"
	desc = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>SUCKER PUNCH</b>: A very weak punch which can't be dodged or parried. \n \
	<b>LEFT HOOK</b>: In swift stance, your special attack is a swift LEFT HOOK to the mouth, which dazes the target. If the target is exposed, vulnerable, or unprepared for combat, they're SILENCED \n \
	You can switch your grip to enable HEAVY stance, switching to the following intents: \n \
	<b>CROSS</b>: A strong, straight punch with your main hand.\n \
	<b>HAYMAKER</b>: A slow, predictable punch, which hits hard and can daze the target if it damages their head, as well as knock them back if you're strong enough.\n \
	<b>UPPER CUT</b>: In heavy stance, your special attack is an UPPER CUT, a slow, charged hit. Does massive damage to vulnerable targets, and knocks them down!\n \
	<i>A homegrown azurian martial art emphasizing a strong form and center of balance, favored for its usefulness to people of most builds in pit-fights</i>"
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart/boxing
	draw_message = "Puts up their dukes!" 
	drop_message = "drops their hands!"
	
/obj/item/rogueweapon/abstractweapon/martialart/boxing
	name = "Fists"
	desc = "Your hands, raised into iron fists"
	force = 15 
	tiermult = 2.5 //Damage scales about as hard as normal fists. Our power scales with our intent
	wbalance = WBALANCE_HEAVY
	alt_grips = list(/datum/alt_grip/boxing)
	possible_item_intents = list(/datum/intent/martial/jab, /datum/intent/martial/sucker_punch)
	masterstring = "As a master of this stance, my jab hits 10% harder, my uppercut comes out a bit faster, and my haymakers become less clumsy."
	masterintents = list(/datum/intent/martial/jab/master, /datum/intent/martial/sucker_punch)
	mastergrips = list(/datum/alt_grip/boxing/master)
	special = /datum/special_intent/silencepunch 

/datum/alt_grip/boxing
	name = "heavy stance"
	two_handed = TRUE
	grip_intents = list(/datum/intent/martial/cross, /datum/intent/mace/smash/martial)
	var_overrides = list("wlength" = WLENGTH_NORMAL, "wbalance" = WBALANCE_HEAVY, "special" = /datum/special_intent/upper_cut)

/datum/alt_grip/boxing/master
	grip_intents = list(/datum/intent/martial/cross, /datum/intent/mace/smash/martial/master)
	var_overrides = list("wlength" = WLENGTH_NORMAL, "wbalance" = WBALANCE_HEAVY, "special" = /datum/special_intent/upper_cut/master)

/datum/intent/martial/jab //this is nearly equivalent to a normal punch, but deals slightly less damage, and is capped based on tier
	name = "jab"
	desc = "A quick, weak punch"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg','sound/combat/hits/punch/punch (2).ogg','sound/combat/hits/punch/punch (3).ogg')
	damfactor = 0.9

/datum/intent/martial/jab/master //masters of boxing get a punch... roughly equivalent to a normal, unstanced punch.
	damfactor = 1

/datum/intent/martial/sucker_punch//similar to a dagger's sucker punch
	name = "sucker punch"
	desc = "A weak punch that can't be evaded"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg','sound/combat/hits/punch/punch (2).ogg','sound/combat/hits/punch/punch (3).ogg')
	attack_verb = list("sucker punches", "sneakily hooks")
	damfactor = 0.5
	clickcd = CLICK_CD_MELEE
	icon_state = "instrike"
	canparry = FALSE
	candodge = FALSE

/datum/intent/martial/cross
	name = "cross"
	desc = "A relatively slow, strong punch"
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE

/datum/intent/mace/smash/martial
	name = "haymaker"
	desc = "A heavy hook from over the shoulder, which deals knockback from 1-3, scaling with your strength in excess of ten. Dazes the target if it deals damage to their head."
	icon_state = "indaze"
	attack_verb = list("slugs", "pummels")
	hitsound = list('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg', 'sound/misc/bonk.ogg')
	chargedrain = 2 // 
	chargetime = 10
	damfactor = 2
	target_parts = list(BODY_ZONE_HEAD)
	intent_effect = /datum/status_effect/debuff/dazed/stunner
	maxrange = 3

/datum/intent/mace/smash/martial/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] winds up for a big punch!"))

/datum/intent/mace/smash/martial/master
	desc = "A heavy hook from over the shoulder, which deals knockback from 1-4, scaling with your strength in excess of ten"
	chargedrain = 1
	chargetime = 8
	maxrange = 4

/datum/special_intent/upper_cut/master
	delay = 8

/datum/special_intent/silencepunch //shameless uppercut copypasta tbh
	name = "Strong Hook"
	desc = "Swiftly charge a left hook which dazes the target. If it connects with a target who is exposed or unprepared, they will be Silenced. Always aims for the head."
	tile_coordinates = list(list(0,0))
	post_icon_state = "kick_fx"
	pre_icon_state = "trap"
	respect_adjacency = TRUE
	delay = 5
	cooldown = 60 SECONDS//swift attack, costs more
	stamcost = 40 //it comes out pretty quick, so pay more for it!
	var/silence_dur = 15 SECONDS
	var/dam = 20
	var/KD_dur = 1 SECONDS
	var/self_immob_dur = 1 SECONDS
	var/pixel_z
	var/prev_pixel_z
	var/prev_transform
	var/transform

/datum/special_intent/silencepunch/on_create()
	. = ..()
	
	howner.OffBalance(self_immob_dur)
	howner.Immobilize(self_immob_dur)
	dam = initial(dam)
	prev_pixel_z = howner.pixel_z
	prev_transform = howner.transform
	//OV Add end
	playsound(howner, 'sound/combat/ground_smash_start.ogg', 100, TRUE)
	if(HAS_TRAIT(howner, TRAIT_BIGGUY))
		return // windup
	else
		animate(howner, pixel_z = howner.pixel_z - 4, time = 3) //OV edit

/datum/special_intent/silencepunch/apply_hit(turf/T) //SHameless copypaste of uppercut, with a few changes~
	for(var/mob/living/L in get_hearers_in_view(0, T))
		//OV edit
		if(isbelly(L.loc))
			continue
		//OV edit end
		if(L != howner)

			if(L.has_status_effect(/datum/status_effect/debuff/exposed) || L.has_status_effect(/datum/status_effect/debuff/vulnerable) || !L.cmode) // sucker punch! Also procs if the target isn't ready for combat.
				L.set_silence(silence_dur)
				dam = 50
				playsound(howner, 'sound/misc/bonk.ogg', 100, TRUE)
				L.remove_status_effect(/datum/status_effect/debuff/exposed)
				L.remove_status_effect(/datum/status_effect/debuff/vulnerable)
				to_chat(L, span_userdanger("I've been hit across the jaw! I can't speak!"))

			apply_generic_weapon_damage(L, dam, "blunt", BODY_ZONE_HEAD, bclass = BCLASS_BLUNT, no_pen = TRUE)
			L.apply_status_effect(/datum/status_effect/debuff/dazed)
			playsound(howner, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
	if(HAS_TRAIT(howner, TRAIT_BIGGUY))
		return
	else
		animate(howner, pixel_z = pixel_z + 12, time = 2)
		animate(pixel_z = prev_pixel_z, transform = turn(transform, pick(-12, 0, 12)), time=2)
		animate(transform = prev_transform, time = 0)
	return ..()
	

