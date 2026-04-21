// Storyteller scaling (roundstart, storyteller_scale_slots path):
// scaling=2, min_players=25, default_cap=2
//  Storyteller    | Cap | <25 | 25-40 | 41+
//  Noc            |  1  |  0  |   1   |  1
//  Dendor/Others  |  2  |  0  |   2   |  2
/datum/antagonist/werewolf
	name = "Verewolf"
	roundend_category = "Werewolves"
	antagpanel_category = "Werewolf"
	job_rank = ROLE_WEREWOLF
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_favor_flags = STORYTELLER_FAVOR_WEREWOLF
	override_candidatereq = TRUE
	storyteller_min_players = 25
	storyteller_slot_scaling = 2
	storyteller_slot_default_cap = 2
	storyteller_maxcaps = list(/datum/storyteller/noc = 1, /datum/storyteller/dendor = 2)
	var/list/inherent_traits = list(
		TRAIT_IGNORESLOWDOWN,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOPAIN, 
		TRAIT_NOPAINSTUN, 
		TRAIT_CRITICAL_RESISTANCE, 
		TRAIT_NOFALLDAMAGE1, 
		TRAIT_KNEESTINGER_IMMUNITY, 
		TRAIT_SHOCKIMMUNE,
		TRAIT_SILVER_WEAK,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_LONGSTRIDER,
		TRAIT_SPELLCOCKBLOCK,
		TRAIT_PIERCEIMMUNE,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_TOXIMMUNE,
		TRAIT_BREADY,
		TRAIT_STEELHEARTED,
		TRAIT_BASHDOORS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_ZJUMP,
		TRAIT_NOSLEEP,
		TRAIT_GRABIMMUNE,
		TRAIT_STRONGBITE,
		TRAIT_LYCANRESILENCE,
		TRAIT_CHUNKYFINGERS, //So they can no longer use weapons at all.
		TRAIT_UNLYCKERABLE, //Literal archenemy
		TRAIT_ZOMBIE_IMMUNE
	)
	confess_lines = list(
		"THE BEAST INSIDE ME!",
		"BEWARE THE BEAST!",
		"MY LUPINE MARK!",
	)
	rogue_enabled = TRUE
	var/special_role = ROLE_WEREWOLF
	var/transformed
	var/transforming
	var/untransforming
	var/resisting_transformation = FALSE // Caustic Edit
	var/ignore_transformation_resist = FALSE // Caustic Edit
	var/wolfname = "Verewolf"
	has_tempo = TRUE
	var/static/list/dendor_cries = list('sound/effects/werewolf_sounds/wscream1.ogg',
								'sound/effects/werewolf_sounds/wscream2.ogg',
								'sound/effects/werewolf_sounds/wscream3.ogg',
								'sound/effects/werewolf_sounds/wscream4.ogg',
								'sound/effects/werewolf_sounds/wscream5.ogg')
// OV EDIT START
	var/allow_rename = FALSE
	var/wolfdesc
	var/wolfdesc_cached
	var/list/werewolf_verbs = list(
		/mob/living/carbon/human/proc/werewolf_changename,
		/mob/living/carbon/human/proc/werewolf_changedesc
	)

/datum/antagonist/werewolf/proc/apply_verbs(mob/M)
	if(!M) return
	for(var/verb_path in werewolf_verbs)
		M.verbs |= verb_path

/datum/antagonist/werewolf/proc/remove_verbs(mob/M)
	if(!M) return
	for(var/verb_path in werewolf_verbs)
		M.verbs -= verb_path

/proc/examine_span_details(title, content) // This feels dumb. Original define at 'modular_causticcove/__DEFINES/slop.dm', it's not loaded when 'code/modules/mob/living/carbon/human/examine.dm' is. -- Umbree.
    return "<details><summary>[title]</summary>[content]</details>"
// OV EDIT END
/datum/antagonist/werewolf/lesser
	name = "Lesser Verewolf"
	increase_votepwr = FALSE

/datum/antagonist/werewolf/lesser/roundend_report()
	return

/datum/antagonist/werewolf/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/werewolf/lesser))
		return span_boldnotice("A young lupine kin.")
	if(istype(examined_datum, /datum/antagonist/werewolf))
		return span_boldnotice("An elder lupine kin.")
	if(istype(examined_datum, /datum/antagonist/maniac))
		return span_boldnotice("A fool.")
	if(istype(examined_datum, /datum/antagonist/dreamwalker))
		return span_boldnotice("The dreamer has this one in his grasp.")
	if(istype(examined_datum, /datum/antagonist/gnoll))
		return span_boldnotice("An abomination.")
	if(examiner.Adjacent(examined))
		if(istype(examined_datum, /datum/antagonist/lich))
			return span_boldnotice("A deadite freek.")
		if(istype(examined_datum, /datum/antagonist/vampire))
			return span_boldnotice("A putrid vampyr, I should watch my back.")
		if(istype(examined_datum, /datum/antagonist/vampire/lord))
			if(transformed)
				return span_boldwarning("An ancient vampyr. I must be careful!")

/datum/antagonist/werewolf/on_gain()
	greet()
	owner.special_role = name
	if(increase_votepwr)
		forge_werewolf_objectives()
	// OV Edit Start
	var/mob/living/carbon/human/H = owner?.current
	if(H)
		if(H.werewolf_setname && length(H.werewolf_setname) > 0)
			wolfname = H.werewolf_setname
			allow_rename = FALSE
		else
			wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
			allow_rename = TRUE
		if(H.werewolf_setdesc && H.werewolf_setdesc_cached)
			wolfdesc = H.werewolf_setdesc
			wolfdesc_cached = H.werewolf_setdesc_cached
		apply_verbs(H)
	else
		wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
		allow_rename = TRUE
	// OV Edit End
	return ..()

/datum/antagonist/werewolf/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("I am no longer a [special_role]!"))
	// OV Edit Start
	var/mob/M = owner?.current
	remove_verbs(M)
	// OV Edit End
	owner.special_role = null
	return ..()

/datum/antagonist/werewolf/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/werewolf/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/werewolf/proc/forge_werewolf_objectives()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/werewolf/escape_objective = new
		escape_objective.owner = owner
		add_objective(escape_objective)
		return

/datum/antagonist/werewolf/greet()
	to_chat(owner.current, span_userdanger("I feel Dendor's madness welling within me. What was its cause... A bite? A curse? Perhaps a blessing? Regardless, the Moonlight calls to me like a siren's song. It promises to help me sate this excruciating Hunger...")) // Caustic Edit: Rewrote text to be a bit more ambiguous
	var/picked_sound = pick(dendor_cries)
	owner.current.playsound_local(get_turf(owner.current), picked_sound, 100)
	return ..()

/datum/antagonist/werewolf/lesser/greet()
	// DO NOT call parent. 
	// lesser verevolfs should always be created by alpha bites, which have their own way of informing the user
	// they are a werewolf. despite this, i still want to provide a new audio cue in the form of [THE CRY].
	// remove it if it's obstructive. thx.
	var/picked_sound = pick(dendor_cries)
	owner.current.playsound_local(get_turf(owner.current), picked_sound, 100)

/mob/living/carbon/human/proc/can_werewolf()
	if(!mind)
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	//No cross species pollination!!!
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/werewolf_check(werewolf_type = /datum/antagonist/werewolf/lesser)
	if(!mind)
		return
	var/already_wolfy = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(already_wolfy)
		return already_wolfy
	if(!can_werewolf())
		return
	return mind.add_antag_datum(werewolf_type)

/mob/living/carbon/human/proc/werewolf_infect_attempt()
	var/datum/antagonist/werewolf/wolfy = werewolf_check()
	if(!wolfy)
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return
	to_chat(src, span_danger("I feel horrible... REALLY horrible..."))
	mob_timers["puke"] = world.time
	vomit(1, blood = TRUE, stun = FALSE)
	return wolfy

/mob/living/carbon/human/proc/werewolf_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/werewolf_skin
	slot_flags = null
	name = "verewolf's skin"
	desc = "an impenetrable hide of dendor's fury"
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_WWOLF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 550
	item_flags = DROPDEL
	repair_time = 15 SECONDS
	interrupt_damount = 35

/datum/intent/simple/werewolf
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = "genslash"
	penfactor = PEN_HEAVY
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"

/datum/intent/mace/smash/werewolf
	name = "thrash"
	desc = "A powerful, smash of lycan muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	maxrange = 5
	chargetime = 1
	penfactor = PEN_HEAVY

/obj/item/rogueweapon/werewolf_claw
	name = "Verevolf Claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 900
	max_integrity = 900
	force = 25
	block_chance = 0
	wdefense = 2
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf, /datum/intent/mace/smash/werewolf)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	special = /datum/special_intent/axe_swing	//Good pairing for area denial for WW's.
	experimental_inhand = FALSE

/obj/item/rogueweapon/werewolf_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/werewolf_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/werewolf_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)
