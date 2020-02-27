extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_tile_by_instance(tile):
	tiles.append(tile)
	add_child(tile)
	show_tiles()

func show_tiles():
	var length = tiles.size()*Constants.Tile.WIDTH
	var y = Constants.Screen.HEIGHT - Constants.Table.BOTTOM_HAND_MARGIN_Y - Constants.Tile.HEIGHT
	var x = (Constants.Screen.WIDTH - Constants.Table.BOTTOM_LIE_WIDTH - length)/2.0
	print_debug(x,", ",y)
	set_position(Vector2(x, y))
	for i in range(tiles.size()):
		if not tiles[i].is_selected:
			tiles[i].position = Vector2(i*Constants.Tile.WIDTH, 0)
		else:
			tiles[i].position = Vector2(i*Constants.Tile.WIDTH, -Constants.Tile.SELECT_HEIGHT)
	print_debug("show_tiles")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
