SUBSYSTEM_DEF(map_edit_deployments)
	name = "Ochre Valley Map Edit Deployments"
	init_order = INIT_ORDER_OV_MAP_EDITS
	flags = SS_NO_FIRE
	/// A list of map edit operations that are deployed when we initialize (sse `modular_ochrevalley\code\modules\map_edit_deployments\map_edit_operation.dm`).
	var/list/deployment_operations = list()

/datum/controller/subsystem/map_edit_deployments/Initialize(start_timeofday)
	prepare_deployment_operations()
	deploy_edits()
	. = ..()

/datum/controller/subsystem/map_edit_deployments/proc/prepare_deployment_operations()
	for(var/datum/map_edit_operation/op_type as anything in subtypesof(/datum/map_edit_operation))
		var/datum/map_edit_operation/basetype = /datum/map_edit_operation
		if(initial(op_type.name) == initial(basetype.name))
			continue
		var/datum/map_edit_operation/O = new op_type()

		deployment_operations.Add(O)

/datum/controller/subsystem/map_edit_deployments/proc/deploy_edits()
	for(var/datum/map_edit_operation/op in deployment_operations)
		var/success = op.deploy(SSmapping.config)
		if(!success)
			var/msg = "OV MAP EDIT DEPLOYMENT ERROR: [op.name] reported back as failing to complete its deployment!"
			#ifdef LOCALTEST
			to_world(span_boldannounce("[msg]"))
			#endif
			log_world(msg)
