/*/datum/species/ooze //OV Edit - Commented out pending REFINEMENT
	name = "Ooze"
	id = "ooze"
	desc = "<b>Ooze</b><br>\
	Oozes are gelatinous lifeforms formed from liquid that submerged disembodied lux. \
	They contain no bones or unqiue organs, but function similarly to other creatures in that regard. \
	However, they are very vulnerable to loss of limbs, \
	though they are fortunate in that they can regenerate them through great effort.\
	THIS IS A WORK IN PROGRESS AND PLAYTEST SPECIES, EXPECT BUGS AND UNFINISHED FEATURES.\
	PLEASE REPORT ANY ISSUES YOU FIND TO THE DISCORD AND GITHUB!!!!"


	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,MUTCOLORS,INVISBLOOD)
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
	race_bonus = list(STAT_PERCEPTION = 1, STAT_INTELLIGENCE = -1)
	inherent_traits = list(
						TRAIT_NOBREATH,
						TRAIT_ZOMBIE_IMMUNE,
						//TRAIT_BLOODLOSS_IMMUNE,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						)
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
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/belly/human,
		/datum/customizer/organ/butt/human,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
		)
	body_markings = list(
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
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
//		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "Ooze Neural Core"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/heart/ooze
	name = "Ooze Fluid Pump"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "Ooze Occular Sensors"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "Ooze Taste Buds"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "Ooze Digestive Chamber"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "Ooze Detoxification Organelle"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE
*/
//SLIME FORM WOOO

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze
	name = "Blob Form"
	desc = ""
	overlay_state = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	convert_damage = FALSE
	do_gib = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering
	name = "suffering ooze"
	melee_damage_lower = 1
	melee_damage_upper = 1
	del_on_deaggro = null
	defprob = 70
	move_to_delay = 20
	STASTR = 2
	STASPD = 2

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering/revive(full_heal = FALSE, admin_revive = FALSE)
	var/obj/shapeshift_holder/ooze_death/H = locate() in src
	if(H)
		H.restore()

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze/Shapeshift(mob/living/caster)
	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	var/mob/living/shape = new shapeshift_type(caster.loc)
	if(ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		shape.color = "#[human_caster.dna.features["mcolor"]]"
	H = new(shape,src,caster,shape)
	shape.name = "[shape]"
	shape.faction = caster.faction

	clothes_req = FALSE
	human_req = FALSE

	if(do_gib)
		playsound(caster.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		caster.spawn_gibs(FALSE)

/obj/shapeshift_holder/ooze_death/Initialize(mapload,mob/living/caster)
	if(!caster)
		return ..()
	shape = loc
	if(!istype(shape))
		to_chat(caster, "Initialize failure: please report: | stored=[caster] shape=[shape]")
		CRASH("shapeshift holder created outside mob/living")
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)

	rebuild_perception(shape)
	hard_reset_spatial(shape)

	stored.forceMove(src)
	stored.notransform = TRUE
	shape.visible_message(span_warning("[stored] has lost their form, they are vulnerable and near death."),span_warningbig("You have been near killed, you can no longer maintain your form. You will need to be revived to return to your humen form."))
	playsound(shape.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	slink = soullink(/datum/soullink/shapeshift, stored , shape)
	slink.source = src

	shape.mob_belly_transfer(stored)
	VORE_PREF_TRANSFER(shape, stored)

/obj/shapeshift_holder/ooze_death/restore(death=FALSE, knockout=0)
	if(restoring || QDELETED(src))
		return

	restoring = TRUE

	if(slink)
		qdel(slink)
		slink = null

	if(!stored)
		qdel(src)
		return

	var/mob/living/temp = stored
	stored = null

	var/turf/original_turf = get_turf(src)

	if(original_turf)
		temp.forceMove(original_turf)
		hard_reset_spatial(temp)
	
	if(isbelly(shape.loc))
		var/obj/belly/B = shape.loc
		temp.forceMove(B)

	temp.notransform = FALSE

	var/datum/mind/M = temp?.mind || shape?.mind
	if(M)
		M.transfer_to(temp)

	rebuild_perception(temp)

	temp.revive(full_heal = TRUE, admin_revive = FALSE)
	to_chat(temp, span_notice("Bug notice: If you can no longer see emotes, move to a different z level and back (up/down a level). This is a known bug."))
	temp.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/ooze)
	temp.Knockdown(200)
	temp.Stun(200)
	temp.apply_status_effect(/datum/status_effect/debuff/revived)
	temp.adjust_fire_stacks(2)
	
	temp.mob_belly_transfer(shape)
	VORE_PREF_TRANSFER(temp, shape)

	qdel(shape)
	shape = null
