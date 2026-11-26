/obj/item/reagent_containers/food/snacks/jellytallow
	dish_type = DISH_SWEET|DISH_MEAT
	name = "stick of jellytallow" //Usually you'd need pectin to make a jam or jelly out of raspberries but *shrug*
	desc = "An Azurian cousin of blackberry Jamtallow; an ingot of jellified raspberries, fit only for the finest slices of bread. It beckons to be sliced with proper cutlery."
	icon = 'modular_ochrevalley/icons/others/sweet.dmi'
	icon_state = "jellytallow6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_POOR //Slightly better than eating a whole log of butter on your lonesome. Slightly.
	slice_path = /obj/item/reagent_containers/food/snacks/jellytallowslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("stickied deliciousness" = 1, "subtle sweet-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/jamtallow/update_icon()
	if(slices_num)
		icon_state = "jellytallow[slices_num]"
	else
		icon_state = "jellytallow_slice"

/obj/item/reagent_containers/food/snacks/jamtallow/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/jellytallowslice
	dish_type = DISH_SWEET|DISH_MEAT
	name = "slice of jellytallow"
	desc = "A portion of jellied paradise, bearing the same hues as a fine Otavan wine. It yearns to be savored not \
	by its lonesome, but upon a slice of bread - ideally, bookbread or toasted."
	icon = 'modular_ochrevalley/icons/others/sweet.dmi'
	icon_state = "jellytallow_slice"
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("stickied deliciousness" = 1, "subtle sweet-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet
