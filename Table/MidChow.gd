extends Node2D


var texture = load("res://Asset/Tile/HandinTilesSheet.png")
signal pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
func show_tiles(suit, number):
	clear_tiles()
	for i in range(3):
		var t = get_tile_instance(suit, number+i-1)
		add_child(t)
		t.position = Vector2(i*Constants.Tile.CHOW_WIDTH, 0)
	show()
	

func get_tile_instance(suit, number):
	var tile = Sprite.new()
	tile.texture = texture
	tile.centered = false
	tile.vframes = 5
	tile.hframes = 9
	tile.frame_coords = Vector2(number-1, suit)
	return tile


func clear_tiles():
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
func _input(event):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		if Rect2(0,0,Constants.Tile.CHOW_WIDTH*3, Constants.Tile.HEIGHT).has_point(to_local(event.position)):
			emit_signal("pressed")
			get_tree().set_input_as_handled()
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
