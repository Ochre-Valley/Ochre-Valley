/datum/virtue/utility/culinarian
	name = "Culinarian"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "Anyone can cook. You know that better than everybody. Why should you settle for the blandness of rations and other chaff when you can prepare the good stuff yourself? You may even fancy making a brew or two."
	added_stashed_items = list("Mess Kit" = /obj/item/storage/gadget/messkit)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
                        list(/datum/skill/craft/cooking, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2))

/datum/virtue/utility/beauty
	name = "Beauty (Beautiful Single-Pick)"
	added_traits = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER)
	desc = "(THIS IS A SINGLE PICK FOR CLASSES LOCKED OUT OF THE WELL-OFF VIRTUE) Just looking at me relieves some of the hardships of the world, and I'm quite good in bed."
	added_stashed_items = list("Hand Mirror" = /obj/item/handmirror)


#define SPARK_CHILLFOOD "Chill Food"
#define SPARK_CAMPFIRE "Create Campfire"
#define SPARK_CLEANING "Greater Cleaning"
#define SPARK_FETCH "Lesser Fetch"
#define SPARK_REPEL "Lesser Repel"
#define SPARK_LIGHT "Light"
#define SPARK_MESSAGE "Message"
#define SPARK_MIRROR "Mirror Transform"
#define SPARK_NONDETECT "Nondetection"
#define SPARK_GROW "Reduce/Grow Person"
#define SPARK_INSTRUMENT "Conjure Instrument"
#define SPARK_TRANSCRIBE "Transcribe"
#define SPARK_OMEN "Read Omen"
#define SPARK_FRIDGE "Fridigitation"

/datum/virtue/utility/spark
	name = "Spark of Magick"
	desc = "A little bit of the arycne graces my form. I can make use of up to three utility cantrips."
	max_choices = 3
	choice_costs = list(0, 0, 0)
	extra_choices = list(
		SPARK_CHILLFOOD,
		SPARK_CAMPFIRE,
		SPARK_CLEANING,
		SPARK_FETCH,
		SPARK_REPEL,
		SPARK_LIGHT,
		SPARK_MESSAGE,
		SPARK_MIRROR,
		SPARK_NONDETECT,
		SPARK_GROW,
		SPARK_INSTRUMENT,
		SPARK_TRANSCRIBE,
		SPARK_OMEN,
		SPARK_FRIDGE,
	)
	choice_tooltips = list(
		SPARK_CHILLFOOD = "Chill a piece of food with a touch of frost without affecting its quality, extending its freshness by a half of a dae (15 MINUTES OOC).",
		SPARK_CAMPFIRE = "Creates a magical campfire to cook on. 3 tiles range. Lasts for 10 minutes.",
		SPARK_CLEANING = "Unleash a wave of kinetic force that scours a nearby area clean of grime and debris.",
		SPARK_FETCH = "Shoot out a magical bolt that draws in a freestanding item towards the caster. Doesn't work on living targets.",
		SPARK_REPEL = "Shoot out a magical bolt that pushes away a freestanding item from the caster. Doesn't work on large or living targets. Instead of repelling a target, it will throw an object in your hand if cast while in throw mode.",
		SPARK_LIGHT = "Summons a condensed orb of light.",
		SPARK_MESSAGE = "Latch onto the mind of one who is familiar to you, whispering a message or sending an intuitive projection into their head.",
		SPARK_MIRROR = "Gives you a arcyne hand mirror that allows one to change their appearance at will.",
		SPARK_NONDETECT = "Shroud a target from divination magic for 1 hour.",
		SPARK_GROW = "A basic trick many apprentices would use to prank their master. Allows one to shift in size to their whims! (( Abuse of this spell for combat purposes will lead to consequences from staff. ))",
		SPARK_INSTRUMENT = "Conjure a Instrument of your choice in your hand. The instrument will be unsummoned should you conjure a new one or unbind the spell.",
		SPARK_TRANSCRIBE = "Conjure a parchment and a magical quill to write for you. This magical parchment will listen for up to ten minutes and transcribe what it has heard onto itself. (use in your hand, and then use again to stop the recording).",
		SPARK_OMEN = "Casting this spell, you draw upon the leylines themselves to reveal secrets of fate itself. (Casting it gives you a vague explanation of who the current storyteller is, if they are your patron the explanation is less vague.)",
		SPARK_FRIDGE = "An advanced version of Chill Food. Greatly prolongs shelf life by entirely freezing it solid. (OOC Note: it does not work on produce, only foods, removes rot timer entirely.).",
	)

/datum/virtue/utility/spark/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!triumph_check(recipient))
		return
	if (!recipient.mind?.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
		recipient.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
	for(var/choice in picked_choices)
		switch(choice)
			if(SPARK_CHILLFOOD)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/chill_food))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/chill_food)
			if(SPARK_CAMPFIRE)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/create_campfire))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/create_campfire)
			if(SPARK_CLEANING)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/greater_cleaning))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/greater_cleaning)
			if(SPARK_FETCH)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/projectile/lesser_fetch))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/lesser_fetch)
			if(SPARK_REPEL)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/projectile/lesser_repel))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/lesser_repel)
			if(SPARK_LIGHT)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/light))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/light)
			if(SPARK_MESSAGE)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/message))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/message)
			if(SPARK_MIRROR)
				if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/mirror_transform_ov))
					recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mirror_transform_ov)
			if(SPARK_NONDETECT)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/nondetection))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/nondetection)
			if(SPARK_GROW)
				if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/sizespell))
					recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/sizespell)
			if(SPARK_INSTRUMENT)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/conjure_instrument))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/conjure_instrument)
			if(SPARK_TRANSCRIBE)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/transcribe))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/transcribe)
			if(SPARK_OMEN)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/readomen))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/readomen)
			if(SPARK_FRIDGE)
				if(!recipient.mind?.has_spell(/datum/action/cooldown/spell/fridigitation))
					recipient.mind?.AddSpell(new /datum/action/cooldown/spell/fridigitation)

#undef SPARK_CHILLFOOD
#undef SPARK_CAMPFIRE
#undef SPARK_CLEANING
#undef SPARK_FETCH
#undef SPARK_REPEL
#undef SPARK_LIGHT
#undef SPARK_MESSAGE
#undef SPARK_MIRROR
#undef SPARK_NONDETECT
#undef SPARK_GROW
#undef SPARK_INSTRUMENT
#undef SPARK_TRANSCRIBE
#undef SPARK_OMEN
#undef SPARK_FRIDGE

/datum/virtue/utility/mountable
	name = "Mountable"
	desc = "You have trained and become fit enough to function as a suitable mount. People may ride you as they would a saiga."
	added_traits = list(TRAIT_MOUNTABLE)

