/datum/world_topic/makenote
	keyword = "makenote"

/datum/world_topic/makenote/Run(list/input)
	if(!SSdbcore.Connect())
		return "Cannot connect to database!"
	if(!("target" in input))
		return "No Target!"
	if(!("admin" in input))
		return "No Admin!"
	if(!(GLOB.admin_datums[input["admin"]]))
		return "Invalid permissions!"
	if(!("severity" in input))
		return "No Severity!"
	if(!("message" in input))
		return "No Message!"
	var/datum/DBQuery/query_create_message = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("messages")] (type, targetckey, adminckey, text, timestamp, server, server_ip, server_port, round_id, secret, expire_timestamp, severity)
		VALUES (:type, :target_ckey, :admin_ckey, :text, :timestamp, :server, INET_ATON(:internet_address), :port, :round_id, :secret, :expiry, :note_severity)
	"}, list(
		"type" = "note",
		"target_ckey" = input["target"],
		"admin_ckey" = input["admin"],
		"text" = html_decode(input["message"]),
		"timestamp" = SQLtime(),
		"server" = CONFIG_GET(string/serversqlname),
		"internet_address" = world.internet_address || "0",
		"port" = "[world.port]",
		"round_id" = GLOB.round_id,
		"secret" = TRUE,
		"expiry" = null,
		"note_severity" = input["severity"],
	))
	var/pm = "[input["admin"]] has created a note for [input["target"]] via Discord: [input["message"]]"
	var/header = "[input["admin"]] has created a note for [input["target"]] via Discord"
	if(!query_create_message.warn_execute())
		qdel(query_create_message)
		return "Query failed!"
	qdel(query_create_message)
	log_admin_private(pm)
	message_admins("[header]:<br>[input["message"]]")
	admin_ticket_log(input["target"], "<font color='blue'>[header]</font>")
	admin_ticket_log(input["target"], input["message"])
	if(CONFIG_GET(flag/amia_enabled))
		amia_relaynote(input["target"], input["admin"], input["message"], input["severity"])
	return "Note added successfully!"
