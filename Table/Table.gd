extends Node2D


var Tile = preload("res://Tile.tscn")
var is_my_turn = false
var has_actions = false #用于控制能否发牌
var my_table_order = 0
var current_msg
var current_kong_type = Message.player_action.EXPOSED_KONG
var just_clicked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnManager.connect("recv_game_msg", self, "handle_game_msg")
	ConnManager.connect("recv_table_order_msg", self, "handle_table_order_msg")
	
	$PlayerAction/Chow.connect("pressed", self, "handle_chow")
	$PlayerAction/Pong.connect("pressed", self, "handle_pong")
	$PlayerAction/Kong.connect("pressed", self, "handle_kong")
	
	$ChowPanel/LeftChow.connect("pressed", self, "handle_left_chow")
	$ChowPanel/MidChow.connect("pressed", self, "handle_mid_chow")
	$ChowPanel/RightChow.connect("pressed", self, "handle_right_chow")


	
func handle_game_msg(msg):
	set_hand_areas(msg)
	set_drop_areas(msg)
	set_shown_areas(msg)
	set_timer_direction(msg)
	set_turn(msg)
	set_player_action(msg)
	set_chow_panel()
	current_msg = msg
	just_clicked = false
	
func handle_table_order_msg(msg):
	my_table_order = msg["table_order"]
	print_debug("set table order: ", my_table_order)
	
	
func handle_chow():
	if current_msg == null:
		return
	var chow_types = current_msg["chow_types"]
	if chow_types == null:
		return
	if chow_types.size()==1:
		ConnManager.send_chow(current_msg["current_tile"], my_table_order,chow_types[0])
	else:	# show chow panel
		var suit = current_msg["current_tile"]["suit"]
		var number = current_msg["current_tile"]["number"]
		print_debug("show chow panel: ", suit, number,"types: ",chow_types)
		$ChowPanel.show_panel(suit, number, chow_types)

func handle_left_chow():
	if current_msg == null:
		return
	var suit = current_msg["current_tile"]["suit"]
	var number = current_msg["current_tile"]["number"]
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.LEFT)
	
func handle_mid_chow():
	if current_msg == null:
		return
	var suit = current_msg["current_tile"]["suit"]
	var number = current_msg["current_tile"]["number"]
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.MID)
	
func handle_right_chow():
	if current_msg == null:
		return
	var suit = current_msg["current_tile"]["suit"]
	var number = current_msg["current_tile"]["number"]
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.RIGHT)
		
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
		ConnManager.send_concealedkong(current_msg["current_tile"], my_table_order)
	elif current_kong_type == Message.player_action.ADDED_KONG:
		ConnManager.send_addedkong(current_msg["current_tile"], my_table_order)
			
		

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
		
func set_chow_panel():
	$ChowPanel.hide()	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_tile_click(suit, number):
	if (not is_my_turn):
		return
	if has_actions:
		return
	if just_clicked:
		return
	ConnManager.send_discard({"suit":suit, "number": number}, my_table_order)
	just_clicked = true
	

# DEBUG AREA
# following functions will be removed when release

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


func _on_Button9_pressed():
	ConnManager.send_start()
	


func _on_righthand_pressed():
	$RightHand.show_tiles(randi()%13)


func _on_bottomdrop_pressed():
	$BottomDropArea.add_tile(randi()%3, randi()%9+1)
	$BottomDropArea.show_tiles()


func _on_leftdrop_pressed():
	$LeftDropArea.add_tile(randi()%3, randi()%9+1)
	$LeftDropArea.show_tiles()


func _on_rightdrop_pressed():
	$RightDropArea.add_tile(randi()%3, randi()%9+1)
	$RightDropArea.show_tiles()


func _on_oppodrop_pressed():
	$RightDropArea.clear_tiles();
	$OppositeDropArea.add_tile(randi()%3, randi()%9+1)
	$OppositeDropArea.show_tiles()
	$ChowPanel.show_panel(0,6,[0,1,2])


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
