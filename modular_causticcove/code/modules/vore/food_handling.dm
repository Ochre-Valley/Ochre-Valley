/obj/item/reagent_containers/food
	var/food_can_insert_micro = FALSE
	var/list/food_inserted_micros

/obj/item/reagent_containers/food/container_resist(mob/living/M)
	if(istype(M, /mob/living/voice)) return	// CHOMPAdd - Stops sentient food from astral projecting
	if(food_inserted_micros)
		food_inserted_micros -= M
	//if(isdisposalpacket(loc)) //Causitc - I believe this is for the Disposals Piping System.
	//	M.forceMove(loc)
	//else
	M.forceMove(get_turf(src))
	to_chat(M, span_warning("You climb out of \the [src]."))

//I ended up not having the patience to bother with this mess. Uhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh. Don't cook micros pls! I am not responsible when it inevitably happens :P -- Jon
//Why the hell is all the rogue-food just, NOT like, childs of a main type for the most part... Goddamn
/obj/item/reagent_containers/food/snacks/rogue
	food_can_insert_micro = TRUE

/*/obj/item/reagent_containers/food/snacks/rogue/honey
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/preserved
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/crackerscooked
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/bread
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/breadslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/sandwich
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/bun
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/crossbun
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cheesebun
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/frybread
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/raisinbread
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/bun_grenz
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/bun_raston
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/frostedcake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/applecake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/applecakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/applenutcake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/applecake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/berrycake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/carrotcake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/lemoncake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/limecake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/limecakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/menthacake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/menthacakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/peacecake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/hcake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/ccake
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/friedegg
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/stuffedegg
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/wieneronions
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/pastry
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/biscuit
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cookie
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/prezzel
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/pumpkinball
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	food_can_insert_micro = TRUE

/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf
	food_can_insert_micro = TRUE*/
