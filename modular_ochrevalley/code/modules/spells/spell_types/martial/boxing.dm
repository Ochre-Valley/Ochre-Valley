/datum/action/cooldown/spell/abstractweapon/martialart/boxing
	name = "Bare-knuckle Boxing"
	desc = "Raise both hands up, entering a versatile stance which combines light and heavy attacks\n \
	<b>JAB</b>: A swift punch which does low damage. \n \
	<b>SUCKER PUNCH</b>: A very weak punch which can't be dodged or parried. \n \
	You can switch your grip to enable HEAVY stance, switching to the following intents: \n \
	<b>CROSS</b>: A strong, straight punch with your main hand.\n \
	<b>HAYMAKER</b>: A slow, predictable punch, which hits hard and can daze the target if it damages their head, as well as knock them back if you're strong enough.\n \
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
	masterstring = "As a master of this stance, my jab hits 10% harder, and my haymakers become less clumsy."
	masterintents = list(/datum/intent/martial/jab/master, /datum/intent/martial/sucker_punch)
	mastergrips = list(/datum/alt_grip/boxing/master)
	special = /datum/special_intent/upper_cut //fucking duh.

/datum/alt_grip/boxing
	name = "heavy stance"
	two_handed = TRUE
	grip_intents = list(/datum/intent/martial/cross, /datum/intent/mace/smash/martial)
	var_overrides = list("wlength" = WLENGTH_NORMAL, "wbalance" = WBALANCE_HEAVY)

/datum/alt_grip/boxing/master
	grip_intents = list(/datum/intent/martial/cross, /datum/intent/mace/smash/martial/master)

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


	