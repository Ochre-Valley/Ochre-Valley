#define TRAIT_SOURCE_WEREWOLF "werewolf_transform"

/datum/antagonist/werewolf/on_life(mob/user)
	if(!user) return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD) return
	if(H.advsetup) return
	if(HAS_TRAIT(H, TRAIT_SILVER_BLESSED)) return

	// Caustic Edit - If we were resisting transformation, Restore strength if we're under the night sky
	if(transformed && resisting_transformation && !ignore_transformation_resist)
		if(GLOB.tod == "night")
			if(isturf(H.loc))
				var/turf/loc = H.loc
				if(loc.can_see_sky())
					remove_transform_resistance(H)
	// Caustic Edit End

	// Werewolf transforms at night AND under the sky
	if(!transformed && !transforming)
		if(GLOB.tod == "night")
			if(isturf(H.loc))
				var/turf/loc = H.loc
				if(loc.can_see_sky())
					to_chat(H, span_userdanger("The moonlight scorns me... It is too late."))
					owner.current.playsound_local(get_turf(owner.current), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
					if(H.show_redflash())
						H.flash_fullscreen("redflash3")
					transforming = world.time // timer

	// Begin transformation
	else if(transforming)
		if (world.time >= transforming + 35 SECONDS) // Stage 3
			H.werewolf_transform()
			transforming = FALSE
			transformed = TRUE // Mark as transformed

		else if (world.time >= transforming + 25 SECONDS) // Stage 2

			if(H.show_redflash())
				H.flash_fullscreen("redflash3")
			H.emote("agony", forced = TRUE)
			to_chat(H, span_userdanger("UNIMAGINABLE PAIN!"))
			H.Stun(30)
			H.Knockdown(30)
			H.drop_all_held_items()

		else if (world.time >= transforming + 10 SECONDS) // Stage 1
			H.emote("")
			to_chat(H, span_warning("I can feel my muscles aching, it feels HORRIBLE..."))


	// Werewolf reverts to human form during the day
	else if(transformed)
		if(GLOB.tod != "night")
			if(!untransforming)
				// Caustic Edit - Transformation resistance
				if(resisting_transformation && !ignore_transformation_resist)
					if(isturf(H.loc))
						var/turf/loc = H.loc
						if(loc.can_see_sky())
							if(H.show_redflash())
								H.flash_fullscreen("redflash3")
							to_chat(H, span_danger("Astrata has seen me! I can no longer RESIST her!"))
							untransforming = world.time // Start untransformation phase
							ignore_transformation_resist = TRUE // Too late, no going back now!
				else
					untransforming = world.time // Start untransformation phase
				// Caustic Edit End

			var/forcing_untransform = !resisting_transformation || ignore_transformation_resist // Caustic Edit: Transformation resistance check
			if (world.time >= untransforming + 30 SECONDS && forcing_untransform) // Untransform // Caustic Edit: Transformation resistance check
				H.emote("rage", forced = TRUE)
				H.werewolf_untransform()
				transformed = FALSE
				untransforming = FALSE // Reset untransforming phase

			else if (world.time >= untransforming && forcing_untransform) // Alert player // Caustic Edit: Transformation resistance check
				if(H.show_redflash())
					H.flash_fullscreen("redflash1")
				to_chat(H, span_warning("Daylight shines around me... the curse begins to fade."))
				// Caustic Edit - Transformation resistance
				if(!ignore_transformation_resist)
					to_chat(H, span_warning("<a href='?src=[REF(src)];task=apply_transform_resistance;'>(To resist changing back to continue a scene, head somewhere you cannot see the sun and click here!)</a>"))
				// Caustic Edit End


/mob/living/carbon/human/species/werewolf/death(gibbed, nocutscene = FALSE)
	werewolf_untransform(TRUE, gibbed)

/mob/living/carbon/human/proc/werewolf_transform()
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)
//	stop_cmusic()

	fully_heal(FALSE)

	var/ww_path
	if(gender == MALE)
		ww_path = /mob/living/carbon/human/species/werewolf/male
	else
		ww_path = /mob/living/carbon/human/species/werewolf/female

	var/mob/living/carbon/human/species/werewolf/W = new ww_path(loc)

	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	W.werewolf_headshot_link = src.werewolf_headshot_link // OC Added Line

	// Set the werewolf's name from the antagonist datum
	var/datum/antagonist/werewolf/Were = mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(Were)
		W.real_name = Were.wolfname
		W.name = Were.wolfname
		Were.apply_verbs(W) // OC Edit: Adds Verbs line.
	W.limb_destroyer = TRUE
	W.ambushable = FALSE
	var/list/dying_world = list('sound/music/cmode/antag/combat_dying_world.ogg' = 1,  // probably best if its not vocals all the time
							'sound/music/cmode/antag/combat_dying_world_instrumental.ogg' = 3) // 1/4 is good odds for 1/round tho
	W.cmode_music = pickweight(dying_world)
	W.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/werewolf_skin(W)
	// Equip without checking if we can equip, since it is forced.
	W.wear_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/werewolf_skin/extremities(W)
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	src.forceMove(W)

	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name
	// CC Edit Start
	// Transfer voregans and contents of them to the destination form
	W.vore_organs = vore_organs.Copy()
	W.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(W)
		B.owner = W
	vore_organs.Cut()
	// CC Edit End
	mind.transfer_to(W)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/beast)

	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	// temporal traits so our body won't snore
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_SOURCE_WEREWOLF)
	ADD_TRAIT(src, TRAIT_PACIFISM, TRAIT_SOURCE_WEREWOLF)

	to_chat(W, span_userdanger("I transform into a horrible beast!"))
	W.emote("rage")

	W.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	W.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	W.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

	W.STASTR = 20
	W.STACON = 20
	W.STAWIL = 20

	W.AddSpell(new /obj/effect/proc_holder/spell/self/howl)
	W.AddSpell(new /obj/effect/proc_holder/spell/self/claws)
	W.AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
	W.mind.AddSpell(new /datum/action/cooldown/spell/repulse/werewolf)
	invisibility = oldinv

/mob/living/carbon/human/proc/werewolf_untransform(dead,gibbed)
	if(!stored_mob)
		return
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null
	if(dead)
		W.death(gibbed)

	W.forceMove(get_turf(src))

	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_NOBREATH, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_DEATHLESS, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_NOPAIN, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_NOHUNGER, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_SOURCE_WEREWOLF)
	REMOVE_TRAIT(W, TRAIT_PACIFISM, TRAIT_SOURCE_WEREWOLF)

	mind.transfer_to(W)

	var/mob/living/carbon/human/species/werewolf/WA = src
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()
	// CC Edit Start
	// Transfer voregans and contents of them to the destination form
	W.vore_organs = vore_organs.Copy()
	W.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(W)
		B.owner = W
	vore_organs.Cut()
	// CC Edit End
	// OV Edit Start
	// var/datum/antagonist/werewolf/WW = mind?.has_antag_datum(/datum/antagonist/werewolf)
	// if(WW)
		// WW.apply_verbs(W)
	// OV Edit End
	W.RemoveSpell(new /obj/effect/proc_holder/spell/self/howl)
	W.RemoveSpell(new /obj/effect/proc_holder/spell/self/claws)
	W.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
	W.mind.RemoveSpell(new /datum/action/cooldown/spell/repulse/werewolf)
	W.regenerate_icons()

	to_chat(W, span_userdanger("I return to my facade."))
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	W.Knockdown(30)
	W.drop_all_held_items()
	W.Stun(30)

	qdel(src)

#undef TRAIT_SOURCE_WEREWOLF
