extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

enum msg_type{GAME_MSG, TABLE_ORDER_MSG, GAME_RESULT_MSG, GET_READY_MSG, CHAT_MSG, JOIN_MSG}

enum player_action{START,DEAL, CHOW,PONG, EXPOSED_KONG, CONCEALED_KONG, ADDED_KONG, WIN, CANCEL, DISCARD, DRAW, READY}

enum chow_type{LEFT, MID, RIGHT, NAC}

enum gender{FEMALE, MALE}

enum join_err{WRONG_PASSWORD=-3, NO_SEAT, NO_SUCH_ROOM}

var game_msg_dict = {
	"msg_type":msg_type.GAME_MSG,
	"table_order":0,
	"action":player_action.START,
	"tile":{"suit":0,"number":0},
	"chow_type":chow_type.NAC,
}

var chat_msg_dict = {
	"msg_type":msg_type.CHAT_MSG,
	"from": 0,
	"content": "",
}
