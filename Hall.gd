extends Node2D


var my_user_id=0


# Called when the node enters the scene tree for the first time.
func _ready():
	$CreateRoomRequest.connect("request_completed", self, "on_request_completed")
	ConnManager.connect("conn_success", self, "on_ws_established")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_ws_established():
	get_tree().change_scene("res://Table/Table.tscn")
	pass

func _on_CreateRoomButton_pressed():
	$CreateRoomDialog.popup_centered()
	
func _on_CancelButton_pressed():
	$CreateRoomDialog.hide()
	pass # Replace with function body.
	
func on_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		pass
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"]==true:
		print_debug("room created")
		# connect to websocket
		ConnManager.connect_ws(my_user_id)
	else:
		print_debug("failed to create room")

	
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
		"room_id":0,
		"passwd":""}
	var data = to_json(dict)



func _on_ConfirmButton_pressed():
	send_create_room()



