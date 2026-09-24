/datum/map_edit_operation/precise_coordinates/template_deployment/deploy_wildsoul_spawns_template
	name = "Deploy Wildsoul Spawns (Via Template)"

	templates_by_mappath = alist(
		"map_files/ovdun_world" = list(
			list(
				"template" = "dun_wildsoul_cave",
				"x" = 155,
				"y" = 351,
				"z" = 4
			)
		),
	)

/datum/map_edit_operation/precise_coordinates/generic_type_spawner/deploy_wildsoul_spawns
	name = "Deploy Wildsoul Spawns (Via Generic Type Spawn)"

	spawntypes_by_mappath = alist(
		"map_files/jagged_jaw" = list(
			list(
				"type" = /obj/effect/landmark/start/wildsoullate,
				"x" = 148,
				"y" = 288,
				"z" = 4
			),
			list(
				"type" = /obj/effect/landmark/start/wildsoullate,
				"x" = 149,
				"y" = 288,
				"z" = 4
			),
			list(
				"type" = /obj/effect/landmark/start/wildsoullate,
				"x" = 150,
				"y" = 288,
				"z" = 4
			),
			list(
				"type" = /obj/effect/landmark/start/wildsoullate,
				"x" = 151,
				"y" = 288,
				"z" = 4
			),
		),
	)
