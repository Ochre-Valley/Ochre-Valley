/datum/emote/living/quest
	key = "quest"
	key_third_person = "has a quest to offer!"
	message = "has a quest to offer!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = TRUE

/datum/emote/living/quest/run_emote(mob/living/user, params, type_override, intentional, targetted, animal)
	if(user.persistent_emote)
		user.clear_overhead_indicator(user.persistent_emote, MUTATIONS_LAYER)
		user.persistent_emote = null
		to_chat(user, span_notice("You have stopped signaling you're offering a quest"))
	else
		. = ..()
		user.persistent_emote = user.play_overhead_indicator_simple('modular_ochrevalley/icons/mob/overhead_effects.dmi', "quest", 0, MUTATIONS_LAYER, soundin = 'sound/misc/levelup1.ogg', y_offset = 32)
		to_chat(user, span_notice("You have signaled you are offering a quest, use the 'Offer Quest' emote again to stop."))

/mob/living/carbon/human/verb/emote_quest()
	set name = "Offer Quest"
	set category = "Emotes"

	emote("quest", intentional =  TRUE)

/datum/emote/living/hiccup
	key = "hiccup"
	key_third_person = "hiccup"
	message = "hiccups."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_hiccup()
	set name = "Hiccup"
	set category = "Emotes.Noises"
	emote("hiccup", intentional = TRUE)

/datum/emote/living/hiccup/hic
	key = "hic"

/datum/emote/living/burp/belch
	key = "belch"
