//OV FILE

/client/proc/player_effects(var/mob/target in GLOB.mob_list)
	set name = "Player Effects"
	set desc = "Modify a player character with various 'special treatments' from a list."
	set category = "-Admin-"
	if(!holder)
		return

	var/datum/eventkit/player_effects/spawner = new()
	spawner.target = target
	spawner.user = src.mob
	spawner.ui_interact(src.mob)

/datum/eventkit/player_effects
	var/mob/target //The target of the effects
	var/mob/user

/datum/eventkit/player_effects/New()
	. = ..()

/datum/eventkit/player_effects/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerEffects", "Player Effects")
		ui.open()

/datum/eventkit/player_effects/Destroy()
	target = null
	. = ..()

/datum/eventkit/player_effects/ui_static_data(mob/user)
	var/list/data = list()

	data["real_name"] = target.name;
	data["player_ckey"] = target.ckey;
	data["target_mob"] = target;


	return data

/datum/eventkit/player_effects/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/eventkit/player_effects/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!ui.user.client.holder)
		return

	log_and_message_admins("used player effect: [action] on [target.ckey] playing [target.name]", ui.user)

	switch(action)

		////////////SMITES/////////////
		if("lightning_strike")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(Tar, icon_state="lightning[rand(1,12)]", time = 5)
			Tar.adjustFireLoss(75)
			if(ishuman(target))
				var/mob/living/carbon/human/H = Tar
				H.electrocution_animation(40)
			record_round_statistic(STATS_PEOPLE_SMITTEN)
			to_chat(Tar, span_danger("The gods have punished you for your sins!"))
		if("brain_damage")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.adjustOrganLoss(ORGAN_SLOT_BRAIN, 199, 199)
		if("Zesus_Psyst")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			sleep(60)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(20)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(15)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(10)
			target.gib(FALSE)
		if("bluespace_artillery")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			ui.user.client.bluespace_artillery(Tar)
		if("CBT")
			if(!ishuman(target))
				to_chat(usr,span_warning("Target must be human!"))
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_CHEST)
			if(!affecting)
				to_chat(usr,span_warning("Target must have a chest!"))
				return
			affecting.add_wound(/datum/wound/cbt/permanent)
		if("snap_neck")
			if(!ishuman(target))
				to_chat(usr,span_warning("Target must be human!"))
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_HEAD)
			if(!affecting)
				to_chat(usr,span_warning("Target must have a head!"))
				return
			affecting.add_wound(/datum/wound/fracture/neck)
		if("fracture_arms_and_legs")
			if(!ishuman(target))
				to_chat(usr,span_warning("Target must be human!"))
				return
			var/limbs_to_cripple = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			var/mob/living/carbon/human/humie = target

			for(var/limb in limbs_to_cripple)
				var/obj/item/bodypart/limb_to_cripple = humie.get_bodypart(limb)
				limb_to_cripple.add_wound(/datum/wound/fracture)
		if("throw_mob")
			if(!ismob(target))
				to_chat(usr,span_warning("Target must be a mob!"))
				return
			var/list/directions = list("North" = NORTH, "South" = SOUTH, "East" = EAST, "West" = WEST, "Northeast" = NORTHEAST, "Northwest" = NORTHWEST, "Southeast" = SOUTHEAST, "Southwest" = SOUTHWEST)
			var/direction = input("Which direction?") in directions
			direction = directions[direction]
			var/target_tile = target.loc
			for (var/i = 0; i < 10; i++)
				var/turf/next_tile = get_step(target_tile, direction) 
				if (!next_tile)
					break
				target_tile = next_tile
			to_chat(target,span_warning("You are flung by a mysterious force..."))
			target.throw_at(target = target_tile, range = 10, speed = 3, thrower = target, spin = 9, diagonals_first = FALSE, callback = null, force = 20)
		if("liam")
			if(!ishuman(target))
				to_chat(usr,span_warning("NO...IT COULDN'T BE... (Needs to be a carbon!)"))
				return
			var/mob/living/carbon/human/humie = target
			playsound(humie, 'sound/villain/dreamer_win.ogg', 100, FALSE, -1)
			humie.gender = MALE
			humie.skin_tone = "ffe0d1"
			humie.hair_color = "999999"
			humie.hairstyle = "Plain Long"
			humie.facial_hair_color = "999999"
			humie.facial_hairstyle = "Knowledge"
			humie.age = AGE_OLD
			humie.equipOutfit(/datum/outfit/treyliam)
			humie.regenerate_icons()
			humie.SetSleeping(25 SECONDS)
			humie.add_stress(/datum/stressevent/maniac_woke_up)
			to_chat(humie, span_deadsay("<span class='reallybig'>... WHERE AM I? ...</span>"))
			var/static/list/slop_lore = list(
				span_deadsay("... Azure Peak? No ... It doesn't exist ..."),
				span_deadsay("... My name is Trey. Trey Liam, Liamtific Troverseer ..."),
				span_deadsay("... I'm on NT Liam, a self Treystaining ship, used to Treyserve what Liamains of roguemanity ..."),
				span_deadsay("... Launched into the Grim Darkness, War and Grim Darkness preserves their grimness ... Their edge ..."),
				span_deadsay("... Keeps them alive in the grimdark future, where there is only war  ..."),
				span_deadsay("... There is no hope left. Only the Space Station 13 (TRADEMARK TITLE DROP) lets me live in the Trey Liam ..."),
				span_deadsay("... What have I done!? ..."),
				span_reallybig("... OH SHIT WHY IS THERE A TALKING DOG?! ..."),
		)
			for(var/slop in slop_lore)
				to_chat(humie, slop)
				sleep(3 SECONDS)
		if("divine_wrath")
			if(!ishuman(target))
				to_chat(usr,span_warning("Target must be human!"))
				return
			ui.user.client.divine_wrath(target)
		if("spin")
			var/speed = tgui_input_number(ui.user, "Spin speed (minimum 0.1):", "Speed")
			if(speed < 0.1)
				return
			var/loops = tgui_input_number(ui.user, "Number of loops (-1 for infinite):", "Loops")
			var/direction_ask = tgui_alert(ui.user, "Clockwise or Anti-Clockwise", "Direction", list("Clockwise", "Anti-Clockwise", "Cancel"))
			var/direction
			if(direction_ask == "Clockwise")
				direction = 1
			if(direction_ask == "Anti-Clockwise")
				direction = 0
			if(direction_ask == "Cancel")
				return
			target.SpinAnimation(speed, loops, direction)
		if("wet_floors")
			if(!target)
				return //Check target still exists after choices were made
			var/turf/target_turf = get_turf(target)
			for(var/turf/open/surroundings in orange(1,target))
				if(target_turf == surroundings) //Don't put it directly on our turf, just neighbouring ones
					continue
				surroundings.MakeSlippery(TURF_WET_LUBE, 20)
		if("elder_smite")
			if(!target.ckey)
				return
			target.overlay_fullscreen("scrolls", /atom/movable/screen/fullscreen/scrolls, 1)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, clear_fullscreen), "scrolls"), 20 SECONDS)
		
		if("item_tf")
			var/mob/living/M = target

			if(!istype(M))
				return

			if(!M.ckey)
				return
			
			var/target_path = input(ui.user, "Enter typepath:", "Typepath", "/obj/structure/closet")
			var/objholder = text2path(target_path)
			if(!ispath(objholder))
				objholder = pick_closest_path(target_path)
				if(!objholder)
					alert("No path was selected")
					return
				else if(!ispath(objholder, /obj/item))
					objholder = null
					alert("That path is not allowed.")
					return

			var/obj/item/spawning = objholder

			to_chat(ui.user,span_warning("spawning is: [spawning]"))

			if(!ispath(spawning, /obj/item/))
				to_chat(ui.user,span_warning("Can only spawn items."))
				return

			var/obj/item/spawned_obj = new spawning(M.loc)

			spawned_obj.mob_possession = M
			M.forceMove(spawned_obj)


		/*
		if("break_legs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/broken_legs = 0
			var/obj/item/organ/external/left_leg = Tar.get_organ(BP_L_LEG)
			if(left_leg && left_leg.fracture())
				broken_legs++
			var/obj/item/organ/external/right_leg = Tar.get_organ(BP_R_LEG)
			if(right_leg && right_leg.fracture())
				broken_legs++
			if(!broken_legs)
				to_chat(ui.user,"[target] didn't have any breakable legs, sorry.")

		if("bluespace_artillery")
			bluespace_artillery(target, ui.user)

		if("spont_combustion")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.adjust_fire_stacks(10)
			Tar.ignite_mob()
			Tar.visible_message(span_danger("[target] bursts into flames!"))

		if("lightning_strike")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			Tar.electrocute_act(75,def_zone = BP_HEAD)
			target.visible_message(span_danger("[target] is struck by lightning!"))

		if("shadekin_attack")
			var/turf/Tt = get_turf(target) //Turf for target

			if(target.loc != Tt)
				return //Too hard to attack someone in something

			var/turf/Ts //Turf for shadekin

			//Try to find nondense turf
			for(var/direction in GLOB.cardinal)
				var/turf/T = get_step(target,direction)
				if(T && !T.density)
					Ts = T //Found shadekin spawn turf
			if(!Ts)
				return //Didn't find shadekin spawn turf

			var/mob/living/simple_mob/shadekin/red/shadekin = new(Ts)
			//Abuse of shadekin
			shadekin.real_name = shadekin.name
			shadekin.init_vore(TRUE)
			shadekin.ability_flags |= 0x1
			shadekin.phase_shift()
			shadekin.ai_holder.give_target(target)
			shadekin.ai_holder.hostile = FALSE
			shadekin.ai_holder.mauling = TRUE
			shadekin.Life()
			//Remove when done
			spawn(10 SECONDS)
				if(shadekin)
					shadekin.death()

		if("shadekin_vore")
			var/static/list/kin_types = list(
				"Red Eyes (Dark)" =	/mob/living/simple_mob/shadekin/red/dark,
				"Red Eyes (Light)" = /mob/living/simple_mob/shadekin/red/white,
				"Red Eyes (Brown)" = /mob/living/simple_mob/shadekin/red/brown,
				"Blue Eyes (Dark)" = /mob/living/simple_mob/shadekin/blue/dark,
				"Blue Eyes (Light)" = /mob/living/simple_mob/shadekin/blue/white,
				"Blue Eyes (Brown)" = /mob/living/simple_mob/shadekin/blue/brown,
				"Purple Eyes (Dark)" = /mob/living/simple_mob/shadekin/purple/dark,
				"Purple Eyes (Light)" = /mob/living/simple_mob/shadekin/purple/white,
				"Purple Eyes (Brown)" = /mob/living/simple_mob/shadekin/purple/brown,
				"Yellow Eyes (Dark)" = /mob/living/simple_mob/shadekin/yellow/dark,
				"Yellow Eyes (Light)" = /mob/living/simple_mob/shadekin/yellow/white,
				"Yellow Eyes (Brown)" = /mob/living/simple_mob/shadekin/yellow/brown,
				"Green Eyes (Dark)" = /mob/living/simple_mob/shadekin/green/dark,
				"Green Eyes (Light)" = /mob/living/simple_mob/shadekin/green/white,
				"Green Eyes (Brown)" = /mob/living/simple_mob/shadekin/green/brown,
				"Orange Eyes (Dark)" = /mob/living/simple_mob/shadekin/orange/dark,
				"Orange Eyes (Light)" = /mob/living/simple_mob/shadekin/orange/white,
				"Orange Eyes (Brown)" = /mob/living/simple_mob/shadekin/orange/brown,
				"Rivyr (Unique)" = /mob/living/simple_mob/shadekin/blue/rivyr)
			var/kin_type = tgui_input_list(ui.user, "Select the type of shadekin for [target] nomf","Shadekin Type Choice", kin_types)
			if(!kin_type || !target)
				return


			kin_type = kin_types[kin_type]

			var/myself = tgui_alert(ui.user, "Control the shadekin yourself or delete pred and prey after?","Control Shadekin?",list("Control","Cancel","Delete"))
			if(!myself || myself == "Cancel" || !target)
				return

			var/turf/Tt = get_turf(target)

			if(target.loc != Tt)
				return //Can't nom when not exposed

			//Begin abuse
			target.transforming = TRUE //Cheap hack to stop them from moving
			var/mob/living/simple_mob/shadekin/shadekin = new kin_type(Tt)
			shadekin.real_name = shadekin.name
			shadekin.init_vore(TRUE)
			shadekin.can_be_drop_pred = TRUE
			shadekin.dir = SOUTH
			shadekin.ability_flags |= 0x1
			shadekin.phase_shift() //Homf
			shadekin.comp.dark_energy = initial(shadekin.comp.dark_energy)
			//For fun
			sleep(1 SECOND)
			shadekin.dir = WEST
			sleep(1 SECOND)
			shadekin.dir = EAST
			sleep(1 SECOND)
			shadekin.dir = SOUTH
			sleep(1 SECOND)
			shadekin.audible_message(span_vwarning(span_bold("[shadekin]") + " belches loudly!"), runemessage = "URRRRRP")
			sleep(2 SECONDS)
			shadekin.phase_shift()
			target.transforming = FALSE //Undo cheap hack

			if(myself == "Control") //Put admin in mob
				shadekin.ckey = target.ckey

			else //Permakin'd
				to_chat(target,span_danger("You're carried off into The Dark by the [shadekin]. Who knows if you'll find your way back?"))
				target.ghostize()
				qdel(target)
				qdel(shadekin)


		if("redspace_abduct")
			redspace_abduction(target, ui.user)

		if("autosave")
			fake_autosave(target, ui.user)

		if("autosave2")
			fake_autosave(target, ui.user, TRUE)

		if("adspam")
			if(target.client)
				target.client.create_fake_ad_popup_multiple(/atom/movable/screen/popup/default, 15)

		if("peppernade")
			var/obj/item/grenade/chem_grenade/teargas/grenade = new /obj/item/grenade/chem_grenade/teargas
			grenade.loc = target.loc
			to_chat(target,span_warning("GRENADE?!"))
			grenade.detonate()

		if("spicerequest")
			var/obj/item/reagent_containers/food/condiment/spacespice/spice = new /obj/item/reagent_containers/food/condiment/spacespice
			spice.loc = target.loc
			to_chat(target,"A bottle of spices appears at your feet... be careful what you wish for!")

		if("terror")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.fear = 200

		if("terror_aoe")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			for(var/mob/living/carbon/human/L in orange(Tar.client.view, Tar))
				L.fear = 200
			Tar.fear = 200

		if("spin")
			var/speed = tgui_input_number(ui.user, "Spin speed (minimum 0.1):", "Speed")
			if(speed < 0.1)
				return
			var/loops = tgui_input_number(ui.user, "Number of loops (-1 for infinite):", "Loops")
			var/direction_ask = tgui_alert(ui.user, "Clockwise or Anti-Clockwise", "Direction", list("Clockwise", "Anti-Clockwise", "Cancel"))
			var/direction
			if(direction_ask == "Clockwise")
				direction = 1
			if(direction_ask == "Anti-Clockwise")
				direction = 0
			if(direction_ask == "Cancel")
				return
			target.SpinAnimation(speed, loops, direction)

		if("squish")
			var/is_squished = target.tf_scale_x || target.tf_scale_y
			playsound(target, 'sound/items/hooh.ogg', 50, 1)
			if(!is_squished)
				target.SetTransform(null, (target.size_multiplier * 1.2), (target.size_multiplier * 0.5))
			else
				target.ClearTransform()
				target.update_transform()

		if("pie_splat")
			new/obj/effect/decal/cleanable/pie_smudge(get_turf(target))
			playsound(target, 'sound/effects/slime_squish.ogg', 100, 1, get_rand_frequency(), falloff = 5)
			target.Weaken(1)
			target.visible_message(span_danger("[target] is struck by pie!"))

		if("spicy_air")
			to_chat(target, span_warning("Spice spice baby!"))
			target.eye_blurry = max(target.eye_blurry, 25)
			target.Blind(10)
			target.Stun(5)
			target.Weaken(5)
			playsound(target, 'sound/effects/spray2.ogg', 100, 1, get_rand_frequency(), falloff = 5)

		if("hot_dog")
			playsound(target, 'sound/effects/whistle.ogg', 50, 1, get_rand_frequency(), falloff = 5)
			sleep(2 SECONDS)
			target.Stun(10)
			if(!ishuman(target))
				return
			var/mob/living/carbon/human/H = target
			if(H.head)
				H.unEquip(H.head)
			if(H.wear_suit)
				H.unEquip(H.wear_suit)
			var/obj/item/clothing/suit = new /obj/item/clothing/suit/storage/hooded/foodcostume/hotdog
			var/obj/item/clothing/hood = new /obj/item/clothing/head/hood_vr/hotdog_hood
			H.equip_to_slot_if_possible(suit, slot_wear_suit, 0, 0, 1)
			H.equip_to_slot_if_possible(hood, slot_head, 0, 0, 1)
			sleep(5 SECONDS)
			qdel(suit)
			qdel(hood)

		if("mob_tf")
			var/mob/living/M = target

			if(!istype(M))
				return

			var/list/types = typesof(/mob/living)
			var/chosen_beast = tgui_input_list(ui.user, "Which form would you like to take?", "Choose Beast Form", types)

			if(!chosen_beast)
				return

			var/mob/living/new_mob = new chosen_beast(get_turf(M))

			M.tf_into(new_mob)

		

		if("elder_smite")
			if(!target.ckey)
				return
			target.overlay_fullscreen("scrolls", /atom/movable/screen/fullscreen/scrolls, 1)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, clear_fullscreen), "scrolls"), 20 SECONDS)

		
		*/


		////////MEDICAL//////////////

		if("health_scan")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			to_chat(user, "[Tar]'s health: [Tar.health]/[Tar.maxHealth]")
			ui.user.client.show_heal_panel(Tar)

		if("purge")
			var/mob/living/carbon/Tar = target
			if(!istype(Tar))
				return
			Tar.reagents.clear_reagents()
		
		if("give_chem")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/chem_list = typesof(/datum/reagent)
			var/datum/reagent/chemical = tgui_input_list(ui.user, "Which chemical would you like to add?", "Chemicals", chem_list)

			if(!chemical)
				return

			var/amount = tgui_input_number(ui.user, "How much of the chemical would you like to add?", "Amount", 5)
			if(!amount)
				return
			
			Tar.reagents.add_reagent(chemical, amount)

		if("full_heal")
			var/mob/living/carbon/Tar = target
			if(!istype(Tar))
				return
			Tar.fully_heal(admin_revive = TRUE)

		if("revive")
			var/mob/living/carbon/Tar = target
			if(!istype(Tar))
				return
			Tar.revive(full_heal = FALSE, admin_revive = TRUE)

		/*if("appendicitis")
			var/mob/living/carbon/human/Tar = target
			if(istype(Tar))
				Tar.appendicitis()

		if("damage_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(ui.user, "Choose an organ to damage:", "Organs", organs)
			if(!our_organ)
				return
			var/effect = tgui_alert(ui.user, "What do you want to do to the Organ", "Effect", list("Damage", "Kill", "Bruise", "Cancel"))
			if(effect == "Cancel")
				return
			if(effect == "Damage")
				var/organ_damage = tgui_input_number(ui.user, "Add how much damage? It is currently at [our_organ.damage].", "Damage")
				our_organ.damage = max((our_organ.damage - organ_damage), 0)
			if(effect == "Kill")
				our_organ.die()
			if(effect == "Bruise")
				our_organ.bruise()

		if("assist_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(ui.user, "Choose an organ to become assisted:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.mechassist()

		if("robot_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(ui.user, "Choose an organ to become robotic:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.robotize()

		if("repair_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(ui.user, "Choose an organ to heal:", "Organs", organs)
			if(!our_organ)
				return
			var/effect = tgui_alert(ui.user, "What do you want to do to the Organ", "Effect", list("Heal", "Rejuvenate", "Cancel"))
			if(effect == "Cancel")
				return
			if(effect == "Heal")
				var/organ_damage = tgui_input_number(ui.user, "Add how much damage? It is currently at [our_organ.damage].", "Damage")
				our_organ.damage = max((our_organ.damage - organ_damage), 0)
			if(effect == "Rejuvenate")
				our_organ.rejuvenate()

		if("drop_organ")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/I in Tar.organs)
				organs |= I
			for(var/obj/item/organ/I in Tar.internal_organs)
				organs |= I
			var/obj/item/organ/our_organ = tgui_input_list(ui.user, "Choose an organ to damage:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.removed()

		if("break_bone")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/organs = list()
			for(var/obj/item/organ/external/E in Tar.organs)
				organs |= E
			var/obj/item/organ/external/our_organ = tgui_input_list(ui.user, "Choose an bone to break:", "Organs", organs)
			if(!our_organ)
				return
			our_organ.fracture()

		if("stasis")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			if(Tar.in_stasis)
				Tar.Stasis(0)
			else
				Tar.Stasis(100000)

		if("give_chem")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/list/chem_list = typesof(/datum/reagent)
			var/datum/reagent/chemical = tgui_input_list(ui.user, "Which chemical would you like to add?", "Chemicals", chem_list)

			if(!chemical)
				return

			var/chem = chemical.id

			var/amount = tgui_input_number(ui.user, "How much of the chemical would you like to add?", "Amount", 5)
			if(!amount)
				return

			var/location = tgui_alert(ui.user, "Where do you want to add the chemical?", "Location", list("Blood", "Stomach", "Skin", "Cancel"))

			if(!location || location == "Cancel")
				return
			if(location == "Blood")
				Tar.bloodstr.add_reagent(chem, amount)
			if(location == "Stomach")
				Tar.ingested.add_reagent(chem, amount)
			if(location == "Skin")
				Tar.touching.add_reagent(chem, amount)

		

		if("medical_issue")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.custom_medical_issue(ui.user)

		if("clear_issue")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.clear_medical_issue(ui.user)
		*/

		////////ABILITIES//////////////

		if("spell_buffs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.admin_buff(user, "spell")
			
		if("order_buffs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.admin_buff(user, "order")
		
		if("divine_buffs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.admin_buff(user, "divine")
		
		if("song_buffs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.admin_buff(user, "song")
		
		if("general_buffs")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.admin_buff(user, "general")
		
		/* if("give_spell")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/obj/effect/proc_holder/spell/new_spell = tgui_input_list(user, "Which spell do you want to give?", "Spells", GLOB.learnable_spells)
			if(!new_spell)
				return
			Tar.AddSpell(new_spell) */
		
		if("remove_spell")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/obj/effect/proc_holder/spell/old_spell = tgui_input_list(user, "Which spell do you want to give?", "Spells", Tar.mind.spell_list)
			if(!old_spell)
				return
			Tar.mind.RemoveSpell(old_spell)

		/*
		if("vent_crawl")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/proc/ventcrawl)

		if("darksight")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/current_darksight = Tar.species.darksight
			var/change_sight = tgui_input_number(ui.user, "What level do you wish to set their darksight to? It is currently [current_darksight].", "Darksight")
			if(change_sight)
				Tar.species.darksight = change_sight

		if("cocoon")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/enter_cocoon)

		if("transformation")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_hair)
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_hair_colors)
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_gender)
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_wings)
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_tail)
			add_verb(Tar, /mob/living/carbon/human/proc/shapeshifter_select_ears)
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_select_shape) //designed for non-shapeshifter mobs
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_select_colour)

		if("set_size")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/proc/set_size)

		if("lleill_energy")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/energy_max = tgui_input_number(ui.user, "What should their max lleill energy be set to? It is currently [Tar.species.lleill_energy_max].", "Max energy")
			Tar.species.lleill_energy_max = energy_max
			var/energy_new = tgui_input_number(ui.user, "What should their current lleill energy be set to? It is currently [Tar.species.lleill_energy].", "Max energy")
			Tar.species.lleill_energy = energy_new

		if("lleill_invisibility")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_invisibility)

		if("beast_form")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_beast_form)

		if("lleill_transmute")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_transmute)

		if("lleill_alchemy")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_alchemy)

		if("lleill_drain")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/carbon/human/proc/lleill_contact)

		if("brutal_pred")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/proc/shred_limb)

		if("trash_eater")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/proc/eat_trash)
			add_verb(Tar, /mob/living/proc/toggle_trash_catching)

		if("active_cloaking")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			add_verb(Tar, /mob/living/proc/toggle_active_cloaking)

		if("colormate")
			if(istype(target,/mob/living/simple_mob))
				var/mob/living/simple_mob/Tar = target
				add_verb(Tar, /mob/living/simple_mob/proc/ColorMate)
			if(istype(target,/mob/living/silicon/robot))
				var/mob/living/silicon/robot/Tar = target
				add_verb(Tar, /mob/living/silicon/robot/proc/ColorMate)

		if("be_event_invis")
			var/mob/living/Tar = target
			if(!istype(Tar)) //Technically does not need this restriction, but prevents ghosts accidentally being placed in mob layer
				return
			if(Tar.plane != PLANE_INVIS_EVENT)
				Tar.plane = PLANE_INVIS_EVENT
				if(!(VIS_EVENT_INVIS in Tar.vis_enabled))
					Tar.plane_holder.set_vis(VIS_EVENT_INVIS,TRUE)
					Tar.vis_enabled += VIS_EVENT_INVIS
			else
				Tar.plane = MOB_LAYER
				if(VIS_EVENT_INVIS in Tar.vis_enabled)
					Tar.plane_holder.set_vis(VIS_EVENT_INVIS,FALSE)
					Tar.vis_enabled -= VIS_EVENT_INVIS

		if("see_event_invis")
			if(!(VIS_EVENT_INVIS in target.vis_enabled))
				target.plane_holder.set_vis(VIS_EVENT_INVIS,TRUE)
				target.vis_enabled += VIS_EVENT_INVIS
			else if(VIS_EVENT_INVIS in target.vis_enabled)
				target.plane_holder.set_vis(VIS_EVENT_INVIS,FALSE)
				target.vis_enabled -= VIS_EVENT_INVIS
		*/

		////////INVENTORY//////////////

		if("drop_all")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/confirm = tgui_alert(ui.user, "Make [Tar] drop everything?", "Message", list("Yes", "No"))
			if(confirm != "Yes")
				return

			for(var/obj/item/W in Tar)
				Tar.dropItemToGround(W)

		if("drop_specific")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return

			var/list/items = Tar.get_equipped_items()
			var/item_to_drop = tgui_input_list(ui.user, "Choose item to force drop:", "Drop Specific Item", items)
			if(item_to_drop)
				Tar.dropItemToGround(item_to_drop)

		if("drop_held")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.drop_all_held_items()

		if("list_all")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			Tar.get_equipped_items()

		if("give_item")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/obj/item/X = ui.user.client.holder.marked_datum
			if(!istype(X))
				return
			Tar.put_in_hands(X)

		if("equip_item")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/obj/item/X = ui.user.client.holder.marked_datum
			if(!istype(X))
				return
			if(Tar.equip_to_appropriate_slot(X))
				return

		////////ADMIN//////////////

		if("teleport")
			var/where = tgui_alert(ui.user, "Where to teleport?", "Where?", list("To Me", "To Mob", "To Area", "Cancel"))
			if(where == "Cancel")
				return
			if(where == "To Me")
				ui.user.client.Getmob(target)
			if(where == "To Mob")
				var/mob/selection = tgui_input_list(ui.user, "Select a mob to jump [target] to:", "Jump to mob", GLOB.mob_list)
				target.forceMove(get_turf(selection))
				log_admin("[key_name(ui.user)] jumped [target] to [selection]")
			if(where == "To Area")
				var/area/A
				A = tgui_input_list(ui.user, "Pick an area to teleport [target] to:", "Jump to Area", GLOB.sortedAreas)
				target.forceMove(pick(get_area_turfs(A)))
				log_admin("[key_name(ui.user)] jumped [target] to [A]")
		
		if("gib")
			var/death = tgui_alert(ui.user, "Are you sure you want to destroy [target]?", "Gib?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.gib()
		
		if("dust")
			var/death = tgui_alert(ui.user, "Are you sure you want to destroy [target]?", "Dust?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.dust()

		if("subtle_message")
			ui.user.client.cmd_admin_subtle_message(target)

		if("direct_narrate")
			ui.user.client.cmd_admin_direct_narrate(target)

		if("view_variables")
			ui.user.client.debug_variables(target)
		
		if("orbit")
			if(!ui.user.client.holder.marked_datum)
				return
			var/atom/movable/X = ui.user.client.holder.marked_datum
			X.orbit(target)

		/*
		if("quick_nif")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			var/input_NIF
			if(!Tar.get_organ(BP_HEAD))
				to_chat(ui.user,span_warning("Target is unsuitable."))
				return
			if(Tar.nif)
				to_chat(ui.user,span_warning("Target already has a NIF."))
				return
			if(Tar.species.flags & NO_DNA)
				var/obj/item/nif/S = /obj/item/nif/bioadap
				input_NIF = initial(S.name)
				new /obj/item/nif/bioadap(Tar)
			else
				var/list/NIF_types = typesof(/obj/item/nif)
				var/list/NIFs = list()

				for(var/NIF_type in NIF_types)
					var/obj/item/nif/S = NIF_type
					NIFs[capitalize(initial(S.name))] = NIF_type

				var/list/show_NIFs = sortList(NIFs) // the list that will be shown to the user to pick from

				input_NIF = tgui_input_list(ui.user, "Pick the NIF type","Quick NIF", show_NIFs)
				var/chosen_NIF = NIFs[capitalize(input_NIF)]

				if(chosen_NIF)
					new chosen_NIF(Tar)
				else
					new /obj/item/nif(Tar)
			log_and_message_admins("Quick NIF'd [Tar.real_name] with a [input_NIF].", ui.user)

		if("resize")
			SSadmin_verbs.dynamic_invoke_verb(ui.user.client, /datum/admin_verb/resize, target)

		if("teleport")
			var/where = tgui_alert(ui.user, "Where to teleport?", "Where?", list("To Me", "To Mob", "To Area", "Cancel"))
			if(where == "Cancel")
				return
			if(where == "To Me")
				ui.user.client.Getmob(target)
			if(where == "To Mob")
				var/mob/selection = tgui_input_list(ui.user, "Select a mob to jump [target] to:", "Jump to mob", GLOB.mob_list)
				target.on_mob_jump()
				target.forceMove(get_turf(selection))
				log_admin("[key_name(ui.user)] jumped [target] to [selection]")
			if(where == "To Area")
				var/area/A
				A = tgui_input_list(ui.user, "Pick an area to teleport [target] to:", "Jump to Area", return_sorted_areas())
				target.on_mob_jump()
				target.forceMove(pick(get_area_turfs(A)))
				log_admin("[key_name(ui.user)] jumped [target] to [A]")

		if("gib")
			var/death = tgui_alert(ui.user, "Are you sure you want to destroy [target]?", "Gib?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.gib()

		if("dust")
			var/death = tgui_alert(ui.user, "Are you sure you want to destroy [target]?", "Dust?", list("KILL", "Cancel"))
			if(death == "KILL")
				target.dust()

		if("paralyse")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			ui.user.client.holder.paralyze_mob(Tar)

		if("subtle_message")
			ui.user.client.cmd_admin_subtle_message(target)

		if("direct_narrate")
			ui.user.client.cmd_admin_direct_narrate(target)

		if("player_panel")
			SSadmin_verbs.dynamic_invoke_verb(ui.user, /datum/admin_verb/show_player_panel, target)

		if("view_variables")
			ui.user.client.debug_variables(target)

		if("orbit")
			if(!ui.user.client.holder.marked_datum)
				return
			var/atom/movable/X = ui.user.client.holder.marked_datum
			X.orbit(target)

		if("ai")
			if(!isliving(target))
				to_chat(ui.user, span_notice("This can only be used on instances of type /mob/living"))
				return
			var/mob/living/L = target
			if(L.client || L.teleop)
				to_chat(ui.user, span_warning("This cannot be used on player mobs!"))
				return

			if(L.ai_holder)	//Cleaning up the original ai
				var/ai_holder_old = L.ai_holder
				L.ai_holder = null
				qdel(ai_holder_old)	//Only way I could make #TESTING - Unable to be GC'd to stop. del() logs show it works.
			L.ai_holder_type = tgui_input_list(ui.user, "Choose AI holder", "AI Type", typesof(/datum/ai_holder/))
			L.initialize_ai_holder()
			L.faction = tgui_input_text(ui.user, "Please input AI faction", "AI faction", "neutral", MAX_MESSAGE_LEN)
			L.a_intent = tgui_input_list(ui.user, "Please choose AI intent", "AI intent", list(I_HURT, I_HELP))
			if(tgui_alert(ui.user, "Make mob wake up? This is needed for carbon mobs.", "Wake mob?", list("Yes", "No")) == "Yes")
				L.AdjustSleeping(-100)

		if("cloaking")
			if(target.cloaked)
				target.uncloak()
			else if(!target.cloaked)
				target.cloak()

		if("give_quest")
			if(!target)
				return
			var/admin_quest =  tgui_alert(ui.user, "Do you want to give a random quest or a personalised one?", "Quest!", list("Random", "Personalised", "Cancel"))
			if(!admin_quest || (admin_quest == "Cancel"))
				return
			if(admin_quest == "Personalised")
				var/specific_quest = tgui_input_text(ui.user, "What is their quest?", "Quest!!!")
				if(!specific_quest)
					return
				target.quest_from_above(specific_quest)
			else
				target.quest_from_above()
		*/

		////////FIXES//////////////

		if("popup-box")
			var/message = tgui_input_text(ui.user, "Write a message to send to the user with a space for them to reply without using the text box:", "Message")
			if(!message)
				return
			log_admin("[key_name(ui.user)] sent message to [target]: [message]")
			var/reply = tgui_input_text(target, "An admin has sent you a message: [message]", "Reply")
			if(!reply)
				return
			log_and_message_admins("replied to [ui.user]'s message: [reply].", target)

		if("stop-orbits")
			if(target.orbiters)
				qdel(target.orbiters)
		
		if("clear_all_status")
			var/mob/living/carbon/human/Tar = target
			if(!istype(Tar))
				return
			for(var/datum/status_effect/our_status in Tar.status_effects)
				our_status.Destroy()

		/*
		if("revert-mob-tf")
			var/mob/living/Tar = target
			if(!istype(Tar))
				return
			Tar.revert_mob_tf()
		*/
