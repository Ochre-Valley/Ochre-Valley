//OV FILE

/mob/living/carbon/human/proc/admin_buff(var/mob/user, var/buff_cat)
	if(!user.client.holder)
		return
	
	if(!buff_cat)
		buff_cat = tgui_input_list(user, "Which type of buff category do you want to use?", "Buff Category", list("spell", "order", "divine", "song", "general"))
		if(!buff_cat)
			return
	
	var/chosen_buff
	
	var/list/spell_buffs = list(
		"Stone Skin" = /datum/status_effect/buff/stoneskin,
		"Hawk Eyes" = /datum/status_effect/buff/hawks_eyes,
		"Dragon Eyes" = /datum/status_effect/buff/dragonhide,
		"Haste" = /datum/status_effect/buff/haste,
		"Guidance" = /datum/status_effect/buff/guidance,
		"Giants Strength" = /datum/status_effect/buff/giants_strength,
		"Fortitude" = /datum/status_effect/buff/fortitude,
		"Arcyne Momentum" = /datum/status_effect/buff/arcyne_momentum,
	)

	var/list/order_buffs = list(
		"On Your Feet" = /datum/status_effect/buff/order/onfeet,
		"Hold" = /datum/status_effect/buff/order/hold,
		"Take Aim" = /datum/status_effect/buff/order/takeaim,
		"Move Move Move" = /datum/status_effect/buff/order/movemovemove,
	)

	var/list/divine_buffs = list(
		"Arillean Apotheosis" = /datum/status_effect/buff/ashen_aril,
		"Pestra's embrace" = /datum/status_effect/buff/pestra_care,
		"Divine Rebirth" = /datum/status_effect/buff/divine_rebirth_healing,
		"Necran Mists" = /datum/status_effect/buff/necran_mists,
		"Necran Vow" = /datum/status_effect/buff/necras_vow,
		"Necra's Healing Vow" = /datum/status_effect/buff/healing/necras_vow,
		"Eoran Balm" = /datum/status_effect/buff/eoran_balm_effect,
		"Eora's Grace" = /datum/status_effect/buff/eora_grace,
		"Lesser Blessing of Eora" = /datum/status_effect/buff/peacecake,
		"Blessing of Eora" = /datum/status_effect/buff/pacify,
		"Blessing of the Lesser Wolf" = /datum/status_effect/buff/lesserwolf,
		"Ravox Provocation" = /datum/status_effect/buff/ravox_provocation,
		"Ravox Vow" = /datum/status_effect/buff/ravox_vow,
		"Noc Enlightenment" = /datum/status_effect/buff/wise_moon,
		"Noc Blessing" = /datum/status_effect/buff/nocblessing,
		"Noc Moonlight Dance" = /datum/status_effect/buff/moonlightdance,
		"Xylix Joy" = /datum/status_effect/buff/xylix_joy,
		"Astratan Gaze" = /datum/status_effect/buff/astrata_gaze,
		"Astratan Fire Resistance" = /datum/status_effect/buff/dragonhide/astrata,
		"Abyssal strength" = /datum/status_effect/buff/abyssal,
		"Matthios Equalize" = /datum/status_effect/buff/equalizebuff,
		"Graggar Bloodrage" = /datum/status_effect/buff/bloodrage,
		"Call To Slaughter" = /datum/status_effect/buff/call_to_slaughter,
		"Psydonic Endurance" = /datum/status_effect/buff/psydonic_endurance,
		"Psydon Enduring" = /datum/status_effect/buff/psyhealing,
		"Psydon Absolved" = /datum/status_effect/buff/psyvived,
	)
	
	var/list/song_buffs = list(
		"Rejuvinating Song" = /datum/status_effect/buff/healing/rejuvenationsong,
		"Recovery Song" = /datum/status_effect/buff/song/recovery,
		"Intellectual Interval" = /datum/status_effect/buff/song/intellectual_interval,
		"Furtive Fortissimo" = /datum/status_effect/buff/song/furtive_fortissimo,
		"Musical Fervor" = /datum/status_effect/buff/song/fervor,
		"Accelerating Akathist" = /datum/status_effect/buff/song/accelakathist,
	)

	var/list/general_buffs = list(
		"Stagehands Silence" = /datum/status_effect/buff/stagehands_silence,
		"Dagger Boost" = /datum/status_effect/buff/dagger_boost,
		"Great Massage" = /datum/status_effect/buff/greatmassage,
		"Refocus" = /datum/status_effect/buff/refocus,
		// "Intelligence" = /datum/status_effect/buff/magic/knowledge,
		"Adrenaline Rush" = /datum/status_effect/buff/adrenaline_rush,
		"Vigorized" = /datum/status_effect/buff/vigorized,
		"Call To Arms" = /datum/status_effect/buff/call_to_arms,
		"Guiding Light" = /datum/status_effect/buff/guidinglight,
		"Healing" = /datum/status_effect/buff/healing,
		"Feather Fall" = /datum/status_effect/buff/featherfall,
	)
	
	var/choice
	switch(buff_cat)
		if("spell")
			choice = tgui_input_list(user, "Choose a buff to apply to [src]", "Buffs", spell_buffs)
			if(!choice)
				return
			chosen_buff = spell_buffs[choice]
		if("order")
			choice = tgui_input_list(user, "Choose a buff to apply to [src]", "Buffs", order_buffs)
			if(!choice)
				return
			chosen_buff = order_buffs[choice]
		if("divine")
			choice = tgui_input_list(user, "Choose a buff to apply to [src]", "Buffs", divine_buffs)
			if(!choice)
				return
			chosen_buff = divine_buffs[choice]
		if("song")
			choice = tgui_input_list(user, "Choose a buff to apply to [src]", "Buffs", song_buffs)
			if(!choice)
				return
			chosen_buff = song_buffs[choice]
		if("general")
			choice = tgui_input_list(user, "Choose a buff to apply to [src]", "Buffs", general_buffs)
			if(!choice)
				return
			chosen_buff = general_buffs[choice]

	var/duration_choice = input("Select Duration for the Blessing:") as null|anything in list( \
		"Default", "1 Minute", "5 Minutes", "10 Minutes", "20 Minutes", \
		"30 Minutes", "60 Minutes", "4 Hours")
	if(!duration_choice)
		return FALSE

	var/duration
	switch(duration_choice)
		if("1 Minute") duration = 1 MINUTES
		if("5 Minutes") duration = 5 MINUTES
		if("10 Minutes") duration = 10 MINUTES
		if("20 Minutes") duration = 20 MINUTES
		if("30 Minutes") duration = 30 MINUTES
		if("60 Minutes") duration = 60 MINUTES
		if("4 Hours") duration = 4 HOURS
	
	if(apply_status_effect(chosen_buff))
		message_admins(span_notice("Admin [key_name_admin(user)] blessed [key_name_admin(src)] with [chosen_buff]! Duration: [duration_choice]."))
		playsound_local(get_turf(src), 'sound/magic/bless.ogg', 100, FALSE)
		if(duration)
			for(var/datum/status_effect/our_buff in status_effects)
				if(our_buff.type == chosen_buff)
					our_buff.duration = duration
