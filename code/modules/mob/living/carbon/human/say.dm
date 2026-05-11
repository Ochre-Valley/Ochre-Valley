/mob/living/carbon/human/say_mod(input, message_mode)
	verb_say = dna.species.say_mod
	if(slurring)
		return "slurs"
	else
		. = ..()

/mob/living/carbon/human/GetVoice()
	if(GetSpecialVoice())
		return GetSpecialVoice()
	if(absorbed && isbelly(loc)) // If absorbed in a belly, check and apply absorbed rename if applicable.
		var/obj/belly/B = loc
		if(B.absorbedrename_enabled)
			var/formatted_name = B.absorbedrename_name
			formatted_name = replacetext(formatted_name,"%pred", B.owner)
			formatted_name = replacetext(formatted_name,"%belly", B.get_belly_name())
			formatted_name = replacetext(formatted_name,"%prey", name)
			return formatted_name
	return real_name

/mob/living/carbon/human/IsVocal()
	// how do species that don't breathe talk? magic, that's what.
	if(!HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT) && !getorganslot(ORGAN_SLOT_LUNGS))
		return FALSE
	if(mind)
		return !mind.miming
	return TRUE

/mob/living/carbon/human/proc/SetSpecialVoice(new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/radio(message, message_mode, list/spans, language)
	. = ..()
	if(. != 0)
		return .

	switch(message_mode)
		if(MODE_HEADSET)
			if (ears)
				ears.talk_into(src, message, , spans, language)
			return ITALICS | REDUCE_RANGE

		if(MODE_DEPARTMENT)
			if (ears)
				ears.talk_into(src, message, message_mode, spans, language)
			return ITALICS | REDUCE_RANGE

	if(message_mode in GLOB.radiochannels)
		if(ears)
			ears.talk_into(src, message, message_mode, spans, language)
			return ITALICS | REDUCE_RANGE

	return 0

/mob/living/carbon/human/get_alt_name(var/force = FALSE)
	if(absorbed && isbelly(loc))
		var/obj/belly/B = loc
		if(B.absorbedrename_enabled)
			return "" // Don't use alt name if under absorbed rename.

	if(force || name != GetVoice())
		var/datum/mob_descriptor/voice/voice_descriptor = get_descriptor_type(/datum/mob_descriptor/voice)
		if(!voice_descriptor || (HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && !show_descriptors))
			return "Unknown Person"

		var/voice_gender = "Person"
		switch(voice_type)
			if(VOICE_TYPE_FEM)
				voice_gender = "Woman"
			if(VOICE_TYPE_MASC)
				voice_gender = "Man"
			if(VOICE_TYPE_ANDR)
				voice_gender = "Person"

		return voice_descriptor.get_speaking_name(voice_gender)

/mob/living/carbon/human/proc/forcesay(list/append) //this proc is at the bottom of the file because quote fuckery makes notepad++ cri
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx_char(temp, "Say \"", 1, 7) && length(temp) > 5)	//"case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext_char(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext_char(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext_char(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext_char(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext_char(trim_left(temp), 3)

				if(findtext_char(temp, "*", 1, 2))	//emotes
					return

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/carbon/human/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, message_mode, original_message)
	. = ..()
	if(message_mode != MODE_WHISPER)
		send_voice(message)
	else	//OV ADD
		playsound(get_turf(src), 'modular_ochrevalley/sounds/message_effects/whisper.ogg', 25, FALSE, -5,frequency = rand(25000, 50000))	//OV ADD

/mob/living/carbon/human/proc/send_voice(message, skip_thingy)
	if(!message || !length(message))
		return
	if(dna.species)
		dna.species.send_voice(src)

/datum/species/proc/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), 'sound/misc/talk.ogg', 100, FALSE, -1)
