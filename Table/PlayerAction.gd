extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func show_actions(actions):
	if (not actions[0]) and (not actions[1]) and (not actions[2]) and (not actions[3]):
		self.hide()
		return false
	else:
		$Chow.visible = actions[0]
		$Pong.visible = actions[1]
		$Kong.visible = actions[2]
		$Win.visible = actions[3]
		$Cancel.visible = true
		self.show()
		return true



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
