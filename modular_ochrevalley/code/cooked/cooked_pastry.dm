/obj/item/reagent_containers/food/snacks/rogue/muffin/shrink
	name = "raw fae muffin"
	desc = "A mushroom shaped treat for whole topped off with a reduction of an odd mushroom. Still needs to be baked!"
	icon = 'modular_ochrevalley/icons/cooked/cooked_pastry.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION, /datum/reagent/size/shrink = 5)
	icon_state = "shrink_muffin_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/shrink/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/shrink/baked
	name = "fae muffin"
	desc = "A mushroom shaped treat for whole topped off with a caramelized reduction of some odd mushroom. Fit for a burgher."
	icon = 'modular_ochrevalley/icons/cooked/cooked_pastry.dmi'
	icon_state = "shrink_muffin"
	cooked_smell = /datum/pollutant/food/muffin
	faretype = FARE_FINE
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/muffin/grow
	name = "raw hearty muffin"
	desc = "A mushroom shaped treat for whole topped off with an herbal blend rumored to encourage growth. Still needs to be baked!"
	icon = 'modular_ochrevalley/icons/cooked/cooked_pastry.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION, /datum/reagent/size/grow = 5)
	icon_state = "grow_muffin_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/grow/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/grow/baked
	name = "hearty muffin"
	desc = "A mushroom shaped treat for whole topped off with an herbal blend rumored to encourage growth. Fit for a burgher."
	icon = 'modular_ochrevalley/icons/cooked/cooked_pastry.dmi'
	icon_state = "grow_muffin"
	cooked_smell = /datum/pollutant/food/muffin
	faretype = FARE_FINE
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_jellytallowed
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_PASTRY|DISH_DAIRY|DISH_BREAD|DISH_MEAT|DISH_FRUIT
	name = "slice of jellytallowed bookbread"
	desc = "'The scarlet stains upon the body and especially upon the face of the victim, were the pest ban \
	which shut him out from the aid and from the sympathy of his fellow-men.'" //The Masque of the Red Death - Edgar Allan Poe
	icon = 'modular_ochrevalley/icons/cooked/cooked_pastry.dmi'
	icon_state = "bookbread_slice_jellytallow"
	faretype = FARE_LAVISH
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("chewy, crispy-edged butterdough" = 1, "jellied sweet-tartiness" = 1, "a lavish start to the dae" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION + NUTRITION_HALF_MEAL)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	dropshrink = 0.8
	eat_effect = /datum/status_effect/buff/greatsnackbuff
