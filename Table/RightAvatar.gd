extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_ready(show_ready=false):
	$StateContainer/ReadyIcon.visible = show_ready
	

func show_avatar(nickname,gender=Message.gender.MALE, 
			show_banker=false, show_ready=false, show_offline=false):
	$StateContainer/ReadyIcon.visible = show_ready
	$StateContainer/OfflineIcon.visible = show_offline
	$StateContainer/BankerIcon.visible = show_banker
	$AvatarContainer/Nickname.text = nickname
	var gender_string = "Male"
	if gender==Message.gender.FEMALE:
		gender_string = "Female"
	$AvatarContainer/Avatar.texture = load("res://Asset/Avatar/%s.png" % gender_string)
	show()

func show_chat_pop(text):
	$Chat/Label.text = text
	$Chat.show()
	$Timer.start()


func _on_Timer_timeout():
	$Chat.hide()
