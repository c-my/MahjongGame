extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Tile = preload("res://Tile.tscn")
var is_my_turn = false
var my_table_order = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnManager.connect("deal_tiles", self, "deal_tile")
	# center the timer	
	pass # Replace with function body.


func tile_click_handler(tile):
	if not is_my_turn:
		return
	$BottomHand.remove_tile_by_instance(tile)
	# TODO:send websocket msg
	
func deal_tile(msg):
	var tiles = msg["current_tile"]
	for i in range(tiles.size()):

		var t = Tile.instance()
		t.set_tile_type(tiles[i]["suit"], tiles[i]["number"])
		$BottomHand.add_tile_by_instance(t)
		pass
	var tiles_count = msg["tiles_count"]
	$RightHand.show_tiles(tiles_count[(my_table_order+1)%4])
	$OppositeHand.show_tiles(tiles_count[(my_table_order+2)%4])
	$LeftHand.show_tiles(tiles_count[(my_table_order+3)%4])	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var tile = Tile.instance()
	tile.set_tile_type(randi()%3, randi()%9)
	$BottomHand.add_tile_by_instance(tile)


func _on_Button2_pressed():
	$OppositeHand.show_tiles(randi()%13)


func _on_Button3_pressed():
	$LeftHand.show_tiles(randi()%13)


func _on_Button4_pressed():
	$RightHand.show_tiles(randi()%13)


func _on_Button5_pressed():
	$BottomDropArea.add_tile(randi()%3, randi()%9)
	pass # Replace with function body.


func _on_Button6_pressed():
	$OppositeDropArea.add_tile(randi()%3, randi()%9)


func _on_Button7_pressed():
	$RightDropArea.add_tile(randi()%3, randi()%9)


func _on_Button8_pressed():
	$LeftDropArea.add_tile(randi()%3, randi()%9)
	pass # Replace with function body.


func _on_Button9_pressed():
	ConnManager.send_message($HBoxContainer/TextEdit.text)
	
