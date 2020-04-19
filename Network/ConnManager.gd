extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal recv_game_msg
signal recv_table_order_msg
signal recv_game_result_msg
signal recv_get_ready_msg
signal recv_user_order_msg

signal conn_success
signal conn_failed
signal deal_tiles	# 发牌
signal draw_tile	# 抓牌


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


		
func connect_ws(user_id):
	# Initiate connection to the given URL.
	var err = _client.connect_to_url(Constants.WebSockt.URL+"/ws/"+ str(user_id))
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
	emit_signal("conn_success")
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
	var msg_type = json["msg_type"]
	if msg_type == Message.msg_type.GAME_MSG:
		emit_signal("recv_game_msg", json)
	elif msg_type == Message.msg_type.TABLE_ORDER_MSG:
		emit_signal("recv_table_order_msg", json)
	elif msg_type == Message.msg_type.GAME_RESULT_MSG:
		emit_signal("recv_game_result_msg", json)
	elif msg_type == Message.msg_type.GET_READY_MSG:
		emit_signal("recv_get_ready_msg", json)
	elif msg_type == Message.msg_type.USER_ORDER_MSG:
		emit_signal("recv_user_order_msg", json)
	
	print_debug("msg_type: ", json_recv.result["msg_type"])

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
	
func send_start():
	var msg = Message.game_msg_dict
	msg["action"]=Message.player_action.START
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_discard(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.DISCARD
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_chow(tile,order,chow_type):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.CHOW
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = chow_type
	send_message(to_json(msg))
	
func send_pong(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.PONG
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_exposedkong(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.EXPOSED_KONG
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_concealedkong(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.CONCEALED_KONG
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))

func send_addedkong(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.ADDED_KONG
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_win(tile, order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.WIN
	msg["tile"] = tile
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_cancel(order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.CANCEL
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
	
func send_ready(order):
	var msg = Message.game_msg_dict
	msg["action"] = Message.player_action.READY
	msg["table_order"] = order
	msg["chow_type"] = Message.chow_type.NAC
	send_message(to_json(msg))
