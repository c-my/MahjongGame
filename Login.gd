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


func _on_SignupButton_pressed():
	$RegisterDialog.popup_centered()
	pass # Replace with function body.

func send_login():
	var use_ssl = false
	var headers = ["Content-Type: application/json"]
	var dict = {"username":"",
		"password":""}
	var data = to_json(dict)
	$LoginHTTPRequest.request(Constants.HTTP.ROOM_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)

	
func send_signup():
	var gender = Message.gender.FEMALE
	if $RegisterDialog/GridContainer/GenderContainer/MaleCheckBox.pressed:
		gender = Message.gender.MALE
	var use_ssl = false
	var headers = ["Content-Type: application/json"]
	var dict = {"username":$RegisterDialog/GridContainer/UsernameEdit.text,
		"password":$RegisterDialog/GridContainer/PasswordEdit.text,
		"nickname":$RegisterDialog/GridContainer/NicknameEdit.text,
		"gender":gender,}
	var data = to_json(dict)
	$LoginHTTPRequest.request(Constants.HTTP.ROOM_URL, headers, use_ssl, HTTPClient.METHOD_POST, data)



func on_login_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when login")
	
func on_register_request_completed(result, response_code, headers, body):
	if result!=HTTPRequest.RESULT_SUCCESS:
		print_debug("http response error when sign up")


func _on_LoginButton_pressed():
	$LoginPanel.popup_centered()
