// OV File

/datum/anvil_recipe/engineering/arquebus
	name = "Arquebus (+1 steel, +1 gear, +1 wood)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/steel, /obj/item/roguegear, /obj/item/grown/log/tree/small)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus
	craftdiff = 5

/datum/anvil_recipe/engineering/blunderbuss
	name = "Blunderbuss (+1 iron, +1 gear, +1 wood)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/iron, /obj/item/roguegear, /obj/item/grown/log/tree/small)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/blunderbuss
	craftdiff = 5

/datum/anvil_recipe/engineering/pistol
    name = "Arquebus Pistol (+1 iron, +1 gear, +1 wood)"
    req_bar = /obj/item/ingot/bronze
    additional_items = list(/obj/item/ingot/iron, /obj/item/roguegear, /obj/item/grown/log/tree/small)
    created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
    craftdiff = 5

/datum/anvil_recipe/engineering/bronze/mech_shotkit
	name = "Mechanized Shot Kit (+1 Gear, +1 Powder-and-Shot Kit))"
	category = "Engineering"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear, /obj/item/quiver/bulletpouch/powderkit)
	created_item = /obj/item/quiver/mechanized/shotkit
	createditem_num = 1
	craftdiff = 4
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/engineering/bronze/mech_shotkit
	name = "Mechanized Shot Kit, Hip-Slung (Only holds pistols) (+1 Gear, +1 Powder-and-Shot Kit))"
	created_item = /obj/item/quiver/mechanized/shotkit/hip

/datum/anvil_recipe/engineering/leadbullets
	name = "Firearm Bullets (x6)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet
	createditem_num = 6
	craftdiff = 2

/datum/anvil_recipe/engineering/leadbullets/silver
	name = "Silver Firearm Bullets (x6)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet/silver
	craftdiff = 4

/datum/anvil_recipe/engineering/leadbullets/bronze
	name = "Runed Firearm Bullets (x12)"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet/bronze
	createditem_num = 12
	craftdiff = 4

/datum/anvil_recipe/engineering/leadbullets/scatter
	name = "Firearm Scattershot (x6) (+1 Cloth)"
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/iron
	additional_items = list(/obj/item/natural/cloth)
	craftdiff = 3

/datum/anvil_recipe/engineering/leadbullets/steel
	name = "Firearm Bullets (x18)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet
	createditem_num = 18
	craftdiff = 2

/datum/anvil_recipe/engineering/leadbullets/steel/scatter
	name = "Firearm Scattershot (x18) (+3 Cloth)"
	created_item = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/iron
	additional_items = list(/obj/item/natural/cloth, /obj/item/natural/cloth, /obj/item/natural/cloth)
	craftdiff = 3
