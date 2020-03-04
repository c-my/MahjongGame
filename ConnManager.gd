extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var url = "ws://127.0.0.1"
var port = "1114"

enum MsgType {GameMsg = 0, ChatMsg}
enum PlayerAction {Start, Deal, Chow, Pong, Kong, Win}

signal deal_tiles


# Our WebSocketClient instance
var _client = WebSocketClient.new()

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(url+":"+port)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
func send_message(msg):
	_client.get_peer(1).put_packet(msg.to_utf8())

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
#	_client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var data_recv = _client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", data_recv)
	var json_recv = JSON.parse(data_recv)
	var json = json_recv.result
	if json["msg_type"]==MsgType.GameMsg:
		if json["available_actions"][0]==PlayerAction.Deal:
			print_debug("current tiles: ", json["current_tile"])
			print_debug("type: ", typeof(json["current_tile"]))
			emit_signal("deal_tiles", json)
	print_debug("msg_type: ", json_recv.result["msg_type"])

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
