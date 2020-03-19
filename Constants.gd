extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Tile:
	enum Suit {Character, Bamboo, Dot, Wind, Dragon, Flower, Season}
	const HEIGHT = 118
	const WIDTH = 76
	const SELECT_HEIGHT = 30
	
	const OPPOSITE_HAND_WIDTH = 79
	const OPPOSITE_DROP_WIDTH = 76
	const OPPOSITE_DROP_HEIGHT = 118
	
	const SIDE_SCALE = 0.6
	const SIDE_HAND_WIDTH = 50
	const SIDE_HAND_THICK = 50
	const SIDE_HAND_DIFF = 0
	const SIDE_DROP_WIDTH = 120*SIDE_SCALE
	const SIDE_DROP_HEIGHT = 114*SIDE_SCALE
	const SIDE_DROP_THICK = 36*SIDE_SCALE
	const SIDE_DROP_DIFF = 0
	const SIDE_SHOWN_SEP = 40
	
	const BOTTOM_DROP_WIDTH = 76
	const BOTTOM_DROP_HEIGHT = 118
	const BOTTOM_DROP_THICK = 32
	const BOTTOM_SHOWN_SEP = 20
	
class Screen:
	const WIDTH = 1920
	const HEIGHT = 1080
	
class Table:
	const BOTTOM_LIE_WIDTH = 40
	const BOTTOM_HAND_MARGIN_X = 10
	const BOTTOM_HAND_MARGIN_Y = 20
	const BOTTOM_SHOWN_MARGIN_X = 50
	const BOTTOM_SHOWN_MARGIN_Y = 70
	
	const OPPO_HAND_MARGIN_Y = 100
	
	const SIDE_HAND_MARGIN = 60
	const SIDE_SHOWN_MARGIN_X = SIDE_HAND_MARGIN + 50 + 30
	const SIDE_SHOWN_MARGIN_Y = 50
	
class Timer_Table:
	enum DIRECTION {NONE, BOTTOM, RIGHT, OPPOSITE, LEFT}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
