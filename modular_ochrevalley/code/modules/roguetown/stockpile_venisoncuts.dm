//Venison cuts so hunters can stockpile them and let other people purchase the cuts without direct purchasing.
//Also includes boar meat at Oben's suggestion.

/datum/roguestock/stockpile/deerribs
	name = "Venison Ribs"
	desc = "Luxuriously edible flesh on-the-bone harvested from saiga."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 8
	withdraw_price = 16
	category = "Animal"

/datum/roguestock/stockpile/deerloins
	name = "Venison Loins"
	desc = "Luxuriously edible loin-flesh harvested from saiga."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 8
	withdraw_price = 16
	category = "Animal"

/datum/roguestock/stockpile/deerprime
	name = "Venison Prime Cuts"
	desc = "Decadently edible prime cuts of flesh harvested from saiga."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 8
	withdraw_price = 16
	category = "Animal"

/datum/roguestock/stockpile/boarham
	name = "Boar Ham"
	desc = "Delicious flesh carved from a wild boar, perfect for smoking or steaming."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar
	trade_good_id = TRADE_GOOD_PORK
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 8
	withdraw_price = 16
	category = "Animal"
