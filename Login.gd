extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LoginHTTPRequest.connect("request_completed", self, "on_login_request_completed")
	$RegisterHTTPRequest.connect("request_completed", self, "on_register_request_completed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func send_login():
	var use_ssl = true
	var headers = ["Content-Type: application/json"]
	var dict = {"username":$LoginPanel/VBoxContainer/GridContainer/UsernameEdit.text,
		"password":$LoginPanel/VBoxContainer/GridContainer/PasswordEdit.text,}
	var data = to_json(dict)
	$LoginHTTPRequest.request(Constants.HTTP.LOGIN_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)

	
func send_signup():
	var gender = Message.gender.FEMALE
	if $RegisterDialog/VBoxContainer/GridContainer/GenderContainer/MaleCheckBox.pressed:
		gender = Message.gender.MALE
	var use_ssl = true
	var headers = ["Content-Type: application/json"]
	var dict = {"username":$RegisterDialog/VBoxContainer/GridContainer/UsernameEdit.text,
		"password":$RegisterDialog/VBoxContainer/GridContainer/PasswordEdit.text,
		"nickname":$RegisterDialog/VBoxContainer/GridContainer/NicknameEdit.text,
		"gender":gender,}
	var data = to_json(dict)
	$LoginHTTPRequest.request(Constants.HTTP.REGISTER_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)



func on_login_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when login")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"] == true:
		print_debug("login success, userID: ", res["user_id"])
		Global.my_user_id = res["user_id"]
		get_tree().change_scene("res://Hall.tscn")
		#TODO: switch scene
	else:
		print_debug("login failed")
	
	
func on_register_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when sign up")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"] == true:
		Global.my_user_id = res["user_id"]
		print_debug("sign up success, userID: ", res["user_id"])
	else:
		print_debug("sign up failed")

func _on_RegisterConfirmButton_pressed():
	#TODO:check text em
	if ($RegisterDialog/VBoxContainer/GridContainer/UsernameEdit.text.empty() or 
		$RegisterDialog/VBoxContainer/GridContainer/PasswordEdit.text.empty() or
		$RegisterDialog/VBoxContainer/GridContainer/NicknameEdit.text.empty() or
		not(
			$RegisterDialog/VBoxContainer/GridContainer/GenderContainer/MaleCheckBox.pressed or
			$RegisterDialog/VBoxContainer/GridContainer/GenderContainer/FemaleCheckBox.pressed
			)
		):
		#TODO:inform not enough info
		return
	send_signup()
	
func _on_LoginConfirmButton_pressed():
	if ($LoginPanel/VBoxContainer/GridContainer/UsernameEdit.text.empty() or
		$LoginPanel/VBoxContainer/GridContainer/PasswordEdit.text.empty()
	):
		# inform not enough info
		return
	send_login()

func _on_LoginButton_pressed():
	$LoginPanel.popup_centered()

func _on_SignupButton_pressed():
	$RegisterDialog.popup_centered()



