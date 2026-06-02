
/* TEMPLATE
//ckey:Character Name
*/

//ChildSoldierOpportunist:Joey Larkens
/datum/loadout_item/ochre_fluff/childsoldieropportunist_wedding_band
	name = "Larkens Family Ring"
	path = /obj/item/clothing/ring/band/paalloy/childsoldieropportunist_wedding_band
	ckeywhitelist = list("childsoldieropportunist", "tigercat2000") // allow wedding partner to also retrieve it

/obj/item/clothing/ring/band/paalloy/childsoldieropportunist_wedding_band
	name = "Larkens Family Ring"
	desc = "A simple ancient band of gilbranze, decorated with the waxing and waning of the moon. The full moon is represented by a smoothly polished purple amethyst. The ring is surrounded in a faint purple glow of enchantment. Inside the ring, there is an engraving: \"My Bunny Forever.\""

/obj/item/clothing/ring/band/paalloy/childsoldieropportunist_wedding_band/Initialize()
	. = ..()
	add_filter("fluff", 2, list("type" = "outline", "color" = "#800080", "alpha" = 120, "size" = 1))

/obj/item/clothing/ring/band/paalloy/childsoldieropportunist_wedding_band/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	// automatically reapply marriage when equipped by correct person
	if(istype(user) && user.ckey == "childsoldieropportunist" && !user.marriedto)
		user.marriedto = "Nyx Larkens"

//tigercat2000:Nyx Larkens
/datum/loadout_item/ochre_fluff/tigercat2000_wedding_band
	name = "Bunny Ring"
	path = /obj/item/clothing/ring/band/tigercat2000_wedding_band
	ckeywhitelist = list("tigercat2000", "childsoldieropportunist") // allow wedding partner to also retrieve it

/obj/item/clothing/ring/band/tigercat2000_wedding_band
	name = "Bunny Ring"
	desc = "A band of silver, decorated with an alternating pattern. The first pattern is the waxing and waning of the moon; the second pattern interleaved between each cycle of the moon is filled with rabbit motifs; grass, carrots, and little bunny faces. The full moon is represented by a smoothly polished aquamarine. The ring is surrounded in a faint diamond blue glow of enchantment. Inside the ring, there is an engraving: \"No book can contain my love for you.\""

/obj/item/clothing/ring/band/tigercat2000_wedding_band/Initialize()
	. = ..()
	add_filter("fluff", 2, list("type" = "outline", "color" = "#4cdbe5", "alpha" = 120, "size" = 1))

/obj/item/clothing/ring/band/tigercat2000_wedding_band/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	// automatically reapply marriage when equipped by correct person
	if(istype(user) && user.ckey == "tigercat2000" && !user.marriedto)
		user.marriedto = "Joey Larkens"
