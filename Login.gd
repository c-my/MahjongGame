extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var username
var password


# Called when the node enters the scene tree for the first time.
func _ready():
	$LoginHTTPRequest.connect("request_completed", self, "on_login_request_completed")
	$RegisterHTTPRequest.connect("request_completed", self, "on_register_request_completed")
	
	$RegisterFailedPanel/VBoxContainer/HBoxContainer/ConfirmButton.connect("pressed", self, "_on_register_failed_confirm_pressed")
	$LoginFailedPanel/HBoxContainer/HBoxContainer/ConfirmButton.connect("pressed", self, "_on_login_failed_confirm_pressed")
	$NetWorkErrDialog/HBoxContainer/HBoxContainer/ConfirmButton.connect("pressed", self, "_on_network_err_confirm_pressed")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func send_login():
	var use_ssl = true
	var headers = ["Content-Type: application/json"]
	var username = $LoginPanel/VBoxContainer/GridContainer/UsernameEdit.text
	var password = $LoginPanel/VBoxContainer/GridContainer/PasswordEdit.text
	var dict = {"username":username,
		"password":password,}
	var data = to_json(dict)
	save_username(username, password)
	$LoginHTTPRequest.request(Constants.HTTP.LOGIN_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)

	
func send_signup():
	var gender = Message.gender.FEMALE
	if $RegisterDialog/VBoxContainer/GridContainer/GenderContainer/MaleCheckBox.pressed:
		gender = Message.gender.MALE
	var use_ssl = true
	username = $RegisterDialog/VBoxContainer/GridContainer/UsernameEdit.text
	password = $RegisterDialog/VBoxContainer/GridContainer/PasswordEdit.text
	var headers = ["Content-Type: application/json"]
	var dict = {"username":username,
		"password":password,
		"nickname":$RegisterDialog/VBoxContainer/GridContainer/NicknameEdit.text,
		"gender":gender,}
	var data = to_json(dict)
	$RegisterHTTPRequest.request(Constants.HTTP.REGISTER_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)



func on_login_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when login")
		show_network_err_panel()
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
		show_wrong_pass_panel()
		
	
	
func on_register_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when sign up")
		show_network_err_panel()
		return
	var json = JSON.parse(body.get_string_from_utf8())
	var res = json.result
	if res["success"] == true:
		print_debug("sign up success, userID: ", res["user_id"])
		save_username(username, password)
		Global.my_user_id = res["user_id"]
		get_tree().change_scene("res://Hall.tscn")
	else:
		print_debug("sign up failed")
		show_exist_username_panel()

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
	
func save_username(username, password):
	var save_game = File.new()
	var user_dict = {
		"username" :username,
		"password" :password,
	}
	save_game.open("user://username.save", File.WRITE)
	save_game.store_string(to_json(user_dict))
	save_game.close()
	
func get_username():
	var save_game = File.new()
	save_game.open("user://username.save", File.READ)
	var content = save_game.get_as_text()
	return content
	
	
func _on_LoginButton_pressed():
#	$LoginPanel.popup_centered()
	var content = get_username()
	print_debug("read username from config:", content)
	if content != "":
		var j = JSON.parse(content)
		var user = j.result["username"]
		var passwd = j.result["password"]
		$LoginPanel/VBoxContainer/GridContainer/UsernameEdit.text = user
		$LoginPanel/VBoxContainer/GridContainer/PasswordEdit.text = passwd
	$LoginPanel.popup_centered_ratio(0.6)

func _on_SignupButton_pressed():
#	$RegisterDialog.popup_centered()
	$RegisterDialog.popup_centered_ratio(0.6)
	
func _on_register_failed_confirm_pressed():
	$RegisterFailedPanel.hide()

func _on_network_err_confirm_pressed():
	$NetWorkErrDialog.hide()
	
func _on_login_failed_confirm_pressed():
	$LoginFailedPanel.hide()
	
func show_exist_username_panel():
	$RegisterFailedPanel.popup_centered()
	
func show_wrong_pass_panel():
	$LoginFailedPanel.popup_centered()
	
func show_network_err_panel():
	$NetWorkErrDialog.popup_centered()
	




