extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Tile:
	enum Suit {Character, Bamboo, Dot, Bonus, Wind, Dragon, Flower, Season}
	const HEIGHT = 142
	const WIDTH = 90
	const SELECT_HEIGHT = 30
	
	const OPPOSITE_HAND_WIDTH = 38
	const OPPOSITE_DROP_WIDTH = 26
	const OPPOSITE_DROP_HEIGHT = 40
	
	const SIDE_HAND_WIDTH = 26
	const SIDE_HAND_DIFF = 4
	const SIDE_DROP_WIDTH = 37
	const SIDE_DROP_HEIGHT = 32
	const SIDE_DROP_THICK = 9
	const SIDE_DROP_DIFF = 2
	
	const BOTTOM_DROP_WIDTH = 29
	const BOTTOM_DROP_HEIGHT = 43
	
class Screen:
	const WIDTH = 1920
	const HEIGHT = 1080
	
class Table:
	const BOTTOM_LIE_WIDTH = 40
	const BOTTOM_HAND_MARGIN_X = 10
	const BOTTOM_HAND_MARGIN_Y = 20
	
class Timer_Table:
	enum DIRECTION {NONE, BOTTOM, RIGHT, OPPOSITE, LEFT}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
