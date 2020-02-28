extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Tile = preload("res://Tile.tscn")
var is_my_turn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# center the timer	
	pass # Replace with function body.


func tile_click_handler(tile):
	if not is_my_turn:
		return
	$BottomHand.remove_tile_by_instance(tile)
	# TODO:send websocket msg

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
