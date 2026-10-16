/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre
	resistance_flags = FIRE_PROOF
	unenchantable = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	blocking_behavior = SAMEWEAR

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin
	blocksound = SOFTUNDERHIT
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin/fullbody
	body_parts_covered = COVERAGE_FULL_BODY_ACTUAL
	body_parts_inherent = COVERAGE_FULL_BODY_ACTUAL

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/chestskin
	blocksound = SOFTHIT //has to be different from the other skin's blocksound for them to layer.
	body_parts_covered = COVERAGE_VEST
	body_parts_inherent = COVERAGE_VEST


//bailiff skin options (equal to a heavy gambeson + leather armor)
/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin/bailiff
	name = "scar-marred skin"
	desc = "Bearing scars of countless whips leaves a gnarly visage. Now it's your time to inflict the same fate upon others."
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/chestskin/bailiff
	name = "scar-marred chest"
	desc = "Bearing scars of countless whips leaves a gnarly visage. Now it's your time to inflict the same fate upon others."
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER


//baseline wildsoul skin (used by mantis) - 125% of a leather armor, with a backup gambeson on chest.
/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin/fullbody/wildsoul
	name = "natural armour"
	desc = "The natural body of this person protects them from some amount of harm."
	armor_class = ARMOR_CLASS_NONE //needs this due to being locked out of armor.
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_ELITE //1.25x hardened leather armor.

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/chestskin/wildsoul
	name = "natural chest armour"
	desc = "The natural body of this person protects them from some amount of harm, particularly to the chest."
	armor_class = ARMOR_CLASS_NONE
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //a chest-only heavy gambeson.


//heavy wildsoul skin - 150% of a leather armor (but plate), with a backup light brig on chest.
/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin/fullbody/wildsoul/heavy
	name = "dense natural armour"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/chestskin/wildsoul/heavy
	name = "dense natural chest armour"
	armor = ARMOR_BRIGANDINE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE - ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER //Light brig


//Warden wildsoul skin - a heavy gambeson + light brigadine, simple since they get layering.
/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/overskin/fullbody/wildsoul/tame
	name = "warden's natural armour"
	armor_class = ARMOR_CLASS_LIGHT //can be set back since these can use armor.
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //A heavy gambeson for the body.

/obj/item/clothing/suit/roguetown/armor/manual/resting/ochre/chestskin/wildsoul/tame
	name = "warden's natural chest armour"
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_BRIGANDINE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE - ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER //Light brig.
