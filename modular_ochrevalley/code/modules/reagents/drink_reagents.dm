//Descriptions, tastes, and names all done by Dragor
/datum/reagent/water
	var/quality = 0 //So these show up nicer on the favorite list, and we can integrate it if upstream ever uses this variable

/datum/reagent/water/bufftea
	description = ""
	reagent_state = LIQUID
	quality = DRINK_NICE

/datum/reagent/water/bufftea/on_mob_life(mob/living/carbon/M) 
	//These may only give +1, but we still don't want stacking, especially since they stack with buff potions.
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(istype(R, /datum/reagent/water/bufftea) && R != src)
			holder.remove_reagent(R.type, 10)
			// Rapidly purge stacking buffs
		if(istype(R, /datum/reagent/consumable/caffeine/ravoxtea))
			holder.remove_reagent(R.type, 10) //Just to cover our bases.
	..()

/datum/reagent/water/bogtea
	name = "Bog Tea"
	description = "Before the bog guard was dissolved, this was their unoffical drink of choice. Doesn't get you high"
	reagent_state = LIQUID
	color = "#addfad" 
	taste_description = "resinous herbaceousness"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/bufftea/minttea
    name = "Mint Tea"
    description = "Steeped minthra. Etruscans love this stuff before going out for courting."
    reagent_state = LIQUID
    color = "#e5ffe5"
    taste_description = "peppermint"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM
    alpha = 173

/datum/reagent/water/bufftea/minttea/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/tea/intellegencetea)
	return ..()

/datum/reagent/water/wormwoodtea
    name = "Wormwood Tea"
    description = "Usually this is used as an intense bittering agent. Why would you drink this pure?"
    reagent_state = LIQUID
    color = "#2f4f4f"
    taste_description = "extreme bitterness"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM
    alpha = 173

/datum/reagent/water/wormwoodtea/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/HM = M
		if(HM.culinary_preferences[CULINARY_FAVOURITE_DRINK] != type) //You shouldn't hate the bitterness if you love the drink!
			M.add_stress(/datum/stressevent/bittertea)

/datum/reagent/water/sagetea
    name = "Sage Tea"
    description = "A pungent flavour, but favoured by Grenzelhoftian grandmothers to cure the sniffles."
    reagent_state = LIQUID
    color = "#c2b280"
    taste_description = "herbal pepperiness"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM
    alpha = 173

/datum/reagent/water/valeriantea
    name = "Valerian Tea"
    description = "Most people don’t drink this for its taste, but because it is reputed to ward off nightmares."
    reagent_state = LIQUID
    color = "#967117"
    taste_description = "musky bitterness"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM
    alpha = 173

/datum/reagent/water/baothatea
    name = "Baothan Tea"
    description = "Those with little regard for their lyfe or Baothans drink this."
    reagent_state = LIQUID
    color = "#ba55d3"
    taste_description = "sweet oblivion"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/water/baothatea/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M, TRAIT_DEPRAVED) && volume > 0.09) //Baothans are immune, for culty reasons.
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(1) 
		else
			M.add_nausea(3) 
			M.adjustToxLoss(2.5) //A bit stronger than berry poison. Will put you into crit with a sip. 

/datum/reagent/water/bufftea/eyebrighttea
    name = "Euphrasia Tea"
    description = "Old people drink this to keep their eyes sharp. Some say elves distill its oil for a better effect."
    reagent_state = LIQUID
    color = "#f3e5ab"
    taste_description = "astringent, herbal bitterness"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/water/bufftea/eyebrighttea/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/tea/perceptiontea)
	return ..()

/datum/reagent/consumable/caffeine/bloomtea
    name = "Bloom Tea"
    description = "The drink of choice of the Celestial Academy, reputed to recover magical fatigue. Everyone knows they just like the pretty, deep blue colour."
    reagent_state = LIQUID
    color = "#000080"
    taste_description = "tingling electricity"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/water/eorantea
    name = "Eoran Tea"
    description = "Every child from Gronn to Naledi knows - if you are sick, drink this. You will feel better. At least that is what parents insist on."
    reagent_state = LIQUID
    color = "#e9d66b"
    taste_description = "citric earthiness"
    overdose_threshold = 0
    metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/water/eorantea/on_mob_life(mob/living/carbon/M) //Just the same as rose tea. Both herb-based, and calendula's the health one.
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/ashtea
    name = "Ashtray Tea"
    description = "This is like zig butts steeped in hot water. Yummy."
    reagent_state = LIQUID
    color = "#4b5320"
    taste_description = "zig roaches"
    overdose_threshold = 0

/datum/reagent/water/ashtea/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.add_nausea(1) //Makes you sort of sick.

/datum/reagent/water/bufftea/psytea
    name = "Pilgrim Tea"
    description = "A favourite among psydonic pilgrims, the hardy plant makes for a surprisingly palatable tea."
    reagent_state = LIQUID
    color = "#87a96b"
    taste_description = "nostalgic herbaceousness"
    overdose_threshold = 0

/datum/reagent/water/bufftea/psytea/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/tea/willpowertea)
	return ..()

/datum/reagent/water/bufftea/dandelioncoffee
    name = "Dandelion Coffee"
    description = "Ravoxians and Graggarites alike drink this when not feasting, for it's reputed to give you a lion’s heart."
    reagent_state = LIQUID
    color = "#fdee00"
    taste_description = "dark, nutty bitterness"
    overdose_threshold = 0

/datum/reagent/water/bufftea/dandelioncoffee/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/tea/constitutiontea)
	return ..()

/datum/reagent/water/nettletea
    name = "Nettle Tea"
    description = "Drunk by soldiers who want to freshen up their water rations in the field."
    reagent_state = LIQUID
    color = "#87a96b"
    taste_description = "mild herbaceousness"
    overdose_threshold = 0

/datum/reagent/water/chamomiletea
    name = "Chamomile Tea"
    description = "9 out of 10 barber-surgeons prescribe this for tooth aches. The last one just pulls it out."
    reagent_state = LIQUID
    color = "#b8860b"
    taste_description = "herbaceous grassiness"
    overdose_threshold = 0

//New blends:

/datum/reagent/consumable/caffeine/raneshenbitter
	name = "Raneshen Bitter Tea"
	description = "Dark and foreboding, a bitter reminder of the loss of PSYDON, to be followed by sweet exaltation of HIS sacrifice."
	reagent_state = LIQUID
	color = "#663854" // This will put hair on your chest colour
	taste_description = "smooth, intense bitterness"
	quality = DRINK_GOOD

/datum/reagent/water/eorasgracetea
	name = "Eora's Grace"
	description = "And she held my hand gently and she smiled. I cried, for I remembered my mother. How I miss her so."
	reagent_state = LIQUID
	color = "#fbaed2"
	taste_description = "fruity herbaceousness"
	quality = DRINK_NICE

/datum/reagent/water/eorasgracetea/on_mob_life(mob/living/carbon/M) //Just the same as rose tea. Both herb-based, and calendula's the health one.
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/eorasloveteafake
	name = "Faked Eora's Love"
	description = "A testament that humankind can never reach the perfection of the gods. Is this love? Or just a really sweet tea?"
	reagent_state = LIQUID
	color = "#fba0e3"
	taste_description = "saccharine fruitiness"
	quality = DRINK_GOOD

/datum/reagent/water/eorasloveteafake/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/eorasloveteatrue
	name = "Eora's Love"
	description = "Humenkind cannot love like the gods, but they do not need to. They have each other and this bond is Eora's most cherished fact of the world."
	reagent_state = LIQUID
	color = "#fba0e3"
	taste_description = "affection"
	quality = DRINK_VERYGOOD

/datum/reagent/water/eorasloveteatrue/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.45  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.45  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1.5)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/ravoxtea
	name = "Ravox's Calm"
	description = "Brew this and drink deep. Feel the focus. Draw your blade with an unclouded mind and let justice speak where mercy was ignored."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "mind-clearing bitterness"
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/ravoxtea/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.apply_status_effect(/datum/status_effect/buff/tea/constitutiontea)

/datum/reagent/consumable/caffeine/mocha
	name = "Sand Coffee"
	description = "I make this pot in the name of the Allfather, stranger. Sit down and drink. As long the brew remains, we shall be brothers. When it is empty, we will depart and maybe see each other again."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "bitter chocolate"
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/mocha/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/gerevine
	name = "Gerevine Brew"
	description = "It is said that this drink was the first offered to the Saints, when they descended and walked among the faithful. They wept, for it reminded them of the Allfather."
	reagent_state = LIQUID
	color = "#fdbcb4" 
	taste_description = "nostalgic homesickness"

/datum/reagent/water/gerevine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
	M.apply_status_effect(/datum/status_effect/buff/tea/willpowertea)

/datum/reagent/consumable/caffeine/schorle
	name = "Apfelschorle"
	description = "Come! Watch me drink the orchard's finest nectar! Ah, lyfe can be so wonderful."
	reagent_state = LIQUID
	color = "#d0f0c0" 
	taste_description = "pearly tartness" // drink of the gods
	quality = DRINK_GOOD
/datum/reagent/consumable/caffeine/schorle/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5) // 1/3 of mana pot after the caffiene energy. Should be fair given it costs ~3x as much as a mana potion, but also gives energized

/datum/reagent/water/boathablend
	name = "Void's Embrace"
	description = "So dark it swallows the stars. Regret incarnate. Sup from it and forget."
	reagent_state = LIQUID
	color = "#d00000" 
	taste_description = "merciful oblivion"
	quality = DRINK_VERYGOOD

/datum/reagent/water/boathablend/on_mob_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_warning("As your lips touch the brew and you drink, you feel yourself cry. Pain surges through you, not physical, but within your heart. All the slights, the taunts, the hurts in your lyfe rush through your head as your body gives out.\n \
Your dreams are a confusing mess of visions of what you have to put up with, the great and the small anguishes of your lyfe and some more - memories you do not recognise. The smile of your sister, her tears when you are judged to die, his hands on your throat as they squeeze and squeeze-\n \
You wake up.\n \
What were you dreaming again? Wait… Where are you?\n \
Who are you?\n \
You have forgotten everything…"))
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.Sleeping(rand(30 SECONDS, 50 SECONDS))
		H.visible_message(span_warning("[H] suddenly collapses!"))
		H.apply_status_effect(/datum/status_effect/debuff/tea/baothaforget) //Nuke their int for a bit, because actually forgetting skills is difficult/mean


/datum/reagent/water/forgottenlove
	name = "Tea of Sisters"
	description = "How can it be? Something so vile and something so pure combined brings forth something new and unprecedented."
	reagent_state = LIQUID
	color = "#de6fa1" 
	taste_description = "bittersweet nostalgia"
	quality = DRINK_FANTASTIC

/datum/reagent/water/forgottenlove/on_mob_metabolize(mob/living/L)
	. = ..()
	to_chat(L, span_warning("You remember something that you couldn't remember.\n\
Of staring into the night sky. \n\
Of wishing things could have been different.\n\
Of it not being too late.\n\
Regret weighs like a stone in your chest.\n\
How strange.\n\
You see the sky from a pit and a palace both."))

/datum/reagent/water/boathablend/on_mob_life(mob/living/carbon/M) //Still nowhere near a health potion, so it can't remotely be an alchemy alternative
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.25, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(2)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/chai
	name = "Chai"
	description = "And on we march to unite the Isles. Gleaming naginatas clash against wicker shields and in the nite we drink Aisata's favoured tea."
	reagent_state = LIQUID
	color = "#b78727" 
	taste_description = "peppery-sweet grassiness"
	quality = 2

/datum/reagent/consumable/caffeine/chai/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/volfmilk
	name = "Vargmjölk"
	description = "And we ring the fire, backs turned in snide to the cold. Volf-skinned, we thank you for snatching this brew from the teats of the world…"
	reagent_state = LIQUID
	color = "#d3003f" 
	taste_description = "warm, fruity sweetness"

/datum/reagent/water/icetea
	name = "Fruktte"
	description = "And in the mountains we tear the frozen tears of the moose, for we do not lose ourselves in bloodshed yet like it wants us to. Instead, we enjoy a good cup with friends and clan."
	reagent_state = LIQUID
	color = "#0f4d92" 
	taste_description = "cooled fruitiness"

/datum/reagent/water/barleytea
	name = "Barley Tea" //Technically this is an asian drink but fuck it, I love the idea.
	description = "Reality is a state of mind caused by the chronic lack of alcohol in the humours. This won't fix it, but at least it whets the tongue, lad."
	reagent_state = LIQUID
	color = "#e08d3c" 
	taste_description = "toasty bitterness" 

/datum/reagent/water/kvass
	name = "Kvass" //Bread soder…
	description = "Tis the bread we drink. Mount the saigas then and let us ride. For the steppe waits for no one and our forefather gave us this so we don't have to chew our meal."
	reagent_state = LIQUID
	color = "#b78727" 
	taste_description = "astringent-sweet cereals" 

/datum/reagent/water/avantare
	name = "Avantare" //Just made up.
	description = "Furl the sails, take down the mizzenmast. Drink our Avantare and hug your wife. We are home, finally home again."
	reagent_state = LIQUID
	color = "#ffff66" 
	taste_description = "freshening sourness" 

/datum/reagent/water/gerevine/on_mob_life(mob/living/carbon/M) //Wards off illness, so make it a really weak antidote + heal
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustToxLoss(-1,0)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()
