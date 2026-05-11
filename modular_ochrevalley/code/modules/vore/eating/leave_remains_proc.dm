GLOBAL_LIST_INIT(organic_bones, list(
	/obj/item/digestion_remains,
	/obj/item/digestion_remains/variant1,
	/obj/item/digestion_remains/variant2,
	/obj/item/digestion_remains/variant3
))

GLOBAL_LIST_INIT(synthetic_bones, list(
	/obj/item/digestion_remains/synth,
	/obj/item/digestion_remains/synth/variant1,
	/obj/item/digestion_remains/synth/variant2,
	/obj/item/digestion_remains/synth/variant3
))

/obj/belly/proc/handle_remains_leaving(mob/living/prey)
	if(!istype(prey))
		return

	// Some variety in amount of bones left
	var/bones_amount = rand(2, 4)

	for(var/i = 1, i <= bones_amount, i++)	//throw in the rest
		var/new_bone = prey.construct ? pick(GLOB.synthetic_bones) : pick(GLOB.organic_bones)
		new new_bone(src, owner, prey)

	if(!ishuman(prey) || prey.construct) // synths n' animals don't have skulls and ribcages that survive digestion
		return

	if(prob(20)) //ribcage surviving whole is some luck
		new /obj/item/digestion_remains/ribcage(src, owner, prey)
		bones_amount--

	new /obj/item/digestion_remains/skull(src, owner, prey)
