/*	.................   Pestoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/pestoplate
	name = "pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket; all it's missing is a cold pint of \
	ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "a hint of herbiness" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pestoplate_slice
	name = "slice of pestoplate"
	desc = "The ultimate definition of being 'more than the sum of its parts'."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "a hint of herbiness" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/meatpestoplate
	name = "sausaged pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and crispy sasuages; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "meat_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meatpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "crispy sausages" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/meatpestoplate_slice
	name = "slice of sausaged pestoplate"
	desc = "What do you mean this is a Baothan's favorite kind of slice?"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "meat_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "crispy sausages" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/fishpestoplate
	name = "fished pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and oily fishes; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "fish_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fishpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "oily fish" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/fishpestoplate_slice
	name = "slice of fished pestoplate"
	desc = "Excuse me, sire, but I specifically asked for no anchovies or zardines!"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "fish_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "oily fish" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY | MEAT
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/onionpestoplate
	name = "onioned pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and crunchy onions; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/onionpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "snappy, crunchy onions" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/onionpestoplate_slice
	name = "slice of onioned pestoplate"
	desc = "Excuse me, sire, but I specifically asked for no anchovies or zardines!"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "snappy, crunchy onions" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate
	name = "truffled pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and decadant truffles; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and decadant truffles" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate_slice
	name = "slice of truffled pestoplate"
	desc = "A slice that's fit for a king! ..so long as that trufflepig didn't accidentally pick a poisoned patch of truffles, of course."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and decadant truffles" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate
	name = "truffled pestoplate" //Like jackberried treats, this is a poisoned variant! For those who don't properly source their truffles.. or simply want to poison others!
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and decadant truffles; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "truffle_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4, /datum/reagent/berrypoison = 5)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "rubbery and bitter truffles" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate_slice
	name = "slice of truffled pestoplate" //Ditto.
	desc = "A slice that's fit for a king! ..so long as that trufflepig didn't accidentally pick a poisoned patch of truffles, of course."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1, /datum/reagent/berrypoison = 5)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "rubbery and bitter truffles" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/pearpestoplate
	name = "pearacotta pestoplate"
	desc = "A curious spin on an Azurian classic, attributed to the hands of Vanderlin's most esteemed culinarians. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and sweet pears; a melody of flavors \
	that has helped to embolden the creativity of Psydonia's artists for centuries-hence, and - hopefully - centuries-more."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pear_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pearpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 4)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "sweet and tangy pears" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pearpestoplate_slice
	name = "slice of pearacotta pestoplate"
	desc = "You'd never imagine that such contrasting ingredients could meld together so wonderfully; and yet, they do! Such is the joy of creation.."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pear_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/nicotine = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and tangy pears" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	foodtype = GRAIN | VEGETABLES | DAIRY
	eat_effect = /datum/status_effect/buff/snackbuff
