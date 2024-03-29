extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var suit
var number
var is_selected = false

signal clicked
signal hover


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.rect_size = self.get_rect().size
	$Control.connect("mouse_entered", self, "mouse_enter_handler")
	$Control.connect("mouse_exited", self, "mouse_exit_handler")

	
# note: number starts from 1
func set_tile_type(suit, number):
	self.suit = suit
	self.number = number
	frame_coords = Vector2(number-1, suit)

func _input(event):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and  event.pressed :
		if get_rect().has_point(to_local(event.position)):
			emit_signal("clicked", self.suit, self.number)
			get_tree().set_input_as_handled()

func mouse_enter_handler():
	is_selected = true
	position = Vector2(position.x, position.y-Constants.Tile.SELECT_HEIGHT)

	
func mouse_exit_handler():
	is_selected = false
	position = Vector2(position.x, position.y+Constants.Tile.SELECT_HEIGHT)


		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
