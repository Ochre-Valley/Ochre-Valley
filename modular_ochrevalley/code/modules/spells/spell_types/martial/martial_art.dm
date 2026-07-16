/datum/action/cooldown/spell/abstractweapon/martialart
	name = "Coderbus Stance"
	desc = "Enter coderbus stance, and get four intents:\n \
	<b>You</b>: Placeholder format!.\n \
	<b>Shouldn't</b>: Placeholder format!. \n \
	<b>See</b>: Placeholder format!.\n \
	<b>This</b>: Placeholder format!. "
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart
	button_icon = 'modular_ochrevalley/icons/mob/actions/roguespells.dmi'
	button_icon_state = "boxing"
	draw_message = "Enters coderbus stance!" 
	drop_message = "Drops their stance."
	spell_requirements = SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_HUMAN //doesn't care about antimagic cuz its not real magics!
	charge_required = TRUE
	charge_time = 1 SECONDS
	spell_tier = 0
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

/obj/item/rogueweapon/abstractweapon/martialart
	name = "Coderbus Stance"
	desc = "You shouldn't be wielding this. Tell a coder!"
	force = 15 //our basic values are roughly equal to an unarmed strike
	can_parry = FALSE
	wdefense = 0 //like the katar, all martial art intents should defer to unarmed parry
	associated_skill = /datum/skill/combat/unarmed
	gripsprite = FALSE
	icon = 'modular_ochrevalley/icons/mob/actions/roguespells.dmi'
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_NORMAL //unarmed strikes hit at WBALANCE_SWIFT, but martial arts should generally be worse in dps than those
	experimental_inhand = FALSE
	item_state = null
	lefthand_file = null
	righthand_file = null
	var/list/baseintents = list()
	var/list/basegrips = list()
	var/list/masterintents = list() //intents given if you meet Mastertier. 
	var/list/mastergrips = list() //alt grips given if you meet Mastertier.
	var/masterstring = "I am a master of this stance"//if you have special master effects, please state them here
	var/wiznerf = TRUE //if casters get a lower tier cap based on their highest spell level
	var/clernerf = TRUE //ditto for miracles
	var/tier = 0 //martial art tiers!! cap is determined by skill, tier is determined by effective unarmed. Tier 4 should be roughly equivalent to a katar in power, tier 0 equivalent to normal unarmed
	var/tiermult = 2.5 //how much the tier of the art affects the damage. multiply tier by tiermult before adding. 
	//var/demotier = 3 //the breakpoint at which this martial art can damage structures and shields. 3 is the minimum tier which requires equipment to reach
	var/mastertier = 4 //the breakpoint at which this martial art can get truly impactful abilities, if any. Tier 4 requires at least expert skill, with minimal magic
	//var/demolition = TRUE //if it can destroy structures and shields at demotier
	var/specialability = TRUE //if it can use special abilities at mastertier. can be ignored if no such abilities are coded into the intents
	var/specialtier = 0 //if this is set to a value, it's necessary for the weapon to be at that tier to use its special

/obj/item/rogueweapon/abstractweapon/martialart/updateequip()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H) && !QDELETED(src)) //you shouldn't have these! bye!
		QDEL_NULL(src)
		return
	var/maximum_tier = H.get_skill_level(associated_skill) //your maximum damage is determined by unarmed skill
	var/spelllevel = 0
	if(clernerf)
		if(H.devotion) //clerics is wizards actually
			spelllevel = H.devotion.level
	if(H.mind && wiznerf)
		var/spelltier = 0
		if(H.mind.mage_aspect_config)
			if(H.mind.mage_aspect_config["minor"] >= 1)
				spelltier = 2
			if(H.mind.mage_aspect_config["major"] >= 1)
				spelltier = 3
			if(H.mind.mage_aspect_config["mastery"] >= 1)
				spelltier = 4
		for(var/datum/action/cooldown/spell/spellcheck in H.mind.spell_list)
			var/isutility = FALSE 
			if(istype(spellcheck, /datum/action/cooldown/spell/miracle)) //should be handled under cleric aspects!
				continue
			if(istype(spellcheck, /datum/action/cooldown/spell/touch/prestidigitation))//basically a utility spell with how common it is
				continue
			if(spellcheck.primary_resource_type == SPELL_COST_DEVOTION) //this is probably also a miracle
				continue
			if(spellcheck.primary_resource_type == SPELL_COST_NONE) //this is probably not the kind of spell we care about for this
				continue
			for(var/path in GLOB.utility_spells)
				if(istype(spellcheck, path))
					isutility = TRUE
					break
			if(isutility)
				continue//for classes like spellfist, we check our entire spell list and single out the tier of the highest tier spell
			spelltier = CLAMP(spellcheck.spell_tier, spelltier, 3)
		spelllevel = max(spelllevel, spelltier)
	maximum_tier = min(maximum_tier, max(2, maximum_tier - spelllevel)) //we nerf the maximum damage tier of martial arts based on how much of a spellcaster you are
	var/ourtier = 0
	var/obj/G = H.get_item_by_slot(SLOT_GLOVES)
	if(HAS_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN)) //pugilists get boosted by two tiers
		ourtier = 2 
	var/dambonus = H.dna.species.punch_damage
	if(istype(G, /obj/item/clothing/gloves/roguetown))
		var/obj/item/clothing/gloves/roguetown/GL = G
		dambonus += GL.unarmed_bonus
		is_silver = GL.is_silver //if the gloves are silver, our attack counts as silvered. simple.
	if(dambonus)
		ourtier += max(1, round(dambonus / 2.5))
	tier = min(ourtier, maximum_tier)
	force = initial(force)
	force += tier * tiermult
	to_chat(H, span_notice("My stance is at tier <B>[tier]</B>, striking at a base force of [force]."))
	if(is_silver)
		to_chat(H, span_notice("My strikes are silvered."))
	//demolition = FALSE
	master = FALSE
	/*if(tier >= demotier)
		demolition = initial(demolition)
		if(demolition)
			to_chat(H, span_notice("I strike with sufficient strength to damage structures."))*/
	if(tier >= mastertier)
		specialability = initial(specialability)
		if(master)
			to_chat(H, span_notice("[masterstring]"))
	possible_item_intents = baseintents
	gripped_intents = baseintents
	alt_grips = basegrips
	if(master && LAZYLEN(masterintents)) //at tier 4 or above, your class is almost certainly an unarmed specialist without spells, so you can get special intents
		possible_item_intents = masterintents
		gripped_intents = masterintents
	if(master && LAZYLEN(mastergrips))
		alt_grips = mastergrips
	/*for(var/datum/intent/I in possible_item_intents)
		to_chat(H, span_userdanger("[I]"))
		if(demolition) 
			to_chat(H, span_userdanger("demolition"))
			I.demolition_mod = initial(I.demolition_mod)
		else
			to_chat(H, span_userdanger("[I] demomod is [I.demolition_mod]"))
			I.demolition_mod = 0 //at and below tier 2 (by default), you're not getting object damage
			to_chat(H, span_userdanger("set [I] demomod to 0"))*/


/datum/intent/martial
	name = "unarmed strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("punches", "hits", "clocks")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	unarmed = FALSE //I am defining this here, same as the base type, to remind you to keep this FALSE if you edit it. 
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"
	clickcd = CLICK_CD_FAST //speed of unarmed
	intent_intdamage_factor = PUNCH_INT_DAMAGEFACTOR // set to BLUNT_DEFAULT_INT_DAMAGEFACTOR on slower attacks
	
