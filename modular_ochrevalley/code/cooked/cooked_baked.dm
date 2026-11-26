/*	.................   Pestoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/pestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
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
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
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
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/meatpestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "sausaged pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and crispy sasuages; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "meat_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meatpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "crispy sausages" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/meatpestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "slice of sausaged pestoplate"
	desc = "What do you mean this is a Baothan's favorite kind of slice?"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "meat_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "crispy sausages" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/fishpestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "fished pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and oily fishes; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "fish_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fishpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "oily fish" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/fishpestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "slice of fished pestoplate"
	desc = "Excuse me, sire, but I specifically asked for no anchovies or zardines!"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "fish_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "oily fish" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/onionpestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "onioned pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and crunchy onions; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/onionpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "snappy, crunchy onions" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/onionpestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "slice of onioned pestoplate"
	desc = "Excuse me, sire, but I specifically asked for no anchovies or zardines!"
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "snappy, crunchy onions" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "truffled pestoplate"
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and decadant truffles; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and decadant truffles" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "slice of truffled pestoplate"
	desc = "A slice that's fit for a king! ..so long as that trufflepig didn't accidentally pick a poisoned patch of truffles, of course."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and decadant truffles" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "truffled pestoplate" //Like jackberried treats, this is a poisoned variant! For those who don't properly source their truffles.. or simply want to poison others!
	desc = "A culinary delight from Azuria's shores, purported to've originated from an inflow of Etruscean refugees from long ago. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and decadant truffles; all it's missing \
	is a cold pint of ale and an ongoing game of lampternball to jeer at."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "truffle_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4, /datum/reagent/berrypoison = 5)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "rubbery and bitter truffles" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "slice of truffled pestoplate" //Ditto.
	desc = "A slice that's fit for a king! ..so long as that trufflepig didn't accidentally pick a poisoned patch of truffles, of course."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "onion_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1, /datum/reagent/berrypoison = 5)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "rubbery and bitter truffles" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff

//

/obj/item/reagent_containers/food/snacks/rogue/pearpestoplate
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "pearacotta pestoplate"
	desc = "A curious spin on an Azurian classic, attributed to the hands of Vanderlin's most esteemed culinarians. The \
	richness of the flatbread's pesto sauce is perfectly complemented by its cheesey blanket and sweet pears; a melody of flavors \
	that has helped to embolden the creativity of Psydonia's artists for centuries-hence, and - hopefully - centuries-more."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pear_pizza_pesto"
	slices_num = 6
	bitesize = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pearpestoplate_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_TWO_MEALS + NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/westleach = 4)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "sweet and tangy pears" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/pearpestoplate_slice
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "slice of pearacotta pestoplate"
	desc = "You'd never imagine that such contrasting ingredients could meld together so wonderfully; and yet, they do! Such is the joy of creation.."
	icon = 'modular_ochrevalley/icons/cooked/pestoplates_cooked.dmi'
	icon_state = "pear_pizza_pesto_slice"
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL, /datum/reagent/consumable/acorn_powder = 1, /datum/reagent/drug/westleach = 1)
	tastes = list("nutty, herby, and garlicky sauce" = 1, "hot and gooey cheese" = 1, "savory and tangy pears" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.................   Jellytallowed  ................... */
/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/jellytallowed_slice
	dish_type = DISH_BREAD|DISH_MEAT|DISH_FRUIT
	tastes = list("crunchy, jellied sweet-tartiness" = 1, "a wonderful start to the dae" = 1)
	name = "jellytallowed toast"
	desc = "A raspberried jelly, smeared across a slice of toast. Beloved by burghers, nobility and peasantry alike, this is a wonderful way to start a good dae."
	faretype = FARE_FINE
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	icon_state = "toast_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/bun_jellytallow
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_BREAD|DISH_MEAT
	name = "jellytallowed bun"
	desc = "A delicious treat to bring along for those long-and-lonesome hikes through the Azurian wetlands; \
	doubly-so, if you happen to be repulsed by blackberries and tangerines."
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	tastes = list("jellied sweet-tartiness" = 1, "a lavish break from the dae's woes" = 1)
	icon_state = "bun_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/crossbun_jellytallowed
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_BREAD|DISH_MEAT|DISH_FRUIT
	name = "jellytallowed crossbun"
	desc = "Colored like the sunrise - or sunset, depending on your point of view. Makes for a perfect Astratan breakfast or supper!"
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("jellied sweet-tartiness" = 1, "a sense of divine gravitas" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun_jellytallowed
	cuisine = CUISINE_OTAVAIS
	dish_type = DISH_BREAD|DISH_MEAT|DISH_FRUIT
	name = "jellytallowed psycrossbun"
	desc = "A particularly favorite treat amongst Reformist sects, especially during the \
	holidaes that pay reverence to Psydon's sacrifice. The jellytallow is said to represent the Weeping God's \
	blood spilled on Psydonia's behalf, though the spiritual implication tends to be lost on more eager-minded children."
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("jellied sweet-tartiness" = 1, "a sense of enduring anguish" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/decabun_jellytallowed

	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_BREAD|DISH_MEAT|DISH_FRUIT
	name = "jellytallowed decabun"
	desc = "A decabun, cruelly parted to be slathered with a spread of jellytallow. Once whole, now wounded; but still bonded together in sweet unity."
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	icon_state = "decabun_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("jellied sweet-tartiness" = 1, "decadent sweetness" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/zbun_jellytallow
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_BREAD|DISH_MEAT|DISH_FRUIT
	name = "jellytallowed zun"
	desc = "A zun, cruelly parted and slathered with red deliciousness. The jellytallow nestled within is \
	said to represent the blood spilled in the name of wealth, might, passion and progress, though the \
	spiritual implication tends to be lost on more eager-minded heretics." //more inclusive ZBuns, for all four Heretic faiths!
	icon = 'modular_ochrevalley/icons/cooked/cooked_baked.dmi'
	icon_state = "zbun_jellytallow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	rotprocess = SHELFLIFE_EXTREME
	tastes = list("jellied sweet-tartiness" = 1, "unholy sweetness" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
