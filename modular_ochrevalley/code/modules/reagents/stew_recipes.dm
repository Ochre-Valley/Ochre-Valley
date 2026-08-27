#define STEW_COOKING_TIME 30 SECONDS
/datum/container_craft/cooking/minttea
	name = "Mint Tea"
	wildcard_requirements = list(/obj/item/alch/mentha = 1)
	created_reagent = /datum/reagent/water/bufftea/minttea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/wormwoodtea
	name = "Wormwood Tea"
	wildcard_requirements = list(/obj/item/alch/artemisia = 1)
	created_reagent = /datum/reagent/water/wormwoodtea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/sagetea
	name = "Sage Tea"
	wildcard_requirements = list(/obj/item/alch/salvia = 1)
	created_reagent = /datum/reagent/water/sagetea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/valeriantea
	name = "Valerian Tea"
	wildcard_requirements = list(/obj/item/alch/valeriana = 1)
	created_reagent = /datum/reagent/water/valeriantea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/baothatea
	name = "Baothan Tea"
	wildcard_requirements = list(/obj/item/alch/atropa = 1)
	created_reagent = /datum/reagent/water/baothatea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/eyebrighttea
	name = "Euphrasia Tea"
	wildcard_requirements = list(/obj/item/alch/euphrasia = 1)
	created_reagent = /datum/reagent/water/bufftea/eyebrighttea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/bloomtea
	name = "Bloom Tea"
	wildcard_requirements = list(/obj/item/alch/manabloompowder = 1)
	created_reagent = /datum/reagent/consumable/caffeine/bloomtea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/eorantea
	name = "Eoran Tea"
	wildcard_requirements = list(/obj/item/alch/calendula = 1)
	created_reagent = /datum/reagent/water/eorantea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/psytea
	name = "Pilgrim Tea"
	wildcard_requirements = list(/obj/item/alch/benedictus = 1)
	created_reagent = /datum/reagent/water/bufftea/psytea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/dandelioncoffee
	name = "Dandelion Coffee"
	wildcard_requirements = list(/obj/item/alch/taraxacum = 1)
	created_reagent = /datum/reagent/water/bufftea/dandelioncoffee
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/nettletea
	name = "Nettle Tea"
	wildcard_requirements = list(/obj/item/alch/urtica = 1)
	created_reagent = /datum/reagent/water/nettletea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/chamomiletea
	name = "Chamomile Tea"
	wildcard_requirements = list(/obj/item/alch/matricaria = 1)
	created_reagent = /datum/reagent/water/chamomiletea
	crafting_time = STEW_COOKING_TIME

//Blend recipes
/datum/container_craft/cooking/raneshenbitters
	name = "Raneshen Bitter Tea"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/raneshenbitters = 1)
	created_reagent = /datum/reagent/consumable/caffeine/raneshenbitter
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/eoragrace
	name = "Eora's Grace"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/eoragrace = 1)
	created_reagent = /datum/reagent/water/eorasgracetea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/eoralovefake
	name = "Faked Eora's Love"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/eoralovefake = 1)
	created_reagent = /datum/reagent/water/eorasloveteafake
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/eoralove
	name = "Eora's Love"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/eoralove = 1)
	created_reagent = /datum/reagent/water/eorasloveteatrue
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/ravoxcalm
	name = "Ravox's Calm"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/ravoxcalm = 1)
	created_reagent = /datum/reagent/consumable/caffeine/ravoxtea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/mocha
	name = "Sand Coffee"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/mocha = 1)
	created_reagent = /datum/reagent/consumable/caffeine/mocha
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/gerevine
	name = "Gerevine Brew"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/gerevine = 1)
	created_reagent = /datum/reagent/water/gerevine
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/schorle
	name = "Apfelschorle"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/schorle = 1)
	created_reagent = /datum/reagent/consumable/caffeine/schorle
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/baothablend
	name = "Void's Embrace"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/baothablend = 1)
	created_reagent = /datum/reagent/water/boathablend
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/forgottenlove
	name = "Tea of Sisters"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/forgottenlove = 1)
	created_reagent = /datum/reagent/water/forgottenlove
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/chai
	name = "Chai"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/chai = 1)
	created_reagent = /datum/reagent/consumable/caffeine/chai
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/volfmilk
	name = "Vargmjölk"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/volfmilk = 1)
	created_reagent = /datum/reagent/water/volfmilk
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/frukkte
	name = "Fruktte"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/frukkte = 1)
	created_reagent = /datum/reagent/water/icetea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/barleytea
	name = "Barley Tea"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/barleytea = 1)
	created_reagent = /datum/reagent/water/barleytea
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/kvass
	name = "Kvass"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/kvass = 1)
	created_reagent = /datum/reagent/water/kvass
	crafting_time = STEW_COOKING_TIME

/datum/container_craft/cooking/avantare
	name = "Avantare"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/avantare = 1)
	created_reagent = /datum/reagent/water/avantare
	crafting_time = STEW_COOKING_TIME

#undef STEW_COOKING_TIME

