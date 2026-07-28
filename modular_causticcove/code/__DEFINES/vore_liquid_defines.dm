//
// -- Lactation Defines --
//	- Similarly check out belly_obj_liquid_choices.dm to fully add more reagents
//

// Basic Reagents
#define REAGENT_WATER "Water"
#define REAGENT_ID_WATER /datum/reagent/water
#define REAGENT_WATER_BATH "Bathwater"
#define REAGENT_ID_WATER_BATH /datum/reagent/water/bathwater
#define REAGENT_WATER_SALT "Saltwater"
#define REAGENT_ID_WATER_SALT /datum/reagent/water/salty
#define REAGENT_WATER_HOLY "Holy Water"
#define REAGENT_ID_WATER_HOLY /datum/reagent/water/holywater
#define REAGENT_WATER_UNHOLY "Unholy Water"
#define REAGENT_ID_WATER_UNHOLY /datum/reagent/fuel/unholywater
#define REAGENT_MILK "Milk"
#define REAGENT_ID_MILK /datum/reagent/consumable/milk
#define REAGENT_COFFEE "Coffee"
#define REAGENT_ID_COFFEE /datum/reagent/consumable/caffeine/coffee
#define REAGENT_TEA "Tea"
#define REAGENT_ID_TEA /datum/reagent/consumable/caffeine/tea
#define REAGENT_TEA_ROSE "Rose Tea"
#define REAGENT_ID_TEA_ROSE /datum/reagent/consumable/rosewater
#define REAGENT_TEA_CALENDULA "Golden Calendula Tea"
#define REAGENT_ID_TEA_CALENDULA /datum/reagent/consumable/golden_calendula_tea
#define REAGENT_TEA_VALERIAN "Soothing Valerian Tea"
#define REAGENT_ID_TEA_VALERIAN /datum/reagent/consumable/soothing_valerian_tea
#define REAGENT_HONEY "Honey"
#define REAGENT_ID_HONEY /datum/reagent/consumable/honey

// Meds and Toxins!
#define REAGENT_PARAPOISON "Paralytic venom"
#define REAGENT_ID_PARAPOISON /datum/reagent/toxin/spidervenom_paralytic
#define REAGENT_SPACEDRUGS "Druggy venom"
#define REAGENT_ID_SPACEDRUGS /datum/reagent/drug/space_drugs
#define REAGENT_POT_MANA "Mana potion"
#define REAGENT_ID_POT_MANA /datum/reagent/medicine/manapot
#define REAGENT_POT_HEALTH "Health potion"
#define REAGENT_ID_POT_HEALTH /datum/reagent/medicine/healthpot
#define REAGENT_POT_POPPY "Poppy Milk"
#define REAGENT_ID_POT_POPPY /datum/reagent/consumable/poppy_milk

// Juices!
#define REAGENT_JUICE_JACKBERRY "Jackberry juice"
#define REAGENT_ID_JUICE_JACKBERRY /datum/reagent/consumable/juice/jackberry
#define REAGENT_JUICE_JACKBERRY_POISON "Poisonous Jackberry juice"
#define REAGENT_ID_JUICE_JACKBERRY_POISON /datum/reagent/consumable/juice/jackberry/poisonous
#define REAGENT_JUICE_APPLE "Apple juice"
#define REAGENT_ID_JUICE_APPLE /datum/reagent/consumeable/juice/apple
#define REAGENT_JUICE_TOMATO "Tomato juice"
#define REAGENT_ID_JUICE_TOMATO /datum/reagent/consumable/juice/tomato
#define REAGENT_JUICE_STRAWBERRY "Strawberry juice"
#define REAGENT_ID_JUICE_STRAWBERRY /datum/reagent/consumable/juice/strawberry
#define REAGENT_JUICE_BLACKBERRY "Blackberry juice"
#define REAGENT_ID_JUICE_BLACKBERRY /datum/reagent/consumable/juice/blackberry
#define REAGENT_JUICE_RASPBERRY "Raspberry juice"
#define REAGENT_ID_JUICE_RASPBERRY /datum/reagent/consumable/juice/raspberry
#define REAGENT_JUICE_PEAR "Pear juice"
#define REAGENT_ID_JUICE_PEAR /datum/reagent/consumable/juice/pear
#define REAGENT_JUICE_LEMON "Lemon juice"
#define REAGENT_ID_JUICE_LEMON /datum/reagent/consumable/juice/lemon
#define REAGENT_JUICE_LIME "Lime juice"
#define REAGENT_ID_JUICE_LIME /datum/reagent/consumable/juice/lime
#define REAGENT_JUICE_TANGERINE "Tangerine juice"
#define REAGENT_ID_JUICE_TANGERINE /datum/reagent/consumable/juice/tangerine
#define REAGENT_JUICE_PLUM "Plum juice"
#define REAGENT_ID_JUICE_PLUM /datum/reagent/consumable/juice/plum
#define REAGENT_JUICE_CARROT "Carrot juice"
#define REAGENT_ID_JUICE_CARROT /datum/reagent/consumable/juice/carrot

// Alcohols! Mostly just the craftable ones for now. There's a lot... rt_alcohol_reagends.dm
#define REAGENT_ALCOHOL_BEER "Beer"
#define REAGENT_ID_ALCOHOL_BEER /datum/reagent/consumable/ethanol/beer
#define REAGENT_ALCOHOL_RUM "Rum"
#define REAGENT_ID_ALCOHOL_RUM /datum/reagent/consumable/ethanol/rum
#define REAGENT_ALCOHOL_CIDER_APPLE "Apple Cider"
#define REAGENT_ID_ALCOHOL_CIDER_APPLE /datum/reagent/consumable/ethanol/cider
#define REAGENT_ALCOHOL_CIDER_PEAR "Pear Cider"
#define REAGENT_ID_ALCOHOL_CIDER_PEAR /datum/reagent/consumable/ethanol/cider/pear
#define REAGENT_ALCOHOL_CIDER_STRAWBERRY "Strawberry Cider"
#define REAGENT_ID_ALCOHOL_CIDER_STRAWBERRY /datum/reagent/consumable/ethanol/cider/strawberry
#define REAGENT_ALCOHOL_BRANDY_APPLE "Apple Brandy"
#define REAGENT_ID_ALCOHOL_BRANDY_APPLE /datum/reagent/consumable/ethanol/brandy
#define REAGENT_ALCOHOL_BRANDY_PEAR "Pear Brandy"
#define REAGENT_ID_ALCOHOL_BRANDY_PEAR /datum/reagent/consumable/ethanol/brandy/pear
#define REAGENT_ALCOHOL_BRANDY_STRAWBERRY "Strawberry Brandy"
#define REAGENT_ID_ALCOHOL_BRANDY_STRAWBERRY /datum/reagent/consumable/ethanol/brandy/strawberry
#define REAGENT_ALCOHOL_BRANDY_TANGERINE "Tangerine Brandy"
#define REAGENT_ID_ALCOHOL_BRANDY_TANGERINE /datum/reagent/consumable/ethanol/brandy/tangerine
#define REAGENT_ALCOHOL_BRANDY_PLUM "Plum Brandy"
#define REAGENT_ID_ALCOHOL_BRANDY_PLUM /datum/reagent/consumable/ethanol/brandy/plum
#define REAGENT_ALCOHOL_WINE "Wine"
#define REAGENT_ID_ALCOHOL_WINE /datum/reagent/consumable/ethanol/wine
#define REAGENT_ALCOHOL_ALE "Ale"
#define REAGENT_ID_ALCOHOL_ALE /datum/reagent/consumable/ethanol/ale

// Dear god why?
#define REAGENT_WATER_DIRTY "Tainted Water"
#define REAGENT_ID_WATER_DIRTY /datum/reagent/water/gross
#define REAGENT_WATER_SEWAGE "Sewage"
#define REAGENT_ID_WATER_SEWAGE /datum/reagent/water/gross/sewage
#define REAGENT_TAINTED_BLOOD "Tainted Blood"
#define REAGENT_ID_TAINTED_BLOOD /datum/reagent/blood/shitty

//Potentially old and leftover stuff from Chompers below
#define REAGENT_CHOCOLATEMILK  "Chocolate Milk"
#define REAGENT_ID_CHOCOLATEMILK "chocolate_milk"
#define REAGENT_CREAM "Cream"
#define REAGENT_ID_CREAM "cream"
#define REAGENT_ICETEA "Iced Tea"
#define REAGENT_ID_ICETEA "icetea"
#define REAGENT_MINTTEA "Mint Tea"
#define REAGENT_ID_MINTTEA "minttea"
#define REAGENT_LEMONTEA "Lemon Tea"
#define REAGENT_ID_LEMONTEA "lemontea"
#define REAGENT_LIMETEA "Lime Tea"
#define REAGENT_ID_LIMETEA "limetea"
#define REAGENT_ORANGETEA "Orange Tea"
#define REAGENT_ID_ORANGETEA "orangetea"
#define REAGENT_BERRYTEA "Berry Tea"
#define REAGENT_ID_BERRYTEA "berrytea"
#define REAGENT_GREENTEA "Green Tea"
#define REAGENT_ID_GREENTEA "greentea"
#define REAGENT_CHAITEA "Chai Tea"
#define REAGENT_ID_CHAITEA "chaitea"
#define REAGENT_CAFELATTE "Cafe Latte"
#define REAGENT_ID_CAFELATTE "cafe_latte"
#define REAGENT_HOTCOCO "Hot Chocolate"
#define REAGENT_ID_HOTCOCO "hot_coco"
#define REAGENT_ALE "Ale"
#define REAGENT_ID_ALE "ale"
#define REAGENT_BEER "Beer"
#define REAGENT_ID_BEER "beer"

#define REAGENT_STOMACID "Digestive acid"
#define REAGENT_ID_STOMACID "stomacid"
#define REAGENT_DIETSTOMACID "Diluted digestive acid"
#define REAGENT_ID_DIETSTOMACID "diet_stomacid"

#define REAGENT_NUMBENZYME "Numbing Enzyme"
#define REAGENT_ID_NUMBENZYME "numbenzyme"
