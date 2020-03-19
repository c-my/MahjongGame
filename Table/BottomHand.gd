extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var new_tile_suit = 0
var new_tile_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func add_tile_by_instance(tile):
	add_child(tile)
#	show_tiles()
	
func remove_tile_by_instance(tile):
	remove_child(tile)
#	show_tiles()
	
func clear_tiles():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
func set_new_tile(suit, number):
	new_tile_suit = suit
	new_tile_number = number

func show_tiles():
	var tiles = get_children()
	var length = tiles.size()*Constants.Tile.WIDTH
	var y = Constants.Screen.HEIGHT - Constants.Table.BOTTOM_HAND_MARGIN_Y - Constants.Tile.HEIGHT
	var x = (Constants.Screen.WIDTH - Constants.Table.BOTTOM_LIE_WIDTH - length)/2.0
	var new_tile_flag = true
	var new_tile_index = -1

	set_position(Vector2(x, y))
	for i in range(tiles.size()):
#		if new_tile_flag and new_tile_number!=0 and tiles[i].suit==new_tile_number and tiles[i].number==new_tile_number:
#			new_tile_flag = false
#			new_tile_index = i
#			continue
		if not tiles[i].is_selected:
			tiles[i].position = Vector2(i*Constants.Tile.WIDTH, 0)
		else:
			tiles[i].position = Vector2(i*Constants.Tile.WIDTH, -Constants.Tile.SELECT_HEIGHT)

#	if new_tile_index!=-1:
#		var new_tile = tiles[new_tile_index]
#		if not tiles[new_tile_index].is_selected:
#			new_tile.position = Vector2((length+1)*Constants.Tile.WIDTH, 0)
#		else:
#			new_tile.position = Vector2((length+1), -Constants.Tile.SELECT_HEIGHT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
