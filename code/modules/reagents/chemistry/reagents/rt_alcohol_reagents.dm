// Just store all of the alcohol reagents that isn't base tg here
/datum/reagent/consumable/ethanol/beer
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_ALE
	name = "beer"
	description = "Civilization in a cup. Could you truly ask for anything more?"
	color = "#a17c10" // rgb: 102, 67, 0
	nutriment_factor = 0.1
	boozepwr = 25
	taste_description = "frothy ale"
	glass_name = "glass of beer"
	glass_desc = ""

/datum/reagent/consumable/ethanol/rum
	cuisine = CUISINE_RANESHENI
	drink_type = DRINKTYPE_SPIRIT
	name = "rum"
	description = "Where has the rum gone?"
	color = "#5f3b23" // rgb: 102, 67, 0
	boozepwr = 40
	taste_description = "tingling sweetness with hints of caramel and vanilla"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/whiskey
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "whiskey"
	description = "Ah, whiskey. Can it get any more local than this?"
	color = "#D59A6F"
	boozepwr = 60
	taste_description = "subtly sweet, woody spice and a lingering burn"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/fyreball
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "fyreball"
	description = "A bold, brave or stupid take on whiskey, using the nectar of fyritius flowers and other spices to give the brew a kick that some argue it never needed."
	color = "#e6813a"
	boozepwr = 80 // Probably bad for you, and not because of this, either.
	taste_description = "well defined oaky-sweet, warmth, with a quickly ebbing intense sting"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/fyreball/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/fyreball)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		M.adjustToxLoss(0.2, 0)
	else
		M.adjustFireLoss(1, 0) // Spicy boy
	..()
	. = 1

/datum/reagent/consumable/ethanol/fyreball/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/fyreball)

/datum/reagent/consumable/ethanol/fyrmenty
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_SPIRIT
	name = "fyrmenty"
	description = "An exotic herbal grain alcohol. It seems to retain the warmth of the fyritius, but lacks the hostile burn. Good for sleeping away a harsh winter night. Very, very flammable."
	color = "#e4a171"
	boozepwr = 100 // This shit is basically everclear, and very small amounts can be made at a time.
	taste_description = "a light sweetness, quickly overwhelmed by warmth and an inability to taste"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/cider
	cuisine = CUISINE_OTAVAIS|CUISINE_ETRUSCAN
	drink_type = DRINKTYPE_CIDER
	name = "apple cider"
	description = "Humenkind always had a knack of looking at any fruit and grain to make alcoholic drink from. This cider is no different."//OV Edit
	boozepwr = 40
	taste_description = "crisp freshness of apple"
	glass_name = "glass of cider"
	color = "#6aa945"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/cider/pear
	name = "pear cider"
	boozepwr = 40
	taste_description = "sweet subtle delights of pear"
	glass_name = "glass of pear cider"
	color = "#fffc6c"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/cider/strawberry
	name = "strawberry cider"
	boozepwr = 40
	taste_description = "a subtle hint of strawberry sweetness"
	color = "#da4d4d"
	taste_description = "strawberry cider"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/aqua_vitae
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "aqua vitae"
	description = "Water of lyfe, lyfe of fire. Drink and yours shall expand away from your mortal flesh."//OV Edit
	boozepwr = 150
	taste_description = "death"
	color = "#6e6e6e"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/brandy
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "apple brandy"
	description = "The ochards of the Celestial Academy of Grenzelhoft is the reputed origin of the apple brandy as alcohol. Nobody can really say otherwise."//OV Edit
	boozepwr = 60
	taste_description = "caramel oak brandy"
	glass_name = "glass of brandy"
	color = "#6aa945"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/pear
	name = "pear brandy"
	description = "Once decried as pale imitation of apple brandy and outlawed by many Grenzel princedoms, a recent imperial decree legalised it after visiting Otava for a tense negotiation that has been saved by a bottle of this stuff."//OV Edit
	boozepwr = 60
	taste_description = "ripe pear with a hint of spice"
	color = "#b9b607"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/strawberry
	name = "strawberry brandy"
	description = "Rossan elves have popularized this after Tovans traded in a huge surplus of delectably sweet forest strawberries. Now the production of it ties the two tribes together."//OV Edit
	boozepwr = 60
	taste_description = "overwhelming sweetness with a smooth finish"
	color = "#bb1a1a"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/tangerine
	name = "tangerine brandy"
	description = "Etruscans don't want you to know, but you can just make your own Limoncello."//OV Edit
	boozepwr = 60
	taste_description = "spice and a twist of citrus"
	color = "#bb751a"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/plum
	name = "plum brandy"
	description = "Once, a Kazengun emissary got into a fistfight with the Inquisition as they served him this as Umeshu. After the brawl subsided, he praised the inventiveness and departed with a keg of plum brandy."//OV Edit
	boozepwr = 60
	taste_description = "purple sweetness and vanilla"
	color = "#5c0449"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/wine
	cuisine = CUISINE_ETRUSCAN
	drink_type = DRINKTYPE_WINE
	name = "wine"
	description = "A young wine of uncertain origin. Likely cut with jackberries, the peasant's grape."//OV Edit
	boozepwr = 30
	taste_description = "aromatic bitterness with notes of sweetly-fermented jackberries"
	glass_name = "glass of wine"
	color = "#8a0b0b"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/light
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "light beer"
	description = "Since Pre-SYON, Humenkind has brewed beer. Sadly, this batch is weakened and watery."//OV Edit
	boozepwr = 5 //Space Europeans hate it
	taste_description = "dish water"
	glass_name = "glass of light beer"
	glass_desc = ""

/datum/reagent/consumable/ethanol/green
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "green beer"
	description = "Since Pre-SYON, Humenkind has brewed beer. Some Dendorite has dyed it green. For reasons."//OV Edit
	color = "#A8E61D"
	taste_description = "green piss water"
	glass_icon_state = "greenbeerglass"
	glass_name = "glass of green beer"
	glass_desc = ""

/datum/reagent/consumable/ethanol/green/on_mob_life(mob/living/carbon/M)
	if(M.color != color)
		M.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)
	return ..()

/datum/reagent/consumable/ethanol/green/on_mob_end_metabolize(mob/living/M)
	M.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/ale
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_ALE
	name = "ale"
	description = "A dark alcoholic beverage made with malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	taste_description = "hearty barley ale"
	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = ""


// BEERS - Imported for now, later the styles will be 'mockable', if and when I get to brewing.

// Humen Production - Underwhelming, but cheap.

/datum/reagent/consumable/ethanol/zagul
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "Zagul Brew"
	description = "Zagul is known for two things. It's cheap price and its potence. There is nothing nice to be said about it otherwise."//OV Edit
	boozepwr = 15
	taste_description = "cheap pisswater"
	color = "#DBD77F"

/datum/reagent/consumable/ethanol/gin
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "gin"
	description = "Grain spirits have been flavoured with tart berries of the North of Grenzelhoft. An acquired taste. A sailor's taste. Cheap, though."//OV Edit
	boozepwr = 65
	taste_description = "strong, piney flavor"
	color = "#809978"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/spottedhen
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "Spotted Hen"
	description = "Spotted Hen beer is reputed in Zenitstadt for disappearing people who say their beer is shit. Keep your mouth shut or Doppelsoldners will pay you a visit."//OV Edit
	boozepwr = 15
	taste_description = "cheap pisswater"
	color = "#DBD77F"

/datum/reagent/consumable/ethanol/hagwoodbitter
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_ALE
	name = "Hagwood Bitter"
	description = "It's rumoured that Zornite brewers fund secessionist movements. This be just rumours. Buy some more."//OV Edit
	boozepwr = 25
	taste_description = "dull crispness"
	color = "#BBB525"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/blackgoat
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_ALE
	name = "Black Gote Kriek"
	description = "Sailors of Grenzelhoft swear on the Black Gote to get them going in the morning. It's to no surprise why."//OV Edit
	boozepwr = 25
	taste_description = "overwhelming sourness"
	color = "#401806"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/onion
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "onion cognac"
	description = "A surprisingly wholesome, spicy drink fashioned out of the humble root vegetable, the onion."//OV Edit
	boozepwr = 10
	taste_description = "spicy sweet malty overtones"
	color = "#683e00"
	quality = DRINK_NICE

// Elf Production - LEAF-LOVERS MOTHERFUCKER

/datum/reagent/consumable/ethanol/aurorian
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_WINE
	name = "Aurorian"
	description = "A light beer brewed by Tovan breweries, more an experiment than anything else, relying on various herbs instead of hops."//OV Edit
	boozepwr = 5
	taste_description = "subtle herbaceous undertones"
	color = "#5D8A8A"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/fireleaf // cabbbage
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_WINE
	name = "Fireleaf"
	description = "Oooh, fireleaf. Who truly loves you? The desperate, the foolish, and Azurians."//OV Edit
	boozepwr = 2
	taste_description = "awful liquor"
	color = "#475e45"
	quality = DRINK_NICE

// Dwarven Production - Best in the Realms!

/datum/reagent/consumable/ethanol/butterhairs
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_ALE
	description = "Besides their silver rapiers, Hammerholdian witch-hunters popularized this beer. Mostly because they kept asking for it."//OV Edit
	name = "Butterhairs"
	boozepwr = 30
	taste_description = "buttery richness"
	color = "#5D8A8A"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/stonebeards
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_ALE
	name = "Stonebeard Reserve"
	description = "It has been said clans have fought bitter feuds over a spilled cup of this legendary brew."//OV Edit
	boozepwr = 40
	taste_description = "potent oatlike liquor"
	color = "#5D8A8A"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/voddena // Definitely Actually Just Vodka Now.
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_SPIRIT
	name = "Voddena"
	description = "First it was made to preserve grain over yils. Now it is made to persevere through conversations with Reformist Freifechters."//OV Edit
	boozepwr = 40	// now it's just vodka
	taste_description = "clean liquor"
	color = "#a1a1a1"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/sazdistal // Definitely Not Vodka.
	cuisine = CUISINE_RANESHENI
	drink_type = DRINKTYPE_SPIRIT
	name = "Saz Distal"
	description = "Stoutenson promises anyone who can drink a bottle of this and not become stonecold drunk a refund. Nobody ever claimed this refund."//OV Edit
	boozepwr = 55	// holy shit
	taste_description = "spicy chilis, ginger, and dirt"
	color = "#2D1D1D"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/limoncello
	cuisine = CUISINE_ETRUSCAN
	drink_type = DRINKTYPE_SPIRIT
	name = "Limoncello"
	description = "A common apperetif and digestive aid by Estrucans, there are a myriad of homebrew versions. This? This is the real deal."//OV Edit
	boozepwr = 45	// holy shit
	taste_description = "burning and lemony"
	color = "#d2da63"
	quality = DRINK_GOOD

// Generic Rice
/datum/reagent/consumable/ethanol/ricewine
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "Both Avar and Kazengun have a tradition of rice wines. Were there more contact between these two peoples, they would probably fight over who makes the better kind."//OV Edit
	name = "rice wine"
	taste_description = "floral sweetness with a subtle umami taste."
	color = "#F5E6C4" // rgb: 210, 218, 99
	boozepwr = 30
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/ricespirit
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "Distilled down into its essence, the humble rice grain becomes a potent warrior, with precise and clean strength to knock you off your feet."//OV Edit
	name = "rice spirit"
	taste_description = "clean heat and dry finish."
	color = "#F8FDFC" // rgb: 210, 218, 99
	boozepwr = 55
	quality = DRINK_NICE

// WINE - Fancy.

// Humen Production - Grape Based

/datum/reagent/consumable/ethanol/sourwine // Peasant grade shit.
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "sour wine"
	description = "Landsknecht companies often sour their wine with apple cider vinegar to keep it fresh. It's a mark of veterancy to drink this without making a face."//OV Edit
	boozepwr = 20
	taste_description = "sour wine"
	color = "#552b4b"

/datum/reagent/consumable/ethanol/whitewine
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "white wine"
	description = "Lesser known, but beloved, especially in the early autumn months where Otavais vineyards sell still-fermenting wine to the commonfolk."//OV Edit
	boozepwr = 30
	taste_description = "sweet white wine"
	color = "#F3ED91"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/redwine
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "red wine"
	description = "Grenzelhoftians and Azurians both cannot think of anyone else but Otavans when they see red wine. A stigma - or sophistication?"//OV Edit
	boozepwr = 30
	taste_description = "tannin-stricken wine"
	color = "#571111"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/jackberrywine
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	description = "Decried as wine for serfs, even nobles enjoy a good glass of well-made Jacque."//OV Edit
	name = "jacksberried wine"
	boozepwr = 15
	taste_description = "sickly sweet young wine"
	color = "#3b2342"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/jackberrywine/aged
	name = "aged jacksberried wine"
	boozepwr = 30
	taste_description = "sweet aged wine"
	color = "#402249"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/jackberrywine/delectable
	name = "delectable jacksberried wine"
	boozepwr = 30
	taste_description = "sweet delectably aged wine"
	color = "#652679"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/plum_wine
	cuisine = CUISINE_OTAVAIS|CUISINE_ETRUSCAN
	drink_type = DRINKTYPE_WINE
	name = "umeshu"
	description = "While not the true Umeshu of the East, Otavais and Etruscan markets produce this imitation, as plums grow well in their climates."//OV Edit
	boozepwr = 15
	taste_description = "sickly sour young wine"
	color = "#c997d8"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/plum_wine/aged
	name = "aged umeshu"
	boozepwr = 30
	taste_description = "sweet slightly sour aged wine"
	color = "#c27cd8"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/plum_wine/delectable
	name = "delectable umeshu"
	boozepwr = 30
	taste_description = "delectably aged sour sweet wine"
	color = "#a854c2"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/tangerine
	cuisine = CUISINE_OTAVAIS|CUISINE_ETRUSCAN
	drink_type = DRINKTYPE_WINE
	name = "tangerine wine"
	description = "Etruscans are famed for their citrus fruit cultivation on the Island Miralago. This wine comes close to their production vintages."//OV Edit
	boozepwr = 15
	taste_description = "bittersweet, citrusy young wine"
	color = "#e7aa59"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/tangerine/aged
	name = "aged tangerine wine"
	boozepwr = 30
	taste_description = "bittersweet, citrusy aged wine"
	color = "#d68d2d"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/tangerine/delectable
	name = "delectable tangerine wine"
	boozepwr = 30
	taste_description = "bittersweet, citrusy delectably aged wine"
	color = "#eb9321"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/raspberry
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "raspberry wine"
	description = "Just to confuse foreigners, Otavans call raspberry wine and a far stronger raspberry liquer Chambord."//OV Edit
	boozepwr = 15
	taste_description = "tart sweet young wine"
	color = "#ee5ea6"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/raspberry/aged
	name = "aged raspberry wine"
	boozepwr = 30
	taste_description = "tart sweet aged wine"
	color = "#d83788"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/raspberry/delectable
	name = "delectable raspberry wine"
	boozepwr = 30
	taste_description = "tart sweet delectably aged wine"
	color = "#db0d74"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/blackberry
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "blackberry wine"
	description = "A favoured drink of the eastern Arwiners and Otavan drow, blackberry wine is an acquired taste for everyone else."//OV Edit
	boozepwr = 15
	taste_description = "bitter tart young wine"
	color = "#861491"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/blackberry/aged
	name = "aged blackberry wine"
	boozepwr = 30
	taste_description = "bitter tart aged wine"
	color = "#58065f"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/blackberry/delectable
	name = "delectable blackberry wine"
	boozepwr = 30
	taste_description = "bitter tart delectably aged wine"
	color = "#330038"
	quality = DRINK_VERYGOOD

// Special Production - Spice, Spice, Baby!

/datum/reagent/consumable/ethanol/spicedwine
	cuisine = CUISINE_RANESHENI
	drink_type = DRINKTYPE_WINE
	name = "spiced wine"
	description = "Originally a drink of Raneshen, this kind of wine has found its niche during Nocmas celebrations for its warming properties."//OV Edit
	boozepwr = 10
	taste_description = "overpoweringly aromatic, sweetening the tongue and numbing the lips"
	color = "#a11a00"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/spicedwine/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.2	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.2	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/spicedwine/aged
	name = "aged spiced wine"
	boozepwr = 20
	taste_description = "richly aromatic spiciness, evoking the memory of a holidae's snow-speckled nite"
	color = "#961800"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/spicedwine/aged/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.4	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.4	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/spicedwine/delectable
	name = "delectable spiced wine"
	boozepwr = 40
	taste_description = "heavenly aromatic sweetness, followed by an ever-familiar warmness in the heart"
	color = "#821500"
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/ethanol/spicedwine/delectable/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.7	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.7	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/cider/ambrosia
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "Ambrosia"
	boozepwr = 100 //Strong Lifeblood, in essence, that'll also leave you completely sloshed. In jubilation, of course!
	taste_description = "divine bliss with hints of appled crispness, followed by what feels like a greatmaul to the forehead"
	color = "#FFD700"
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/ethanol/cider/ambrosia/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+20, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(4)
	if(volume > 0.99)
		M.adjustBruteLoss(-5	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-5	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-5	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -5 * REAGENTS_EFFECT_MULTIPLIER)
	..()

/datum/reagent/consumable/ethanol/cider/ambrosia
	cuisine = CUISINE_SOUTH_IMPERIAL

// Elf Production - Berries & Herbal

/datum/reagent/consumable/ethanol/elfred
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_WINE
	name = "Elven Red"
	description = "Elven Red is famous for its sweetness and ease of drinking it. While not strictly in drow hands anymore, it's still marketed as Mer product."//OV Edit
	boozepwr = 15
	taste_description = "delectable fruity notes"
	color = "#6C0000"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/elfblue
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_WINE
	description = "It is said it was only after Valmora has produced her first bottle of wine after she retired was she sainted by the Orthodoxy. Figures."//OV Edit
	name = "Valmora Blue"
	boozepwr = 50
	taste_description = "saintly sweetness"
	color = "#2C9DAF"
	quality = DRINK_FANTASTIC

// Azure Drinks
/datum/reagent/consumable/ethanol/jagdtrunk // JÄGERMEISTER!!!!
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_SPIRIT
	name = "Jagdtrunk"
	description = "A proprietary blend of many herbs and spices, this liquor is drunk as digestiv by Grenzelhoftan nobility, from the border princes to the Kaiser himself."//OV Edit
	boozepwr = 55	// gotta be stronk
	taste_description = "spicy herbal remedy"
	color = "#331f18"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/apfelweinheim
	cuisine = CUISINE_NORTH_IMPERIAL
	drink_type = DRINKTYPE_CIDER
	description = "Apfelweinheim is famed for its crisp, tart apples, but its cider has reached acclaim by the addition of the humbler pear to mellow out the acidity."//OV Edit
	name = "Appelheimer"
	boozepwr = 45
	taste_description = "tart crispness and mellow sweetness"
	color = "#e0cb55"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/rtoper
	drink_type = DRINKTYPE_SPIRIT
	name = "Lirvas Toper"
	description = "Extremely sour. Like any coinslave when you tell them that you do not know what a portfolio is."//OV Edit
	boozepwr = 40
	taste_description = "overwhelming tartness"
	color = "#e0a400"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/nred
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_WINE
	name = "Norwardine Red"
	description = "Gronnite spirits fashioned with Hammerholdian techniques. It would be an insult, were they not faithfully applying the learned skills."//OV Edit
	boozepwr = 30
	taste_description = "heavy caramel note and slight bitterness"
	color = "#543633"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/gronnmead
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_MEAD
	name = "Ragnar's Brew"
	description = "While honey-wine isn't unknown to the western continent, The Iskan people have a special talent of weaving nectar to spirit..."//OV Edit
	boozepwr = 35
	taste_description = "notes of honey and red berries" //I love red mead ok...
	color = "#772C48"
	quality = DRINK_GOOD

//Avar boozes

/datum/reagent/consumable/ethanol/avarmead
	drink_type = DRINKTYPE_MEAD
	name = "Zögiin bal"
	description = "It was after a failed Gronnite raid that steppemen from the northern border figured they can make their own mead. Their version is oddly spicy, from the heath flowers."//OV Edit
	boozepwr = 30
	taste_description = "spicy honey"
	color = "#e0a400"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/avarrice
	drink_type = DRINKTYPE_RICEWINE
	name = "Makkolir"
	description = "A rice wine from the coasts and lake regions of Avar. Don't ask a steppeman who made it first, you will hear the same answer all the time."//OV Edit
	boozepwr = 30
	taste_description = "tangy sweetness"
	color = "#ddcbc9"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/saigamilk //No way, kumys from avar!!!
	name = "Bökhiin Arkhi"
	description = "The nomadic peoples of Avar figured there must be a way to preserve their favoured mount's milk. Many foreigners claim they're still looking for one."//OV Edit
	boozepwr = 15
	taste_description = "bubbly saltiness with a sour aftertaste"
	color = "#dddddd"
	quality = DRINK_NICE

//Kazengun boozes

/datum/reagent/consumable/ethanol/kgunlager
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_ALE
	name = "Yamaguchi Pale"
	description = "Kazengun usually does not brew beer, and wanted to distinguish themselves by adding a local flavour with green tea. Their success is in the eye of the beholder."//OV Edit
	boozepwr = 10 //A PALE imitation actual beer...
	taste_description = "mellow bitterness and a hint of green tea"
	color = "#d7dbbc"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/kgunsake
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	name = "Junmai-ginjo"
	description = "And so we struck, naginatas raised high - we are the Lords of this land, by conquest and by strength. The Sun Goddess smiles upon our success."//OV Edit
	boozepwr = 50
	taste_description = "dry sweetness"
	color = "#ccd7e0"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/kgunshochu
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "To deny a man his Shochu is a grave insult. This is a warrior's drink. A right by blade. To deny a man his Shochu is a declaration of emnity."//OV Edit
	name = "Shochu"
	boozepwr = 60
	taste_description = "dry, clean finish"
	color = "#F8FDFC"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/kgunplum
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_WINE
	description = "Beloved by commoners and jealously guarded, this drink is exported with gusto to show Westerners how to make proper plum wine."//OV Edit
	name = "Umeshu"
	boozepwr = 30
	taste_description = "a mix of sweet and sour"
	color = "#ddb99b"
	quality = DRINK_GOOD

// Lingyuese
/datum/reagent/consumable/ethanol/huangjiu
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "Lingyuese prefers milder, sweeter rice wines and many households have their own, little spins on it. This one is export-made, however."//OV Edit
	name = "Huangjiu"
	boozepwr = 30
	taste_description = "a mix of sweet and sour"
	color = "#d8b84c"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/baijiu
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "Originally made because Huangjiu doesn't travel well in traditional vessels, Baijiu has become a show of bravery for its spiciness and waking properties."//OV Edit
	name = "Baijiu"
	boozepwr = 60
	taste_description = "fiery and pungent alcohol with a hint of sweetness"
	color = "#f8fdfc"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/yaojiu
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	description = "Drink a cup for dropsy, gout, the shivers, bone-eating disease, the common cold, unbalanced humours, or when too many Kazengunite vixens visited your bedchambers."//OV Edit
	name = "Yaojiu"
	boozepwr = 50
	taste_description = "bittersweet alcohol with deep herbal notes"
	color = "#8C4B1F"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/shejiu
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	name = "Shejiu"
	description = "Although western medicine prefers enlightened arts of cutting someone open to improve circulation, Lingyuese prefer to drink this spirit instead."//OV Edit
	boozepwr = 50
	taste_description = "musky and strong alcohol with a hint of gameiness"
	color = "#C49A6C"
	quality = DRINK_VERYGOOD

// Mead
/datum/reagent/consumable/ethanol/mead
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_MEAD
	name = "mead"
	description = "A warriors drink, though a cheap one."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "sweet, sweet alcohol"
	glass_icon_state = "meadglass"
	glass_name = "Mead"
	glass_desc = ""

/datum/reagent/consumable/ethanol/mead/spider
	color = "#660061"

// Special Drugs
/datum/reagent/consumable/ethanol/murkwine // not Toilet wine
	name = "Mürkwine"
	description = "Yes, this looks drinkable, from a particular point of view. It's a liquid, alright." //OV Edit
	boozepwr = 50	// bubba's best
	taste_description = "hints of questionable choices--a bouqet of murkwater and pure ethanol"
	color = "#4b1e00"

/datum/reagent/consumable/ethanol/murkwine/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/murkwine)
	M.stamina_add(0.1)
	..()
	. = 1

/datum/reagent/consumable/ethanol/murkwine/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/murkwine)

/datum/reagent/consumable/ethanol/nocshine // wait, no, NOCSHINE
	drink_type = DRINKTYPE_SPIRIT
	name = "Noc's Shine"
	description = "How ironic that Noc's Wisdom has led to this, the distillation of bad choices."//OV Edit
	boozepwr = 70	// YEEEEEHAAAWWWWWW
	taste_description = "what might be my throat melting and nose hair burning"
	color = "#d8fbfd63"
	quality = DRINK_NICE


/datum/reagent/consumable/ethanol/nocshine/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/nocshine)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		M.adjustToxLoss(0.1, 0)
	else
		M.adjustToxLoss(0.75, 0)
	..()
	. = 1

/datum/reagent/consumable/ethanol/nocshine/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/nocshine)

/datum/reagent/consumable/ethanol/nocmash
	name = "Noc Mash"
	description = "A raw, grain-fortified distillate. Must be distilled with swampweed before it becomes the notorious Noc's Shine."
	boozepwr = 55
	taste_description = "undiluted alcohol with a faint hint of wheat"
	color = "#b8d4d6"

/datum/reagent/consumable/ethanol/luxwine // oh no.
	drink_type = DRINKTYPE_WINE
	name = "Luxintenebre" // lux left w/ sugar in a darkened place for quite some time... U could say... Light in Darkness.....
	description = "A fermented form of vitae, highly alcoholic, and with a particularly grim taste. Often sought out by the daring, foolhardy, and heretical..."
	boozepwr = 80 // THE END OF THE FUCKING WORLD.
	taste_description = "a green numbness, then a burning vigor in the heart" // heartburn (healing)
	color = "#86cca3"
	quality = DRINK_VERYGOOD // good stuff!

/datum/reagent/consumable/ethanol/luxwine/on_mob_life(mob/living/carbon/M) // stolen healthpot code. i am shameless.
	if(volume > 0.99) // i have no clue if this works.
		M.adjustBruteLoss(-1	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-1	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/ethanol/whipwine // dont ask
	name = "Magickal Whip Wine"
	description = "A recipe recently floated into the Peaks. Magickal Whip Wine is said to increase one's potence and stamina sevenfold."
	boozepwr = 10 // it's a whip. it's an actual whip.
	taste_description = "leather, bitter herbs, and regret" // what did you expect
	color = "#3a1d18"

/datum/reagent/consumable/ethanol/truewhipwine
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_RICEWINE
	name = "Divine Snake Wine"
	description = "The True Form of the Whipwine. A medicinal rice wine from the Lingyuese highlands, steeped for years with a coiled venomous serpent and a secret cocktail of mountain herbs. Said to restore the vigor of even the most spent of men."
	boozepwr = 60
	taste_description = "deep herbal warmth, iron, and a slow-burning fire that climbs the spine"
	color = "#553837"
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/ethanol/truewhipwine/on_mob_metabolize(mob/living/M)
	. = ..()
	M.apply_status_effect(/datum/status_effect/buff/fermented_crab)

//New Alcoholic mixes.

/datum/reagent/consumable/ethanol/bloodymary
	cuisine = CUISINE_RANESHENI
	drink_type = DRINKTYPE_CIDER
	name = "Bloody Mary"
	description = "Possibly the only way blood can be palatable for the normal non-graggarite. How moral it is to drink? Still questionable."
	color = "#570000"
	quality = DRINK_FANTASTIC
	boozepwr = 30
	taste_description = "a bit of tang, a little citrus, and a little.. iron."
	metabolization_rate = 1 * REAGENTS_METABOLISM
	overdose_threshold = null
	hydration_factor = 15

/datum/chemical_reaction/alch/bloodymary
	name = "Bloody Mary"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/ethanol/bloodymary
	results = list(/datum/reagent/consumable/ethanol/bloodymary = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol/voddena = 1, /datum/reagent/consumable/juice/tomato = 1, /datum/reagent/consumable/juice/lime = 1, /datum/reagent/blood = 1)

/datum/reagent/consumable/ethanol/eoras_favour
	cuisine = CUISINE_RANESHENI
	drink_type = DRINKTYPE_CIDER
	name = "Eora's Favour"
	description = "The most romantic and refreshing mix of cider and pomegranate, fresh from Eora's trees."
	color = "#FF5799"
	quality = DRINK_FANTASTIC
	boozepwr = 30
	taste_description = "a refreshing and viscous sweet and tart mix."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null
	hydration_factor = 15

/datum/chemical_reaction/alch/efavour
	name = "Eora's Favour"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/ethanol/eoras_favour
	results = list(/datum/reagent/consumable/ethanol/eoras_favour = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/cider = 1, /datum/reagent/consumable/juice/pomegranate = 1)

/datum/reagent/consumable/ethanol/dendors_favour
	cuisine = CUISINE_SOUTHEASTERN
	drink_type = DRINKTYPE_CIDER
	name = "Dendor's Favour"
	description = "A very natural and very alcoholic mixture for a blessing from Dendor instead of a curse."
	color = "#628C58"
	quality = DRINK_FANTASTIC
	boozepwr = 40
	taste_description = "sweet taste of nature."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null
	hydration_factor = 15

/datum/chemical_reaction/alch/dfavour
	name = "Dendor's Favour"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/ethanol/dendors_favour
	results = list(/datum/reagent/consumable/ethanol/dendors_favour = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/cider/pear = 1, /datum/reagent/consumable/ethanol/aurorian = 1)

/datum/reagent/consumable/ethanol/blackberry_sangria
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "Sangria D'Otavais"
	description = "A refreshingly sweet and tart blackberry mixture, screams Otavan. This alcohol is practically a dessert."
	color = "#2E2047"
	quality = DRINK_FANTASTIC
	boozepwr = 40
	taste_description = "slightly tart sweetness."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null

/datum/chemical_reaction/alch/bsangria
	name = "Sangria D'Otavais"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/ethanol/blackberry_sangria
	results = list(/datum/reagent/consumable/ethanol/blackberry_sangria = 2)
	required_reagents = list(/datum/reagent/consumable/juice/blackberry = 1, /datum/reagent/consumable/ethanol/blackberry = 1)

/datum/reagent/consumable/ethanol/xylix_spice
	cuisine = CUISINE_OTAVAIS
	drink_type = DRINKTYPE_WINE
	name = "Spice of Xylix"
	description = "A gamble to your senses, this drink is harsh and definitely an acquired taste."
	color = "#EBBD1C"
	quality = DRINK_FANTASTIC
	boozepwr = 40
	taste_description = "Spicy and acidic shock."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null

/datum/chemical_reaction/alch/xylix_spice
	name = "Spice of Xylix"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/ethanol/xylix_spice
	results = list(/datum/reagent/consumable/ethanol/xylix_spice = 2)
	required_reagents = list(/datum/reagent/consumable/juice/orange = 1, /datum/reagent/consumable/ethanol/sazdistal = 1, /datum/reagent/consumable/allspice = 1)
