extends Node

var TS : TextServer = TextServerManager.get_primary_interface() : get = get_text_server

func get_text_server():
	return TS
