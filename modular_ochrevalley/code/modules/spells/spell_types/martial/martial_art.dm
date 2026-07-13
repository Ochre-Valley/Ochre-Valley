/datum/action/cooldown/spell/abstractweapon/martialart
	name = "Coderbus Stance"
	desc = "Enter coderbus stance, and get four intents:\n \
	<b>You</b>: Placeholder format!.\n \
	<b>Shouldn't</b>: Placeholder format!. \n \
	<b>See</b>: Placeholder format!.\n \
	<b>This</b>: Placeholder format!. "
	hand_path = /obj/item/rogueweapon/abstractweapon/martialart
	draw_message = "Enters coderbus stance!" 
	drop_message = "Drops their stance."
	spell_requirements = SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_HUMAN //doesn't care about antimagic cuz its not real magics!
	charge_required = TRUE
	charge_time = 2 SECONDS
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
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_NORMAL //unarmed strikes hit at WBALANCE_SWIFT, but martial arts should generally be worse in dps than those
	var/list/masterintents = list() //intents given if you meet Mastertier. 
	var/list/mastergrips = list() //alt grips given if you meet Mastertier.
	var/masterstring = "I am a master of this stance"//if you have special master effects, please state them here
	var/wiznerf = TRUE //if casters get a lower tier cap based on their highest spell level
	var/clernerf = TRUE //ditto for miracles
	var/tier = 0 //martial art tiers!! cap is determined by skill, tier is determined by effective unarmed. Tier 4 should be roughly equivalent to a katar in power, tier 0 equivalent to normal unarmed
	var/tiermult = 2.5 //how much the tier of the art affects the damage. multiply tier by tiermult before adding. 
	var/demotier = 3 //the breakpoint at which this martial art can damage structures and shields. 3 is the minimum tier which requires equipment to reach
	var/mastertier = 4 //the breakpoint at which this martial art can get truly impactful abilities, if any. Tier 4 requires at least expert skill, with minimal magic
	var/demolition = TRUE //if it can destroy structures and shields at demotier
	var/specialability = TRUE //if it can use special abilities at mastertier. can be ignored if no such abilities are coded into the intents
	var/specialtier = 0 //if this is set to a value, it's necessary for the weapon to be at that tier to use its special

/obj/item/rogueweapon/abstractweapon/martialart/updateequip()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H)) //you shouldn't have these! bye!
		qdel(src)
		return
	var/maximum_tier = H.get_skill_level(associated_skill) //your maximum damage is determined by unarmed skill
	var/spelllevel = 0
	if(clernerf)
		if(H.devotion) //clerics is wizards actually
			spelllevel = H.devotion.level
	if(H.mind && wiznerf)
		var/spelltier = 0
		//shameless copy paste
		var/major = LAZYLEN(H.mind.mage_aspect_config) ? H.mind.mage_aspect_config["major"] : MAX_MAJOR_ASPECTS
		var/minor = LAZYLEN(H.mind.mage_aspect_config) ? H.mind.mage_aspect_config["minor"] : MAX_MINOR_ASPECTS
		var/mastery = LAZYLEN(H.mind.mage_aspect_config) ? H.mind.mage_aspect_config["mastery"] : FALSE
		if(mastery) //as wizardy as it gets. skip the pricier check
			spelltier = 4
		else if(major) //we're not going to take values bigger than 3 from the whole-ass spell list check
			spelltier = 3
		else //only do this if we don't have a balue of 3 yet
			for(var/datum/action/cooldown/spell/spellcheck in H.mind.spell_list)
				var/isutility = FALSE 
				if(istype(spellcheck, /datum/action/cooldown/spell/miracle)) //should be handled under cleric aspects!
					continue
				for(var/path in GLOB.utility_spells)
					if(istype(spellcheck, path))
						isutility = TRUE
						break
				if(isutility)
					continue//for classes like spellfist, we check our entire spell list and single out the tier of the highest tier spell
				spelltier = CLAMP(spellcheck.spell_tier, spelltier, 3)
			if(minor)
				spelltier = max(spelltier, 2) //if no spell was above tier 1, finally, we end up here
		if(spelllevel)//if you have both miracles and spells of notable level, we tax you by one more
			spelllevel = max(spelltier, spelllevel) + 1
		else
			spelllevel = spelltier
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
	ourtier += round(dambonus / 2.5) 
	tier = min(ourtier, maximum_tier)
	force = initial(force)
	force += tier * tiermult
	to_chat(H, span_notice("My stance is at tier <B>[tier]</B>, striking at a base force of [force]."))
	if(is_silver)
		to_chat(H, span_notice("My strikes are silvered."))
	demolition = FALSE
	master = FALSE
	if(tier >= demotier)
		demolition = initial(demolition)
		if(demolition)
			to_chat(H, span_notice("I strike with sufficient strength to damage structures."))
	if(tier >= mastertier)
		specialability = initial(specialability)
		if(master)
			to_chat(H, span_notice("[masterstring]"))
	possible_item_intents = initial(possible_item_intents)
	alt_grips = initial(alt_grips)
	if(master && LAZYLEN(masterintents)) //at tier 4 or above, your class is almost certainly an unarmed specialist without spells, so you can get special intents
		possible_item_intents = masterintents
	if(master && LAZYLEN(mastergrips))
		alt_grips = mastergrips
	for(var/datum/intent/I in possible_item_intents)
		if(demolition) 
			I.demolition_mod = initial(I.demolition_mod)
		else
			I.demolition_mod = 0 //at and below tier 2 (by default), you're not getting object damage


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
