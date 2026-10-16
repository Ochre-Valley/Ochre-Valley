/datum/map_template/remote_sanctuary
	var/sanctuary_id
	/// Description used in the shop to describe this shelter's contents
	var/description
	/// Text used in the shop UI just beneath the sanctuary's title. Keep it brief and flavorful as this will be put on the sanctuary's select button.
	var/subtitle
	/// Cost in mammons to purchase this remote sanctuary from the shop.
	///
	/// Owning a private sanctuary, even if it's not a good one, is a VERY luxurious opportunity, so keep them pricy!
	var/price = 500
	/// List of lines that the KEYMASTER will randomly yell upon purchasing this sanctuary.
	///
	/// The town KEYMASTER speaks in a vaguely Shakespearean manner, ALWAYS yells in allcaps outside of very rare circumstances, and exclusively refers to buyers as "DISCERNER".
	var/list/purchase_lines = list(
		"A LAND FOR THEE, DISCERNER!!",
		"THY LAND ART PREPARED, DISCERNER! COME AND MEET THY DESTINY!!",
		"DISCERNER, I PRONOUNCE THEE KEY AND SPOUSE!! HAVE THY HONEYMOON IN THY NEWLY PURCHASED LAND!!",
	)
	/// Alternative list of lines that the KEYMASTER in the wretch coast will randomly say upon purchasing this sanctuary.
	///
	/// The wretch KEYMASTER is more informal, does not ever yell, but still speaks in allcaps. It also likes to be a bit mean to everyone, including buyers.
	///
	/// Also, keep in mind when writing lines that most if not all lands purchased at the wretch KEYMASTER are sanctuaries that have been sneakily hijacked by the shady (and intentionally nondescript) organization that the wretch KEYMASTER serves for the purpose of being resold. It'll sometimes bluntly mention how easy or tough it was to "reclaim" a sanctuary.
	var/list/purchase_lines_wretch = list(
		"FOR YOU, A LAND \"RECLAIMED\".",
		"ANOTHER LAND PURCHASED. IT TOOK US A WHILE TO TAKE THIS LAND FROM THEM WITHOUT THEM NOTICING. MAKE GOOD USE OF IT.",
		"YOU WANT *ANOTHER* HIDEOUT? THIS ONE YOU'RE IN NOW ISN'T GOOD ENOUGH FOR YOU? GREEDY, GREEDY... ALRIGHT, HERE'S YOUR KEY.",
	)

/datum/map_template/remote_sanctuary/cozy_homestead
	name = "Mountain Cabin"
	sanctuary_id = "cozy_homestead"
	description = "A quiet little cabin for two to share along the northern mountains of Grenzelhoft neighboring Ochre Valley. Sparkling mountain waters streaming down from above bear errant fish perfect for catching. For resources that cannot be easily sourced by the land, a vomitorium has been placed on the bottom floor of the cabin."
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/15x15x2/cozy_homestead.dmm"
	purchase_lines = list(
		"A FINE CHOICE, DISCERNER! THE VIEWS WITHIN OCHRE VALLEY ART TO DIE FOR!!",
		"THOU HATH CHOSEN WELL, DISCERNER! THIS ONE IS FAR AWAY FROM THE RUSTWOODS, I PROMISE!!",
		"A MOST VAST AND ROTUND LAND AWAITS THEE, DISCERNER!!"
	)
	subtitle = "Close to the clouds do we forge our home..."

/datum/map_template/remote_sanctuary/shitty_cave
	name = "Barren Cave"
	sanctuary_id = "shitty_cave"
	price = 400
	description = "One of the many recently discovered caves along the distant mountains. Barely any accommodations whatsoever, but with decent natural resources at one's disposal, an industrious owner could turn it into something special... with some effort."
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/15x15x2/shitty_cave.dmm"
	purchase_lines = list(
		"A MOST PROSPECTIVE CHOICE HATH THOU MADE, DISCERNER!! I WISH THEE GOOD FORTUNE IN YONDER MINES!!",
		"ENJOY THY NEWLY ACQUIRED LAND, DISCERNER!! THE WALLS IN YONDER CAVE ART RICH IN RESOURCES!!",
		"A BOUNTIFUL UNTAPPED LAND AWAITS THEE, DISCERNER!!",
		"A SPOOKY CHOICE, DISCERNER!! THE NOISES I OFT HEAR FROM YONDER CAVE GIVE ME THE WILLIES!!",
	)
	purchase_lines_wretch = list(
		"HAHAH, REALLY? YOU BOUGHT A CAVE AS YOUR CHOICE OF LAND? ALRIGHT, IT'S YOUR MAMMON. TAKE YOUR KEY.",
		"ANOTHER LAND PURCHASED. THIS ONE WAS ACTUALLY PRETTY EASY FOR US TO TAKE FROM THEM. PROBABLY WHY IT'S AS CHEAP AS IT IS... COMPARED TO THE OTHERS, ANYWAY.",
	)
	subtitle = "For the luxuriously industrious..."

/datum/map_template/remote_sanctuary/kazengun_retreat
	name = "Kazengun Retreat"
	sanctuary_id = "kazengun_retreat"
	price = 600 // This one is PARTICULARLY extravagant so it's a bit more pricey
	description = "Azurian architects consulted with the builders of Kazengun for direction while constructing this unique home next to a natural hot spring bubbling at the side of one of the local mountainsides. Comes with a kitchen, vomitorium, two bedrooms, and of course hot spring that dominates its exterior."
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/15x15x2/kazengun_retreat.dmm"
	purchase_lines = list(
		"A FINE AND TASTEFUL CHOICE, DISCERNER!! RELAXING SPRING WATERS AWAIT THEE!!",
		"IF I KNEW BUT A SINGLE WORD OF KAZENGUNESE, DISCERNER, I WOULDST SPEAK IT NOW TO CONGRATULATE THEE ON THY EXCELLENT PURCHASE!!",
		"AN EXCELLENT CHOICE, DISCERNER!! I WISH THE STEAM FROM THE HOT SPRINGS THERE DIDN'T FOG UP MINE ORB SO I COULD SEE IT BETTER!!",
	)
	purchase_lines_wretch = list(
		"THANKS FOR YOUR PATRONAGE. YOU'D BETTER NOT GET THIS ONE TOO MESSY; I LIKE THIS ONE. NOT LIKE I COULD STOP YOU ANYWAY.",
		"A SLICE OF KAZENGUN, JUST FOR YOU, HUH? QUITE THE SPLURGE... TAKE YOUR KEY",
	)
	subtitle = "Fine homes far awae replicated with Azurian flair..."

/datum/map_template/remote_sanctuary/arena
	name = "Arena"
	sanctuary_id = "fight_zone"
	description = "By the demand of eccentric and wealthy Ravoxians, private arenas have been constructed, and this is one of them. A small colosseum, complete with a small kitchen and vomitorium, as well as some basic accommodations for an infirmary, as well as a couple viewpoints for spectators."
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/15x15x2/fight_zone.dmm"
	purchase_lines = list(
		"GLORY AND HONOR AWAIT THEE IN THY NEWLY PURCHASED LAND, DISCERNER!!",
		"A SPECTACULAR PURCHASE, DISCERNER! I LOVE THE CONCESSIONS STAND OVER YONDER! I LOVE PRETENDING I CAN EAT THEIR GRENZELBUNS!!",
		"REMEMBER TO BATTLE RESPONSIBLY IN THY NEWLY PURCHASED LAND, DISCERNER! PRITHEE, REMEMBER TO YIELD IN DUELS! I BEG OF THEE, PLEASE PLEASE PLEASE!!",
	)
	purchase_lines_wretch = list(
		"THANKS FOR YOUR PATRONAGE. THIS ONE WAS SURPRISINGLY EASY FOR US TO TAKE FROM THEM. TOOK FOREVER TO WASH THE VISCERA OFF MY ORB THERE AFTER THEIR LITTLE \"DUEL.\"",
	)
	subtitle = "Honor. Glory. And Grenzelbuns on the side..."

/datum/map_template/remote_sanctuary/gambling_cave
	name = "Renovated Gambling Den"
	sanctuary_id = "gambling_cave"
	price = 700
	description = "Bandits, raiders, assassins, and criminals alike are oft known for building secret domiciles hidden from Astrata's inquisitorial gaze. Some such places grow in such popularity amongst heretics and criminals that they are given surprisingly impressive accommodations for what their ultimate purpose was. This used to be one of them. The heretical symbols have been rent from the walls, the unholy iconography peeled away so finely that one could never tell they were ever there, the traps removed, all threats cleaned and cleared out. These halls, once dedicated to Evyl, have since been entirely renovated and put to greater use: private use by the Tennites its original architects conspired against. What greater way to demoralize the worshipers of the Inhumen, after all, than to not merely destroy their hiding places, but comb away their original intents so finely that no trace of their deeds could be found by even the sharpest of eyes?"
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/15x15x2/gambling_cave.dmm"
	purchase_lines = list(
		"EXCELLENT TASTES, DISCERNER! I LOVE THIS ONE!! I CANST NOT. UM. SEE IN THERE BECAUSE THEY PUT MINE STAND IN THE CAVERN OUTSIDE. BUT IT, UM... SOUNDS FUN IN THERE, AT LEAST!!",
		"XYLIX SMILES UPON THY PURCHASE, DISCERNER!! USE THE LUCKY XYLIX'S FORTUNE IN THERE, I HATH HEARD IT WINS MORE OFTEN!!", // This is a lie btw but they don't need to know that
		"LET'S GO GAMBLING, DISCERNER!!",
	)
	purchase_lines_wretch = list(
		"HAHAHAHAH... GOOD PURCHASE. YOU READ THAT DESCRIPTION TOO, RIGHT? GODS, THE IRONY IS RICH, ISN'T IT?",
		"THANKS FOR YOUR PATRONAGE. THE BEST PART ABOUT THIS ONE IS THAT THEY STILL DON'T KNOW ABOUT OUR LITTLE \"RECLAMATION\" OF IT.",
	)
	subtitle = "The Laughing God reclaims its blessed games..."

/datum/map_template/remote_sanctuary/naledi_home
	name = "Naledi House of Hearth"
	sanctuary_id = "naledi_home"
	// This one is comically luxurious AND is in a very unique location.
	// It's also nicer than some noble houses. It NEEDS to be expensive as fuck.
	price = 1000
	description = "Far, far to the south, the grassy plains, mountains, and valleys with which we are familiar give way to a sea of sands bathed in the purest rays of both Astrata and Noc every dae and nite. Much of these lands are inhospitable and dangerous in their own right, but to its people, the dunes of Naledi are home.\n\
	\n\
	And what a home have they made it! Extravagant and colorful is the make of their homes and decor, for their access to exceedingly vast sources of gold has created a uniquely lavish style of decorating their households. In collaboration with land owners in the oasis towns of Naledi has this home been prepared for the discerning prospective home-owner. A kitchen stocked with silverware of gold, a lavish bathroom, two bedrooms, a study, a living and dining room, a garden - this place truly has it all, and more."
	mappath = "_maps/ochre_valley/templates/remote_sanctuary/20x20x2/naledi_home.dmm"
	purchase_lines = list(
		"OOH, I LOVE THIS PLACE, DISCERNER!! GOLD EVERYWHERE!! I WISH THEY MADE MINE STAND OVER THERE OUT OF GOLD, TOO!!",
		"THY BOUNTIFUL COIN SHALT BE WELL-SPENT, DISCERNER!! I LOVE HOW COLORFUL AND BRIGHT NALEDI HOMES ARE!!",
		"A FINE HOME THOU SHALT HAVE, WEALTHY DISCERNER, FOR PARADISE AWAITS!!",
		"A WONDROUS CHOICE, DISCERNER!! ALSO. Uh. I-if a sandstorm kicks up... prithee, put on one of the masks over yonder. The Naledians leave those out to help protect visitors from the, um... Dj-Djinn the storms oft bring.",
	)
	purchase_lines_wretch = list(
		"... GREAT GOOGLY MOOGLY, YOU ACTUALLY HAD THE COIN FOR THAT ONE? I UH, GOT NOTHING. I'M ACTUALLY IMPRESSED. TAKE YOUR KEY.",
		"GOOD PURCHASE. BE GLAD NO NALEDIAN OFFICIALS YET KNOW ABOUT OUR HIJACKING OF THEIR LITTLE \"COLLABORATION\". IT'S A GOOD THING THEY'RE SO... TRUSTING, ISN'T IT?",
		"THANKS FOR YOUR PATRONAGE. IF A SANDSTORM KICKS UP OVER THERE, PUT ON ONE OF THE MASKS YOU'LL FIND ON THE TABLE THERE. I DON'T RECOMMEND THAT TO KEEP THE SAND OUT OF YOUR MOUTH; NO, IT'S TO KEEP THE ONCOMING DJINN OUT."
	)
	subtitle = "Rest thy weary mind for but a mote, REPENTER..."
