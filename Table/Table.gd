extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Tile = preload("res://Tile.tscn")
var is_my_turn = false
var has_actions = false #用于控制能否发牌
var my_table_order = 0
var current_msg
var current_kong_type = Message.player_action.EXPOSED_KONG


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	ConnManager.connect("recv_game_msg", self, "handle_game_msg")
	
	$PlayerAction/Chow.connect("pressed", self, "handle_chow")
	$PlayerAction/Pong.connect("pressed", self, "handle_pong")
	$PlayerAction/Kong.connect("pressed", self, "handle_kong")


	
func handle_game_msg(msg):
	set_hand_areas(msg)
	set_drop_areas(msg)
	set_shown_areas(msg)
	set_timer_direction(msg)
	set_turn(msg)
	set_player_action(msg)
	current_msg = msg
	# 处理逻辑
	
func handle_chow():
	pass
	
func handle_pong():
	print_debug("handle pong")
	if current_msg == null:
		print_debug("current msg is null")
		return
	ConnManager.send_pong(current_msg["current_tile"], my_table_order)
	
func handle_kong():
	if current_msg == null:
		return
	if current_kong_type == Message.player_action.EXPOSED_KONG:
		ConnManager.send_exposedkong(current_msg["current_tile"], my_table_order)
	elif current_kong_type == Message.player_action.CONCEALED_KONG:
		pass
	elif current_kong_type == Message.player_action.ADDED_KONG:
		pass
			
		

func set_hand_areas(msg):
	var tiles_count = msg["player_tile"]
	$RightHand.show_tiles(tiles_count[(my_table_order+1)%4]["hand_tiles"].size())
	$OppositeHand.show_tiles(tiles_count[(my_table_order+2)%4]["hand_tiles"].size())
	$LeftHand.show_tiles(tiles_count[(my_table_order+3)%4]["hand_tiles"].size())
	
	var my_tiles = msg["player_tile"][my_table_order]["hand_tiles"]
	$BottomHand.clear_tiles()
	for i in range(my_tiles.size()):
		var t = Tile.instance()
		t.set_tile_type(my_tiles[i]["suit"], my_tiles[i]["number"])
		t.connect("clicked", self, "handle_tile_click")
		$BottomHand.add_tile_by_instance(t)
	$BottomHand.show_tiles()
	
func set_drop_areas(msg):
	var bottom_drop_tiles = msg["player_tile"][my_table_order]["drop_tiles"]
	$BottomDropArea.clear_tiles()
	if bottom_drop_tiles!=null:
		for t in bottom_drop_tiles:
			$BottomDropArea.add_tile(t["suit"], t["number"])
	var right_drop_tiles = msg["player_tile"][(my_table_order+1)%4]["drop_tiles"]
	$RightDropArea.clear_tiles()
	if right_drop_tiles!=null:
		for t in right_drop_tiles:
			$RightDropArea.add_tile(t["suit"], t["number"])
	var oppo_drop_tiles = msg["player_tile"][(my_table_order+2)%4]["drop_tiles"]
	$OppositeDropArea.clear_tiles()
	if oppo_drop_tiles!=null:
		for t in oppo_drop_tiles:
			$OppositeDropArea.add_tile(t["suit"], t["number"])
	var left_drop_tiles = msg["player_tile"][(my_table_order+3)%4]["drop_tiles"] 
	$LeftDropArea.clear_tiles()
	if left_drop_tiles!=null:
		for t in left_drop_tiles:
			$LeftDropArea.add_tile(t["suit"], t["number"])
		
func set_timer_direction(msg):
	var current_turn = msg["current_turn"]
	var direction
	if current_turn==my_table_order%4:
		direction = Constants.Timer_Table.DIRECTION.BOTTOM
	elif  current_turn==(my_table_order+1)%4:
		direction = Constants.Timer_Table.DIRECTION.RIGHT
	elif  current_turn==(my_table_order+2)%4:
		direction = Constants.Timer_Table.DIRECTION.OPPOSITE		
	elif  current_turn==(my_table_order+3)%4:
		direction = Constants.Timer_Table.DIRECTION.LEFT
	$Timer.show_timer(direction)
	
func set_turn(msg):
	if msg["current_turn"]==my_table_order:
		is_my_turn = true
	else:
		is_my_turn = false
	
func set_player_action(msg):
	var acts = [false,false,false,false,true]
	if msg["current_turn"]!=my_table_order:
		$PlayerAction.show_actions(acts)
		return	
	var actions = msg["available_actions"]
	if actions != null:
		for action in actions:
			if action==Message.player_action.CHOW:
				acts[0]=true
			elif action==Message.player_action.PONG:
				acts[1]=true
			elif action==Message.player_action.CONCEALED_KONG or action==Message.player_action.EXPOSED_KONG or action==Message.player_action.ADDED_KONG:
				current_kong_type = action
				acts[2]=true
			elif action==Message.player_action.WIN:
				acts[3]=true
	has_actions = $PlayerAction.show_actions(acts)
	
	
func set_shown_areas(msg):
	var tiles = msg["player_tile"]
	if tiles == null:
		return
	var bottom_shown = tiles[my_table_order]["shown_tiles"]
	if bottom_shown != null:
		$BottomShown.show_tiles(bottom_shown)
	var right_shown = tiles[(my_table_order+1)%4]["shown_tiles"]
	if right_shown != null:
		$RightShown.show_tiles(right_shown)
	var oppo_shown = tiles[(my_table_order+2)%4]["shown_tiles"]
	if oppo_shown != null:
		$OppoShown.show_tiles(oppo_shown)
	var left_shown = tiles[(my_table_order+3)%4]["shown_tiles"]
	if left_shown != null:
		$LeftShown.show_tiles(left_shown)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_tile_click(suit, number):
	if (not is_my_turn):
		return
	if has_actions:
		return
	ConnManager.send_discard({"suit":suit, "number": number}, my_table_order)
	


func _on_Button_pressed():
	var tile = Tile.instance()
	tile.set_tile_type(randi()%3, randi()%9)
	$BottomHand.add_tile_by_instance(tile)
	$BottomHand.show_tiles()


func _on_Button2_pressed():
	$OppositeHand.show_tiles(randi()%13)


func _on_Button3_pressed():
	$LeftHand.show_tiles(randi()%13)


func _on_Button4_pressed():
	my_table_order = 0


func _on_Button5_pressed():
	my_table_order = 1


func _on_Button6_pressed():
	my_table_order = 2


func _on_Button7_pressed():
	my_table_order = 3


func _on_Button8_pressed():
	ConnManager.connect_ws()


func _on_Button9_pressed():
	ConnManager.send_start()
	


func _on_righthand_pressed():
	$RightHand.show_tiles(randi()%13)


func _on_bottomdrop_pressed():
	$BottomDropArea.add_tile(randi()%3, randi()%9)
	$BottomDropArea.show_tiles()


func _on_leftdrop_pressed():
	$LeftDropArea.add_tile(randi()%3, randi()%9)
	$LeftDropArea.show_tiles()


func _on_rightdrop_pressed():
	$RightDropArea.add_tile(randi()%3, randi()%9)
	$RightDropArea.show_tiles()


func _on_oppodrop_pressed():
	$RightDropArea.clear_tiles();
	$OppositeDropArea.add_tile(randi()%3, randi()%9)
	$OppositeDropArea.show_tiles()


func _on_bottomshown_pressed():
	var json_tmp = JSON.parse("""[
	{
		"shown_type":2,
		"tiles":[
			{"suit":0,"number":1},
			{"suit":0,"number":2},
			{"suit":0,"number":3}
		]
	},
   {
		"shown_type":5,
		"tiles":[
			{"suit":2,"number":3},
			{"suit":2,"number":3},
			{"suit":2,"number":3},
			{"suit":2,"number":3}
		]
	},
   {
		"shown_type":4,
		"tiles":[
			{"suit":1,"number":7},
			{"suit":1,"number":7},
			{"suit":1,"number":7},
			{"suit":1,"number":7}
		]
	},
   {
		"shown_type":6,
		"tiles":[
			{"suit":4,"number":1},
			{"suit":4,"number":1},
			{"suit":4,"number":1},
			{"suit":4,"number":1}
		]
	}
]""")
	$BottomShown.show_tiles(json_tmp.result)
	$OppoShown.show_tiles(json_tmp.result)
	$LeftShown.show_tiles(json_tmp.result)
	$RightShown.show_tiles(json_tmp.result)
