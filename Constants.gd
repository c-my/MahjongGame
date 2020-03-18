extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Tile:
	enum Suit {Character, Bamboo, Dot, Wind, Dragon, Flower, Season}
	const HEIGHT = 118
	const WIDTH = 76
	const SELECT_HEIGHT = 30
	
	const OPPOSITE_HAND_WIDTH = 38
	const OPPOSITE_DROP_WIDTH = 76
	const OPPOSITE_DROP_HEIGHT = 118
	
	const SIDE_HAND_WIDTH = 26
	const SIDE_HAND_DIFF = 4
	const SIDE_DROP_WIDTH = 120
	const SIDE_DROP_HEIGHT = 114
	const SIDE_DROP_THICK = 9
	const SIDE_DROP_DIFF = 2
	
	const BOTTOM_DROP_WIDTH = 76
	const BOTTOM_DROP_HEIGHT = 118
	
class Screen:
	const WIDTH = 1920
	const HEIGHT = 1080
	
class Table:
	const BOTTOM_LIE_WIDTH = 40
	const BOTTOM_HAND_MARGIN_X = 10
	const BOTTOM_HAND_MARGIN_Y = 20
	
	const OPPO_HAND_MARGIN_Y = 100
	
class Timer_Table:
	enum DIRECTION {NONE, BOTTOM, RIGHT, OPPOSITE, LEFT}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
