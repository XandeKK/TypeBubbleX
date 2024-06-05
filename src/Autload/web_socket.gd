extends Node

var websocket_url = "ws://" + Preference.general.url + ":" + Preference.general.port

var _client = WebSocketPeer.new()
var send : bool = false
var loading : bool = false

func _ready():
	set_process(false)

func run():
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		Notification.message(tr('KEY_UNABLE_TO_CONNECT'))
		set_process(false)
		return
	
	set_process(true)
	send = true

func _closed():
	Notification.message(tr('KEY_CLOSED_WEBSOCKET'))
	#Notification.hide_loading()
	set_process(false)

func _connected(_proto = ""):
	Notification.message(tr('KEY_CONNECTED_WEBSOCKET'))
	var data : Dictionary = {}
	if not FileHandler.raw_images_path.is_empty():
		data['directory_path'] = FileHandler.raw_path
	else:
		data['directory_path'] = FileHandler.cleaned_path

	_client.send_text(JSON.stringify(data))
	loading = true

func _on_data():
	#Notification.hide_loading()

	var data_string : String = _client.get_packet().get_string_from_utf8()
	var data_dict : Dictionary = JSON.parse_string(data_string)

	if data_dict['status'] == 'boxes':
		FileHandler.boxes.append(data_dict)
	elif data_dict['status'] == 'finished':
		_client.close()
	else:
		Notification.message(tr('KEY_ERROR_SERVER'))

	if loading:
		FileHandler.load_image_in_canvas()
		loading = false

func _process(_delta):
	_client.poll()
	var state = _client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if send:
			_connected()
			send = false
		while _client.get_available_packet_count():
			_on_data()
	elif state == WebSocketPeer.STATE_CLOSED:
		_closed()

func _exit_tree():
	_client.close()
