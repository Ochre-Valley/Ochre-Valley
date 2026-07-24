#define RESIZE_MINIMUM 0.25 //OV EDIT
#define RESIZE_STANDARD 1
#define RESIZE_MAXIMUM 2 //OV EDIT
#define RESIZE_MINIMUM_DORMS 0.01
#define RESIZE_MAXIMUM_DORMS 6

#define RESIZE_HUGE 2
#define RESIZE_BIG 1.5
#define RESIZE_NORMAL 1
#define RESIZE_SMALL 0.5
#define RESIZE_TINY 0.25
#define RESIZE_A_HUGEBIG (RESIZE_HUGE + RESIZE_BIG) / 2
#define RESIZE_A_BIGNORMAL (RESIZE_BIG + RESIZE_NORMAL) / 2
#define RESIZE_A_NORMALSMALL (RESIZE_NORMAL + RESIZE_SMALL) / 2
#define RESIZE_A_SMALLTINY (RESIZE_SMALL + RESIZE_TINY) / 2

//stores numeric player size options indexed by name
GLOBAL_LIST_INIT(player_sizes_list, list(
		"Macro" 	= RESIZE_HUGE,
		"Big" 		= RESIZE_BIG,
		"Normal" 	= RESIZE_NORMAL,
		"Small" 	= RESIZE_SMALL,
		"Tiny" 		= RESIZE_TINY))

//Blacklist to exclude items from object ingestion. Digestion blacklist located in digest_act_vr.dm
GLOBAL_LIST_INIT(item_vore_blacklist, list())

//Classic Vore sounds
GLOBAL_LIST_INIT(classic_vore_sounds, list(
		"Gulp" = 'modular_causticcove/sound/cvore/vore/gulp.ogg',
		"Insert" = 'modular_causticcove/sound/cvore/vore/insert.ogg',
		"Insertion1" = 'modular_causticcove/sound/cvore/vore/insertion1.ogg',
		"Insertion2" = 'modular_causticcove/sound/cvore/vore/insertion2.ogg',
		"Insertion3" = 'modular_causticcove/sound/cvore/vore/insertion3.ogg',
		"Schlorp" = 'modular_causticcove/sound/cvore/vore/schlorp.ogg',
		"Squish1" = 'modular_causticcove/sound/cvore/vore/squish1.ogg',
		"Squish2" = 'modular_causticcove/sound/cvore/vore/squish2.ogg',
		"Squish3" = 'modular_causticcove/sound/cvore/vore/squish3.ogg',
		"Squish4" = 'modular_causticcove/sound/cvore/vore/squish4.ogg',
		"Rustle (cloth)" = 'modular_causticcove/sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'modular_causticcove/sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'modular_causticcove/sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'modular_causticcove/sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'modular_causticcove/sound/effects/rustle5.ogg',
		"Zipper" = 'modular_causticcove/sound/effects/zip.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(classic_release_sounds, list(
		"Rustle (cloth)" = 'modular_causticcove/sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'modular_causticcove/sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'modular_causticcove/sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'modular_causticcove/sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'modular_causticcove/sound/effects/rustle5.ogg',
		"Zipper" = 'modular_causticcove/sound/effects/zip.ogg',
		"Splatter" = 'modular_causticcove/sound/effects/splat.ogg',
		"None" = null
		))

//Poojy's Fancy Sounds
GLOBAL_LIST_INIT(fancy_vore_sounds, list(
		"Gulp" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/swallow_01.ogg',
		"Swallow" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/swallow_02.ogg',
		"Insertion1" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/insertion_01.ogg',
		"Insertion2" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/insertion_02.ogg',
		"Tauric Swallow" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/taurswallow.ogg',
		"Stomach Move"		= 'modular_causticcove/sound/cvore/vore/sunesound/pred/stomachmove.ogg',
		"Schlorp" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/schlorp.ogg',
		"Squish1" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/squish_01.ogg',
		"Squish2" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/squish_02.ogg',
		"Squish3" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/squish_03.ogg',
		"Squish4" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/squish_04.ogg',
		"Rustle (cloth)" = 'modular_causticcove/sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'modular_causticcove/sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'modular_causticcove/sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'modular_causticcove/sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'modular_causticcove/sound/effects/rustle5.ogg',
		"Zipper" = 'modular_causticcove/sound/effects/zip.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(fancy_release_sounds, list(
		"Rustle (cloth)" = 'modular_causticcove/sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'modular_causticcove/sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'modular_causticcove/sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'modular_causticcove/sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'modular_causticcove/sound/effects/rustle5.ogg',
		"Zipper" ='modular_causticcove/sound/effects/zip.ogg',
		"Stomach Move" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/stomachmove.ogg',
		"Pred Escape" = 'modular_causticcove/sound/cvore/vore/sunesound/pred/escape.ogg',
		"Splatter" = 'modular_causticcove/sound/effects/splat.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(global_vore_egg_types, list(
	"Unathi",
	"Tajara",
	"Akula",
	"Skrell",
	"Sergal",
	"Nevrean",
	"Human",
	"Slime",
	"Egg",
	"Xenochimera",
	"Xenomorph",
	"Chocolate",
	"Boney",
	"Slime Glob",
	"Chicken",
	"Synthetic",
	"Bluespace Floppy",
	"Bluespace Compressed File",
	"Bluespace CD",
	"Escape Pod",
	"Cooking Error",
	"Web Cocoon",
	"Honeycomb",
	"Bug Cocoon",
	"Rock",
	"Yellow",
	"Blue",
	"Green",
	"Orange",
	"Purple",
	"Red",
	"Rainbow",
	"Spotted Pink"
	))

GLOBAL_LIST_INIT(tf_vore_egg_types, list(
	"Unathi" 		= /obj/item/storage/vore_egg/unathi,
	"Tajara" 		= /obj/item/storage/vore_egg/tajaran,
	"Akula" 		= /obj/item/storage/vore_egg/shark,
	"Skrell" 		= /obj/item/storage/vore_egg/skrell,
	"Sergal"		= /obj/item/storage/vore_egg/sergal,
	"Nevrean"		= /obj/item/storage/vore_egg/nevrean,
	"Human"			= /obj/item/storage/vore_egg/human,
	"Slime"			= /obj/item/storage/vore_egg/slime,
	"Egg"			= /obj/item/storage/vore_egg,
	"Xenochimera"	= /obj/item/storage/vore_egg/scree,
	"Xenomorph"		= /obj/item/storage/vore_egg/xenomorph,
	"Chocolate"		= /obj/item/storage/vore_egg/chocolate,
	"Boney"			= /obj/item/storage/vore_egg/owlpellet,
	"Slime Glob"	= /obj/item/storage/vore_egg/slimeglob,
	"Chicken"		= /obj/item/storage/vore_egg/chicken,
	"Synthetic"		= /obj/item/storage/vore_egg/synthetic,
	"Bluespace Floppy"	= /obj/item/storage/vore_egg/floppy,
	"Bluespace Compressed File"	= /obj/item/storage/vore_egg/file,
	"Bluespace CD"	= /obj/item/storage/vore_egg/cd,
	"Escape Pod"	= /obj/item/storage/vore_egg/escapepod,
	"Cooking Error"	= /obj/item/storage/vore_egg/badrecipe,
	"Web Cocoon"	= /obj/item/storage/vore_egg/cocoon,
	"Honeycomb"	= /obj/item/storage/vore_egg/honeycomb,
	"Bug Cocoon"	= /obj/item/storage/vore_egg/bugcocoon,
	"Rock"			= /obj/item/storage/vore_egg/rock,
	"Yellow"		= /obj/item/storage/vore_egg/yellow,
	"Blue"			= /obj/item/storage/vore_egg/blue,
	"Green"			= /obj/item/storage/vore_egg/green,
	"Orange"		= /obj/item/storage/vore_egg/orange,
	"Purple"		= /obj/item/storage/vore_egg/purple,
	"Red"			= /obj/item/storage/vore_egg/red,
	"Rainbow"		= /obj/item/storage/vore_egg/rainbow,
	"Spotted Pink"	= /obj/item/storage/vore_egg/pinkspots))

GLOBAL_LIST_INIT(contamination_flavors, list(
				"Generic" = GLOB.contamination_flavors_generic,
				"Acrid" = GLOB.contamination_flavors_acrid,
				"Dirty" = GLOB.contamination_flavors_dirty,
				"Musky" = GLOB.contamination_flavors_musky,
				"Smelly" = GLOB.contamination_flavors_smelly,
				"Slimy" = GLOB.contamination_flavors_slimy,
				"Wet" = GLOB.contamination_flavors_wet))

GLOBAL_LIST_INIT(contamination_flavors_generic, list("acrid",
				"bedraggled",
				"begrimed",
				"churned",
				"contaminated",
				"cruddy",
				"damp",
				"digested",
				"dirty",
				"disgusting",
				"drenched",
				"drippy",
				"filthy",
				"foul",
				"funky",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"gunky",
				"icky",
				"juicy",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"smeary",
				"smelly",
				"smudgy",
				"smutty",
				"soaked",
				"soggy",
				"soiled",
				"sopping",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"stinky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory",
				"yucky"))

GLOBAL_LIST_INIT(contamination_flavors_wet, list("damp",
				"drenched",
				"drippy",
				"gloppy",
				"gooey",
				"juicy",
				"oozing",
				"slimy",
				"slobbery",
				"sloppy",
				"sloshed",
				"sloughy",
				"sludgy",
				"slushy",
				"soaked",
				"soggy",
				"sopping",
				"squashy",
				"squishy",
				"sticky"))

GLOBAL_LIST_INIT(contamination_flavors_smelly, list("disgusting",
				"filthy",
				"foul",
				"funky",
				"gross",
				"icky",
				"malodorous",
				"nasty",
				"niffy",
				"noxious",
				"pungent",
				"putrescent",
				"putrid",
				"rancid",
				"reeking",
				"repulsive",
				"smelly",
				"stenchy",
				"stinky",
				"unsavory",
				"whiffy",
				"yucky"))

GLOBAL_LIST_INIT(contamination_flavors_acrid, list("acrid",
				"caustic",
				"churned",
				"chymous",
				"digested",
				"discolored",
				"disgusting",
				"drippy",
				"foul",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"icky",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"slushy",
				"smelly",
				"smudgy",
				"soupy",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"tainted",
				"unsavory",
				"yucky"))

GLOBAL_LIST_INIT(contamination_flavors_dirty, list("bedraggled",
				"begrimed",
				"besmirched",
				"blemished",
				"contaminated",
				"cruddy",
				"dirty",
				"discolored",
				"filthy",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"grubby",
				"gruesome",
				"gunky",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"saucy",
				"slimy",
				"sloppy",
				"sludgy",
				"smeary",
				"smudgy",
				"smutty",
				"soiled",
				"stained",
				"sticky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory"))

GLOBAL_LIST_INIT(contamination_flavors_musky, list("drenched",
				"drippy",
				"funky",
				"gooey",
				"juicy",
				"messy",
				"musky",
				"nasty",
				"raunchy",
				"saucy",
				"slimy",
				"sloppy",
				"slushy",
				"smeary",
				"smelly",
				"smutty",
				"soggy",
				"squashy",
				"squishy",
				"sticky",
				"tainted"))

GLOBAL_LIST_INIT(contamination_flavors_slimy, list("slimy",
				"sloppy",
				"drippy",
				"glistening",
				"dripping",
				"gunky",
				"slimed",
				"mucky",
				"viscous",
				"dank",
				"glutinous",
				"syrupy",
				"slippery",
				"gelatinous"
				))

GLOBAL_LIST_INIT(contamination_colors, list("green",
				"white",
				"black",
				"grey",
				"yellow",
				"red",
				"blue",
				"orange",
				"purple",
				"lime",
				"brown",
				"darkred",
				"cyan",
				"beige",
				"pink"
				))


#define CHEM_VORE 4 // vore belly interactions
#define CHEM_INGEST 2

#define isbelly(A)				istype(A, /obj/belly)

#define LOG_CATEGORY_VORE "vore"


#define ITEMSIZE_COST_TINY			1
#define ITEMSIZE_COST_SMALL			2
#define ITEMSIZE_COST_NORMAL		4
#define ITEMSIZE_COST_LARGE			8
#define ITEMSIZE_COST_HUGE			16
#define ITEMSIZE_COST_GIGANTIC		32

#define CHANNEL_PREYLOOP 1011	//VORESTATION ADD - Fancy Sound Loop channel


// Vore Lists
GLOBAL_LIST_INIT(item_digestion_blacklist, list(
	/obj/item/roguekey,
	/obj/item/clothing/head/roguetown/crown/serpcrown
))

GLOBAL_LIST_INIT(slosh, list(
	'modular_causticcove/sound/cvore/vore/walkslosh1.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh2.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh3.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh4.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh5.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh6.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh7.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh8.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh9.ogg',
	'modular_causticcove/sound/cvore/vore/walkslosh10.ogg',
))

/*
// Vore Pref Defines
#define VORE_PREF_TRANSFER(target, source)												\
	target.digestable = source.digestable;												\
	target.devourable = source.devourable;												\
	target.feeding = source.feeding;													\
	target.absorbable = source.absorbable;												\
	target.allowmobvore = source.allowmobvore;											\
	target.permit_healbelly = source.permit_healbelly;									\
	target.allowtemp = source.allowtemp;												\
																						\
	target.vore_taste = source.vore_taste;												\
	target.vore_smell = source.vore_smell;												\
	target.noisy = source.noisy;														\
	target.show_vore_fx = source.show_vore_fx;											\
	target.selective_preference = source.selective_preference;							\
	target.size_strip_preference = source.size_strip_preference;						\
	target.digest_leave_remains = source.digest_leave_remains;							\
	target.digest_pain = source.digest_pain;											\
	target.noisy_full = source.noisy_full;												\
	target.eating_privacy_global = source.eating_privacy_global;						\
	target.vore_death_privacy = source.vore_death_privacy;								\
																						\
	target.can_be_drop_prey = source.can_be_drop_prey;									\
	target.can_be_drop_pred = source.can_be_drop_pred;									\
	target.can_be_afk_prey = source.can_be_afk_prey;									\
	target.can_be_afk_pred = source.can_be_afk_pred;									\
	target.throw_vore = source.throw_vore;												\
	target.food_vore = source.food_vore;												\
	target.drop_vore = source.drop_vore;												\
	target.slip_vore = source.slip_vore;												\
	target.stumble_vore = source.stumble_vore;											\
	target.phase_vore = source.phase_vore;												\
																						\
	target.spont_belly_rear = source.spont_belly_rear;									\
	target.spont_belly_left = source.spont_belly_left;									\
	target.spont_belly_front = source.spont_belly_front;								\
	target.spont_belly_right = source.spont_belly_right;								\
																						\
	target.resizable = source.resizable;												\
	target.step_mechanics_pref = source.step_mechanics_pref;							\
	target.pickup_pref = source.pickup_pref;											\
	target.allow_spontaneous_tf = source.allow_spontaneous_tf;							\
	target.allow_mind_transfer = source.allow_mind_transfer;							\
	target.allow_mimicry = source.allow_mimicry;										\
																						\
	target.consume_liquid_belly = source.consume_liquid_belly;							\
	target.receive_reagents = source.receive_reagents;									\
	target.apply_reagents = source.apply_reagents;										\
	target.give_reagents = source.give_reagents;										\
																						\
	target.nutrition_messages = source.nutrition_messages;								\
	target.nutrition_message_visible = source.nutrition_message_visible;				\
	target.weight_message_visible = source.weight_message_visible;						\
	target.weight_messages = source.weight_messages;									\
																						\
	target.latejoin_vore = source.latejoin_vore;										\
	target.latejoin_prey = source.latejoin_prey;										\
	target.no_latejoin_vore_warning = source.no_latejoin_vore_warning;					\
	target.no_latejoin_prey_warning = source.no_latejoin_prey_warning;					\
	target.no_latejoin_vore_warning_time = source.no_latejoin_vore_warning_time;		\
	target.no_latejoin_prey_warning_time = source.no_latejoin_prey_warning_time;		\
	target.no_latejoin_vore_warning_persists = source.no_latejoin_vore_warning_persists;\
	target.no_latejoin_prey_warning_persists = source.no_latejoin_prey_warning_persists;\
	target.max_voreoverlay_alpha = source.max_voreoverlay_alpha;						\
																						\
	target.autotransferable = source.autotransferable;									\
	target.strip_pref = source.strip_pref;												\
	target.contaminate_pref = source.contaminate_pref;									\
	target.vore_sprite_multiply = source.vore_sprite_multiply;							\
	target.vore_sprite_color = source.vore_sprite_color;								\
	target.belly_rub_target = source.belly_rub_target;									\
																						\
	target.soulcatcher_pref_flags = source.soulcatcher_pref_flags;						\
	target.persistend_edit_mode = source.persistend_edit_mode;
*/

// Vore Signals
///from /obj/belly/HandleBellyReagents() and /obj/belly/update_internal_overlay()
#define COMSIG_BELLY_UPDATE_VORE_FX "update_vore_fx"
///from /obj/belly/process()
#define COMSIG_BELLY_UPDATE_PREY_LOOP "update_prey_loop"

// Spontaneous vore stuff.
///from /mob/living/stumble_into(mob/living/M)
#define COMSIG_LIVING_STUMBLED_INTO "living_stumbled_into"
		///Something has special handling. Don't continue.
	#define CANCEL_STUMBLED_INTO	(1<<0)
///from /mob/living/handle_fall(var/turf/landing) args: landing, drop_mob)
#define COMSIG_LIVING_FALLING_DOWN "living_falling_down"
		//Special handling. Cancel the fall chain.
	#define COMSIG_CANCEL_FALL	(1<<0)
///from /mob/living/hitby(atom/movable/source, datum/thrownthing/throwingdatum).
#define COMSIG_LIVING_HIT_BY_THROWN_ENTITY "hit_by_thrown_entity"
		//Special handling. Cancel the hitby proc.
	#define COMSIG_CANCEL_HITBY	(1<<0)


// Vore Reg Defines
#define VORE_SOUND_FALLOFF 0.1
#define VORE_SOUND_RANGE 3
#define VOLUME_CHANNEL_VORE "Vore"

#define BELLIES_MAX 40
#define BELLIES_NAME_MIN 2
#define BELLIES_NAME_MAX 40
#define BELLIES_DESC_MAX 8192
#define BELLIES_EXAMINE_MAX 2048
#define BELLIES_IDLE_MAX 2048
#define BELLIES_MESSAGE_MAX 1024
#define BELLIES_MESSAGE_COMBINED 1024 * 10 + 18
#define FLAVOR_MAX 400

#define VORE_SC_MAX 2048
#define VORE_SC_DESC_MAX 8192

#define VORE_VERSION	2	//This is a Define so you don't have to worry about magic numbers.

#define VPANEL_DESCRIPTION_TAB 0
#define VPANEL_EXAMINE_TAB 1
#define VPANEL_TRASH_EATER_TAB 2
#define VPANEL_STRUGGLE_TAB 3
#define VPANEL_ESCAPE_TAB 4
#define VPANEL_ESCAPE_ABSORBED_TAB 5
#define VPANEL_TRANSFER_TAB 6
#define VPANEL_INTERACTION_TAB 7
#define VPANEL_BELLYMODE_TAB 8
#define VPANEL_IDLE_TAB 9
#define VPANEL_LIQUIDS_TAB 10

#define VORE_RESIZE_COST 125

#define MAX_VOICE_FREQ 70000
#define MIN_VOICE_FREQ 15000


// I don't think these are used anywhere??? I don't know who did what with this port but damn

/// COMSIG used to get messages where they need to go
#define COMSIG_VISIBLE_MESSAGE "visible_message"
