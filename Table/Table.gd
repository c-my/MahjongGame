extends Node2D


var Tile = preload("res://Tile.tscn")
var is_my_turn = false
var has_actions = false #用于控制能否发牌
var my_table_order = 0
var my_user_order = 0
var my_gender = 0
var current_msg
var current_kong_type = Message.player_action.EXPOSED_KONG
var just_clicked = false
var is_mute = false


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnManager.connect("recv_game_msg", self, "handle_game_msg")
	ConnManager.connect("recv_table_order_msg", self, "handle_table_order_msg")
	ConnManager.connect("recv_game_result_msg", self, "handle_game_result_msg")
	ConnManager.connect("recv_get_ready_msg", self, "handle_get_ready_msg")
	ConnManager.connect("recv_user_order_msg", self, "handle_user_id_msg")
	
	$ReadyButton.connect("pressed", self, "handle_ready_pressed")

	
	$PlayerAction/Chow.connect("pressed", self, "handle_chow")
	$PlayerAction/Pong.connect("pressed", self, "handle_pong")
	$PlayerAction/Kong.connect("pressed", self, "handle_kong")
	$PlayerAction/Cancel.connect("pressed", self, "handle_cancel")
	$PlayerAction/Win.connect("pressed", self, "handle_win")
	
	$ChowPanel/LeftChow.connect("pressed", self, "handle_left_chow")
	$ChowPanel/MidChow.connect("pressed", self, "handle_mid_chow")
	$ChowPanel/RightChow.connect("pressed", self, "handle_right_chow")


	
func handle_game_msg(msg):
	my_gender = msg["user_list"][my_table_order]["gender"]
	set_hand_areas(msg)
	set_drop_areas(msg)
	set_shown_areas(msg)
	set_timer_direction(msg)
	set_turn(msg)
	set_player_action(msg)
	set_chow_panel()
	set_action_audio(msg)
	current_msg = msg
	just_clicked = false
	
func handle_table_order_msg(msg):
	my_table_order = int(msg["table_order"])
	print_debug("set table order: ", my_table_order)
	
func handle_game_result_msg(msg):
	var winner = msg["winner"]
	print_debug("winner: ", winner)
	
func handle_get_ready_msg(msg):
	# TODO: show ready state
	pass
	
func handle_user_id_msg(msg):
	my_user_order = msg["user_order"]
	
func handle_ready_pressed():
	print_debug("ready pressed")
	ConnManager.send_ready(my_table_order)
	
	
func handle_chow():
	if current_msg == null:
		return
	var chow_types = current_msg["chow_types"]
	if chow_types == null:
		return
	if chow_types.size()==1:
		play_action_audio(Message.player_action.CHOW, my_gender)
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
	play_action_audio(Message.player_action.CHOW, my_gender)
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.LEFT)
	
func handle_mid_chow():
	if current_msg == null:
		return
	var suit = current_msg["current_tile"]["suit"]
	var number = current_msg["current_tile"]["number"]
	play_action_audio(Message.player_action.CHOW, my_gender)
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.MID)
	
func handle_right_chow():
	if current_msg == null:
		return
	var suit = current_msg["current_tile"]["suit"]
	var number = current_msg["current_tile"]["number"]
	play_action_audio(Message.player_action.CHOW, my_gender)
	ConnManager.send_chow({"suit":suit,"number":number}, my_table_order ,Message.chow_type.RIGHT)
		
func handle_pong():
	print_debug("handle pong")
	if current_msg == null:
		print_debug("current msg is null")
		return
	play_action_audio(Message.player_action.PONG, my_gender)
	ConnManager.send_pong(current_msg["current_tile"], my_table_order)
	
func handle_kong():
	if current_msg == null:
		return
	if current_kong_type == Message.player_action.EXPOSED_KONG:
		play_action_audio(current_kong_type, my_gender)
		ConnManager.send_exposedkong(current_msg["current_tile"], my_table_order)
	elif current_kong_type == Message.player_action.CONCEALED_KONG:
		play_action_audio(current_kong_type, my_gender)		
		ConnManager.send_concealedkong(current_msg["current_tile"], my_table_order)
	elif current_kong_type == Message.player_action.ADDED_KONG:
		play_action_audio(current_kong_type, my_gender)		
		ConnManager.send_addedkong(current_msg["current_tile"], my_table_order)
		

func handle_win():
	if current_msg == null:
		return
	print_debug("send win")
	play_action_audio(Message.player_action.WIN, my_gender)	
	ConnManager.send_win(current_msg["current_tile"], my_table_order)

		
func handle_cancel():
	if current_msg == null:
		return
	print_debug("send cancel")
	ConnManager.send_cancel(my_table_order)
			
		

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
	var my_tiles_total = my_tiles.size()
	var kong_count = 0
	var my_shown = msg["player_tile"][my_table_order]["shown_tiles"]
	if my_shown != null:
		for shown in my_shown:
			if (shown["shown_type"]==Message.player_action.ADDED_KONG or
				shown["shown_type"]==Message.player_action.CONCEALED_KONG or
				shown["shown_type"]==Message.player_action.EXPOSED_KONG
			):
				kong_count+=1
				
			my_tiles_total += shown["tiles"].size()
	var new_tile_suit = msg["current_tile"]["suit"]
	var new_tile_number = msg["current_tile"]["number"]
	var new_tile_in_hand = false
	var show_new_tile = false
	if msg["current_turn"]==my_table_order:
		show_new_tile = true
	if show_new_tile:
		new_tile_in_hand = false
		if kong_count+14 == my_tiles_total:
			# 玩家抓了牌
			print_debug("new_tile_in_hand=true, my_tiles_total:", my_tiles_total,"kong_count:",kong_count)
			new_tile_in_hand = true
		else:
			print_debug("add new tile in hand")
			var t = Tile.instance()
			t.set_tile_type(new_tile_suit, new_tile_number)
			t.connect("clicked", self, "handle_tile_click")
			$BottomHand.add_tile_by_instance(t)
	$BottomHand.show_tiles(show_new_tile, new_tile_in_hand, new_tile_suit, new_tile_number)
	
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
	
func set_action_audio(msg):
	var last_turn = msg["last_turn"]
	var last_action = msg["last_action"]
	if last_turn < 0 or last_turn == my_table_order:
		return
	var gender = msg["user_list"][last_turn]["gender"]
	if last_action == Message.player_action.DISCARD:
		var last_tile = msg["last_tile"]
		play_discard_audio(last_tile["suit"], last_tile["number"], gender)
	else:
		play_action_audio(last_action, gender)
		
func handle_sound_button_clicked():
	var mute = $ControlButtons/SoundButton.pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Effect"), mute)
	
func handle_music_button_clicked():
	var mute = $ControlButtons/MusicButton.pressed
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), mute)      
	
	
		
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
		
	play_discard_audio(suit, number, my_gender)
	ConnManager.send_discard({"suit":suit, "number": number}, my_table_order)
	just_clicked = true
	

func play_discard_audio(suit, number, gender=Message.gender.MALE):
	var gender_string = "Male"
	if gender==Message.gender.FEMALE:
		gender_string = "Female"
	var audio_path = "res://Asset/Audio/Action/Discard/%s/%d%d.ogg" % [gender_string, suit, number]
	$ActionPlayer.stream = load(audio_path)
	$ActionPlayer.stream.set("loop", false)
	$ActionPlayer.play()
	
func play_action_audio(action, gender=Message.gender.MALE):
	var gender_string = "Male"
	if gender==Message.gender.FEMALE:
		gender_string = "Female"
	var action_string = ""
	if action == Message.player_action.CHOW:
		action_string = "Chow"
	elif action == Message.player_action.PONG:
		action_string = "Pong"
	elif action == Message.player_action.EXPOSED_KONG or action == Message.player_action.ADDED_KONG or action == Message.player_action.CONCEALED_KONG:
		action_string = "Kong"
	elif action == Message.player_action.WIN:
		action_string = "Win"
	else:
		return	
	var audio_path = "res://Asset/Audio/Action/PlayerAction/%s/%s.ogg" % [gender_string, action_string]
	$ActionPlayer.stream = load(audio_path)
	$ActionPlayer.stream.set("loop", false)
	$ActionPlayer.play()

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
