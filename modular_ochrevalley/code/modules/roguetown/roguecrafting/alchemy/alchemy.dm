/datum/crafting_recipe/roguetown/survival/hemosnack_poor
	name = "bloody slop"
	structurecraft = /obj/structure/table
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/poor = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /datum/reagent/water = 30, /obj/item/alch/viscera = 2, /obj/item/reagent_containers/powder/salt = 1)
	craftdiff = 0	//made on a table by the desperate

/datum/crafting_recipe/roguetown/alchemy/hemosnack_mid
	name = "alchemical vitae"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/mid = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /datum/reagent/medicine/healthpot = 30, /obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2, /obj/item/alch/puresalt = 1)
	craftdiff = 2	//made at an alchemy table by the knowing

/datum/crafting_recipe/roguetown/alchemy/hemosnack_good
	name = "bloodwine stew"
	category = "Table"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/hemosnack/good = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /datum/reagent/consumable/ethanol/jackberrywine = 30, /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal = 2, /obj/item/alch/puresalt = 1)
	craftdiff = 4	//made on an alchemy table by the experts
