extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal chow
signal pong
signal kong
signal win
signal cancel


# Called when the node enters the scene tree for the first time.
func _ready():
	$Chow.connect("pressed", self, "chow")
	$Pong.connect("pressed", self, "pong")
	$Kong.connect("pressed", self, "kong")
	$Win.connect("pressed", self, "win")
	$Cancel.connect("pressed", self, "cancel")
	
func show_actions(actions):
	if (not actions[0]) and (not actions[1]) and (not actions[2]) and (not actions[3]):
		self.hide()
	else:
		$Chow.disabled = !actions[0]
		$Pong.disabled = !actions[1]
		$Kong.disabled = !actions[2]
		$Win.disabled = !actions[3]
		$Cancel.disabled = !actions[4]



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
