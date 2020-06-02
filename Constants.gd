extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class Tile:
	enum Suit {Character, Bamboo, Dot, Wind, Dragon, Flower, Season}
	const BOTTOM_HAND_SCALE = 1.5
	const HEIGHT = 118*BOTTOM_HAND_SCALE
	const WIDTH = 76*BOTTOM_HAND_SCALE
	const SELECT_HEIGHT = 30
	const CHOW_SCALE = 1.3
	const CHOW_WIDTH = 76*CHOW_SCALE
	const CHOW_HEIGHT = 118*CHOW_SCALE
	
	const OPPOSITE_HAND_WIDTH = 79
	const OPPOSITE_HAND_HEIGHT = 120
	const OPPOSITE_DROP_WIDTH = 76
	const OPPOSITE_DROP_HEIGHT = 118
	const OPPOSITE_DROP_THICK = 32
	
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
	const BOTTOM_DROP_MARGIN_X = 400
	const BOTTOM_DROP_COUNT_MAX = 14
	const BOTTOM_SHOWN_SEP = 20
	
	const RESULT_SCALE = 0.7
	const RESULT_HEIGHT = 120
	const RESULT_HAND_HEIGHT = 118*RESULT_SCALE
	const RESULT_HAND_WIDTH = 76*RESULT_SCALE
	const RESULT_SHOWN_HEIGHT = BOTTOM_DROP_HEIGHT*RESULT_SCALE
	const RESULT_SHOWN_WIDTH = BOTTOM_DROP_WIDTH*RESULT_SCALE
	const RESULT_VERTICALL_GAP = 30
	const RESULT_LEFT_MARGIN = 40
	
	
class Screen:
	const WIDTH = 1920
	const HEIGHT = 1080
	
class Table:
	const BOTTOM_LIE_WIDTH = 40
	const BOTTOM_HAND_MARGIN_X = 10
	const BOTTOM_HAND_MARGIN_Y = 20
	const BOTTOM_SHOWN_MARGIN_X = 50
	const BOTTOM_SHOWN_MARGIN_Y = 70
	
	const OPPO_HAND_MARGIN_Y = 120
	
	const SIDE_HAND_MARGIN = 80
	const SIDE_SHOWN_MARGIN_X = SIDE_HAND_MARGIN + 50 + 30
	const SIDE_SHOWN_MARGIN_Y = 150
	const SIDE_DROP_MARGIN_X = SIDE_SHOWN_MARGIN_X + 50
	
class Timer_Table:
	enum DIRECTION {NONE, BOTTOM, RIGHT, OPPOSITE, LEFT}
	
class Chow_Panel:
	const SEPARATION = 30
	const MARGIN_BOTTOM = 350
	
class HTTP:
#	const BASE_URL = "http://127.0.0.1"
	const BASE_URL = "https://mj.caimingyang.cn"
#	const PORT = "1114"
	const PORT = "443"
	const ROOM_URL = BASE_URL+":"+PORT+"/room/"
	const LOGIN_URL = BASE_URL+":"+PORT+"/login/"
	const REGISTER_URL = BASE_URL+":"+PORT+"/register/"
	
	const RELEASE_BASE_URL = "https://mj.caimingyang.cn"
	const RELEASE_PORT = "443"
	const RELEASE_ROOM_URL = RELEASE_BASE_URL+":"+RELEASE_PORT+"/room/"

class WebSockt:
#	const BASE_URL = "ws://127.0.0.1"
	const BASE_URL = "wss://mj.caimingyang.cn"
#	const BASE_PORT = "1114"
	const BASE_PORT = "443"
	const URL = BASE_URL+":"+BASE_PORT
	
	const RELEASE_BASE_URL = "wss://mj.caimingyang.cn"
	const RELEASE_BASE_PORT = "443"
	const RELEASE_URL = RELEASE_BASE_URL+":"+RELEASE_BASE_PORT
	
enum rule{JinzhouGameRule, ShenyangGameRule}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
