extends Node2D

const Success       = 1
const NoSuchRoom    = -1
const NoSeat        = -2
const WrongPassword = -3

var my_user_id=0


# Called when the node enters the scene tree for the first time.
func _ready():
	$CreateRoomRequest.connect("request_completed", self, "on_create_request_completed")
	$JoinRoomRequest.connect("request_completed", self, "on_join_request_completed")
	ConnManager.connect("conn_success", self, "on_ws_established")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_ws_established():
	get_tree().change_scene("res://Table/Table.tscn")
	pass

func _on_CreateRoomButton_pressed():
	$CreateRoomDialog.popup_centered()
	
func _on_CreateRoom_ConfirmButton_pressed():
	send_create_room()
	
func _on_CreateRoom_CancelButton_pressed():
	$CreateRoomDialog.hide()
	
func _on_EnterRoomButton_pressed():
	$JoinRoomDialog.popup_centered()
	
func _on_JoinRoom_ConfirmButton_pressed():
	if $JoinRoomDialog/VoxContainer/RoomIDContainer/RoomIDEdit.text.is_valid_integer():
		send_join_room()
	else:
		#提示错误
		pass
	
func _on_JoinRoom_CancelButton_pressed():
	$JoinRoomDialog.hide()
	
func on_create_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when creating room")
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"]==true:
		print_debug("room created")
		# connect to websocket
		ConnManager.connect_ws(my_user_id)
	else:
		print_debug("failed to create room")
		

func on_join_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when joining room")
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"]==true:
		print_debug("room joined")
		# connect to websocket
		ConnManager.connect_ws(my_user_id)
	else:
		var reason = res["reason"]
		print_debug("failed to join room")
		

	
func send_create_room():
	var use_ssl = false
	var headers = ["Content-Type: application/json"]
	var dict = {"user_id":my_user_id,
		"passwd":$CreateRoomDialog/VoxContainer/PasswdContainer/PasswordEdit.text}
	var data = to_json(dict)
	$CreateRoomRequest.request(Constants.HTTP.ROOM_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)

	
func send_join_room():
	var use_ssl = false
	var headers = ["Content-Type: application/json"]
	var dict = {"user_id":my_user_id,
		"room_id":$JoinRoomDialog/VoxContainer/RoomIDContainer/RoomIDEdit.text.to_int(),
		"passwd":$JoinRoomDialog/VoxContainer/PasswdContainer/PasswordEdit.text}
	var data = to_json(dict)
	print_debug(data)
	$JoinRoomRequest.request(Constants.HTTP.ROOM_URL, headers, use_ssl, HTTPClient.METHOD_PUT, data)









