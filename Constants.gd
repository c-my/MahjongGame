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
	
	const SIDE_HAND_WIDTH = 26
	const SIDE_HAND_DIFF = 4
	
	const BOTTOM_DROP_WIDTH = 29
	const BOTTOM_DROP_HEIGHT = 43
	
class Screen:
	const WIDTH = 1920
	const HEIGHT = 1080
	
class Table:
	const BOTTOM_LIE_WIDTH = 40
	const BOTTOM_HAND_MARGIN_X = 10
	const BOTTOM_HAND_MARGIN_Y = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
