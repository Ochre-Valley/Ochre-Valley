/datum/food_recipe/dough/pestoplate
	name = "pestoplate base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/pesto
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw

/datum/food_recipe/dough/pestoplate_cheese
	name = "cheesed pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese

/datum/food_recipe/dough/pestoplate_sausage
	name = "sausage pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_sausage

/datum/food_recipe/dough/pestoplate_fish
	name = "fish pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_fish

/datum/food_recipe/dough/pestoplate_truffle
	name = "truffle pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/truffles
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_truffles

/datum/food_recipe/dough/pestoplate_poisontruffle
	name = "truffle pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/toxicshrooms
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_poisontruffles
	hidden = TRUE

/datum/food_recipe/dough/pestoplate_onion
	name = "onion pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
			/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_onion
	time_per_step = 3 SECONDS

/datum/food_recipe/dough/pestoplate_pear
	name = "pear pestoplate"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_pear
