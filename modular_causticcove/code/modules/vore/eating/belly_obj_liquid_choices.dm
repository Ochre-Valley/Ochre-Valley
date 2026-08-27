//Similarly check out vore_liquid_defines.dm to add more options!

//////////////////////////// REAGENT SELECTION /////////////////////

//This is gonna end up a long proc, but its gonna have to make do for now

/obj/belly/proc/ReagentSwitch()
	var/list/our_reagents = list()
	for(var/entry in reagent_choices)
		our_reagents.Add(lowertext(entry))
	switch(reagent_chosen)
		if(REAGENT_WATER)
			generated_reagents = list(REAGENT_ID_WATER = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER)
			gen_amount = 2
			gen_cost = 1
			reagentid = REAGENT_WATER
			reagentcolor = "#0064C877"
		if(REAGENT_WATER_BATH)
			generated_reagents = list(REAGENT_ID_WATER_BATH = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_BATH)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_WATER_BATH
			reagentcolor = "#c9e5eec6"
		if(REAGENT_WATER_SALT)
			generated_reagents = list(REAGENT_ID_WATER_SALT = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_SALT)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_WATER_SALT
			reagentcolor = "#417ac5c6"
		if(REAGENT_WATER_HOLY)
			generated_reagents = list(REAGENT_ID_WATER_HOLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_HOLY)
			gen_amount = 1
			gen_cost = 20
			reagentid = REAGENT_WATER_HOLY
			reagentcolor = "#E0E8EF"
		if(REAGENT_WATER_UNHOLY)
			generated_reagents = list(REAGENT_ID_WATER_UNHOLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_UNHOLY)
			gen_amount = 1
			gen_cost = 20
			reagentid = REAGENT_WATER_UNHOLY
			reagentcolor = "#660000"
		if(REAGENT_MILK)
			generated_reagents = list(REAGENT_ID_MILK = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_MILK)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_MILK
			reagentcolor = "#DFDFDF"
		if(REAGENT_COFFEE)
			generated_reagents = list(REAGENT_ID_COFFEE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_COFFEE)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_COFFEE
			reagentcolor = "#482000"
		if(REAGENT_TEA)
			generated_reagents = list(REAGENT_ID_TEA = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TEA)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_TEA
			reagentcolor = "#508141"
		if(REAGENT_TEA_ROSE)
			generated_reagents = list(REAGENT_ID_TEA_ROSE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TEA_ROSE)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_TEA_ROSE
			reagentcolor = "#f398b6"
		if(REAGENT_TEA_CALENDULA)
			generated_reagents = list(REAGENT_ID_TEA_CALENDULA = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TEA_CALENDULA)
			gen_amount = 1
			gen_cost = 15
			reagentid = REAGENT_TEA_CALENDULA
			reagentcolor = "#b38e17"
		if(REAGENT_TEA_VALERIAN)
			generated_reagents = list(REAGENT_ID_TEA_VALERIAN = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TEA_VALERIAN)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_TEA_VALERIAN
			reagentcolor = "#f398b6"
		if(REAGENT_HONEY)
			generated_reagents = list(REAGENT_ID_HONEY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_HONEY)
			gen_amount = 1
			gen_cost = 60
			reagentid = REAGENT_HONEY
			reagentcolor = "#d3a308"
		if(REAGENT_PARAPOISON)
			generated_reagents = list(REAGENT_ID_PARAPOISON = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_PARAPOISON)
			gen_amount = 1
			gen_cost = 250
			reagentid = REAGENT_PARAPOISON
			reagentcolor = "#508141"
		if(REAGENT_SPACEDRUGS)
			generated_reagents = list(REAGENT_ID_SPACEDRUGS = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_SPACEDRUGS)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_SPACEDRUGS
			reagentcolor = "#60A584"
		if(REAGENT_POT_MANA)
			generated_reagents = list(REAGENT_ID_POT_MANA = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_POT_MANA)
			gen_amount = 1
			gen_cost = 15
			reagentid = REAGENT_POT_MANA
			reagentcolor = "#000042"
		if(REAGENT_POT_HEALTH)
			generated_reagents = list(REAGENT_ID_POT_HEALTH = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_POT_HEALTH)
			gen_amount = 1
			gen_cost = 20
			reagentid = REAGENT_POT_HEALTH
			reagentcolor = "#ff0000"
		if(REAGENT_POT_POPPY)
			generated_reagents = list(REAGENT_ID_POT_POPPY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_POT_POPPY)
			gen_amount = 1
			gen_cost = 20
			reagentid = REAGENT_POT_POPPY
			reagentcolor = "#dbd7d5"
		if(REAGENT_JUICE_JACKBERRY)
			generated_reagents = list(REAGENT_ID_JUICE_JACKBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_JACKBERRY)
			gen_amount = 1
			gen_cost = 20
			reagentid = REAGENT_JUICE_JACKBERRY
			reagentcolor = "#F1EBDB"
		if(REAGENT_JUICE_JACKBERRY_POISON)
			generated_reagents = list(REAGENT_ID_JUICE_JACKBERRY_POISON = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_JACKBERRY_POISON)
			gen_amount = 1
			gen_cost = 100
			reagentid = REAGENT_JUICE_JACKBERRY_POISON
			reagentcolor = "#F1EBDB"
		if(REAGENT_JUICE_APPLE)
			generated_reagents = list(REAGENT_ID_JUICE_APPLE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_APPLE)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_APPLE
			reagentcolor = "#D7B086"
		if(REAGENT_JUICE_TOMATO)
			generated_reagents = list(REAGENT_ID_JUICE_TOMATO = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_TOMATO)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_TOMATO
			reagentcolor = "#FF6347"
		if(REAGENT_JUICE_STRAWBERRY)
			generated_reagents = list(REAGENT_ID_JUICE_STRAWBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_STRAWBERRY)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_STRAWBERRY
			reagentcolor = "#FA5053"
		if(REAGENT_JUICE_BLACKBERRY)
			generated_reagents = list(REAGENT_ID_JUICE_BLACKBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_BLACKBERRY)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_BLACKBERRY
			reagentcolor = "#272C3F"
		if(REAGENT_JUICE_RASPBERRY)
			generated_reagents = list(REAGENT_ID_JUICE_RASPBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_RASPBERRY)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_RASPBERRY
			reagentcolor = "#A01600"
		if(REAGENT_JUICE_PEAR)
			generated_reagents = list(REAGENT_ID_JUICE_PEAR = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_PEAR)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_PEAR
			reagentcolor = "#D2B48C"
		if(REAGENT_JUICE_LEMON)
			generated_reagents = list(REAGENT_ID_JUICE_LEMON = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_LEMON)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_LEMON
			reagentcolor = "#FFFF00"
		if(REAGENT_JUICE_LIME)
			generated_reagents = list(REAGENT_ID_JUICE_LIME = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_LIME)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_LIME
			reagentcolor = "#00FF00"
		if(REAGENT_JUICE_TANGERINE)
			generated_reagents = list(REAGENT_ID_JUICE_TANGERINE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_TANGERINE)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_TANGERINE
			reagentcolor = "#FFA500"
		if(REAGENT_JUICE_PLUM)
			generated_reagents = list(REAGENT_ID_JUICE_PLUM = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_PLUM)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_PLUM
			reagentcolor = "#8B008B"
		if(REAGENT_JUICE_CARROT)
			generated_reagents = list(REAGENT_ID_JUICE_CARROT = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_JUICE_CARROT)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_JUICE_CARROT
			reagentcolor = "#ed9121"
		if(REAGENT_ALCOHOL_BEER)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BEER = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BEER)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_BEER
			reagentcolor = "#a17c10"
		if(REAGENT_ALCOHOL_RUM)
			generated_reagents = list(REAGENT_ID_ALCOHOL_RUM = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_RUM)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_RUM
			reagentcolor = "#5f3b23"
		if(REAGENT_ALCOHOL_CIDER_APPLE)
			generated_reagents = list(REAGENT_ID_ALCOHOL_CIDER_APPLE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_CIDER_APPLE)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_CIDER_APPLE
			reagentcolor = "#6aa945"
		if(REAGENT_ALCOHOL_CIDER_PEAR)
			generated_reagents = list(REAGENT_ID_ALCOHOL_CIDER_PEAR = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_CIDER_PEAR)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_CIDER_PEAR
			reagentcolor = "#fffc6c"
		if(REAGENT_ALCOHOL_CIDER_STRAWBERRY)
			generated_reagents = list(REAGENT_ID_ALCOHOL_CIDER_STRAWBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_CIDER_STRAWBERRY)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_CIDER_STRAWBERRY
			reagentcolor = "#da4d4d"
		if(REAGENT_ALCOHOL_BRANDY_APPLE)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BRANDY_APPLE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BRANDY_APPLE)
			gen_amount = 1
			gen_cost = 8
			reagentid = REAGENT_ALCOHOL_BRANDY_APPLE
			reagentcolor = "#6aa945"
		if(REAGENT_ALCOHOL_BRANDY_PEAR)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BRANDY_PEAR = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BRANDY_PEAR)
			gen_amount = 1
			gen_cost = 8
			reagentid = REAGENT_ALCOHOL_BRANDY_PEAR
			reagentcolor = "#b9b607"
		if(REAGENT_ALCOHOL_BRANDY_STRAWBERRY)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BRANDY_STRAWBERRY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BRANDY_STRAWBERRY)
			gen_amount = 1
			gen_cost = 8
			reagentid = REAGENT_ALCOHOL_BRANDY_STRAWBERRY
			reagentcolor = "#bb1a1a"
		if(REAGENT_ALCOHOL_BRANDY_TANGERINE)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BRANDY_TANGERINE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BRANDY_TANGERINE)
			gen_amount = 1
			gen_cost = 8
			reagentid = REAGENT_ALCOHOL_BRANDY_TANGERINE
			reagentcolor = "#bb751a"
		if(REAGENT_ALCOHOL_BRANDY_PLUM)
			generated_reagents = list(REAGENT_ID_ALCOHOL_BRANDY_PLUM = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_BRANDY_PLUM)
			gen_amount = 1
			gen_cost = 8
			reagentid = REAGENT_ALCOHOL_BRANDY_PLUM
			reagentcolor = "#5c0449"
		if(REAGENT_ALCOHOL_WINE)
			generated_reagents = list(REAGENT_ID_ALCOHOL_WINE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_WINE)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_WINE
			reagentcolor = "#8a0b0b"
		if(REAGENT_ALCOHOL_ALE)
			generated_reagents = list(REAGENT_ID_ALCOHOL_ALE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_ALCOHOL_ALE)
			gen_amount = 1
			gen_cost = 6
			reagentid = REAGENT_ALCOHOL_ALE
			reagentcolor = "#664300"
		if(REAGENT_WATER_DIRTY)
			generated_reagents = list(REAGENT_ID_WATER_DIRTY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_DIRTY)
			gen_amount = 1
			gen_cost = 60
			reagentid = REAGENT_WATER_DIRTY
			reagentcolor = "#98934bc6"
		if(REAGENT_WATER_SEWAGE)
			generated_reagents = list(REAGENT_ID_WATER_SEWAGE = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER_SEWAGE)
			gen_amount = 1
			gen_cost = 100
			reagentid = REAGENT_WATER_SEWAGE
			reagentcolor = "#98934bc6"
		if(REAGENT_TAINTED_BLOOD)
			generated_reagents = list(REAGENT_ID_TAINTED_BLOOD = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TAINTED_BLOOD)
			gen_amount = 1
			gen_cost = 150
			reagentid = REAGENT_TAINTED_BLOOD
			reagentcolor = "#941010"
