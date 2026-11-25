/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry_sugared
	cuisine = CUISINE_RANESHENI
	dish_type = DISH_FRUIT|DISH_SWEET
	name = "smothered raspberry"
	desc = "Sugared raspberries, smothered in sweetness and awaiting to be baptized in a pot of boiling fat."
	icon = 'modular_ochrevalley/icons/roguetown/items/produce.dmi'
	icon_state = "raspberrysugar"
	faretype = FARE_FINE
	splat_color = "#A01600"
	tastes = list("overpoweringly sweet" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	eat_effect = /datum/status_effect/buff/sweet
	juice_results = list(/datum/reagent/consumable/juice/raspberry = JUICE_YIELD)
