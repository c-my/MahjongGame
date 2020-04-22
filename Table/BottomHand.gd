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

func show_tiles(show_new_tile=false, new_tile_in_hand=false, new_tile_suit=-1, new_tile_number=0):
	var tiles = get_children()
	var length = tiles.size()*Constants.Tile.WIDTH
	var y = Constants.Screen.HEIGHT - Constants.Table.BOTTOM_HAND_MARGIN_Y - Constants.Tile.HEIGHT
	var x = (Constants.Screen.WIDTH - Constants.Table.BOTTOM_LIE_WIDTH - length)/2.0

	var new_tile_index = -1

	var left_size = tiles.size()
	if not new_tile_in_hand:
		left_size -= 1
	set_position(Vector2(x, y))
	var pos_x = 0
	for i in range(left_size):
		if (show_new_tile and new_tile_in_hand and new_tile_suit!=-1 and 
			tiles[i].suit==new_tile_suit and tiles[i].number==new_tile_number
		):
			show_new_tile = false
			new_tile_index = i
			continue
		else:
			if not tiles[i].is_selected:
				tiles[i].position = Vector2(pos_x, 0)
			else:
				tiles[i].position = Vector2(pos_x, -Constants.Tile.SELECT_HEIGHT)
			pos_x += Constants.Tile.WIDTH

	# 新抓的牌
	pos_x += Constants.Tile.WIDTH/2
	if new_tile_index!=-1:
		var new_tile = tiles[new_tile_index]
		if not new_tile.is_selected:
			new_tile.position = Vector2(pos_x, 0)
		else:
			new_tile.position = Vector2(pos_x, -Constants.Tile.SELECT_HEIGHT)
	# 别人打的牌
	if show_new_tile and not new_tile_in_hand:
		var new_tile = tiles[left_size]
		if not new_tile.is_selected:
			new_tile.position = Vector2(pos_x, 0)
		else:
			new_tile.position = Vector2(pos_x, -Constants.Tile.SELECT_HEIGHT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
