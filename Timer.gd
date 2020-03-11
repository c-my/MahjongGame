extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_position = Vector2((Constants.Screen.WIDTH-get_rect().size.x)/2.0,
						(Constants.Screen.HEIGHT-get_rect().size.y)/2.0)
	
	$TimerBottom.rect_position = Vector2(-122, 92)
	$TimerOpposite.rect_position = Vector2(-119, -166)
	$TimerLeft.rect_position = Vector2(-164, -174)
	$TimerRight.rect_position = Vector2(94, -173)
	
func show_timer(direction):
	if direction == Constants.Timer_Table.DIRECTION.NONE:
		$TimerBottom.hide()
		$TimerRight.hide()
		$TimerOpposite.hide()
		$TimerLeft.hide()
	elif direction == Constants.Timer_Table.DIRECTION.RIGHT:
		$TimerBottom.hide()
		$TimerRight.show()
		$TimerOpposite.hide()
		$TimerLeft.hide()
	elif direction == Constants.Timer_Table.DIRECTION.OPPOSITE:
		$TimerBottom.hide()
		$TimerRight.hide()
		$TimerOpposite.show()
		$TimerLeft.hide()
	elif direction == Constants.Timer_Table.DIRECTION.LEFT:
		$TimerBottom.hide()
		$TimerRight.hide()
		$TimerOpposite.hide()
		$TimerLeft.show()
	elif direction == Constants.Timer_Table.DIRECTION.BOTTOM:
		$TimerBottom.show()
		$TimerRight.hide()
		$TimerOpposite.hide()
		$TimerLeft.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
