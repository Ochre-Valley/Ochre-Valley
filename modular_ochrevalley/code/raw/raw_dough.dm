/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw
	dish_type = DISH_BREAD|DISH_VEGETABLE
	name = "uncooked pestoplate"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "pizza_pesto_base"
	desc = "Flatdough with a healthy smearing of pesto sauce upon its surface. A sprinkling of fresh cheese should round it all out."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_cheese
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "uncooked pestoplate with cheese"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce - and sprinkling of fresh cheese - upon its surface. It is ready to be baked into a delicious pestoplate, lest one wishes to further adorn it with sausages, fillets, onions, pears, or truffles."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pestoplate

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_sausage
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "uncooked pestoplate with sausages"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "sausage_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of sliced sausages upon its surface. It is ready to be baked into a deliciously rich pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate_meat
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meatpestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_fish
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY|DISH_MEAT
	name = "uncooked pestoplate with fishes"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "fish_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of filleted fishes upon its surface. It is ready to be baked into a deliciously oiled pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate_fish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fishpestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_truffles
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "uncooked pestoplate with truffles"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "truffle_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/trufflepestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_poisontruffles
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "uncooked pestoplate with truffles"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "truffle_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	list_reagents = list(/datum/reagent/berrypoison = 5)
	cooked_smell = /datum/pollutant/food/pestoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisontrufflepestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_onion
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "uncooked pestoplate with onions"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "onion_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of ringed onions upon its surface. It is ready to be baked into a deliciously earthsome pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate_onion
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/onionpestoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/pestoplate_raw_pear
	dish_type = DISH_BREAD|DISH_VEGETABLE|DISH_DAIRY
	name = "uncooked pestoplate with pears"
	icon = 'modular_ochrevalley/icons/raw/pestoplates.dmi'
	icon_state = "pear_pizza_pesto_uncooked"
	desc = "Flatdough with a healthy smearing of pesto sauce, a sprinkling of fresh cheese, and a dotting of juicy pears upon its surface. It is ready to be baked into a deliciously creative pestoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pestoplate_pear
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearpestoplate
