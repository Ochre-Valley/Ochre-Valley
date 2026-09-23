/area/rogue/indoors/remote_sanctuary
	name = "Remote Sanctuary"
	first_time_text = "REMOTE SANCTUARY"
	icon_state = "eora"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'modular_ochrevalley/sounds/music/sanctuary.ogg'
	droning_sound_night = 'modular_ochrevalley/sounds/music/sanctuary.ogg'
	deathsight_message = "a normally unreachable, remote location that cannot see the sky"

/area/rogue/indoors/remote_sanctuary/running_water_sounds
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER

/area/rogue/indoors/remote_sanctuary/bath
	droning_sound = 'sound/music/area/bath.ogg'

/area/rogue/indoors/remote_sanctuary/cave
	name = "Remote Sanctuary"
	icon_state = "cave"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = 'sound/music/area/caves.ogg'
	droning_sound_night = 'sound/music/area/caves.ogg'
	ambientsounds = AMB_GENCAVE
	ambientnight = AMB_GENCAVE
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	soundenv = 8
	deathsight_message = "a normally unreachable, remote location in a cave"

// Outdoor areas

/area/rogue/outdoors/remote_sanctuary
	name = "Remote Sanctuary"
	first_time_text = "REMOTE SANCTUARY"
	icon_state = "exposed"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'modular_ochrevalley/sounds/music/sanctuary.ogg'
	droning_sound_night = 'modular_ochrevalley/sounds/music/sanctuary.ogg'
	deathsight_message = "a normally unreachable, remote location with a view of the sky"
	soundenv = 16
	converted_type = /area/rogue/indoors/remote_sanctuary

/area/rogue/outdoors/remote_sanctuary/mountains
	icon_state = "mountains"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17

