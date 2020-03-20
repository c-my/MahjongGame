extends Node2D

var sep = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func show_panel(suit, number, types):
	if len(types)==1:
		hide()
	hide_all()
	for t in types:
		if t == Message.chow_type.LEFT:
			$LeftChow.show_tiles(suit, number)
		elif t == Message.chow_type.MID:
			$MidChow.show_tiles(suit, number)
		elif t == Message.chow_type.RIGHT:
			$RightChow.show_tiles(suit, number)
	var pos = 0
	for child in get_children():
		if child.visible:
			child.position = Vector2(pos, 0)
			pos += sep+3*Constants.Tile.CHOW_WIDTH
			
func hide_all():
	$LeftChow.hide()
	$MidChow.hide()
	$RightChow.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
