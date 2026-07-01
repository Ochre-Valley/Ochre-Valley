/datum/reagent/size
	description = ""
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	overdose_threshold = 33

/datum/reagent/size/grow
	name = "Enlargement Draught"
	color = "#87e7ff"
	taste_description = "light sweetness"
	scent_description = "fresh pastry"

/datum/reagent/size/grow/on_mob_life(mob/living/carbon/M)
	var/new_size = clamp((M.size_multiplier + 0.01), RESIZE_MINIMUM, RESIZE_MAXIMUM)
	M.resize(new_size)
	. = ..()

/datum/reagent/size/shrink
	name = "Reduction Draught"
	color = "#f98cff"
	taste_description = "tart cherry"
	scent_description = "tart fruitiness"

/datum/reagent/size/shrink/on_mob_life(mob/living/carbon/M)
	var/new_size = clamp((M.size_multiplier - 0.01), RESIZE_MINIMUM, RESIZE_MAXIMUM)
	M.resize(new_size)
	. = ..()

/datum/reagent/size/normal
	name = "Normalization Draught"
	color = "#999999"
	taste_description = "true blandness"
	scent_description = "nothing"

/datum/reagent/size/normal/on_mob_life(mob/living/carbon/M)
	if(M.size_multiplier > 1)
		M.resize(M.size_multiplier-0.01) //Decrease by 1% size per tick.
	else if(M.size_multiplier < 1)
		M.resize(M.size_multiplier+0.01) //Increase 1% per tick.
	. = ..()
	
