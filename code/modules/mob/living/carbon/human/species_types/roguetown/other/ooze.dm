/datum/species/ooze
	name = "Ooze" //OV Edit - Name and DESC changed
	id = "ooze"
	desc = "<b>Ooze</b><br>\
	Ever since Zizo's ascension, the imbalance of the world has affected Psydonia, but one of its most curious symptoms is the leyline's own process of \
	trying to right the wrong that happened to its system - the Ooze. At least they are connected in some shape or form, since only since the Ascendance have they been reported in history. \
	Ultimately, they are a fluke. A by-product of errant Lux finding itself in a liquid strong enough to hold its form, before something pulses the dormant power \
	within Psydon's Gift awake, lashing its tendrils into matter and forming the core of a being, bubbling and festering into a shape it is vaguely familiar with. \
	What finally emerges is the Ooze, with some big-headed scholars trying to give them a more 'proper celestial name', although nobody can quite agree on \
	it. Luxophont, Luxem, Homunculus… Whatever their philological circles babble about, the common man calls them Ooze, for their opaque and liquid-y appearance. \
	Though hardened by the violent depths, they remain volatile and naive, struggling to understand a surface world that often sees them as monsters.<br> \
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 CON | +1 INT<br> \
	Easy Dismember | Limb Regrowth | Inhumen Digestion</span><br><br>"
	blood_color = "#00FFFF" //Defaults to blue, but we recolor this later to match the slime person's body color.
	origin_default = /datum/virtue/origin/racial/underdark
	base_name = "Ooze"
	origin = "Underdark"
	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS)
	restricted_virtues = list(/datum/virtue/utility/feral_appetite) //OV EDIT - Allow them to be nobles
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = FALSE
	possible_ages = ALL_AGES_LIST
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_TAUR = list(-16,0), OFFSET_TAUR_F = list(-16,0), \
		)
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_INTELLIGENCE = 1)
	inherent_traits = list(
						TRAIT_NASTY_EATER,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_ZOMBIE_IMMUNE,
						)
	//OV Add Start
	allowed_taur_types = list(
		/obj/item/bodypart/taur/lamia,
		/obj/item/bodypart/taur/spider,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/cow,
		/obj/item/bodypart/taur/lizard,
		/obj/item/bodypart/taur/tent,
		/obj/item/bodypart/taur/tentacle,
		/obj/item/bodypart/taur/feline,
		/obj/item/bodypart/taur/slug,
		/obj/item/bodypart/taur/tempest,
		/obj/item/bodypart/taur/drake,
		/obj/item/bodypart/taur/otie,
		/obj/item/bodypart/taur/wolf,
		/obj/item/bodypart/taur/alraune,
		/obj/item/bodypart/taur/frog,
		/obj/item/bodypart/taur/deer,
		/obj/item/bodypart/taur/wasp,
		/obj/item/bodypart/taur/fatwolf,
		/obj/item/bodypart/taur/fatfeline,
		/obj/item/bodypart/taur/mermaid,
		/obj/item/bodypart/taur/altnaga,
		/obj/item/bodypart/taur/altnagatailmaw,
		/obj/item/bodypart/taur/fatnaga,
		/obj/item/bodypart/taur/bunny,
		/obj/item/bodypart/taur/mammoth,
		/obj/item/bodypart/taur/biglegs,
		/obj/item/bodypart/taur/biglegsstanced,
	)
	//OV Add End
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid, //OV EDIT - Don't restrict slime customisability
		/datum/customizer/bodypart_feature/hair/facial/humanoid, //OV EDIT - Don't restrict slime customisability
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing, //OV Add
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/belly/human, //OV Add
		/datum/customizer/organ/butt/human, //OV Add
		/datum/customizer/organ/testicles/anthro,
		//OV Edit Start
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		//OV Edit End
		)
	body_marking_sets = list(
	//OV Edit Start
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	//OV Edit End
	)
	body_markings = list(
	//OV Edit Start
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/bellyscaleslimsmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/drake_eyes,
		/datum/body_marking/spotted,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
	//OV Edit End
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "Ooze Neural Core"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/lungs/ooze
	name = "Ooze Breathing Sac"
	icon = 'icons/obj/velslime.dmi'
	icon_state = "liver" //No lungs sprite, re-using the liver sprite instead.
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/heart/ooze
	name = "Ooze Fluid Pump"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "Ooze Ocular Sensors"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "Ooze Taste Buds"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "Ooze Digestive Chamber"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "Ooze Detoxification Organelle"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE

//Set slime blood color to match body color.
/datum/species/ooze/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	blood_color = C.dna.features["mcolor"]
	blood_color = "#[blood_color]"

/datum/species/ooze/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
	return randname

/datum/species/ooze/random_surname()
	return
