// OV File
/datum/anvil_recipe/engineering/arquebus
	name = "Arquebus (+1 bronze, +1 cog, +1 wood)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/roguegear, /obj/item/grown/log/tree/small) //Expensive!
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus
	craftdiff = 5

/datum/anvil_recipe/engineering/pistol
    name = "Arquebus Pistol (+1 cog, +1 wood)"
    req_bar = /obj/item/ingot/bronze
    additional_items = list(/obj/item/roguegear, /obj/item/grown/log/tree/small) //A little cheaper!
    created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
    craftdiff = 5
