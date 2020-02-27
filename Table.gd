extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Tile = preload("res://Tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# center the timer	
	pass # Replace with function body.


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
